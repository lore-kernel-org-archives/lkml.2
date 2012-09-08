Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2IHWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:09:28 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48137 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2IHWJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:09:26 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.46.74
Date: Sat, 8 Sep 2012 15:09:19 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org
Subject: [PATCHv3 3/4] efi: Add a function to look up existing IO memory
 mappings
Message-ID: <c93d14d6431b77243af921cf0a54ecbf4676aa55.1347141698.git.josh@joshtriplett.org>
References: <cover.1347141698.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1347141698.git.josh@joshtriplett.org>
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
index ab2cfe8..90023d1 100644
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
index 3c72c27..00aa5de 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -502,6 +502,7 @@ extern void efi_free_boot_services(void);
 static void efi_enter_virtual_mode(void) {}
 static void efi_free_boot_services(void) {}
 #endif
+extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
-- 
1.7.10.4

