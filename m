Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2GASTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:19:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47048 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932319Ab2GASQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:47 -0400
Message-Id: <20120701172009.796864449@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 22/48] dm thin: reinstate missing mempool_free in cell_release_singleton
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 03aaae7cdc71bc306888440b1f569d463e917b6d upstream.

Fix a significant memory leak inadvertently introduced during
simplification of cell_release_singleton() in commit
6f94a4c45a6f744383f9f695dde019998db3df55 ("dm thin: fix stacked bi_next
usage").

A cell's hlist_del() must be accompanied by a mempool_free().
Use __cell_release() to do this, like before.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-thin.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 213ae32..301db0f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -279,8 +279,10 @@ static void __cell_release(struct cell *cell, struct bio_list *inmates)
 
 	hlist_del(&cell->list);
 
-	bio_list_add(inmates, cell->holder);
-	bio_list_merge(inmates, &cell->bios);
+	if (inmates) {
+		bio_list_add(inmates, cell->holder);
+		bio_list_merge(inmates, &cell->bios);
+	}
 
 	mempool_free(cell, prison->cell_pool);
 }
@@ -303,9 +305,10 @@ static void cell_release(struct cell *cell, struct bio_list *bios)
  */
 static void __cell_release_singleton(struct cell *cell, struct bio *bio)
 {
-	hlist_del(&cell->list);
 	BUG_ON(cell->holder != bio);
 	BUG_ON(!bio_list_empty(&cell->bios));
+
+	__cell_release(cell, NULL);
 }
 
 static void cell_release_singleton(struct cell *cell, struct bio *bio)


