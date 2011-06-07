Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1FGT6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:58:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753546Ab1FGT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:58:36 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+OhGs6nNKOVFzTGgC1z0EdE9zpunspHVkELqS44k
	ntKhm7i6PIJGuG
From: Peter Huewe <peterhuewe@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] kernel/trace: Convert to kstrtoul_from_user
Date: Tue,  7 Jun 2011 21:58:27 +0200
Message-Id: <1307476707-14762-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an unsigned long from a
userspace buffer by a simple call to kstroul_from_user.
This makes it easier to read and less error prone.

Kernel Version: v3.0-rc2

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 kernel/trace/ftrace.c       |   13 +-------
 kernel/trace/ring_buffer.c  |   13 +-------
 kernel/trace/trace.c        |   65 ++++++------------------------------------
 kernel/trace/trace_events.c |   26 ++--------------
 kernel/trace/trace_stack.c  |   13 +-------
 5 files changed, 20 insertions(+), 110 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..508dcb4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -806,19 +806,10 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
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
index b0c7aa4..6c59dd9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3978,20 +3978,11 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
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
index ee9c921..2bdc019 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2701,20 +2701,11 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
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
@@ -2966,20 +2957,11 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
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
@@ -3434,19 +3416,10 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
 	unsigned long val;
-	char buf[64];
 	int ret, cpu;
 
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
@@ -4099,19 +4072,10 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
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
@@ -4159,20 +4123,11 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
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
1.7.3.4

