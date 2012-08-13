Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2HMWaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:30:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48802 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2HMWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:15:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Capper <steve.capper@arm.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 13/65] ARM: 7478/1: errata: extend workaround for erratum #720789
Date: Mon, 13 Aug 2012 15:13:57 -0700
Message-Id: <20120813221416.131732811@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/tlb-v7.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

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


