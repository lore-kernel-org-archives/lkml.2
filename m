Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002Ab2JAXWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:22:05 -0400
Received: from 1wt.eu ([62.212.114.60]:35361 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab2JAXBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:25 -0400
Message-Id: <20121001225202.266707400@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 110/180] ext4: dont let i_reserved_meta_blocks go negative
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

commit 97795d2a5b8d3c8dc4365d4bd3404191840453ba upstream.

If we hit a condition where we have allocated metadata blocks that
were not appropriately reserved, we risk underflow of
ei->i_reserved_meta_blocks.  In turn, this can throw
sbi->s_dirtyclusters_counter significantly out of whack and undermine
the nondelalloc fallback logic in ext4_nonda_switch().  Warn if this
occurs and set i_allocated_meta_blocks to avoid this problem.

This condition is reproduced by xfstests 270 against ext2 with
delalloc enabled:

Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): delayed block allocation failed for inode 14 at logical offset 64486 with max blocks 64 with error -28
Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This should not happen!! Data will be lost

270 ultimately fails with an inconsistent filesystem and requires an
fsck to repair.  The cause of the error is an underflow in
ext4_da_update_reserve_space() due to an unreserved meta block
allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/inode.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 72ba88f..efe6363 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1112,6 +1112,15 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		used = ei->i_reserved_data_blocks;
 	}
 
+	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_blocks)) {
+		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, allocated %d "
+			 "with only %d reserved metadata blocks\n", __func__,
+			 inode->i_ino, ei->i_allocated_meta_blocks,
+			 ei->i_reserved_meta_blocks);
+		WARN_ON(1);
+		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
+	}
+
 	/* Update per-inode reservations */
 	ei->i_reserved_data_blocks -= used;
 	used += ei->i_allocated_meta_blocks;
-- 
1.7.2.1.45.g54fbc



