Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0CWSY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:24:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:18206 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0CWSYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:24:55 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB+kqEurRN+J/2dsb2JhbACDCpgec6RHiDGQc4EsgmdqBIMe
X-IronPort-AV: E=Sophos;i="4.51,296,1267401600"; 
   d="scan'208";a="501574800"
From: Joe Eykholt <jeykholt@cisco.com>
Subject: [RFC PATCH] lib/random32: export pseudo-random number generator for
	modules
To: linux-kernel@vger.kernel.org
Date: Tue, 23 Mar 2010 11:24:54 -0700
Message-ID: <20100323182454.5530.91279.stgit@savbu-fcoe15.cisco.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the definition of struct rnd_state to linux/random.h
and adds the functions prandom32() and prandom32_seed().

The former just calls the static __random32() which returns the
next pseudo-random value given a state structure.  The latter
seeds a private state structure from a u64.

For FCoE FC-BB-6 VN2VN mode self-selected unique FC address generation,
we need an pseudo-random number generator seeded with the 64-bit
world-wide port name.  A truly random generator or one seeded with
randomness won't do because the same sequence of numbers should
be generated each time we boot.  This provides that without disturbing
existing functionality.

For lower cost, we could rename or export the existing __random32(),
and inline the seeding function so it wouldn't consume text space
in the base kernel, just in the module.  That would also require
moving the little __seed() function to random.h.  I elected not
to do that to keep the patch small.

Please include me in replies.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)


diff --git a/include/linux/random.h b/include/linux/random.h
index 25d02fe..9b11998 100644
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
@@ -74,6 +78,9 @@ unsigned long randomize_range(unsigned long start, unsigned long end, unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
+u32 prandom32(struct rnd_state *);
+void prandom32_seed(struct rnd_state *, u64);
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
diff --git a/lib/random32.c b/lib/random32.c
index 217d5c4..f5ba81e 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -39,10 +39,6 @@
 #include <linux/jiffies.h>
 #include <linux/random.h>
 
-struct rnd_state {
-	u32 s1, s2, s3;
-};
-
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 static u32 __random32(struct rnd_state *state)
@@ -101,6 +97,36 @@ void srandom32(u32 entropy)
 }
 EXPORT_SYMBOL(srandom32);
 
+/**
+ *	prandom32 - seeded pseudo-random number generator.
+ *	@state: pointer to state structure holding seeded state.
+ *
+ *	This is used when very controlled pseudo-randomness,
+ *	with no outside seeding, is desired by some subsystem.
+ */
+u32 prandom32(struct rnd_state *state)
+{
+	return __random32(state);
+}
+EXPORT_SYMBOL(prandom32);
+
+/**
+ *	prandom32_seed - set seed for prandom32().
+ *	@state: pointer to state structure to receive the seed.
+ *	@seed: arbitrary 64-bit value to use as a seed.
+ *
+ *	This is to hide the organization of the rnd_state from a subsystem
+ *	wanting to initialize it.  The behavior shouldn't be changed
+ *	since subsystems may depend on it.
+ */
+void prandom32_seed(struct rnd_state *state, u64 seed)
+{
+	state->s1 = __seed((u32)(seed >> 32), 1);
+	state->s2 = __seed((u32)(seed >> 16), 7);
+	state->s3 = __seed((u32)seed, 15);
+}
+EXPORT_SYMBOL(prandom32_seed);
+
 /*
  *	Generate some initially weak seeding values to allow
  *	to start the random32() engine.


