Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1AGDzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:55:47 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51082 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1AGDzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:55:45 -0500
Date: Fri, 7 Jan 2011 14:55:40 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: hwrng: via_rng - Fix memory scribbling on some CPUs
Message-ID: <20110107035540.GB1341@gondor.apana.org.au>
References: <20110105003020.GA5751@gondor.apana.org.au> <20110105035222.GA8762@darkside.kls.lan> <20110105054735.GA7773@gondor.apana.org.au> <20110105131621.GA24769@darkside.kls.lan> <20110106061241.GA18939@gondor.apana.org.au> <20110106131516.GB8803@darkside.kls.lan> <20110106133541.GA22030@gondor.apana.org.au> <20110106144254.GC8803@darkside.kls.lan> <20110107034948.GA1177@gondor.apana.org.au> <20110107035456.GA1341@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107035456.GA1341@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 55db8387a5e8d07407f0b7c6b2526417a2bc6243
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jan 7 14:55:06 2011 +1100

    hwrng: via_rng - Fix memory scribbling on some CPUs
    
    It has been reported that on at least one Nano CPU the xstore
    instruction will write as many as 16 bytes of data to the output
    buffer.
    
    This causes memory corruption as we use rng->priv which is only
    4-8 bytes long.
    
    This patch fixes this by using an intermediate buffer on the stack
    with at least 16 bytes and aligned to a 16-byte boundary.
    
    The problem was observed on the following processor:
    
    processor	: 0
    vendor_id	: CentaurHauls
    cpu family	: 6
    model		: 15
    model name	: VIA Nano processor U2250 (1.6GHz Capable)
    stepping	: 3
    cpu MHz		: 1600.000
    cache size	: 1024 KB
    fdiv_bug	: no
    hlt_bug		: no
    f00f_bug	: no
    coma_bug	: no
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 10
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm syscall nx lm constant_tsc up rep_good pni monitor vmx est tm2 ssse3 cx16 xtpr rng rng_en ace ace_en ace2 phe phe_en lahf_lm
    bogomips	: 3192.08
    clflush size	: 64
    cache_alignment	: 128
    address sizes	: 36 bits physical, 48 bits virtual
    power management:
    
    Tested-by: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 7f86666..d0387a8 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -24,6 +24,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/hw_random.h>
@@ -34,7 +35,6 @@
 #include <asm/i387.h>
 
 
-#define PFX	KBUILD_MODNAME ": "
 
 
 enum {
@@ -89,8 +89,10 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
 
 static int via_rng_data_present(struct hwrng *rng, int wait)
 {
+	char buf[16 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
+	u32 *via_rng_datum = (u32 *)PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
 	u32 bytes_out;
-	u32 *via_rng_datum = (u32 *)(&rng->priv);
 	int i;
 
 	/* We choose the recommended 1-byte-per-instruction RNG rate,
@@ -114,6 +116,7 @@ static int via_rng_data_present(struct hwrng *rng, int wait)
 			break;
 		udelay(10);
 	}
+	rng->priv = *via_rng_datum;
 	return bytes_out ? 1 : 0;
 }

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
