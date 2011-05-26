Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1EZDLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:11:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13945 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1EZDLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:11:42 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: sha1: modify sha1_update to use SHA1_BLOCK_SIZE
Date: Wed, 25 May 2011 20:11:17 -0700
Message-Id: <1306379477-24552-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plus some other minor cleanup.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 crypto/sha1_generic.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..4bdd228 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -40,33 +40,32 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
+	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
+	u32 temp[SHA_WORKSPACE_WORDS];
+	const u8 *src = data;
 
-	partial = sctx->count & 0x3f;
 	sctx->count += len;
-	done = 0;
-	src = data;
 
-	if ((partial + len) > 63) {
-		u32 temp[SHA_WORKSPACE_WORDS];
+	if (partial && ((partial + len) >= SHA1_BLOCK_SIZE)) {
+		unsigned int done = SHA1_BLOCK_SIZE - partial;
 
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buffer + partial, data, done + 64);
-			src = sctx->buffer;
-		}
+		memcpy(sctx->buffer + partial, src, done);
+		sha_transform(sctx->state, sctx->buffer, temp);
+		len -= done;
+		src += done;
+		partial = 0;
+	}
 
-		do {
-			sha_transform(sctx->state, src, temp);
-			done += 64;
-			src = data + done;
-		} while (done + 63 < len);
+	while (len >= SHA1_BLOCK_SIZE) {
+		sha_transform(sctx->state, src, temp);
+		len -= SHA1_BLOCK_SIZE;
+		src += SHA1_BLOCK_SIZE;
+	}
 
+	if (src != data)
 		memset(temp, 0, sizeof(temp));
-		partial = 0;
-	}
-	memcpy(sctx->buffer + partial, src, len - done);
+
+	memcpy(sctx->buffer + partial, src, len);
 
 	return 0;
 }
-- 
1.7.3.1

