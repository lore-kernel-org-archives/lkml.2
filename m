Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab2HUEG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:06:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2HUEGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:06:24 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, manoj.iyer@canonical.com
Subject: [PATCH 0/1] xhci: Unconditionally switch ports to xHCI on powerup
Date: Mon, 20 Aug 2012 23:06:15 -0500
Message-Id: <1345521975-13708-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

USB 3.0 devices show up as high-speed devices on powerup, after an
s3 cycle they are correctly recognized as SuperSpeed. At powerup
unconditionally switch the port to xHCI like we do when we resume
from suspend.

BugLink: http://bugs.launchpad.net/bugs/1000424

Test results:
This patch was tested by me on a Lenovo system:

00:14.0 USB controller [0c03]: Intel Corporation Panther Point USB xHCI Host Con
troller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
        Subsystem: Lenovo Device [17aa:5002]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step
ping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 41
        Region 0: Memory at 90600000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3h
ot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 4169
        Kernel driver in use: xhci_hcd

== BEFORE PATCH ==
[   25.982350] eth1: no IPv6 routers present
[   27.577663] usb 2-1.1: new high-speed USB device number 3 using ehci_hcd
[   27.674465] scsi6 : usb-storage 2-1.1:1.0
[   28.673788] scsi 6:0:0:0: Direct-Access     JetFlash Transcend 16GB   1.00 PQ: 0 ANSI: 5
[   28.674667] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   28.677284] sd 6:0:0:0: [sdc] 30871552 512-byte logical blocks: (15.8 GB/14.7 GiB)
[   28.677832] sd 6:0:0:0: [sdc] Write Protect is off
[   28.677839] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   28.678454] sd 6:0:0:0: [sdc] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[   28.682117]  sdc: sdc1
[   28.684179] sd 6:0:0:0: [sdc] Attached SCSI removable disk

== AFTER PATCH USB 3.0 PORT ==
[   56.653501] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
[   56.672677] scsi6 : usb-storage 4-1:1.0
[   57.669912] scsi 6:0:0:0: Direct-Access     JetFlash Transcend 16GB   1.00 PQ: 0 ANSI: 5
[   57.671100] sd 6:0:0:0: [sdc] 30871552 512-byte logical blocks: (15.8 GB/14.7 GiB)
[   57.671185] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   57.671389] sd 6:0:0:0: [sdc] Write Protect is off
[   57.671392] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   57.671499] sd 6:0:0:0: [sdc] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[   57.674480]  sdc: sdc1
[   57.675180] sd 6:0:0:0: [sdc] Attached SCSI removable disk


== AFTER PATCH USB 2.0 PORT ==
[  112.468810] usb 4-1: USB disconnect, device number 2
[  117.688925] usb 1-1.2: new high-speed USB device number 5 using ehci_hcd
[  117.786131] scsi7 : usb-storage 1-1.2:1.0
[  118.785809] scsi 7:0:0:0: Direct-Access     JetFlash Transcend 16GB   1.00 PQ: 0 ANSI: 5
[  118.788004] sd 7:0:0:0: Attached scsi generic sg3 type 0
[  118.789848] sd 7:0:0:0: [sdc] 30871552 512-byte logical blocks: (15.8 GB/14.7 GiB)
[  118.790287] sd 7:0:0:0: [sdc] Write Protect is off
[  118.790294] sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  118.791072] sd 7:0:0:0: [sdc] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[  118.796448]  sdc: sdc1
[  118.798525] sd 7:0:0:0: [sdc] Attached SCSI removable disk

Manoj Iyer (1):
  xhci: Unconditionally switch ports to xHCI on powerup

 drivers/usb/host/xhci-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

-- 
1.7.9.5

