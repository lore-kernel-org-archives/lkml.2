Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1AGDuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:50:03 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57410 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1AGDuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:50:01 -0500
Date: Fri, 7 Jan 2011 14:49:48 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110107034948.GA1177@gondor.apana.org.au>
References: <20110104224238.GA4978@gondor.apana.org.au> <20110104230644.GJ27114@darkside.kls.lan> <20110105003020.GA5751@gondor.apana.org.au> <20110105035222.GA8762@darkside.kls.lan> <20110105054735.GA7773@gondor.apana.org.au> <20110105131621.GA24769@darkside.kls.lan> <20110106061241.GA18939@gondor.apana.org.au> <20110106131516.GB8803@darkside.kls.lan> <20110106133541.GA22030@gondor.apana.org.au> <20110106144254.GC8803@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106144254.GC8803@darkside.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 03:42:55PM +0100, Mario 'BitKoenig' Holbe wrote:
>
> holbe@ideapad ~ % gcc -o via-rng-test via-rng-test.c
> holbe@ideapad ~ % ./via-rng-test
> 0xbff09d40: 00000000
> ecx: aa55aa55   edx: ffffff03   edi: 0xbff09d40
> ecx: aa55aa55   edx: 00000003   edi: 0xbff09d48
> 0xbff09d40: 339d4525
> holbe@ideapad ~ % 

Thanks, I've applied this patch:

commit 0735ac1f2551d9f9d356126aaf3b1110150918e6
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jan 7 14:48:57 2011 +1100

    hwrng: via_rng - Fix asm constraints
    
    The inline asm to invoke xstore did not specify the constraints
    correctly.  In particular, dx/di should have been marked as output
    registers as well as input as they're modified by xstore.
    
    Thanks to Mario Holbe for creating this patch and testing it.
    
    Tested-by: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 794aacb..7f86666 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -81,8 +81,7 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
 	ts_state = irq_ts_save();
 
 	asm(".byte 0x0F,0xA7,0xC0 /* xstore %%edi (addr=%0) */"
-		:"=m"(*addr), "=a"(eax_out)
-		:"D"(addr), "d"(edx_in));
+		: "=m" (*addr), "=a" (eax_out), "+d" (edx_in), "+D" (addr));
 
 	irq_ts_restore(ts_state);
 	return eax_out;

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
