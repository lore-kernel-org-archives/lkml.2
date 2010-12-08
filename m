Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab0LHBEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:13 -0500
Received: from kroah.org ([198.145.64.141]:33893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885Ab0LHBEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:05 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:48 2010
Message-Id: <20101208005748.733000813@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [273/289] crypto: padlock - Fix AES-CBC handling on odd-block-sized input
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/crypto/padlock-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -286,7 +286,7 @@ static inline u8 *padlock_xcrypt_cbc(con
 	if (initial)
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 			      : "+S" (input), "+D" (output), "+a" (iv)
-			      : "d" (control_word), "b" (key), "c" (count));
+			      : "d" (control_word), "b" (key), "c" (initial));
 
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 		      : "+S" (input), "+D" (output), "+a" (iv)


