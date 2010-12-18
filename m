Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0LRCCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 21:02:42 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757022Ab0LRCCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 21:02:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQHAH+jC015LdJm/2dsb2JhbACXH40TdL44hUoEiwE
Message-Id: <20101218015117.335778892@kernel.dk>
User-Agent: quilt/0.48-1
Date: Sat, 18 Dec 2010 12:46:38 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/8] fs: preserve inode dirty bits on failed metadata writeback
References: <20101218014634.943276411@kernel.dk>
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


