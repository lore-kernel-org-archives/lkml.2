Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1AFGNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 01:13:00 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38655 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1AFGM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 01:12:59 -0500
Date: Thu, 6 Jan 2011 17:12:41 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110106061241.GA18939@gondor.apana.org.au>
References: <20110104043338.GA27604@gondor.apana.org.au> <20110104121957.GA27114@darkside.kls.lan> <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au> <20110104230644.GJ27114@darkside.kls.lan> <20110105003020.GA5751@gondor.apana.org.au> <20110105035222.GA8762@darkside.kls.lan> <20110105054735.GA7773@gondor.apana.org.au> <20110105131621.GA24769@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105131621.GA24769@darkside.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:16:22PM +0100, Mario 'BitKoenig' Holbe wrote:
>
> attached. I hope I got the gcc call right. However, I prefer the objdump
> output anyways, so this one is attached as well.

I see what you mean now.

Please let me know if this patch (still against vanilla) helps.

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 794aacb..6788bbc 100644
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
@@ -81,8 +81,13 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
 	ts_state = irq_ts_save();
 
 	asm(".byte 0x0F,0xA7,0xC0 /* xstore %%edi (addr=%0) */"
-		:"=m"(*addr), "=a"(eax_out)
-		:"D"(addr), "d"(edx_in));
+		: "=m" (*addr), "=a" (eax_out), "+D" (addr)
+		: "d" (edx_in)
+#ifdef CONFIG_64BIT
+		: "%rcx");
+#else
+		: "%ecx");
+#endif
 
 	irq_ts_restore(ts_state);
 	return eax_out;
@@ -90,8 +95,10 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
 
 static int via_rng_data_present(struct hwrng *rng, int wait)
 {
+	char buf[16 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
+	u32 *via_rng_datum = (u32 *)PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
 	u32 bytes_out;
-	u32 *via_rng_datum = (u32 *)(&rng->priv);
 	int i;
 
 	/* We choose the recommended 1-byte-per-instruction RNG rate,
@@ -115,6 +122,7 @@ static int via_rng_data_present(struct hwrng *rng, int wait)
 			break;
 		udelay(10);
 	}
+	rng->priv = *via_rng_datum;
 	return bytes_out ? 1 : 0;
 }
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2e992bc..2e56508 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -9,6 +9,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -21,7 +22,6 @@
 #include <asm/byteorder.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
-#include "padlock.h"
 
 /*
  * Number of data blocks actually fetched for each xcrypt insn.
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index d3a27e0..adf075b 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -13,6 +13,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/padlock.h>
 #include <crypto/sha.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -22,13 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/scatterlist.h>
 #include <asm/i387.h>
-#include "padlock.h"
-
-#ifdef CONFIG_64BIT
-#define STACK_ALIGN 16
-#else
-#define STACK_ALIGN 4
-#endif
 
 struct padlock_sha_desc {
 	struct shash_desc fallback;
diff --git a/drivers/crypto/padlock.h b/drivers/crypto/padlock.h
deleted file mode 100644
index b728e45..0000000
--- a/drivers/crypto/padlock.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Driver for VIA PadLock
- *
- * Copyright (c) 2004 Michal Ludvig <michal@logix.cz>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
- * any later version.
- *
- */
-
-#ifndef _CRYPTO_PADLOCK_H
-#define _CRYPTO_PADLOCK_H
-
-#define PADLOCK_ALIGNMENT 16
-
-#define PFX	"padlock: "
-
-#define PADLOCK_CRA_PRIORITY	300
-#define PADLOCK_COMPOSITE_PRIORITY 400
-
-#endif	/* _CRYPTO_PADLOCK_H */
diff --git a/include/crypto/padlock.h b/include/crypto/padlock.h
new file mode 100644
index 0000000..d2cfa2e
--- /dev/null
+++ b/include/crypto/padlock.h
@@ -0,0 +1,29 @@
+/*
+ * Driver for VIA PadLock
+ *
+ * Copyright (c) 2004 Michal Ludvig <michal@logix.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_PADLOCK_H
+#define _CRYPTO_PADLOCK_H
+
+#define PADLOCK_ALIGNMENT 16
+
+#define PFX	KBUILD_MODNAME ": "
+
+#define PADLOCK_CRA_PRIORITY	300
+#define PADLOCK_COMPOSITE_PRIORITY 400
+
+#ifdef CONFIG_64BIT
+#define STACK_ALIGN 16
+#else
+#define STACK_ALIGN 4
+#endif
+
+#endif	/* _CRYPTO_PADLOCK_H */

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
