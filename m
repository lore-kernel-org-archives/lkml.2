Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2BEW3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:29:37 -0500
Received: from 1wt.eu ([62.212.114.60]:62176 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab2BEW3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:29:34 -0500
Message-Id: <20120205220950.897542067@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>, Jan Kara <jack@suse.cz>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 34/91] ext3: Fix oops in ext3_try_to_allocate_with_rsv()
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit ad95c5e9bc8b5885f94dce720137cac8fa8da4c9 upstream.

Block allocation is called from two places: ext3_get_blocks_handle() and
ext3_xattr_block_set(). These two callers are not necessarily synchronized
because xattr code holds only xattr_sem and i_mutex, and
ext3_get_blocks_handle() may hold only truncate_mutex when called from
writepage() path. Block reservation code does not expect two concurrent
allocations to happen to the same inode and thus assertions can be triggered
or reservation structure corruption can occur.

Fix the problem by taking truncate_mutex in xattr code to serialize
allocations.

CC: Sage Weil <sage@newdream.net>
Reported-by: Fyodor Ustinov <ufm@ufm.su>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext3/xattr.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/fs/ext3/xattr.c
===================================================================
--- longterm-2.6.27.orig/fs/ext3/xattr.c	2012-02-05 22:34:33.971915261 +0100
+++ longterm-2.6.27/fs/ext3/xattr.c	2012-02-05 22:34:39.684915780 +0100
@@ -801,8 +801,16 @@
 			/* We need to allocate a new block */
 			ext3_fsblk_t goal = ext3_group_first_block_no(sb,
 						EXT3_I(inode)->i_block_group);
-			ext3_fsblk_t block = ext3_new_block(handle, inode,
-							goal, &error);
+			ext3_fsblk_t block;
+
+			/*
+			 * Protect us agaist concurrent allocations to the
+			 * same inode from ext3_..._writepage(). Reservation
+			 * code does not expect racing allocations.
+			 */
+			mutex_lock(&EXT3_I(inode)->truncate_mutex);
+			block = ext3_new_block(handle, inode, goal, &error);
+			mutex_unlock(&EXT3_I(inode)->truncate_mutex);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);


