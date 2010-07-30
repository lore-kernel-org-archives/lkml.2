Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab0G3S6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:58:52 -0400
Received: from kroah.org ([198.145.64.141]:51834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545Ab0G3RTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.121314021@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [094/165] ext4: Fix BUG_ON at fs/buffer.c:652 in no journal mode
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 73b50c1c92666d326b5fa2c945d46509f2f6d91f upstream (as of v2.6.33-git11)

Calls to ext4_handle_dirty_metadata should only pass in an inode
pointer for inode-specific metadata, and not for shared metadata
blocks such as inode table blocks, block group descriptors, the
superblock, etc.

The BUG_ON can get tripped when updating a special device (such as a
block device) that is opened (so that i_mapping is set in
fs/block_dev.c) and the file system is mounted in no journal mode.

Addresses-Google-Bug: #2404870

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4_jbd2.c |    2 +-
 fs/ext4/ialloc.c    |    2 +-
 fs/ext4/inode.c     |    6 +++---
 fs/ext4/namei.c     |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -89,7 +89,7 @@ int __ext4_handle_dirty_metadata(const c
 			ext4_journal_abort_handle(where, __func__, bh,
 						  handle, err);
 	} else {
-		if (inode && bh)
+		if (inode)
 			mark_buffer_dirty_inode(bh, inode);
 		else
 			mark_buffer_dirty(bh);
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -904,7 +904,7 @@ repeat_in_this_group:
 				BUFFER_TRACE(inode_bitmap_bh,
 					"call ext4_handle_dirty_metadata");
 				err = ext4_handle_dirty_metadata(handle,
-								 inode,
+								 NULL,
 							inode_bitmap_bh);
 				if (err)
 					goto fail;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5158,7 +5158,7 @@ static int ext4_do_update_inode(handle_t
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
-			err = ext4_handle_dirty_metadata(handle, inode,
+			err = ext4_handle_dirty_metadata(handle, NULL,
 					EXT4_SB(sb)->s_sbh);
 		}
 	}
@@ -5187,7 +5187,7 @@ static int ext4_do_update_inode(handle_t
 	}
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-	rc = ext4_handle_dirty_metadata(handle, inode, bh);
+	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (!err)
 		err = rc;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
@@ -5741,7 +5741,7 @@ static int ext4_pin_inode(handle_t *hand
 			err = jbd2_journal_get_write_access(handle, iloc.bh);
 			if (!err)
 				err = ext4_handle_dirty_metadata(handle,
-								 inode,
+								 NULL,
 								 iloc.bh);
 			brelse(iloc.bh);
 		}
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2024,7 +2024,7 @@ int ext4_orphan_add(handle_t *handle, st
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-	err = ext4_handle_dirty_metadata(handle, inode, EXT4_SB(sb)->s_sbh);
+	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
@@ -2096,7 +2096,7 @@ int ext4_orphan_del(handle_t *handle, st
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		err = ext4_handle_dirty_metadata(handle, inode, sbi->s_sbh);
+		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
 	} else {
 		struct ext4_iloc iloc2;
 		struct inode *i_prev =


