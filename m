Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2CJC5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:57:05 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:38089 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221Ab2CJC5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:57:01 -0500
Date: Sat, 10 Mar 2012 02:56:58 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/6] Squashfs: add mount time sanity check for block_size
 and block_log match
Message-ID: <4f5ac2fa.BVNsfM2JUUe4UE6G%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Squashfs currently has a sanity check for block_size less than or
equal to the maximum block_size (1 Mbyte).  This catches some
superblock corruption, but obviously with a block_size maximum
of 1 Mbyte there's 7 correct values (4K, 8K, 16K, 32K, ... etc) and
a lot of incorrect values which are not caught by this check.

The Squashfs superblock, however, has both a block_size and
a block_log (2^block_log == block_size).  Checking that the block_size
matches the block_log is a much more robust check.  Corruption of the
superblock is unlikely to produce values which match, and it also
ensures the block_size is an exact power of two.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index ecaa2f7..a55a9c5 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -158,10 +158,15 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
+	/* Check block log for sanity */
 	msblk->block_log = le16_to_cpu(sblk->block_log);
 	if (msblk->block_log > SQUASHFS_FILE_MAX_LOG)
 		goto failed_mount;
 
+	/* Check that block_size and block_log match */
+	if (msblk->block_size != (1 << msblk->block_log))
+		goto failed_mount;
+
 	/* Check the root inode for sanity */
 	root_inode = le64_to_cpu(sblk->root_inode);
 	if (SQUASHFS_INODE_OFFSET(root_inode) > SQUASHFS_METADATA_SIZE)
-- 
1.7.5.4

