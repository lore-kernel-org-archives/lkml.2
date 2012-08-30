Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2H3V24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:28:56 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38068 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2H3V2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:28:53 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 14:28:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/3] efi: Add a function to look up existing IO memory
 mappings
Message-ID: <5563b7d0ce3577f421e9622063a58aa4003ec917.1346361959.git.josh@joshtriplett.org>
References: <cover.1346361959.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346361959.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EFI initialization creates virtual mappings for EFI boot services
memory, so if a driver wants to access EFI boot services memory, it
cannot call ioremap itself; doing so will trip the WARN about mapping
RAM twice.  Thus, a driver accessing EFI boot services memory must do so
via the existing mapping already created during EFI intiialization.
Since the EFI code already maintains a memory map for that memory, add a
function efi_lookup_mapped_addr to look up mappings in that memory map.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/platform/efi/efi.c |   28 ++++++++++++++++++++++++++++
 include/linux/efi.h         |    1 +
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 8af329f..ae35cc8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -777,6 +777,34 @@ static void __init runtime_code_page_mkexec(void)
 }
 
 /*
+ * We can't ioremap data in EFI boot services RAM, because we've already mapped
+ * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
+ * callable after efi_enter_virtual_mode and before efi_free_boot_services.
+ */
+void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
+{
+	void *p;
+	if (WARN_ON(!memmap.map))
+		return NULL;
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 end = md->phys_addr + size;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+		if (!md->virt_addr)
+			continue;
+		if (phys_addr >= md->phys_addr && phys_addr < end) {
+			phys_addr += md->virt_addr - md->phys_addr;
+			return (__force void __iomem *)phys_addr;
+		}
+	}
+	return NULL;
+}
+
+/*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor and update
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 00ec70f..0c11a58 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -496,6 +496,7 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern void efi_free_boot_services(void);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
-- 
1.7.10.4

