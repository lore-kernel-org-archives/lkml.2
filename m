Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0CZX1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:27:19 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:36536 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0CZX1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:27:18 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 19:27:17 EDT
Date: Fri, 26 Mar 2010 18:21:04 -0500
From: David Fries <david@fries.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 2.6.34-rc2 breaks via82cxxx Host Protected Area
Message-ID: <20100326232104.GA10769@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 26 Mar 2010 18:21:05 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel fails to see the entire disk with 2.6.34-rc2 with VIA
vt82c586b chipset.  I tracked it down to commit
f931a5d5785d7b7c44871bd7ad2762e29dfddf29 "via82cxxx: workaround h/w
bugs" and reverting just that one solves the problem, or just
commenting out just one outb write in that change.

via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later

Note the kernel panic is intentional as I'm given the test kernel an
invalid root device, so that I can suspend to disk, try a kernel,
resume and pick up where I left off.  It does have a side benefit of
dumping the size of all partitions.

2.6.34-rc2 unmodified, fails and sees 30985416 KiB for the last
partition.
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
hda: p3 size 236037312 exceeds device capacity, enabling native capacity
hda: p3 size 236037312 exceeds device capacity, limited to end of disk
ide-cd driver 5.00
...
Please append a correct "root=" boot option; here are the available partitions:
0300        33027624 hda driver: ide-gd
  0301           49391 hda1
  0302         1992816 hda2
  0303        30985416 hda3
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)

2.6.34-rc2 with patch revered, correct size 118018656
ide-gd driver 1.18
hda: max request size: 128KiB
hda: Host Protected Area detected.
        current capacity is 66055248 sectors (33820 MB)
        native  capacity is 240121728 sectors (122942 MB)
hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
hda: p3 size 236037312 exceeds device capacity, enabling native capacity
hda: detected capacity change from 33820286976 to 122942324736
ide-cd driver 5.00
0300       120060864 hda driver: ide-gd
  0301           49391 hda1
  0302         1992816 hda2
  0303       118018656 hda3
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)

Here are two debug patches, the first adds debug prints and the second
disables the problematic write, I  have the output of both included.

>From dac7d14ce1f227d8a084c3ec218ea1430bffdc57 Mon Sep 17 00:00:00 2001
From: David Fries <david@fries.net>
Date: Thu, 25 Mar 2010 19:51:31 -0500
Subject: [PATCH 1/2] fails: add print messages

add print messages for debugging
---
 drivers/ide/via82cxxx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index e65d010..ccd5640 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -409,6 +409,8 @@ static void via_write_devctl(ide_hwif_t *hwif, u8 ctl)
 
 	outb(ctl, hwif->io_ports.ctl_addr);
 	outb(vdev->cached_device[hwif->channel], hwif->io_ports.device_addr);
+	printk("via_write_devctl        write %u, %lu\n",
+		vdev->cached_device[hwif->channel], hwif->io_ports.device_addr);
 }
 
 static void __via_dev_select(ide_drive_t *drive, u8 select)
@@ -442,6 +444,9 @@ static void via_tf_load(ide_drive_t *drive, struct ide_taskfile *tf, u8 valid)
 		outb(tf->lbah, io_ports->lbah_addr);
 	if (valid & IDE_VALID_DEVICE)
 		__via_dev_select(drive, tf->device);
+	printk("via_tf_load write tf->device %u in place of tf->device %u\n"
+		" value io_ports->device_addr %lu\n",
+		tf->device, tf->device, io_ports->device_addr);
 }
 
 const struct ide_tp_ops via_tp_ops = {
-- 
1.7.0



Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
ide: disallowing DMA for hda
ide: disallowing DMA for hdb
    ide0: BM-DMA at 0xe400-0xe407
ide: disallowing DMA for hdc
ide: disallowing DMA for hdd
    ide1: BM-DMA at 0xe408-0xe40f
via_write_devctl        write 160, 502
via_write_devctl        write 176, 502
via_write_devctl        write 160, 502
hda: Maxtor 6Y120P0, ATA DISK drive
via_write_devctl        write 176, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_write_devctl        write 176, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
ide1: no devices on the port
via_write_devctl        write 160, 502
via_write_devctl        write 0, 374
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 175 in place of tf->device 175
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 224 in place of tf->device 224
 value io_ports->device_addr 502
via_write_devctl        write 224, 502
hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
hda: cache flushes supported
 hda:via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 224 in place of tf->device 224
 value io_ports->device_addr 502
 hda1 hda2 hda3
hda: p3 size 236037312 exceeds device capacity, enabling native capacity
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 224 in place of tf->device 224
 value io_ports->device_addr 502
via_write_devctl        write 224, 502
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 227 in place of tf->device 227
 value io_ports->device_addr 502
via_write_devctl        write 227, 502
hda: p3 size 236037312 exceeds device capacity, limited to end of disk
via_write_devctl        write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl        write 160, 502
ide-cd driver 5.00
VFS: Cannot open root device "1602" or unknown-block(22,2)
Please append a correct "root=" boot option; here are the available partitions:
0300        33027624 hda driver: ide-gd
  0301           49391 hda1
  0302         1992816 hda2
  0303        30985416 hda3
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)


>From 72da5cd66e1f857fbe6afa0e92634e8adf684737 Mon Sep 17 00:00:00 2001
From: David Fries <david@fries.net>
Date: Thu, 25 Mar 2010 20:07:19 -0500
Subject: [PATCH 2/2] via82cxxx works: skip write

This fixes via82cxxx host protected area problems.
---
 drivers/ide/via82cxxx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index ccd5640..d598b63 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -408,8 +408,10 @@ static void via_write_devctl(ide_hwif_t *hwif, u8 ctl)
 	struct via82cxxx_dev *vdev = hwif->host->host_priv;
 
 	outb(ctl, hwif->io_ports.ctl_addr);
+	/*
 	outb(vdev->cached_device[hwif->channel], hwif->io_ports.device_addr);
-	printk("via_write_devctl        write %u, %lu\n",
+	*/
+	printk("via_write_devctl   skip write %u, %lu\n",
 		vdev->cached_device[hwif->channel], hwif->io_ports.device_addr);
 }
 
-- 
1.7.0



Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
ide: disallowing DMA for hda
ide: disallowing DMA for hdb
    ide0: BM-DMA at 0xe400-0xe407
ide: disallowing DMA for hdc
ide: disallowing DMA for hdd
    ide1: BM-DMA at 0xe408-0xe40f
via_write_devctl   skip write 160, 502
via_write_devctl   skip write 176, 502
via_write_devctl   skip write 160, 502
hda: Maxtor 6Y120P0, ATA DISK drive
via_write_devctl   skip write 176, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_write_devctl   skip write 176, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
ide1: no devices on the port
via_write_devctl   skip write 160, 502
via_write_devctl   skip write 0, 374
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 175 in place of tf->device 175
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 224 in place of tf->device 224
 value io_ports->device_addr 502
via_write_devctl   skip write 224, 502
hda: Host Protected Area detected.
        current capacity is 66055248 sectors (33820 MB)
        native  capacity is 240121728 sectors (122942 MB)
hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
hda: cache flushes supported
 hda:via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 224 in place of tf->device 224
 value io_ports->device_addr 502
 hda1 hda2 hda3
hda: p3 size 236037312 exceeds device capacity, enabling native capacity
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 224 in place of tf->device 224
 value io_ports->device_addr 502
via_write_devctl   skip write 224, 502
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 238 in place of tf->device 238
 value io_ports->device_addr 502
via_write_devctl   skip write 238, 502
hda: detected capacity change from 33820286976 to 122942324736
via_write_devctl   skip write 160, 502
via_tf_load write tf->device 0 in place of tf->device 0
 value io_ports->device_addr 502
via_tf_load write tf->device 160 in place of tf->device 160
 value io_ports->device_addr 502
via_write_devctl   skip write 160, 502
ide-cd driver 5.00
VFS: Cannot open root device "1602" or unknown-block(22,2)
Please append a correct "root=" boot option; here are the available partitions:
0300       120060864 hda driver: ide-gd
  0301           49391 hda1
  0302         1992816 hda2
  0303       118018656 hda3
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
