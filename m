Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0KWOLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:11:51 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2581 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab0KWOLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:11:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEJAMpZ60x5LdQd/2dsb2JhbACUYYECjQByvUeFSwSKXoUT
Message-Id: <20101123140707.701911603@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 01:06:11 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/7] fs: mark_inode_dirty barrier fix
References: <20101123140610.292941494@kernel.dk>
Content-Disposition: inline; filename=fs-mark_inode_dirty-barrier-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystems appear to be using ->dirty_inode, expecting that the dirtying
operating is done and visible to all CPUs (eg. setting private inode dirty
bits, without any barriers themselves). So release the dirty "critical
section" with a barrier before calling ->dirty_inode.

Cost is not significantly changed, because we're just moving the barrier.
Those filesystems that do use ->dirty_inode should have to care slightly
less about barriers, which is a good thing.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-11-19 16:47:00.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-11-19 16:49:39.000000000 +1100
@@ -934,6 +934,15 @@ void __mark_inode_dirty(struct inode *in
 	bool wakeup_bdi = false;
 
 	/*
+	 * Make sure that changes are seen by all cpus before we test i_state
+	 * or mark anything as being dirty. Ie. all dirty state should be
+	 * written to the inode and visible. Like an "unlock" operation, the
+	 * mark_inode_dirty call must "release" our ordering window that is
+	 * opened when we started modifying the inode.
+	 */
+	smp_mb();
+
+	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
 	 * dirty the inode itself
 	 */
@@ -942,12 +951,6 @@ void __mark_inode_dirty(struct inode *in
 			sb->s_op->dirty_inode(inode);
 	}
 
-	/*
-	 * make sure that changes are seen by all cpus before we test i_state
-	 * -- mikulas
-	 */
-	smp_mb();
-
 	/* avoid the locking if we can */
 	if ((inode->i_state & flags) == flags)
 		return;


