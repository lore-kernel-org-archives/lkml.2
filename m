Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2DCI2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:28:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46308 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2DCI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:28:50 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: [Patch v2] proc: clean up /proc/<pid>/environ handling
Date: Tue,  3 Apr 2012 16:28:13 +0800
Message-Id: <1333441703-8180-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20120328153936.495f567a.akpm@linux-foundation.org>
References: <20120328153936.495f567a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2: Add similar fix with 6d08f2c7139790c268820a2e590795cb8333181a
"proc: make sure mem_open() doesn't pin the target's memory",
suggested by Oleg.

Similar to e268337dfe2 ("proc: clean up and fix /proc/<pid>/mem
handling"), move the check of permission to open(), this will simplify
read() code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/base.c |   65 +++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1c8b280..b863ba3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -801,30 +801,50 @@ static const struct file_operations proc_mem_operations = {
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
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+
+	if (mm) {
+		/* ensure this mm_struct can't be freed */
+		atomic_inc(&mm->mm_count);
+		/* but do not pin its memory */
+		mmput(mm);
+	}
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
 
@@ -836,7 +856,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		this_len = (this_len > max_len) ? max_len : this_len;
 
-		retval = access_process_vm(task, (mm->env_start + src),
+		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
@@ -855,19 +875,26 @@ static ssize_t environ_read(struct file *file, char __user *buf,
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
 
+static int environ_release(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm = file->private_data;
+	if (mm)
+		mmdrop(mm);
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
