Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2KUH31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:29:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2KUH30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:29:26 -0500
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DJ Johnston <dj.johnston@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] random: Account for entropy loss due to overwrites
Date: Tue, 20 Nov 2012 23:27:48 -0800
Message-Id: <1353482868-8064-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353482868-8064-1-git-send-email-hpa@linux.intel.com>
References: <1353482868-8064-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 20 Nov 2012 23:29:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

When we write entropy into a non-empty pool, we currently don't
account at all for the fact that we will probabilistically overwrite
some of the entropy in that pool.  This means that unless the pool is
fully empty, we are currently *guaranteed* to overestimate the amount
of entropy in the pool!

Assuming Shannon entropy with zero correlations we end up with an
exponentally decaying value of new entropy added:

	entropy <- entropy + (pool_size - entropy) *
		(1 - exp(-add_entropy/pool_size))

However, calculations involving fractional exponentials are not
practical in the kernel, so apply a piecewise linearization:

	  For add_entropy <= pool_size then

	  (1 - exp(-add_entropy/pool_size)) >= (add_entropy/pool_size)*0.632...

	  ... so we can approximate the exponential with
	  add_entropy/(pool_size*2) and still be on the
	  safe side by adding at most one pool_size at a time.

In order for the loop not to take arbitrary amounts of time if a bad
ioctl is received, terminate if we are within one bit of full.  This
way the loop is guaranteed to terminate after no more than
log2(poolsize) iterations, no matter what the input value is.  The
vast majority of the time the loop will be executed exactly once.

The piecewise linearization is very conservative, approaching 1/2 of
the usable input value for small inputs, however, our entropy
estimation is pretty weak at best, especially for small values; we
have no handle on correlation; and the Shannon entropy measure (Rényi
entropy of order 1) is not the correct one to use in the first place,
but rather the correct entropy measure is the min-entropy, the Rényi
entropy of infinite order.

As such, this conservatism seems more than justified.  Note, however,
that attempting to add one bit of entropy will never succeed; nor will
two bits unless the pool is completely empty.  These roundoff
artifacts could be improved by using fixed-point arithmetic and adding
some number of fractional entropy bits.

[ v2: rely on the previous patch for poolbitshift ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: DJ Johnston <dj.johnston@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/char/random.c | 56 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b522338..c5c68cf 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -272,10 +272,12 @@
 /*
  * Configuration information
  */
-#define INPUT_POOL_WORDS 128
-#define OUTPUT_POOL_WORDS 32
-#define SEC_XFER_SIZE 512
-#define EXTRACT_SIZE 10
+#define INPUT_POOL_SHIFT	12
+#define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
+#define OUTPUT_POOL_SHIFT	10
+#define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
+#define SEC_XFER_SIZE		512
+#define EXTRACT_SIZE		10
 
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
@@ -419,7 +421,7 @@ module_param(debug, bool, 0644);
 struct entropy_store;
 struct entropy_store {
 	/* read-only data: */
-	struct poolinfo *poolinfo;
+	const struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
@@ -581,11 +583,13 @@ static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
 }
 
 /*
- * Credit (or debit) the entropy store with n bits of entropy
+ * Credit (or debit) the entropy store with n bits of entropy.
+ * The nbits value is given in units of 2^-16 bits, i.e. 0x10000 == 1 bit.
  */
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	int entropy_count, orig;
+	const int pool_size = r->poolinfo->poolbits;
 
 	if (!nbits)
 		return;
@@ -594,12 +598,48 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	entropy_count += nbits;
+	if (nbits < 0) {
+		/* Debit. */
+		entropy_count += nbits;
+	} else {
+		/*
+		 * Credit: we have to account for the possibility of
+		 * overwriting already present entropy.  Even in the
+		 * ideal case of pure Shannon entropy, new contributions
+		 * approach the full value asymptotically:
+		 *
+		 * entropy <- entropy + (pool_size - entropy) *
+		 *	(1 - exp(-add_entropy/pool_size))
+		 *
+		 * For add_entropy <= pool_size then
+		 * (1 - exp(-add_entropy/pool_size)) >=
+		 *    (add_entropy/pool_size)*0.632...
+		 * so we can approximate the exponential with
+		 * add_entropy/(pool_size*2) and still be on the
+		 * safe side by adding at most one pool_size at a time.
+		 *
+		 * The use of pool_size-1 in the while statement is to
+		 * prevent rounding artifacts from making the loop
+		 * arbitrarily long; this limits the loop to poolshift
+		 * turns no matter how large nbits is.
+		 */
+		int pnbits  = nbits;
+		const int s = r->poolinfo->poolbitshift + 1;
 
+		do {
+			int anbits = min(pnbits, pool_size);
+
+			entropy_count +=
+				((pool_size - entropy_count)*anbits) >> s;
+			pnbits -= anbits;
+		} while (unlikely(entropy_count < pool_size-1 && pnbits));
+	}
+ 
 	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
 		entropy_count = 0;
-	} else if (entropy_count > r->poolinfo->poolbits)
-		entropy_count = r->poolinfo->poolbits;
+	} else if (entropy_count > pool_size)
+		entropy_count = pool_size;
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-- 
1.7.11.7

