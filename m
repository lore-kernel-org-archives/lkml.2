Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2I0V6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:58:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0V6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:58:09 -0400
Date: Thu, 27 Sep 2012 14:57:53 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-429c5a7fa9294e9792116d6ba1016b2cf39572e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        josh@joshtriplett.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, josh@joshtriplett.org, matt.fleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <c93d14d6431b77243af921cf0a54ecbf4676aa55.1347141698.git.josh@joshtriplett.org>
References: <c93d14d6431b77243af921cf0a54ecbf4676aa55.1347141698.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi:
  Add a function to look up existing IO memory mappings
Git-Commit-ID: 429c5a7fa9294e9792116d6ba1016b2cf39572e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 27 Sep 2012 14:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  429c5a7fa9294e9792116d6ba1016b2cf39572e4
Gitweb:     http://git.kernel.org/tip/429c5a7fa9294e9792116d6ba1016b2cf39572e4
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sat, 8 Sep 2012 15:09:19 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Sep 2012 14:43:32 -0700

efi: Add a function to look up existing IO memory mappings

The EFI initialization creates virtual mappings for EFI boot services
memory, so if a driver wants to access EFI boot services memory, it
cannot call ioremap itself; doing so will trip the WARN about mapping
RAM twice.  Thus, a driver accessing EFI boot services memory must do so
via the existing mapping already created during EFI intiialization.
Since the EFI code already maintains a memory map for that memory, add a
function efi_lookup_mapped_addr to look up mappings in that memory map.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/c93d14d6431b77243af921cf0a54ecbf4676aa55.1347141698.git.josh@joshtriplett.org
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |   28 ++++++++++++++++++++++++++++
 include/linux/efi.h         |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b3dbbdb..78d3343 100644
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
