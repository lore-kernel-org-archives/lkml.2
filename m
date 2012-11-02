Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078Ab2KBRan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:30:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33166 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762950Ab2KBRak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:30:40 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5093E4F302000078000A6162@nat28.tlf.novell.com>
References: <5093E4F302000078000A6162@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3, v2] x86/xor: make virtualization friendly
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 02 Nov 2012 10:30:08 -0700
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Message-ID: <c9840e69-aa7f-4ba5-a981-e330f4fba297@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aren't we actually talking just about PV here?

If so the test is wrong.

Jan Beulich <JBeulich@suse.com> wrote:

>In virtualized environments, the CR0.TS management needed here can be a
>lot slower than anticipated by the original authors of this code, which
>particularly means that in such cases forcing the use of SSE- (or MMX-)
>based implementations is not desirable - actual measurements should
>always be done in that case.
>
>For consistency, pull into the shared (32- and 64-bit) header not only
>the inclusion of the generic code, but also that of the AVX variants.
>
>Signed-off-by: Jan Beulich <jbeulich@suse.com>
>Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
>---
> arch/x86/include/asm/xor.h    |    8 +++++++-
> arch/x86/include/asm/xor_32.h |   22 ++++++++++------------
> arch/x86/include/asm/xor_64.h |   10 ++++++----
> 3 files changed, 23 insertions(+), 17 deletions(-)
>
>--- 3.7-rc3-x86-xor.orig/arch/x86/include/asm/xor.h
>+++ 3.7-rc3-x86-xor/arch/x86/include/asm/xor.h
>@@ -487,6 +487,12 @@ static struct xor_block_template xor_blo
> 
> #undef XOR_CONSTANT_CONSTRAINT
> 
>+/* Also try the AVX routines */
>+#include <asm/xor_avx.h>
>+
>+/* Also try the generic routines. */
>+#include <asm-generic/xor.h>
>+
> #ifdef CONFIG_X86_32
> # include <asm/xor_32.h>
> #else
>@@ -494,6 +500,6 @@ static struct xor_block_template xor_blo
> #endif
> 
> #define XOR_SELECT_TEMPLATE(FASTEST) \
>-	AVX_SELECT(FASTEST)
>+	(cpu_has_hypervisor ? (FASTEST) : AVX_SELECT(FASTEST))
> 
> #endif /* _ASM_X86_XOR_H */
>--- 3.7-rc3-x86-xor.orig/arch/x86/include/asm/xor_32.h
>+++ 3.7-rc3-x86-xor/arch/x86/include/asm/xor_32.h
>@@ -537,12 +537,6 @@ static struct xor_block_template xor_blo
> 	.do_5 = xor_sse_5,
> };
> 
>-/* Also try the AVX routines */
>-#include <asm/xor_avx.h>
>-
>-/* Also try the generic routines.  */
>-#include <asm-generic/xor.h>
>-
>/* We force the use of the SSE xor block because it can write around
>L2.
>  We may also be able to load into the L1 only depending on how the cpu
>    deals with a load to a line that is being prefetched.  */
>@@ -553,15 +547,19 @@ do {							\
> 	if (cpu_has_xmm) {				\
> 		xor_speed(&xor_block_pIII_sse);		\
> 		xor_speed(&xor_block_sse_pf64);		\
>-	} else if (cpu_has_mmx) {			\
>+		if (!cpu_has_hypervisor)		\
>+			break;				\
>+	}						\
>+	if (cpu_has_mmx) {				\
> 		xor_speed(&xor_block_pII_mmx);		\
> 		xor_speed(&xor_block_p5_mmx);		\
>-	} else {					\
>-		xor_speed(&xor_block_8regs);		\
>-		xor_speed(&xor_block_8regs_p);		\
>-		xor_speed(&xor_block_32regs);		\
>-		xor_speed(&xor_block_32regs_p);		\
>+		if (!cpu_has_hypervisor)		\
>+			break;				\
> 	}						\
>+	xor_speed(&xor_block_8regs);			\
>+	xor_speed(&xor_block_8regs_p);			\
>+	xor_speed(&xor_block_32regs);			\
>+	xor_speed(&xor_block_32regs_p);			\
> } while (0)
> 
> #endif /* _ASM_X86_XOR_32_H */
>--- 3.7-rc3-x86-xor.orig/arch/x86/include/asm/xor_64.h
>+++ 3.7-rc3-x86-xor/arch/x86/include/asm/xor_64.h
>@@ -9,10 +9,6 @@ static struct xor_block_template xor_blo
> 	.do_5 = xor_sse_5,
> };
> 
>-
>-/* Also try the AVX routines */
>-#include <asm/xor_avx.h>
>-
>/* We force the use of the SSE xor block because it can write around
>L2.
>  We may also be able to load into the L1 only depending on how the cpu
>    deals with a load to a line that is being prefetched.  */
>@@ -22,6 +18,12 @@ do {						\
> 	AVX_XOR_SPEED;				\
> 	xor_speed(&xor_block_sse_pf64);		\
> 	xor_speed(&xor_block_sse);		\
>+	if (cpu_has_hypervisor) {		\
>+		xor_speed(&xor_block_8regs);	\
>+		xor_speed(&xor_block_8regs_p);	\
>+		xor_speed(&xor_block_32regs);	\
>+		xor_speed(&xor_block_32regs_p);	\
>+	}					\
> } while (0)
> 
> #endif /* _ASM_X86_XOR_64_H */

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
