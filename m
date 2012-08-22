Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab2HVREo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:04:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab2HVREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:32 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Alasdair Kergon <agk@redhat.com>
Subject: [PATCH v6 02/13] dm: Use bioset's front_pad for dm_rq_clone_bio_info
Date: Wed, 22 Aug 2012 10:03:59 -0700
Message-Id: <1345655050-28199-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345655050-28199-1-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, dm_rq_clone_bio_info needed to be freed by the bio's
destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
This gets rid of a memory allocation and means we can kill
dm_rq_bio_destructor.

v6: Fix comment on struct dm_rq_clone_bio_info, per Tejun

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Alasdair Kergon <agk@redhat.com>
---
 drivers/md/dm.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0c3d6dd..5ed9779 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -86,12 +86,17 @@ struct dm_rq_target_io {
 };
 
 /*
- * For request-based dm.
- * One of these is allocated per bio.
+ * For request-based dm - the bio clones we allocate are embedded in these
+ * structs.
+ *
+ * We allocate these with bio_alloc_bioset, using the front_pad parameter when
+ * the bioset is created - this means the bio has to come at the end of the
+ * struct.
  */
 struct dm_rq_clone_bio_info {
 	struct bio *orig;
 	struct dm_rq_target_io *tio;
+	struct bio clone;
 };
 
 union map_info *dm_get_mapinfo(struct bio *bio)
@@ -467,16 +472,6 @@ static void free_rq_tio(struct dm_rq_target_io *tio)
 	mempool_free(tio, tio->md->tio_pool);
 }
 
-static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
-{
-	return mempool_alloc(md->io_pool, GFP_ATOMIC);
-}
-
-static void free_bio_info(struct dm_rq_clone_bio_info *info)
-{
-	mempool_free(info, info->tio->md->io_pool);
-}
-
 static int md_in_flight(struct mapped_device *md)
 {
 	return atomic_read(&md->pending[READ]) +
@@ -1460,30 +1455,17 @@ void dm_dispatch_request(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
-static void dm_rq_bio_destructor(struct bio *bio)
-{
-	struct dm_rq_clone_bio_info *info = bio->bi_private;
-	struct mapped_device *md = info->tio->md;
-
-	free_bio_info(info);
-	bio_free(bio, md->bs);
-}
-
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 				 void *data)
 {
 	struct dm_rq_target_io *tio = data;
-	struct mapped_device *md = tio->md;
-	struct dm_rq_clone_bio_info *info = alloc_bio_info(md);
-
-	if (!info)
-		return -ENOMEM;
+	struct dm_rq_clone_bio_info *info =
+		container_of(bio, struct dm_rq_clone_bio_info, clone);
 
 	info->orig = bio_orig;
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
 	bio->bi_private = info;
-	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
 }
@@ -2718,7 +2700,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
 	if (!pools->tio_pool)
 		goto free_io_pool_and_out;
 
-	pools->bs = bioset_create(pool_size, 0);
+	pools->bs = bioset_create(pool_size,
+				  offsetof(struct dm_rq_clone_bio_info, clone));
 	if (!pools->bs)
 		goto free_tio_pool_and_out;
 
-- 
1.7.12

