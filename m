Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1HVKSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:18:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22667 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab1HVKRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:17:40 -0400
Subject: [PATCH 1/2] vmscan: fix initial shrinker size handling
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 22 Aug 2011 14:17:21 +0300
Message-ID: <20110822101721.19462.63082.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.

Also make total_scan signed, otherwise check (total_scan < 0) below never works.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 29b3612..f174561 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -248,14 +248,18 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
-		unsigned long total_scan;
-		unsigned long max_pass;
+		long total_scan;
+		long max_pass;
 		int shrink_ret = 0;
 		long nr;
 		long new_nr;
 		long batch_size = shrinker->batch ? shrinker->batch
 						  : SHRINK_BATCH;
 
+		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		if (max_pass <= 0)
+			continue;
+
 		/*
 		 * copy the current shrinker scan count into a local variable
 		 * and zero it so that other concurrent shrinker invocations
@@ -266,7 +270,6 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
 
 		total_scan = nr;
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);

