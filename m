Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2GESNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:13:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37006 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2GESMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:12:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 02/10] random: use lockless techniques when mixing entropy pools
Date: Thu,  5 Jul 2012 14:12:05 -0400
Message-Id: <1341511933-11169-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The real-time Linux folks didn't like add_interrupt_randomness()
taking a spinlock since it is called in the low-level interrupt
routine.  Using atomic_t's and cmpxchg is also too expensive on some
of the older architectures.  So we'll bite the bullet and use
ACCESS_ONCE() and smp_rmb()/smp_wmb() to minimize the race windows
when mixing in the entropy pool.

Also, we will use a trylock when trying to increase then entropy
accounting during the interrupt path to avoid taking a spinlock there;
if there is contention, we will simply not credit the entropy count,
thus failing safe.  Thanks to Dan Carpenter for suggesting this
approach.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 53b3e85..789709e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -418,9 +418,9 @@ struct entropy_store {
 	/* read-write data: */
 	spinlock_t lock;
 	unsigned add_ptr;
+	unsigned input_rotate;
 	int entropy_count;
 	int entropy_total;
-	int input_rotate;
 	unsigned int initialized:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
@@ -478,16 +478,16 @@ static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
 	__u32 w;
 	unsigned long flags;
 
-	/* Taps are constant, so we can load them without holding r->lock.  */
 	tap1 = r->poolinfo->tap1;
 	tap2 = r->poolinfo->tap2;
 	tap3 = r->poolinfo->tap3;
 	tap4 = r->poolinfo->tap4;
 	tap5 = r->poolinfo->tap5;
 
-	spin_lock_irqsave(&r->lock, flags);
-	input_rotate = r->input_rotate;
-	i = r->add_ptr;
+	local_irq_save(flags);
+	smp_rmb();
+	input_rotate = ACCESS_ONCE(r->input_rotate);
+	i = ACCESS_ONCE(r->add_ptr);
 
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
@@ -514,19 +514,19 @@ static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
 		input_rotate += i ? 7 : 14;
 	}
 
-	r->input_rotate = input_rotate;
-	r->add_ptr = i;
+	ACCESS_ONCE(r->input_rotate) = input_rotate;
+	ACCESS_ONCE(r->add_ptr) = i;
+	local_irq_restore(flags);
+	smp_wmb();
 
 	if (out)
 		for (j = 0; j < 16; j++)
 			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
-
-	spin_unlock_irqrestore(&r->lock, flags);
 }
 
 static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
 {
-       mix_pool_bytes_extract(r, in, bytes, NULL);
+	mix_pool_bytes_extract(r, in, bytes, NULL);
 }
 
 struct fast_pool {
@@ -558,10 +558,12 @@ static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
 	f->rotate = input_rotate;
 }
 
+#define CREDIT_ENTROPY_BITS_NOWAIT	0x01
+
 /*
  * Credit (or debit) the entropy store with n bits of entropy
  */
-static void credit_entropy_bits(struct entropy_store *r, int nbits)
+static void credit_entropy_bits(struct entropy_store *r, int nbits, int fl)
 {
 	unsigned long flags;
 	int entropy_count;
@@ -569,7 +571,11 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	if (!nbits)
 		return;
 
-	spin_lock_irqsave(&r->lock, flags);
+	if (fl & CREDIT_ENTROPY_BITS_NOWAIT) {
+		if (!spin_trylock_irqsave(&r->lock, flags))
+			return;
+	} else
+		spin_lock_irqsave(&r->lock, flags);
 
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
 	entropy_count = r->entropy_count;
@@ -592,6 +598,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
+
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
@@ -714,7 +721,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		 * and limit entropy entimate to 12 bits.
 		 */
 		credit_entropy_bits(&input_pool,
-				    min_t(int, fls(delta>>1), 11));
+				    min_t(int, fls(delta>>1), 11), 0);
 	}
 out:
 	preempt_enable();
@@ -764,7 +771,7 @@ void add_interrupt_randomness(int irq)
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
 	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
-	credit_entropy_bits(r, 1);
+	credit_entropy_bits(r, 1, CREDIT_ENTROPY_BITS_NOWAIT);
 }
 
 #ifdef CONFIG_BLOCK
@@ -816,7 +823,7 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
 		mix_pool_bytes(r, tmp, bytes);
-		credit_entropy_bits(r, bytes*8);
+		credit_entropy_bits(r, bytes*8, 0);
 	}
 }
 
@@ -1211,7 +1218,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		credit_entropy_bits(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count, 0);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1226,7 +1233,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 				    size);
 		if (retval < 0)
 			return retval;
-		credit_entropy_bits(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count, 0);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
-- 
1.7.11.1.108.gb129051

