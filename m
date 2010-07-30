Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0G3RTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:39 -0400
Received: from kroah.org ([198.145.64.141]:51957 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757Ab0G3RTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.587274036@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Jing Zhang <zj.barak@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [110/165] ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit b720303df7352d4a7a1f61e467e0a124913c0d41 upstream (as of v2.6.34-git13)

When EIO occurs after bio is submitted, there is no memory free
operation for bio, which results in memory leakage. And there is also
no check against bio_alloc() for bio.

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2446,7 +2446,7 @@ static void bi_complete(struct bio *bio,
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
-	int ret = -EIO;
+	int ret;
 	struct bio *bio;
 	int blkbits, blocksize;
 	sector_t ee_pblock;
@@ -2470,6 +2470,9 @@ static int ext4_ext_zeroout(struct inode
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
+		if (!bio)
+			return -ENOMEM;
+
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 
@@ -2497,17 +2500,15 @@ static int ext4_ext_zeroout(struct inode
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


