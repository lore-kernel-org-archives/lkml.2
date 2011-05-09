Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1EIXRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:17:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60098 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1EIXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:17:44 -0400
Date: Mon, 9 May 2011 23:17:39 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-7cb00b72876ea2451eb79d468da0e8fb9134aa8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1304623186-18261-4-git-send-email-mjg@redhat.com>
References: <1304623186-18261-4-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Pass a minimal map to SetVirtualAddressMap()
Git-Commit-ID: 7cb00b72876ea2451eb79d468da0e8fb9134aa8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 May 2011 23:17:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cb00b72876ea2451eb79d468da0e8fb9134aa8a
Gitweb:     http://git.kernel.org/tip/7cb00b72876ea2451eb79d468da0e8fb9134aa8a
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Thu, 5 May 2011 15:19:45 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 9 May 2011 12:14:39 -0700

x86, efi: Pass a minimal map to SetVirtualAddressMap()

Experimentation with various EFI implementations has shown that functions
outside runtime services will still update their pointers if
SetVirtualAddressMap() is called with memory descriptors outside the
runtime area. This is obviously insane, and therefore is unsurprising.
Evidence from instrumenting another EFI implementation suggests that it
only passes the set of descriptors covering runtime regions, so let's
avoid any problems by doing the same. Runtime descriptors are copied to
a separate memory map, and only that map is passed back to the firmware.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1304623186-18261-4-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
