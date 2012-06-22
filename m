Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240Ab2FVPAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565Ab2FVPAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:00:17 -0400
Date: Fri, 22 Jun 2012 10:59:48 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Thornber <ejt@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] dm thin: reinstate missing mempool_free in
 cell_release_singleton
Message-ID: <20120622145947.GA4089@redhat.com>
References: <20120330195801.GA31806@kroah.com>
 <20120330194856.784259750@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330194856.784259750@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

3.3-stable pulled in upstream commit
6f94a4c45a6f744383f9f695dde019998db3df55 (dm thin: fix stacked bi_next usage)

But later in the 3.4 development window it was determined that that
commit introduced a significant leak.  The following upstream commit
fixes it (but unfortunately didn't cc: stable).

-------------------

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
---
 drivers/md/dm-thin.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

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
-- 
1.7.4.4
