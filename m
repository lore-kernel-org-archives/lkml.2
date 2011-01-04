Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1ADEdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 23:33:54 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:47551 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1ADEdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 23:33:52 -0500
Date: Tue, 4 Jan 2011 15:33:38 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110104043338.GA27604@gondor.apana.org.au>
References: <4D1BF056.3060909@lwfinger.net> <20101230143406.GA23219@darkside.kls.lan> <4D1CD161.4040107@lwfinger.net> <20101230204522.GC23219@darkside.kls.lan> <4D1D0C61.9050800@lwfinger.net> <20101231003735.GA24101@gondor.apana.org.au> <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan> <20101231024653.GA24879@gondor.apana.org.au> <20101231085103.GA31935@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101231085103.GA31935@darkside.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 09:51:04AM +0100, Mario 'BitKoenig' Holbe wrote:
> On Fri, Dec 31, 2010 at 01:46:53PM +1100, Herbert Xu wrote:
> > Thanks for checking.  Can you provide the output of
> > 	cat /proc/cpuinfo
> 
> attached.

Thanks.

Can you please test the following patch?

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 794aacb..507a57f 100644
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
@@ -90,8 +90,10 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
 
 static int via_rng_data_present(struct hwrng *rng, int wait)
 {
+	char buf[16 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
+	u32 *via_rng_datum = (u32 *)PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
 	u32 bytes_out;
-	u32 *via_rng_datum = (u32 *)(&rng->priv);
 	int i;
 
 	/* We choose the recommended 1-byte-per-instruction RNG rate,
@@ -115,6 +117,7 @@ static int via_rng_data_present(struct hwrng *rng, int wait)
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

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
