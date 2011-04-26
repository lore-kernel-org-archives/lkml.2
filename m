Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab1DZWmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:42:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29984 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab1DZWms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:42:48 -0400
Message-ID: <4DB74A50.3080804@kernel.org>
Date: Tue, 26 Apr 2011 15:42:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, efi: Only print warning when desc_size is smaller than
 defined one.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DB74A5A.00AE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One system get warning:
	Kernel-defined memdesc doesn't match the one from EFI!

UEFI spec allows GetMemoryMap() return bigger desc_size and desc_ver for future
extension.
And desc_size is already used to get offset of next memory entry.

Only need to check if desc_size is smaller than defined struct.

Also print the size in warning if it happens.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/platform/efi/efi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/platform/efi/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -448,9 +448,10 @@ void __init efi_init(void)
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 
-	if (memmap.desc_size != sizeof(efi_memory_desc_t))
+	if (memmap.desc_size < sizeof(efi_memory_desc_t))
 		printk(KERN_WARNING
-		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
+		  "Kernel-defined memdesc size is bigger than the one from EFI! %ld > %ld\n",
+			 sizeof(efi_memory_desc_t), memmap.desc_size);
 
 	if (add_efi_memmap)
 		do_add_efi_memmap();
