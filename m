Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2DMOHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2DMOHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:07:24 -0400
From: Matthew Garrett <mjg@redhat.com>
To: hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] hfsplus: Fix bless ioctl when used with hardlinks
Date: Fri, 13 Apr 2012 10:06:54 -0400
Message-Id: <1334326014-15244-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HFS+ doesn't really implement hard links - instead, hardlinks are indicated
by a magic file type which refers to an indirect node in a hidden
directory. The spec indicates that stat() should return the inode number
of the indirect node, but it turns out that this doesn't satisfy the
firmware when it's looking for a bootloader - it wants the catalog ID of
the hardlink file instead. Fix up this case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 fs/hfsplus/ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index c640ba5..5ee0681 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -31,6 +31,7 @@ static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	struct hfsplus_vh *vh = sbi->s_vhdr;
 	struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
+	int cnid = (u32)(unsigned long)dentry->d_fsdata;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -41,8 +42,12 @@ static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
 	vh->finder_info[0] = bvh->finder_info[0] =
 		cpu_to_be32(parent_ino(dentry));
 
-	/* Bootloader */
-	vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(inode->i_ino);
+	/*
+	 * Bootloader. Just using the inode here breaks in the case of
+	 * hard links - the firmware wants the ID of the hard link file,
+	 * but the inode points at the indirect inode
+	 */
+	vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(cnid);
 
 	/* Per spec, the OS X system folder - same as finder_info[0] here */
 	vh->finder_info[5] = bvh->finder_info[5] =
-- 
1.7.10

