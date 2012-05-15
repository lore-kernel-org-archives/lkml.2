Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411Ab2EOCic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:38:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53505 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357Ab2EOCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 135/179] ext3: Fix oops in ext3_try_to_allocate_with_rsv()
Date: Mon, 14 May 2012 22:13:51 -0400
Message-ID: <1337048075-6132-136-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext3/xattr.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 534a94c..3a6356d 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -803,8 +803,16 @@ inserted:
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
-- 
1.7.9.6

