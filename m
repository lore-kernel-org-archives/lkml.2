Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab2CFTks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:40:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56029 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab2CFTkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:40:46 -0500
Date: Tue, 6 Mar 2012 11:40:20 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] ext4: Update s_free_{inodes,blocks}_count during online
	resize
Message-ID: <20120306194020.GI15164@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030619-7182-0000-0000-000000FA885D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're doing an online resize of an ext4 filesystem, we need to update the
free inode and block counts in the superblock so that fsck doesn't complain.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/resize.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f9d948f..a97ede4 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1163,8 +1163,11 @@ static void ext4_update_super(struct super_block *sb,
 	do_div(reserved_blocks, 100);
 
 	ext4_blocks_count_set(es, ext4_blocks_count(es) + blocks_count);
+	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + free_blocks);
 	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb) *
 		     flex_gd->count);
+	le32_add_cpu(&es->s_free_inodes_count, EXT4_INODES_PER_GROUP(sb) *
+		     flex_gd->count);
 
 	/*
 	 * We need to protect s_groups_count against other CPUs seeing
@@ -1465,6 +1468,7 @@ static int ext4_group_extend_no_check(struct super_block *sb,
 	}
 
 	ext4_blocks_count_set(es, o_blocks_count + add);
+	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + add);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
 	/* We add the blocks to the bitmap and set the group need init bit */

