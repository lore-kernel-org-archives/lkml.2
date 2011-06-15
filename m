Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1FONxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:53:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1FONwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:43 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Yil3cgBou_wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=mXFo69PVMRp-lK1vSngA:9 a=DHQQ7jDAcw4A:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135235.712598126@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 12/16 v2] tracing: Convert to kstrtoul_from_user
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Convert-to-kstrtoul_from_user.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch replaces the code for getting an unsigned long from a
userspace buffer by a simple call to kstroul_from_user.
This makes it easier to read and less error prone.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Link: http://lkml.kernel.org/r/1307476707-14762-1-git-send-email-peterhuewe@gmx.de
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c       |   13 +-------
 kernel/trace/ring_buffer.c  |   13 +-------
 kernel/trace/trace.c        |   65 ++++++------------------------------------
 kernel/trace/trace_events.c |   26 ++--------------
 kernel/trace/trace_stack.c  |   13 +-------
 5 files changed, 20 insertions(+), 110 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e153807..458018a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -803,19 +803,10 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
 	unsigned long val;
-	char buf[64];		/* big enough to hold a number */
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	val = !!val;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 725153d..f00ede3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3980,20 +3980,11 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	unsigned long *p = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	if (val)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cf22b4b..c977018 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2706,20 +2706,11 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	val = !!val;
@@ -3006,20 +2997,11 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
 	unsigned long *ptr = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	*ptr = val * 1000;
@@ -3474,19 +3456,10 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
 	unsigned long val;
-	char buf[64];
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	/* must have at least 1 entry */
@@ -4139,19 +4112,10 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 {
 	struct trace_option_dentry *topt = filp->private_data;
 	unsigned long val;
-	char buf[64];
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	if (val != 0 && val != 1)
@@ -4199,20 +4163,11 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			 loff_t *ppos)
 {
 	long index = (long)filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	if (val != 0 && val != 1)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 686ec39..4d7e149 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -486,20 +486,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	ret = tracing_update_buffers();
@@ -571,19 +562,10 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 {
 	const char *system = filp->private_data;
 	unsigned long val;
-	char buf[64];
 	ssize_t ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
 		return ret;
 
 	ret = tracing_update_buffers();
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index b0b53b8..77575b3 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -156,20 +156,11 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 {
 	long *ptr = filp->private_data;
 	unsigned long val, flags;
-	char buf[64];
 	int ret;
 	int cpu;
 
-	if (count >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, count))
-		return -EFAULT;
-
-	buf[count] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+	ret = kstrtoul_from_user(ubuf, count, 10, &val);
+	if (ret)
 		return ret;
 
 	local_irq_save(flags);
-- 
1.7.4.4


