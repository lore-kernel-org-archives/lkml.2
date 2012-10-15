Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2JOUS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:18:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47102 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab2JOUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:27 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        vgoyal@redhat.com, martin.petersen@oracle.com
Subject: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
Date: Mon, 15 Oct 2012 13:09:01 -0700
Message-Id: <1350331769-14856-28-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_integrity_split() seemed to be confusing pointers and arrays -
bip_vec in bio_integrity_payload was an array appended to the end of the
payload, so the bio_vecs in struct bio_pair should have come after the
bio_integrity_payload they're for.

Fix it by making bip_vec a pointer to the inline vecs - a later patch is
going to make more use of this pointer.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  | 5 +++--
 include/linux/bio.h | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index a3f28f3..94fa1c5 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -112,6 +112,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 
 	bip->bip_slab = idx;
 	bip->bip_bio = bio;
+	bip->bip_vec = bip->bip_inline_vecs;
 	bio->bi_integrity = bip;
 
 	return bip;
@@ -697,8 +698,8 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->iv1 = bip->bip_vec[0];
 	bp->iv2 = bip->bip_vec[0];
 
-	bp->bip1.bip_vec[0] = bp->iv1;
-	bp->bip2.bip_vec[0] = bp->iv2;
+	bp->bip1.bip_vec = &bp->iv1;
+	bp->bip2.bip_vec = &bp->iv2;
 
 	bp->iv1.bv_len = sectors * bi->tuple_size;
 	bp->iv2.bv_offset += sectors * bi->tuple_size;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b31036f..81004fd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -182,7 +182,9 @@ struct bio_integrity_payload {
 	unsigned short		bip_idx;	/* current bip_vec index */
 
 	struct work_struct	bip_work;	/* I/O completion */
-	struct bio_vec		bip_vec[0];	/* embedded bvec array */
+
+	struct bio_vec		*bip_vec;
+	struct bio_vec		bip_inline_vecs[0];/* embedded bvec array */
 };
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-- 
1.7.12

