Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0DGEAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:00:02 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35827 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0DGD7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 23:59:55 -0400
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20100406225425.GA8292@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 21:59:43 -0600
Message-Id: <1270612783.8518.15.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 15:54 -0700, Andy Isaacson wrote:
> This Dell Precision WorkStation T3400 doesn't boot 2.6.34-rc1 (tried
> 522dba71).  2.6.33 was fine, and it's been running various stable
> kernels for the last 18 months.  Unfortunately I can't reasonably bisect
> as I need this machine to be usable, but I can test specific patches or
> options.  (three or four reboots is fine, 15 is not.)
> 
> full dmesg from failing boot and a successful boot at
> http://web.hexapodia.org/~adi/tmp/20100406-pci-ahci-reset-fail/
> 
> I suspect it's due to:
> 
> [    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> [    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]

Thanks a lot for reporting this!

No need to bisect it.  I'm pretty sure 2.6.34-rc1 will boot fine if you
use "pci=use_crs" (obviously that's only a temporary workaround until we
fix the real problem).

The BIOS apparently reported this window:

  pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]

which doesn't enclose the [mem 0xff970000-0xff9707ff] region where BIOS
put AHCI device, so we moved the AHCI device.  Unfortunately, we put it
at [mem 0x000a0000-0x000a07ff], which wasn't a very good choice because
that's probably already used by a VGA device.

If you happen to have Windows on this box, I'd love to know whether *it*
moves the AHCI device, too, or whether Windows interprets the BIOS
information differently than we do.  If you have Windows and can collect
screenshots of the Device Manager resources for the PCI bus and the AHCI
controller, that would be a good start.

Would you mind trying the patch below and the patch and kernel args
here:
  https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5

This will (1) reserve the VGA area, so we should put the AHCI device
elsewhere, and (2) collect a few more details about exactly what the
BIOS is reporting.

Bjorn


commit 46b6e80aae2ec1d073767c92bba1d98896bce700
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Apr 6 21:44:12 2010 -0600

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..f4c0fe4 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -44,7 +44,6 @@ static inline void visws_early_detect(void) { }
 extern unsigned long saved_video_mode;
 
 extern void reserve_standard_io_resources(void);
-extern void i386_reserve_resources(void);
 extern void setup_default_timer_irq(void);
 
 #ifdef CONFIG_X86_MRST
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index b2e2460..966b37f 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -22,7 +22,6 @@ static void __init i386_default_early_setup(void)
 {
 	/* Initilize 32bit specific setup functions */
 	x86_init.resources.probe_roms = probe_roms;
-	x86_init.resources.reserve_resources = i386_reserve_resources;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
 	reserve_ebda_region();
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9570541..24d9113 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -575,6 +575,13 @@ static struct resource standard_io_resources[] = {
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
 };
 
+static struct resource video_ram_resource = {
+	.name	= "Video RAM area",
+	.start	= 0xa0000,
+	.end	= 0xbffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
 void __init reserve_standard_io_resources(void)
 {
 	int i;
@@ -583,6 +590,7 @@ void __init reserve_standard_io_resources(void)
 	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
 		request_resource(&ioport_resource, &standard_io_resources[i]);
 
+	request_resource(&iomem_resource, &video_ram_resource);
 }
 
 /*
@@ -1042,20 +1050,3 @@ void __init setup_arch(char **cmdline_p)
 
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


