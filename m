Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1AFA5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:57:45 -0500
Received: from kroah.org ([198.145.64.141]:35533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1AFA3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:17 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.759818209@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Valentine Barshak <vbarshak@mvista.com>,
        "George G. Davis" <gdavis@mvista.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [033/152] ARM: 6535/1: V6 MPCore v6_dma_inv_range and v6_dma_flush_range RWFO fix
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Valentine Barshak <vbarshak@mvista.com>

commit 85b093bcc5322baa811a03ec73de0909c157f181 upstream.

Cache ownership must be acquired by reading/writing data from the
cache line to make cache operation have the desired effect on the
SMP MPCore CPU. However, the ownership is never acquired in the
v6_dma_inv_range function when cleaning the first line and
flushing the last one, in case the address is not aligned
to D_CACHE_LINE_SIZE boundary.
Fix this by reading/writing data if needed, before performing
cache operations.
While at it, fix v6_dma_flush_range to prevent RWFO outside
the buffer.

Signed-off-by: Valentine Barshak <vbarshak@mvista.com>
Signed-off-by: George G. Davis <gdavis@mvista.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/cache-v6.S |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -196,6 +196,10 @@ ENTRY(v6_flush_kern_dcache_area)
  *	- end     - virtual end address of region
  */
 v6_dma_inv_range:
+#ifdef CONFIG_DMA_CACHE_RWFO
+	ldrb	r2, [r0]			@ read for ownership
+	strb	r2, [r0]			@ write for ownership
+#endif
 	tst	r0, #D_CACHE_LINE_SIZE - 1
 	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
 #ifdef HARVARD_CACHE
@@ -204,6 +208,10 @@ v6_dma_inv_range:
 	mcrne	p15, 0, r0, c7, c11, 1		@ clean unified line
 #endif
 	tst	r1, #D_CACHE_LINE_SIZE - 1
+#ifdef CONFIG_DMA_CACHE_RWFO
+	ldrneb	r2, [r1, #-1]			@ read for ownership
+	strneb	r2, [r1, #-1]			@ write for ownership
+#endif
 	bic	r1, r1, #D_CACHE_LINE_SIZE - 1
 #ifdef HARVARD_CACHE
 	mcrne	p15, 0, r1, c7, c14, 1		@ clean & invalidate D line
@@ -211,10 +219,6 @@ v6_dma_inv_range:
 	mcrne	p15, 0, r1, c7, c15, 1		@ clean & invalidate unified line
 #endif
 1:
-#ifdef CONFIG_DMA_CACHE_RWFO
-	ldr	r2, [r0]			@ read for ownership
-	str	r2, [r0]			@ write for ownership
-#endif
 #ifdef HARVARD_CACHE
 	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D line
 #else
@@ -222,6 +226,10 @@ v6_dma_inv_range:
 #endif
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	cmp	r0, r1
+#ifdef CONFIG_DMA_CACHE_RWFO
+	ldrlo	r2, [r0]			@ read for ownership
+	strlo	r2, [r0]			@ write for ownership
+#endif
 	blo	1b
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
@@ -256,12 +264,12 @@ v6_dma_clean_range:
  *	- end     - virtual end address of region
  */
 ENTRY(v6_dma_flush_range)
-	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
-1:
 #ifdef CONFIG_DMA_CACHE_RWFO
-	ldr	r2, [r0]			@ read for ownership
-	str	r2, [r0]			@ write for ownership
+	ldrb	r2, [r0]		@ read for ownership
+	strb	r2, [r0]		@ write for ownership
 #endif
+	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
+1:
 #ifdef HARVARD_CACHE
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
 #else
@@ -269,6 +277,10 @@ ENTRY(v6_dma_flush_range)
 #endif
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	cmp	r0, r1
+#ifdef CONFIG_DMA_CACHE_RWFO
+	ldrlob	r2, [r0]			@ read for ownership
+	strlob	r2, [r0]			@ write for ownership
+#endif
 	blo	1b
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer


