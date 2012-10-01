Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab2JAXBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35375 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941Ab2JAXBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:38 -0400
Message-Id: <20121001225204.733697078@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 168/180] random: use lockless techniques in the interrupt path
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 902c098a3663de3fa18639efbb71b6080f0bcd3c upstream.

The real-time Linux folks don't like add_interrupt_randomness() taking
a spinlock since it is called in the low-level interrupt routine.
This also allows us to reduce the overhead in the fast path, for the
random driver, which is the interrupt collection path.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |   78 ++++++++++++++++++++++++------------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 30eae12..d7135b9 100644
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
@@ -468,26 +468,24 @@ static __u32 const twist_table[8] = {
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
  */
-static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
-				   int nbytes, __u8 out[64])
+static void __mix_pool_bytes(struct entropy_store *r, const void *in,
+			     int nbytes, __u8 out[64])
 {
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
 	const char *bytes = in;
 	__u32 w;
-	unsigned long flags;
 
-	/* Taps are constant, so we can load them without holding r->lock.  */
 	tap1 = r->poolinfo->tap1;
 	tap2 = r->poolinfo->tap2;
 	tap3 = r->poolinfo->tap3;
 	tap4 = r->poolinfo->tap4;
 	tap5 = r->poolinfo->tap5;
 
-	spin_lock_irqsave(&r->lock, flags);
-	input_rotate = r->input_rotate;
-	i = r->add_ptr;
+	smp_rmb();
+	input_rotate = ACCESS_ONCE(r->input_rotate);
+	i = ACCESS_ONCE(r->add_ptr);
 
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
@@ -514,19 +512,23 @@ static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
 		input_rotate += i ? 7 : 14;
 	}
 
-	r->input_rotate = input_rotate;
-	r->add_ptr = i;
+	ACCESS_ONCE(r->input_rotate) = input_rotate;
+	ACCESS_ONCE(r->add_ptr) = i;
+	smp_wmb();
 
 	if (out)
 		for (j = 0; j < 16; j++)
 			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
-
-	spin_unlock_irqrestore(&r->lock, flags);
 }
 
-static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
+static void mix_pool_bytes(struct entropy_store *r, const void *in,
+			     int nbytes, __u8 out[64])
 {
-       mix_pool_bytes_extract(r, in, bytes, NULL);
+	unsigned long flags;
+
+	spin_lock_irqsave(&r->lock, flags);
+	__mix_pool_bytes(r, in, nbytes, out);
+	spin_unlock_irqrestore(&r->lock, flags);
 }
 
 struct fast_pool {
@@ -564,23 +566,22 @@ static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
  */
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
-	unsigned long flags;
-	int entropy_count;
+	int entropy_count, orig;
 
 	if (!nbits)
 		return;
 
-	spin_lock_irqsave(&r->lock, flags);
-
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
-	entropy_count = r->entropy_count;
+retry:
+	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	entropy_count += nbits;
 	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
 		entropy_count = 0;
 	} else if (entropy_count > r->poolinfo->POOLBITS)
 		entropy_count = r->poolinfo->POOLBITS;
-	r->entropy_count = entropy_count;
+	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+		goto retry;
 
 	if (!r->initialized && nbits > 0) {
 		r->entropy_total += nbits;
@@ -593,7 +594,6 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
-	spin_unlock_irqrestore(&r->lock, flags);
 }
 
 /*********************************************************************
@@ -680,7 +680,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		sample.cycles = get_cycles();
 
 	sample.num = num;
-	mix_pool_bytes(&input_pool, &sample, sizeof(sample));
+	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -764,7 +764,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	fast_pool->last = now;
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
-	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
+	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
 	/*
 	 * If we don't have a valid cycle counter, and we see
 	 * back-to-back timer interrupts, then skip giving credit for
@@ -829,7 +829,7 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		mix_pool_bytes(r, tmp, bytes);
+		mix_pool_bytes(r, tmp, bytes, NULL);
 		credit_entropy_bits(r, bytes*8);
 	}
 }
@@ -890,9 +890,11 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	int i;
 	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
 	__u8 extract[64];
+	unsigned long flags;
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
+	spin_lock_irqsave(&r->lock, flags);
 	for (i = 0; i < r->poolinfo->poolwords; i += 16)
 		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
 
@@ -905,7 +907,8 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	mix_pool_bytes_extract(r, hash, sizeof(hash), extract);
+	__mix_pool_bytes(r, hash, sizeof(hash), extract);
+	spin_unlock_irqrestore(&r->lock, flags);
 
 	/*
 	 * To avoid duplicates, we atomically extract a portion of the
@@ -928,11 +931,10 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 }
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, int min, int reserved)
+				 size_t nbytes, int min, int reserved)
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
-	unsigned long flags;
 
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
@@ -941,6 +943,8 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 		extract_buf(r, tmp);
 
 		if (fips_enabled) {
+			unsigned long flags;
+
 			spin_lock_irqsave(&r->lock, flags);
 			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
 				panic("Hardware RNG duplicated output!\n");
@@ -1034,22 +1038,18 @@ EXPORT_SYMBOL(get_random_bytes);
 static void init_std_data(struct entropy_store *r)
 {
 	int i;
-	ktime_t now;
-	unsigned long flags;
+	ktime_t now = ktime_get_real();
+	unsigned long rv;
 
-	spin_lock_irqsave(&r->lock, flags);
 	r->entropy_count = 0;
 	r->entropy_total = 0;
-	spin_unlock_irqrestore(&r->lock, flags);
-
-	now = ktime_get_real();
-	mix_pool_bytes(r, &now, sizeof(now));
-	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof flags) {
-		if (!arch_get_random_long(&flags))
+	mix_pool_bytes(r, &now, sizeof(now), NULL);
+	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof(rv)) {
+		if (!arch_get_random_long(&rv))
 			break;
-		mix_pool_bytes(r, &flags, sizeof(flags));
+		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
-	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
+	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
 }
 
 static int rand_initialize(void)
@@ -1186,7 +1186,7 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 		count -= bytes;
 		p += bytes;
 
-		mix_pool_bytes(r, buf, bytes);
+		mix_pool_bytes(r, buf, bytes, NULL);
 		cond_resched();
 	}
 
-- 
1.7.2.1.45.g54fbc



