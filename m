Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1HYPdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:33:44 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32964 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1HYPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 023/118] drbd: Replace the ERR_IF macro with an assert-like macro
Date: Thu, 25 Aug 2011 17:07:19 +0200
Message-Id: <1314284934-17999-24-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Remove the file name and line number from the syslog messages generated:
we have no duplicate function names, and no function contains the same
assertion more than once.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   21 +++++---
 drivers/block/drbd/drbd_bitmap.c   |   91 +++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_int.h      |   18 +++++--
 drivers/block/drbd/drbd_main.c     |   13 +++--
 drivers/block/drbd/drbd_nl.c       |    8 ++-
 drivers/block/drbd/drbd_receiver.c |   19 +++++--
 drivers/block/drbd/drbd_worker.c   |    7 ++-
 7 files changed, 114 insertions(+), 63 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 0eb17d3..9284b10 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -491,7 +491,8 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		unsigned int trn;
 
 		rv = drbd_al_read_tr(mdev, bdev, buffer, i);
-		ERR_IF(rv == 0) goto cancel;
+		if (!expect(rv != 0))
+			goto cancel;
 		if (rv == -1) {
 			mutex_unlock(&mdev->md_io_mutex);
 			return 0;
@@ -770,8 +771,10 @@ void __drbd_set_in_sync(struct drbd_conf *mdev, sector_t sector, int size,
 	nr_sectors = drbd_get_capacity(mdev->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
-	ERR_IF(sector >= nr_sectors) return;
-	ERR_IF(esector >= nr_sectors) esector = (nr_sectors-1);
+	if (!expect(sector < nr_sectors))
+		return;
+	if (!expect(esector < nr_sectors))
+		esector = nr_sectors - 1;
 
 	lbnr = BM_SECT_TO_BIT(nr_sectors-1);
 
@@ -837,10 +840,10 @@ int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector, int size,
 	nr_sectors = drbd_get_capacity(mdev->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
-	ERR_IF(sector >= nr_sectors)
+	if (!expect(sector < nr_sectors))
 		goto out;
-	ERR_IF(esector >= nr_sectors)
-		esector = (nr_sectors-1);
+	if (!expect(esector < nr_sectors))
+		esector = nr_sectors - 1;
 
 	lbnr = BM_SECT_TO_BIT(nr_sectors-1);
 
@@ -1218,8 +1221,10 @@ void drbd_rs_failed_io(struct drbd_conf *mdev, sector_t sector, int size)
 	nr_sectors = drbd_get_capacity(mdev->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
-	ERR_IF(sector >= nr_sectors) return;
-	ERR_IF(esector >= nr_sectors) esector = (nr_sectors-1);
+	if (!expect(sector < nr_sectors))
+		return;
+	if (!expect(esector < nr_sectors))
+		esector = nr_sectors - 1;
 
 	lbnr = BM_SECT_TO_BIT(nr_sectors-1);
 
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 7b97629..c756b4d 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -440,7 +440,8 @@ int drbd_bm_init(struct drbd_conf *mdev)
 
 sector_t drbd_bm_capacity(struct drbd_conf *mdev)
 {
-	ERR_IF(!mdev->bitmap) return 0;
+	if (!expect(mdev->bitmap))
+		return 0;
 	return mdev->bitmap->bm_dev_capacity;
 }
 
@@ -448,7 +449,8 @@ sector_t drbd_bm_capacity(struct drbd_conf *mdev)
  */
 void drbd_bm_cleanup(struct drbd_conf *mdev)
 {
-	ERR_IF (!mdev->bitmap) return;
+	if (!expect(mdev->bitmap))
+		return;
 	bm_free_pages(mdev->bitmap->bm_pages, mdev->bitmap->bm_number_of_pages);
 	bm_vk_free(mdev->bitmap->bm_pages, (BM_P_VMALLOCED & mdev->bitmap->bm_flags));
 	kfree(mdev->bitmap);
@@ -611,7 +613,8 @@ int drbd_bm_resize(struct drbd_conf *mdev, sector_t capacity, int set_new_bits)
 	int err = 0, growing;
 	int opages_vmalloced;
 
-	ERR_IF(!b) return -ENOMEM;
+	if (!expect(b))
+		return -ENOMEM;
 
 	drbd_bm_lock(mdev, "resize", BM_LOCKED_MASK);
 
@@ -733,8 +736,10 @@ unsigned long _drbd_bm_total_weight(struct drbd_conf *mdev)
 	unsigned long s;
 	unsigned long flags;
 
-	ERR_IF(!b) return 0;
-	ERR_IF(!b->bm_pages) return 0;
+	if (!expect(b))
+		return 0;
+	if (!expect(b->bm_pages))
+		return 0;
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	s = b->bm_set;
@@ -757,8 +762,10 @@ unsigned long drbd_bm_total_weight(struct drbd_conf *mdev)
 size_t drbd_bm_words(struct drbd_conf *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
-	ERR_IF(!b) return 0;
-	ERR_IF(!b->bm_pages) return 0;
+	if (!expect(b))
+		return 0;
+	if (!expect(b->bm_pages))
+		return 0;
 
 	return b->bm_words;
 }
@@ -766,7 +773,8 @@ size_t drbd_bm_words(struct drbd_conf *mdev)
 unsigned long drbd_bm_bits(struct drbd_conf *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
-	ERR_IF(!b) return 0;
+	if (!expect(b))
+		return 0;
 
 	return b->bm_bits;
 }
@@ -787,8 +795,10 @@ void drbd_bm_merge_lel(struct drbd_conf *mdev, size_t offset, size_t number,
 
 	end = offset + number;
 
-	ERR_IF(!b) return;
-	ERR_IF(!b->bm_pages) return;
+	if (!expect(b))
+		return;
+	if (!expect(b->bm_pages))
+		return;
 	if (number == 0)
 		return;
 	WARN_ON(offset >= b->bm_words);
@@ -832,8 +842,10 @@ void drbd_bm_get_lel(struct drbd_conf *mdev, size_t offset, size_t number,
 
 	end = offset + number;
 
-	ERR_IF(!b) return;
-	ERR_IF(!b->bm_pages) return;
+	if (!expect(b))
+		return;
+	if (!expect(b->bm_pages))
+		return;
 
 	spin_lock_irq(&b->bm_lock);
 	if ((offset >= b->bm_words) ||
@@ -861,8 +873,10 @@ void drbd_bm_get_lel(struct drbd_conf *mdev, size_t offset, size_t number,
 void drbd_bm_set_all(struct drbd_conf *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
-	ERR_IF(!b) return;
-	ERR_IF(!b->bm_pages) return;
+	if (!expect(b))
+		return;
+	if (!expect(b->bm_pages))
+		return;
 
 	spin_lock_irq(&b->bm_lock);
 	bm_memset(b, 0, 0xff, b->bm_words);
@@ -875,8 +889,10 @@ void drbd_bm_set_all(struct drbd_conf *mdev)
 void drbd_bm_clear_all(struct drbd_conf *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
-	ERR_IF(!b) return;
-	ERR_IF(!b->bm_pages) return;
+	if (!expect(b))
+		return;
+	if (!expect(b->bm_pages))
+		return;
 
 	spin_lock_irq(&b->bm_lock);
 	bm_memset(b, 0, 0, b->bm_words);
@@ -1209,8 +1225,10 @@ static unsigned long bm_find_next(struct drbd_conf *mdev,
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned long i = DRBD_END_OF_BITMAP;
 
-	ERR_IF(!b) return i;
-	ERR_IF(!b->bm_pages) return i;
+	if (!expect(b))
+		return i;
+	if (!expect(b->bm_pages))
+		return i;
 
 	spin_lock_irq(&b->bm_lock);
 	if (BM_DONT_TEST & b->bm_flags)
@@ -1311,8 +1329,10 @@ static int bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 	struct drbd_bitmap *b = mdev->bitmap;
 	int c = 0;
 
-	ERR_IF(!b) return 1;
-	ERR_IF(!b->bm_pages) return 0;
+	if (!expect(b))
+		return 1;
+	if (!expect(b->bm_pages))
+		return 0;
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if ((val ? BM_DONT_SET : BM_DONT_CLEAR) & b->bm_flags)
@@ -1437,8 +1457,10 @@ int drbd_bm_test_bit(struct drbd_conf *mdev, const unsigned long bitnr)
 	unsigned long *p_addr;
 	int i;
 
-	ERR_IF(!b) return 0;
-	ERR_IF(!b->bm_pages) return 0;
+	if (!expect(b))
+		return 0;
+	if (!expect(b->bm_pages))
+		return 0;
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if (BM_DONT_TEST & b->bm_flags)
@@ -1472,8 +1494,10 @@ int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 	 * robust in case we screwed up elsewhere, in that case pretend there
 	 * was one dirty bit in the requested area, so we won't try to do a
 	 * local read there (no bitmap probably implies no disk) */
-	ERR_IF(!b) return 1;
-	ERR_IF(!b->bm_pages) return 1;
+	if (!expect(b))
+		return 1;
+	if (!expect(b->bm_pages))
+		return 1;
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if (BM_DONT_TEST & b->bm_flags)
@@ -1486,11 +1510,10 @@ int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 				bm_unmap(p_addr);
 			p_addr = bm_map_pidx(b, idx);
 		}
-		ERR_IF (bitnr >= b->bm_bits) {
-			dev_err(DEV, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
-		} else {
+		if (expect(bitnr < b->bm_bits))
 			c += (0 != test_bit_le(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
-		}
+		else
+			dev_err(DEV, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
 	}
 	if (p_addr)
 		bm_unmap(p_addr);
@@ -1520,8 +1543,10 @@ int drbd_bm_e_weight(struct drbd_conf *mdev, unsigned long enr)
 	unsigned long flags;
 	unsigned long *p_addr, *bm;
 
-	ERR_IF(!b) return 0;
-	ERR_IF(!b->bm_pages) return 0;
+	if (!expect(b))
+		return 0;
+	if (!expect(b->bm_pages))
+		return 0;
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if (BM_DONT_TEST & b->bm_flags)
@@ -1553,8 +1578,10 @@ unsigned long drbd_bm_ALe_set_all(struct drbd_conf *mdev, unsigned long al_enr)
 	unsigned long weight;
 	unsigned long s, e;
 	int count, i, do_now;
-	ERR_IF(!b) return 0;
-	ERR_IF(!b->bm_pages) return 0;
+	if (!expect(b))
+		return 0;
+	if (!expect(b->bm_pages))
+		return 0;
 
 	spin_lock_irq(&b->bm_lock);
 	if (BM_DONT_SET & b->bm_flags)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index bb08714..00c9e31 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -102,12 +102,18 @@ struct drbd_conf;
 #define D_ASSERT(exp)	if (!(exp)) \
 	 dev_err(DEV, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
 
-#define ERR_IF(exp) if (({						\
-	int _b = (exp) != 0;						\
-	if (_b) dev_err(DEV, "ASSERT FAILED: %s: (%s) in %s:%d\n",	\
-			__func__, #exp, __FILE__, __LINE__);		\
-	_b;								\
-	}))
+/**
+ * expect  -  Make an assertion
+ *
+ * Unlike the assert macro, this macro returns a boolean result.
+ */
+#define expect(exp) ({								\
+		bool _bool = (exp);						\
+		if (!_bool)							\
+			dev_err(DEV, "ASSERTION %s FAILED in %s\n",		\
+			        #exp, __func__);				\
+		_bool;								\
+		})
 
 /* Defines to control fault insertion */
 enum {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 19176a1..46ba4aa 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1810,7 +1810,7 @@ void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 		p == mdev->receiver.task ? &mdev->receiver :
 		p == mdev->worker.task   ? &mdev->worker   :
 		NULL;
-	ERR_IF(thi == NULL)
+	if (!expect(thi != NULL))
 		return;
 	if (!thi->reset_cpu_mask)
 		return;
@@ -1826,8 +1826,10 @@ int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 {
 	int sent, ok;
 
-	ERR_IF(!h) return false;
-	ERR_IF(!size) return false;
+	if (!expect(h))
+		return false;
+	if (!expect(size))
+		return false;
 
 	h->magic   = cpu_to_be32(DRBD_MAGIC);
 	h->command = cpu_to_be16(cmd);
@@ -2300,7 +2302,8 @@ int _drbd_send_bitmap(struct drbd_conf *mdev)
 	struct p_header80 *p;
 	int err;
 
-	ERR_IF(!mdev->bitmap) return false;
+	if (!expect(mdev->bitmap))
+		return false;
 
 	/* maybe we should use some per thread scratch page,
 	 * and allocate that during initial device creation? */
@@ -3255,7 +3258,7 @@ static void drbd_delete_device(unsigned int minor)
 		dev_err(DEV, "open_cnt = %d in %s:%u", mdev->open_cnt,
 				__FILE__ , __LINE__);
 
-	ERR_IF (!list_empty(&mdev->data.work.q)) {
+	if (!expect(list_empty(&mdev->data.work.q))) {
 		struct list_head *lp;
 		list_for_each(lp, &mdev->data.work.q) {
 			dev_err(DEV, "lp = %p\n", lp);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 1840cbb8..51da849 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -751,7 +751,7 @@ static int drbd_check_al_size(struct drbd_conf *mdev)
 	unsigned int in_use;
 	int i;
 
-	ERR_IF(mdev->sync_conf.al_extents < 7)
+	if (!expect(mdev->sync_conf.al_extents >= 7))
 		mdev->sync_conf.al_extents = 127;
 
 	if (mdev->act_log &&
@@ -1804,8 +1804,10 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 		}
 	}
 
-	ERR_IF (sc.rate < 1) sc.rate = 1;
-	ERR_IF (sc.al_extents < 7) sc.al_extents = 127; /* arbitrary minimum */
+	if (!expect(sc.rate >= 1))
+		sc.rate = 1;
+	if (!expect(sc.al_extents >= 7))
+		sc.al_extents = 127; /* arbitrary minimum */
 #define AL_MAX ((MD_AL_MAX_SIZE-1) * AL_EXTENTS_PT)
 	if (sc.al_extents > AL_MAX) {
 		dev_err(DEV, "sc.al_extents > %d\n", AL_MAX);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1cfcc44..a41b078 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1260,9 +1260,12 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector, int data_size) __
 
 	data_size -= dgs;
 
-	ERR_IF(data_size == 0) return NULL;
-	ERR_IF(data_size &  0x1ff) return NULL;
-	ERR_IF(data_size >  DRBD_MAX_BIO_SIZE) return NULL;
+	if (!expect(data_size != 0))
+		return NULL;
+	if (!expect(IS_ALIGNED(data_size, 512)))
+		return NULL;
+	if (!expect(data_size <= DRBD_MAX_BIO_SIZE))
+		return NULL;
 
 	/* even though we trust out peer,
 	 * we sometimes have to double check. */
@@ -3615,7 +3618,8 @@ static int receive_skip(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	while (size > 0) {
 		want = min_t(int, size, sizeof(sink));
 		r = drbd_recv(mdev, sink, want);
-		ERR_IF(r <= 0) break;
+		if (!expect(r > 0))
+			break;
 		size -= r;
 	}
 	return size == 0;
@@ -4493,7 +4497,10 @@ int drbd_asender(struct drbd_thread *thi)
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev);
 		if (test_and_clear_bit(SEND_PING, &mdev->flags)) {
-			ERR_IF(!drbd_send_ping(mdev)) goto reconnect;
+			if (!drbd_send_ping(mdev)) {
+				dev_err(DEV, "drbd_send_ping has failed\n");
+				goto reconnect;
+			}
 			mdev->meta.socket->sk->sk_rcvtimeo =
 				mdev->net_conf->ping_timeo*HZ/10;
 			ping_timeout_active = 1;
@@ -4587,7 +4594,7 @@ int drbd_asender(struct drbd_thread *thi)
 				goto disconnect;
 			}
 			expect = cmd->pkt_size;
-			ERR_IF(len != expect-sizeof(struct p_header80))
+			if (!expect(len == expect - sizeof(struct p_header80)))
 				goto reconnect;
 		}
 		if (received == expect) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index c2a9285..2e2c065 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1331,7 +1331,8 @@ static int _drbd_may_sync_now(struct drbd_conf *mdev)
 		if (odev->sync_conf.after == -1)
 			return 1;
 		odev = minor_to_mdev(odev->sync_conf.after);
-		ERR_IF(!odev) return 1;
+		if (!expect(odev))
+			return 1;
 		if ((odev->state.conn >= C_SYNC_SOURCE &&
 		     odev->state.conn <= C_PAUSED_SYNC_T) ||
 		    odev->state.aftr_isp || odev->state.peer_isp ||
@@ -1637,7 +1638,7 @@ int drbd_worker(struct drbd_thread *thi)
 		if (intr) {
 			D_ASSERT(intr == -EINTR);
 			flush_signals(current);
-			ERR_IF (get_t_state(thi) == RUNNING)
+			if (!expect(get_t_state(thi) != RUNNING))
 				continue;
 			break;
 		}
@@ -1650,7 +1651,7 @@ int drbd_worker(struct drbd_thread *thi)
 
 		w = NULL;
 		spin_lock_irq(&mdev->data.work.q_lock);
-		ERR_IF(list_empty(&mdev->data.work.q)) {
+		if (!expect(!list_empty(&mdev->data.work.q))) {
 			/* something terribly wrong in our logic.
 			 * we were able to down() the semaphore,
 			 * but the list is empty... doh.
-- 
1.7.4.1

