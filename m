Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0LLXve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:51:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab0LLXsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: herbert@gondor.hengli.com.au, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [209/223] crypto: padlock - Fix AES-CBC handling on odd-block-sized input
Message-Id: <20101212234836.699D2B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

commit c054a076a1bd4731820a9c4d638b13d5c9bf5935 upstream.

On certain VIA chipsets AES-CBC requires the input/output to be
a multiple of 64 bytes.  We had a workaround for this but it was
buggy as it sent the whole input for processing when it is meant
to only send the initial number of blocks which makes the rest
a multiple of 64 bytes.

As expected this causes memory corruption whenever the workaround
kicks in.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/crypto/padlock-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/crypto/padlock-aes.c
===================================================================
--- linux.orig/drivers/crypto/padlock-aes.c
+++ linux/drivers/crypto/padlock-aes.c
@@ -286,7 +286,7 @@ static inline u8 *padlock_xcrypt_cbc(con
 	if (initial)
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 			      : "+S" (input), "+D" (output), "+a" (iv)
-			      : "d" (control_word), "b" (key), "c" (count));
+			      : "d" (control_word), "b" (key), "c" (initial));
 
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 		      : "+S" (input), "+D" (output), "+a" (iv)
