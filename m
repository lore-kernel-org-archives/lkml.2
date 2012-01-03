Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2ACEOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 23:14:05 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:49582 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab2ACEOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 23:14:03 -0500
Date: Tue, 03 Jan 2012 04:14:00 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH] Squashfs: fix i_blocks calculation with extended regular
 files
Message-ID: <4f028088.10/1QgccWuFwnQkk%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The le64_to_cpu() forces the calculation to be unsigned, with
the effect that it can underflow leading to an incorrect large
value.

This bug only triggers in rare(ish) circumstances, an empty file
encoded as an extended regular file or a completely sparse file.
Normally empty files are encoded as a regular file rather than as
an extended regular file (and the regular file i_blocks calculation
doesn't have this bug).  To save space regular file inodes are
optimised to encode the most commonly occurring files.  Less
common regular files are encoded using extended regular file inodes
which contain extra information.

Empty files with nlinks greater than 1, and or empty files
with extended attributes are encoded using extended regular file
inodes and they will hit this bug.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index fd7b3b3..81afbcc 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -208,8 +208,8 @@ int squashfs_read_inode(struct inode *inode, long long ino)
 		inode->i_op = &squashfs_inode_ops;
 		inode->i_fop = &generic_ro_fops;
 		inode->i_mode |= S_IFREG;
-		inode->i_blocks = ((inode->i_size -
-				le64_to_cpu(sqsh_ino->sparse) - 1) >> 9) + 1;
+		inode->i_blocks = (inode->i_size -
+				le64_to_cpu(sqsh_ino->sparse) + 511) >> 9;
 
 		squashfs_i(inode)->fragment_block = frag_blk;
 		squashfs_i(inode)->fragment_size = frag_size;
-- 
1.7.5.4

