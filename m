Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2IJMkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:40:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34458 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab2IJMkU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 10 Sep 2012 08:40:20 -0400
Message-Id: <504DFBD0020000780009A32D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:40:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] x86/xor: make virtualization friendly
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In virtualized environments, the CR0.TS management needed here can be a
lot slower than anticipated by the original authors of this code, which
particularly means that in such cases forcing the use of SSE- (or MMX-)
based implementations is not desirable - actual measurements should
always be done in that case.

For consistency, pull into the shared (32- and 64-bit) header not only
the inclusion of the generic code, but also that of the AVX variants.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

---
 arch/x86/include/asm/xor.h    |    8 +++++++-
 arch/x86/include/asm/xor_32.h |   22 ++++++++++------------
 arch/x86/include/asm/xor_64.h |   10 ++++++----
 3 files changed, 23 insertions(+), 17 deletions(-)

--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor.h
@@ -547,6 +547,12 @@ static struct xor_block_template xor_blo
 #undef XOR_MOV
 #undef XOR_CONSTANT_CONSTRAINT
 
+/* Also try the AVX routines */
+#include "xor_avx.h"
+
+/* Also try the generic routines. */
+#include <asm-generic/xor.h>
+
 #ifdef CONFIG_X86_32
 # include "xor_32.h"
 #else
@@ -554,6 +560,6 @@ static struct xor_block_template xor_blo
 #endif
 
 #define XOR_SELECT_TEMPLATE(FASTEST) \
-	AVX_SELECT(FASTEST)
+	(cpu_has_hypervisor ? (FASTEST) : AVX_SELECT(FASTEST))
 
 #endif /* _ASM_X86_XOR_H */
--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor_32.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor_32.h
@@ -537,12 +537,6 @@ static struct xor_block_template xor_blo
 	.do_5 = xor_sse_5,
 };
 
-/* Also try the AVX routines */
-#include "xor_avx.h"
-
-/* Also try the generic routines.  */
-#include <asm-generic/xor.h>
-
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
@@ -553,15 +547,19 @@ do {							\
 	if (cpu_has_xmm) {				\
 		xor_speed(&xor_block_pIII_sse);		\
 		xor_speed(&xor_block_sse_pf64);		\
-	} else if (cpu_has_mmx) {			\
+		if (!cpu_has_hypervisor)		\
+			break;				\
+	}						\
+	if (cpu_has_mmx) {				\
 		xor_speed(&xor_block_pII_mmx);		\
 		xor_speed(&xor_block_p5_mmx);		\
-	} else {					\
-		xor_speed(&xor_block_8regs);		\
-		xor_speed(&xor_block_8regs_p);		\
-		xor_speed(&xor_block_32regs);		\
-		xor_speed(&xor_block_32regs_p);		\
+		if (!cpu_has_hypervisor)		\
+			break;				\
 	}						\
+	xor_speed(&xor_block_8regs);			\
+	xor_speed(&xor_block_8regs_p);			\
+	xor_speed(&xor_block_32regs);			\
+	xor_speed(&xor_block_32regs_p);			\
 } while (0)
 
 #endif /* _ASM_X86_XOR_32_H */
--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor_64.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor_64.h
@@ -9,10 +9,6 @@ static struct xor_block_template xor_blo
 	.do_5 = xor_sse_5,
 };
 
-
-/* Also try the AVX routines */
-#include "xor_avx.h"
-
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
@@ -22,6 +18,12 @@ do {						\
 	AVX_XOR_SPEED;				\
 	xor_speed(&xor_block_sse_pf64);		\
 	xor_speed(&xor_block_sse);		\
+	if (cpu_has_hypervisor) {		\
+		xor_speed(&xor_block_8regs);	\
+		xor_speed(&xor_block_8regs_p);	\
+		xor_speed(&xor_block_32regs);	\
+		xor_speed(&xor_block_32regs_p);	\
+	}					\
 } while (0)
 
 #endif /* _ASM_X86_XOR_64_H */



