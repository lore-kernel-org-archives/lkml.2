Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1HFAKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:10:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab1HFAKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:10:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:52 2011
Message-Id: <20110806000252.388605468@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@newdream.net>, Jan Kara <jack@suse.cz>
Subject: [35/55] ext3: Fix oops in ext3_try_to_allocate_with_rsv()
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

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
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -800,8 +800,16 @@ inserted:
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


