Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1EYDXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:23:42 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:54322 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793Ab1EYDXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:23:41 -0400
Date: Wed, 25 May 2011 04:23:38 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Squashfs: add extra sanity checks at mount time
Message-ID: <4ddc763a.iEroXVA5QW9QMuO1%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some extra sanity checks of the inode and directory structures.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/super.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index efa8118..984d6c8 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -268,7 +268,7 @@ allocate_id_index_table:
 handle_fragments:
 	fragments = le32_to_cpu(sblk->fragments);
 	if (fragments == 0)
-		goto allocate_root;
+		goto check_directory_table;
 
 	msblk->fragment_cache = squashfs_cache_init("fragment",
 		SQUASHFS_CACHED_FRAGMENTS, msblk->block_size);
@@ -286,8 +286,22 @@ handle_fragments:
 		msblk->fragment_index = NULL;
 		goto failed_mount;
 	}
+	next_table = msblk->fragment_index[0];
 
-allocate_root:
+check_directory_table:
+	/* Sanity check directory_table */
+	if (msblk->directory_table >= next_table) {
+		err = -EINVAL;
+		goto failed_mount;
+	}
+
+	/* Sanity check inode_table */
+	if (msblk->inode_table >= msblk->directory_table) {
+		err = -EINVAL;
+		goto failed_mount;
+	}
+
+	/* allocate root */
 	root = new_inode(sb);
 	if (!root) {
 		err = -ENOMEM;
-- 
1.7.1

