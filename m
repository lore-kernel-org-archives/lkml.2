Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0DGVGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:06:33 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37171 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0DGVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:06:31 -0400
Subject: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well as x86_32
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Renninger <trenn@suse.de>
Date: Wed, 07 Apr 2010 15:06:28 -0600
Message-ID: <20100407210628.28364.96982.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, we only reserve the legacy VGA area [mem 0xa0000-0xbffff] on
x86_32.  But this legacy area is also used on x86_64, so this patch
reserves it there, too.

If we don't reserve it, we may mistakenly move a PCI device to that area,
as we did here:

  pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
  pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
  pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
  pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]

as reported by Andy Isaacson at http://lkml.org/lkml/2010/4/6/375

I think the fact that the BAR is not within a host bridge window is a
BIOS defect, and it's now more visible because we have "pci=use_crs" as
the default.  Using "pci=nocrs" is a workaround, because then we won't
attempt to move the device.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/head32.c     |    3 +--
 arch/x86/kernel/setup.c      |   25 ++++++++-----------------
 3 files changed, 9 insertions(+), 20 deletions(-)


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
index b2e2460..b6de8f8 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -20,9 +20,8 @@
 
 static void __init i386_default_early_setup(void)
 {
-	/* Initilize 32bit specific setup functions */
+	/* Initialize 32bit specific setup functions */
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

