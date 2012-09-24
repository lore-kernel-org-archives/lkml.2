Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2IXWmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:42:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43938 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2IXWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:35:31 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 01/26] block: Fix a buffer overrun in bio_integrity_split()
Date: Mon, 24 Sep 2012 15:34:41 -0700
Message-Id: <1348526106-17074-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_integrity_split() seemed to be confusing pointers and arrays -
bip_vec in bio_integrity_payload is an array appended to the end of the
payload, so the bio_vecs in struct bio_pair need to come immediately
after the bio_integrity_payload they're for, and there was an assignment
in bio_integrity_split() that didn't make any sense.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  | 3 ---
 include/linux/bio.h | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index a3f28f3..c7b6b52 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -697,9 +697,6 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->iv1 = bip->bip_vec[0];
 	bp->iv2 = bip->bip_vec[0];
 
-	bp->bip1.bip_vec[0] = bp->iv1;
-	bp->bip2.bip_vec[0] = bp->iv2;
-
 	bp->iv1.bv_len = sectors * bi->tuple_size;
 	bp->iv2.bv_offset += sectors * bi->tuple_size;
 	bp->iv2.bv_len -= sectors * bi->tuple_size;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b31036f..8e2d108 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -200,8 +200,10 @@ struct bio_pair {
 	struct bio			bio1, bio2;
 	struct bio_vec			bv1, bv2;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
-	struct bio_integrity_payload	bip1, bip2;
-	struct bio_vec			iv1, iv2;
+	struct bio_integrity_payload	bip1;
+	struct bio_vec			iv1;
+	struct bio_integrity_payload	bip2;
+	struct bio_vec			iv2;
 #endif
 	atomic_t			cnt;
 	int				error;
-- 
1.7.12

