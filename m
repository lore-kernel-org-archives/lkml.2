Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1BPAoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:44:15 -0500
Received: from kroah.org ([198.145.64.141]:49333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab1BPAXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.815498026@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: [177/272] Revert "exofs: Set i_mapping->backing_dev_info anyway"
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 0b0abeaf3d30cec03ac6497fe978b8f7edecc5ae upstream.

This reverts commit 115e19c53501edc11f730191f7f047736815ae3d.

Apparently setting inode->bdi to one's own sb->s_bdi stops VFS from
sending *read-aheads*.  This problem was bisected to this commit.  A
revert fixes it.  I'll investigate farther why is this happening for the
next Kernel, but for now a revert.

I'm sending to stable@kernel.org as well, since it exists also in
2.6.37.  2.6.36 is good and does not have this patch.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exofs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1030,7 +1030,6 @@ struct inode *exofs_iget(struct super_bl
 		memcpy(oi->i_data, fcb.i_data, sizeof(fcb.i_data));
 	}
 
-	inode->i_mapping->backing_dev_info = sb->s_bdi;
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &exofs_file_inode_operations;
 		inode->i_fop = &exofs_file_operations;
@@ -1131,7 +1130,6 @@ struct inode *exofs_new_inode(struct ino
 
 	sbi = sb->s_fs_info;
 
-	inode->i_mapping->backing_dev_info = sb->s_bdi;
 	sb->s_dirt = 1;
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = sbi->s_nextid++;


