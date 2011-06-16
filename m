Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1FPHLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48976 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923Ab1FPHK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:59 -0400
X-Sasl-enc: sfji4gBWcnXMx4pwLwjkXUIHDCjRumsyPLiQFU87SycE 1308208258
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:07 2011
Message-Id: <20110616002907.903001241@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [41/85] ARM: 6941/1: cache: ensure MVA is cacheline aligned in
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
 flush_kern_dcache_area

From: Will Deacon <will.deacon@arm.com>

commit a248b13b21ae00b97638b4f435c8df3075808b5d upstream.

The v6 and v7 implementations of flush_kern_dcache_area do not align
the passed MVA to the size of a cacheline in the data cache. If a
misaligned address is used, only a subset of the requested area will
be flushed. This has been observed to cause failures in SMP boot where
the secondary_data initialised by the primary CPU is not cacheline
aligned, causing the secondary CPUs to read incorrect values for their
pgd and stack pointers.

This patch ensures that the base address is cacheline aligned before
flushing the d-cache.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/cache-v6.S |    1 +
 arch/arm/mm/cache-v7.S |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -169,6 +169,7 @@ ENDPROC(v6_coherent_kern_range)
  */
 ENTRY(v6_flush_kern_dcache_area)
 	add	r1, r0, r1
+	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
 1:
 #ifdef HARVARD_CACHE
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -197,6 +197,8 @@ ENDPROC(v7_coherent_user_range)
 ENTRY(v7_flush_kern_dcache_area)
 	dcache_line_size r2, r3
 	add	r1, r0, r1
+	sub	r3, r2, #1
+	bic	r0, r0, r3
 1:
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line / unified line
 	add	r0, r0, r2


