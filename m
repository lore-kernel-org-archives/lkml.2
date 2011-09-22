Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1IVWKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:10:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1IVWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:37 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=BU0vCepEQBUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=bupWADxjYw37Z3BFzU4A:9 a=-bbjSTx2QM0tIGxriBEA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221029.879339397@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 20/21] tracing: Do not allocate buffer for trace_marker
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0020-tracing-Do-not-allocate-buffer-for-trace_marker.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When doing intense tracing, the kmalloc inside trace_marker can
introduce side effects to what is being traced. It is best to simply
use a static buffer and grab a mutex to write to it. This keeps
the impact of using the trace_marker() to a minimum.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4b8df0d..e463125 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1442,15 +1442,19 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 
 #endif /* CONFIG_STACKTRACE */
 
+static char trace_buf[TRACE_BUF_SIZE];
+static char trace_ubuf[TRACE_BUF_SIZE];
+
+static arch_spinlock_t trace_buf_lock =
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+static DEFINE_MUTEX(trace_ubuf_mutex);
+
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
  */
 int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock =
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-	static u32 trace_buf[TRACE_BUF_SIZE];
 
 	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
@@ -1480,7 +1484,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	/* Lockdep uses trace_printk for lock tracing */
 	local_irq_save(flags);
 	arch_spin_lock(&trace_buf_lock);
-	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vbin_printf((u32 *)trace_buf, TRACE_BUF_SIZE/sizeof(int), fmt, args);
 
 	if (len > TRACE_BUF_SIZE || len < 0)
 		goto out_unlock;
@@ -1532,9 +1536,6 @@ int trace_array_printk(struct trace_array *tr,
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock = __ARCH_SPIN_LOCK_UNLOCKED;
-	static char trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
@@ -3633,23 +3634,22 @@ static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
-	char *buf;
 	size_t written;
+	char *buf = trace_ubuf;
 
 	if (tracing_disabled)
 		return -EINVAL;
 
-	if (cnt > TRACE_BUF_SIZE)
-		cnt = TRACE_BUF_SIZE;
+	if (cnt >= TRACE_BUF_SIZE)
+		cnt = TRACE_BUF_SIZE - 2; /* \n\0 */
 
-	buf = kmalloc(cnt + 2, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
+	mutex_lock(&trace_ubuf_mutex);
 
 	if (copy_from_user(buf, ubuf, cnt)) {
-		kfree(buf);
-		return -EFAULT;
+		written = -EFAULT;
+		goto out;
 	}
+
 	if (buf[cnt-1] != '\n') {
 		buf[cnt] = '\n';
 		buf[cnt+1] = '\0';
@@ -3657,12 +3657,13 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 		buf[cnt] = '\0';
 
 	written = mark_printk("%s", buf);
-	kfree(buf);
 	*fpos += written;
 
 	/* don't tell userspace we wrote more - it might confuse them */
 	if (written > cnt)
 		written = cnt;
+ out:
+	mutex_unlock(&trace_ubuf_mutex);
 
 	return written;
 }
-- 
1.7.5.4


