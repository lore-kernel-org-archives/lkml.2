Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab0JSD7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:59:36 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35919 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933791Ab0JSD7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:59:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCd4JSBIpK
Message-Id: <20101019034658.106421196@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:41 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 25/35] fs: icache reduce some locking overheads
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-reduce-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c |    8 +++++---
 fs/inode.c        |    5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:21.000000000 +1100
@@ -375,15 +375,17 @@
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
 	if (!(inode->i_state & I_FREEING)) {
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:22.000000000 +1100
@@ -857,9 +857,12 @@
 
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode->i_lock);
 		inode->i_ino = get_next_ino();
 		inode->i_state = 0;
+		/*
+		 * We could init inode locked here, to improve performance.
+		 */
+		spin_lock(&inode->i_lock);
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
 	}


