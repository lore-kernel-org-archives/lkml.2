Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab2BXFVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:21:47 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9406 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750709Ab2BXFVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:21:46 -0500
X-SpamScore: -1
X-BigFish: VS-1(zzc89bh4015Izz1202hzzz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Fuzhou Chen <fuzhouch@microsoft.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>
Subject: RE: linux-next: pata_acpi.ko crashes at ata_ap_acpi_handle()
Thread-Topic: RE: linux-next: pata_acpi.ko crashes at ata_ap_acpi_handle()
Thread-Index: Aczys9ZQaaITKt6/T++OY6N3Ux8fgg==
Date: Fri, 24 Feb 2012 05:21:17 +0000
Message-ID: <6689D53B948ACF469C8E9C8CCD48EBE1114EFE01@SINEX14MBXC415.southpacific.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1O5Lt95003347

Hi,

                I’m looking for help to analysis a crash on linux-next kernel. I recently identified an NULL pointer panic when I tried to deploy a linux-next (since next-20120216) kernel to Hyper-V machine. I enabled CONFIG_HYPERV_STORAGE to use hv_storvsc.ko (Microsoft virtual HDD driver), as well as pata_acpi driver.

                When I boot my RHEL 6.1 VM with built kernel, the system hangs after a NULL pointer crash. The stack trace is listed below.

       I did an investigation on this and below is my analysis.
　　　　libata-sff.c:2424:ata_pci_sff_activate_host()
　　　　-> libata-core.c:5889:ata_host_start()
　　　　	-> pata_acpi.c:198:pacpi_port_start()
		　　-> pata_acpi.c:61:ata_ap_acpi_handle() <<< Access ap->scsi_field (crash!)
　　　　-> libata-core.c:6043:ata_host_register()
	　　　-> libata-scsi.c:3386:ata_scsi_add_hosts () <<< Initialize ap->scsi_field

       We can see the code in ata_ap_acpi_handle()accesses ap->scsi_host filed without checking if it’s initialized, which causes NULL pointer panic. Meanwhile, ata_pci_sff_activate_host() calls ata_host_register(), which calls ata_scsi_add_hosts() to initialize scsi_host field. Both calls are after ata_host_start() in a must-visit code path. I believe ata_scsi_add_hosts() is the first place for initialization because it does not check if scsi_host field is NULL either. So it makes no sense to access ap->scsi_host in ata_ap_acpi_handle().

                I’m still not clear that why pata_acpi goes wrong when hv_storvsc is raised. I think a possible reason is the VHD device is registered as an SCSI device, which triggers libata. Meanwhile, we can work-around the issue by use ata_piix instead of hv_storvsc. In this scenario, pata_acpi was loaded but does not really take effect. I’m assuming the driver goes to different call path, as all my added debugging pr_info() statements are not printed at all. 

                I’m not sure who is owning pata_acpi now. Could anyone point me to the correct person to confirm this? Any help will be appreciated.

Thanks,
Fuzhou

====
[    3.075896] hv_vmbus: Hyper-V Host OS Build:7601-6.1-17-0.17514
[    3.081705] hv_vmbus: child device vmbus_0_1 registered
[    3.081968] hv_vmbus: child device vmbus_0_2 registered
[    3.082199] hv_vmbus: child device vmbus_0_3 registered
[    3.082454] hv_vmbus: child device vmbus_0_4 registered
[    3.082679] hv_vmbus: child device vmbus_0_5 registered
[    3.082897] hv_vmbus: child device vmbus_0_6 registered
[    3.083123] hv_vmbus: child device vmbus_0_7 registered
[    3.083397] hv_vmbus: child device vmbus_0_8 registered
[    3.083662] hv_vmbus: child device vmbus_0_9 registered
%G[    6.301372] IBM TrackPoint firmware: 0x01, buttons: 0/0
[    6.307425] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input1
[    8.089382] Uniform Multi-Platform E-IDE driver
[    8.098140] SCSI subsystem initialized
[    8.105944] ACPI: bus type scsi registered
[    8.114482] BUG: unable to handle kernel NULL pointer dereference at 00000000000003a8
[    8.117255] IP: [<ffffffffa00bc70f>] ata_ap_acpi_handle+0xf/0x20 [libata]
[    8.117255] PGD 374f3067 PUD 375b3067 PMD 0
[    8.117255] Oops: 0000 [#1] PREEMPT SMP
[    8.117255] CPU 1
[    8.117255] Modules linked in: pata_acpi(+) ide_pci_generic ata_generic libat
a scsi_mod ide_core hv_vmbus floppy dm_mirror dm_region_hash dm_log dm_mod
[    8.117255]
[    8.117255] Pid: 173, comm: modprobe Not tainted 3.3.0-rc3-next-20120213-dail
y-dirty #12 Microsoft Corporation Virtual Machine/Virtual Machine
[    8.117255] RIP: 0010:[<ffffffffa00bc70f>]  [<ffffffffa00bc70f>] ata_ap_acpi_
handle+0xf/0x20 [libata]
[    8.117255] RSP: 0018:ffff880037aa7ae8  EFLAGS: 00010246
[    8.117255] RAX: 0000000000000000 RBX: ffff8800376cc000 RCX: 0000000000000000
[    8.117255] RDX: ffffffffa00beac0 RSI: 0000000000000002 RDI: ffff8800376cc000
[    8.117255] RBP: ffff880037aa7ae8 R08: 0000000000000001 R09: 0000000000000040
[    8.117255] R10: 0000000000000039 R11: 0000000000000003 R12: ffff88003dd61090
[    8.117255] R13: ffff8800376d0000 R14: 0000000000000000 R15: ffff8800376cc000
[    8.117255] FS:  00007f0d8272a700(0000) GS:ffff88003fc40000(0000) knlGS:0000000000000000
[    8.117255] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    8.117255] CR2: 00000000000003a8 CR3: 0000000037a53000 CR4: 00000000000006e0
[    8.117255] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.117255] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    8.117255] Process modprobe (pid: 173, threadinfo ffff880037aa6000, task ffff880037926e00)
[    8.117255] Stack:
[    8.117255]  ffff880037aa7b08 ffffffffa00e5144 ffff88003dcf2858 0000000000000000
[    8.117255]  ffff880037aa7b48 ffffffffa00a5e7d ffff880037aa7b28 ffff88003dcf2858
[    8.117255]  ffff88003dd61090 ffffffffa00e55c0 ffffffffa00e5424 ffffffffa00ba150
[    8.117255] Call Trace:
[    8.117255]  [<ffffffffa00e5144>] pacpi_port_start+0x24/0xa0 [pata_acpi]
[    8.117255]  [<ffffffffa00a5e7d>] ata_host_start+0x10d/0x1c0 [libata]
[    8.117255]  [<ffffffffa00ba150>] ? ata_bmdma_port_intr+0x120/0x120 [libata]
[    8.117255]  [<ffffffffa00b86cc>] ata_pci_sff_activate_host+0x3c/0x250 [libata]
[    8.117255]  [<ffffffff8125eb13>] ? pcibios_set_master+0x83/0xb0
[    8.117255]  [<ffffffffa00b8ca7>] ata_pci_init_one+0x117/0x190 [libata]
[    8.117255]  [<ffffffffa00b8d2f>] ata_pci_bmdma_init_one+0xf/0x20 [libata]
[    8.117255]  [<ffffffffa00e508c>] pacpi_init_one+0x3c/0x60 [pata_acpi]
[    8.117255]  [<ffffffff81260a1a>] local_pci_probe+0x5a/0xd0
[    8.117255]  [<ffffffff81261d10>] pci_device_probe+0x80/0xb0
[    8.117255]  [<ffffffff812e0b2a>] ? driver_sysfs_add+0x7a/0xb0
[    8.117255]  [<ffffffff812e0cca>] driver_probe_device+0x9a/0x2f0
[    8.117255]  [<ffffffff812e0fbb>] __driver_attach+0x9b/0xa0
[    8.117255]  [<ffffffff812e0f20>] ? driver_probe_device+0x2f0/0x2f0
[    8.117255]  [<ffffffff812df244>] bus_for_each_dev+0x64/0x90
[    8.117255]  [<ffffffff812e0a59>] driver_attach+0x19/0x20
[    8.117255]  [<ffffffff812dfcd8>] bus_add_driver+0x1b8/0x2a0
[    8.117255]  [<ffffffffa00e7000>] ? 0xffffffffa00e6fff
[    8.117255]  [<ffffffffa00e7000>] ? 0xffffffffa00e6fff
[    8.117255]  [<ffffffff812e1641>] driver_register+0x71/0x140
[    8.117255]  [<ffffffff8105ea2d>] ? notifier_call_chain+0x4d/0x70
[    8.117255]  [<ffffffffa00e7000>] ? 0xffffffffa00e6fff
[    8.117255]  [<ffffffff81261fb0>] __pci_register_driver+0x50/0xc0
[    8.117255]  [<ffffffff8105ed80>] ? __blocking_notifier_call_chain+0x60/0x80
[    8.117255]  [<ffffffffa00e701e>] pacpi_init+0x1e/0x20 [pata_acpi]
[    8.117255]  [<ffffffff810001cd>] do_one_initcall+0x3d/0x170
[    8.117255]  [<ffffffff810916bb>] sys_init_module+0x14b/0x12c0
[    8.117255]  [<ffffffff813eb4f9>] system_call_fastpath+0x16/0x1b
[    8.117255] Code: c0 2e 00 00 b8 02 00 00 00 c9 c3 90 48 83 4f 48 20 e8 46 84 fe ff c9 c3 90 90 90 90 31 c0 f6 47 1a 02 55 48 89 e5 75 0a 48 8b 07 <48> 8b 80 a8 03 00 00 c9 c3 0f 1f 84 00 00 00 00 00 55 31 c0 48
[    8.117255] RIP  [<ffffffffa00bc70f>] ata_ap_acpi_handle+0xf/0x20 [libata]
[    8.117255]  RSP <ffff880037aa7ae8>
[    8.117255] CR2: 00000000000003a8
[    8.720877] ---[ end trace cba8a6e1bb900c59 ]---udevd-work[120]: '/sbin/modprobe -b pci:v00008086d00007111sv00000000sd00000000bc01sc01i80' unexpected exit with status 0x0009

[    8.756429] hv_utils: Registering HyperV Utility Driver
[    8.762879] hv_vmbus: registering driver hv_util
[   13.777774] hv_storvsc: module is from the staging directory, the quality isunknown, you have been warned.
[   13.787268] hv_vmbus: registering driver hv_storvsc
[   13.792494] scsi0 : storvsc_host_t
[   13.813982] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[   18.825427] hv_vmbus: registering driver hid_hyperv
[   18.841575] input: Microsoft Vmbus HID-compliant Mouse as /devices/virtual/input/input2
[   18.851709] hid 0006:045E:0621.0001: input: <UNKNOWN> HID v0.01 Mouse [Micros
oft Vmbus HID-compliant Mouse] on
[   23.870368] hv_vmbus: registering driver netvsc
[   23.885294] hv_netvsc: hv_netvsc channel opened successfully
[   23.996964] netvsc vmbus_0_9: Device MAC 00:15:5d:8f:0c:02 link state up
[   29.006143] sd 0:0:0:0: [sda] 62914560 512-byte logical blocks: (32.2 GB/30.0 GiB)
[   29.017302] sd 0:0:0:0: [sda] Write Protect is off
[   29.037502] sd 0:0:0:0: [sda] Mode Sense: 0f 00 10 00
[   29.045945] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   29.056013]  sda: sda1 sda2
[   29.062157] sd 0:0:0:0: [sda] Attached SCSI disk



���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
