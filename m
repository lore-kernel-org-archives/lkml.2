Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2HGDt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:49:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59751 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757362Ab2HGDie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:34 -0400
Message-Id: <20120807032803.353647509@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 50/70] ARM: 7478/1: errata: extend workaround for erratum #720789
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 5a783cbc48367cfc7b65afc75430953dfe60098f upstream.

Commit cdf357f1 ("ARM: 6299/1: errata: TLBIASIDIS and TLBIMVAIS
operations can broadcast a faulty ASID") replaced by-ASID TLB flushing
operations with all-ASID variants to workaround A9 erratum #720789.

This patch extends the workaround to include the tlb_range operations,
which were overlooked by the original patch.

Tested-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/tlb-v7.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mm/tlb-v7.S b/arch/arm/mm/tlb-v7.S
index 845f461..c202113 100644
--- a/arch/arm/mm/tlb-v7.S
+++ b/arch/arm/mm/tlb-v7.S
@@ -38,11 +38,19 @@ ENTRY(v7wbi_flush_user_tlb_range)
 	dsb
 	mov	r0, r0, lsr #PAGE_SHIFT		@ align address
 	mov	r1, r1, lsr #PAGE_SHIFT
+#ifdef CONFIG_ARM_ERRATA_720789
+	mov	r3, #0
+#else
 	asid	r3, r3				@ mask ASID
+#endif
 	orr	r0, r3, r0, lsl #PAGE_SHIFT	@ Create initial MVA
 	mov	r1, r1, lsl #PAGE_SHIFT
 1:
+#ifdef CONFIG_ARM_ERRATA_720789
+	ALT_SMP(mcr	p15, 0, r0, c8, c3, 3)	@ TLB invalidate U MVA all ASID (shareable)
+#else
 	ALT_SMP(mcr	p15, 0, r0, c8, c3, 1)	@ TLB invalidate U MVA (shareable)
+#endif
 	ALT_UP(mcr	p15, 0, r0, c8, c7, 1)	@ TLB invalidate U MVA
 
 	add	r0, r0, #PAGE_SZ
@@ -67,7 +75,11 @@ ENTRY(v7wbi_flush_kern_tlb_range)
 	mov	r0, r0, lsl #PAGE_SHIFT
 	mov	r1, r1, lsl #PAGE_SHIFT
 1:
+#ifdef CONFIG_ARM_ERRATA_720789
+	ALT_SMP(mcr	p15, 0, r0, c8, c3, 3)	@ TLB invalidate U MVA all ASID (shareable)
+#else
 	ALT_SMP(mcr	p15, 0, r0, c8, c3, 1)	@ TLB invalidate U MVA (shareable)
+#endif
 	ALT_UP(mcr	p15, 0, r0, c8, c7, 1)	@ TLB invalidate U MVA
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1


