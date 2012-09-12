Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2ILXax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:30:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab2ILXar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:30:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 007/108] ARM: 7489/1: errata: fix workaround for erratum #720789 on UP systems
Date: Wed, 12 Sep 2012 16:28:05 -0700
Message-Id: <20120912232451.203499203@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/tlb-v7.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


