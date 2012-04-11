Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2DKGAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:00:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2DKGAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:00:32 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 1/6 v3] proc: clean up /proc/<pid>/environ handling
Date: Wed, 11 Apr 2012 13:59:22 +0800
Message-Id: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3: Unify environ_open with mem_open(), and mem_release() too
V2: Add similar fix with 6d08f2c7139790c268820a2e590795cb8333181a
"proc: make sure mem_open() doesn't pin the target's memory",
suggested by Oleg.

Similar to e268337dfe2 ("proc: clean up and fix /proc/<pid>/mem
handling"), move the check of permission to open(), this will simplify
read() code.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 fs/proc/base.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1c8b280..f3c4887 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -677,7 +677,7 @@ static const struct file_operations proc_single_file_operations = {
 	.release	= single_release,
 };
 
-static int mem_open(struct inode* inode, struct file* file)
+static int __mem_open(struct inode* inode, struct file* file, unsigned int mode)
 {
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	struct mm_struct *mm;
@@ -685,7 +685,7 @@ static int mem_open(struct inode* inode, struct file* file)
 	if (!task)
 		return -ESRCH;
 
-	mm = mm_access(task, PTRACE_MODE_ATTACH);
+	mm = mm_access(task, mode);
 	put_task_struct(task);
 
 	if (IS_ERR(mm))
@@ -705,6 +705,11 @@ static int mem_open(struct inode* inode, struct file* file)
 	return 0;
 }
 
+static int mem_open(struct inode* inode, struct file* file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
+}
+
 static ssize_t mem_rw(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos, int write)
 {
@@ -801,30 +806,29 @@ static const struct file_operations proc_mem_operations = {
 	.release	= mem_release,
 };
 
+static int environ_open(struct inode* inode, struct file* file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_READ);
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
+	int ret = 0;
+	struct mm_struct *mm = file->private_data;
 
-	if (!task)
-		goto out_no_task;
+	if (!mm)
+		return 0;
 
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
+	if (!atomic_inc_not_zero(&mm->mm_users))
+		goto free;
 	while (count > 0) {
 		int this_len, retval, max_len;
 
@@ -836,7 +840,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		this_len = (this_len > max_len) ? max_len : this_len;
 
-		retval = access_process_vm(task, (mm->env_start + src),
+		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
@@ -855,19 +859,18 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 		count -= retval;
 	}
 	*ppos = src;
-
 	mmput(mm);
-out_free:
+
+free:
 	free_page((unsigned long) page);
-out:
-	put_task_struct(task);
-out_no_task:
 	return ret;
 }
 
 static const struct file_operations proc_environ_operations = {
+	.open		= environ_open,
 	.read		= environ_read,
 	.llseek		= generic_file_llseek,
+	.release	= mem_release,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
-- 
1.7.7.6

