Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0LMA07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:26:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab0LLXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: mikey@neuling.org, benh@kernel.crashing.org, ak@linux.intel.com,
        david@gibson.dropbear.id.au, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [37/223] powerpc: Fix call to subpage_protection()
Message-Id: <20101212234533.C3B30B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael Neuling <mikey@neuling.org>

commit 1c2c25c78740b2796c7c06640784cb6732fa4907 upstream.

In:
  powerpc/mm: Fix pgtable cache cleanup with CONFIG_PPC_SUBPAGE_PROT
  commit d28513bc7f675d28b479db666d572e078ecf182d
  Author: David Gibson <david@gibson.dropbear.id.au>

subpage_protection() was changed to to take an mm rather a pgdir but it
didn't change calling site in hashpage_preload().  The change wasn't
noticed at compile time since hashpage_preload() used a void* as the
parameter to subpage_protection().

This is obviously wrong and can trigger the following crash when
CONFIG_SLAB, CONFIG_DEBUG_SLAB, CONFIG_PPC_64K_PAGES
CONFIG_PPC_SUBPAGE_PROT are enabled.

Freeing unused kernel memory: 704k freed
Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6c49b7
Faulting instruction address: 0xc0000000000410f4
cpu 0x2: Vector: 300 (Data Access) at [c00000004233f590]
    pc: c0000000000410f4: .hash_preload+0x258/0x338
    lr: c000000000041054: .hash_preload+0x1b8/0x338
    sp: c00000004233f810
   msr: 8000000000009032
   dar: 6b6b6b6b6b6c49b7
 dsisr: 40000000
  current = 0xc00000007e2c0070
  paca    = 0xc000000007fe0500
    pid   = 1, comm = init
enter ? for help
[c00000004233f810] c000000000041020 .hash_preload+0x184/0x338 (unreliable)
[c00000004233f8f0] c00000000003ed98 .update_mmu_cache+0xb0/0xd0
[c00000004233f990] c000000000157754 .__do_fault+0x48c/0x5dc
[c00000004233faa0] c000000000158fd0 .handle_mm_fault+0x508/0xa8c
[c00000004233fb90] c0000000006acdd4 .do_page_fault+0x428/0x6ac
[c00000004233fe30] c000000000005260 handle_page_fault+0x20/0x74

Reported-by: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/hash_utils_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/powerpc/mm/hash_utils_64.c
===================================================================
--- linux.orig/arch/powerpc/mm/hash_utils_64.c
+++ linux/arch/powerpc/mm/hash_utils_64.c
@@ -1122,7 +1122,7 @@ void hash_preload(struct mm_struct *mm,
 	else
 #endif /* CONFIG_PPC_HAS_HASH_64K */
 		rc = __hash_page_4K(ea, access, vsid, ptep, trap, local, ssize,
-				    subpage_protection(pgdir, ea));
+				    subpage_protection(mm, ea));
 
 	/* Dump some info in case of hash insertion failure, they should
 	 * never happen so it is really useful to know if/when they do
