Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1HGV3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:29:43 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:38867 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755318Ab1HGV3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:29:40 -0400
Subject: [PATCH] treewide: Remove direct uses of SHA_WORKSPACE_WORDS
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
In-Reply-To: <CA+55aFyNtMwgJaMDjsy8V4k3v+WPcw9byNEVN46VGetvDOheuw@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
	 <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
	 <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
	 <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
	 <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
	 <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
	 <d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com>
	 <CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
	 <m2liv5ovf5.fsf@igel.home>
	 <CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
	 <CAGhQ9Vy9boyXuMMn=0E5Z-oN629wUTCC=ZMWWwUpB8U9RXJmdw@mail.gmail.com>
	 <CA+55aFyNtMwgJaMDjsy8V4k3v+WPcw9byNEVN46VGetvDOheuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Aug 2011 14:29:37 -0700
Message-ID: <1312752577.29102.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While not connected to ARM's implementation of sha_transform,
maybe this might make code a bit clearer.

Remove need to know the size and type of SHA_WORKSPACE_WORDS.
Introduce and use opaque struct sha_workspace instead.

Add #include <linux/cryptohash.h> to lib/sha1.c

Signed-off-by: Joe Perches <joe@perches.com>
---
 crypto/sha1_generic.c      |    6 +++---
 drivers/char/random.c      |    9 +++++----
 include/linux/cryptohash.h |    7 ++++++-
 lib/sha1.c                 |    7 +++++--
 net/ipv4/syncookies.c      |    7 ++++---
 net/ipv4/tcp_output.c      |    4 ++--
 net/ipv6/syncookies.c      |    7 ++++---
 7 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 00ae60e..639b507 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -49,7 +49,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	src = data;
 
 	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-		u32 temp[SHA_WORKSPACE_WORDS];
+		struct sha_workspace temp;
 
 		if (partial) {
 			done = -partial;
@@ -59,12 +59,12 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 		}
 
 		do {
-			sha_transform(sctx->state, src, temp);
+			sha_transform(sctx->state, src, &temp);
 			done += SHA1_BLOCK_SIZE;
 			src = data + done;
 		} while (done + SHA1_BLOCK_SIZE <= len);
 
-		memset(temp, 0, sizeof(temp));
+		memset(&temp, 0, sizeof(temp));
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index c35a785..bd0fd99 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -816,13 +816,14 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
-	__u32 hash[5], workspace[SHA_WORKSPACE_WORDS];
+	__u32 hash[5];
+	struct sha_workspace workspace;
 	__u8 extract[64];
 
 	/* Generate a hash across the pool, 16 words (512 bits) at a time */
 	sha_init(hash);
 	for (i = 0; i < r->poolinfo->poolwords; i += 16)
-		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
+		sha_transform(hash, (__u8 *)(r->pool + i), &workspace);
 
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
@@ -839,9 +840,9 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * To avoid duplicates, we atomically extract a portion of the
 	 * pool while mixing, and hash one final time.
 	 */
-	sha_transform(hash, extract, workspace);
+	sha_transform(hash, extract, &workspace);
 	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
+	memset(&workspace, 0, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 2cd9f1c..18b3a27 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -5,8 +5,13 @@
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
 #define SHA_WORKSPACE_WORDS 16
 
+struct sha_workspace {
+	__u32 words[SHA_WORKSPACE_WORDS];
+};
+
 void sha_init(__u32 *buf);
-void sha_transform(__u32 *digest, const char *data, __u32 *W);
+void sha_transform(__u32 *digest, const char *data,
+		   struct sha_workspace *workspace);
 
 #define MD5_DIGEST_WORDS 4
 #define MD5_MESSAGE_BYTES 64
diff --git a/lib/sha1.c b/lib/sha1.c
index f33271d..990612a 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/cryptohash.h>
 #include <asm/unaligned.h>
 
 /*
@@ -66,7 +67,7 @@
  *
  * @digest: 160 bit digest to update
  * @data:   512 bits of data to hash
- * @array:  16 words of workspace (see note)
+ * @workspace:  struct sha_workspace * (see note)
  *
  * This function generates a SHA1 digest for a single 512-bit block.
  * Be warned, it does not handle padding and message digest, do not
@@ -77,9 +78,11 @@
  * to clear the workspace. This is left to the caller to avoid
  * unnecessary clears between chained hashing operations.
  */
-void sha_transform(__u32 *digest, const char *data, __u32 *array)
+void sha_transform(__u32 *digest, const char *data,
+		   struct sha_workspace *workspace)
 {
 	__u32 A, B, C, D, E;
+	__u32 *array = workspace->words;
 
 	A = digest[0];
 	B = digest[1];
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 92bb943..77e8069 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -37,20 +37,21 @@ __initcall(init_syncookies);
 #define COOKIEBITS 24	/* Upper bits store count */
 #define COOKIEMASK (((__u32)1 << COOKIEBITS) - 1)
 
-static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
-		      ipv4_cookie_scratch);
+static DEFINE_PER_CPU(__u32 [16 + 5], ipv4_cookie_scratch);
+static DEFINE_PER_CPU(struct sha_workspace, ipv4_sha_workspace);
 
 static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
 		       u32 count, int c)
 {
 	__u32 *tmp = __get_cpu_var(ipv4_cookie_scratch);
+	struct sha_workspace workspace = __get_cpu_var(ipv4_sha_workspace);
 
 	memcpy(tmp + 4, syncookie_secret[c], sizeof(syncookie_secret[c]));
 	tmp[0] = (__force u32)saddr;
 	tmp[1] = (__force u32)daddr;
 	tmp[2] = ((__force u32)sport << 16) + (__force u32)dport;
 	tmp[3] = count;
-	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
+	sha_transform(tmp + 16, (__u8 *)tmp, &workspace);
 
 	return tmp[17];
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 882e0b0..d9388c8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2494,7 +2494,7 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 		}
 
 		if (opts.hash_size > 0) {
-			__u32 workspace[SHA_WORKSPACE_WORDS];
+			struct sha_workspace workspace;
 			u32 *mess = &xvp->cookie_bakery[COOKIE_DIGEST_WORDS];
 			u32 *tail = &mess[COOKIE_MESSAGE_WORDS-1];
 
@@ -2512,7 +2512,7 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 
 			sha_transform((__u32 *)&xvp->cookie_bakery[0],
 				      (char *)mess,
-				      &workspace[0]);
+				      &workspace);
 			opts.hash_location =
 				(__u8 *)&xvp->cookie_bakery[0];
 		}
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 89d5bf8..7781ef2 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -63,13 +63,14 @@ static inline struct sock *get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	return child;
 }
 
-static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
-		      ipv6_cookie_scratch);
+static DEFINE_PER_CPU(__u32 [16 + 5], ipv6_cookie_scratch);
+static DEFINE_PER_CPU(struct sha_workspace, ipv6_sha_workspace);
 
 static u32 cookie_hash(const struct in6_addr *saddr, const struct in6_addr *daddr,
 		       __be16 sport, __be16 dport, u32 count, int c)
 {
 	__u32 *tmp = __get_cpu_var(ipv6_cookie_scratch);
+	struct sha_workspace workspace = __get_cpu_var(ipv6_sha_workspace);
 
 	/*
 	 * we have 320 bits of information to hash, copy in the remaining
@@ -81,7 +82,7 @@ static u32 cookie_hash(const struct in6_addr *saddr, const struct in6_addr *dadd
 	memcpy(tmp + 4, daddr, 16);
 	tmp[8] = ((__force u32)sport << 16) + (__force u32)dport;
 	tmp[9] = count;
-	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
+	sha_transform(tmp + 16, (__u8 *)tmp, &workspace);
 
 	return tmp[17];
 }
-- 
1.7.6.405.gc1be0


