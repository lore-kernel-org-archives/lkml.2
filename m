Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0LRCCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 21:02:31 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756965Ab0LRCCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 21:02:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQHAH+jC015LdJm/2dsb2JhbACXH40TdL44hUoEiwE
Message-Id: <20101218015117.126922835@kernel.dk>
User-Agent: quilt/0.48-1
Date: Sat, 18 Dec 2010 12:46:36 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/8] fs: simple fsync race fix
References: <20101218014634.943276411@kernel.dk>
Content-Disposition: inline; filename=fs-sync-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is incorrect to test inode dirty bits without participating in the inode
writeback protocol. Inode writeback sets I_SYNC and clears I_DIRTY_?, then
writes out the particular bits, then clears I_SYNC when it is done. BTW. it
may not completely write all pages out, so I_DIRTY_PAGES would get set
again.

This is a standard pattern used throughout the kernel's writeback caches
(I_SYNC ~= I_WRITEBACK, if that makes it clearer).

And so it is not possible to determine an inode's dirty status just by
checking I_DIRTY bits. Especially not for the purpose of data integrity
syncs.

Missing the check for these bits means that fsync can complete while
writeback to the inode is underway. Inode writeback functions get this
right, so call into them rather than try to shortcut things by testing
dirty state improperly.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>


Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-11-19 16:44:39.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-11-19 16:49:42.000000000 +1100
@@ -895,11 +895,6 @@ int generic_file_fsync(struct file *file
 	int ret;
 
 	ret = sync_mapping_buffers(inode->i_mapping);
-	if (!(inode->i_state & I_DIRTY))
-		return ret;
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return ret;
-
 	err = sync_inode_metadata(inode, 1);
 	if (ret == 0)
 		ret = err;
Index: linux-2.6/fs/exofs/file.c
===================================================================
--- linux-2.6.orig/fs/exofs/file.c	2010-11-19 16:50:00.000000000 +1100
+++ linux-2.6/fs/exofs/file.c	2010-11-19 16:50:07.000000000 +1100
@@ -48,11 +48,6 @@ static int exofs_file_fsync(struct file
 	struct inode *inode = filp->f_mapping->host;
 	struct super_block *sb;
 
-	if (!(inode->i_state & I_DIRTY))
-		return 0;
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return 0;
-
 	ret = sync_inode_metadata(inode, 1);
 
 	/* This is a good place to write the sb */


