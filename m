Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1HII62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:58:28 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:45105 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315Ab1HII60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:58:26 -0400
Subject: [PATCH] treewide: Update sha_transform
From: Joe Perches <joe@perches.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        GeertUytterhoeven <geert@linux-m68k.org>
In-Reply-To: <20110809055226.GE6103@google.com>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
	 <1312847115.1643.22.camel@Joe-Laptop>  <20110809055226.GE6103@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 01:58:23 -0700
Message-ID: <1312880303.1676.5.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the workspace into sha_transform as local stack variable struct.

Remove #define SHA_WORKSPACE_WORDS.
Remove workspace argument from sha_transform.
Convert uses of __u8 * to void * in sha_transform.
Eliminate possible sha_transform unaligned accesses to data by copying
data to an aligned __u32 array if necessary.
Add sha_transform wipe argument to force workspace clearing if desired.
A little macro neatening.

This should speed network syncookies a trivial bit.

Add #include <linux/cryptohash.h> to lib/sha1.c

Compiled/untested.

Signed-off-by: Joe Perches <joe@perches.com>
---

On Mon, 2011-08-08 at 22:52 -0700, Mandeep Singh Baines wrote:
> We don't call sha_tranform directly. We use crypto_hash_digest. So maybe
> add a wipe param there. I'm happy to work on or test such a patch if folks
> think its interesting. Its saves me 190 ms on a 6 second boot. I suspect
> there may be other hash intense applications that also don't need secracy.
 
Well, here's the patch I produced.

 crypto/sha1_generic.c      |    5 +---
 drivers/char/random.c      |    7 ++---
 include/linux/cryptohash.h |    3 +-
 lib/sha1.c                 |   61 +++++++++++++++++++++++++++++++-------------
 net/ipv4/syncookies.c      |    5 +--
 net/ipv4/tcp_output.c      |    6 +---
 net/ipv6/syncookies.c      |    5 +--
 7 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 00ae60e..d0c3f4a 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -49,8 +49,6 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	src = data;
 
 	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		u32 temp[SHA_WORKSPACE_WORDS];
-
 		if (partial) {
 			done = -partial;
 			memcpy(sctx->buffer + partial, data,
@@ -59,12 +57,11 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 		}
 
 		do {
-			sha_transform(sctx->state, src, temp);
+			sha_transform(sctx->state, src, true);
 			done += SHA1_BLOCK_SIZE;
 			src = data + done;
 		} while (done + SHA1_BLOCK_SIZE <= len);
 
-		memset(temp, 0, sizeof(temp));
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index c35a785..6b9e5dc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -816,13 +816,13 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u32 hash[5];
 	__u8 extract[64];
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
 	for (i = 0; i < r->poolinfo->poolwords; i += 16)
-		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
+		sha_transform(hash, r->pool + i, false);
 
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
@@ -839,9 +839,8 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * To avoid duplicates, we atomically extract a portion of the
 	 * pool while mixing, and hash one final time.
 	 */
-	sha_transform(hash, extract, workspace);
+	sha_transform(hash, extract, true);
 	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 2cd9f1c..c64b5cf 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -3,10 +3,9 @@
 
 #define SHA_DIGEST_WORDS 5
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
-#define SHA_WORKSPACE_WORDS 16
 
 void sha_init(__u32 *buf);
-void sha_transform(__u32 *digest, const char *data, __u32 *W);
+void sha_transform(__u32 *digest, const void *data, bool wipe);
 
 #define MD5_DIGEST_WORDS 4
 #define MD5_MESSAGE_BYTES 64
diff --git a/lib/sha1.c b/lib/sha1.c
index f33271d..a78ca29 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/cryptohash.h>
 #include <asm/unaligned.h>
 
 /*
@@ -41,45 +42,66 @@
 #endif
 
 /* This "rolls" over the 512-bit array */
-#define W(x) (array[(x)&15])
+#define W(x) (workspace.array[(x)&15])
 
 /*
  * Where do we get the source from? The first 16 iterations get it from
  * the input data, the next mix it from the 512-bit array.
  */
-#define SHA_SRC(t) get_unaligned_be32((__u32 *)data + t)
+#define SHA_SRC(t) (workspace.aligned_data[t])
 #define SHA_MIX(t) rol32(W(t+13) ^ W(t+8) ^ W(t+2) ^ W(t), 1)
 
-#define SHA_ROUND(t, input, fn, constant, A, B, C, D, E) do { \
-	__u32 TEMP = input(t); setW(t, TEMP); \
-	E += TEMP + rol32(A,5) + (fn) + (constant); \
-	B = ror32(B, 2); } while (0)
-
-#define T_0_15(t, A, B, C, D, E)  SHA_ROUND(t, SHA_SRC, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
-#define T_16_19(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
-#define T_20_39(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) , 0x6ed9eba1, A, B, C, D, E )
-#define T_40_59(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, ((B&C)+(D&(B^C))) , 0x8f1bbcdc, A, B, C, D, E )
-#define T_60_79(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) ,  0xca62c1d6, A, B, C, D, E )
+#define SHA_ROUND(t, input, fn, constant, A, B, C, D, E)	\
+do {								\
+	__u32 TEMP = input(t);					\
+								\
+	setW(t, TEMP);						\
+	E += TEMP + rol32(A, 5) + (fn) + (constant);		\
+	B = ror32(B, 2);					\
+} while (0)
+
+#define T_0_15(t, A, B, C, D, E)					\
+	SHA_ROUND(t, SHA_SRC, (((C^D)&B)^D), 0x5a827999, A, B, C, D, E)
+#define T_16_19(t, A, B, C, D, E)					\
+	SHA_ROUND(t, SHA_MIX, (((C^D)&B)^D), 0x5a827999, A, B, C, D, E)
+#define T_20_39(t, A, B, C, D, E)					\
+	SHA_ROUND(t, SHA_MIX, (B^C^D), 0x6ed9eba1, A, B, C, D, E)
+#define T_40_59(t, A, B, C, D, E)					\
+	SHA_ROUND(t, SHA_MIX, ((B&C)+(D&(B^C))), 0x8f1bbcdc, A, B, C, D, E)
+#define T_60_79(t, A, B, C, D, E)					\
+	SHA_ROUND(t, SHA_MIX, (B^C^D), 0xca62c1d6, A, B, C, D, E)
 
 /**
  * sha_transform - single block SHA1 transform
  *
  * @digest: 160 bit digest to update
  * @data:   512 bits of data to hash
- * @array:  16 words of workspace (see note)
+ * @wipe:   true if the hash is security sensitive
  *
  * This function generates a SHA1 digest for a single 512-bit block.
  * Be warned, it does not handle padding and message digest, do not
  * confuse it with the full FIPS 180-1 digest algorithm for variable
  * length messages.
- *
- * Note: If the hash is security sensitive, the caller should be sure
- * to clear the workspace. This is left to the caller to avoid
- * unnecessary clears between chained hashing operations.
  */
-void sha_transform(__u32 *digest, const char *data, __u32 *array)
+void sha_transform(__u32 *digest, const void *data, bool wipe)
 {
 	__u32 A, B, C, D, E;
+	struct {
+		__u32 array[16];	/* working array */
+		__u32 aligned[16];	/* u32 aligned version of data */
+		const __u32 *aligned_data;	/* either data or aligned */
+	} workspace;
+	size_t wipe_size;
+
+	if (((unsigned long)data) & 3) {	/* unaligned word accesses */
+		workspace.aligned_data =
+			memcpy(workspace.aligned, data,
+			       sizeof(workspace.aligned));
+		wipe_size = sizeof(workspace);
+	} else {
+		workspace.aligned_data = data;
+		wipe_size = sizeof(workspace.array);
+	}
 
 	A = digest[0];
 	B = digest[1];
@@ -182,6 +204,9 @@ void sha_transform(__u32 *digest, const char *data, __u32 *array)
 	digest[2] += C;
 	digest[3] += D;
 	digest[4] += E;
+
+	if (wipe)
+		memset(&workspace, 0, wipe_size);
 }
 EXPORT_SYMBOL(sha_transform);
 
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 92bb943..8f429cd 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -37,8 +37,7 @@ __initcall(init_syncookies);
 #define COOKIEBITS 24	/* Upper bits store count */
 #define COOKIEMASK (((__u32)1 << COOKIEBITS) - 1)
 
-static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
-		      ipv4_cookie_scratch);
+static DEFINE_PER_CPU(__u32 [16 + 5], ipv4_cookie_scratch);
 
 static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
 		       u32 count, int c)
@@ -50,7 +49,7 @@ static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
 	tmp[1] = (__force u32)daddr;
 	tmp[2] = ((__force u32)sport << 16) + (__force u32)dport;
 	tmp[3] = count;
-	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
+	sha_transform(tmp + 16, tmp, false);
 
 	return tmp[17];
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 882e0b0..454ed67 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2494,7 +2494,6 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 		}
 
 		if (opts.hash_size > 0) {
-			__u32 workspace[SHA_WORKSPACE_WORDS];
 			u32 *mess = &xvp->cookie_bakery[COOKIE_DIGEST_WORDS];
 			u32 *tail = &mess[COOKIE_MESSAGE_WORDS-1];
 
@@ -2510,9 +2509,8 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 			*tail-- ^= (((__force u32)th->dest << 16) | (__force u32)th->source);
 			*tail-- ^= (u32)(unsigned long)cvp; /* per sockopt */
 
-			sha_transform((__u32 *)&xvp->cookie_bakery[0],
-				      (char *)mess,
-				      &workspace[0]);
+			sha_transform((__u32 *)&xvp->cookie_bakery[0], mess,
+				      false);
 			opts.hash_location =
 				(__u8 *)&xvp->cookie_bakery[0];
 		}
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 89d5bf8..90823e0 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -63,8 +63,7 @@ static inline struct sock *get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	return child;
 }
 
-static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
-		      ipv6_cookie_scratch);
+static DEFINE_PER_CPU(__u32 [16 + 5], ipv6_cookie_scratch);
 
 static u32 cookie_hash(const struct in6_addr *saddr, const struct in6_addr *daddr,
 		       __be16 sport, __be16 dport, u32 count, int c)
@@ -81,7 +80,7 @@ static u32 cookie_hash(const struct in6_addr *saddr, const struct in6_addr *dadd
 	memcpy(tmp + 4, daddr, 16);
 	tmp[8] = ((__force u32)sport << 16) + (__force u32)dport;
 	tmp[9] = count;
-	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
+	sha_transform(tmp + 16, tmp, false);
 
 	return tmp[17];
 }
-- 
1.7.6.405.gc1be0



