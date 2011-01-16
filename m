Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1APO2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 09:28:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35034 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1APO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 09:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GxkXLi4tGjv5+2F0AgQs0BG3eW3h4vckOYz5vENa54ub9kStjQXFDXIwsbCjrEUzd/
         L7AmF2Y2uDxpMneTzmPEDI+qY2D+kg1jRykrhuFA9bjWwuWZfliq1QIOehajCE3LzZ2Z
         AFkqe9DpEeesHKyn/QgtxaURHcNVipOGkEYUE=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: fix address space warnings in ioctl_fiemap()
Date: Sun, 16 Jan 2011 23:28:17 +0900
Message-Id: <1295188097-7798-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fi_extents_start field of struct fiemap_extent_info is a
user pointer but was not marked as __user. This makes sparse
emit following warnings:

  CHECK   fs/ioctl.c
fs/ioctl.c:114:26: warning: incorrect type in argument 1 (different address spaces)
fs/ioctl.c:114:26:    expected void [noderef] <asn:1>*dst
fs/ioctl.c:114:26:    got struct fiemap_extent *[assigned] dest
fs/ioctl.c:202:14: warning: incorrect type in argument 1 (different address spaces)
fs/ioctl.c:202:14:    expected void const volatile [noderef] <asn:1>*<noident>
fs/ioctl.c:202:14:    got struct fiemap_extent *[assigned] fi_extents_start
fs/ioctl.c:212:27: warning: incorrect type in argument 1 (different address spaces)
fs/ioctl.c:212:27:    expected void [noderef] <asn:1>*dst
fs/ioctl.c:212:27:    got char *<noident>

Also add 'ufiemap' variable to eliminate unnecessary casts.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ioctl.c         |   10 +++++-----
 include/linux/fs.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index d6cc16476620..a59635e295fa 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -86,7 +86,7 @@ int fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo, u64 logical,
 			    u64 phys, u64 len, u32 flags)
 {
 	struct fiemap_extent extent;
-	struct fiemap_extent *dest = fieinfo->fi_extents_start;
+	struct fiemap_extent __user *dest = fieinfo->fi_extents_start;
 
 	/* only count the extents */
 	if (fieinfo->fi_extents_max == 0) {
@@ -173,6 +173,7 @@ static int fiemap_check_ranges(struct super_block *sb,
 static int ioctl_fiemap(struct file *filp, unsigned long arg)
 {
 	struct fiemap fiemap;
+	struct fiemap __user *ufiemap = (struct fiemap __user *) arg;
 	struct fiemap_extent_info fieinfo = { 0, };
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
@@ -182,8 +183,7 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	if (!inode->i_op->fiemap)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(&fiemap, (struct fiemap __user *)arg,
-			   sizeof(struct fiemap)))
+	if (copy_from_user(&fiemap, ufiemap, sizeof(fiemap)))
 		return -EFAULT;
 
 	if (fiemap.fm_extent_count > FIEMAP_MAX_EXTENTS)
@@ -196,7 +196,7 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 
 	fieinfo.fi_flags = fiemap.fm_flags;
 	fieinfo.fi_extents_max = fiemap.fm_extent_count;
-	fieinfo.fi_extents_start = (struct fiemap_extent *)(arg + sizeof(fiemap));
+	fieinfo.fi_extents_start = ufiemap->fm_extents;
 
 	if (fiemap.fm_extent_count != 0 &&
 	    !access_ok(VERIFY_WRITE, fieinfo.fi_extents_start,
@@ -209,7 +209,7 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	error = inode->i_op->fiemap(inode, &fieinfo, fiemap.fm_start, len);
 	fiemap.fm_flags = fieinfo.fi_flags;
 	fiemap.fm_mapped_extents = fieinfo.fi_extents_mapped;
-	if (copy_to_user((char *)arg, &fiemap, sizeof(fiemap)))
+	if (copy_to_user(ufiemap, &fiemap, sizeof(fiemap)))
 		error = -EFAULT;
 
 	return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 08824e0ef381..d1777ab1fc5d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1481,8 +1481,8 @@ struct fiemap_extent_info {
 	unsigned int fi_flags;		/* Flags as passed from user */
 	unsigned int fi_extents_mapped;	/* Number of mapped extents */
 	unsigned int fi_extents_max;	/* Size of fiemap_extent array */
-	struct fiemap_extent *fi_extents_start; /* Start of fiemap_extent
-						 * array */
+	struct fiemap_extent __user *fi_extents_start; /* Start of
+							fiemap_extent array */
 };
 int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
 			    u64 phys, u64 len, u32 flags);
-- 
1.7.3.4.600.g982838b0

