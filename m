Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0JaNWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 09:22:13 -0400
Received: from kilobug.org ([62.212.118.231]:36365 "EHLO aoskar.kilobug.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab0JaNWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 09:22:11 -0400
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Oct 2010 09:22:10 EDT
From: Gael Le Mignot <gael@pilotsystems.net>
To: linux-kernel@vger.kernel.org
Subject: Kernel bug on Xen DOM0 with SAS, swraid, lvm
Organization: Pilot Systems
Mail-Copies-To: nobody
X-Revolutionnary-Date: 10 Brumaire an 219 de la =?iso-8859-1?Q?R=E9volutio?=
 =?iso-8859-1?Q?n?=
X-PGP-Fingerprint: 1F2C 9804 7505 79DF 95E6 7323 B66B F67B 7103 C5DA
Date: Sun, 31 Oct 2010 13:57:02 +0100
Message-ID: <plop87eib6msf5.fsf@aoskar.kilobug.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

We are using the following setup :

- A  Xen DOM0  with  several  Xen DOMUs,  all  running Debian  GNU/Linux
  stable, with kernel 2.6.26-2-xen-amd64 ;

- Disks are either SATA or SAS disks (2 SAS disks for performances and 4
  SATA disks for bulk storage), all paired in software RAID1, and we use
  LVM on top of that.

We usually have  no problem with this setup which  is running for almost
two  years, except  today we  had a  kernel BUG  (I'll  include hardware
details and syslog trace afterwards).

After this kernel  BUG, most operations were still  working, but several
disk  related   ones  like   "cat  /proc/mdstat",  "lvs"   were  hanging
undefinitely, and starting  a Xen VM would fail with  a timeout. Doing a
reboot fixed everything.

Since  it  included  a  "BUG:  unable  to  handle  kernel  NULL  pointer
dereference at 0000000000000000", I guess it  is a kernel bug, not a bug
in Xen or a hardware problem. I know the kernel is a bit old, but we use
stable Debian on production servers.

If the kernel is  too old for the bug report to  be useful, feel free to
ignore  it,  but  in  doubt,  I  prefer to  submit  it.  I  can  provide
additionnal details if needed.

-------
Here is the syslog about the problem :
-------

Oct 31 08:09:13 thelma kernel: [8150666.955924] mptscsih: ioc2: attempting task abort! (sc=ffff880039a546c0)
Oct 31 08:09:13 thelma kernel: [8150666.955967] sd 2:0:5:0: [sdi] CDB: Read(10): 28 00 2d b4 bc af 00 00 08 00
Oct 31 08:09:16 thelma kernel: [8150669.309069] mptbase: ioc2: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 31 08:09:16 thelma kernel: [8150669.517393] mptscsih: ioc2: task abort: SUCCESS (sc=ffff880039a546c0)
Oct 31 08:09:23 thelma kernel: [8150676.065107] mptbase: ioc2: LogInfo(0x31111000): Originator={PL}, Code={Reset}, SubCode(0x1000)
Oct 31 08:09:26 thelma kernel: [8150679.516012] mptscsih: ioc2: attempting task abort! (sc=ffff880039a546c0)
Oct 31 08:09:26 thelma kernel: [8150679.516053] sd 2:0:5:0: [sdi] CDB: Test Unit Ready: 00 00 00 00 00 00
Oct 31 08:09:27 thelma kernel: [8150680.558931] mptbase: ioc2: LogInfo(0x31111000): Originator={PL}, Code={Reset}, SubCode(0x1000)
Oct 31 08:09:30 thelma kernel: [8150683.809175] mptsas: ioc2: removing sata device, channel 0, id 7, phy 6
Oct 31 08:09:30 thelma kernel: [8150683.809216]  port-2:5: mptsas: ioc2: delete port (5)
Oct 31 08:09:30 thelma kernel: [8150683.867264] mptscsih: ioc2: task abort: SUCCESS (sc=ffff880039a546c0)
Oct 31 08:09:30 thelma kernel: [8150683.867302] mptscsih: ioc2: attempting task abort! (sc=ffff88003a8eae80)
Oct 31 08:09:30 thelma kernel: [8150683.867335] scsi 2:0:5:0: [sdi] CDB: Read(10): 28 00 3a 87 82 c7 00 00 08 00
Oct 31 08:09:30 thelma kernel: [8150683.867434] mptscsih: ioc2: task abort: SUCCESS (sc=ffff88003a8eae80)
Oct 31 08:09:30 thelma kernel: [8150683.867472] mptscsih: ioc2: attempting bus reset! (sc=ffff880039a546c0)
Oct 31 08:09:30 thelma kernel: [8150683.867504] scsi 2:0:5:0: [sdi] CDB: Read(10): 28 00 2d b4 bc af 00 00 08 00
Oct 31 08:09:30 thelma kernel: [8150683.867615] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Oct 31 08:09:30 thelma kernel: [8150683.867672] IP: [<ffffffffa006459a>] :mptscsih:mptscsih_bus_reset+0x95/0x104
Oct 31 08:09:30 thelma kernel: [8150683.867672] IP: [<ffffffffa006459a>] :mptscsih:mptscsih_bus_reset+0x95/0x104
Oct 31 08:09:30 thelma kernel: [8150683.867733] PGD 3fddd067 PUD 3dd51067 PMD 0
Oct 31 08:09:30 thelma kernel: [8150683.867771] Oops: 0000 [1] SMP
Oct 31 08:09:30 thelma kernel: [8150683.867804] CPU 0
Oct 31 08:09:30 thelma kernel: [8150683.867831] Modules linked in: tcp_diag inet_diag xt_tcpudp xt_physdev iptable_filter ip_tables x_tables ipv6 8021q bridge raid1 \
md_mod loop parport_pc parport psmouse pcspkr serio_raw i2c_i801 i2c_core rng_core i5000_edac edac_core shpchp pci_hotplug container button joydev evdev ext3 jbd mbc\
ache dm_mirror dm_log dm_snapshot dm_mod ide_disk ata_generic libata dock usbhid hid ff_memless sd_mod piix floppy ide_pci_generic ide_core ehci_hcd uhci_hcd e1000e \
mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal processor fan thermal_sys [last unloaded: scsi_wait_scan]
Oct 31 08:09:30 thelma kernel: [8150683.868277] Pid: 860, comm: scsi_eh_2 Not tainted 2.6.26-2-xen-amd64 #1
Oct 31 08:09:30 thelma kernel: [8150683.868310] RIP: e030:[<ffffffffa006459a>]  [<ffffffffa006459a>] :mptscsih:mptscsih_bus_reset+0x95/0x104
Oct 31 08:09:30 thelma kernel: [8150683.868370] RSP: e02b:ffff88003d89fe00  EFLAGS: 00010246
Oct 31 08:09:30 thelma kernel: [8150683.868400] RAX: ffff880032ac8002 RBX: ffff880039a546c0 RCX: 000000000000000a
Oct 31 08:09:30 thelma kernel: [8150683.868449] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff805aaab0
Oct 31 08:09:30 thelma kernel: [8150683.868497] RBP: ffff88003d85f5e8 R08: 0000000000000001 R09: 00000000ffffff20
Oct 31 08:09:30 thelma kernel: [8150683.868546] R10: 0000000000000000 R11: 0000010b7494482f R12: ffff88003dfe7008
Oct 31 08:09:30 thelma kernel: [8150683.868595] R13: ffff88003dfe7000 R14: 0000000000000071 R15: ffff88003d85f000
Oct 31 08:09:30 thelma kernel: [8150683.868646] FS:  00007fd31f1d8770(0000) GS:ffffffff8053a000(0000) knlGS:0000000000000000
Oct 31 08:09:30 thelma kernel: [8150683.868696] CS:  e033 DS: 0000 ES: 0000
Oct 31 08:09:30 thelma kernel: [8150683.868724] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 31 08:09:30 thelma kernel: [8150683.868773] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 31 08:09:30 thelma kernel: [8150683.868821] Process scsi_eh_2 (pid: 860, threadinfo ffff88003d89e000, task ffff88003fe62040)
Oct 31 08:09:30 thelma kernel: [8150683.870876] Stack:  00003a3a00000000 ffff880039a546c0 ffff880039a546c0 0000000000002003
Oct 31 08:09:30 thelma kernel: [8150683.870876]  ffff88003d89fee0 ffffffffa002027f ffff880039a546c0 ffff88003d89fec8
Oct 31 08:09:30 thelma kernel: [8150683.870876]  0000000000000000 ffffffffa0020f65 ffff88003d89fed0 ffff88003d89fec8
Oct 31 08:09:30 thelma kernel: [8150683.870876] Call Trace:
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffffa002027f>] ? :scsi_mod:scsi_try_bus_reset+0x4c/0xb4
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffffa0020f65>] ? :scsi_mod:scsi_eh_ready_devs+0x3ce/0x5ac
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffffa0021870>] ? :scsi_mod:scsi_error_handler+0x312/0x4b7
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffff80221555>] ? __wake_up_common+0x41/0x74
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffffa002155e>] ? :scsi_mod:scsi_error_handler+0x0/0x4b7
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffff8023f527>] ? kthread+0x47/0x74
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffff802282ec>] ? schedule_tail+0x27/0x5c
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffff8020be28>] ? child_rip+0xa/0x12
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffff8023f4e0>] ? kthread+0x0/0x74
Oct 31 08:09:30 thelma kernel: [8150683.870876]  [<ffffffff8020be1e>] ? child_rip+0x0/0x12
Oct 31 08:09:30 thelma kernel: [8150683.870876]
Oct 31 08:09:30 thelma kernel: [8150683.870876]
Oct 31 08:09:30 thelma kernel: [8150683.870876] Code: 00 00 00 48 8b 03 b9 28 00 00 00 48 8b 90 88 00 00 00 41 8a 85 98 00 00 00 84 c0 74 0e 31 c9 3c 02 0f 94 c1 8d \
0c cd 02 00 00 00 <48> 8b 02 45 31 c9 45 31 c0 be 04 00 00 00 48 89 ef 0f b6 50 0b
Oct 31 08:09:30 thelma kernel: [8150683.870876] RIP  [<ffffffffa006459a>] :mptscsih:mptscsih_bus_reset+0x95/0x104
Oct 31 08:09:30 thelma kernel: [8150683.870876]  RSP <ffff88003d89fe00>
Oct 31 08:09:30 thelma kernel: [8150683.870876] CR2: 0000000000000000
Oct 31 08:09:30 thelma kernel: [8150683.876328] ---[ end trace 2f918c612367ed7e ]---


-----
Hardware information
-----

Hardware is a dual quad-core Xeon, with 64Gb of ECC RAM (no ECC error in
the IPMI log), with LSI SAS controllers.

Here is a lspci :

00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 2-3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 4-5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 6-7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E3 (rev 01)
03:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09)
03:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09)
04:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)
05:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)
06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet Controller (Copper) (rev 01)
06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit Ethernet Controller (Copper) (rev 01)
07:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)
0b:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

Regards,

-- 
Gaël Le Mignot - gael@pilotsystems.net
Pilot Systems - 9, rue Desargues - 75011 Paris
Tel : +33 1 44 53 05 55 - www.pilotsystems.net
Gérez vos contacts et vos newsletters : www.cockpit-mailing.com
