Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1ABIN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:13:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:34053 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1ABHVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 021/260] ext4: Avoid crashing on NULL ptr dereference on a filesystem error
Date: Sun,  2 Jan 2011 02:15:17 -0500
Message-Id: <1293952756-15010-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:29.0131 (UTC) FILETIME=[889BD9B0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit f70f362b4a6fe47c239dbfb3efc0cc2c10e4f09c upstream.

If the EOFBLOCK_FL flag is set when it should not be and the inode is
zero length, then eh_entries is zero, and ex is NULL, so dereferencing
ex to print ex->ee_block causes a kernel OOPS in
ext4_ext_map_blocks().

On top of that, the error message which is printed isn't very helpful.
So we fix this by printing something more explanatory which doesn't
involve trying to print ex->ee_block.

Addresses-Google-Bug: #2655740

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/extents.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a1d3f7c..8e8a7a4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3381,8 +3381,9 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (unlikely(path[depth].p_ext == NULL && depth != 0)) {
 		EXT4_ERROR_INODE(inode, "bad extent address "
-				 "iblock: %d, depth: %d pblock %lld",
-				 iblock, depth, path[depth].p_block);
+				 "iblock: %lu, depth: %d pblock %lld",
+				 (unsigned long) iblock, depth,
+				 path[depth].p_block);
 		err = -EIO;
 		goto out2;
 	}
@@ -3512,8 +3513,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	if (unlikely(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
 		if (unlikely(!eh->eh_entries)) {
 			EXT4_ERROR_INODE(inode,
-					 "eh->eh_entries == 0 ee_block %d",
-					 ex->ee_block);
+					 "eh->eh_entries == 0 and "
+					 "EOFBLOCKS_FL set");
 			err = -EIO;
 			goto out2;
 		}
-- 
1.7.3.3

