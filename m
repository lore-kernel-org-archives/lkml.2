Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1HCX3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:29:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab1HCX2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:51 2011
Message-Id: <20110803221251.075701537@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [070/102] ext4: fix i_blocks/quota accounting when extent insertion fails
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Patlasov <maxim.patlasov@gmail.com>

commit 7132de744ba76930d13033061018ddd7e3e8cd91 upstream.

The current implementation of ext4_free_blocks() always calls
dquot_free_block This looks quite sensible in the most cases: blocks
to be freed are associated with inode and were accounted in quota and
i_blocks some time ago.

However, there is a case when blocks to free were not accounted by the
time calling ext4_free_blocks() yet:

1. delalloc is on, write_begin pre-allocated some space in quota
2. write-back happens, ext4 allocates some blocks in ext4_ext_map_blocks()
3. then ext4_ext_map_blocks() gets an error (e.g.  ENOSPC) from
   ext4_ext_insert_extent() and calls ext4_free_blocks().

In this scenario, ext4_free_blocks() calls dquot_free_block() who, in
turn, decrements i_blocks for blocks which were not accounted yet (due
to delalloc) After clean umount, e2fsck reports something like:

> Inode 21, i_blocks is 5080, should be 5128.  Fix<y>?
because i_blocks was erroneously decremented as explained above.

The patch fixes the problem by passing the new flag
EXT4_FREE_BLOCKS_NO_QUOT_UPDATE to ext4_free_blocks(), to request
that the dquot_free_block() call be skipped.

Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |    4 +++-
 fs/ext4/mballoc.c |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -526,6 +526,7 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
 #define EXT4_FREE_BLOCKS_FORGET		0x0002
 #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
+#define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
 
 /*
  * ioctl commands
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3601,12 +3601,14 @@ int ext4_ext_map_blocks(handle_t *handle
 
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
+		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
+			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;
 		/* free data blocks we just allocated */
 		/* not a good idea to call discard here directly,
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), 0);
+				 ext4_ext_get_actual_len(&newex), fb_flags);
 		goto out2;
 	}
 
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4637,7 +4637,7 @@ do_more:
 	}
 	ext4_mark_super_dirty(sb);
 error_return:
-	if (freed)
+	if (freed && !(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
 		dquot_free_block(inode, freed);
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);


