Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0CZBJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:09:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11437 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0CZBJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:09:41 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAumq0urRN+K/2dsb2JhbACDGZgRc6UUiDmQWIErgmhqBIMe
X-IronPort-AV: E=Sophos;i="4.51,310,1267401600"; 
   d="scan'208";a="503112294"
From: Joe Eykholt <jeykholt@cisco.com>
Subject: [PATCH] lib/random32: export pseudo-random number generator for
	modules
To: linux-kernel@vger.kernel.org
Date: Thu, 25 Mar 2010 18:09:41 -0700
Message-ID: <20100326010940.3802.18525.stgit@savbu-fcoe15.cisco.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the definition of struct rnd_state and the
inline __seed() function to linux/random.h.  It renames the
static __random32() function to prandom32() and exports it
for use in modules.

prandom32() is useful as a privately-seeded pseudo random number
generator that can give the same result every time it is initialized.

For FCoE FC-BB-6 VN2VN mode self-selected unique FC address generation,
we need an pseudo-random number generator seeded with the 64-bit
world-wide port name.  A truly random generator or one seeded with
randomness won't do because the same sequence of numbers should
be generated each time we boot or the link comes up.

A prandom32_seed() inline function is added to the header file.
It is inlined not for speed, but so the function won't be
expanded in the base kernel, but only in the module that uses it.

Please include me in any e-mail replies.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 include/linux/random.h |   28 ++++++++++++++++++++++++++++
 lib/random32.c         |   38 +++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 21 deletions(-)


diff --git a/include/linux/random.h b/include/linux/random.h
index 25d02fe..fb7ab9d 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -40,6 +40,10 @@ struct rand_pool_info {
 	__u32	buf[0];
 };
 
+struct rnd_state {
+	__u32 s1, s2, s3;
+};
+
 /* Exported functions */
 
 #ifdef __KERNEL__
@@ -74,6 +78,30 @@ unsigned long randomize_range(unsigned long start, unsigned long end, unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
+u32 prandom32(struct rnd_state *);
+
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
+{
+	return (x < m) ? x + m : x;
+}
+
+/**
+ * prandom32_seed - set seed for prandom32().
+ * @state: pointer to state structure to receive the seed.
+ * @seed: arbitrary 64-bit value to use as a seed.
+ */
+static inline void prandom32_seed(struct rnd_state *state, u64 seed)
+{
+	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+
+	state->s1 = __seed(i, 1);
+	state->s2 = __seed(i, 7);
+	state->s3 = __seed(i, 15);
+}
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
diff --git a/lib/random32.c b/lib/random32.c
index 217d5c4..870dc3f 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -39,13 +39,16 @@
 #include <linux/jiffies.h>
 #include <linux/random.h>
 
-struct rnd_state {
-	u32 s1, s2, s3;
-};
-
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
-static u32 __random32(struct rnd_state *state)
+/**
+ *	prandom32 - seeded pseudo-random number generator.
+ *	@state: pointer to state structure holding seeded state.
+ *
+ *	This is used for pseudo-randomness with no outside seeding.
+ *	For more random results, use random32().
+ */
+u32 prandom32(struct rnd_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
@@ -55,14 +58,7 @@ static u32 __random32(struct rnd_state *state)
 
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
-
-/*
- * Handle minimum values for seeds
- */
-static inline u32 __seed(u32 x, u32 m)
-{
-	return (x < m) ? x + m : x;
-}
+EXPORT_SYMBOL(prandom32);
 
 /**
  *	random32 - pseudo random number generator
@@ -75,7 +71,7 @@ u32 random32(void)
 {
 	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = __random32(state);
+	r = prandom32(state);
 	put_cpu_var(state);
 	return r;
 }
@@ -118,12 +114,12 @@ static int __init random32_init(void)
 		state->s3 = __seed(LCG(state->s2), 15);
 
 		/* "warm it up" */
-		__random32(state);
-		__random32(state);
-		__random32(state);
-		__random32(state);
-		__random32(state);
-		__random32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
 	}
 	return 0;
 }
@@ -147,7 +143,7 @@ static int __init random32_reseed(void)
 		state->s3 = __seed(seeds[2], 15);
 
 		/* mix it in */
-		__random32(state);
+		prandom32(state);
 	}
 	return 0;
 }


