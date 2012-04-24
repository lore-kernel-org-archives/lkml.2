Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab2DXWsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:48:09 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2DXWhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:10 -0400
Message-Id: <20120424223253.622038828@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kent Yoder <key@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 02/42] crypto: sha512 - Fix byte counter overflow in SHA-512
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 crypto/sha512_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -174,7 +174,7 @@ sha512_update(struct shash_desc *desc, c
 	index = sctx->count[0] & 0x7f;
 
 	/* Update number of bytes */
-	if (!(sctx->count[0] += len))
+	if ((sctx->count[0] += len) < len)
 		sctx->count[1]++;
 
         part_len = 128 - index;


