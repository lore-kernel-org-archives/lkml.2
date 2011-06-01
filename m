Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162434Ab1FAI7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:59:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:44149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162166Ab1FAISK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:10 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:53 2011
Message-Id: <20110601080452.063075659@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:01:08 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [132/146] ARM: 6941/1: cache: ensure MVA is cacheline aligned in
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -176,6 +176,7 @@ ENDPROC(v6_coherent_kern_range)
  */
 ENTRY(v6_flush_kern_dcache_area)
 	add	r1, r0, r1
+	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
 1:
 #ifdef HARVARD_CACHE
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -221,6 +221,8 @@ ENDPROC(v7_coherent_user_range)
 ENTRY(v7_flush_kern_dcache_area)
 	dcache_line_size r2, r3
 	add	r1, r0, r1
+	sub	r3, r2, #1
+	bic	r0, r0, r3
 1:
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line / unified line
 	add	r0, r0, r2


