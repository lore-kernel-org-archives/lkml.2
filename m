Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1HCSzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:55:00 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:58406 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1HCSyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:54:54 -0400
Subject: [PATCH] CFQ: clarify cleverness regarding cic->key
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 20:54:50 +0200
Message-ID: <1312397690.30457.10.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add (and edit) a few comments to make the cleverness regarding cic->key
more obvious.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Not even compile tested.

1) It seems I ran into another CFQ corner case again. This forces me to
study this code once more. I found the clever dual use of cic->key
rather non-obvious. But perhaps this is a common idiom. Anyhow, are
these comments too verbose? 

 block/cfq-iosched.c       |   11 +++++++++--
 include/linux/iocontext.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..c1618dd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -480,6 +480,10 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 #define CIC_DEAD_KEY	1ul
 #define CIC_DEAD_INDEX_SHIFT	1
 
+/*
+ * We mangle cic_index so it will always be an odd number, and then cast it to
+ * a void pointer, so it can never be a valid pointer to a struct cfq_data.
+ */
 static inline void *cfqd_dead_key(struct cfq_data *cfqd)
 {
 	return (void *)(cfqd->cic_index << CIC_DEAD_INDEX_SHIFT | CIC_DEAD_KEY);
@@ -489,6 +493,8 @@ static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic->key;
 
+	/* if this is an odd number it can't be valid a pointer to a
+	 * struct cfq_data, so this must be dead cic */
 	if (unlikely((unsigned long) cfqd & CIC_DEAD_KEY))
 		return NULL;
 
@@ -2708,6 +2714,7 @@ static void cic_free_func(struct io_context *ioc, struct cfq_io_context *cic)
 	BUG_ON(!(dead_key & CIC_DEAD_KEY));
 
 	spin_lock_irqsave(&ioc->lock, flags);
+	/* we must demangle dead_key into a valid radix tree index again */
 	radix_tree_delete(&ioc->radix_root, dead_key >> CIC_DEAD_INDEX_SHIFT);
 	hlist_del_rcu(&cic->cic_list);
 	spin_unlock_irqrestore(&ioc->lock, flags);
@@ -3141,8 +3148,8 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 }
 
 /*
- * Add cic into ioc, using cfqd as the search key. This enables us to lookup
- * the process specific cfq io context when entered from the block layer.
+ * Add cic into ioc, using cic_index as the search key. This enables us to
+ * lookup the process specific cfq io context when entered from the block layer.
  * Also adds the cic to a per-cfqd list, used when this queue is removed.
  */
 static int cfq_cic_link(struct cfq_data *cfqd, struct io_context *ioc,
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 5037a0a..a7f2c83 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -14,6 +14,8 @@ struct cfq_ttime {
 };
 
 struct cfq_io_context {
+	/* either a valid pointer to a struct cfq_data or a (mangled) index
+	 * to io_context->radix_root */
 	void *key;
 
 	struct cfq_queue *cfqq[2];
-- 
1.7.4.4

