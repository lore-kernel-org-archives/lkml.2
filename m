Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2IXWgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:36:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63509 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2IXWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:36:01 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 25/26] bio-integrity: Add explicit field for owner of bip_buf
Date: Mon, 24 Sep 2012 15:35:05 -0700
Message-Id: <1348526106-17074-26-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was the only real user of BIO_CLONED, which didn't have very clear
semantics. Convert to its own flag so we can get rid of BIO_CLONED.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  | 5 ++---
 include/linux/bio.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index f175814..c5f33b4 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -95,9 +95,7 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_set *bs = bio->bi_pool;
 
-	/* A cloned bio doesn't own the integrity metadata */
-	if (!bio_flagged(bio, BIO_CLONED) && !bio_flagged(bio, BIO_FS_INTEGRITY)
-	    && bip->bip_buf != NULL)
+	if (bip->bip_owns_buf)
 		kfree(bip->bip_buf);
 
 	if (bs) {
@@ -384,6 +382,7 @@ int bio_integrity_prep(struct bio *bio)
 		return -EIO;
 	}
 
+	bip->bip_owns_buf = 1;
 	bip->bip_buf = buf;
 	bip->bip_size = len;
 	bip->bip_sector = bio->bi_sector;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bd130b6..d316fb3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -178,6 +178,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_idx;	/* current bip_vec index */
+	unsigned		bip_owns_buf:1;	/* should free bip_buf */
 
 	struct work_struct	bip_work;	/* I/O completion */
 
-- 
1.7.12

