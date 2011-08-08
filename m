Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1HHXIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:08:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60959 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1HHXII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:08:08 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] lib/sha1: remove memsets and allocate workspace on the stack
Date: Mon,  8 Aug 2011 16:07:17 -0700
Message-Id: <1312844837-10086-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous implementation required the workspace to be passed in as
a parameter. This prevents the compiler from being able to store the
workspace in registers. I've also removed the memset since that also
prevents the compiler from storing the workspace in registers.

There is no loss of security due to removing the memset. It would be a
bug for the stack to leak to userspace. However, a defence-in-depth
argument could be made for keeping the clearing of the workspace.

For ChromiumOS, we use SHA-1 to verify the integrity of the root
filesystem.  The speed of the kernel sha-1 implementation has a major
impact on our boot performance.

This patch results in a 190 ms improvement in boot speed.

10 reboots, remove slowest/fastest.

Before:

Mean: 5.89 seconds
Stdev: 0.07

After:

Mean: 5.70 seconds
Stdev: 0.04

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://thread.gmane.org/gmane.linux.kernel.cryptoapi/5758/focus=5769
Cc: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Joachim Eastwood <manabian@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 crypto/sha1_generic.c      |    4 ----
 drivers/char/random.c      |    7 +++----
 include/linux/cryptohash.h |    3 +--
 lib/sha1.c                 |    8 ++------
 net/ipv4/syncookies.c      |    5 ++---
 net/ipv4/tcp_output.c      |    4 +---
 net/ipv6/syncookies.c      |    5 ++---
 7 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 00ae60e..e6dd074 100644
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
@@ -63,8 +61,6 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 			done += SHA1_BLOCK_SIZE;
 			src = data + done;
 		} while (done + SHA1_BLOCK_SIZE <= len);
-
-		memset(temp, 0, sizeof(temp));
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index c35a785..88a30f4 100644
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
+		sha_transform(hash, (__u8 *)(r->pool + i));
 
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
@@ -839,9 +839,8 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * To avoid duplicates, we atomically extract a portion of the
 	 * pool while mixing, and hash one final time.
 	 */
-	sha_transform(hash, extract, workspace);
+	sha_transform(hash, extract);
 	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 2cd9f1c..2c17ded 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -3,10 +3,9 @@
 
 #define SHA_DIGEST_WORDS 5
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
-#define SHA_WORKSPACE_WORDS 16
 
 void sha_init(__u32 *buf);
-void sha_transform(__u32 *digest, const char *data, __u32 *W);
+void sha_transform(__u32 *digest, const char *data);
 
 #define MD5_DIGEST_WORDS 4
 #define MD5_MESSAGE_BYTES 64
diff --git a/lib/sha1.c b/lib/sha1.c
index f33271d..166d9f2 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -66,20 +66,16 @@
  *
  * @digest: 160 bit digest to update
  * @data:   512 bits of data to hash
- * @array:  16 words of workspace (see note)
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
+void sha_transform(__u32 *digest, const char *data)
 {
 	__u32 A, B, C, D, E;
+	__u32 array[16];
 
 	A = digest[0];
 	B = digest[1];
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 92bb943..6cdead4 100644
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
+	sha_transform(tmp + 16, (__u8 *)tmp);
 
 	return tmp[17];
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 882e0b0..db1932c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2494,7 +2494,6 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 		}
 
 		if (opts.hash_size > 0) {
-			__u32 workspace[SHA_WORKSPACE_WORDS];
 			u32 *mess = &xvp->cookie_bakery[COOKIE_DIGEST_WORDS];
 			u32 *tail = &mess[COOKIE_MESSAGE_WORDS-1];
 
@@ -2511,8 +2510,7 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 			*tail-- ^= (u32)(unsigned long)cvp; /* per sockopt */
 
 			sha_transform((__u32 *)&xvp->cookie_bakery[0],
-				      (char *)mess,
-				      &workspace[0]);
+				      (char *)mess);
 			opts.hash_location =
 				(__u8 *)&xvp->cookie_bakery[0];
 		}
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 89d5bf8..c22ab16 100644
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
+	sha_transform(tmp + 16, (__u8 *)tmp);
 
 	return tmp[17];
 }
-- 
1.7.3.1

