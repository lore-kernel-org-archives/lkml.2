Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1ABHVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:34079 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1ABHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 022/260] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted
Date: Sun,  2 Jan 2011 02:15:18 -0500
Message-Id: <1293952756-15010-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:30.0053 (UTC) FILETIME=[89288950:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 786ec7915e530936b9eb2e3d12274145cab7aa7d upstream.

Dimitry Monakhov discovered an edge case where it was possible for the
EXT4_EOFBLOCKS_FL flag could get cleared unnecessarily.  This is true;
I have a test case that can be exercised via downloading and
decompressing the file:

wget ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-testcases/eofblocks-fl-test-case.img.bz2
bunzip2 eofblocks-fl-test-case.img
dd if=/dev/zero of=eofblocks-fl-test-case.img bs=1k seek=17925 bs=1k count=1 conv=notrunc

However, triggering it in real life is highly unlikely since it
requires an extremely fragmented sparse file with a hole in exactly
the right place in the extent tree.  (It actually took quite a bit of
work to generate this test case.)  Still, it's nice to get even
extreme corner cases to be correct, so this patch makes sure that we
don't clear the EXT4_EOFBLOCKS_FL incorrectly even in this corner
case.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/extents.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8e8a7a4..5e663a7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3329,7 +3329,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent_header *eh;
 	struct ext4_extent newex, *ex, *last_ex;
 	ext4_fsblk_t newblock;
-	int err = 0, depth, ret, cache_type;
+	int i, err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
@@ -3519,8 +3519,20 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			goto out2;
 		}
 		last_ex = EXT_LAST_EXTENT(eh);
-		if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
-		    + ext4_ext_get_actual_len(last_ex))
+		/*
+		 * If the current leaf block was reached by looking at
+		 * the last index block all the way down the tree, and
+		 * we are extending the inode beyond the last extent
+		 * in the current leaf block, then clear the
+		 * EOFBLOCKS_FL flag.
+		 */
+		for (i = depth-1; i >= 0; i--) {
+			if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
+				break;
+		}
+		if ((i < 0) &&
+		    (iblock + ar.len > le32_to_cpu(last_ex->ee_block) +
+		     ext4_ext_get_actual_len(last_ex)))
 			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
-- 
1.7.3.3

