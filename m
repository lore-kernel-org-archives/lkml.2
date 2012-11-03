Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2KCPoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 11:44:20 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48484 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab2KCPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 11:44:18 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v2 01/11] random32: rename prandom32 to random32_state
Date: Sun,  4 Nov 2012 00:43:32 +0900
Message-Id: <1351957422-23243-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
References: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames prandom32() and prandom32_seed to randome32_state() and
srandom32_state().  The purpose of this renaming is to prevent some
kernel developers from assuming that prandom32() and random32() might
imply that only prandom32() was the one using a pseudo-random number
generator by prandom32's "p", and the result may be a very embarassing
security exposure.

And furthermore, I'm going to introduce new functions for getting the
requested number of pseudo-random bytes.  If I continue to use both
prandom32 and random32 prefixes for these functions, the confusion
is getting worse.

So as a result of this renaming, "random32" is the common prefix for
random32 library.

Suggested-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org
Cc: Michel Lespinasse <walken@google.com>
---
new patch from v2

 drivers/scsi/fcoe/fcoe_ctlr.c |  4 ++--
 include/linux/random.h        |  6 +++---
 lib/interval_tree_test_main.c |  7 ++++---
 lib/random32.c                | 22 +++++++++++-----------
 lib/rbtree_test.c             |  6 +++---
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 2ebe03a..4f5a207 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2144,7 +2144,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 	 */
 	port_id = fip->port_id;
 	if (fip->probe_tries)
-		port_id = prandom32(&fip->rnd_state) & 0xffff;
+		port_id = random32_state(&fip->rnd_state) & 0xffff;
 	else if (!port_id)
 		port_id = fip->lp->wwpn & 0xffff;
 	if (!port_id || port_id == 0xffff)
@@ -2169,7 +2169,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
 {
 	fip->probe_tries = 0;
-	prandom32_seed(&fip->rnd_state, fip->lp->wwpn);
+	srandom32_state(&fip->rnd_state, fip->lp->wwpn);
 	fcoe_ctlr_vn_restart(fip);
 }
 
diff --git a/include/linux/random.h b/include/linux/random.h
index 6330ed4..bb96f79 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -28,7 +28,7 @@ unsigned long randomize_range(unsigned long start, unsigned long end, unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
-u32 prandom32(struct rnd_state *);
+u32 random32_state(struct rnd_state *);
 
 /*
  * Handle minimum values for seeds
@@ -39,11 +39,11 @@ static inline u32 __seed(u32 x, u32 m)
 }
 
 /**
- * prandom32_seed - set seed for prandom32().
+ * srandom32_state - set seed for random32_state().
  * @state: pointer to state structure to receive the seed.
  * @seed: arbitrary 64-bit value to use as a seed.
  */
-static inline void prandom32_seed(struct rnd_state *state, u64 seed)
+static inline void srandom32_state(struct rnd_state *state, u64 seed)
 {
 	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
 
diff --git a/lib/interval_tree_test_main.c b/lib/interval_tree_test_main.c
index b259039..f44a0e7 100644
--- a/lib/interval_tree_test_main.c
+++ b/lib/interval_tree_test_main.c
@@ -30,7 +30,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < NODES; i++) {
-		u32 a = prandom32(&rnd), b = prandom32(&rnd);
+		u32 a = random32_state(&rnd);
+		u32 b = random32_state(&rnd);
 		if (a <= b) {
 			nodes[i].start = a;
 			nodes[i].last = b;
@@ -40,7 +41,7 @@ static void init(void)
 		}
 	}
 	for (i = 0; i < SEARCHES; i++)
-		queries[i] = prandom32(&rnd);
+		queries[i] = random32_state(&rnd);
 }
 
 static int interval_tree_test_init(void)
@@ -51,7 +52,7 @@ static int interval_tree_test_init(void)
 
 	printk(KERN_ALERT "interval tree insert/remove");
 
-	prandom32_seed(&rnd, 3141592653589793238ULL);
+	srandom32_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
diff --git a/lib/random32.c b/lib/random32.c
index 938bde5..7a3e0c7 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -42,13 +42,13 @@
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 /**
- *	prandom32 - seeded pseudo-random number generator.
+ *	random32_state - seeded pseudo-random number generator.
  *	@state: pointer to state structure holding seeded state.
  *
  *	This is used for pseudo-randomness with no outside seeding.
  *	For more random results, use random32().
  */
-u32 prandom32(struct rnd_state *state)
+u32 random32_state(struct rnd_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
@@ -58,7 +58,7 @@ u32 prandom32(struct rnd_state *state)
 
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
-EXPORT_SYMBOL(prandom32);
+EXPORT_SYMBOL(random32_state);
 
 /**
  *	random32 - pseudo random number generator
@@ -71,7 +71,7 @@ u32 random32(void)
 {
 	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = prandom32(state);
+	r = random32_state(state);
 	put_cpu_var(state);
 	return r;
 }
@@ -114,12 +114,12 @@ static int __init random32_init(void)
 		state->s3 = __seed(LCG(state->s2), 15);
 
 		/* "warm it up" */
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
+		random32_state(state);
+		random32_state(state);
+		random32_state(state);
+		random32_state(state);
+		random32_state(state);
+		random32_state(state);
 	}
 	return 0;
 }
@@ -143,7 +143,7 @@ static int __init random32_reseed(void)
 		state->s3 = __seed(seeds[2], 15);
 
 		/* mix it in */
-		prandom32(state);
+		random32_state(state);
 	}
 	return 0;
 }
diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 268b239..f144d82 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -96,8 +96,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < NODES; i++) {
-		nodes[i].key = prandom32(&rnd);
-		nodes[i].val = prandom32(&rnd);
+		nodes[i].key = random32_state(&rnd);
+		nodes[i].val = random32_state(&rnd);
 	}
 }
 
@@ -155,7 +155,7 @@ static int rbtree_test_init(void)
 
 	printk(KERN_ALERT "rbtree testing");
 
-	prandom32_seed(&rnd, 3141592653589793238ULL);
+	srandom32_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
-- 
1.7.11.7

