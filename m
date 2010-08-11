Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab0HKX5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:57:53 -0400
Received: from kroah.org ([198.145.64.141]:40106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab0HKX5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:48 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:57 2010
Message-Id: <20100811235457.572172274@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [022/111] ARM: 6299/1: errata: TLBIASIDIS and TLBIMVAIS operations can broadcast a faulty ASID
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit cdf357f1e13a08a11261edacb3083746f65c1ed9 upstream.

On versions of the Cortex-A9 prior to r2p0, performing TLB invalidations by
ASID match can result in the incorrect ASID being broadcast to other CPUs.
As a consequence of this, the targetted TLB entries are not invalidated
across the system.

This workaround changes the TLB flushing routines to invalidate entries
regardless of the ASID.

Tested-by: Rob Clark <rob@ti.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/Kconfig                |   12 ++++++++++++
 arch/arm/include/asm/tlbflush.h |    8 ++++++++
 2 files changed, 20 insertions(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -887,6 +887,18 @@ config ARM_ERRATA_460075
 	  ACTLR register. Note that setting specific bits in the ACTLR register
 	  may not be available in non-secure mode.
 
+config ARM_ERRATA_720789
+	bool "ARM errata: TLBIASIDIS and TLBIMVAIS operations can broadcast a faulty ASID"
+	depends on CPU_V7 && SMP
+	help
+	  This option enables the workaround for the 720789 Cortex-A9 (prior to
+	  r2p0) erratum. A faulty ASID can be sent to the other CPUs for the
+	  broadcasted CP15 TLB maintenance operations TLBIASIDIS and TLBIMVAIS.
+	  As a consequence of this erratum, some TLB entries which should be
+	  invalidated are not, resulting in an incoherency in the system page
+	  tables. The workaround changes the TLB flushing routines to invalidate
+	  entries regardless of the ASID.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -369,7 +369,11 @@ static inline void local_flush_tlb_mm(st
 	if (tlb_flag(TLB_V6_I_ASID))
 		asm("mcr p15, 0, %0, c8, c5, 2" : : "r" (asid) : "cc");
 	if (tlb_flag(TLB_V7_UIS_ASID))
+#ifdef CONFIG_ARM_ERRATA_720789
+		asm("mcr p15, 0, %0, c8, c3, 0" : : "r" (zero) : "cc");
+#else
 		asm("mcr p15, 0, %0, c8, c3, 2" : : "r" (asid) : "cc");
+#endif
 
 	if (tlb_flag(TLB_BTB)) {
 		/* flush the branch target cache */
@@ -409,7 +413,11 @@ local_flush_tlb_page(struct vm_area_stru
 	if (tlb_flag(TLB_V6_I_PAGE))
 		asm("mcr p15, 0, %0, c8, c5, 1" : : "r" (uaddr) : "cc");
 	if (tlb_flag(TLB_V7_UIS_PAGE))
+#ifdef CONFIG_ARM_ERRATA_720789
+		asm("mcr p15, 0, %0, c8, c3, 3" : : "r" (uaddr & PAGE_MASK) : "cc");
+#else
 		asm("mcr p15, 0, %0, c8, c3, 1" : : "r" (uaddr) : "cc");
+#endif
 
 	if (tlb_flag(TLB_BTB)) {
 		/* flush the branch target cache */


