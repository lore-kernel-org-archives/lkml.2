Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2I2XOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 19:14:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2I2XOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 19:14:34 -0400
Date: Sat, 29 Sep 2012 16:14:17 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-7bc90e01c3f66c137e7e761f574bbf883087d590@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        josh@joshtriplett.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, josh@joshtriplett.org, hpa@linux.intel.com
In-Reply-To: <0eb48ae012797912874919110660ad420b90268b.1348876882.git.josh@joshtriplett.org>
References: <0eb48ae012797912874919110660ad420b90268b.1348876882.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi:
  Add a function to look up existing IO memory mappings
Git-Commit-ID: 7bc90e01c3f66c137e7e761f574bbf883087d590
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 29 Sep 2012 16:14:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bc90e01c3f66c137e7e761f574bbf883087d590
Gitweb:     http://git.kernel.org/tip/7bc90e01c3f66c137e7e761f574bbf883087d590
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Fri, 28 Sep 2012 17:56:08 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 29 Sep 2012 12:21:02 -0700

efi: Add a function to look up existing IO memory mappings

The EFI initialization creates virtual mappings for EFI boot services
memory, so if a driver wants to access EFI boot services memory, it
cannot call ioremap itself; doing so will trip the WARN about mapping
RAM twice.  Thus, a driver accessing EFI boot services memory must do so
via the existing mapping already created during EFI intiialization.
Since the EFI code already maintains a memory map for that memory, add a
function efi_lookup_mapped_addr to look up mappings in that memory map.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/0eb48ae012797912874919110660ad420b90268b.1348876882.git.josh@joshtriplett.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |   28 ++++++++++++++++++++++++++++
 include/linux/efi.h         |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b3dbbdb..f7f928c 100644
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
+			return (__force void __iomem *)(unsigned long)phys_addr;
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
index 5782114..fff135d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -501,6 +501,7 @@ extern void efi_free_boot_services(void);
 #else
 static inline void efi_free_boot_services(void) {}
 #endif
+extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
