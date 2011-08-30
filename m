Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1H3JHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:07:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38211 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1H3JFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/15] drbd: use clear_bit_unlock() where appropriate
Date: Tue, 30 Aug 2011 11:05:42 +0200
Message-Id: <1314695149-387-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Some open-coded clear_bit(); smp_mb__after_clear_bit();
should in fact have been smp_mb__before_clear_bit(); clear_bit();

Instead, use clear_bit_unlock() to annotate the intention,
and have it do the right thing.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |    3 +--
 drivers/block/drbd/drbd_main.c   |    3 +--
 include/linux/lru_cache.h        |    3 +--
 lib/lru_cache.c                  |   10 ++++------
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index e8d652f..4be7370 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -219,8 +219,7 @@ static void bm_page_unlock_io(struct drbd_conf *mdev, int page_nr)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	void *addr = &page_private(b->bm_pages[page_nr]);
-	clear_bit(BM_PAGE_IO_LOCK, addr);
-	smp_mb__after_clear_bit();
+	clear_bit_unlock(BM_PAGE_IO_LOCK, addr);
 	wake_up(&mdev->bitmap->bm_io_wait);
 }
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 910dff7..75b092b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2819,8 +2819,7 @@ static int w_bitmap_io(struct drbd_work *w, int unused)
 		put_ldev(mdev);
 	}
 
-	clear_bit(BITMAP_IO, &mdev->flags);
-	smp_mb__after_clear_bit();
+	clear_bit_unlock(BITMAP_IO, &mdev->flags);
 	wake_up(&mdev->misc_wait);
 
 	if (work->done)
diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
index 7a71ffa..4cceafb 100644
--- a/include/linux/lru_cache.h
+++ b/include/linux/lru_cache.h
@@ -275,8 +275,7 @@ static inline int lc_try_lock(struct lru_cache *lc)
  */
 static inline void lc_unlock(struct lru_cache *lc)
 {
-	clear_bit(__LC_DIRTY, &lc->flags);
-	smp_mb__after_clear_bit();
+	clear_bit_unlock(__LC_DIRTY, &lc->flags);
 }
 
 static inline int lc_is_used(struct lru_cache *lc, unsigned int enr)
diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index a07e726..9f353f7 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -44,8 +44,8 @@ MODULE_LICENSE("GPL");
 } while (0)
 
 #define RETURN(x...)     do { \
-	clear_bit(__LC_PARANOIA, &lc->flags); \
-	smp_mb__after_clear_bit(); return x ; } while (0)
+	clear_bit_unlock(__LC_PARANOIA, &lc->flags); \
+	return x ; } while (0)
 
 /* BUG() if e is not one of the elements tracked by lc */
 #define PARANOIA_LC_ELEMENT(lc, e) do {	\
@@ -438,8 +438,7 @@ void lc_changed(struct lru_cache *lc, struct lc_element *e)
 	hlist_add_head(&e->colision, lc_hash_slot(lc, lc->new_number));
 	lc->changing_element = NULL;
 	lc->new_number = LC_FREE;
-	clear_bit(__LC_DIRTY, &lc->flags);
-	smp_mb__after_clear_bit();
+	clear_bit_unlock(__LC_DIRTY, &lc->flags);
 	RETURN();
 }
 
@@ -463,8 +462,7 @@ unsigned int lc_put(struct lru_cache *lc, struct lc_element *e)
 		/* move it to the front of LRU. */
 		list_move(&e->list, &lc->lru);
 		lc->used--;
-		clear_bit(__LC_STARVING, &lc->flags);
-		smp_mb__after_clear_bit();
+		clear_bit_unlock(__LC_STARVING, &lc->flags);
 	}
 	RETURN(e->refcnt);
 }
-- 
1.7.4.1

