Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1FNSIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:08:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53835 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1FNSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=g8BjSWMYdbSqg5xylQT/z9lX/uQod1v5K/j966AEmbSPf2f/sBMUU0oYX0oqVYqn7w
         iaxHdg+ywblfkfzvQKAeTqtWOBON9InH34d61y5SRb2GnnxRuGAXnl5kJiUo2NqYYRIk
         1k2A3A6vFsPE4wJcpwAs/3uGlIeML1tC1L+KI=
Message-ID: <4DF7A005.1050407@gmail.com>
Date: Tue, 14 Jun 2011 19:53:09 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Joe Perches <joe@perches.com>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] x86, efi: Do not reserve boot services regions within
 reserved areas
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 916f676f8dc started reserving boot service code since some systems
require you to keep that code around until SetVirtualAddressMap is called.

However, in some cases those areas will overlap with reserved regions.
The proper medium-term fix is to fix the bootloader to prevent the
conflicts from occurring by moving the kernel to a better position,
but the kernel should check for this possibility, and only reserve regions
which can be reserved.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
V2: Removed some printks and a unrelated change
V3: Another printk change

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
index 0d3a4fa..23c50e8 100644
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


