Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2IIXVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:21:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51552 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438Ab2IIXRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:18 -0400
Message-Id: <20120909224153.774684501@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 21/95] ARM: 7489/1: errata: fix workaround for erratum #720789 on UP
 systems
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 730a8128cd8978467eb1cf546b11014acb57d433 upstream.

Commit 5a783cbc4836 ("ARM: 7478/1: errata: extend workaround for erratum
 #720789") added workarounds for erratum #720789 to the range TLB
invalidation functions with the observation that the erratum only
affects SMP platforms. However, when running an SMP_ON_UP kernel on a
uniprocessor platform we must take care to preserve the ASID as the
workaround is not required.

This patch ensures that we don't set the ASID to 0 when flushing the TLB
on such a system, preserving the original behaviour with the workaround
disabled.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/tlb-v7.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/tlb-v7.S b/arch/arm/mm/tlb-v7.S
index c202113..ea94765 100644
--- a/arch/arm/mm/tlb-v7.S
+++ b/arch/arm/mm/tlb-v7.S
@@ -38,10 +38,10 @@ ENTRY(v7wbi_flush_user_tlb_range)
 	dsb
 	mov	r0, r0, lsr #PAGE_SHIFT		@ align address
 	mov	r1, r1, lsr #PAGE_SHIFT
-#ifdef CONFIG_ARM_ERRATA_720789
-	mov	r3, #0
-#else
 	asid	r3, r3				@ mask ASID
+#ifdef CONFIG_ARM_ERRATA_720789
+	ALT_SMP(W(mov)	r3, #0	)
+	ALT_UP(W(nop)		)
 #endif
 	orr	r0, r3, r0, lsl #PAGE_SHIFT	@ Create initial MVA
 	mov	r1, r1, lsl #PAGE_SHIFT


