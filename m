Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1ABHVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:33850 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab1ABHVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jing Zhang <zj.barak@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 005/260] ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
Date: Sun,  2 Jan 2011 02:15:01 -0500
Message-Id: <1293952756-15010-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:12.0194 (UTC) FILETIME=[7E837820:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Zhang <zj.barak@gmail.com>

commit b720303df7352d4a7a1f61e467e0a124913c0d41 upstream.

When EIO occurs after bio is submitted, there is no memory free
operation for bio, which results in memory leakage. And there is also
no check against bio_alloc() for bio.

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/extents.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 236b834..228eeaf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2544,7 +2544,7 @@ static void bi_complete(struct bio *bio, int error)
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
-	int ret = -EIO;
+	int ret;
 	struct bio *bio;
 	int blkbits, blocksize;
 	sector_t ee_pblock;
@@ -2568,6 +2568,9 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
+		if (!bio)
+			return -ENOMEM;
+
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 
@@ -2595,17 +2598,15 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 		submit_bio(WRITE, bio);
 		wait_for_completion(&event);
 
-		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
-			ret = 0;
-		else {
-			ret = -EIO;
-			break;
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			bio_put(bio);
+			return -EIO;
 		}
 		bio_put(bio);
 		ee_len    -= done;
 		ee_pblock += done  << (blkbits - 9);
 	}
-	return ret;
+	return 0;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
-- 
1.7.3.3

