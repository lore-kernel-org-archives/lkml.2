Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2GaFA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:00:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48680 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab2GaEua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:30 -0400
Message-Id: <20120731044321.453865665@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Brian Foster <bfoster@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 63/73] ext4: dont let i_reserved_meta_blocks go negative
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a533a18..25f809d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -346,6 +346,15 @@ void ext4_da_update_reserve_space(struct inode *inode,
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
 	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;


