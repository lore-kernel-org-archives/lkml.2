Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070Ab2DKTlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:41:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:24742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760981Ab2DKTko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131319271"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com
Subject: [PATCH 4/4] lib/raid6: cleanup gen_syndrome function selection
Date: Wed, 11 Apr 2012 12:40:31 -0700
Message-Id: <1334173231-28595-5-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorders functions in raid6_algos as well as the preference check
to reduce the number of functions tested on initialization.

Also, creates symmetry between choosing the gen_syndrome functions
and choosing the recovery functions.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/algos.c |  104 +++++++++++++++++++++++++++++------------------------
 1 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 5a7f802..589f5f5 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -34,10 +34,6 @@ struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
 
 const struct raid6_calls * const raid6_algos[] = {
-	&raid6_intx1,
-	&raid6_intx2,
-	&raid6_intx4,
-	&raid6_intx8,
 #if defined(__ia64__)
 	&raid6_intx16,
 	&raid6_intx32,
@@ -61,6 +57,10 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_altivec4,
 	&raid6_altivec8,
 #endif
+	&raid6_intx1,
+	&raid6_intx2,
+	&raid6_intx4,
+	&raid6_intx8,
 	NULL
 };
 
@@ -86,7 +86,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #define time_before(x, y) ((x) < (y))
 #endif
 
-static inline void raid6_choose_recov(void)
+static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 {
 	const struct raid6_recov_calls *const *algo;
 	const struct raid6_recov_calls *best;
@@ -103,62 +103,38 @@ static inline void raid6_choose_recov(void)
 		printk("raid6: using %s recovery algorithm\n", best->name);
 	} else
 		printk("raid6: Yikes! No recovery algorithm found!\n");
-}
-
 
-/* Try to pick the best algorithm */
-/* This code uses the gfmul table as convenient data set to abuse */
+	return best;
+}
 
-int __init raid6_select_algo(void)
+static inline const struct raid6_calls *raid6_choose_gen(
+	void *(*const dptrs)[(65536/PAGE_SIZE)+2], const int disks)
 {
-	const struct raid6_calls * const * algo;
-	const struct raid6_calls * best;
-	char *syndromes;
-	void *dptrs[(65536/PAGE_SIZE)+2];
-	int i, disks;
-	unsigned long perf, bestperf;
-	int bestprefer;
-	unsigned long j0, j1;
-
-	disks = (65536/PAGE_SIZE)+2;
-	for ( i = 0 ; i < disks-2 ; i++ ) {
-		dptrs[i] = ((char *)raid6_gfmul) + PAGE_SIZE*i;
-	}
-
-	/* Normal code - use a 2-page allocation to avoid D$ conflict */
-	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
-
-	if ( !syndromes ) {
-		printk("raid6: Yikes!  No memory available.\n");
-		return -ENOMEM;
-	}
-
-	dptrs[disks-2] = syndromes;
-	dptrs[disks-1] = syndromes + PAGE_SIZE;
+	unsigned long perf, bestperf, j0, j1;
+	const struct raid6_calls *const *algo;
+	const struct raid6_calls *best;
 
-	bestperf = 0;  bestprefer = 0;  best = NULL;
+	for (bestperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
+		if (!best || (*algo)->prefer >= best->prefer) {
+			if ((*algo)->valid && !(*algo)->valid())
+				continue;
 
-	for ( algo = raid6_algos ; *algo ; algo++ ) {
-		if ( !(*algo)->valid || (*algo)->valid() ) {
 			perf = 0;
 
 			preempt_disable();
 			j0 = jiffies;
-			while ( (j1 = jiffies) == j0 )
+			while ((j1 = jiffies) == j0)
 				cpu_relax();
 			while (time_before(jiffies,
 					    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
-				(*algo)->gen_syndrome(disks, PAGE_SIZE, dptrs);
+				(*algo)->gen_syndrome(disks, PAGE_SIZE, *dptrs);
 				perf++;
 			}
 			preempt_enable();
 
-			if ( (*algo)->prefer > bestprefer ||
-			     ((*algo)->prefer == bestprefer &&
-			      perf > bestperf) ) {
-				best = *algo;
-				bestprefer = best->prefer;
+			if (perf > bestperf) {
 				bestperf = perf;
+				best = *algo;
 			}
 			printk("raid6: %-8s %5ld MB/s\n", (*algo)->name,
 			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
@@ -173,12 +149,46 @@ int __init raid6_select_algo(void)
 	} else
 		printk("raid6: Yikes!  No algorithm found!\n");
 
-	free_pages((unsigned long)syndromes, 1);
+	return best;
+}
+
+
+/* Try to pick the best algorithm */
+/* This code uses the gfmul table as convenient data set to abuse */
+
+int __init raid6_select_algo(void)
+{
+	const int disks = (65536/PAGE_SIZE)+2;
+
+	const struct raid6_calls *gen_best;
+	const struct raid6_recov_calls *rec_best;
+	char *syndromes;
+	void *dptrs[(65536/PAGE_SIZE)+2];
+	int i;
+
+	for (i = 0; i < disks-2; i++)
+		dptrs[i] = ((char *)raid6_gfmul) + PAGE_SIZE*i;
+
+	/* Normal code - use a 2-page allocation to avoid D$ conflict */
+	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
+
+	if (!syndromes) {
+		printk("raid6: Yikes!  No memory available.\n");
+		return -ENOMEM;
+	}
+
+	dptrs[disks-2] = syndromes;
+	dptrs[disks-1] = syndromes + PAGE_SIZE;
+
+	/* select raid gen_syndrome function */
+	gen_best = raid6_choose_gen(&dptrs, disks);
 
 	/* select raid recover functions */
-	raid6_choose_recov();
+	rec_best = raid6_choose_recov();
+
+	free_pages((unsigned long)syndromes, 1);
 
-	return best ? 0 : -EINVAL;
+	return gen_best && rec_best ? 0 : -EINVAL;
 }
 
 static void raid6_exit(void)
-- 
1.7.8.5

