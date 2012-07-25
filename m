Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab2GYRhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:37:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2GYRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:37:39 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, "Theodore T'so" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, w@1wt.edu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@vger.kernel.org, DJ Johnston <dj.johnston@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] random: mix in architectural randomness in extract_buf()
Date: Wed, 25 Jul 2012 10:37:02 -0700
Message-Id: <1343237822-7789-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <20120725151000.GA30996@thunk.org>
References: <20120725151000.GA30996@thunk.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 10:37:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

RDRAND is so much faster than the Linux pool system that we can
always just mix in architectural randomness.

Doing this in extract_buf() lets us do this in one convenient
place, unfortunately the output size (10 bytes) is maximally
awkward.  That, plus the fact that every output byte will have
passed through extract_buf() twice means we are not being very
efficient with the RDRAND use.

Measurements show that RDRAND is 12-15 times faster than the Linux
pool system.  Doing the math shows this corresponds to about an
11.5% slowdown which is confirmed by measurements.

Users who are very performance- or power-sensitive could definitely
still benefit from being allowed to use RDRAND directly, but I
believe this version should satisfy even the most hyper-paranoid
crowd.

[ v2: changed the final memcpy() from hash.w to hash in order to
  make it more obvious that mucking with hash.l doesn't leave
  hash.w unmodified.  This doesn't have any impact on the final
  code as the Linux kernel is alwasy compiled with -fno-strict-aliasing
  but it might make it more obvious to the human reader who might get
  confused and think it is a structure. ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: DJ Johnston <dj.johnston@intel.com>
---
 drivers/char/random.c | 56 +++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9793b40..7bc0b36 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -277,6 +277,8 @@
 #define SEC_XFER_SIZE 512
 #define EXTRACT_SIZE 10
 
+#define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
+
 /*
  * The minimum number of bits of entropy before we wake up a read on
  * /dev/random.  Should be enough to do a significant reseed.
@@ -813,11 +815,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
  */
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	union {
-		__u32	tmp[OUTPUT_POOL_WORDS];
-		long	hwrand[4];
-	} u;
-	int	i;
+	__u32	tmp[OUTPUT_POOL_WORDS];
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
@@ -828,23 +826,17 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		/* pull at least as many as BYTES as wakeup BITS */
 		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
 		/* but never more than the buffer size */
-		bytes = min_t(int, bytes, sizeof(u.tmp));
+		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%d of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
-		bytes = extract_entropy(r->pull, u.tmp, bytes,
+		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
-		mix_pool_bytes(r, u.tmp, bytes, NULL);
+		mix_pool_bytes(r, tmp, bytes, NULL);
 		credit_entropy_bits(r, bytes*8);
 	}
-	kmemcheck_mark_initialized(&u.hwrand, sizeof(u.hwrand));
-	for (i = 0; i < 4; i++)
-		if (arch_get_random_long(&u.hwrand[i]))
-			break;
-	if (i)
-		mix_pool_bytes(r, &u.hwrand, sizeof(u.hwrand), 0);
 }
 
 /*
@@ -901,15 +893,19 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
+	union {
+		__u32 w[5];
+		unsigned long l[LONGS(EXTRACT_SIZE)];
+	} hash;
+	__u32 workspace[SHA_WORKSPACE_WORDS];
 	__u8 extract[64];
 	unsigned long flags;
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
-	sha_init(hash);
+	sha_init(hash.w);
 	spin_lock_irqsave(&r->lock, flags);
 	for (i = 0; i < r->poolinfo->poolwords; i += 16)
-		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
+		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
 
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
@@ -920,14 +916,14 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__mix_pool_bytes(r, hash, sizeof(hash), extract);
+	__mix_pool_bytes(r, hash.w, sizeof(hash.w), extract);
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	/*
 	 * To avoid duplicates, we atomically extract a portion of the
 	 * pool while mixing, and hash one final time.
 	 */
-	sha_transform(hash, extract, workspace);
+	sha_transform(hash.w, extract, workspace);
 	memset(extract, 0, sizeof(extract));
 	memset(workspace, 0, sizeof(workspace));
 
@@ -936,11 +932,23 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * pattern, we fold it in half. Thus, we always feed back
 	 * twice as much data as we output.
 	 */
-	hash[0] ^= hash[3];
-	hash[1] ^= hash[4];
-	hash[2] ^= rol32(hash[2], 16);
-	memcpy(out, hash, EXTRACT_SIZE);
-	memset(hash, 0, sizeof(hash));
+	hash.w[0] ^= hash.w[3];
+	hash.w[1] ^= hash.w[4];
+	hash.w[2] ^= rol32(hash.w[2], 16);
+
+	/*
+	 * If we have a architectural hardware random number
+	 * generator, mix that in, too.
+	 */
+	for (i = 0; i < LONGS(EXTRACT_SIZE); i++) {
+		unsigned long v;
+		if (!arch_get_random_long(&v))
+			break;
+		hash.l[i] ^= v;
+	}
+
+	memcpy(out, &hash, EXTRACT_SIZE);
+	memset(&hash, 0, sizeof(hash));
 }
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-- 
1.7.11.2

