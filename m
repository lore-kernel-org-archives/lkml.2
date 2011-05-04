Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1EDXkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:40:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327Ab1EDXkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:40:01 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2011 16:39:11 -0700
Message-ID: <BANLkTimme-B72D=QfsdgAUKP83VoaKrWNw@mail.gmail.com>
Subject: Duplicate regulator sysfs files..
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam, Mark,
 appended is a report from Werner Landgraf <w.landgraf@ru.ru> who
builds a kernel with pretty much everything enabled, and forwarded
this from one of his testers.

Comments? Why does that "supply vmmc not found, using dummy regulator"
message show up twice? And apparently it tries to register it both
times, which on the second try results in a WARN_ON() from sysfs..

              Linus

---
lspci entry:

02:0b.4 Generic system peripheral [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
(prog-if 01)
	Subsystem: Toshiba America Info Systems Unknown device 0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at cee07800 (32-bit, non-prefetchable) [size=256]
	Region 1: Memory at cee07900 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at cee07a00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 4c 10 34 80 06 00 10 02 00 01 05 08 08 40 80 00
10: 00 78 e0 ce 00 79 e0 ce 00 7a e0 ce 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 79 11 01 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 ff 04 07 04

dmesg excerpt:

sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:02:0b.4: SDHCI controller found [104c:8034] (rev 0)
sdhci-pci 0000:02:0b.4: enabling device (0000 -> 0002)
sdhci-pci 0000:02:0b.4: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
_regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy regulator
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:02:0b.4] using DMA
_regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy regulator
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
Hardware name: Qosmio E10
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.39-rc5-git4-i486-1sys #1
Call Trace:
 [<c1128fef>] ? sysfs_add_one+0x83/0x95
 [<c103ef43>] warn_slowpath_common+0x7a/0x8f
 [<c1128fef>] ? sysfs_add_one+0x83/0x95
 [<c103efe3>] warn_slowpath_fmt+0x33/0x35
 [<c1128fef>] sysfs_add_one+0x83/0x95
 [<c11289ef>] sysfs_add_file_mode+0x4a/0x72
 [<c1128a2f>] sysfs_add_file+0x18/0x1c
 [<c1128aca>] sysfs_create_file+0x25/0x27
 [<c178a561>] device_create_file+0x18/0x1a
 [<c168c304>] _regulator_get+0x224/0x3b7
 [<c1081747>] ? request_threaded_irq+0xb9/0xe5
 [<c168c4ba>] regulator_get+0xf/0x11
 [<c1cbb273>] sdhci_add_host+0x580/0x6cb
 [<c15903ac>] ? pci_ioremap_bar+0x5b/0x5f
 [<c1ea0a43>] sdhci_pci_probe+0x320/0x3c9
 [<c15905db>] local_pci_probe+0x41/0x85
 [<c1591150>] pci_device_probe+0x48/0x6b
 [<c178c300>] driver_probe_device+0x9c/0x145
 [<c1590575>] ? pci_match_device+0x96/0x9c
 [<c1eb9041>] ? _cond_resched+0x8/0x47
 [<c178c3f1>] __driver_attach+0x48/0x64
 [<c178bc41>] bus_for_each_dev+0x42/0x6c
 [<c178c189>] driver_attach+0x1e/0x20
 [<c178c3a9>] ? driver_probe_device+0x145/0x145
 [<c178b656>] bus_add_driver+0xc6/0x20a
 [<c242b1f2>] ? parse_early_options+0x25/0x25
 [<c178c91b>] driver_register+0x98/0xf8
 [<c178c91b>] ? driver_register+0x98/0xf8
 [<c168db7e>] ? tty_register_driver+0x15e/0x1e2
 [<c242b1f2>] ? parse_early_options+0x25/0x25
 [<c159133d>] __pci_register_driver+0x3d/0x96
 [<c1eb84c8>] ? printk+0x1d/0x1f
 [<c242b1f2>] ? parse_early_options+0x25/0x25
 [<c24903fa>] sdhci_drv_init+0x14/0x16
 [<c1001174>] do_one_initcall+0x8c/0x142
