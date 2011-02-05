Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1BEOVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1BEOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fe3Pq4YGKO7DrlveVAUQffreHU8NWT1B5cxM6uAIn6brAmRzVuc1tyONySA9egl4EZ
         7h4gbO0XekrI6Y8ARno5sfJL77z+kIk4zS0v7AbgIzVYriz5wy9eIjP8Lexlpz0bEq7u
         z7v1ELZkx7FVceHqUZVBpbMh5E6WUrLHPyLpQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 09/52] kstrtox: convert fs/proc/
Date: Sat,  5 Feb 2011 16:20:12 +0200
Message-Id: <1296915654-7458-9-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/base.c           |   21 ++++++++++-----------
 fs/proc/task_mmu.c       |    8 +++++---
 include/linux/sched.h    |    2 +-
 kernel/sched_autogroup.c |   12 ++++++------
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..43c3941 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1005,7 +1005,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
-	long oom_adjust;
+	int oom_adjust;
 	unsigned long flags;
 	int err;
 
@@ -1017,8 +1017,8 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
-	if (err)
+	err = kstrtoint(strstrip(buffer), 0, &oom_adjust);
+	if (err < 0)
 		goto out;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
 	     oom_adjust != OOM_DISABLE) {
@@ -1114,7 +1114,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	unsigned long flags;
-	long oom_score_adj;
+	int oom_score_adj;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1125,8 +1125,8 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_score_adj);
-	if (err)
+	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
+	if (err < 0)
 		goto out;
 	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
 			oom_score_adj > OOM_SCORE_ADJ_MAX) {
@@ -1414,7 +1414,7 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct task_struct *p;
 	char buffer[PROC_NUMBUF];
-	long nice;
+	int nice;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1423,16 +1423,15 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
 
-	err = strict_strtol(strstrip(buffer), 0, &nice);
+	err = kstrtoint(strstrip(buffer), 0, &nice);
 	if (err)
-		return -EINVAL;
+		return err;
 
 	p = get_proc_task(inode);
 	if (!p)
 		return -ESRCH;
 
-	err = nice;
-	err = proc_sched_autogroup_set_nice(p, &err);
+	err = proc_sched_autogroup_set_nice(p, nice);
 	if (err)
 		count = err;
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 60b9148..b47c827 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -497,15 +497,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	long type;
+	int type;
+	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	if (strict_strtol(strstrip(buffer), 10, &type))
-		return -EINVAL;
+	rv = kstrtoint(strstrip(buffer), 10, &type);
+	if (rv < 0)
+		return rv;
 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
 		return -EINVAL;
 	task = get_proc_task(file->f_path.dentry->d_inode);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..762eb38 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1956,7 +1956,7 @@ extern void sched_autogroup_fork(struct signal_struct *sig);
 extern void sched_autogroup_exit(struct signal_struct *sig);
 #ifdef CONFIG_PROC_FS
 extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m);
-extern int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice);
+extern int proc_sched_autogroup_set_nice(struct task_struct *p, int nice);
 #endif
 #else
 static inline void sched_autogroup_create_attach(struct task_struct *p) { }
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 9fb6562..4b14c36 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -209,20 +209,20 @@ __setup("noautogroup", setup_autogroup);
 
 #ifdef CONFIG_PROC_FS
 
-int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
+int proc_sched_autogroup_set_nice(struct task_struct *p, int nice)
 {
 	static unsigned long next = INITIAL_JIFFIES;
 	struct autogroup *ag;
 	int err;
 
-	if (*nice < -20 || *nice > 19)
+	if (nice < -20 || nice > 19)
 		return -EINVAL;
 
-	err = security_task_setnice(current, *nice);
+	err = security_task_setnice(current, nice);
 	if (err)
 		return err;
 
-	if (*nice < 0 && !can_nice(current, *nice))
+	if (nice < 0 && !can_nice(current, nice))
 		return -EPERM;
 
 	/* this is a heavy operation taking global locks.. */
@@ -233,9 +233,9 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 	ag = autogroup_task_get(p);
 
 	down_write(&ag->lock);
-	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
+	err = sched_group_set_shares(ag->tg, prio_to_weight[nice + 20]);
 	if (!err)
-		ag->nice = *nice;
+		ag->nice = nice;
 	up_write(&ag->lock);
 
 	autogroup_kref_put(ag);
-- 
1.7.3.4

