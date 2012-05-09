Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2EIFxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38859 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab2EIFxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:10 -0400
Message-Id: <20120509055029.917954110@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kent Yoder <key@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 002/167] [PATCH] crypto: sha512 - Fix byte counter overflow in SHA-512
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Yoder <key@linux.vnet.ibm.com>

commit 25c3d30c918207556ae1d6e663150ebdf902186b upstream.

The current code only increments the upper 64 bits of the SHA-512 byte
counter when the number of bytes hashed happens to hit 2^64 exactly.

This patch increments the upper 64 bits whenever the lower 64 bits
overflows.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/sha512_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 107f6f7..dd30f40 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -174,7 +174,7 @@ sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	index = sctx->count[0] & 0x7f;
 
 	/* Update number of bytes */
-	if (!(sctx->count[0] += len))
+	if ((sctx->count[0] += len) < len)
 		sctx->count[1]++;
 
         part_len = 128 - index;
-- 
1.7.10



