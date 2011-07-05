Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1GEMxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:53:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1GEMxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:53:51 -0400
Date: Tue, 5 Jul 2011 12:53:42 GMT
From: tip-bot for Peter Huewe <peterhuewe@gmx.de>
Message-ID: <tip-22fe9b54d859e53bfbbbdc1a0a77a82bc453927c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, peterhuewe@gmx.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, peterhuewe@gmx.de
In-Reply-To: <1307476707-14762-1-git-send-email-peterhuewe@gmx.de>
References: <1307476707-14762-1-git-send-email-peterhuewe@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert to kstrtoul_from_user
Git-Commit-ID: 22fe9b54d859e53bfbbbdc1a0a77a82bc453927c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:53:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22fe9b54d859e53bfbbbdc1a0a77a82bc453927c
Gitweb:     http://git.kernel.org/tip/22fe9b54d859e53bfbbbdc1a0a77a82bc453927c
Author:     Peter Huewe <peterhuewe@gmx.de>
AuthorDate: Tue, 7 Jun 2011 21:58:27 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:50 -0400

tracing: Convert to kstrtoul_from_user

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
