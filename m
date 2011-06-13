Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1FMQre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:47:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40232 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1FMQrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:47:32 -0400
Date: Mon, 13 Jun 2011 17:47:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110613164712.GA23343@srcf.ucam.org>
References: <4DECFC1C.10801@xs4all.nl>
 <4DED0394.2090000@gmail.com>
 <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com>
 <20110607014127.GA8450@srcf.ucam.org>
 <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
 <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF29E7E.50908@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's just try this in a somewhat more brute force way. Can you try 
this patch on top of current git, and give me the full dmesg and 
/proc/iomem ?

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..ffbe47c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -312,11 +312,35 @@ void __init efi_reserve_boot_services(void)
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		unsigned long long end = start + size;
 
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		if (md->type != EFI_BOOT_SERVICES_CODE)
 			continue;
 
+		/*
+		 * Trying to map EFI code over the zero page is just asking
+		 * for trouble. The good news is that it's almost certainly
+		 * only there for graphics card bringup at POST time, so
+		 * we should be able to get away with not having it there
+		 */
+
+		if (start == 0) {
+			md->num_pages = 0;
+			continue;
+		}
+
+		/*
+		 * We probably also want to avoid mapping code over the
+		 * kernel...
+		 */
+
+		if ((start <= virt_to_phys(_etext)-1 && end >= virt_to_phys(_text)) ||
+		    (start <= virt_to_phys(_edata)-1 && end >= virt_to_phys(_etext)) ||
+		    (start <= virt_to_phys(&__bss_stop)-1 && end >= virt_to_phys(&__bss_start))) {
+			md->num_pages = 0;
+			continue;
+		}
+
 		memblock_x86_reserve_range(start, start + size, "EFI Boot");
 	}
 }
@@ -330,8 +354,10 @@ static void __init efi_free_boot_services(void)
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		if (md->type != EFI_BOOT_SERVICES_CODE)
+			continue;
+
+		if (size == 0)
 			continue;
 
 		free_bootmem_late(start, size);
@@ -483,9 +509,6 @@ void __init efi_init(void)
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
-	/* Setup for EFI runtime service */
-	reboot_type = BOOT_EFI;
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif

-- 
Matthew Garrett | mjg59@srcf.ucam.org
