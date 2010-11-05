Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0KELLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:11:23 -0400
Received: from msa105.auone-net.jp ([61.117.18.165]:58714 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0KELLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:11:20 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 07:11:20 EDT
Date: Fri, 5 Nov 2010 20:04:42 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: pvclock: Remove leftover scale_delta function.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20101105110444.BAF6D6FC03B@msa105.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 92580d64e16402762e2acc3022f065397c780425
("x86: pvclock: Move scale_delta into common header")
forgot to remove scale_delta.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 arch/x86/kernel/pvclock.c |   38 --------------------------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index bab3b9e..008b91e 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -41,44 +41,6 @@ void pvclock_set_flags(u8 flags)
 	valid_flags = flags;
 }
 
-/*
- * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
- * yielding a 64-bit result.
- */
-static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
-{
-	u64 product;
-#ifdef __i386__
-	u32 tmp1, tmp2;
-#endif
-
-	if (shift < 0)
-		delta >>= -shift;
-	else
-		delta <<= shift;
-
-#ifdef __i386__
-	__asm__ (
-		"mul  %5       ; "
-		"mov  %4,%%eax ; "
-		"mov  %%edx,%4 ; "
-		"mul  %5       ; "
-		"xor  %5,%5    ; "
-		"add  %4,%%eax ; "
-		"adc  %5,%%edx ; "
-		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
-		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
-#elif defined(__x86_64__)
-	__asm__ (
-		"mul %%rdx ; shrd $32,%%rdx,%%rax"
-		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
-#else
-#error implement me!
-#endif
-
-	return product;
-}
-
 static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
 	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
-- 
1.7.2.3

