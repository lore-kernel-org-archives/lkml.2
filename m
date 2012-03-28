Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2C1Arl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:47:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:31868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2C1Arj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146597547"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        axboe@kernel.dk
Subject: [PATCH 01/13] block: use lockdep_assert_held for queue locking
Date: Tue, 27 Mar 2012 17:47:05 -0700
Message-Id: <1332895637-32572-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Instead of an ugly open coded variant.

Cc: axboe@kernel.dk
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 block/blk-throttle.c   |    2 +-
 include/linux/blkdev.h |   18 +++++++-----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5eed6a7..f2ddb94 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1218,7 +1218,7 @@ void blk_throtl_drain(struct request_queue *q)
 	struct bio_list bl;
 	struct bio *bio;
 
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	bio_list_init(&bl);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 606cf33..2aa2466 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -426,14 +426,10 @@ struct request_queue {
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
 				 (1 << QUEUE_FLAG_ADD_RANDOM))
 
-static inline int queue_is_locked(struct request_queue *q)
+static inline void queue_lockdep_assert_held(struct request_queue *q)
 {
-#ifdef CONFIG_SMP
-	spinlock_t *lock = q->queue_lock;
-	return lock && spin_is_locked(lock);
-#else
-	return 1;
-#endif
+	if (q->queue_lock)
+		lockdep_assert_held(q->queue_lock);
 }
 
 static inline void queue_flag_set_unlocked(unsigned int flag,
@@ -445,7 +441,7 @@ static inline void queue_flag_set_unlocked(unsigned int flag,
 static inline int queue_flag_test_and_clear(unsigned int flag,
 					    struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	if (test_bit(flag, &q->queue_flags)) {
 		__clear_bit(flag, &q->queue_flags);
@@ -458,7 +454,7 @@ static inline int queue_flag_test_and_clear(unsigned int flag,
 static inline int queue_flag_test_and_set(unsigned int flag,
 					  struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	if (!test_bit(flag, &q->queue_flags)) {
 		__set_bit(flag, &q->queue_flags);
@@ -470,7 +466,7 @@ static inline int queue_flag_test_and_set(unsigned int flag,
 
 static inline void queue_flag_set(unsigned int flag, struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 	__set_bit(flag, &q->queue_flags);
 }
 
@@ -487,7 +483,7 @@ static inline int queue_in_flight(struct request_queue *q)
 
 static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 	__clear_bit(flag, &q->queue_flags);
 }
 
-- 
1.7.7.6

