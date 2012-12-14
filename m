Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2LNLBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:01:47 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:40198 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2LNLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:01:44 -0500
Subject: [PATCH] ata: uncomment ata_timing for XFER_PIO_SLOW
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@redhat.com>
Date: Fri, 14 Dec 2012 15:01:37 +0400
Message-ID: <20121214110137.9155.68183.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uncomments ata timings for XFER_PIO_SLOW,
otherwise ata_timing_find_mode() returns NULL and kernel crashes in
pacpi_set_dmamode() after null-pointer dereference.

The same problem was mentioned recently in debug patch v3.7-rc5-72-gcd705d5
("libata debugging: Warn when unable to find timing descriptor based on xfer_mode")

I'm not sure about this patch, because I have no idea what this XFER_PIO_SLOW
means and why this bug so rare (3 times during 4 days boot-reboot test) I caught
this on completely ordinary PC with nvidia MCP61 chipset, sata hdd and ide dvd-rom.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

---

Sep 27 13:48:23 buzz kernel: [   63.815060] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 20
Sep 27 13:48:23 buzz kernel: [   63.987035] scsi0 : pata_acpi
Sep 27 13:48:23 buzz kernel: [   64.072790] scsi1 : pata_acpi
Sep 27 13:48:23 buzz kernel: [   64.127731] ata1: PATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xcc00 irq 20
Sep 27 13:48:23 buzz kernel: [   64.127919] ata2: PATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xcc08 irq 20
Sep 27 13:48:23 buzz kernel: [   64.247630] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 23
Sep 27 13:48:23 buzz kernel: [   64.511669] scsi2 : pata_acpi
Sep 27 13:48:23 buzz kernel: [   64.575269] ------------[ cut here ]------------
Sep 27 13:48:23 buzz kernel: [   64.575269] WARNING: at drivers/ata/libata-core.c:2946 ata_timing_find_mode+0x5e/0x8a [libata]()
Sep 27 13:48:23 buzz kernel: [   64.575269] Hardware name: M52S-S3P
Sep 27 13:48:23 buzz kernel: [   64.575269] Modules linked in: ohci_hcd(+) pata_amd(+) pata_acpi(+) sata_nv(+) libata scsi_mod forcedeth ehci_hcd amd74
xx usbcore ide_pci_generic ide_core usb_common unix
Sep 27 13:48:23 buzz kernel: [   64.575269] Pid: 1785, comm: scsi_eh_0 Not tainted 3.6.0-rc7-next-20120926-00012-g872b7d8 #568
Sep 27 13:48:23 buzz kernel: [   64.575269] Call Trace:
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810760fa>] warn_slowpath_common+0xc4/0xf2
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff81076150>] warn_slowpath_null+0x28/0x31
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa028d1bf>] ata_timing_find_mode+0x5e/0x8a [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa001e2e2>] pacpi_set_dmamode+0x45/0xc7 [pata_acpi]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa001e469>] pacpi_qc_issue+0x7e/0xa1 [pata_acpi]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa0290a71>] ata_qc_issue+0x45b/0x4c7 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff816832e1>] ? _raw_spin_lock_irqsave+0xdc/0xf8
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa0290b7f>] ? ata_exec_internal_sg+0xa2/0x5af [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa0290d6c>] ata_exec_internal_sg+0x28f/0x5af [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa0291132>] ata_exec_internal+0xa6/0xba [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff8117bb60>] ? time_hardirqs_off+0x3b/0x47
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810c8e5a>] ? local_clock+0x59/0x8c
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02911f1>] ata_do_dev_read_id+0x31/0x3a [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810f99d6>] ? mark_held_locks+0xa4/0xde
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa0291329>] ata_dev_read_id+0x12f/0x583 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa028c344>] ? ata_link_max_devices+0x14/0x45 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a08cc>] ata_eh_recover+0xa80/0x1871 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810c8e5a>] ? local_clock+0x59/0x8c
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a42d1>] ? spin_unlock_irqrestore+0x10/0x19 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a4d7c>] ? ata_sff_drain_fifo+0xb1/0xb1 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a5929>] ? ata_sff_wait_after_reset+0x18c/0x18c [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa001e21c>] ? pacpi_port_start+0xc0/0xc0 [pata_acpi]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff81684351>] ? _raw_spin_unlock_irqrestore+0x7d/0xbc
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a5929>] ? ata_sff_wait_after_reset+0x18c/0x18c [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a5929>] ? ata_sff_wait_after_reset+0x18c/0x18c [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a2184>] ata_do_eh+0x60/0xe3 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a4d7c>] ? ata_sff_drain_fifo+0xb1/0xb1 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a5929>] ? ata_sff_wait_after_reset+0x18c/0x18c [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa001e21c>] ? pacpi_port_start+0xc0/0xc0 [pata_acpi]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a4b32>] ata_sff_error_handler+0x13b/0x14f [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a4cbb>] ata_bmdma_error_handler+0x175/0x185 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a1b23>] ata_scsi_port_error_handler+0x34d/0x832 [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa01e1c1f>] ? scsi_eh_get_sense+0x21a/0x21a [scsi_mod]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa02a20d4>] ata_scsi_error+0xcc/0x11c [libata]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa01e1c1f>] ? scsi_eh_get_sense+0x21a/0x21a [scsi_mod]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa01e1dbc>] scsi_error_handler+0x19d/0x869 [scsi_mod]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffffa01e1c1f>] ? scsi_eh_get_sense+0x21a/0x21a [scsi_mod]
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810ac806>] kthread+0xe2/0xf1
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810ac724>] ? __kthread_parkme+0xa4/0xa4
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff8168f42c>] ret_from_fork+0x7c/0x90
Sep 27 13:48:23 buzz kernel: [   64.575269]  [<ffffffff810ac724>] ? __kthread_parkme+0xa4/0xa4
Sep 27 13:48:23 buzz kernel: [   64.575269] ---[ end trace b97218fb3afe71eb ]---
Sep 27 13:48:23 buzz kernel: [   64.575269] ata_timing_find_mode xfer_mode 0
Sep 27 13:48:23 buzz kernel: [   64.640696] scsi3 : pata_acpi
Sep 27 13:48:23 buzz kernel: [   64.689329] ata3: PATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xe000 irq 23
Sep 27 13:48:23 buzz kernel: [   64.689519] ata4: PATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xe008 irq 23
Sep 27 13:48:23 buzz kernel: [   64.721830] ohci_hcd 0000:00:02.0: OHCI Host Controller
Sep 27 13:48:23 buzz kernel: [   64.722421] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
Sep 27 13:48:23 buzz kernel: [   64.725143] ohci_hcd 0000:00:02.0: irq 23, io mem 0xfc008000
Sep 27 13:48:23 buzz kernel: [   64.772703] ata1.00: HPA detected: current 488395055, native 488397168
Sep 27 13:48:23 buzz kernel: [   64.772900] ata1.00: ATA-7: ST3250410AS, 3.AAA, max UDMA/133
Sep 27 13:48:23 buzz kernel: [   64.773090] ata1.00: 488395055 sectors, multi 16: LBA48 NCQ (depth 0/32)

Warning was added by following debebug patch. I cannot collect oops inself because
it always happens too early, before crashkernel initialization.

 --- a/drivers/ata/libata-core.c
 +++ b/drivers/ata/libata-core.c
@@ -2942,6 +2942,9 @@ const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)

        if (xfer_mode == t->mode)
                return t;
+
+       WARN_ON(1);
+       printk("%s xfer_mode %d\n", __func__, xfer_mode);
        return NULL;
 }
 --- a/drivers/ata/pata_acpi.c
 +++ b/drivers/ata/pata_acpi.c
@@ -121,6 +121,8 @@ static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)

        /* Now stuff the nS values into the structure */
        t = ata_timing_find_mode(adev->pio_mode);
+       if (!t)
+               return;
        acpi->gtm.drive[unit].pio = t->cycle;
        ata_acpi_stm(ap, &acpi->gtm);
        /* See what mode we actually got */

I saw this oops on this machine with linux-next/allmodconfig

root@buzz:/var/crash# lspci
00:00.0 RAM memory: NVIDIA Corporation MCP61 Memory Controller (rev a1)
00:01.0 ISA bridge: NVIDIA Corporation MCP61 LPC Bridge (rev a2)
00:01.1 SMBus: NVIDIA Corporation MCP61 SMBus (rev a2)
00:01.2 RAM memory: NVIDIA Corporation MCP61 Memory Controller (rev a2)
00:02.0 USB controller: NVIDIA Corporation MCP61 USB 1.1 Controller (rev a3)
00:02.1 USB controller: NVIDIA Corporation MCP61 USB 2.0 Controller (rev a3)
00:04.0 PCI bridge: NVIDIA Corporation MCP61 PCI bridge (rev a1)
00:05.0 Audio device: NVIDIA Corporation MCP61 High Definition Audio (rev a2)
00:06.0 IDE interface: NVIDIA Corporation MCP61 IDE (rev a2)
00:07.0 Bridge: NVIDIA Corporation MCP61 Ethernet (rev a2)
00:08.0 IDE interface: NVIDIA Corporation MCP61 SATA Controller (rev a2)
00:08.1 IDE interface: NVIDIA Corporation MCP61 SATA Controller (rev a2)
00:09.0 PCI bridge: NVIDIA Corporation MCP61 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
02:00.0 VGA compatible controller: NVIDIA Corporation G86 [GeForce 8500 GT] (rev a1)
---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 47d5961..c7d572f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2873,7 +2873,7 @@ int sata_set_spd(struct ata_link *link)
  */
 
 static const struct ata_timing ata_timing[] = {
-/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 0,  960,   0 }, */
+	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 0,  960,   0 },
 	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 0,  600,   0 },
 	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 0,  383,   0 },
 	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 0,  240,   0 },

