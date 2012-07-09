Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2GIRyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:54:46 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43479 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2GIRyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:54:44 -0400
Message-ID: <20120709205441.11422bntesq3cdno@www.81.fi>
Date: Mon, 09 Jul 2012 20:54:41 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for July 2 (crypto/hifn_795x)
References: <20120702172334.2618cae84cc57b4ec5a63ed7@canb.auug.org.au>
 <4FF1CBF2.8060303@xenotime.net>
In-Reply-To: <4FF1CBF2.8060303@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_28zo09nk67fo"
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--=_28zo09nk67fo
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting Randy Dunlap <rdunlap@xenotime.net>:

> On 07/02/2012 12:23 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120629:
>>
>
>
> on i386:
>
>
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
>

This is caused by commit feb7b7ab928afa97a79a9c424e4e0691f49d63be.  
hifn_795x has "DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq)", which  
should be changed to DIV_ROUND_UP_ULL now that NSEC_PER_SEC is 64bit  
on 32bit archs. Patch to fix hifn_795x is attached (only compile  
tested).

-Jussi


--=_28zo09nk67fo
Content-Type: text/x-patch;
 charset=ISO-8859-1;
 name="01-crypto-hifn_795x-fix-64bit-division-and-undefined-__divdi3.patch"
Content-Disposition: attachment;
 filename*0="01-crypto-hifn_795x-fix-64bit-division-and-undefined-__divdi3.pat";
 filename*1="ch"
Content-Transfer-Encoding: 7bit

crypto: hifn_795x - fix 64bit division and undefined __divdi3 on 32bit archs

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Commit feb7b7ab928afa97a79a9c424e4e0691f49d63be changed NSEC_PER_SEC to 64-bit
constant, which causes "DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq)" to
generate __divdi3 call on 32-bit archs. Fix this by changing DIV_ROUND_UP to
DIV_ROUND_UP_ULL.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/crypto/hifn_795x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index c9c4bef..df14358 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -821,8 +821,8 @@ static int hifn_register_rng(struct hifn_device *dev)
 	/*
 	 * We must wait at least 256 Pk_clk cycles between two reads of the rng.
 	 */
-	dev->rng_wait_time	= DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq) *
-				  256;
+	dev->rng_wait_time	= DIV_ROUND_UP_ULL(NSEC_PER_SEC,
+						   dev->pk_clk_freq) * 256;
 
 	dev->rng.name		= dev->name;
 	dev->rng.data_present	= hifn_rng_data_present,

--=_28zo09nk67fo--

