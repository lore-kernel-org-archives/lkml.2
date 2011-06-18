Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab1FRHNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 03:13:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58168 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1FRHN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 03:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tkm8Ydpmhors+Un1zvq7OhingVUGM2xhoudfgWweMVYQoXoEH4nfmpD+mmSQTtzxIW
         qDMcjNYBqRhGb7VoBPXM/s2bsJD4xskFKNMYAXQzo2muuX/DLOd12kf5haiCGY3HmnTV
         cDxUGJh+vcIfJLlD41ubjbONCIum+2RHTQQ1M=
Date: Sat, 18 Jun 2011 15:13:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [Patch] hugetlb: remove user_shm_lock() check from
 hugetlb_file_setup()
Message-ID: <20110618071308.GA24743@cr0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a revert of

commit 2584e517320bd48dc8d20e38a2621a2dbe58fade
Author: Ravikiran G Thirumalai <kiran@scalex86.org>
Date:   Tue Mar 31 15:21:26 2009 -0700

    mm: reintroduce and deprecate rlimit based access for SHM_HUGETLB


because it is deprecated and scheduled to be removed.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 72e2384..d627fd3 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -298,18 +298,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	Ability for non root users to shm_get hugetlb pages based on mlock
-	resource limits
-When:	2.6.31
-Why:	Non root users need to be part of /proc/sys/vm/hugetlb_shm_group or
-	have CAP_IPC_LOCK to be able to allocate shm segments backed by
-	huge pages.  The mlock based rlimit check to allow shm hugetlb is
-	inconsistent with mmap based allocations.  Hence it is being
-	deprecated.
-Who:	Ravikiran Thirumalai <kiran@scalex86.org>
-
----------------------------
-
 What:	CONFIG_THERMAL_HWMON
 When:	January 2009
 Why:	This option was introduced just to allow older lm-sensors userspace
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7aafeb8..e2627a3 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -936,15 +936,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
 
-	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
-		*user = current_user();
-		if (user_shm_lock(size, *user)) {
-			printk_once(KERN_WARNING "Using mlock ulimits for SHM_HUGETLB is deprecated\n");
-		} else {
-			*user = NULL;
-			return ERR_PTR(-EPERM);
-		}
-	}
+	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm())
+		return ERR_PTR(-EPERM);
 
 	root = hugetlbfs_vfsmount->mnt_root;
 	quick_string.name = name;
@@ -952,7 +945,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	quick_string.hash = 0;
 	path.dentry = d_alloc(root, &quick_string);
 	if (!path.dentry)
-		goto out_shm_unlock;
+		goto out;
 
 	path.mnt = mntget(hugetlbfs_vfsmount);
 	error = -ENOSPC;
@@ -983,11 +976,7 @@ out_inode:
 	iput(inode);
 out_dentry:
 	path_put(&path);
-out_shm_unlock:
-	if (*user) {
-		user_shm_unlock(size, *user);
-		*user = NULL;
-	}
+out:
 	return ERR_PTR(error);
 }
 
