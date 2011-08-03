Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1HCUOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:14:39 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:50963 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1HCUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:14:33 -0400
Subject: [PATCH] [RFC] CFQ: simplify radix tree lookup in cfq_cic_lookup()
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 03 Aug 2011 22:14:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.3 (3.1.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312402472.22854.16.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Not tested and not signed-off.

1) This is to see whether I understand the cfqd->cic_index usage (at
least, part of it).

2) If the lookup of a cic in the radix tree turned up a "dead" cic, then
that cic will be dropped. There's no reason to again try to lookup that
cic: that lookup should return NULL. (If it doesn't return NULL, we seem
to be in trouble.) So there's no need for a do {[...]} while (1) loop
and this code can be simplified a little.

3) Does this make sense?


Paul Bolle
---
 block/cfq-iosched.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..0d33d8c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3120,22 +3120,20 @@ cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 		return cic;
 	}
 
-	do {
-		cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
-		rcu_read_unlock();
-		if (!cic)
-			break;
-		if (unlikely(cic->key != cfqd)) {
-			cfq_drop_dead_cic(cfqd, ioc, cic);
-			rcu_read_lock();
-			continue;
-		}
+	cic = radix_tree_lookup(&ioc->radix_root, cfqd->cic_index);
+	rcu_read_unlock();
 
-		spin_lock_irqsave(&ioc->lock, flags);
-		rcu_assign_pointer(ioc->ioc_data, cic);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-		break;
-	} while (1);
+	if (!cic)
+		return NULL;
+
+	if (unlikely(cic->key != cfqd)) {
+		cfq_drop_dead_cic(cfqd, ioc, cic);
+		return NULL;
+	}
+
+	spin_lock_irqsave(&ioc->lock, flags);
+	rcu_assign_pointer(ioc->ioc_data, cic);
+	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	return cic;
 }
-- 
1.7.6

