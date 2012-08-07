Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2HGDyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:54:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59627 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757281Ab2HGDiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:11 -0400
Message-Id: <20120807032758.818646584@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>
Subject: [ 19/70] random: use the arch-specific rng in xfer_secondary_pool
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit e6d4947b12e8ad947add1032dd754803c6004824 upstream.

If the CPU supports a hardware random number generator, use it in
xfer_secondary_pool(), where it will significantly improve things and
where we can afford it.

Also, remove the use of the arch-specific rng in
add_timer_randomness(), since the call is significantly slower than
get_cycles(), and we're much better off using it in
xfer_secondary_pool() anyway.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index df3358a..f67ae3e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -254,6 +254,7 @@
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
 #include <linux/ptrace.h>
+#include <linux/kmemcheck.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
@@ -702,11 +703,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-
-	/* Use arch random value, fall back to cycles */
-	if (!arch_get_random_int(&sample.cycles))
-		sample.cycles = get_cycles();
-
+	sample.cycles = get_cycles();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -838,7 +835,11 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
  */
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32 tmp[OUTPUT_POOL_WORDS];
+	union {
+		__u32	tmp[OUTPUT_POOL_WORDS];
+		long	hwrand[4];
+	} u;
+	int	i;
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
@@ -849,17 +850,23 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		/* pull at least as many as BYTES as wakeup BITS */
 		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
 		/* but never more than the buffer size */
-		bytes = min_t(int, bytes, sizeof(tmp));
+		bytes = min_t(int, bytes, sizeof(u.tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%d of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
-		bytes = extract_entropy(r->pull, tmp, bytes,
+		bytes = extract_entropy(r->pull, u.tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		mix_pool_bytes(r, tmp, bytes, NULL);
+		mix_pool_bytes(r, u.tmp, bytes, NULL);
 		credit_entropy_bits(r, bytes*8);
 	}
+	kmemcheck_mark_initialized(&u.hwrand, sizeof(u.hwrand));
+	for (i = 0; i < 4; i++)
+		if (arch_get_random_long(&u.hwrand[i]))
+			break;
+	if (i)
+		mix_pool_bytes(r, &u.hwrand, sizeof(u.hwrand), 0);
 }
 
 /*


