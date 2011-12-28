Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab1L1GJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 01:09:05 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:42187
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab1L1GJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 01:09:03 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: <b29237@freescale.com>
To: <neilb@suse.de>, <linux-raid@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <r58472@freescale.com>
CC: Forrest shi <b29237@freescale.com>
Subject: [PATCH][RFC] 	RAID5/DMA/memcpy: zero copy the bio page when possible
Date: Wed, 28 Dec 2011 13:20:08 +0800
Message-ID: <1325049608-8638-1-git-send-email-b29237@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Forrest shi <b29237@freescale.com>

	use bio page directly instead of copying the bio page to stripe
	header page when possible.

	Signed-off-by: Forrest Shi<b29237@freescale.com>
---
 drivers/dma/Kconfig        |    8 +++
 drivers/md/raid5.c         |  122 +++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.h         |    6 ++
 include/linux/page-flags.h |   11 ++++
 mm/filemap.c               |   21 ++++++++
 5 files changed, 154 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index dd8e959..8e90272 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -280,6 +280,14 @@ config ASYNC_TX_DMA
 
 	  If unsure, say N.
 
+config OPTIMIZE_FSL_DMA_MEMCPY
+        bool "Optimized DMA/XOR offload: reduce raid5 memcpy which offloaded for fsl dma"
+        depends on ASYNC_TX_DMA
+        help
+          This allows the async_tx api try to reduce raid5 memcpy operations for
+          fsl dma. If you have fsl dma and talitos enabled, you can set it as Y,
+          else N.
+
 config DMATEST
 	tristate "DMA Test client"
 	depends on DMA_ENGINE
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cbb50d3..9b80e52 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3,7 +3,8 @@
  *	   Copyright (C) 1996, 1997 Ingo Molnar, Miguel de Icaza, Gadi Oxman
  *	   Copyright (C) 1999, 2000 Ingo Molnar
  *	   Copyright (C) 2002, 2003 H. Peter Anvin
- *
+ *	   Copyright (C) 2010, Freescale Semiconductor, Inc. All rights
+ *		reserved.
  * RAID-4/5/6 management functions.
  * Thanks to Penguin Computing for making the RAID-6 development possible
  * by donating a test server!
@@ -558,6 +559,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+			if (test_bit(R5_DirectAccess, &sh->dev[i].flags)) {
+				struct page *pg = sh->dev[i].page;
+				BUG_ON(sh->dev[i].req.bi_io_vec[0].bv_page ==
+					pg);
+				sh->dev[i].req.bi_io_vec[0].bv_page = pg;
+			}
+#endif
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
@@ -685,6 +694,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
 			spin_unlock_irq(&conf->device_lock);
+
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
@@ -754,10 +764,16 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
-	for (i = disks; i--; )
+	for (i = disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		struct page *pg = dev->page;
 		if (i != target)
-			xor_srcs[count++] = sh->dev[i].page;
-
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+			if (test_bit(R5_DirectAccess, &dev->flags))
+				pg = dev->req.bi_io_vec[0].bv_page;
+#endif
+			xor_srcs[count++] = pg;
+	}
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
@@ -993,8 +1009,14 @@ ops_run_prexor(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_Wantdrain, &dev->flags))
-			xor_srcs[count++] = dev->page;
+		if (test_bit(R5_Wantdrain, &dev->flags)) {
+			struct page *pg = dev->page;
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+			if (test_bit(R5_DirectAccess, &dev->flags))
+				pg = dev->req.bi_io_vec[0].bv_page;
+#endif
+			xor_srcs[count++] = pg;
+		}
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
@@ -1004,6 +1026,32 @@ ops_run_prexor(struct stripe_head *sh, struct raid5_percpu *percpu,
 	return tx;
 }
 
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+static struct page *raid5_zero_copy(struct bio *bio, sector_t sector)
+{
+        sector_t bi_sector = bio->bi_sector;
+        struct page *page = NULL;
+        struct bio_vec *bv;
+        int i;
+
+        bio_for_each_segment(bv, bio, i) {
+                if (sector == bi_sector)
+                        page = bio_iovec_idx(bio, i)->bv_page;
+
+                bi_sector += bio_iovec_idx(bio, i)->bv_len >> 9;
+                if (bi_sector >= sector + STRIPE_SECTORS) {
+                        /* check if the stripe is covered by one page */
+                        if (page == bio_iovec_idx(bio, i)->bv_page) {
+                                SetPageConstant(page);
+                                return page;
+                        }
+                        return NULL;
+                }
+        }
+        return NULL;
+}
+#endif
+
 static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
@@ -1025,8 +1073,28 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			dev->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+			set_bit(R5_LOCKED, &dev->flags);
+			BUG_ON(test_bit(R5_DirectAccess, &dev->flags));
 			spin_unlock(&sh->lock);
 
+			if (!wbi->bi_next && test_bit(R5_OVERWRITE, &dev->flags)
+					&& test_bit(R5_Insync, &dev->flags)) {
+				struct page *pg = raid5_zero_copy(wbi,
+								dev->sector);
+				if (pg) {
+					dev->req.bi_io_vec[0].bv_page = pg;
+					set_bit(R5_DirectAccess, &dev->flags);
+					clear_bit(R5_UPTODATE, &dev->flags);
+					clear_bit(R5_OVERWRITE, &dev->flags);
+					continue;
+				}
+			}
+			clear_bit(R5_OVERWRITE, &dev->flags);
+			set_bit(R5_UPTODATE, &dev->flags);
+#else
+			spin_unlock(&sh->lock);
+#endif
 			while (wbi && wbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				if (wbi->bi_rw & REQ_FUA)
@@ -1102,15 +1170,29 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (dev->written)
-				xor_srcs[count++] = dev->page;
+			struct page *pg = dev->page;
+
+			if (dev->written) {
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+				if (test_bit(R5_DirectAccess, &dev->flags))
+					pg = dev->req.bi_io_vec[0].bv_page;
+#endif
+				xor_srcs[count++] = pg;
+			}
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
-				xor_srcs[count++] = dev->page;
+			struct page *pg = dev->page;
+
+			if (i != pd_idx) {
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+				if (test_bit(R5_DirectAccess, &dev->flags))
+					pg = dev->req.bi_io_vec[0].bv_page;
+#endif
+				xor_srcs[count++] = pg;
+			}
 		}
 	}
 
@@ -1637,6 +1719,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			md_error(conf->mddev, rdev);
 		}
 	}
+
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -1666,15 +1749,19 @@ static void raid5_end_write_request(struct bio *bi, int error)
 		md_error(conf->mddev, conf->disks[i].rdev);
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-	
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+	if (test_bit(R5_DirectAccess, &sh->dev[i].flags)) {
+		BUG_ON(sh->dev[i].req.bi_io_vec[0].bv_page == sh->dev[i].page);
+		sh->dev[i].req.bi_io_vec[0].bv_page = sh->dev[i].page;
+	}
+#endif
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
-
 static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
-	
+
 static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 {
 	struct r5dev *dev = &sh->dev[i];
@@ -2505,7 +2592,11 @@ static void handle_stripe_clean_event(raid5_conf_t *conf,
 		if (sh->dev[i].written) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) &&
-				test_bit(R5_UPTODATE, &dev->flags)) {
+				(test_bit(R5_UPTODATE, &dev->flags)
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+				|| test_bit(R5_DirectAccess, &dev->flags)
+#endif
+			)) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
@@ -2513,6 +2604,9 @@ static void handle_stripe_clean_event(raid5_conf_t *conf,
 				spin_lock_irq(&conf->device_lock);
 				wbi = dev->written;
 				dev->written = NULL;
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+				clear_bit(R5_DirectAccess, &dev->flags);
+#endif
 				while (wbi && wbi->bi_sector <
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 3ca77a2..dccf34f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -276,6 +276,12 @@ struct r6_state {
 				    */
 #define R5_Wantdrain	13 /* dev->towrite needs to be drained */
 #define R5_WantFUA	14	/* Write should be FUA */
+
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+#define R5_DirectAccess 15 /* access cached pages directly instead of
+                                       * sh pages */
+#endif
+
 /*
  * Write method
  */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6081493..d2bbc94 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -104,6 +104,9 @@ enum pageflags {
 #ifdef CONFIG_MEMORY_FAILURE
 	PG_hwpoison,		/* hardware poisoned page. Don't touch */
 #endif
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+        PG_constant,            /* const page not modified during raid5 io */
+#endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
@@ -196,6 +199,14 @@ static inline int __TestClearPage##uname(struct page *page) { return 0; }
 
 struct page;	/* forward declaration */
 
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+#define PageConstant(page) test_bit(PG_constant, &(page)->flags)
+#define SetPageConstant(page) set_bit(PG_constant, &(page)->flags)
+#define ClearPageConstant(page) clear_bit(PG_constant, &(page->flags))
+#define TestSetPageConstant(page) test_and_set_bit(PG_constant, &(page)->flags)
+extern void clear_page_constant(struct page *page);
+#endif
+
 TESTPAGEFLAG(Locked, locked)
 PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
 PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
diff --git a/mm/filemap.c b/mm/filemap.c
index a8251a8..f7d98ad 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -28,6 +28,11 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
+
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+#include <linux/rmap.h>
+#endif
+
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/cpuset.h>
@@ -636,10 +641,26 @@ void end_page_writeback(struct page *page)
 		BUG();
 
 	smp_mb__after_clear_bit();
+
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+	clear_page_constant(page);
+#endif
+
 	wake_up_page(page, PG_writeback);
 }
 EXPORT_SYMBOL(end_page_writeback);
 
+#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
+void clear_page_constant(struct page *page)
+{
+	if (PageConstant(page)) {
+		ClearPageConstant(page);
+		SetPageUptodate(page);
+	}
+}
+EXPORT_SYMBOL(clear_page_constant);
+#endif
+
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
-- 
1.7.0.4


