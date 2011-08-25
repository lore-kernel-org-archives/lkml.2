Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1HYUjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:39:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64097 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1HYUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:39:01 -0400
Date: Thu, 25 Aug 2011 23:38:58 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arm: nwfpe: '&pointer[0]' to 'pointer' fix
Message-ID: <20110825203858.GA3852@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:15 PM, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Thu, Aug 25, 2011 at 10:11:43PM +0300, Maxin B. John wrote:
>> '&pointer[0]' to 'pointer' fix in arch/arm/nwfpe/fpa11_cpdt.c
> Your reason being?
The first thought was, this is "obvious" and we "can" do it. I haven't
thought about the consistency of the code while making this change.

> You may notice the original code has some consistency.  Your
> replacement
> is less consistent.  If you wish to make this change, it should
> change to:
>
>        get_user(p[0], pMem + 0);
>        get_user(p[1], pMem + 1);
>
> to maintain consistency.

As per your instruction, I have modified the patch to retain the
consistency of the code. Please let me know your comments on this.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/arch/arm/nwfpe/fpa11_cpdt.c b/arch/arm/nwfpe/fpa11_cpdt.c
index d31c49f..1dbd915 100644
--- a/arch/arm/nwfpe/fpa11_cpdt.c
+++ b/arch/arm/nwfpe/fpa11_cpdt.c
@@ -42,11 +42,11 @@ static inline void loadDouble(const unsigned int Fn, const unsigned int __user *
 	p = (unsigned int *) &fpa11->fpreg[Fn].fDouble;
 	fpa11->fType[Fn] = typeDouble;
 #ifdef __ARMEB__
-	get_user(p[0], &pMem[0]);	/* sign & exponent */
-	get_user(p[1], &pMem[1]);
+	get_user(p[0], pMem + 0);	/* sign & exponent */
+	get_user(p[1], pMem + 1);
 #else
-	get_user(p[0], &pMem[1]);
-	get_user(p[1], &pMem[0]);	/* sign & exponent */
+	get_user(p[0], pMem + 1);
+	get_user(p[1], pMem + 0);	/* sign & exponent */
 #endif
 }
 
@@ -57,13 +57,13 @@ static inline void loadExtended(const unsigned int Fn, const unsigned int __user
 	unsigned int *p;
 	p = (unsigned int *) &fpa11->fpreg[Fn].fExtended;
 	fpa11->fType[Fn] = typeExtended;
-	get_user(p[0], &pMem[0]);	/* sign & exponent */
+	get_user(p[0], pMem + 0);	/* sign & exponent */
 #ifdef __ARMEB__
-	get_user(p[1], &pMem[1]);	/* ms bits */
-	get_user(p[2], &pMem[2]);	/* ls bits */
+	get_user(p[1], pMem + 1);	/* ms bits */
+	get_user(p[2], pMem + 2);	/* ls bits */
 #else
-	get_user(p[1], &pMem[2]);	/* ls bits */
-	get_user(p[2], &pMem[1]);	/* ms bits */
+	get_user(p[1], pMem + 2);	/* ls bits */
+	get_user(p[2], pMem + 1);	/* ms bits */
 #endif
 }
 #endif
@@ -75,15 +75,15 @@ static inline void loadMultiple(const unsigned int Fn, const unsigned int __user
 	unsigned long x;
 
 	p = (unsigned int *) &(fpa11->fpreg[Fn]);
-	get_user(x, &pMem[0]);
+	get_user(x, pMem);
 	fpa11->fType[Fn] = (x >> 14) & 0x00000003;
 
 	switch (fpa11->fType[Fn]) {
 	case typeSingle:
 	case typeDouble:
 		{
-			get_user(p[0], &pMem[2]);	/* Single */
-			get_user(p[1], &pMem[1]);	/* double msw */
+			get_user(p[0], pMem + 2);	/* Single */
+			get_user(p[1], pMem + 1);	/* double msw */
 			p[2] = 0;			/* empty */
 		}
 		break;
@@ -91,8 +91,8 @@ static inline void loadMultiple(const unsigned int Fn, const unsigned int __user
 #ifdef CONFIG_FPE_NWFPE_XP
 	case typeExtended:
 		{
-			get_user(p[1], &pMem[2]);
-			get_user(p[2], &pMem[1]);	/* msw */
+			get_user(p[1], pMem + 2);
+			get_user(p[2], pMem + 1);	/* msw */
 			p[0] = (x & 0x80003fff);
 		}
 		break;
@@ -150,11 +150,11 @@ static inline void storeDouble(struct roundingData *roundData, const unsigned in
 	}
 
 #ifdef __ARMEB__
-	put_user(val.i[0], &pMem[0]);	/* msw */
-	put_user(val.i[1], &pMem[1]);	/* lsw */
+	put_user(val.i[0], pMem + 0);	/* msw */
+	put_user(val.i[1], pMem + 1);	/* lsw */
 #else
-	put_user(val.i[1], &pMem[0]);	/* msw */
-	put_user(val.i[0], &pMem[1]);	/* lsw */
+	put_user(val.i[1], pMem + 0);	/* msw */
+	put_user(val.i[0], pMem + 1);	/* lsw */
 #endif
 }
 
@@ -180,13 +180,13 @@ static inline void storeExtended(const unsigned int Fn, unsigned int __user *pMe
 		val.f = fpa11->fpreg[Fn].fExtended;
 	}
 
-	put_user(val.i[0], &pMem[0]);	/* sign & exp */
+	put_user(val.i[0], pMem + 0);	/* sign & exp */
 #ifdef __ARMEB__
-	put_user(val.i[1], &pMem[1]);	/* msw */
-	put_user(val.i[2], &pMem[2]);
+	put_user(val.i[1], pMem + 1);	/* msw */
+	put_user(val.i[2], pMem + 2);
 #else
-	put_user(val.i[1], &pMem[2]);
-	put_user(val.i[2], &pMem[1]);	/* msw */
+	put_user(val.i[1], pMem + 2);
+	put_user(val.i[2], pMem + 1);	/* msw */
 #endif
 }
 #endif
@@ -203,18 +203,18 @@ static inline void storeMultiple(const unsigned int Fn, unsigned int __user *pMe
 	case typeSingle:
 	case typeDouble:
 		{
-			put_user(p[0], &pMem[2]);	/* single */
-			put_user(p[1], &pMem[1]);	/* double msw */
-			put_user(nType << 14, &pMem[0]);
+			put_user(p[0], pMem + 2);	/* single */
+			put_user(p[1], pMem + 1);	/* double msw */
+			put_user(nType << 14, pMem + 0);
 		}
 		break;
 
 #ifdef CONFIG_FPE_NWFPE_XP
 	case typeExtended:
 		{
-			put_user(p[2], &pMem[1]);	/* msw */
-			put_user(p[1], &pMem[2]);
-			put_user((p[0] & 0x80003fff) | (nType << 14), &pMem[0]);
+			put_user(p[2], pMem + 1);	/* msw */
+			put_user(p[1], pMem + 2);
+			put_user((p[0] & 0x80003fff) | (nType << 14), pMem + 0);
 		}
 		break;
 #endif

