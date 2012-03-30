Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936299Ab2C3ViW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:38:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33600 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966072Ab2C3VcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:17 -0400
X-Sasl-enc: fPPDsfddGEG4v55NTS7WnmcU06dxzuv5FdHL7I5Cx+qh 1333143136
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:56 2012
Message-Id: <20120330194856.784259750@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 152/175] dm thin: fix stacked bi_next usage
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 6f94a4c45a6f744383f9f695dde019998db3df55 upstream.

Avoid using the bi_next field for the holder of a cell when deferring
bios because a stacked device below might change it.  Store the
holder in a new field in struct cell instead.

When a cell is created, the bio that triggered creation (the holder) was
added to the same bio list as subsequent bios.  In some cases we pass
this holder bio directly to devices underneath.  If those devices use
the bi_next field there will be trouble...

This also simplifies some code that had to work out which bio was the
holder.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |  126 +++++++++++++++++++++++++++++----------------------
 1 file changed, 74 insertions(+), 52 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -124,7 +124,7 @@ struct cell {
 	struct hlist_node list;
 	struct bio_prison *prison;
 	struct cell_key key;
-	unsigned count;
+	struct bio *holder;
 	struct bio_list bios;
 };
 
@@ -220,54 +220,59 @@ static struct cell *__search_bucket(stru
  * This may block if a new cell needs allocating.  You must ensure that
  * cells will be unlocked even if the calling thread is blocked.
  *
- * Returns the number of entries in the cell prior to the new addition
- * or < 0 on failure.
+ * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
  */
 static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 		      struct bio *inmate, struct cell **ref)
 {
-	int r;
+	int r = 1;
 	unsigned long flags;
 	uint32_t hash = hash_key(prison, key);
-	struct cell *uninitialized_var(cell), *cell2 = NULL;
+	struct cell *cell, *cell2;
 
 	BUG_ON(hash > prison->nr_buckets);
 
 	spin_lock_irqsave(&prison->lock, flags);
-	cell = __search_bucket(prison->cells + hash, key);
 
-	if (!cell) {
-		/*
-		 * Allocate a new cell
-		 */
-		spin_unlock_irqrestore(&prison->lock, flags);
-		cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
-		spin_lock_irqsave(&prison->lock, flags);
-
-		/*
-		 * We've been unlocked, so we have to double check that
-		 * nobody else has inserted this cell in the meantime.
-		 */
-		cell = __search_bucket(prison->cells + hash, key);
-
-		if (!cell) {
-			cell = cell2;
-			cell2 = NULL;
-
-			cell->prison = prison;
-			memcpy(&cell->key, key, sizeof(cell->key));
-			cell->count = 0;
-			bio_list_init(&cell->bios);
-			hlist_add_head(&cell->list, prison->cells + hash);
-		}
+	cell = __search_bucket(prison->cells + hash, key);
+	if (cell) {
+		bio_list_add(&cell->bios, inmate);
+		goto out;
 	}
 
-	r = cell->count++;
-	bio_list_add(&cell->bios, inmate);
+	/*
+	 * Allocate a new cell
+	 */
 	spin_unlock_irqrestore(&prison->lock, flags);
+	cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
+	spin_lock_irqsave(&prison->lock, flags);
 
-	if (cell2)
+	/*
+	 * We've been unlocked, so we have to double check that
+	 * nobody else has inserted this cell in the meantime.
+	 */
+	cell = __search_bucket(prison->cells + hash, key);
+	if (cell) {
 		mempool_free(cell2, prison->cell_pool);
+		bio_list_add(&cell->bios, inmate);
+		goto out;
+	}
+
+	/*
+	 * Use new cell.
+	 */
+	cell = cell2;
+
+	cell->prison = prison;
+	memcpy(&cell->key, key, sizeof(cell->key));
+	cell->holder = inmate;
+	bio_list_init(&cell->bios);
+	hlist_add_head(&cell->list, prison->cells + hash);
+
+	r = 0;
+
+out:
+	spin_unlock_irqrestore(&prison->lock, flags);
 
 	*ref = cell;
 
@@ -283,8 +288,8 @@ static void __cell_release(struct cell *
 
 	hlist_del(&cell->list);
 
-	if (inmates)
-		bio_list_merge(inmates, &cell->bios);
+	bio_list_add(inmates, cell->holder);
+	bio_list_merge(inmates, &cell->bios);
 
 	mempool_free(cell, prison->cell_pool);
 }
@@ -305,22 +310,44 @@ static void cell_release(struct cell *ce
  * bio may be in the cell.  This function releases the cell, and also does
  * a sanity check.
  */
+static void __cell_release_singleton(struct cell *cell, struct bio *bio)
+{
+	hlist_del(&cell->list);
+	BUG_ON(cell->holder != bio);
+	BUG_ON(!bio_list_empty(&cell->bios));
+}
+
 static void cell_release_singleton(struct cell *cell, struct bio *bio)
 {
-	struct bio_prison *prison = cell->prison;
-	struct bio_list bios;
-	struct bio *b;
 	unsigned long flags;
-
-	bio_list_init(&bios);
+	struct bio_prison *prison = cell->prison;
 
 	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release(cell, &bios);
+	__cell_release_singleton(cell, bio);
 	spin_unlock_irqrestore(&prison->lock, flags);
+}
+
+/*
+ * Sometimes we don't want the holder, just the additional bios.
+ */
+static void __cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	struct bio_prison *prison = cell->prison;
+
+	hlist_del(&cell->list);
+	bio_list_merge(inmates, &cell->bios);
+
+	mempool_free(cell, prison->cell_pool);
+}
+
+static void cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	unsigned long flags;
+	struct bio_prison *prison = cell->prison;
 
-	b = bio_list_pop(&bios);
-	BUG_ON(b != bio);
-	BUG_ON(!bio_list_empty(&bios));
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release_no_holder(cell, inmates);
+	spin_unlock_irqrestore(&prison->lock, flags);
 }
 
 static void cell_error(struct cell *cell)
@@ -800,21 +827,16 @@ static void cell_defer(struct thin_c *tc
  * Same as cell_defer above, except it omits one particular detainee,
  * a write bio that covers the block and has already been processed.
  */
-static void cell_defer_except(struct thin_c *tc, struct cell *cell,
-			      struct bio *exception)
+static void cell_defer_except(struct thin_c *tc, struct cell *cell)
 {
 	struct bio_list bios;
-	struct bio *bio;
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
 	bio_list_init(&bios);
-	cell_release(cell, &bios);
 
 	spin_lock_irqsave(&pool->lock, flags);
-	while ((bio = bio_list_pop(&bios)))
-		if (bio != exception)
-			bio_list_add(&pool->deferred_bios, bio);
+	cell_release_no_holder(cell, &pool->deferred_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	wake_worker(pool);
@@ -854,7 +876,7 @@ static void process_prepared_mapping(str
 	 * the bios in the cell.
 	 */
 	if (bio) {
-		cell_defer_except(tc, m->cell, bio);
+		cell_defer_except(tc, m->cell);
 		bio_endio(bio, 0);
 	} else
 		cell_defer(tc, m->cell, m->data_block);


