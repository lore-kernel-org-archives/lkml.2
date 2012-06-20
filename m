Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2FTSWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab2FTSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:16 -0400
Message-Id: <20120620173023.259786850@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [ 27/61] hfsplus: fix bless ioctl when used with hardlinks
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 7dea9665fee828fb56db3bae5b9685d9fa006d33 upstream.

HFS+ doesn't really implement hard links - instead, hardlinks are indicated
by a magic file type which refers to an indirect node in a hidden
directory. The spec indicates that stat() should return the inode number
of the indirect node, but it turns out that this doesn't satisfy the
firmware when it's looking for a bootloader - it wants the catalog ID of
the hardlink file instead. Fix up this case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hfsplus/ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -31,6 +31,7 @@ static int hfsplus_ioctl_bless(struct fi
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	struct hfsplus_vh *vh = sbi->s_vhdr;
 	struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
+	u32 cnid = (unsigned long)dentry->d_fsdata;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -41,8 +42,12 @@ static int hfsplus_ioctl_bless(struct fi
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


