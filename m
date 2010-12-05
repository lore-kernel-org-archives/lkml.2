Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0LER5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:57:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab0LERua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u+7tx/BHHUaSoJxyZyv5GCfonA5bfjSXU9iHVi4hxdjTahBaeed71/+JrjoNahcHu5
         +BKF1Q1gDQZh3LE2Zflmb9SKYrcUgeRkye1IoGzZQ1dHUwfBK/Cqq/mIpWaJA1pJ7LdZ
         VTLvDi5ggQ9W6HAqh/ARJH0yqDETh5AqJuwdw=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 09/45] kstrtox: convert fs/proc/
Date: Sun,  5 Dec 2010 19:49:06 +0200
Message-Id: <1291571382-2719-9-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/base.c     |   12 ++++++------
 fs/proc/task_mmu.c |    8 +++++---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..4469398 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1018,7 +1018,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
-	long oom_adjust;
+	int oom_adjust;
 	unsigned long flags;
 	int err;
 
@@ -1030,8 +1030,8 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
-	if (err)
+	err = kstrtoint(strstrip(buffer), 0, &oom_adjust);
+	if (err < 0)
 		goto out;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
 	     oom_adjust != OOM_DISABLE) {
@@ -1127,7 +1127,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	unsigned long flags;
-	long oom_score_adj;
+	int oom_score_adj;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1138,8 +1138,8 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_score_adj);
-	if (err)
+	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
+	if (err < 0)
 		goto out;
 	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
 			oom_score_adj > OOM_SCORE_ADJ_MAX) {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c126c83..d6cd94a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -493,15 +493,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
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
-- 
1.7.2.2

