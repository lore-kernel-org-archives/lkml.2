Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1FGJIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:08:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44178 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1FGJIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iNIsapgDDElaxlFMUOeX2G0a5S8gjdagqX7bO6/fIDUHWnbmBDKwAtFNqtwJ6zMsmx
         u8wgPCj0lo49z0yIaS90uFvkDikuoQXxnaKuu8Tlu1HJTCMIHJDA0i1mNHOBAPyay0gl
         BaoBQvMAuU+aJXWNUzUJur3Hj5TyjoqqhEoTk=
Message-ID: <4DEDEA73.7010900@gmail.com>
Date: Tue, 07 Jun 2011 11:08:03 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org>
In-Reply-To: <4DED8752.5070005@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Op 07-06-11 04:05, Yinghai Lu schreef:
> On 06/06/2011 06:41 PM, Matthew Garrett wrote:
>> On Mon, Jun 06, 2011 at 05:19:17PM -0700, Yinghai Lu wrote:
>>
>>> assume EFI in ram is not page-aligned?
>> They'll be 4K aligned at least.
>>
>
> can you get boot log with "memblock=debug"?
Well that definitely helped me isolate things. It seems some ranges are reserved already.
I added a simple patch to ignore the reservations there. Just a proof of concept,
don't rate for style. :-)

diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index aa11693..013ecf5 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -8,7 +8,7 @@
 #include <linux/range.h>
 
 /* Check for already reserved areas */
-static bool __init check_with_memblock_reserved_size(u64 *addrp, u64 *sizep, u64 align)
+bool __init check_with_memblock_reserved_size(u64 *addrp, u64 *sizep, u64 align)
 {
 	struct memblock_region *r;
 	u64 addr = *addrp, last;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..eb3a4d9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -304,20 +304,29 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
+extern bool __init check_with_memblock_reserved_size(u64 *addrp,
+							u64 *sizep,
+							u64 align);
+
 void __init efi_reserve_boot_services(void)
 {
 	void *p;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 start = md->phys_addr;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
-
-		memblock_x86_reserve_range(start, start + size, "EFI Boot");
+		if (check_with_memblock_reserved_size(&start, &size, 1<<EFI_PAGE_SHIFT)) {
+			/* Could not reserve, skip it */
+			md->num_pages = 0;
+			printk(KERN_INFO PFX "Could not reserve boot area "
+				"[0x%llx - 0x%llx]\n", start, start+size);
+		} else
+			memblock_x86_reserve_range(start, start+size, "EFI Boot");
 	}
 }
 
@@ -334,6 +343,10 @@ static void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
+		/* Could not reserve boot area */
+		if (size)
+			continue;
+
 		free_bootmem_late(start, size);
 	}
 }


