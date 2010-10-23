Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0JWCvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:51:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36708 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab0JWCvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:51:36 -0400
Date: Sat, 23 Oct 2010 13:51:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20101023135133.136f6e19.sfr@canb.auug.org.au>
In-Reply-To: <20101011141838.fc59ee7c.sfr@canb.auug.org.au>
References: <20101011141838.fc59ee7c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Mon, 11 Oct 2010 14:18:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from init/do_mounts.h:2,
>                  from init/do_mounts_md.c:5:
> include/linux/blkdev.h: In function 'sb_issue_zeroout':
> include/linux/blkdev.h:900: error: too many arguments to function 'blkdev_issue_zeroout'
> 
> Caused by commit dd3932eddf428571762596e17b65f5dc92ca361b ("block: remove
> BLKDEV_IFL_WAIT") interacting with commit
> 3be0ead7b05f0caaeb2f56b9902985b8120ef0cf ("Add helper function for
> blkdev_issue_zeroout (sb_issue_discard)") from the ext4 tree.
> 
> I applied the following merge fixup patch which I can carry as necessary
> (unless there is a better solution).

This fix (below) will now be necessary when the ext4 tree is merged with
Linus' tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Oct 2010 13:50:22 +1100
Subject: [PATCH] ext4: merge fix for blkdev_issue_zeroout API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/extents.c      |    3 +--
 fs/ext4/ialloc.c       |    5 +----
 fs/ext4/resize.c       |    5 ++---
 include/linux/blkdev.h |    4 ++--
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a0e6230..a130f02 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2545,8 +2545,7 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 	ee_len    = ext4_ext_get_actual_len(ex);
 	ee_pblock = ext_pblock(ex);
 
-	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len,
-			       GFP_NOFS, BLKDEV_IFL_WAIT);
+	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len, GFP_NOFS);
 	if (ret > 0)
 		ret = 0;
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 87d228a..f7e25aa 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1238,7 +1238,6 @@ extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 	handle_t *handle;
 	ext4_fsblk_t blk;
 	int num, ret = 0, used_blks = 0;
-	unsigned long flags = BLKDEV_IFL_WAIT;
 
 	/* This should not happen, but just to be sure check this */
 	if (sb->s_flags & MS_RDONLY) {
@@ -1303,9 +1302,7 @@ extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 
 	ext4_debug("going to zero out inode table in group %d\n",
 		   group);
-	if (barrier)
-		flags |= BLKDEV_IFL_BARRIER;
-	ret = sb_issue_zeroout(sb, blk, num, GFP_NOFS, flags);
+	ret = sb_issue_zeroout(sb, blk, num, GFP_NOFS);
 	if (ret < 0)
 		goto err_out;
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 2f5e347..998a462 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -229,7 +229,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
 			block, sbi->s_itb_per_group);
 	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
-			       GFP_NOFS, BLKDEV_IFL_WAIT);
+			       GFP_NOFS);
 	if (err)
 		goto exit_bh;
 
@@ -244,8 +244,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	block = input->inode_table;
 	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
 			block, sbi->s_itb_per_group);
-	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group,
-			       GFP_NOFS, BLKDEV_IFL_WAIT);
+	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
 	if (err)
 		goto exit_bh;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a1dec60..1095272 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -892,12 +892,12 @@ static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 				    gfp_mask, flags);
 }
 static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
-		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
+		sector_t nr_blocks, gfp_t gfp_mask)
 {
 	return blkdev_issue_zeroout(sb->s_bdev,
 				    block << (sb->s_blocksize_bits - 9),
 				    nr_blocks << (sb->s_blocksize_bits - 9),
-				    gfp_mask, flags);
+				    gfp_mask);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
