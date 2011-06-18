Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1FRUzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 16:55:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:44526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1FRUzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 16:55:39 -0400
Date: Sat, 18 Jun 2011 20:55:28 GMT
From: tip-bot for Maarten Lankhorst <m.b.lankhorst@gmail.com>
Message-ID: <tip-7d68dc3f1003a38948c55c803c32d1989dd49198@git.kernel.org>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, m.b.lankhorst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg@redhat.com, m.b.lankhorst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4DF7A005.1050407@gmail.com>
References: <4DF7A005.1050407@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Do not reserve boot services regions within reserved areas
Git-Commit-ID: 7d68dc3f1003a38948c55c803c32d1989dd49198
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Jun 2011 20:55:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d68dc3f1003a38948c55c803c32d1989dd49198
Gitweb:     http://git.kernel.org/tip/7d68dc3f1003a38948c55c803c32d1989dd49198
Author:     Maarten Lankhorst <m.b.lankhorst@gmail.com>
AuthorDate: Tue, 14 Jun 2011 19:53:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jun 2011 22:48:49 +0200

x86, efi: Do not reserve boot services regions within reserved areas

Commit 916f676f8dc started reserving boot service code since some systems
require you to keep that code around until SetVirtualAddressMap is called.

However, in some cases those areas will overlap with reserved regions.
The proper medium-term fix is to fix the bootloader to prevent the
conflicts from occurring by moving the kernel to a better position,
but the kernel should check for this possibility, and only reserve regions
which can be reserved.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Link: http://lkml.kernel.org/r/4DF7A005.1050407@gmail.com
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/memblock.h |    2 +-
 arch/x86/mm/memblock.c          |    4 ++--
 arch/x86/platform/efi/efi.c     |   29 +++++++++++++++++++++++++----
 3 files changed, 28 insertions(+), 7 deletions(-)

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
