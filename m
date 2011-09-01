Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1IAGzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:55:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:29910 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab1IAGzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:55:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,312,1312182000"; 
   d="scan'208";a="44590614"
Subject: [PATCH] EFI: Do not use __pa() to get the physical address of an
 ioremapped memory range
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 14:55:14 +0800
Message-ID: <1314860114.32522.3.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>
Date: Wed, 31 Aug 2011 09:59:01 +0800
Subject: Do not use __pa() to get the physical address of an ioremapped memory range.

set_memory_uc uses __pa() to translate the virtual address to the physical address.
This breaks a EFI_MEMORY_MAPPED_IO memory region in my case as it was ioremapped first.

<1>[    0.029956] BUG: unable to handle kernel paging request at f7f22280
<1>[    0.042049] IP: [<c10257b9>] reserve_ram_pages_type+0x89/0x210
<4>[    0.053465] *pdpt = 0000000001978001 *pde = 0000000001ffb067 *pte = 0000000000000000
<0>[    0.068781] Oops: 0000 [#1] PREEMPT SMP
<4>[    0.076441] Modules linked in:
<4>[    0.082399]
<4>[    0.085304] Pid: 0, comm: swapper Not tainted 3.0.0-acpi-efi-0805 #3
<4>[    0.098067] EIP: 0060:[<c10257b9>] EFLAGS: 00010202 CPU: 0
<4>[    0.108810] EIP is at reserve_ram_pages_type+0x89/0x210
<4>[    0.119022] EAX: 0070e280 EBX: 38714000 ECX: f7814000 EDX: 00000000
<4>[    0.131284] ESI: 00000000 EDI: 38715000 EBP: c189fef0 ESP: c189fea8
<4>[    0.143543]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>[    0.154099] Process swapper (pid: 0, ti=c189e000 task=c18bbe60 task.ti=c189e000)
<0>[    0.168576] Stack:
<4>[    0.172475]  80000200 ff108000 00000000 c189ff00 00038714 00000000 00000000 c189fed0
<4>[    0.187623]  c104f8ca 00038714 00000000 00038715 00000000 00000000 00038715 00000000
<4>[    0.202777]  00000010 38715000 c189ff48 c1025aff 38715000 00000000 00000010 00000000
<0>[    0.217930] Call Trace:
<4>[    0.222722]  [<c104f8ca>] ? page_is_ram+0x1a/0x40
<4>[    0.231916]  [<c1025aff>] reserve_memtype+0xdf/0x2f0
<4>[    0.241622]  [<c1024dc9>] set_memory_uc+0x49/0xa0
<4>[    0.250818]  [<c19334d0>] efi_enter_virtual_mode+0x1c2/0x3aa
<4>[    0.261887]  [<c19216d4>] start_kernel+0x291/0x2f2
<4>[    0.271245]  [<c19211c7>] ? loglevel+0x1b/0x1b
<4>[    0.279929]  [<c19210bf>] i386_start_kernel+0xbf/0xc8
---
 arch/x86/platform/efi/efi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: acpi50/arch/x86/platform/efi/efi.c
===================================================================
--- acpi50.orig/arch/x86/platform/efi/efi.c
+++ acpi50/arch/x86/platform/efi/efi.c
@@ -44,6 +44,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
+#include <asm/pat.h>
 
 #define EFI_DEBUG	1
 #define PFX 		"EFI: "
@@ -687,7 +688,13 @@ void __init efi_enter_virtual_mode(void)
 			addr = md->virt_addr;
 			npages = md->num_pages;
 			memrange_efi_to_native(&addr, &npages);
-			set_memory_uc(addr, npages);
+			if (reserve_memtype(md->phys_addr, md->phys_addr + npages * PAGE_SIZE,
+					_PAGE_CACHE_UC_MINUS, NULL)) {
+				printk(KERN_ERR PFX "failed to reserve region as uncacheable\n");
+			} elif (_set_memory_uc(addr, npages)) {
+				printk(KERN_ERR PFX "failed to set region to uncacheable\n");
+				free_memtype(md->phys_addr, md->phys_addr + npages * PAGE_SIZE);
+			}
 		}
 
 		systab = (u64) (unsigned long) efi_phys.systab;


