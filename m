Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2AaM7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:59:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54814 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2AaM7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:59:52 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] proc: clean up /proc/<pid>/environ handling
Date: Tue, 31 Jan 2012 20:50:44 +0800
Message-Id: <1328014247-16461-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to commit e268337dfe26dfc7efd422a804dbb27977a3cccc
(proc: clean up and fix /proc/<pid>/mem handling), move the
check of permission to open(), this will simplify read() code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9cde9edf..3d30eb4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -835,28 +835,38 @@ static const struct file_operations proc_mem_operations = {
 	.release	= mem_release,
 };
 
+static int environ_open(struct inode *inode, struct file *file)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct mm_struct *mm;
+
+	if (!task)
+		return -ESRCH;
+
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (!mm)
+		return -ENOENT;
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+
+	file->private_data = mm;
+
+	return 0;
+}
+
 static ssize_t environ_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
 	char *page;
 	unsigned long src = *ppos;
-	int ret = -ESRCH;
-	struct mm_struct *mm;
-
-	if (!task)
-		goto out_no_task;
+	int ret = 0;
+	struct mm_struct *mm = file->private_data;
 
-	ret = -ENOMEM;
 	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
-		goto out;
-
-
-	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
-		goto out_free;
+		return -ENOMEM;
 
 	ret = 0;
 	while (count > 0) {
@@ -870,7 +880,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		this_len = (this_len > max_len) ? max_len : this_len;
 
-		retval = access_process_vm(task, (mm->env_start + src),
+		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
@@ -890,18 +900,23 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	}
 	*ppos = src;
 
-	mmput(mm);
-out_free:
 	free_page((unsigned long) page);
-out:
-	put_task_struct(task);
-out_no_task:
 	return ret;
 }
 
+static int environ_release(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm = file->private_data;
+
+	mmput(mm);
+	return 0;
+}
+
 static const struct file_operations proc_environ_operations = {
+	.open		= environ_open,
 	.read		= environ_read,
 	.llseek		= generic_file_llseek,
+	.release	= environ_release,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
