Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0DIR0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:26:16 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:22354 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0DIR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:26:13 -0400
Message-ID: <4BBF626A.3060800@oracle.com>
Date: Fri, 09 Apr 2010 10:22:50 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio> <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com>
In-Reply-To: <4BBF5987.3010100@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4BBF630F.0332:SCFMA4539814,ss=1,pt=DBB_66871,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 09:44 AM, H. Peter Anvin wrote:
> On 04/09/2010 09:04 AM, Bjorn Helgaas wrote:
>>>
>>> for 64 bit, you may check boot_params.screen_info.orig_video_isVGA to see if you need to reserve that VGA range.
>>> not sure if every bootloader fill that...
>>
>> Why is this different for 64-bit vs 32-bit?  Can you point me to any
>> references where I can learn about this?
>>
> 
> It's not.  Any differences between 32 and 64 bits in this area are just
> plain wrong.
> 

then please check this one

update e820 at first, and later put them resource tree, but give pci BAR chance to claim
the range, before assign unassigned resources.

in case some system doesn't have VGA, and use [0xa0000, ..] for mmio of some other pci devices.

Yinghai

Subject: [RFC PATCH] x86: reserve [0xa0000, 0x100000] in e820

And put those range in resource tree after pci BAR claim those range

---
 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/e820.c       |    2 +-
 arch/x86/kernel/head32.c     |    1 -
 arch/x86/kernel/setup.c      |   19 +------------------
 4 files changed, 2 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -44,7 +44,6 @@ static inline void visws_early_detect(vo
 extern unsigned long saved_video_mode;
 
 extern void reserve_standard_io_resources(void);
-extern void i386_reserve_resources(void);
 extern void setup_default_timer_irq(void);
 
 #ifdef CONFIG_X86_MRST
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1094,7 +1094,7 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (e820.map[i].type != E820_RESERVED) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -22,7 +22,6 @@ static void __init i386_default_early_se
 {
 	/* Initilize 32bit specific setup functions */
 	x86_init.resources.probe_roms = probe_roms;
-	x86_init.resources.reserve_resources = i386_reserve_resources;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
 	reserve_ebda_region();
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -693,7 +693,7 @@ static void __init trim_bios_range(void)
 	 * area (640->1Mb) as ram even though it is not.
 	 * take them out.
 	 */
-	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+	e820_add_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RESERVED);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
@@ -1052,20 +1052,3 @@ void __init setup_arch(char **cmdline_p)
 
 	mcheck_init();
 }
-
-#ifdef CONFIG_X86_32
-
-static struct resource video_ram_resource = {
-	.name	= "Video RAM area",
-	.start	= 0xa0000,
-	.end	= 0xbffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-void __init i386_reserve_resources(void)
-{
-	request_resource(&iomem_resource, &video_ram_resource);
-	reserve_standard_io_resources();
-}
-
-#endif /* CONFIG_X86_32 */
