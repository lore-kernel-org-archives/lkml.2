Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1AaPQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:16:41 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:9015 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1AaPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:16:40 -0500
X-IronPort-AV: E=Sophos;i="4.60,404,1291593600"; 
   d="scan'208";a="4064331"
Date: Mon, 31 Jan 2011 15:18:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <hpa@zytor.com>, <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jan Beulich <JBeulich@novell.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
Message-ID: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/mm/init: respect memblock reserved regions when destroying mappings

In init_memory_mapping we are destroying all the mappings between
_brk_end and _end, no matter if some memory areas in that range have
been reserved using memblock_x86_reserve_range.
Besides if _end is not pmd aligned we might destroy the
mappings for valid memory between _end and the following pmd.

In order to avoid this problem, before clearing any pmds we check if the
corresponding memory area has been reserved and we only destroy the
mapping if it hasn't.

We found this problem because under Xen we have a valid mapping at _end,
and if _end is not pmd aligned the current code destroys the initial
part of it.

In practice this fix does not have any impact on native.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 947f42a..66637bd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -283,6 +283,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem && !start) {
 		pud_t *pud;
 		pmd_t *pmd;
+		unsigned long addr;
+		u64 size, memblock_addr;
 
 		mmu_cr4_features = read_cr4();
 
@@ -291,11 +293,18 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		 * located on different 2M pages. cleanup_highmap(), however,
 		 * can only consider _end when it runs, so destroy any
 		 * mappings beyond _brk_end here.
+		 * Respect memblock reserved regions.
 		 */
 		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
 		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
+		addr = (_brk_end + PMD_SIZE - 1) & PMD_MASK;
+		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1)) {
+			memblock_addr = memblock_x86_find_in_range_size(__pa(addr),
+					&size, PMD_SIZE);
+			if (memblock_addr == (u64) __pa(addr) && size >= PMD_SIZE)
+				pmd_clear(pmd);
+			addr += PMD_SIZE;
+		}
 	}
 #endif
 	__flush_tlb_all();
