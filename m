Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab1IIOSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:18:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43018 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1IIOSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:18:22 -0400
Date: Fri, 9 Sep 2011 09:18:21 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Russ Anderson <rja@sgi.com>, stable@kernel.org
Subject: [PATCH] x86, efi: Regression in Pass a minimal map to SetVirtualAddressMap()
Message-ID: <20110909141820.GA7634@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7cb00b72876ea2451eb79d468da0e8fb9134aa8a allocated a new memmap
table to be passed down to bios.  The problem is that there needs to be a 
physical mapping of the table for bios to access it.  The bottom 512Gig
of memory has a physical mapping, so if the table is in that range 
bios can access it.  If the table is above that range bios cannot.  
UV systems with more than 512Gig of memory have hit this problem.

This patch undoes the previous commit, reverting back to using the
old memmap table.

Reported-by: Russ Anderson <rja@sgi.com>
Tested-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: stable@kernel.org


---
 arch/x86/platform/efi/efi.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux/arch/x86/platform/efi/efi.c
===================================================================
--- linux.orig/arch/x86/platform/efi/efi.c	2011-09-08 15:07:33.099462927 -0500
+++ linux/arch/x86/platform/efi/efi.c	2011-09-08 15:13:18.843970180 -0500
@@ -625,8 +625,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_status_t status;
 	unsigned long size;
 	u64 end, systab, addr, npages, end_pfn;
-	void *p, *va, *new_memmap = NULL;
-	int count = 0;
+	void *p, *va;
 
 	efi.systab = NULL;
 
@@ -695,21 +694,15 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
-		memcpy(new_memmap + (count * memmap.desc_size), md,
-		       memmap.desc_size);
-		count++;
 	}
 
 	BUG_ON(!efi.systab);
 
 	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * count,
+		memmap.desc_size * memmap.nr_map,
 		memmap.desc_size,
 		memmap.desc_version,
-		(efi_memory_desc_t *)__pa(new_memmap));
+		memmap.phys_map);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
@@ -747,7 +740,6 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
-	kfree(new_memmap);
 }
 
 /*
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
