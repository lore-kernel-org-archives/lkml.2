Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1EETUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:20:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab1EETUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:20:09 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] efi: Pass a minimal map to SetVirtualAddressMap()
Date: Thu,  5 May 2011 15:19:45 -0400
Message-Id: <1304623186-18261-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1304623186-18261-1-git-send-email-mjg@redhat.com>
References: <1304623186-18261-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Experimentation with various EFI implementations has shown that functions
outside runtime services will still update their pointers if
SetVirtualAddressMap() is called with memory descriptors outside the
runtime area. This is obviously insane, and therefore is unsurprising.
Evidence from instrumenting another EFI implementation suggests that it
only passes the set of descriptors covering runtime regions, so let's
avoid any problems by doing the same. Runtime descriptors are copied to
a separate memory map, and only that map is passed back to the firmware.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index a46a73e..b30aa26 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -502,7 +502,8 @@ void __init efi_enter_virtual_mode(void)
 	efi_status_t status;
 	unsigned long size;
 	u64 end, systab, addr, npages, end_pfn;
-	void *p, *va;
+	void *p, *va, *new_memmap = NULL;
+	int count = 0;
 
 	efi.systab = NULL;
 
@@ -569,15 +570,21 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
+		new_memmap = krealloc(new_memmap,
+				      (count + 1) * memmap.desc_size,
+				      GFP_KERNEL);
+		memcpy(new_memmap + (count * memmap.desc_size), md,
+		       memmap.desc_size);
+		count++;
 	}
 
 	BUG_ON(!efi.systab);
 
 	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * memmap.nr_map,
+		memmap.desc_size * count,
 		memmap.desc_size,
 		memmap.desc_version,
-		memmap.phys_map);
+		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
@@ -605,6 +612,7 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
+	kfree(new_memmap);
 }
 
 /*
-- 
1.7.5

