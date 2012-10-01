Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2JAXFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:05:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35714 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab2JAXFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:05:13 -0400
Message-Id: <20121001225204.903698296@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        DJ Johnston <dj.johnston@intel.com>, Theodore Tso <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 172/180] random: mix in architectural randomness in extract_buf()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

commit d2e7c96af1e54b507ae2a6a7dd2baf588417a7e5 upstream.

Mix in any architectural randomness in extract_buf() instead of
xfer_secondary_buf().  This allows us to mix in more architectural
randomness, and it also makes xfer_secondary_buf() faster, moving a
tiny bit of additional CPU overhead to process which is extracting the
randomness.

[ Commit description modified by tytso to remove an extended
  advertisement for the RDRAND instruction. ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: DJ Johnston <dj.johnston@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |   56 ++++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b038751..3ea1ddb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -274,6 +274,8 @@
 #define SEC_XFER_SIZE 512
 #define EXTRACT_SIZE 10
 
+#define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
+
 /*
  * The minimum number of bits of entropy before we wake up a read on
  * /dev/random.  Should be enough to do a significant reseed.
@@ -835,11 +837,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
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
@@ -850,23 +848,17 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
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
@@ -923,15 +915,19 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
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
@@ -942,14 +938,14 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
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
 
@@ -958,11 +954,23 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
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
1.7.2.1.45.g54fbc



