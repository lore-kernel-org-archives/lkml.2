Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0DIXGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:06:01 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62643 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0DIXF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:05:58 -0400
Message-ID: <4BBFB1D8.6090802@oracle.com>
Date: Fri, 09 Apr 2010 16:01:44 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Yinghai Lu <yinghai.lu@oracle.com>, guenter.roeck@ericsson.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org>
In-Reply-To: <20100409223532.GC11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BBFB29A.0069:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check

Subject: [PATCH] x86: reserve [0xa0000, 0x100000] in e820

Update e820 at first, and later put them resource tree.

-V2: reserved that early, no PCI BAR can use it, force them to get new one

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>

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
+	e820_add_region(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RESERVED);
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
