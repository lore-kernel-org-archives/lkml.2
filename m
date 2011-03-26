Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1CZXGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 19:06:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50930 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1CZXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 19:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cbo1RZPxzI29kbr3BdgoV996Ac7732OqwCgF7pUyb2ZuF79yJ+P4pRKcFwjMvpllOY
         ynG9wS025trbeI/ANF2ilWKsQoHb+i1lAm+vJn985S6xq+WQuMnTleIF3uqXdQvLTzmR
         wh35ZQSMiBcAIG/tJqsymxU0+CzgXLRHyUkhA=
Date: Sun, 27 Mar 2011 01:06:16 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kstrtox: convert fs/proc/
Message-ID: <20110326230616.GA6802@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert fs/proc/ from strict_strto*() to kstrto*() functions.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c     |   16 ++++++++--------
 fs/proc/task_mmu.c |    8 +++++---
 2 files changed, 13 insertions(+), 11 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1059,7 +1059,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
-	long oom_adjust;
+	int oom_adjust;
 	unsigned long flags;
 	int err;
 
@@ -1071,7 +1071,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
+	err = kstrtoint(strstrip(buffer), 0, &oom_adjust);
 	if (err)
 		goto out;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
@@ -1168,7 +1168,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	unsigned long flags;
-	long oom_score_adj;
+	int oom_score_adj;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1179,7 +1179,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	err = strict_strtol(strstrip(buffer), 0, &oom_score_adj);
+	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
 	if (err)
 		goto out;
 	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
@@ -1468,7 +1468,7 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct task_struct *p;
 	char buffer[PROC_NUMBUF];
-	long nice;
+	int nice;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1477,9 +1477,9 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
 
-	err = strict_strtol(strstrip(buffer), 0, &nice);
-	if (err)
-		return -EINVAL;
+	err = kstrtoint(strstrip(buffer), 0, &nice);
+	if (err < 0)
+		return err;
 
 	p = get_proc_task(inode);
 	if (!p)
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -533,15 +533,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
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
