Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0FXDQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0FXDPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:50 -0400
Message-Id: <20100624030733.001192703@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:58 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 46/52] fs: icache reduce locking
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode-reduce-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -484,15 +484,17 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode->i_lock);
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
-	spin_unlock(&inode->i_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
-		int err = write_inode(inode, wbc);
+		int err;
+
+		spin_unlock(&inode->i_lock);
+		err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
+		spin_lock(&inode->i_lock);
 	}
 
-	spin_lock(&inode->i_lock);
 	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -810,12 +810,9 @@ struct inode *new_inode(struct super_blo
 
 	inode = alloc_inode(sb);
 	if (inode) {
-		/* XXX: init as locked for speedup */
-		spin_lock(&inode->i_lock);
 		inode->i_ino = last_ino_get();
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
-		spin_unlock(&inode->i_lock);
 	}
 	return inode;
 }


