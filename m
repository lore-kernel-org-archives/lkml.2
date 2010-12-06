Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0LFRRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:17:03 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:27297 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753894Ab0LFRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7lwOv.IVM1nSxe_mEefvMCfVHJjmxNvn5lmsXvhurYbTdu_
 lSjKIZIyHICulUJCJkr8jckC4FiRPpW3VnZQKajTuerio31gAahU_TU_.9T8
 Uuoibqmzxy1sJcYReiRnAnRAt91D0x04A2MAkKTVUcE88KjZzUBsiCYO7NKU
 9wby5MMzWrRJcAQrjp4QYoVfT7Nuy9vGJzUK0vHSD6VDsn7b2jS7ss022_Eh
 73uboEHVZyFfIPwFqYgaxHvKuLI02P3sCZLjFKJnkkTYSsGbEhScnHtxgY8D
 zpRwfQTmQy2iHtxj.Xz3i
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171642.042645708@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:28 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@lst.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 10/11] fs: Use this_cpu_xx operations in buffer.c
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize various per cpu area operations through the new this cpu
operations. These operations avoid address calculations through the use
of segment prefixes avoid multiple memory references through RMW
instructions etc.

Reduces code size:

Before:

christoph@linux-2.6$ size fs/buffer.o
   text	   data	    bss	    dec	    hex	filename
  19169	     80	     28	  19277	   4b4d	fs/buffer.o

After:

christoph@linux-2.6$ size fs/buffer.o
   text	   data	    bss	    dec	    hex	filename
  19138	     80	     28	  19246	   4b2e	fs/buffer.o

V3->V4:
	- Move the use of this_cpu_inc_return into a later patch so that
	  this one can go in without percpu infrastructure changes.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 fs/buffer.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2010-11-30 09:41:30.000000000 -0600
+++ linux-2.6/fs/buffer.c	2010-11-30 09:55:55.000000000 -0600
@@ -1270,12 +1270,10 @@ static inline void check_irqs_on(void)
 static void bh_lru_install(struct buffer_head *bh)
 {
 	struct buffer_head *evictee = NULL;
-	struct bh_lru *lru;
 
 	check_irqs_on();
 	bh_lru_lock();
-	lru = &__get_cpu_var(bh_lrus);
-	if (lru->bhs[0] != bh) {
+	if (__this_cpu_read(bh_lrus.bhs[0]) != bh) {
 		struct buffer_head *bhs[BH_LRU_SIZE];
 		int in;
 		int out = 0;
@@ -1283,7 +1281,8 @@ static void bh_lru_install(struct buffer
 		get_bh(bh);
 		bhs[out++] = bh;
 		for (in = 0; in < BH_LRU_SIZE; in++) {
-			struct buffer_head *bh2 = lru->bhs[in];
+			struct buffer_head *bh2 =
+				__this_cpu_read(bh_lrus.bhs[in]);
 
 			if (bh2 == bh) {
 				__brelse(bh2);
@@ -1298,7 +1297,7 @@ static void bh_lru_install(struct buffer
 		}
 		while (out < BH_LRU_SIZE)
 			bhs[out++] = NULL;
-		memcpy(lru->bhs, bhs, sizeof(bhs));
+		memcpy(__this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
 	}
 	bh_lru_unlock();
 
@@ -1313,23 +1312,22 @@ static struct buffer_head *
 lookup_bh_lru(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *ret = NULL;
-	struct bh_lru *lru;
 	unsigned int i;
 
 	check_irqs_on();
 	bh_lru_lock();
-	lru = &__get_cpu_var(bh_lrus);
 	for (i = 0; i < BH_LRU_SIZE; i++) {
-		struct buffer_head *bh = lru->bhs[i];
+		struct buffer_head *bh = __this_cpu_read(bh_lrus.bhs[i]);
 
 		if (bh && bh->b_bdev == bdev &&
 				bh->b_blocknr == block && bh->b_size == size) {
 			if (i) {
 				while (i) {
-					lru->bhs[i] = lru->bhs[i - 1];
+					__this_cpu_write(bh_lrus.bhs[i],
+						__this_cpu_read(bh_lrus.bhs[i - 1]));
 					i--;
 				}
-				lru->bhs[0] = bh;
+				__this_cpu_write(bh_lrus.bhs[0], bh);
 			}
 			get_bh(bh);
 			ret = bh;
@@ -3203,22 +3201,23 @@ static void recalc_bh_state(void)
 	int i;
 	int tot = 0;
 
-	if (__get_cpu_var(bh_accounting).ratelimit++ < 4096)
+	if (__get_cpu_var(bh_accounting).ratelimit++ < 4096)
 		return;
-	__get_cpu_var(bh_accounting).ratelimit = 0;
+	__this_cpu_write(bh_accounting.ratelimit, 0);
 	for_each_online_cpu(i)
 		tot += per_cpu(bh_accounting, i).nr;
 	buffer_heads_over_limit = (tot > max_buffer_heads);
 }
-	
+
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
 	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
-		get_cpu_var(bh_accounting).nr++;
+		preempt_disable();
+		__this_cpu_inc(bh_accounting.nr);
 		recalc_bh_state();
-		put_cpu_var(bh_accounting);
+		preempt_enable();
 	}
 	return ret;
 }
@@ -3228,9 +3227,10 @@ void free_buffer_head(struct buffer_head
 {
 	BUG_ON(!list_empty(&bh->b_assoc_buffers));
 	kmem_cache_free(bh_cachep, bh);
-	get_cpu_var(bh_accounting).nr--;
+	preempt_disable();
+	__this_cpu_dec(bh_accounting.nr);
 	recalc_bh_state();
-	put_cpu_var(bh_accounting);
+	preempt_enable();
 }
 EXPORT_SYMBOL(free_buffer_head);
 
@@ -3243,9 +3243,8 @@ static void buffer_exit_cpu(int cpu)
 		brelse(b->bhs[i]);
 		b->bhs[i] = NULL;
 	}
-	get_cpu_var(bh_accounting).nr += per_cpu(bh_accounting, cpu).nr;
+	this_cpu_add(bh_accounting.nr, per_cpu(bh_accounting, cpu).nr);
 	per_cpu(bh_accounting, cpu).nr = 0;
-	put_cpu_var(bh_accounting);
 }
 
 static int buffer_cpu_notify(struct notifier_block *self,

