Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab1EZXVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:21:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1EZXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=K7ctQ4N7cHy8A+luLBqyamdUW+tB895iiT0j/lGqGbbCw0y5mh4KzzuHsuGJp9YyPg
         zRW3mjMDRKB88tGMtvug==
Date: Thu, 26 May 2011 16:20:58 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: msb@chromium.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2] crypto: sha1: modify sha1_update to use SHA1_BLOCK_SIZE
Message-ID: <20110526232058.GQ11023@google.com>
References: <1306379477-24552-1-git-send-email-msb@chromium.org>
 <20110525.233411.1372538972166578285.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525.233411.1372538972166578285.davem@davemloft.net>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller (davem@davemloft.net) wrote:
> 
> The temp[] buffer is explicitly places inside the inner most
> basic block so that the compiler doesn't allocate the stack
> space unless that code path is taken.
> 

Fixed in V2 (this patch). Thanks for the review.

-- >8 -- (snip)

Plus some other minor cleanup.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: linux-crypto@vger.kernel.org
---
 crypto/sha1_generic.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..0b56719 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -40,33 +40,30 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
+	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
 
-	partial = sctx->count & 0x3f;
 	sctx->count += len;
-	done = 0;
-	src = data;
 
-	if ((partial + len) > 63) {
+	if ((partial + len) >= SHA1_BLOCK_SIZE) {
 		u32 temp[SHA_WORKSPACE_WORDS];
 
 		if (partial) {
-			done = -partial;
-			memcpy(sctx->buffer + partial, data, done + 64);
-			src = sctx->buffer;
-		}
-
-		do {
-			sha_transform(sctx->state, src, temp);
-			done += 64;
-			src = data + done;
-		} while (done + 63 < len);
+			unsigned int done = SHA1_BLOCK_SIZE - partial;
 
+			memcpy(sctx->buffer + partial, data, done);
+			sha_transform(sctx->state, sctx->buffer, temp);
+			len -= done;
+			data += done;
+			partial = 0;
+		}
+		while (len >= SHA1_BLOCK_SIZE) {
+			sha_transform(sctx->state, data, temp);
+			len -= SHA1_BLOCK_SIZE;
+			data += SHA1_BLOCK_SIZE;
+		}
 		memset(temp, 0, sizeof(temp));
-		partial = 0;
 	}
-	memcpy(sctx->buffer + partial, src, len - done);
+	memcpy(sctx->buffer + partial, data, len);
 
 	return 0;
 }
-- 
1.7.3.1

