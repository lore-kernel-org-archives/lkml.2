Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2GESUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:20:23 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37059 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab2GESUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:20:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 08/10] random: unify mix_pool_bytes() and mix_pool_bytes_entropy()
Date: Thu,  5 Jul 2012 14:12:11 -0400
Message-Id: <1341511933-11169-9-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 63ba944..0423254 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -477,8 +477,8 @@ static __u32 const twist_table[8] = {
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
  */
-static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
-				   int nbytes, __u8 out[64])
+static void mix_pool_bytes(struct entropy_store *r, const void *in,
+			   int nbytes, __u8 out[64])
 {
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
@@ -533,11 +533,6 @@ static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
 			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
 }
 
-static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
-{
-	mix_pool_bytes_extract(r, in, bytes, NULL);
-}
-
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
@@ -673,10 +668,10 @@ void add_device_randomness(const void *buf, unsigned int size)
 {
 	unsigned long time = get_cycles() ^ jiffies;
 
-	mix_pool_bytes(&input_pool, buf, size);
-	mix_pool_bytes(&input_pool, &time, sizeof(time));
-	mix_pool_bytes(&nonblocking_pool, buf, size);
-	mix_pool_bytes(&nonblocking_pool, &time, sizeof(time));
+	mix_pool_bytes(&input_pool, buf, size, NULL);
+	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
+	mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
+	mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
 }
 EXPORT_SYMBOL(add_device_randomness);
 
@@ -710,7 +705,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	sample.jiffies = jiffies;
 	sample.cycles = get_cycles();
 	sample.num = num;
-	mix_pool_bytes(&input_pool, &sample, sizeof(sample));
+	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -794,7 +789,7 @@ void add_interrupt_randomness(int irq)
 	fast_pool->last = now;
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
-	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
+	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
 	credit_entropy_bits(r, 1, CREDIT_ENTROPY_BITS_NOWAIT);
 }
 
@@ -847,14 +842,14 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		mix_pool_bytes(r, tmp, bytes);
+		mix_pool_bytes(r, tmp, bytes, NULL);
 		credit_entropy_bits(r, bytes*8, 0);
 	}
 	for (i = 0; i < 4; i++)
 		if (arch_get_random_int(&hwrand[i]))
 			break;
 	if (i)
-		mix_pool_bytes(r, &hwrand, sizeof(hwrand));
+		mix_pool_bytes(r, &hwrand, sizeof(hwrand), NULL);
 }
 
 /*
@@ -928,7 +923,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	mix_pool_bytes_extract(r, hash, sizeof(hash), extract);
+	mix_pool_bytes(r, hash, sizeof(hash), extract);
 
 	/*
 	 * To avoid duplicates, we atomically extract a portion of the
@@ -1085,13 +1080,13 @@ static void init_std_data(struct entropy_store *r)
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	now = ktime_get_real();
-	mix_pool_bytes(r, &now, sizeof(now));
+	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof flags) {
 		if (!arch_get_random_long(&flags))
 			break;
-		mix_pool_bytes(r, &flags, sizeof(flags));
+		mix_pool_bytes(r, &flags, sizeof(flags), NULL);
 	}
-	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
+	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
 }
 
 static int rand_initialize(void)
@@ -1228,7 +1223,7 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 		count -= bytes;
 		p += bytes;
 
-		mix_pool_bytes(r, buf, bytes);
+		mix_pool_bytes(r, buf, bytes, NULL);
 		cond_resched();
 	}
 
-- 
1.7.11.1.108.gb129051

