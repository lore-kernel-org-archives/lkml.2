Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2BBBnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:43:52 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41910 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2BBBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:23 -0500
Subject: [RFC PATCH 13/14] sched: make __update_entity_runnable_avg() fast
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:27 -0800
Message-ID: <20120202013827.20844.30497.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__update_entity_runnable_avg forms the core of maintaining an entity's runnable
load average.  In this function we charge the accumulated run-time since last
update and handle appropriate decay.  In some cases, e.g. a waking task, this
time interval may be much larger than our period unit.

Fortunately we can exploit some properties of our series to perform decay for a
blocked update in constant time and account the contribution for a running
update in essentially-constant* time.

[*]: For any running entity they should be performing updates at the tick which
gives us a soft limit of 1 jiffy between updates, and we can compute up to a
32 jiffy update in a single pass.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |  100 ++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 82 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9e2c9a4..ad524bb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -896,17 +896,77 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 /*
+ * We choose a half-life close to 1 scheduling period.
+ * Note: The tables below are dependent on this value.
+ */
+#define LOAD_AVG_PERIOD 32
+
+/* Precomputed fixed inverse multiplies for multiplication by y^n */
+const static u32 runnable_avg_yN_inv[] = {
+	0xffffffff,0xfa83b2db,0xf5257d15,0xefe4b99b,0xeac0c6e7,0xe5b906e7,
+	0xe0ccdeec,0xdbfbb797,0xd744fcca,0xd2a81d91,0xce248c15,0xc9b9bd86,
+	0xc5672a11,0xc12c4cca,0xbd08a39f,0xb8fbaf47,0xb504f333,0xb123f581,
+	0xad583eea,0xa9a15ab4,0xa5fed6a9,0xa2704303,0x9ef53260,0x9b8d39b9,
+	0x9837f051,0x94f4efa8,0x91c3d373,0x8ea4398b,0x8b95c1e3,0x88980e80,
+	0x85aac367,0x82cd8698,
+};
+
+/* Precomputed \Sum y^k { 1<=k<=n } */
+const static u32 runnable_avg_yN_sum[] = {
+	    0, 1002, 1982, 2941, 3880, 4798, 5697, 6576, 7437, 8279, 9103,
+	 9909,10698,11470,12226,12966,13690,14398,15091,15769,16433,17082,
+	17718,18340,18949,19545,20128,20698,21256,21802,22336,22859,23371,
+};
+
+/*
  * Approximate:
  *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
  */
 static __always_inline u64 decay_load(u64 val, int n)
 {
-	for (;n && val;n--) {
-		val *= 4008;
-		val >>= 12;
+	if (!n)
+		return val;
+
+	/*
+	 * As y^PERIOD = 1/2, we can combine
+	 *    y^n = 1/2^(n/PERIOD) * k^(n%PERIOD)
+	 * With a look-up table which covers k^n (n<PERIOD)
+	 *
+	 * To achieve constant time decay_load.
+	 */
+	if (unlikely(n >= LOAD_AVG_PERIOD)) {
+		val >>= n/LOAD_AVG_PERIOD;
+		n %= LOAD_AVG_PERIOD;
 	}
 
-	return val;
+	val *= runnable_avg_yN_inv[n];
+	return SRR(val, 32);
+}
+
+/*
+ * For updates fully spanning n periods, the contribution to runnable
+ * average will be: \Sum 1024*y^n
+ *
+ * We can compute this reasonably efficiently by combining:
+ *   y^PERIOD = 1/2 with precomputed \Sum 1024*y^n {for  n <PERIOD}
+ */
+static u32 __compute_runnable_contrib(int n)
+{
+	u32 contrib = 0;
+
+	if (likely(n<=LOAD_AVG_PERIOD))
+		return runnable_avg_yN_sum[n];
+
+	/* Compute \Sum k^n combining precomputed values for k^i, \Sum k^j */
+	do {
+		contrib /= 2; /* y^LOAD_AVG_PERIOD = 1/2 */
+		contrib += runnable_avg_yN_sum[LOAD_AVG_PERIOD];
+
+		n -= LOAD_AVG_PERIOD;
+	} while (n>LOAD_AVG_PERIOD);
+
+	contrib = decay_load(contrib, n);
+	return contrib + runnable_avg_yN_sum[n];
 }
 
 /* We can represent the historical contribution to runnable average as the
@@ -940,6 +1000,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 							int runnable)
 {
 	u64 delta;
+	u32 periods, runnable_contrib;
 	int delta_w, decayed = 0;
 
 	delta = now - sa->last_runnable_update;
@@ -963,20 +1024,23 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		decayed = 1;
 
 		delta_w = 1024 - delta_w;
-		BUG_ON(delta_w > delta);
-		do {
-			if (runnable)
-				sa->runnable_avg_sum += delta_w;
-			sa->runnable_avg_period += delta_w;
-
-			sa->runnable_avg_sum =
-				decay_load(sa->runnable_avg_sum, 1);
-			sa->runnable_avg_period =
-				decay_load(sa->runnable_avg_period, 1);
-
-			delta -= delta_w;
-			delta_w = 1024;
-		} while (delta >= 1024);
+		if (runnable)
+			sa->runnable_avg_sum += delta_w;
+		sa->runnable_avg_period += delta_w;
+
+		delta -= delta_w;
+		periods = delta / 1024;
+		delta %= 1024;
+
+		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
+						  periods + 1);
+		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
+						  periods + 1);
+
+		runnable_contrib = __compute_runnable_contrib(periods);
+		if (runnable)
+			sa->runnable_avg_sum += runnable_contrib;
+		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	if (runnable)


