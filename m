Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab2JAXCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35570 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab2JAXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:44 -0400
Message-Id: <20121001225200.744308113@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 074/180] crypto: sha512 - Fix byte counter overflow in SHA-512
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Yoder <key@linux.vnet.ibm.com>

commit 25c3d30c918207556ae1d6e663150ebdf902186b upstream.

The current code only increments the upper 64 bits of the SHA-512 byte
counter when the number of bytes hashed happens to hit 2^64 exactly.

This patch increments the upper 64 bits whenever the lower 64 bits
overflows.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 crypto/sha512_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.2.1.45.g54fbc



