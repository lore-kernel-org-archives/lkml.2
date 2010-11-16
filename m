Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab0KPHWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:22:53 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46275 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab0KPHWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:22:51 -0500
Date: Mon, 15 Nov 2010 23:22:47 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Incorrect size checks on mmap() for sysfs PCI resource files is
	breaking X?
Message-ID: <20101116072247.GQ14383@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just loaded 2.6.37-rc2 on my machines, and I noticed that X no longer starts.
Running an strace of the X server shows that it's doing this:

open("/sys/bus/pci/devices/0000:07:00.0/resource0", O_RDWR) = 10
mmap(NULL, 16777216, PROT_READ|PROT_WRITE, MAP_SHARED, 10, 0) = -1 EINVAL (Invalid argument)

This code seems to be asking for a shared read/write mapping of 16MB worth of
BAR0 starting at file offset 0, and letting the kernel assign a starting
address.  Here's the lspci dump:

07:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200EV
	Subsystem: IBM Device 0369
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 96000000 (32-bit, prefetchable) [size=16M]
	Region 1: Memory at 97800000 (32-bit, non-prefetchable) [size=16K]
	Region 2: Memory at 97000000 (32-bit, non-prefetchable) [size=8M]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: matroxfb_base

Looking into dmesg, there's a complaint like so:

[  541.445705] ------------[ cut here ]------------
[  541.450339] WARNING: at /home/djwong/linux-2.6.37-rc2-fs/drivers/pci/pci-sysfs.c:758 pci_mmap_resource+0xff/0x161()
[  541.460801] Hardware name: System x3550 M2 -[7946AC1]-
[  541.465980] process "Xorg" tried to map 0x01000000 bytes at page 0x00000000 on 0000:07:00.0 BAR 0 (start 0x        96000000, size 0x         1000000)
[  541.479414] Modules linked in: ext4 mbcache jbd2 crc16 dm_round_robin dm_multipath dm_mod nfsd exportfs eeprom kvm_intel kvm acpi_cpufreq mperf k10temp k8temp coretemp ipv6 rtc_cmos rtc_core cdc_ether i7core_edac shpchp ioatdma serio_raw mousedev usbnet evdev edac_core rtc_lib pci_hotplug dca processor button af_packet nfs lockd fscache nfs_acl auth_rpcgss sunrpc virtio_pci sd_mod crc_t10dif sg sr_mod cdrom usbhid hid mptsas mptscsih ata_piix mptbase libata scsi_transport_sas uhci_hcd lpfc ehci_hcd scsi_transport_fc usbcore scsi_tgt scsi_mod bnx2 nls_base virtio_net virtio virtio_ring bridge stp llc raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod nbd
[  541.546034] Pid: 3983, comm: Xorg Tainted: G        W   2.6.37-rc2-fs64 #1
[  541.552898] Call Trace:
[  541.555342]  [<ffffffff81050809>] warn_slowpath_common+0x85/0x9d
[  541.561335]  [<ffffffff810508c4>] warn_slowpath_fmt+0x46/0x48
[  541.567073]  [<ffffffff811b99c5>] pci_mmap_resource+0xff/0x161
[  541.572932]  [<ffffffff811b9a40>] pci_mmap_resource_uc+0x19/0x1b
[  541.578965]  [<ffffffff8116568b>] mmap+0x73/0xfa
[  541.583619]  [<ffffffff810e9b56>] mmap_region+0x2bb/0x4c4
[  541.589051]  [<ffffffff8100e39b>] ? arch_get_unmapped_area_topdown+0x1c3/0x290
[  541.596295]  [<ffffffff810e9fef>] do_mmap_pgoff+0x290/0x2f3
[  541.601903]  [<ffffffff810ea148>] sys_mmap_pgoff+0xf6/0x12e
[  541.607511]  [<ffffffff8100df4e>] sys_mmap+0x22/0x24
[  541.612482]  [<ffffffff8100a00a>] tracesys+0xd0/0xd5
[  541.617504] ---[ end trace e20ec6912607e574 ]---

...with the following code in pci_mmap_fits:

	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
		pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
        if (start >= pci_start && start < pci_start + size &&
                        start + nr <= pci_start + size)

It looks like the logic here is set up such that when the mmap call comes via
sysfs, the check in pci_mmap_fits wants vma->vm_pgoff to be between the
resource's start and end address, and the end of the vma to be no farther than
the end.  However, the sysfs PCI resource files always start at offset zero,
which means that this test always fails for programs that mmap the sysfs files.
Given the comment in the original commit
3b519e4ea618b6943a82931630872907f9ac2c2b, I _think_ the old procfs files
require that the file offset be equal to the resource's base address when
mmapping.

I think what we want here is for pci_start to be 0 when mmap_api ==
PCI_MMAP_PROCFS, though I'll leave it up to the author to ack me or prove me
wrong.

In any case, X is totally broken -- I can't get it started on Matrox, Radeon,
or Mach64 hardware, and I'd bet everything else is broken too.

--D
