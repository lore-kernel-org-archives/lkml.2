Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2KMNhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:37:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab2KMNhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:37:34 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org,
        Michel Lespinasse <walken@google.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        David Laight <david.laight@aculab.com>
Subject: [PATCH v3 01/11] random32: rename random32 to prandom
Date: Tue, 13 Nov 2012 22:37:00 +0900
Message-Id: <1352813830-4624-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
References: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames all random32 functions to have 'prandom_' prefix as follows:

void prandom_seed(u32 seed);	/* rename from srandom32() */
u32 prandom_u32(void);		/* rename from random32() */
void prandom_seed_state(struct rnd_state *state, u64 seed);
				/* rename from prandom32_seed() */
u32 prandom_u32_state(struct rnd_state *state);
				/* rename from prandom32() */

The purpose of this renaming is to prevent some kernel developers from
assuming that prandom32() and random32() might imply that only
prandom32() was the one using a pseudo-random number generator by
prandom32's "p", and the result may be a very embarassing security
exposure.  This concern was expressed by Theodore Ts'o.

And furthermore, I'm going to introduce new functions for getting the
requested number of pseudo-random bytes.  If I continue to use both
prandom32 and random32 prefixes for these functions, the confusion
is getting worse.

As a result of this renaming, "prandom_" is the common prefix for
pseudo-random number library.

Currently, srandom32() and random32() are preserved because it is
difficult to rename too many users at once.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org
Cc: Michel Lespinasse <walken@google.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: David Laight <david.laight@aculab.com>
---
* v3
- change common prefix from 'random32_' to 'prandom_'

 drivers/scsi/fcoe/fcoe_ctlr.c |  4 ++--
 include/linux/random.h        | 17 ++++++++++-----
 lib/interval_tree_test_main.c |  7 ++++---
 lib/random32.c                | 48 +++++++++++++++++++++----------------------
 lib/rbtree_test.c             |  6 +++---
 5 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 2ebe03a..4a909d7 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2144,7 +2144,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 	 */
 	port_id = fip->port_id;
 	if (fip->probe_tries)
-		port_id = prandom32(&fip->rnd_state) & 0xffff;
+		port_id = prandom_u32_state(&fip->rnd_state) & 0xffff;
 	else if (!port_id)
 		port_id = fip->lp->wwpn & 0xffff;
 	if (!port_id || port_id == 0xffff)
@@ -2169,7 +2169,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
 {
 	fip->probe_tries = 0;
-	prandom32_seed(&fip->rnd_state, fip->lp->wwpn);
+	prandom_seed_state(&fip->rnd_state, fip->lp->wwpn);
 	fcoe_ctlr_vn_restart(fip);
 }
 
diff --git a/include/linux/random.h b/include/linux/random.h
index 6330ed4..db6debc 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -25,10 +25,17 @@ extern const struct file_operations random_fops, urandom_fops;
 unsigned int get_random_int(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
-u32 random32(void);
-void srandom32(u32 seed);
+u32 prandom_u32(void);
+void prandom_seed(u32 seed);
 
-u32 prandom32(struct rnd_state *);
+/*
+ * These macros are preserved for backward compatibility and should be
+ * removed as soon as a transition is finished.
+ */
+#define random32() prandom_u32()
+#define srandom32(seed) prandom_seed(seed)
+
+u32 prandom_u32_state(struct rnd_state *);
 
 /*
  * Handle minimum values for seeds
@@ -39,11 +46,11 @@ static inline u32 __seed(u32 x, u32 m)
 }
 
 /**
- * prandom32_seed - set seed for prandom32().
+ * prandom_seed_state - set seed for prandom_u32_state().
  * @state: pointer to state structure to receive the seed.
  * @seed: arbitrary 64-bit value to use as a seed.
  */
-static inline void prandom32_seed(struct rnd_state *state, u64 seed)
+static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
 	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
 
diff --git a/lib/interval_tree_test_main.c b/lib/interval_tree_test_main.c
index b259039..245900b 100644
--- a/lib/interval_tree_test_main.c
+++ b/lib/interval_tree_test_main.c
@@ -30,7 +30,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < NODES; i++) {
-		u32 a = prandom32(&rnd), b = prandom32(&rnd);
+		u32 a = prandom_u32_state(&rnd);
+		u32 b = prandom_u32_state(&rnd);
 		if (a <= b) {
 			nodes[i].start = a;
 			nodes[i].last = b;
@@ -40,7 +41,7 @@ static void init(void)
 		}
 	}
 	for (i = 0; i < SEARCHES; i++)
-		queries[i] = prandom32(&rnd);
+		queries[i] = prandom_u32_state(&rnd);
 }
 
 static int interval_tree_test_init(void)
@@ -51,7 +52,7 @@ static int interval_tree_test_init(void)
 
 	printk(KERN_ALERT "interval tree insert/remove");
 
-	prandom32_seed(&rnd, 3141592653589793238ULL);
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
diff --git a/lib/random32.c b/lib/random32.c
index 938bde5..d1830fa 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -42,13 +42,13 @@
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 /**
- *	prandom32 - seeded pseudo-random number generator.
+ *	prandom_u32_state - seeded pseudo-random number generator.
  *	@state: pointer to state structure holding seeded state.
  *
  *	This is used for pseudo-randomness with no outside seeding.
- *	For more random results, use random32().
+ *	For more random results, use prandom_u32().
  */
-u32 prandom32(struct rnd_state *state)
+u32 prandom_u32_state(struct rnd_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
@@ -58,32 +58,32 @@ u32 prandom32(struct rnd_state *state)
 
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
-EXPORT_SYMBOL(prandom32);
+EXPORT_SYMBOL(prandom_u32_state);
 
 /**
- *	random32 - pseudo random number generator
+ *	prandom_u32 - pseudo random number generator
  *
  *	A 32 bit pseudo-random number is generated using a fast
  *	algorithm suitable for simulation. This algorithm is NOT
  *	considered safe for cryptographic use.
  */
-u32 random32(void)
+u32 prandom_u32(void)
 {
 	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = prandom32(state);
+	r = prandom_u32_state(state);
 	put_cpu_var(state);
 	return r;
 }
-EXPORT_SYMBOL(random32);
+EXPORT_SYMBOL(prandom_u32);
 
 /**
- *	srandom32 - add entropy to pseudo random number generator
+ *	prandom_seed - add entropy to pseudo random number generator
  *	@seed: seed value
  *
- *	Add some additional seeding to the random32() pool.
+ *	Add some additional seeding to the prandom pool.
  */
-void srandom32(u32 entropy)
+void prandom_seed(u32 entropy)
 {
 	int i;
 	/*
@@ -95,13 +95,13 @@ void srandom32(u32 entropy)
 		state->s1 = __seed(state->s1 ^ entropy, 1);
 	}
 }
-EXPORT_SYMBOL(srandom32);
+EXPORT_SYMBOL(prandom_seed);
 
 /*
  *	Generate some initially weak seeding values to allow
- *	to start the random32() engine.
+ *	to start the prandom_u32() engine.
  */
-static int __init random32_init(void)
+static int __init prandom_init(void)
 {
 	int i;
 
@@ -114,22 +114,22 @@ static int __init random32_init(void)
 		state->s3 = __seed(LCG(state->s2), 15);
 
 		/* "warm it up" */
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
 	}
 	return 0;
 }
-core_initcall(random32_init);
+core_initcall(prandom_init);
 
 /*
  *	Generate better values after random number generator
  *	is fully initialized.
  */
-static int __init random32_reseed(void)
+static int __init prandom_reseed(void)
 {
 	int i;
 
@@ -143,8 +143,8 @@ static int __init random32_reseed(void)
 		state->s3 = __seed(seeds[2], 15);
 
 		/* mix it in */
-		prandom32(state);
+		prandom_u32_state(state);
 	}
 	return 0;
 }
-late_initcall(random32_reseed);
+late_initcall(prandom_reseed);
diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 268b239..da96578 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -96,8 +96,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < NODES; i++) {
-		nodes[i].key = prandom32(&rnd);
-		nodes[i].val = prandom32(&rnd);
+		nodes[i].key = prandom_u32_state(&rnd);
+		nodes[i].val = prandom_u32_state(&rnd);
 	}
 }
 
@@ -155,7 +155,7 @@ static int rbtree_test_init(void)
 
 	printk(KERN_ALERT "rbtree testing");
 
-	prandom32_seed(&rnd, 3141592653589793238ULL);
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
-- 
1.7.11.7

