Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab2FQVGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:06:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60666
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757928Ab2FQVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:06:33 -0400
Message-Id: <20120617210633.151202220@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Sun, 17 Jun 2012 17:05:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] hfsplus: fix bless ioctl when used with hardlinks
References: <20120617210523.088906451@bombadil.infradead.org>
Content-Disposition: inline; filename=hfsplus-bless.diff
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

HFS+ doesn't really implement hard links - instead, hardlinks are indicated
by a magic file type which refers to an indirect node in a hidden
directory. The spec indicates that stat() should return the inode number
of the indirect node, but it turns out that this doesn't satisfy the
firmware when it's looking for a bootloader - it wants the catalog ID of
the hardlink file instead. Fix up this case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/hfsplus/ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index c640ba5..09addc8 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -31,6 +31,7 @@ static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	struct hfsplus_vh *vh = sbi->s_vhdr;
 	struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
+	u32 cnid = (unsigned long)dentry->d_fsdata;
 
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



