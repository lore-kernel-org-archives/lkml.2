Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660Ab2KICWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:22:01 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55251 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2KICV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:21:59 -0500
Message-ID: <509C68C1.3040501@gmail.com>
Date: Fri, 09 Nov 2012 10:21:53 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 7/9] trace: use this_cpu_ptr per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
v3:
  directly return member address of per-cpu variable.
---
 kernel/trace/blktrace.c |    2 +-
 kernel/trace/trace.c    |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..71259e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		return;
 
 	local_irq_save(flags);
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf = this_cpu_ptr(bt->msg_data);
 	va_start(args, fmt);
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..65cb003 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1495,7 +1495,6 @@ static struct trace_buffer_struct *trace_percpu_nmi_buffer;
 static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *percpu_buffer;
-	struct trace_buffer_struct *buffer;
 
 	/*
 	 * If we have allocated per cpu buffers, then we do not
@@ -1513,9 +1512,7 @@ static char *get_trace_buf(void)
 	if (!percpu_buffer)
 		return NULL;
 
-	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
-
-	return buffer->buffer;
+	return (char *)this_cpu_ptr(&percpu_buffer->buffer);
 }
 
 static int alloc_percpu_trace_buffer(void)
-- 
1.7.1
