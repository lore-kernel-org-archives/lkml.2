Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0KWOLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:11:54 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21941 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab0KWOLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:11:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEJAMpZ60x5LdQd/2dsb2JhbACUYYECjQByvUeFSwSKXg
Message-Id: <20101123140707.922192750@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 01:06:14 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/7] fs: preserve inode dirty bits on failed metadata writeback
References: <20101123140610.292941494@kernel.dk>
Content-Disposition: inline; filename=fs-inode-dirty-error-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we think the inode is clean even if syncing failed.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-11-23 22:28:22.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-11-23 22:57:40.000000000 +1100
@@ -447,15 +447,25 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
-	spin_unlock(&inode_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
-		int err = write_inode(inode, wbc);
+		int err;
+
+		spin_unlock(&inode_lock);
+		err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
+		spin_lock(&inode_lock);
+		if (err) {
+			/*
+			 * Inode writeout failed, restore inode metadata
+			 * dirty bits.
+			 */
+			inode->i_state |= dirty &
+					(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+		}
 	}
 
-	spin_lock(&inode_lock);
 	if (!inode_writeback_end(inode)) {
 		if (wbc->nr_to_write <= 0) {
 			/*


