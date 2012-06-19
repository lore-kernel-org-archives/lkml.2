Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2FSLV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:21:27 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:50479 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab2FSLVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:21:20 -0400
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 16:51:16 +0530
Message-ID: <CADysL2acF3ttJ-TR2as+GT66MfJiK4YyWYaAiP5j8yQ+YLBGYQ@mail.gmail.com>
Subject: [PATCH v2 2/4] ARM: add flush_mem api for ARMv6
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 630a3a8f341eb7f58f9a63bf786d732b5bdfd01e Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Fri, 15 Jun 2012 16:39:21 +0530
Subject: [PATCH v2 2/4] ARM: add flush_mem api for ARMv6

Added flush_mem cache maintenance api for ARMv6.
The implementation is based on dma_flush_range.

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 arch/arm/mm/cache-v6.S |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 74c2e5a..f91d847 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -328,6 +328,34 @@ ENTRY(v6_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v6_dma_unmap_area)

+/*
+ *	v6_flush_mem(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(v6_flush_mem)
+#ifdef CONFIG_DMA_CACHE_RWFO
+	ldrb	r2, [r0]		@ read for ownership
+	strb	r2, [r0]		@ write for ownership
+#endif
+	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
+1:
+#ifdef HARVARD_CACHE
+	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
+#else
+	mcr	p15, 0, r0, c7, c15, 1		@ clean & invalidate line
+#endif
+	add	r0, r0, #D_CACHE_LINE_SIZE
+	cmp	r0, r1
+#ifdef CONFIG_DMA_CACHE_RWFO
+	ldrlob	r2, [r0]			@ read for ownership
+	strlob	r2, [r0]			@ write for ownership
+#endif
+	blo	1b
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(v6_flush_mem)
 	__INITDATA

 	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
-- 
1.7.0.4


-- 
regards
Ramesh Gupta G
