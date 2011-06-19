Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1FSJJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:09:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab1FSJJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:09:17 -0400
Date: Sun, 19 Jun 2011 11:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110619090911.GA27871@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus


out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
MAINTAINERS                        # c1f5c54: x86, MAINTAINERS: Add x86 MCE peo

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86, MAINTAINERS: Add x86 MCE people

Maarten Lankhorst (1):
      x86, efi: Do not reserve boot services regions within reserved areas


 MAINTAINERS                     |    7 +++++++
 arch/x86/include/asm/memblock.h |    2 +-
 arch/x86/mm/memblock.c          |    4 ++--
 arch/x86/platform/efi/efi.c     |   29 +++++++++++++++++++++++++----
 4 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 502f2dd..b12b8c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7007,6 +7007,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+X86 MCE INFRASTRUCTURE
+M:	Tony Luck <tony.luck@intel.com>
+M:	Borislav Petkov <bp@amd64.org>
+L:	linux-edac@vger.kernel.org
+S:	Maintained
+F:	arch/x86/kernel/cpu/mcheck/*
+
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 19ae14b..0cd3800 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -4,7 +4,6 @@
 #define ARCH_DISCARD_MEMBLOCK
 
 u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
-void memblock_x86_to_bootmem(u64 start, u64 end);
 
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
@@ -19,5 +18,6 @@ u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
+bool memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
 
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index aa11693..992da5e 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -8,7 +8,7 @@
 #include <linux/range.h>
 
 /* Check for already reserved areas */
-static bool __init check_with_memblock_reserved_size(u64 *addrp, u64 *sizep, u64 align)
+bool __init memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align)
 {
 	struct memblock_region *r;
 	u64 addr = *addrp, last;
@@ -59,7 +59,7 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
 		if (addr >= ei_last)
 			continue;
 		*sizep = ei_last - addr;
-		while (check_with_memblock_reserved_size(&addr, sizep, align))
+		while (memblock_x86_check_reserved_size(&addr, sizep, align))
 			;
 
 		if (*sizep)
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..474356b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -310,14 +310,31 @@ void __init efi_reserve_boot_services(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 start = md->phys_addr;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
-
-		memblock_x86_reserve_range(start, start + size, "EFI Boot");
+		/* Only reserve where possible:
+		 * - Not within any already allocated areas
+		 * - Not over any memory area (really needed, if above?)
+		 * - Not within any part of the kernel
+		 * - Not the bios reserved area
+		*/
+		if ((start+size >= virt_to_phys(_text)
+				&& start <= virt_to_phys(_end)) ||
+			!e820_all_mapped(start, start+size, E820_RAM) ||
+			memblock_x86_check_reserved_size(&start, &size,
+							1<<EFI_PAGE_SHIFT)) {
+			/* Could not reserve, skip it */
+			md->num_pages = 0;
+			memblock_dbg(PFX "Could not reserve boot range "
+					"[0x%010llx-0x%010llx]\n",
+						start, start+size-1);
+		} else
+			memblock_x86_reserve_range(start, start+size,
+							"EFI Boot");
 	}
 }
 
@@ -334,6 +351,10 @@ static void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
+		/* Could not reserve boot area */
+		if (!size)
+			continue;
+
 		free_bootmem_late(start, size);
 	}
 }
