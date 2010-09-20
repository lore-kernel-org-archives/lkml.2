Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0ITOLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:11:41 -0400
Received: from atl.turmel.org ([74.117.157.138]:56999 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279Ab0ITOLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:11:31 -0400
Message-ID: <4C976B86.4090606@turmel.org>
Date: Mon, 20 Sep 2010 10:11:18 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Mat <jackdachef@gmail.com>, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org> <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------080700030705030700040101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080700030705030700040101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/20/2010 09:25 AM, Jiri Kosina wrote:
> The patch below should at least tell us the same what addr2line would tell 
> us. The dmesg lines preceeding the OOPS will be interesting. Thanks.
> 
> 
> 
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index 681e620..3a5f097 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -270,17 +270,26 @@ static int hiddev_open(struct inode *inode, struct file *file)
>  	struct hiddev *hiddev;
>  	int res;
>  
> +	printk("A\n");
>  	intf = usbhid_find_interface(iminor(inode));
> +	printk("B\n");
>  	if (!intf)
>  		return -ENODEV;
> +	printk("C\n");
>  	hid = usb_get_intfdata(intf);
> +	printk("D\n");
>  	hiddev = hid->hiddev;
> +	printk("E\n");
>  
>  	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
>  		return -ENOMEM;
> +	printk("F\n");
>  	mutex_init(&list->thread_lock);
> +	printk("G\n");
>  	list->hiddev = hiddev;
> +	printk("H\n");
>  	file->private_data = list;
> +	printk("I\n");
>  
>  	/*
>  	 * no need for locking because the USB major number
> @@ -298,11 +307,14 @@ static int hiddev_open(struct inode *inode, struct file *file)
>  		res = -ENODEV;
>  		goto bail;
>  	}
> +	printk("J\n");
>  
>  	spin_lock_irq(&list->hiddev->list_lock);
>  	list_add_tail(&list->node, &hiddev->list);
>  	spin_unlock_irq(&list->hiddev->list_lock);
>  
> +	printk("K\n");
> +
>  	if (!list->hiddev->open++)
>  		if (list->hiddev->exist) {
>  			struct hid_device *hid = hiddev->hid;
> @@ -313,10 +325,13 @@ static int hiddev_open(struct inode *inode, struct file *file)
>  			}
>  			usbhid_open(hid);
>  		}
> +	printk("L\n");
>  	return 0;
>  bail:
> +	printk("M\n");
>  	file->private_data = NULL;
>  	kfree(list);
> +	printk("N\n");
>  	return res;
>  }

here you go:

[   16.689736] Adding 4192960k swap on /dev/sda3.  Priority:-1 extents:1 across:4192960k 
[   28.307298] A
[   28.307308] B
[   28.307309] C
[   28.307311] D
[   28.307312] E
[   28.307334] F
[   28.307335] G
[   28.307336] H
[   28.307337] I
[   28.307345] BUG: unable to handle kernel NULL pointer dereference at (null)
[   28.307881] IP: [<ffffffff817d0a22>] hiddev_open+0x152/0x2e0
[   28.308949] PGD 1398fa067 PUD 1398fb067 PMD 0 
[   28.310004] Oops: 0000 [#1] PREEMPT SMP 
[   28.310004] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
[   28.310004] CPU 0 
[   28.310004] Modules linked in: tpm_infineon iwlagn iwlcore tpm_tis tifm_7xx1 toshiba_acpi toshiba_bluetooth tifm_core pcmcia sdhci_pci sdhci yenta_socket [last unloaded: scsi_wait_scan]
[   28.313737] 
[   28.313737] Pid: 3152, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00167-g48e80ac #17 Portable PC/TECRA A9
[   28.313737] RIP: 0010:[<ffffffff817d0a22>]  [<ffffffff817d0a22>] hiddev_open+0x152/0x2e0
[   28.313737] RSP: 0018:ffff88013786bc38  EFLAGS: 00010296
[   28.313737] RAX: 0000000000000000 RBX: ffff88013a016d80 RCX: ffffffff820c7de0
[   28.313737] RDX: ffffffff81e72a48 RSI: 0000000000000046 RDI: ffffffff820c7cd0
[   28.313737] RBP: ffff88013786bc58 R08: 00000000ffffffff R09: 0000000000000000
[   28.313737] R10: 0000000000000000 R11: 0000000000000002 R12: ffff880139e80000
[   28.313737] R13: 0000000000000000 R14: 00000000ffffffed R15: ffff880138fa5af8
[   28.313737] FS:  00007f2a9595c700(0000) GS:ffff880002400000(0000) knlGS:0000000000000000
[   28.313737] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.313737] CR2: 0000000000000000 CR3: 0000000139f1a000 CR4: 00000000000006f0
[   28.313737] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   28.313737] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   28.313737] Process hald-probe-hidd (pid: 3152, threadinfo ffff88013786a000, task ffff88013b1b2ed0)
[   28.313737] Stack:
[   28.313737]  ffff88013a016d80 ffffffff81b57c20 ffffffff81b66420 00000000ffffffed
[   28.313737] <0> ffff88013786bc98 ffffffff8171794b 000000000029d5f6 ffff88013bb46d80
[   28.313737] <0> ffff880138fa5af8 ffff88013a016d80 0000000000000000 ffffffff81156ae0
[   28.313737] Call Trace:
[   28.313737]  [<ffffffff8171794b>] usb_open+0x10b/0x2b0
[   28.313737]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
[   28.313737]  [<ffffffff81156c07>] chrdev_open+0x127/0x280
[   28.313737]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
[   28.313737]  [<ffffffff81151508>] __dentry_open+0x108/0x3a0
[   28.313737]  [<ffffffff811518b4>] nameidata_to_filp+0x54/0x70
[   28.313737]  [<ffffffff8115f668>] do_last+0x3b8/0x6c0
[   28.313737]  [<ffffffff811618a8>] do_filp_open+0x228/0x670
[   28.313737]  [<ffffffff81919b65>] ? T.827+0x135/0x230
[   28.313737]  [<ffffffff8116c4aa>] ? alloc_fd+0xfa/0x140
[   28.313737]  [<ffffffff811512c5>] do_sys_open+0x65/0x130
[   28.313737]  [<ffffffff811513d0>] sys_open+0x20/0x30
[   28.313737]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   28.313737] Code: c0 4d 89 ac 24 18 c0 00 00 e8 e2 d5 2b 00 31 c0 4c 89 a3 98 00 00 00 48 c7 c7 11 43 c9 81 e8 cd d5 2b 00 49 8b 84 24 18 c0 00 00 <83> 38 00 0f 84 d9 00 00 00 8b 50 04 8d 4a 01 85 d2 89 48 04 75 
[   28.313737] RIP  [<ffffffff817d0a22>] hiddev_open+0x152/0x2e0
[   28.313737]  RSP <ffff88013786bc38>
[   28.313737] CR2: 0000000000000000
[   28.354413] ---[ end trace aac45f6a6d58c1a5 ]---

# addr2line -f -e vmlinux ffffffff817d0a22
hiddev_open
hiddev.c:0

Complete dmesg attached.

Since addr2line couldn't narrow this down, I'm attaching the object dump/disassembly as well.

Let me know what's next.

Regards,

Phil

--------------080700030705030700040101
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.36-rc4-00167-g48e80ac (root@scorpius) (gcc version 4.4.4 (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #17 SMP PREEMPT Mon Sep 20 09:45:13 EDT 2010
[    0.000000] Command line: debug root=LABEL=Root   snd_hda_intel.model=toshia-s06 raid=noautodetect selinux=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff40000 (usable)
[    0.000000]  BIOS-e820: 00000000bff40000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec28000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00500 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FEDA0000 mask FFFFE0000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbff40 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff40000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff40000 page 4k
[    0.000000] kernel direct mapping tables up to bff40000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ b000-11000
[    0.000000] RAMDISK: 3775f000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f01e0 00014 (v00 TOSHIB)
[    0.000000] ACPI: RSDT 00000000bff40000 00054 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: FACP 00000000bff40080 00084 (v02 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: DSDT 00000000bff40104 0635F (v02 TOSHIB A0056    20080108 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000000eee00 00040
[    0.000000] ACPI: SSDT 00000000bff46463 00506 (v02 TOSHIB A0056    20061102 MSFT 03000000)
[    0.000000] ACPI: BOOT 00000000bff40058 00028 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: APIC 00000000bff46dff 00068 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: MCFG 00000000bff46e67 0003C (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: HPET 00000000bff46ed7 00038 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: TCPA 00000000bff47085 00032 (v02 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: SLIC 00000000bff46f0f 00176 (v01 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: ASF! 00000000bff470b7 00075 (v16 TOSHIB A0056    20070816 TASM 04010000)
[    0.000000] ACPI: SSDT 00000000bff47bcb 005E1 (v02 TOSHIB A0056    20061220 MSFT 03000000)
[    0.000000] ACPI: SSDT 00000000bff4712c 00076 (v02 TOSHIB A0056    20051021 MSFT 03000000)
[    0.000000] ACPI: SSDT 00000000bff471a2 00A29 (v02 TOSHIB A0056    20061226 MSFT 03000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880100200000-ffff8801039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000bff40
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1031898
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3938 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767864 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xd808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bff40000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec28000
[    0.000000] PM: Registered nosave memory: 00000000fec28000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fedc0000
[    0.000000] PM: Registered nosave memory: 00000000fedc0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffd00000
[    0.000000] PM: Registered nosave memory: 00000000ffd00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ec00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002400000 s81920 r8192 d20480 u1048576
[    0.000000] pcpu-alloc: s81920 r8192 d20480 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1014202
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: debug root=LABEL=Root   snd_hda_intel.model=toshia-s06 raid=noautodetect selinux=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (56 early reservations)
[    0.000000]   #1 [0001000000 - 00021f4550]   TEXT DATA BSS
[    0.000000]   #2 [003775f000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009bc00 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00021f5000 - 00021f52c8]             BRK
[    0.000000]   #5 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #6 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #7 [0000008000 - 000000b000]         PGTABLE
[    0.000000]   #8 [000000b000 - 000000c000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [00021f5300 - 00021f6300]         BOOTMEM
[    0.000000]   #11 [00021f4580 - 00021f4880]         BOOTMEM
[    0.000000]   #12 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #13 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #14 [0100200000 - 0103a00000]        MEMMAP 0
[    0.000000]   #15 [00021f4880 - 00021f4a00]         BOOTMEM
[    0.000000]   #16 [00021f6300 - 000220e300]         BOOTMEM
[    0.000000]   #17 [000220e300 - 0002214300]         BOOTMEM
[    0.000000]   #18 [0002215000 - 0002216000]         BOOTMEM
[    0.000000]   #19 [00021f4a00 - 00021f4a41]         BOOTMEM
[    0.000000]   #20 [00021f4a80 - 00021f4ac3]         BOOTMEM
[    0.000000]   #21 [00021f4b00 - 00021f4eb8]         BOOTMEM
[    0.000000]   #22 [00021f4ec0 - 00021f4f28]         BOOTMEM
[    0.000000]   #23 [00021f4f40 - 00021f4fa8]         BOOTMEM
[    0.000000]   #24 [0002214300 - 0002214368]         BOOTMEM
[    0.000000]   #25 [0002214380 - 00022143e8]         BOOTMEM
[    0.000000]   #26 [0002214400 - 0002214468]         BOOTMEM
[    0.000000]   #27 [0002214480 - 00022144e8]         BOOTMEM
[    0.000000]   #28 [0002214500 - 0002214568]         BOOTMEM
[    0.000000]   #29 [0002214580 - 00022145e8]         BOOTMEM
[    0.000000]   #30 [0002214600 - 0002214668]         BOOTMEM
[    0.000000]   #31 [0002214680 - 00022146e8]         BOOTMEM
[    0.000000]   #32 [0002214700 - 0002214768]         BOOTMEM
[    0.000000]   #33 [0002214780 - 00022147e8]         BOOTMEM
[    0.000000]   #34 [0002214800 - 0002214868]         BOOTMEM
[    0.000000]   #35 [0002214880 - 00022148e8]         BOOTMEM
[    0.000000]   #36 [0002214900 - 0002214968]         BOOTMEM
[    0.000000]   #37 [0002214980 - 00022149e8]         BOOTMEM
[    0.000000]   #38 [00021f4fc0 - 00021f4fe0]         BOOTMEM
[    0.000000]   #39 [0002214a00 - 0002214a20]         BOOTMEM
[    0.000000]   #40 [0002214a40 - 0002214a93]         BOOTMEM
[    0.000000]   #41 [0002214ac0 - 0002214b13]         BOOTMEM
[    0.000000]   #42 [0002400000 - 000241b000]         BOOTMEM
[    0.000000]   #43 [0002500000 - 000251b000]         BOOTMEM
[    0.000000]   #44 [0002214b40 - 0002214b48]         BOOTMEM
[    0.000000]   #45 [0002214b80 - 0002214b88]         BOOTMEM
[    0.000000]   #46 [0002214bc0 - 0002214bc8]         BOOTMEM
[    0.000000]   #47 [0002214c00 - 0002214c10]         BOOTMEM
[    0.000000]   #48 [0002214c40 - 0002214d80]         BOOTMEM
[    0.000000]   #49 [0002214d80 - 0002214de0]         BOOTMEM
[    0.000000]   #50 [0002214e00 - 0002214e60]         BOOTMEM
[    0.000000]   #51 [0002216000 - 000221e000]         BOOTMEM
[    0.000000]   #52 [000251b000 - 000651b000]         BOOTMEM
[    0.000000]   #53 [000221e000 - 000223e000]         BOOTMEM
[    0.000000]   #54 [000223e000 - 000227e000]         BOOTMEM
[    0.000000]   #55 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3976688k/5177344k available (10836k kernel code, 1049752k absent, 150904k reserved, 5140k data, 1012k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.410 MHz processor.
[    0.003339] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.68 BogoMIPS (lpj=7314700)
[    0.003582] pid_max: default: 32768 minimum: 301
[    0.007048] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009842] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.011315] Mount-cache hash table entries: 256
[    0.011590] Initializing cgroup subsys cpuacct
[    0.011714] Initializing cgroup subsys net_cls
[    0.011860] CPU: Physical Processor ID: 0
[    0.011981] CPU: Processor Core ID: 0
[    0.012101] mce: CPU supports 6 MCE banks
[    0.012227] CPU0: Thermal monitoring handled by SMI
[    0.012350] using mwait in idle threads.
[    0.012470] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.012785] PEBS disabled due to CPU errata.
[    0.012908] ... version:                2
[    0.013027] ... bit width:              40
[    0.013145] ... generic registers:      2
[    0.013266] ... value mask:             000000ffffffffff
[    0.013341] ... max period:             000000007fffffff
[    0.013463] ... fixed-purpose events:   3
[    0.013582] ... event mask:             0000000700000003
[    0.013750] ACPI: Core revision 20100702
[    0.022495] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.022622] ftrace: allocating 35048 entries in 138 pages
[    0.023384] Setting APIC routing to flat
[    0.024053] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059521] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.070015] Booting Node   0, Processors  #1 Ok.
[    0.006666] CPU1: Thermal monitoring handled by SMI
[    0.166685] Brought up 2 CPUs
[    0.166926] Total of 2 processors activated (8781.55 BogoMIPS).
[    0.167584] devtmpfs: initialized
[    0.167584] xor: automatically using best checksumming function: generic_sse
[    0.183256]    generic_sse:  8130.000 MB/sec
[    0.183335] xor: using function: generic_sse (8130.000 MB/sec)
[    0.183466] NET: Registered protocol family 16
[    0.183516] ACPI: bus type pci registered
[    0.183516] dca service started, version 1.12.1
[    0.183516] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.183551] PCI: not using MMCONFIG
[    0.183669] PCI: Using configuration type 1 for base access
[    0.190030] bio: create slab <bio-0> at 0
[    0.246766] raid6: int64x1   1713 MB/s
[    0.303282] raid6: int64x2   2163 MB/s
[    0.359944] raid6: int64x4   1660 MB/s
[    0.416618] raid6: int64x8   1461 MB/s
[    0.473258] raid6: sse2x1    3706 MB/s
[    0.529929] raid6: sse2x2    3885 MB/s
[    0.586595] raid6: sse2x4    6555 MB/s
[    0.586668] raid6: using algorithm sse2x4 (6555 MB/s)
[    0.587751] ACPI: EC: Look up EC in DSDT
[    0.589117] ACPI: Actual Package length (12) is larger than NumElements field (5), truncated
[    0.589357] 
[    0.592449] ACPI Warning: Incorrect checksum in table [ASF!] - 0xE9, should be 0x94 (20100702/tbutils-314)
[    0.592756] ACPI: SSDT 00000000bff46b71 000F3 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.593321] ACPI: Dynamic OEM Table Load:
[    0.593513] ACPI: SSDT (null) 000F3 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.593949] ACPI: SSDT 00000000bff46cda 0006C (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.594505] ACPI: Dynamic OEM Table Load:
[    0.594749] ACPI: SSDT (null) 0006C (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.595279] ACPI: SSDT 00000000bff46c64 00076 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.595922] ACPI: Dynamic OEM Table Load:
[    0.596167] ACPI: SSDT (null) 00076 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.596522] ACPI: SSDT 00000000bff46d46 00079 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.597037] ACPI: Dynamic OEM Table Load:
[    0.597282] ACPI: SSDT (null) 00079 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.597700] ACPI: Interpreter enabled
[    0.597819] ACPI: (supports S0 S3 S4 S5)
[    0.598203] ACPI: Using IOAPIC for interrupt routing
[    0.598349] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.599404] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.617440] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.617563] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.617827] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.617985] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.617985] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.617985] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.617985] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.617985] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xefffffff]
[    0.620048] pci_root PNP0A08:00: host bridge window [mem 0xf4000000-0xfebfffff]
[    0.620224] pci_root PNP0A08:00: host bridge window [mem 0xfec28000-0xfecfffff]
[    0.620400] pci_root PNP0A08:00: host bridge window [mem 0xfed00500-0xfed13fff]
[    0.620577] pci_root PNP0A08:00: host bridge window [mem 0xfed1a000-0xfed1bfff]
[    0.620753] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.620929] pci_root PNP0A08:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.621114] pci_root PNP0A08:00: host bridge window [mem 0xfedc0000-0xfedfffff]
[    0.621290] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xff9fffff]
[    0.621466] pci_root PNP0A08:00: host bridge window [mem 0xffc00000-0xffcfffff]
[    0.621726] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.621850] pci 0000:00:01.0: PME# disabled
[    0.622000] pci 0000:00:03.0: reg 10: [mem 0xffcffff0-0xffcfffff 64bit]
[    0.622163] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.622286] pci 0000:00:03.0: PME# disabled
[    0.622495] pci 0000:00:19.0: reg 10: [mem 0xffcc0000-0xffcdffff]
[    0.622627] pci 0000:00:19.0: reg 14: [mem 0xffcfe000-0xffcfefff]
[    0.622760] pci 0000:00:19.0: reg 18: [io  0xbfe0-0xbfff]
[    0.622950] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.623076] pci 0000:00:19.0: PME# disabled
[    0.623267] pci 0000:00:1a.0: reg 20: [io  0xbf80-0xbf9f]
[    0.623510] pci 0000:00:1a.1: reg 20: [io  0x0000-0x001f]
[    0.624826] pci 0000:00:1a.7: reg 10: [mem 0xffcff800-0xffcffbff]
[    0.625038] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.625165] pci 0000:00:1a.7: PME# disabled
[    0.625334] pci 0000:00:1b.0: reg 10: [mem 0x00000000-0x00003fff 64bit]
[    0.625540] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.625664] pci 0000:00:1b.0: PME# disabled
[    0.625895] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.626021] pci 0000:00:1c.0: PME# disabled
[    0.626257] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.626382] pci 0000:00:1c.1: PME# disabled
[    0.626735] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.626861] pci 0000:00:1c.2: PME# disabled
[    0.627072] pci 0000:00:1d.0: reg 20: [io  0x9fe0-0x9fff]
[    0.627288] pci 0000:00:1d.1: reg 20: [io  0x9f80-0x9f9f]
[    0.627504] pci 0000:00:1d.2: reg 20: [io  0x9f60-0x9f7f]
[    0.627702] pci 0000:00:1d.7: reg 10: [mem 0xffcff400-0xffcff7ff]
[    0.627914] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.628040] pci 0000:00:1d.7: PME# disabled
[    0.628377] pci 0000:00:1f.0: quirk: [io  0xd800-0xd87f] claimed by ICH6 ACPI/GPIO/TCO
[    0.628556] pci 0000:00:1f.0: quirk: [io  0xeec0-0xeeff] claimed by ICH6 GPIO
[    0.628682] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.628864] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)
[    0.629093] pci 0000:00:1f.1: reg 10: [io  0x9f58-0x9f5f]
[    0.629225] pci 0000:00:1f.1: reg 14: [io  0x9f54-0x9f57]
[    0.629357] pci 0000:00:1f.1: reg 18: [io  0x9f48-0x9f4f]
[    0.629489] pci 0000:00:1f.1: reg 1c: [io  0x9f44-0x9f47]
[    0.629620] pci 0000:00:1f.1: reg 20: [io  0x9f30-0x9f3f]
[    0.629816] pci 0000:00:1f.2: reg 10: [io  0x9f28-0x9f2f]
[    0.629948] pci 0000:00:1f.2: reg 14: [io  0x9f24-0x9f27]
[    0.630048] pci 0000:00:1f.2: reg 18: [io  0x9f18-0x9f1f]
[    0.630180] pci 0000:00:1f.2: reg 1c: [io  0x9f14-0x9f17]
[    0.630311] pci 0000:00:1f.2: reg 20: [io  0x9ee0-0x9eff]
[    0.630444] pci 0000:00:1f.2: reg 24: [mem 0xffcfd800-0xffcfdfff]
[    0.630614] pci 0000:00:1f.2: PME# supported from D3hot
[    0.630738] pci 0000:00:1f.2: PME# disabled
[    0.630945] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.631088] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.631231] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.631368] pci 0000:01:00.0: reg 24: [io  0xcf00-0xcf7f]
[    0.631502] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.631700] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.631822] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.631946] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdffffff]
[    0.632073] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.632383] pci 0000:02:00.0: reg 10: [mem 0xff9fe000-0xff9fffff 64bit]
[    0.632667] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.632796] pci 0000:02:00.0: PME# disabled
[    0.636689] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.636815] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.636943] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.637074] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.637315] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.637441] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.637566] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.637697] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.637935] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.638061] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
[    0.638187] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.638373] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.638647] pci 0000:06:0b.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.638798] pci 0000:06:0b.0: supports D1 D2
[    0.638919] pci 0000:06:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.639053] pci 0000:06:0b.0: PME# disabled
[    0.639223] pci 0000:06:0b.1: reg 10: [mem 0x00000000-0x000007ff]
[    0.639361] pci 0000:06:0b.1: reg 14: [mem 0x00000000-0x00003fff]
[    0.639581] pci 0000:06:0b.1: supports D1 D2
[    0.639708] pci 0000:06:0b.1: PME# supported from D0 D1 D2 D3hot
[    0.639835] pci 0000:06:0b.1: PME# disabled
[    0.640028] pci 0000:06:0b.2: reg 10: [mem 0x00000000-0x00000fff]
[    0.640262] pci 0000:06:0b.2: supports D1 D2
[    0.640383] pci 0000:06:0b.2: PME# supported from D0 D1 D2 D3hot
[    0.640510] pci 0000:06:0b.2: PME# disabled
[    0.640679] pci 0000:06:0b.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.640912] pci 0000:06:0b.3: supports D1 D2
[    0.641033] pci 0000:06:0b.3: PME# supported from D0 D1 D2 D3hot
[    0.641161] pci 0000:06:0b.3: PME# disabled
[    0.641338] pci 0000:00:1e.0: PCI bridge to [bus 06-07] (subtractive decode)
[    0.641465] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.641592] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.641776] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.641954] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.642131] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.642309] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.642487] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.642665] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xefffffff] (subtractive decode)
[    0.642843] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfebfffff] (subtractive decode)
[    0.643022] pci 0000:00:1e.0:   bridge window [mem 0xfec28000-0xfecfffff] (subtractive decode)
[    0.643200] pci 0000:00:1e.0:   bridge window [mem 0xfed00500-0xfed13fff] (subtractive decode)
[    0.643335] pci 0000:00:1e.0:   bridge window [mem 0xfed1a000-0xfed1bfff] (subtractive decode)
[    0.643513] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.643691] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.643870] pci 0000:00:1e.0:   bridge window [mem 0xfedc0000-0xfedfffff] (subtractive decode)
[    0.644048] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xff9fffff] (subtractive decode)
[    0.644226] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffcfffff] (subtractive decode)
[    0.644460] pci_bus 0000:07: [bus 07-0a] partially hidden behind transparent bridge 0000:06 [bus 06-07]
[    0.644670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.644882] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.645089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MPEX._PRT]
[    0.645252] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXCB._PRT]
[    0.645412] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.645571] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.650333] ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
[    0.650457] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
[    0.651149] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
[    0.651844] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
[    0.652538] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
[    0.653784] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
[    0.654477] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
[    0.655169] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
[    0.655823] HEST: Table is not found!
[    0.655823] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.655823] vgaarb: loaded
[    0.655823] SCSI subsystem initialized
[    0.656676] libata version 3.00 loaded.
[    0.656704] usbcore: registered new interface driver usbfs
[    0.656814] usbcore: registered new interface driver hub
[    0.656814] usbcore: registered new device driver usb
[    0.656814] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.656814] PCI: Using ACPI for IRQ routing
[    0.656926] PCI: pci_cache_line_size set to 64 bytes
[    0.657167] reserve RAM buffer: 000000000009bc00 - 000000000009ffff 
[    0.657239] reserve RAM buffer: 00000000bff40000 - 00000000bfffffff 
[    0.657439] NET: Registered protocol family 23
[    0.657439] Bluetooth: Core ver 2.15
[    0.657439] NET: Registered protocol family 31
[    0.657439] Bluetooth: HCI device and connection manager initialized
[    0.657439] Bluetooth: HCI socket layer initialized
[    0.657439] NET: Registered protocol family 8
[    0.657439] NET: Registered protocol family 20
[    0.657439] cfg80211: Calling CRDA to update world regulatory domain
[    0.660054] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.666708] Switching to clocksource tsc
[    0.675392] pnp: PnP ACPI init
[    0.675535] ACPI: bus type pnp registered
[    0.677986] pnp 00:09: disabling [io  0x0010-0x001f] because it overlaps 0000:00:1a.1 BAR 4 [io  0x0000-0x001f]
[    0.679988] pnp: PnP ACPI: found 13 devices
[    0.680110] ACPI: ACPI bus type pnp unregistered
[    0.680240] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.680365] system 00:00: [mem 0x000e8000-0x000fffff] could not be reserved
[    0.680489] system 00:00: [mem 0x00100000-0xbff3ffff] could not be reserved
[    0.680613] system 00:00: [mem 0xbff40000-0xbff4ffff] has been reserved
[    0.680736] system 00:00: [mem 0xbff50000-0xbfffffff] has been reserved
[    0.680860] system 00:00: [mem 0xfec00000-0xfec27fff] could not be reserved
[    0.680984] system 00:00: [mem 0xfed00400-0xfed004ff] has been reserved
[    0.681107] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.681231] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.681356] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.681480] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.681604] system 00:00: [mem 0xfeda0000-0xfedbffff] has been reserved
[    0.681734] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.681859] system 00:00: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.681983] system 00:00: [mem 0xffd00000-0xffffffff] has been reserved
[    0.682107] system 00:00: [mem 0x100000000-0x13bffffff] could not be reserved
[    0.683370] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.683499] system 00:09: [io  0x01e0-0x01ef] has been reserved
[    0.683621] system 00:09: [io  0x0480-0x048f] has been reserved
[    0.683745] system 00:09: [io  0xe000-0xe07f] has been reserved
[    0.683869] system 00:09: [io  0xe080-0xe0ff] has been reserved
[    0.683993] system 00:09: [io  0xe400-0xe47f] has been reserved
[    0.684116] system 00:09: [io  0xe480-0xe4ff] has been reserved
[    0.684240] system 00:09: [io  0xe800-0xe87f] has been reserved
[    0.684363] system 00:09: [io  0xe880-0xe8ff] has been reserved
[    0.684487] system 00:09: [io  0xec00-0xec7f] has been reserved
[    0.684609] system 00:09: [io  0xec80-0xecff] has been reserved
[    0.684733] system 00:09: [io  0xd800-0xd87f] has been reserved
[    0.684857] system 00:09: [io  0xd880-0xd89f] has been reserved
[    0.684980] system 00:09: [io  0xeec0-0xeeff] has been reserved
[    0.685104] system 00:09: [io  0x0690-0x06ff] has been reserved
[    0.685227] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.692937] pci 0000:00:1e.0: BAR 15: assigned [mem 0xc0000000-0xc3ffffff pref]
[    0.693117] pci 0000:00:1e.0: BAR 14: assigned [mem 0xc4000000-0xc9ffffff]
[    0.693250] pci 0000:00:1c.1: BAR 15: assigned [mem 0xca000000-0xca1fffff 64bit pref]
[    0.693429] pci 0000:00:1b.0: BAR 0: assigned [mem 0xca200000-0xca203fff 64bit]
[    0.693613] pci 0000:00:1b.0: BAR 0: set to [mem 0xca200000-0xca203fff 64bit] (PCI address [0xca200000-0xca203fff]
[    0.693795] pci 0000:00:1e.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.693918] pci 0000:00:1a.1: BAR 4: assigned [io  0x2000-0x201f]
[    0.694045] pci 0000:00:1a.1: BAR 4: set to [io  0x2000-0x201f] (PCI address [0x2000-0x201f]
[    0.694225] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    0.694403] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.694527] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.694652] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdffffff]
[    0.694776] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.694955] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.695078] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.695206] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.695333] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.695461] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.695583] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.695710] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.695840] pci 0000:00:1c.1:   bridge window [mem 0xca000000-0xca1fffff 64bit pref]
[    0.696023] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.696145] pci 0000:00:1c.2:   bridge window [io  disabled]
[    0.696271] pci 0000:00:1c.2:   bridge window [mem disabled]
[    0.696396] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    0.696535] pci 0000:06:0b.0: BAR 15: assigned [mem 0xc0000000-0xc3ffffff pref]
[    0.696711] pci 0000:06:0b.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.696835] pci 0000:06:0b.1: BAR 1: assigned [mem 0xc8000000-0xc8003fff]
[    0.696962] pci 0000:06:0b.1: BAR 1: set to [mem 0xc8000000-0xc8003fff] (PCI address [0xc8000000-0xc8003fff]
[    0.697145] pci 0000:06:0b.0: BAR 0: assigned [mem 0xc8004000-0xc8004fff]
[    0.697273] pci 0000:06:0b.0: BAR 0: set to [mem 0xc8004000-0xc8004fff] (PCI address [0xc8004000-0xc8004fff]
[    0.697453] pci 0000:06:0b.2: BAR 0: assigned [mem 0xc8005000-0xc8005fff]
[    0.697582] pci 0000:06:0b.2: BAR 0: set to [mem 0xc8005000-0xc8005fff] (PCI address [0xc8005000-0xc8005fff]
[    0.697766] pci 0000:06:0b.1: BAR 0: assigned [mem 0xc8006000-0xc80067ff]
[    0.697894] pci 0000:06:0b.1: BAR 0: set to [mem 0xc8006000-0xc80067ff] (PCI address [0xc8006000-0xc80067ff]
[    0.698074] pci 0000:06:0b.0: BAR 13: assigned [io  0x1000-0x10ff]
[    0.698197] pci 0000:06:0b.0: BAR 14: assigned [io  0x1400-0x14ff]
[    0.698327] pci 0000:06:0b.3: BAR 0: assigned [mem 0xc8006800-0xc80068ff]
[    0.698455] pci 0000:06:0b.3: BAR 0: set to [mem 0xc8006800-0xc80068ff] (PCI address [0xc8006800-0xc80068ff]
[    0.698636] pci 0000:06:0b.0: CardBus bridge to [bus 07-0a]
[    0.698759] pci 0000:06:0b.0:   bridge window [io  0x1000-0x10ff]
[    0.698885] pci 0000:06:0b.0:   bridge window [io  0x1400-0x14ff]
[    0.699012] pci 0000:06:0b.0:   bridge window [mem 0xc0000000-0xc3ffffff pref]
[    0.699192] pci 0000:06:0b.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.699320] pci 0000:00:1e.0: PCI bridge to [bus 06-07]
[    0.699443] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.699571] pci 0000:00:1e.0:   bridge window [mem 0xc4000000-0xc9ffffff]
[    0.699698] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xc3ffffff pref]
[    0.699900] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.700026] pci 0000:00:01.0: setting latency timer to 64
[    0.700158] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.700285] pci 0000:00:1c.0: setting latency timer to 64
[    0.700415] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.700541] pci 0000:00:1c.1: setting latency timer to 64
[    0.700674] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.700801] pci 0000:00:1c.2: setting latency timer to 64
[    0.700930] pci 0000:00:1e.0: setting latency timer to 64
[    0.701063] pci 0000:06:0b.0: enabling device (0000 -> 0003)
[    0.701190] pci 0000:06:0b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.701321] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.701443] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.701567] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.701691] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.701815] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xefffffff]
[    0.701939] pci_bus 0000:00: resource 9 [mem 0xf4000000-0xfebfffff]
[    0.702063] pci_bus 0000:00: resource 10 [mem 0xfec28000-0xfecfffff]
[    0.702187] pci_bus 0000:00: resource 11 [mem 0xfed00500-0xfed13fff]
[    0.702311] pci_bus 0000:00: resource 12 [mem 0xfed1a000-0xfed1bfff]
[    0.702435] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.702559] pci_bus 0000:00: resource 14 [mem 0xfed90000-0xfed9ffff]
[    0.702683] pci_bus 0000:00: resource 15 [mem 0xfedc0000-0xfedfffff]
[    0.702806] pci_bus 0000:00: resource 16 [mem 0xfee01000-0xff9fffff]
[    0.702931] pci_bus 0000:00: resource 17 [mem 0xffc00000-0xffcfffff]
[    0.703054] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.703178] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfdffffff]
[    0.703309] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.703488] pci_bus 0000:02: resource 1 [mem 0xff900000-0xff9fffff]
[    0.703611] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    0.703735] pci_bus 0000:03: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.703859] pci_bus 0000:03: resource 2 [mem 0xca000000-0xca1fffff 64bit pref]
[    0.704036] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.704159] pci_bus 0000:06: resource 1 [mem 0xc4000000-0xc9ffffff]
[    0.704283] pci_bus 0000:06: resource 2 [mem 0xc0000000-0xc3ffffff pref]
[    0.704407] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.704531] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.704654] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.704777] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000dffff]
[    0.704900] pci_bus 0000:06: resource 8 [mem 0xc0000000-0xefffffff]
[    0.705023] pci_bus 0000:06: resource 9 [mem 0xf4000000-0xfebfffff]
[    0.705147] pci_bus 0000:06: resource 10 [mem 0xfec28000-0xfecfffff]
[    0.705271] pci_bus 0000:06: resource 11 [mem 0xfed00500-0xfed13fff]
[    0.705395] pci_bus 0000:06: resource 12 [mem 0xfed1a000-0xfed1bfff]
[    0.705519] pci_bus 0000:06: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.705643] pci_bus 0000:06: resource 14 [mem 0xfed90000-0xfed9ffff]
[    0.705767] pci_bus 0000:06: resource 15 [mem 0xfedc0000-0xfedfffff]
[    0.705890] pci_bus 0000:06: resource 16 [mem 0xfee01000-0xff9fffff]
[    0.706014] pci_bus 0000:06: resource 17 [mem 0xffc00000-0xffcfffff]
[    0.706138] pci_bus 0000:07: resource 0 [io  0x1000-0x10ff]
[    0.706262] pci_bus 0000:07: resource 1 [io  0x1400-0x14ff]
[    0.706385] pci_bus 0000:07: resource 2 [mem 0xc0000000-0xc3ffffff pref]
[    0.706509] pci_bus 0000:07: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.706669] NET: Registered protocol family 2
[    0.706941] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.708356] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.713409] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.714190] TCP: Hash tables configured (established 524288 bind 65536)
[    0.714314] TCP reno registered
[    0.714444] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.714613] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.714868] NET: Registered protocol family 1
[    0.715106] RPC: Registered udp transport module.
[    0.715228] RPC: Registered tcp transport module.
[    0.715350] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.715664] pci 0000:01:00.0: Boot video device
[    0.715807] PCI: CLS 32 bytes, default 64
[    0.715976] Trying to unpack rootfs image as initramfs...
[    0.887057] Freeing initrd memory: 8772k freed
[    0.891881] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.892012] Placing 64MB software IO TLB between ffff88000251b000 - ffff88000651b000
[    0.892190] software IO TLB at phys 0x251b000 - 0x651b000
[    0.892758] Simple Boot Flag value 0xb read from CMOS RAM was invalid
[    0.892889] Simple Boot Flag at 0x7c set to 0x1
[    0.893570] Intel AES-NI instructions are not detected.
[    0.893692] Intel PCLMULQDQ-NI instructions are not detected.
[    0.894343] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.896913] VFS: Disk quotas dquot_6.5.2
[    0.897107] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.897923] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.898475] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.899064] fuse init (API version 7.15)
[    0.899451] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.903125] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    0.904119] SGI XFS Quota Management subsystem
[    0.904522] Btrfs loaded
[    0.904646] msgmni has been set to 7784
[    0.905732] async_tx: api initialized (async)
[    0.905896] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.906075] io scheduler noop registered
[    0.906195] io scheduler deadline registered (default)
[    0.906714] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.906911] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.908157] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.908454] acpiphp: Slot [1] registered
[    0.908676] acpiphp: Slot [1-1] registered
[    0.908854] pci-stub: invalid id string ""
[    0.909216] ACPI: AC Adapter [ADP1] (off-line)
[    0.909441] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.909657] ACPI: Lid Switch [LID]
[    0.909934] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.910120] ACPI: Power Button [PWRB]
[    0.910296] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.910474] ACPI: Power Button [PWRF]
[    0.911758] acpi device:23: registered as cooling_device0
[    0.912031] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/LNXVIDEO:00/input/input3
[    0.912213] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
[    0.912476] ACPI: acpi_idle registered with cpuidle
[    0.912720] Marking TSC unstable due to TSC halts in idle
[    0.913026] Switching to clocksource hpet
[    0.915367] thermal LNXTHERM:01: registered as thermal_zone0
[    0.915490] ACPI: Thermal Zone [THRM] (70 C)
[    0.916345] ACPI: Battery Slot [BAT1] (battery present)
[    0.916428] ERST: Table is not found!
[    0.916429] GHES: HEST is not enabled!
[    0.916816] Linux agpgart interface v0.103
[    0.917027] [drm] Initialized drm 1.1.0 20060810
[    0.917361] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    0.917630] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    0.917763] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.917892] nouveau 0000:01:00.0: setting latency timer to 64
[    0.922763] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x086a00a2)
[    0.929895] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    1.018851] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    1.018976] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    1.019099] [drm] nouveau 0000:01:00.0: Bios version 60.86.49.00
[    1.019294] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    1.019417] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    1.019539] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    1.019718] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 010003f3 00010035
[    1.019842] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02811300 00000028
[    1.019967] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02822312 00000030
[    1.020103] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 01833320 00000028
[    1.020227] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 0000000e 00000000
[    1.020352] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[    1.020477] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[    1.020654] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    1.020832] [drm] nouveau 0000:01:00.0:   2: 0x00001255: type 0x55 idx 2 tag 0x07
[    1.021011] [drm] nouveau 0000:01:00.0: unknown type, using 0x31
[    1.021135] [drm] nouveau 0000:01:00.0:   3: 0x00000351: type 0x51 idx 3 tag 0xff
[    1.021380] [drm] nouveau 0000:01:00.0: unknown type, using 0x00
[    1.021507] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC377
[    1.060123] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC6C3
[    1.093347] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD304
[    1.093530] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD3F6
[    1.100084] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD5F0
[    1.100262] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD655
[    1.123350] [drm] nouveau 0000:01:00.0: 0xD655: Condition still not met after 20ms, skipping following opcodes
[    1.123537] [drm] nouveau 0000:01:00.0: BIOS FP mode: 1680x1050 (119880kHz pixel clock)
[    1.123716] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    1.254162] [TTM] Zone  kernel: Available graphics memory: 1992730 kiB.
[    1.254286] [TTM] Initializing pool allocator.
[    1.286545] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    1.906580] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    1.913537] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    2.017274] [drm] nouveau 0000:01:00.0: allocated 1680x1050 fb: 0x40230000, bo ffff880138f41000
[    2.017586] fbcon: nouveaufb (fb0) is primary device
[    2.027306] Console: switching to colour frame buffer device 210x65
[    2.031101] fb0: nouveaufb frame buffer device
[    2.031120] drm: registered panic notifier
[    2.031141] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    2.031221] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.052071] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.073342] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.074019] brd: module loaded
[    2.074981] loop: module loaded
[    2.075501] Loading iSCSI transport class v2.0-870.
[    2.076022] iscsi: registered transport (tcp)
[    2.076188] SCSI Media Changer driver v0.25 
[    2.076281] ahci 0000:00:1f.2: version 3.0
[    2.076308] ahci 0000:00:1f.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    2.076367] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.076434] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x3 impl SATA mode
[    2.076445] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    2.076458] ahci 0000:00:1f.2: setting latency timer to 64
[    2.080077] scsi0 : ahci
[    2.080216] scsi1 : ahci
[    2.080339] scsi2 : ahci
[    2.080532] ata1: SATA max UDMA/133 abar m2048@0xffcfd800 port 0xffcfd900 irq 40
[    2.080543] ata2: SATA max UDMA/133 abar m2048@0xffcfd800 port 0xffcfd980 irq 40
[    2.080552] ata3: DUMMY
[    2.080662] ata_piix 0000:00:1f.1: version 2.13
[    2.080679] ata_piix 0000:00:1f.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.080720] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.080800] scsi3 : ata_piix
[    2.080918] scsi4 : ata_piix
[    2.081224] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x9f30 irq 14
[    2.081235] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x9f38 irq 15
[    2.081307] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    2.081317] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.081363] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    2.081372] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    2.081394] ata5: port disabled. ignoring.
[    2.081402] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.081412] e1000e 0000:00:19.0: setting latency timer to 64
[    2.081543] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    2.240367] ata4.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.40, max UDMA/33
[    2.253618] ata4.00: configured for UDMA/33
[    2.372251] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:15:b7:10:1e:f4
[    2.372641] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.373563] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
[    2.374455] CAN device driver interface
[    2.375279] sja1000 CAN netdevice driver
[    2.376151] VMware vmxnet3 virtual NIC driver - version 1.0.14.0-k-NAPI
[    2.377114] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.1.3 (June 24, 2010)
[    2.377964] tun: Universal TUN/TAP device driver, 1.6
[    2.378793] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.379730] console [netcon0] enabled
[    2.380534] netconsole: network logging started
[    2.381454] firewire_ohci 0000:06:0b.1: enabling device (0000 -> 0002)
[    2.382275] firewire_ohci 0000:06:0b.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.400029] ata2: SATA link down (SStatus 0 SControl 300)
[    2.400368] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.401814] ata1.00: unexpected _GTF length (8)
[    2.402420] ata1.00: ATA-8: Hitachi HTS725050A9A364, PC4OC70E, max UDMA/133
[    2.403003] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.404656] ata1.00: unexpected _GTF length (8)
[    2.405286] ata1.00: configured for UDMA/133
[    2.416776] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
[    2.417303] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.417384] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.418990] sd 0:0:0:0: [sda] Write Protect is off
[    2.419821] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.419994] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.40 PQ: 0 ANSI: 5
[    2.421663] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.426004] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.426366] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.427444] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.428315] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    2.433402] firewire_ohci: Added fw-ohci device 0000:06:0b.1, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    2.434214] aoe: AoE v47 initialised.
[    2.434891] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.435757] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.436738] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.437666] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.438676] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.439614] ehci_hcd 0000:00:1a.7: debug port 1
[    2.444454] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.444890] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xffcff800
[    2.456687] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.457263] hub 1-0:1.0: USB hub found
[    2.458086] hub 1-0:1.0: 4 ports detected
[    2.459112] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.460042] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.460994] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.462023] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.462977] ehci_hcd 0000:00:1d.7: debug port 1
[    2.467830] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.468304] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffcff400
[    2.480016] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.480609] hub 2-0:1.0: USB hub found
[    2.481428] hub 2-0:1.0: 6 ports detected
[    2.482484] uhci_hcd: USB Universal Host Controller Interface driver
[    2.483363] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.484299] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.485265] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.486290] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.487221] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bf80
[    2.488286] hub 3-0:1.0: USB hub found
[    2.489059] hub 3-0:1.0: 2 ports detected
[    2.490055] uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
[    2.490917] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.491849] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.492782] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.493770] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.494651] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002000
[    2.495705] hub 4-0:1.0: USB hub found
[    2.496453] hub 4-0:1.0: 2 ports detected
[    2.497412] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.498265] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.499176] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.500136] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.500997] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009fe0
[    2.502039] hub 5-0:1.0: USB hub found
[    2.502756] hub 5-0:1.0: 2 ports detected
[    2.503699] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.504529] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.505416] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.506358] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.507220] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009f80
[    2.508191] hub 6-0:1.0: USB hub found
[    2.508898] hub 6-0:1.0: 2 ports detected
[    2.509803] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.510631] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.511471] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.512357] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.513156] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009f60
[    2.514129] hub 7-0:1.0: USB hub found
[    2.514782] hub 7-0:1.0: 2 ports detected
[    2.515792] usbcore: registered new interface driver wusb-cbaf
[    2.516512] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.521702] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.522067] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.522958] mice: PS/2 mouse device common for all mice
[    2.523916] rtc_cmos 00:08: RTC can wake from S4
[    2.524440] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    2.525204] rtc0: alarms up to one year, 114 bytes nvram, hpet irqs
[    2.526020] i2c /dev entries driver
[    2.527280] lirc_dev: IR Remote Control driver registered, major 249 
[    2.527603] IR LIRC bridge handler initialized
[    2.528415] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    2.529460] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0xd860)
[    2.530161] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.530921] iTCO_vendor_support: vendor-support=0
[    2.531754] md: linear personality registered for level -1
[    2.532595] md: raid0 personality registered for level 0
[    2.533531] md: raid1 personality registered for level 1
[    2.534249] md: raid10 personality registered for level 10
[    2.535079] md: raid6 personality registered for level 6
[    2.535906] md: raid5 personality registered for level 5
[    2.536765] md: raid4 personality registered for level 4
[    2.536814] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.538552] device-mapper: uevent: version 1.0.3
[    2.539309] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    2.540108] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    2.540931] usbcore: registered new interface driver btusb
[    2.541742] EDAC MC: Ver: 2.1.0 Sep 19 2010
[    2.543963] cpuidle: using governor ladder
[    2.544935] cpuidle: using governor menu
[    2.545553] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.546909] usbcore: registered new interface driver hiddev
[    2.547286] usbcore: registered new interface driver usbhid
[    2.548050] usbhid: USB HID core driver
[    2.549207] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    2.549769] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    2.550623] HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    2.551453] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.552351] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    2.553160] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.586384] hda_codec: ALC262: SKU not ready 0x598301f0
[    2.586870] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[    2.724676]  sda: sda1 sda2 sda3 sda4
[    2.725349] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.933439] firewire_core: created device fw0: GUID 0000390000875f33, S400
[    3.066708] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    3.258152] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input6
[    3.265194] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input7
[    3.265662] generic-usb 0003:046D:C51B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    3.280064] generic-usb 0003:046D:C51B.0002: hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    3.287676] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input8
[    3.506707] usb 6-1: new full speed USB device using uhci_hcd and address 2
[    3.597894] ALSA device list:
[    3.598259]   #0: HDA Intel at 0xca200000 irq 42
[    3.599376] oprofile: using NMI interrupt.
[    3.600272] Netfilter messages via NETLINK v0.30.
[    3.601221] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.602516] ctnetlink v0.93: registering with nfnetlink.
[    3.603187] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    3.604200] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    3.605512] xt_time: kernel timezone is -0000
[    3.606693] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.607207] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    3.608193] arp_tables: (C) 2002 David S. Miller
[    3.609216] TCP bic registered
[    3.610210] TCP cubic registered
[    3.611205] TCP westwood registered
[    3.612182] TCP highspeed registered
[    3.613162] TCP hybla registered
[    3.614147] TCP htcp registered
[    3.615088] TCP vegas registered
[    3.616036] TCP veno registered
[    3.616975] TCP scalable registered
[    3.616977] TCP lp registered
[    3.616978] TCP yeah registered
[    3.616979] TCP illinois registered
[    3.616980] Initializing XFRM netlink socket
[    3.619274] NET: Registered protocol family 10
[    3.619704] lo: Disabled Privacy Extensions
[    3.620253] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.620324] IPv6 over IPv4 tunneling driver
[    3.620690] sit0: Disabled Privacy Extensions
[    3.621311] ip6tnl0: Disabled Privacy Extensions
[    3.621576] NET: Registered protocol family 17
[    3.621583] NET: Registered protocol family 15
[    3.621623] Bridge firewalling registered
[    3.621625] Ebtables v2.0 registered
[    3.621666] can: controller area network core (rev 20090105 abi 8)
[    3.621691] NET: Registered protocol family 29
[    3.621693] can: raw protocol (rev 20090105)
[    3.621695] can: broadcast manager protocol (rev 20090105 t)
[    3.622394] IrCOMM protocol (Dag Brattli)
[    3.623908] Bluetooth: L2CAP ver 2.15
[    3.623909] Bluetooth: L2CAP socket layer initialized
[    3.623913] Bluetooth: SCO (Voice Link) ver 0.6
[    3.623914] Bluetooth: SCO socket layer initialized
[    3.623936] Bluetooth: RFCOMM TTY layer initialized
[    3.623939] Bluetooth: RFCOMM socket layer initialized
[    3.623940] Bluetooth: RFCOMM ver 1.11
[    3.623942] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.623943] Bluetooth: BNEP filters: protocol multicast
[    3.623945] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.624030] lec:lane_module_init: lec.c: Sep 19 2010 21:07:27 initialized
[    3.624033] mpoa:atm_mpoa_init: mpc.c: Sep 19 2010 21:07:26 initialized
[    3.624038] L2TP core driver, V2.0
[    3.624039] L2TP IP encapsulation support (L2TPv3)
[    3.624099] L2TP netlink interface
[    3.624110] L2TP ethernet pseudowire support (L2TPv3)
[    3.624111] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    3.624113] All bugs added by David S. Miller <davem@redhat.com>
[    3.624899] SCTP: Hash tables configured (established 65536 bind 65536)
[    3.625262] lib80211: common routines for IEEE802.11 drivers
[    3.625265] lib80211_crypt: registered algorithm 'NULL'
[    3.625275] Registering the dns_resolver key type
[    3.647992] registered taskstats version 1
[    3.653076] rtc_cmos 00:08: setting system clock to 2010-09-20 13:50:22 UTC (1284990622)
[    3.654717] Freeing unused kernel memory: 1012k freed
[    3.691379] udev: starting version 161
[    3.692032] udevd (1294): /proc/1294/oom_adj is deprecated, please use /proc/1294/oom_score_adj instead.
[    3.779882] yenta_cardbus 0000:06:0b.0: CardBus bridge found [1179:0001]
[    3.780816] sdhci: Secure Digital Host Controller Interface driver
[    3.781088] yenta_cardbus 0000:06:0b.0: Enabling burst memory read transactions
[    3.781987] sdhci: Copyright(c) Pierre Ossman
[    3.782682] yenta_cardbus 0000:06:0b.0: Using CSCINT to route CSC interrupts to PCI
[    3.785093] yenta_cardbus 0000:06:0b.0: Routing CardBus interrupts to PCI
[    3.785425] yenta_cardbus 0000:06:0b.0: TI: mfunc 0x01aa1022, devctl 0x64
[    4.014409] yenta_cardbus 0000:06:0b.0: ISA IRQ mask 0x0cf8, PCI irq 20
[    4.014666] yenta_cardbus 0000:06:0b.0: Socket status: 30000410
[    4.015493] pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #07 to #0a
[    4.016364] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [io  0x1000-0x1fff]
[    4.017249] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [mem 0xc4000000-0xc9ffffff]
[    4.018143] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc4000000-0xc9ffffff: excluding 0xc4000000-0xc81fffff
[    4.018156] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [mem 0xc0000000-0xc3ffffff pref]
[    4.018158] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc0000000-0xc3ffffff: excluding 0xc0000000-0xc3ffffff
[    4.018621] sdhci-pci 0000:06:0b.3: SDHCI controller found [104c:803c] (rev 0)
[    4.018646] sdhci-pci 0000:06:0b.3: enabling device (0000 -> 0002)
[    4.018654] sdhci-pci 0000:06:0b.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.024076] Registered led device: mmc0::
[    4.025013] mmc0: SDHCI controller on PCI [0000:06:0b.3] using DMA
[    4.206232] dracut: Scanning devices sda4  for LVM volume groups 
[    4.221797] dracut: Reading all physical volumes. This may take a while...
[    4.222295] dracut: Found volume group "Group0" using metadata type lvm2
[    4.245318] dracut: The link /dev/Group0/Root should had been created by udev but it was not found. Falling back to direct link creation.
[    4.245884] dracut: 1 logical volume(s) in volume group "Group0" now active
[    4.368230] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[    4.369004] EXT4-fs (dm-0): write access will be enabled during recovery
[    4.903435] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
[    4.904218] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc8200000-0xc9ffffff: excluding 0xc8f20000-0xc90fffff
[    4.911714] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 20)
[    6.952535] EXT4-fs (dm-0): orphan cleanup on readonly fs
[    6.953328] EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 3936667
[    6.954347] EXT4-fs (dm-0): 1 orphan inode deleted
[    6.955452] EXT4-fs (dm-0): recovery complete
[    7.193761] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    7.255300] dracut: Remounting /dev/disk/by-label/Root with -o acl,noatime,ro
[    7.311069] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl
[    7.324725] dracut: Mounted root filesystem /dev/mapper/Group0-Root
[    7.415543] dracut: Switching root
[   10.362401] udev: starting version 161
[   11.745053] Detected Toshiba ACPI Bluetooth device - installing RFKill handler
[   11.746923] toshiba_bluetooth: Re-enabling Toshiba Bluetooth
[   11.767601] input: Toshiba input device as /devices/virtual/input/input9
[   11.767657] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   11.767659] toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
[   11.774602] Registered led device: toshiba::illumination
[   11.778933] tifm_7xx1 0000:06:0b.2: enabling device (0000 -> 0002)
[   11.778942] tifm_7xx1 0000:06:0b.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   11.792096] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[   12.004665] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   12.004669] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   12.004761] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.004771] iwlagn 0000:02:00.0: setting latency timer to 64
[   12.004827] iwlagn 0000:02:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[   12.044946] iwlagn 0000:02:00.0: device EEPROM VER=0x36, CALIB=0x5
[   12.044962] iwlagn 0000:02:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[   12.045041] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[   12.130590] iwlagn 0000:02:00.0: loaded firmware version 228.61.2.24
[   12.174411] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.333390] usb 6-2: new full speed USB device using uhci_hcd and address 3
[   15.910232] EXT4-fs (dm-0): re-mounted. Opts: acl
[   16.133114] REISERFS (device sda1): found reiserfs format "3.6" with standard journal
[   16.133143] REISERFS (device sda1): using ordered data mode
[   16.133369] REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   16.133921] REISERFS (device sda1): checking transaction log (sda1)
[   16.148543] REISERFS (device sda1): Using r5 hash to sort names
[   16.689736] Adding 4192960k swap on /dev/sda3.  Priority:-1 extents:1 across:4192960k 
[   28.307298] A
[   28.307308] B
[   28.307309] C
[   28.307311] D
[   28.307312] E
[   28.307334] F
[   28.307335] G
[   28.307336] H
[   28.307337] I
[   28.307345] BUG: unable to handle kernel NULL pointer dereference at (null)
[   28.307881] IP: [<ffffffff817d0a22>] hiddev_open+0x152/0x2e0
[   28.308949] PGD 1398fa067 PUD 1398fb067 PMD 0 
[   28.310004] Oops: 0000 [#1] PREEMPT SMP 
[   28.310004] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
[   28.310004] CPU 0 
[   28.310004] Modules linked in: tpm_infineon iwlagn iwlcore tpm_tis tifm_7xx1 toshiba_acpi toshiba_bluetooth tifm_core pcmcia sdhci_pci sdhci yenta_socket [last unloaded: scsi_wait_scan]
[   28.313737] 
[   28.313737] Pid: 3152, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00167-g48e80ac #17 Portable PC/TECRA A9
[   28.313737] RIP: 0010:[<ffffffff817d0a22>]  [<ffffffff817d0a22>] hiddev_open+0x152/0x2e0
[   28.313737] RSP: 0018:ffff88013786bc38  EFLAGS: 00010296
[   28.313737] RAX: 0000000000000000 RBX: ffff88013a016d80 RCX: ffffffff820c7de0
[   28.313737] RDX: ffffffff81e72a48 RSI: 0000000000000046 RDI: ffffffff820c7cd0
[   28.313737] RBP: ffff88013786bc58 R08: 00000000ffffffff R09: 0000000000000000
[   28.313737] R10: 0000000000000000 R11: 0000000000000002 R12: ffff880139e80000
[   28.313737] R13: 0000000000000000 R14: 00000000ffffffed R15: ffff880138fa5af8
[   28.313737] FS:  00007f2a9595c700(0000) GS:ffff880002400000(0000) knlGS:0000000000000000
[   28.313737] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.313737] CR2: 0000000000000000 CR3: 0000000139f1a000 CR4: 00000000000006f0
[   28.313737] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   28.313737] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   28.313737] Process hald-probe-hidd (pid: 3152, threadinfo ffff88013786a000, task ffff88013b1b2ed0)
[   28.313737] Stack:
[   28.313737]  ffff88013a016d80 ffffffff81b57c20 ffffffff81b66420 00000000ffffffed
[   28.313737] <0> ffff88013786bc98 ffffffff8171794b 000000000029d5f6 ffff88013bb46d80
[   28.313737] <0> ffff880138fa5af8 ffff88013a016d80 0000000000000000 ffffffff81156ae0
[   28.313737] Call Trace:
[   28.313737]  [<ffffffff8171794b>] usb_open+0x10b/0x2b0
[   28.313737]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
[   28.313737]  [<ffffffff81156c07>] chrdev_open+0x127/0x280
[   28.313737]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
[   28.313737]  [<ffffffff81151508>] __dentry_open+0x108/0x3a0
[   28.313737]  [<ffffffff811518b4>] nameidata_to_filp+0x54/0x70
[   28.313737]  [<ffffffff8115f668>] do_last+0x3b8/0x6c0
[   28.313737]  [<ffffffff811618a8>] do_filp_open+0x228/0x670
[   28.313737]  [<ffffffff81919b65>] ? T.827+0x135/0x230
[   28.313737]  [<ffffffff8116c4aa>] ? alloc_fd+0xfa/0x140
[   28.313737]  [<ffffffff811512c5>] do_sys_open+0x65/0x130
[   28.313737]  [<ffffffff811513d0>] sys_open+0x20/0x30
[   28.313737]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   28.313737] Code: c0 4d 89 ac 24 18 c0 00 00 e8 e2 d5 2b 00 31 c0 4c 89 a3 98 00 00 00 48 c7 c7 11 43 c9 81 e8 cd d5 2b 00 49 8b 84 24 18 c0 00 00 <83> 38 00 0f 84 d9 00 00 00 8b 50 04 8d 4a 01 85 d2 89 48 04 75 
[   28.313737] RIP  [<ffffffff817d0a22>] hiddev_open+0x152/0x2e0
[   28.313737]  RSP <ffff88013786bc38>
[   28.313737] CR2: 0000000000000000
[   28.354413] ---[ end trace aac45f6a6d58c1a5 ]---
[   33.972287] idr_remove called for id=0 which is not allocated.
[   33.972302] Pid: 3228, comm: X Tainted: G      D     2.6.36-rc4-00167-g48e80ac #17
[   33.972313] Call Trace:
[   33.972324]  [<ffffffff814acbae>] idr_remove+0x7e/0x1f0
[   33.972334]  [<ffffffff8157d88f>] drm_mode_object_put+0x3f/0x60
[   33.972343]  [<ffffffff8157db3a>] drm_mode_destroy+0x1a/0x30
[   33.972352]  [<ffffffff815b8f5e>] nouveau_connector_get_modes+0x3e/0x3a0
[   33.972362]  [<ffffffff815b9e7a>] ? nouveau_connector_detect_lvds+0xea/0x2d0
[   33.972375]  [<ffffffff8156cccb>] drm_helper_probe_single_connector_modes+0xdb/0x380
[   33.972385]  [<ffffffff81580aba>] drm_mode_getconnector+0x33a/0x360
[   33.972394]  [<ffffffff81571d1b>] drm_ioctl+0x40b/0x4b0
[   33.972403]  [<ffffffff81124b78>] ? handle_mm_fault+0x198/0xbd0
[   33.972411]  [<ffffffff81580780>] ? drm_mode_getconnector+0x0/0x360
[   33.972422]  [<ffffffff8106552b>] ? do_page_fault+0x19b/0x3e0
[   33.972430]  [<ffffffff81162f8f>] do_vfs_ioctl+0x9f/0x540
[   33.972438]  [<ffffffff8116347f>] sys_ioctl+0x4f/0x80
[   33.972445]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   34.180097] idr_remove called for id=0 which is not allocated.
[   34.180113] Pid: 3228, comm: X Tainted: G      D     2.6.36-rc4-00167-g48e80ac #17
[   34.180124] Call Trace:
[   34.180134]  [<ffffffff814acbae>] idr_remove+0x7e/0x1f0
[   34.180145]  [<ffffffff8157d88f>] drm_mode_object_put+0x3f/0x60
[   34.180153]  [<ffffffff8157db3a>] drm_mode_destroy+0x1a/0x30
[   34.180164]  [<ffffffff815b8f5e>] nouveau_connector_get_modes+0x3e/0x3a0
[   34.180174]  [<ffffffff815b9e7a>] ? nouveau_connector_detect_lvds+0xea/0x2d0
[   34.180186]  [<ffffffff8156cccb>] drm_helper_probe_single_connector_modes+0xdb/0x380
[   34.180199]  [<ffffffff81107571>] ? find_get_page+0x71/0xb0
[   34.180208]  [<ffffffff81580aba>] drm_mode_getconnector+0x33a/0x360
[   34.180217]  [<ffffffff81571d1b>] drm_ioctl+0x40b/0x4b0
[   34.180225]  [<ffffffff81124b78>] ? handle_mm_fault+0x198/0xbd0
[   34.180234]  [<ffffffff81580780>] ? drm_mode_getconnector+0x0/0x360
[   34.180245]  [<ffffffff8106552b>] ? do_page_fault+0x19b/0x3e0
[   34.180254]  [<ffffffff81162f8f>] do_vfs_ioctl+0x9f/0x540
[   34.180262]  [<ffffffff8116347f>] sys_ioctl+0x4f/0x80
[   34.180272]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   34.586426] [drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[   34.593782] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
[   39.760831] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   44.726868] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   44.780290] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   44.780891] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   49.018561] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   49.853654] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   49.906794] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   49.907422] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   50.442829] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   54.487140] wlan0: authenticate with 00:0f:66:ea:00:d0 (try 1)
[   54.489616] wlan0: authenticated
[   54.490237] wlan0: associate with 00:0f:66:ea:00:d0 (try 1)
[   54.493543] wlan0: RX AssocResp from 00:0f:66:ea:00:d0 (capab=0x431 status=0 aid=2)
[   54.494166] wlan0: associated
[   54.522882] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   64.519670] netconsole: local port 6665
[   64.520327] netconsole: local IP 192.168.19.67
[   64.521445] netconsole: interface 'wlan0'
[   64.522572] netconsole: remote port 514
[   64.523677] netconsole: remote IP 192.168.19.2
[   64.524757] netconsole: remote ethernet address 00:23:54:94:80:7c
[   64.525853] netconsole: wlan0 doesn't support polling, aborting.
[   64.923383] wlan0: no IPv6 routers present


--------------080700030705030700040101
Content-Type: text/plain;
 name="hiddev.od"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hiddev.od"


usbhid.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <hid_start_in>:
       0:	55                   	push   %rbp
       1:	48 89 e5             	mov    %rsp,%rbp
       4:	48 83 ec 20          	sub    $0x20,%rsp
       8:	48 89 1c 24          	mov    %rbx,(%rsp)
       c:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
      11:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
      16:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
      1b:	e8 00 00 00 00       	callq  20 <hid_start_in+0x20>
      20:	48 8b 9f 00 1c 00 00 	mov    0x1c00(%rdi),%rbx
      27:	49 89 fe             	mov    %rdi,%r14
      2a:	4c 8d a3 88 28 00 00 	lea    0x2888(%rbx),%r12
      31:	4c 89 e7             	mov    %r12,%rdi
      34:	e8 00 00 00 00       	callq  39 <hid_start_in+0x39>
      39:	49 89 c5             	mov    %rax,%r13
      3c:	41 8b 86 fc 1a 00 00 	mov    0x1afc(%r14),%eax
      43:	85 c0                	test   %eax,%eax
      45:	7e 1f                	jle    66 <hid_start_in+0x66>
      47:	48 8b 83 90 28 00 00 	mov    0x2890(%rbx),%rax
      4e:	84 c0                	test   %al,%al
      50:	78 14                	js     66 <hid_start_in+0x66>
      52:	f6 c4 02             	test   $0x2,%ah
      55:	75 0f                	jne    66 <hid_start_in+0x66>
      57:	f0 0f ba ab 90 28 00 	lock btsl $0x3,0x2890(%rbx)
      5e:	00 03 
      60:	19 c0                	sbb    %eax,%eax
      62:	85 c0                	test   %eax,%eax
      64:	74 2a                	je     90 <hid_start_in+0x90>
      66:	45 31 f6             	xor    %r14d,%r14d
      69:	4c 89 ee             	mov    %r13,%rsi
      6c:	4c 89 e7             	mov    %r12,%rdi
      6f:	e8 00 00 00 00       	callq  74 <hid_start_in+0x74>
      74:	44 89 f0             	mov    %r14d,%eax
      77:	48 8b 1c 24          	mov    (%rsp),%rbx
      7b:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
      80:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
      85:	4c 8b 74 24 18       	mov    0x18(%rsp),%r14
      8a:	c9                   	leaveq 
      8b:	c3                   	retq   
      8c:	0f 1f 40 00          	nopl   0x0(%rax)
      90:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
      94:	be 20 00 00 00       	mov    $0x20,%esi
      99:	e8 00 00 00 00       	callq  9e <hid_start_in+0x9e>
      9e:	41 89 c6             	mov    %eax,%r14d
      a1:	85 c0                	test   %eax,%eax
      a3:	74 c4                	je     69 <hid_start_in+0x69>
      a5:	f0 80 a3 90 28 00 00 	lock andb $0xf7,0x2890(%rbx)
      ac:	f7 
      ad:	eb ba                	jmp    69 <hid_start_in+0x69>
      af:	90                   	nop

00000000000000b0 <hid_io_error>:
      b0:	55                   	push   %rbp
      b1:	48 89 e5             	mov    %rsp,%rbp
      b4:	48 83 ec 20          	sub    $0x20,%rsp
      b8:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
      bc:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
      c0:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
      c4:	e8 00 00 00 00       	callq  c9 <hid_io_error+0x19>
      c9:	4c 8b af 00 1c 00 00 	mov    0x1c00(%rdi),%r13
      d0:	49 8d 9d 88 28 00 00 	lea    0x2888(%r13),%rbx
      d7:	48 89 df             	mov    %rbx,%rdi
      da:	e8 00 00 00 00       	callq  df <hid_io_error+0x2f>
      df:	41 80 bd 90 28 00 00 	cmpb   $0x0,0x2890(%r13)
      e6:	00 
      e7:	49 89 c4             	mov    %rax,%r12
      ea:	78 6a                	js     156 <hid_io_error+0xa6>
      ec:	49 8b 85 d0 28 00 00 	mov    0x28d0(%r13),%rax
      f3:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # fa <hid_io_error+0x4a>
      fa:	48 8d 88 96 00 00 00 	lea    0x96(%rax),%rcx
     101:	48 39 d1             	cmp    %rdx,%rcx
     104:	0f 88 86 00 00 00    	js     190 <hid_io_error+0xe0>
     10a:	41 8b 95 d8 28 00 00 	mov    0x28d8(%r13),%edx
     111:	85 d2                	test   %edx,%edx
     113:	0f 84 82 00 00 00    	je     19b <hid_io_error+0xeb>
     119:	83 fa 63             	cmp    $0x63,%edx
     11c:	77 09                	ja     127 <hid_io_error+0x77>
     11e:	01 d2                	add    %edx,%edx
     120:	41 89 95 d8 28 00 00 	mov    %edx,0x28d8(%r13)
     127:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 12e <hid_io_error+0x7e>
     12e:	48 39 d0             	cmp    %rdx,%rax
     131:	78 3d                	js     170 <hid_io_error+0xc0>
     133:	41 8b bd d8 28 00 00 	mov    0x28d8(%r13),%edi
     13a:	e8 00 00 00 00       	callq  13f <hid_io_error+0x8f>
     13f:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 146 <hid_io_error+0x96>
     146:	49 8d bd 98 28 00 00 	lea    0x2898(%r13),%rdi
     14d:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
     151:	e8 00 00 00 00       	callq  156 <hid_io_error+0xa6>
     156:	4c 89 e6             	mov    %r12,%rsi
     159:	48 89 df             	mov    %rbx,%rdi
     15c:	e8 00 00 00 00       	callq  161 <hid_io_error+0xb1>
     161:	48 8b 5d e8          	mov    -0x18(%rbp),%rbx
     165:	4c 8b 65 f0          	mov    -0x10(%rbp),%r12
     169:	4c 8b 6d f8          	mov    -0x8(%rbp),%r13
     16d:	c9                   	leaveq 
     16e:	c3                   	retq   
     16f:	90                   	nop
     170:	f0 41 0f ba ad 90 28 	lock btsl $0x4,0x2890(%r13)
     177:	00 00 04 
     17a:	19 c0                	sbb    %eax,%eax
     17c:	85 c0                	test   %eax,%eax
     17e:	75 b3                	jne    133 <hid_io_error+0x83>
     180:	49 8d bd e0 28 00 00 	lea    0x28e0(%r13),%rdi
     187:	e8 00 00 00 00       	callq  18c <hid_io_error+0xdc>
     18c:	eb c8                	jmp    156 <hid_io_error+0xa6>
     18e:	66 90                	xchg   %ax,%ax
     190:	41 c7 85 d8 28 00 00 	movl   $0x0,0x28d8(%r13)
     197:	00 00 00 00 
     19b:	41 c7 85 d8 28 00 00 	movl   $0xd,0x28d8(%r13)
     1a2:	0d 00 00 00 
     1a6:	bf e8 03 00 00       	mov    $0x3e8,%edi
     1ab:	e8 00 00 00 00       	callq  1b0 <hid_io_error+0x100>
     1b0:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 1b7 <hid_io_error+0x107>
     1b7:	48 01 d0             	add    %rdx,%rax
     1ba:	49 89 85 d0 28 00 00 	mov    %rax,0x28d0(%r13)
     1c1:	e9 61 ff ff ff       	jmpq   127 <hid_io_error+0x77>
     1c6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
     1cd:	00 00 00 

00000000000001d0 <hid_submit_out>:
     1d0:	55                   	push   %rbp
     1d1:	48 89 e5             	mov    %rsp,%rbp
     1d4:	41 54                	push   %r12
     1d6:	53                   	push   %rbx
     1d7:	e8 00 00 00 00       	callq  1dc <hid_submit_out+0xc>
     1dc:	48 8b 9f 00 1c 00 00 	mov    0x1c00(%rdi),%rbx
     1e3:	0f b6 83 69 28 00 00 	movzbl 0x2869(%rbx),%eax
     1ea:	48 c1 e0 04          	shl    $0x4,%rax
     1ee:	f6 83 91 28 00 00 02 	testb  $0x2,0x2891(%rbx)
     1f5:	48 8d 84 18 60 18 00 	lea    0x1860(%rax,%rbx,1),%rax
     1fc:	00 
     1fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
     201:	4c 8b 60 10          	mov    0x10(%rax),%r12
     205:	0f 85 9d 00 00 00    	jne    2a8 <hid_submit_out+0xd8>
     20b:	8b 82 1c 02 00 00    	mov    0x21c(%rdx),%eax
     211:	48 8b 8b 60 18 00 00 	mov    0x1860(%rbx),%rcx
     218:	31 f6                	xor    %esi,%esi
     21a:	83 7a 10 00          	cmpl   $0x0,0x10(%rdx)
     21e:	40 0f 95 c6          	setne  %sil
     222:	ff c8                	dec    %eax
     224:	c1 e8 03             	shr    $0x3,%eax
     227:	8d 44 06 01          	lea    0x1(%rsi,%rax,1),%eax
     22b:	4c 89 e6             	mov    %r12,%rsi
     22e:	89 81 84 00 00 00    	mov    %eax,0x84(%rcx)
     234:	48 8b 97 88 18 00 00 	mov    0x1888(%rdi),%rdx
     23b:	48 8b 83 60 18 00 00 	mov    0x1860(%rbx),%rax
     242:	48 8b 12             	mov    (%rdx),%rdx
     245:	48 81 ea 88 00 00 00 	sub    $0x88,%rdx
     24c:	48 89 50 48          	mov    %rdx,0x48(%rax)
     250:	48 8b bb 70 28 00 00 	mov    0x2870(%rbx),%rdi
     257:	48 8b 83 60 18 00 00 	mov    0x1860(%rbx),%rax
     25e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
     264:	e8 00 00 00 00       	callq  269 <hid_submit_out+0x99>
     269:	4c 89 e7             	mov    %r12,%rdi
     26c:	e8 00 00 00 00       	callq  271 <hid_submit_out+0xa1>
     271:	8b 15 00 00 00 00    	mov    0x0(%rip),%edx        # 277 <hid_submit_out+0xa7>
     277:	85 d2                	test   %edx,%edx
     279:	75 61                	jne    2dc <hid_submit_out+0x10c>
     27b:	48 8b bb 60 18 00 00 	mov    0x1860(%rbx),%rdi
     282:	be 20 00 00 00       	mov    $0x20,%esi
     287:	e8 00 00 00 00       	callq  28c <hid_submit_out+0xbc>
     28c:	85 c0                	test   %eax,%eax
     28e:	75 32                	jne    2c2 <hid_submit_out+0xf2>
     290:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 297 <hid_submit_out+0xc7>
     297:	48 89 83 80 28 00 00 	mov    %rax,0x2880(%rbx)
     29e:	31 c0                	xor    %eax,%eax
     2a0:	5b                   	pop    %rbx
     2a1:	41 5c                	pop    %r12
     2a3:	c9                   	leaveq 
     2a4:	c3                   	retq   
     2a5:	0f 1f 00             	nopl   (%rax)
     2a8:	48 8d b3 00 29 00 00 	lea    0x2900(%rbx),%rsi
     2af:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 2b6 <hid_submit_out+0xe6>
     2b6:	e8 00 00 00 00       	callq  2bb <hid_submit_out+0xeb>
     2bb:	31 c0                	xor    %eax,%eax
     2bd:	5b                   	pop    %rbx
     2be:	41 5c                	pop    %r12
     2c0:	c9                   	leaveq 
     2c1:	c3                   	retq   
     2c2:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     2c9:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     2d0:	31 c0                	xor    %eax,%eax
     2d2:	e8 00 00 00 00       	callq  2d7 <hid_submit_out+0x107>
     2d7:	83 c8 ff             	or     $0xffffffffffffffff,%eax
     2da:	eb e1                	jmp    2bd <hid_submit_out+0xed>
     2dc:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     2e3:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     2ea:	31 c0                	xor    %eax,%eax
     2ec:	e8 00 00 00 00       	callq  2f1 <hid_submit_out+0x121>
     2f1:	eb 88                	jmp    27b <hid_submit_out+0xab>
     2f3:	66 66 66 66 2e 0f 1f 	nopw   %cs:0x0(%rax,%rax,1)
     2fa:	84 00 00 00 00 00 

0000000000000300 <hid_submit_ctrl>:
     300:	55                   	push   %rbp
     301:	48 89 e5             	mov    %rsp,%rbp
     304:	48 83 ec 40          	sub    $0x40,%rsp
     308:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
     30c:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
     310:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
     314:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
     318:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
     31c:	e8 00 00 00 00       	callq  321 <hid_submit_ctrl+0x21>
     321:	48 8b 9f 00 1c 00 00 	mov    0x1c00(%rdi),%rbx
     328:	49 89 fc             	mov    %rdi,%r12
     32b:	0f b6 83 41 18 00 00 	movzbl 0x1841(%rbx),%eax
     332:	f6 83 91 28 00 00 02 	testb  $0x2,0x2891(%rbx)
     339:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
     33d:	48 8d 04 c3          	lea    (%rbx,%rax,8),%rax
     341:	4c 8b 68 48          	mov    0x48(%rax),%r13
     345:	48 8b 48 50          	mov    0x50(%rax),%rcx
     349:	44 0f b6 70 40       	movzbl 0x40(%rax),%r14d
     34e:	0f 85 4c 01 00 00    	jne    4a0 <hid_submit_ctrl+0x1a0>
     354:	45 31 ff             	xor    %r15d,%r15d
     357:	41 8b 85 1c 02 00 00 	mov    0x21c(%r13),%eax
     35e:	41 83 7d 10 00       	cmpl   $0x0,0x10(%r13)
     363:	41 0f 95 c7          	setne  %r15b
     367:	ff c8                	dec    %eax
     369:	c1 e8 03             	shr    $0x3,%eax
     36c:	45 84 f6             	test   %r14b,%r14b
     36f:	45 8d 7c 07 01       	lea    0x1(%r15,%rax,1),%r15d
     374:	0f 84 46 01 00 00    	je     4c0 <hid_submit_ctrl+0x1c0>
     37a:	48 8b 53 30          	mov    0x30(%rbx),%rdx
     37e:	48 8b 87 88 18 00 00 	mov    0x1888(%rdi),%rax
     385:	48 8b 00             	mov    (%rax),%rax
     388:	8b 80 78 ff ff ff    	mov    -0x88(%rax),%eax
     38e:	c1 e0 08             	shl    $0x8,%eax
     391:	0d 80 00 00 80       	or     $0x80000080,%eax
     396:	89 42 58             	mov    %eax,0x58(%rdx)
     399:	48 8b 73 30          	mov    0x30(%rbx),%rsi
     39d:	48 8b 97 88 18 00 00 	mov    0x1888(%rdi),%rdx
     3a4:	8b 46 58             	mov    0x58(%rsi),%eax
     3a7:	48 8b 12             	mov    (%rdx),%rdx
     3aa:	84 c0                	test   %al,%al
     3ac:	0f 89 f4 01 00 00    	jns    5a6 <hid_submit_ctrl+0x2a6>
     3b2:	c1 f8 0f             	sar    $0xf,%eax
     3b5:	83 e0 0f             	and    $0xf,%eax
     3b8:	48 8b 84 c2 58 02 00 	mov    0x258(%rdx,%rax,8),%rax
     3bf:	00 
     3c0:	48 85 c0             	test   %rax,%rax
     3c3:	0f 84 77 01 00 00    	je     540 <hid_submit_ctrl+0x240>
     3c9:	0f b7 48 04          	movzwl 0x4(%rax),%ecx
     3cd:	85 c9                	test   %ecx,%ecx
     3cf:	0f 84 6b 01 00 00    	je     540 <hid_submit_ctrl+0x240>
     3d5:	42 8d 54 39 ff       	lea    -0x1(%rcx,%r15,1),%edx
     3da:	89 d0                	mov    %edx,%eax
     3dc:	c1 fa 1f             	sar    $0x1f,%edx
     3df:	f7 f9                	idiv   %ecx
     3e1:	8b 53 14             	mov    0x14(%rbx),%edx
     3e4:	0f af c1             	imul   %ecx,%eax
     3e7:	39 d0                	cmp    %edx,%eax
     3e9:	0f 47 c2             	cmova  %edx,%eax
     3ec:	89 86 84 00 00 00    	mov    %eax,0x84(%rsi)
     3f2:	41 83 ce 21          	or     $0x21,%r14d
     3f6:	48 8b 43 30          	mov    0x30(%rbx),%rax
     3fa:	49 8b 94 24 88 18 00 	mov    0x1888(%r12),%rdx
     401:	00 
     402:	48 8b 12             	mov    (%rdx),%rdx
     405:	48 81 ea 88 00 00 00 	sub    $0x88,%rdx
     40c:	48 89 50 48          	mov    %rdx,0x48(%rax)
     410:	ba 01 00 00 00       	mov    $0x1,%edx
     415:	48 8b 43 38          	mov    0x38(%rbx),%rax
     419:	44 88 30             	mov    %r14b,(%rax)
     41c:	48 8b 43 38          	mov    0x38(%rbx),%rax
     420:	88 50 01             	mov    %dl,0x1(%rax)
     423:	48 8b 53 38          	mov    0x38(%rbx),%rdx
     427:	41 8b 45 14          	mov    0x14(%r13),%eax
     42b:	ff c0                	inc    %eax
     42d:	c1 e0 08             	shl    $0x8,%eax
     430:	66 41 0b 45 10       	or     0x10(%r13),%ax
     435:	66 89 42 02          	mov    %ax,0x2(%rdx)
     439:	48 8b 43 38          	mov    0x38(%rbx),%rax
     43d:	8b 53 10             	mov    0x10(%rbx),%edx
     440:	66 89 50 04          	mov    %dx,0x4(%rax)
     444:	48 8b 43 38          	mov    0x38(%rbx),%rax
     448:	66 44 89 78 06       	mov    %r15w,0x6(%rax)
     44d:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 453 <hid_submit_ctrl+0x153>
     453:	85 c9                	test   %ecx,%ecx
     455:	0f 85 09 01 00 00    	jne    564 <hid_submit_ctrl+0x264>
     45b:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
     45f:	be 20 00 00 00       	mov    $0x20,%esi
     464:	e8 00 00 00 00       	callq  469 <hid_submit_ctrl+0x169>
     469:	85 c0                	test   %eax,%eax
     46b:	0f 85 d6 00 00 00    	jne    547 <hid_submit_ctrl+0x247>
     471:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 478 <hid_submit_ctrl+0x178>
     478:	48 89 83 58 18 00 00 	mov    %rax,0x1858(%rbx)
     47f:	31 c0                	xor    %eax,%eax
     481:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
     485:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
     489:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
     48d:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
     491:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
     495:	c9                   	leaveq 
     496:	c3                   	retq   
     497:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     49e:	00 00 
     4a0:	48 8d b3 00 29 00 00 	lea    0x2900(%rbx),%rsi
     4a7:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 4ae <hid_submit_ctrl+0x1ae>
     4ae:	e8 00 00 00 00       	callq  4b3 <hid_submit_ctrl+0x1b3>
     4b3:	31 c0                	xor    %eax,%eax
     4b5:	eb ca                	jmp    481 <hid_submit_ctrl+0x181>
     4b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     4be:	00 00 
     4c0:	48 8b 87 88 18 00 00 	mov    0x1888(%rdi),%rax
     4c7:	48 8b 53 30          	mov    0x30(%rbx),%rdx
     4cb:	48 8b 00             	mov    (%rax),%rax
     4ce:	48 89 ce             	mov    %rcx,%rsi
     4d1:	8b 80 78 ff ff ff    	mov    -0x88(%rax),%eax
     4d7:	c1 e0 08             	shl    $0x8,%eax
     4da:	0d 00 00 00 80       	or     $0x80000000,%eax
     4df:	89 42 58             	mov    %eax,0x58(%rdx)
     4e2:	49 63 d7             	movslq %r15d,%rdx
     4e5:	48 8b 43 30          	mov    0x30(%rbx),%rax
     4e9:	44 89 b8 84 00 00 00 	mov    %r15d,0x84(%rax)
     4f0:	48 8b bb 48 18 00 00 	mov    0x1848(%rbx),%rdi
     4f7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
     4fb:	e8 00 00 00 00       	callq  500 <hid_submit_ctrl+0x200>
     500:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
     504:	48 89 cf             	mov    %rcx,%rdi
     507:	e8 00 00 00 00       	callq  50c <hid_submit_ctrl+0x20c>
     50c:	48 8b 43 30          	mov    0x30(%rbx),%rax
     510:	49 8b 94 24 88 18 00 	mov    0x1888(%r12),%rdx
     517:	00 
     518:	48 8b 12             	mov    (%rdx),%rdx
     51b:	48 81 ea 88 00 00 00 	sub    $0x88,%rdx
     522:	48 89 50 48          	mov    %rdx,0x48(%rax)
     526:	ba 09 00 00 00       	mov    $0x9,%edx
     52b:	48 8b 43 38          	mov    0x38(%rbx),%rax
     52f:	c6 00 21             	movb   $0x21,(%rax)
     532:	48 8b 43 38          	mov    0x38(%rbx),%rax
     536:	e9 e5 fe ff ff       	jmpq   420 <hid_submit_ctrl+0x120>
     53b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     540:	31 c0                	xor    %eax,%eax
     542:	e9 a5 fe ff ff       	jmpq   3ec <hid_submit_ctrl+0xec>
     547:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     54e:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     555:	31 c0                	xor    %eax,%eax
     557:	e8 00 00 00 00       	callq  55c <hid_submit_ctrl+0x25c>
     55c:	83 c8 ff             	or     $0xffffffffffffffff,%eax
     55f:	e9 1d ff ff ff       	jmpq   481 <hid_submit_ctrl+0x181>
     564:	48 8b 43 38          	mov    0x38(%rbx),%rax
     568:	48 c7 c1 00 00 00 00 	mov    $0x0,%rcx
     56f:	80 78 01 09          	cmpb   $0x9,0x1(%rax)
     573:	44 0f b7 48 06       	movzwl 0x6(%rax),%r9d
     578:	44 0f b7 40 04       	movzwl 0x4(%rax),%r8d
     57d:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
     584:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     58b:	48 0f 44 d1          	cmove  %rcx,%rdx
     58f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     596:	0f b7 48 02          	movzwl 0x2(%rax),%ecx
     59a:	31 c0                	xor    %eax,%eax
     59c:	e8 00 00 00 00       	callq  5a1 <hid_submit_ctrl+0x2a1>
     5a1:	e9 b5 fe ff ff       	jmpq   45b <hid_submit_ctrl+0x15b>
     5a6:	be 1e 06 00 00       	mov    $0x61e,%esi
     5ab:	89 45 c0             	mov    %eax,-0x40(%rbp)
     5ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
     5b2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     5b9:	e8 00 00 00 00       	callq  5be <hid_submit_ctrl+0x2be>
     5be:	48 8b 73 30          	mov    0x30(%rbx),%rsi
     5c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
     5c6:	8b 45 c0             	mov    -0x40(%rbp),%eax
     5c9:	e9 e4 fd ff ff       	jmpq   3b2 <hid_submit_ctrl+0xb2>
     5ce:	66 90                	xchg   %ax,%ax

00000000000005d0 <usbhid_restart_queues>:
     5d0:	55                   	push   %rbp
     5d1:	48 89 e5             	mov    %rsp,%rbp
     5d4:	53                   	push   %rbx
     5d5:	48 83 ec 08          	sub    $0x8,%rsp
     5d9:	e8 00 00 00 00       	callq  5de <usbhid_restart_queues+0xe>
     5de:	48 89 fb             	mov    %rdi,%rbx
     5e1:	48 83 bf 60 18 00 00 	cmpq   $0x0,0x1860(%rdi)
     5e8:	00 
     5e9:	74 21                	je     60c <usbhid_restart_queues+0x3c>
     5eb:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
     5ef:	48 83 c7 30          	add    $0x30,%rdi
     5f3:	e8 00 00 00 00       	callq  5f8 <usbhid_restart_queues+0x28>
     5f8:	48 85 c0             	test   %rax,%rax
     5fb:	74 0f                	je     60c <usbhid_restart_queues+0x3c>
     5fd:	0f b6 93 68 28 00 00 	movzbl 0x2868(%rbx),%edx
     604:	3a 93 69 28 00 00    	cmp    0x2869(%rbx),%dl
     60a:	75 6c                	jne    678 <usbhid_restart_queues+0xa8>
     60c:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
     610:	48 83 c7 30          	add    $0x30,%rdi
     614:	e8 00 00 00 00       	callq  619 <usbhid_restart_queues+0x49>
     619:	48 85 c0             	test   %rax,%rax
     61c:	0f 84 87 00 00 00    	je     6a9 <usbhid_restart_queues+0xd9>
     622:	0f b6 93 40 18 00 00 	movzbl 0x1840(%rbx),%edx
     629:	3a 93 41 18 00 00    	cmp    0x1841(%rbx),%dl
     62f:	75 0f                	jne    640 <usbhid_restart_queues+0x70>
     631:	48 83 c4 08          	add    $0x8,%rsp
     635:	5b                   	pop    %rbx
     636:	c9                   	leaveq 
     637:	c3                   	retq   
     638:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     63f:	00 
     640:	48 89 c7             	mov    %rax,%rdi
     643:	e8 b8 fc ff ff       	callq  300 <hid_submit_ctrl>
     648:	85 c0                	test   %eax,%eax
     64a:	74 e5                	je     631 <usbhid_restart_queues+0x61>
     64c:	f0 80 a3 90 28 00 00 	lock andb $0xfd,0x2890(%rbx)
     653:	fd 
     654:	31 c9                	xor    %ecx,%ecx
     656:	48 8d bb 20 29 00 00 	lea    0x2920(%rbx),%rdi
     65d:	ba 01 00 00 00       	mov    $0x1,%edx
     662:	be 03 00 00 00       	mov    $0x3,%esi
     667:	e8 00 00 00 00       	callq  66c <usbhid_restart_queues+0x9c>
     66c:	48 83 c4 08          	add    $0x8,%rsp
     670:	5b                   	pop    %rbx
     671:	c9                   	leaveq 
     672:	c3                   	retq   
     673:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     678:	48 89 c7             	mov    %rax,%rdi
     67b:	e8 50 fb ff ff       	callq  1d0 <hid_submit_out>
     680:	85 c0                	test   %eax,%eax
     682:	74 88                	je     60c <usbhid_restart_queues+0x3c>
     684:	f0 80 a3 90 28 00 00 	lock andb $0xfb,0x2890(%rbx)
     68b:	fb 
     68c:	31 c9                	xor    %ecx,%ecx
     68e:	48 8d bb 20 29 00 00 	lea    0x2920(%rbx),%rdi
     695:	ba 01 00 00 00       	mov    $0x1,%edx
     69a:	be 03 00 00 00       	mov    $0x3,%esi
     69f:	e8 00 00 00 00       	callq  6a4 <usbhid_restart_queues+0xd4>
     6a4:	e9 63 ff ff ff       	jmpq   60c <usbhid_restart_queues+0x3c>
     6a9:	be dc 00 00 00       	mov    $0xdc,%esi
     6ae:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     6b5:	e8 00 00 00 00       	callq  6ba <usbhid_restart_queues+0xea>
     6ba:	e9 72 ff ff ff       	jmpq   631 <usbhid_restart_queues+0x61>
     6bf:	90                   	nop

00000000000006c0 <hid_post_reset>:
     6c0:	55                   	push   %rbp
     6c1:	48 89 e5             	mov    %rsp,%rbp
     6c4:	48 83 ec 60          	sub    $0x60,%rsp
     6c8:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
     6cc:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
     6d0:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
     6d4:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
     6d8:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
     6dc:	e8 00 00 00 00       	callq  6e1 <hid_post_reset+0x21>
     6e1:	4c 8b 7f 30          	mov    0x30(%rdi),%r15
     6e5:	49 89 fe             	mov    %rdi,%r14
     6e8:	4d 8d af 78 ff ff ff 	lea    -0x88(%r15),%r13
     6ef:	48 8d 7f 30          	lea    0x30(%rdi),%rdi
     6f3:	e8 00 00 00 00       	callq  6f8 <hid_post_reset+0x38>
     6f8:	48 8b 98 00 1c 00 00 	mov    0x1c00(%rax),%rbx
     6ff:	49 89 c4             	mov    %rax,%r12
     702:	48 8d 83 88 28 00 00 	lea    0x2888(%rbx),%rax
     709:	48 89 c7             	mov    %rax,%rdi
     70c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
     710:	e8 00 00 00 00       	callq  715 <hid_post_reset+0x55>
     715:	f0 80 a3 90 28 00 00 	lock andb $0xef,0x2890(%rbx)
     71c:	ef 
     71d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
     721:	48 89 c7             	mov    %rax,%rdi
     724:	e8 00 00 00 00       	callq  729 <hid_post_reset+0x69>
     729:	41 8b b7 78 ff ff ff 	mov    -0x88(%r15),%esi
     730:	45 31 c0             	xor    %r8d,%r8d
     733:	49 8b 46 08          	mov    0x8(%r14),%rax
     737:	c1 e6 08             	shl    $0x8,%esi
     73a:	44 0f b6 48 02       	movzbl 0x2(%rax),%r9d
     73f:	81 ce 00 00 00 80    	or     $0x80000000,%esi
     745:	b9 21 00 00 00       	mov    $0x21,%ecx
     74a:	ba 0a 00 00 00       	mov    $0xa,%edx
     74f:	4c 89 ef             	mov    %r13,%rdi
     752:	c7 44 24 10 88 13 00 	movl   $0x1388,0x10(%rsp)
     759:	00 
     75a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
     761:	00 
     762:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
     769:	00 
     76a:	e8 00 00 00 00       	callq  76f <hid_post_reset+0xaf>
     76f:	4c 89 e7             	mov    %r12,%rdi
     772:	e8 89 f8 ff ff       	callq  0 <hid_start_in>
     777:	85 c0                	test   %eax,%eax
     779:	78 25                	js     7a0 <hid_post_reset+0xe0>
     77b:	48 89 df             	mov    %rbx,%rdi
     77e:	e8 4d fe ff ff       	callq  5d0 <usbhid_restart_queues>
     783:	31 c0                	xor    %eax,%eax
     785:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
     789:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
     78d:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
     791:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
     795:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
     799:	c9                   	leaveq 
     79a:	c3                   	retq   
     79b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     7a0:	4c 89 e7             	mov    %r12,%rdi
     7a3:	e8 08 f9 ff ff       	callq  b0 <hid_io_error>
     7a8:	eb d1                	jmp    77b <hid_post_reset+0xbb>
     7aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000007b0 <hid_reset_resume>:
     7b0:	55                   	push   %rbp
     7b1:	48 89 e5             	mov    %rsp,%rbp
     7b4:	41 54                	push   %r12
     7b6:	53                   	push   %rbx
     7b7:	e8 00 00 00 00       	callq  7bc <hid_reset_resume+0xc>
     7bc:	48 89 fb             	mov    %rdi,%rbx
     7bf:	48 8d 7f 30          	lea    0x30(%rdi),%rdi
     7c3:	e8 00 00 00 00       	callq  7c8 <hid_reset_resume+0x18>
     7c8:	49 89 c4             	mov    %rax,%r12
     7cb:	48 8b 80 00 1c 00 00 	mov    0x1c00(%rax),%rax
     7d2:	f0 80 a0 91 28 00 00 	lock andb $0xfd,0x2891(%rax)
     7d9:	fd 
     7da:	48 89 df             	mov    %rbx,%rdi
     7dd:	e8 de fe ff ff       	callq  6c0 <hid_post_reset>
     7e2:	89 c3                	mov    %eax,%ebx
     7e4:	85 c0                	test   %eax,%eax
     7e6:	78 23                	js     80b <hid_reset_resume+0x5b>
     7e8:	49 8b 84 24 b8 1a 00 	mov    0x1ab8(%r12),%rax
     7ef:	00 
     7f0:	48 85 c0             	test   %rax,%rax
     7f3:	74 16                	je     80b <hid_reset_resume+0x5b>
     7f5:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
     7fc:	48 85 c0             	test   %rax,%rax
     7ff:	74 0a                	je     80b <hid_reset_resume+0x5b>
     801:	4c 89 e7             	mov    %r12,%rdi
     804:	ff d0                	callq  *%rax
     806:	85 c0                	test   %eax,%eax
     808:	0f 48 d8             	cmovs  %eax,%ebx
     80b:	89 d8                	mov    %ebx,%eax
     80d:	5b                   	pop    %rbx
     80e:	41 5c                	pop    %r12
     810:	c9                   	leaveq 
     811:	c3                   	retq   
     812:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
     819:	1f 84 00 00 00 00 00 

0000000000000820 <hid_cease_io>:
     820:	55                   	push   %rbp
     821:	48 89 e5             	mov    %rsp,%rbp
     824:	53                   	push   %rbx
     825:	48 83 ec 08          	sub    $0x8,%rsp
     829:	e8 00 00 00 00       	callq  82e <hid_cease_io+0xe>
     82e:	48 89 fb             	mov    %rdi,%rbx
     831:	48 8d bf 98 28 00 00 	lea    0x2898(%rdi),%rdi
     838:	e8 00 00 00 00       	callq  83d <hid_cease_io+0x1d>
     83d:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
     841:	e8 00 00 00 00       	callq  846 <hid_cease_io+0x26>
     846:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
     84a:	e8 00 00 00 00       	callq  84f <hid_cease_io+0x2f>
     84f:	48 8b bb 60 18 00 00 	mov    0x1860(%rbx),%rdi
     856:	e8 00 00 00 00       	callq  85b <hid_cease_io+0x3b>
     85b:	48 83 c4 08          	add    $0x8,%rsp
     85f:	5b                   	pop    %rbx
     860:	c9                   	leaveq 
     861:	c3                   	retq   
     862:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
     869:	1f 84 00 00 00 00 00 

0000000000000870 <hid_pre_reset>:
     870:	55                   	push   %rbp
     871:	48 89 e5             	mov    %rsp,%rbp
     874:	48 83 ec 10          	sub    $0x10,%rsp
     878:	48 89 1c 24          	mov    %rbx,(%rsp)
     87c:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
     881:	e8 00 00 00 00       	callq  886 <hid_pre_reset+0x16>
     886:	48 83 c7 30          	add    $0x30,%rdi
     88a:	e8 00 00 00 00       	callq  88f <hid_pre_reset+0x1f>
     88f:	48 8b 98 00 1c 00 00 	mov    0x1c00(%rax),%rbx
     896:	4c 8d a3 88 28 00 00 	lea    0x2888(%rbx),%r12
     89d:	4c 89 e7             	mov    %r12,%rdi
     8a0:	e8 00 00 00 00       	callq  8a5 <hid_pre_reset+0x35>
     8a5:	f0 80 8b 90 28 00 00 	lock orb $0x10,0x2890(%rbx)
     8ac:	10 
     8ad:	4c 89 e7             	mov    %r12,%rdi
     8b0:	e8 00 00 00 00       	callq  8b5 <hid_pre_reset+0x45>
     8b5:	48 8d bb 00 29 00 00 	lea    0x2900(%rbx),%rdi
     8bc:	e8 00 00 00 00       	callq  8c1 <hid_pre_reset+0x51>
     8c1:	48 89 df             	mov    %rbx,%rdi
     8c4:	e8 57 ff ff ff       	callq  820 <hid_cease_io>
     8c9:	31 c0                	xor    %eax,%eax
     8cb:	48 8b 1c 24          	mov    (%rsp),%rbx
     8cf:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
     8d4:	c9                   	leaveq 
     8d5:	c3                   	retq   
     8d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
     8dd:	00 00 00 

00000000000008e0 <hid_resume>:
     8e0:	55                   	push   %rbp
     8e1:	48 89 e5             	mov    %rsp,%rbp
     8e4:	48 83 ec 20          	sub    $0x20,%rsp
     8e8:	48 89 1c 24          	mov    %rbx,(%rsp)
     8ec:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
     8f1:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
     8f6:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
     8fb:	e8 00 00 00 00       	callq  900 <hid_resume+0x20>
     900:	48 8d 5f 30          	lea    0x30(%rdi),%rbx
     904:	48 89 df             	mov    %rbx,%rdi
     907:	e8 00 00 00 00       	callq  90c <hid_resume+0x2c>
     90c:	4c 8b a0 00 1c 00 00 	mov    0x1c00(%rax),%r12
     913:	49 89 c5             	mov    %rax,%r13
     916:	41 f6 84 24 91 28 00 	testb  $0x1,0x2891(%r12)
     91d:	00 01 
     91f:	0f 84 87 00 00 00    	je     9ac <hid_resume+0xcc>
     925:	f0 41 80 a4 24 91 28 	lock andb $0xfd,0x2891(%r12)
     92c:	00 00 fd 
     92f:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 936 <hid_resume+0x56>
     936:	49 8b 44 24 08       	mov    0x8(%r12),%rax
     93b:	48 8b 40 30          	mov    0x30(%rax),%rax
     93f:	48 89 90 a8 04 00 00 	mov    %rdx,0x4a8(%rax)
     946:	49 8b 94 24 90 28 00 	mov    0x2890(%r12),%rdx
     94d:	00 
     94e:	48 89 d0             	mov    %rdx,%rax
     951:	48 c1 ea 06          	shr    $0x6,%rdx
     955:	48 c1 e8 04          	shr    $0x4,%rax
     959:	48 09 d0             	or     %rdx,%rax
     95c:	a8 01                	test   $0x1,%al
     95e:	75 68                	jne    9c8 <hid_resume+0xe8>
     960:	41 c7 84 24 d8 28 00 	movl   $0x0,0x28d8(%r12)
     967:	00 00 00 00 00 
     96c:	4c 89 ef             	mov    %r13,%rdi
     96f:	e8 8c f6 ff ff       	callq  0 <hid_start_in>
     974:	41 89 c6             	mov    %eax,%r14d
     977:	85 c0                	test   %eax,%eax
     979:	78 65                	js     9e0 <hid_resume+0x100>
     97b:	4c 89 e7             	mov    %r12,%rdi
     97e:	e8 4d fc ff ff       	callq  5d0 <usbhid_restart_queues>
     983:	49 8b 85 b8 1a 00 00 	mov    0x1ab8(%r13),%rax
     98a:	48 85 c0             	test   %rax,%rax
     98d:	74 14                	je     9a3 <hid_resume+0xc3>
     98f:	48 8b 40 78          	mov    0x78(%rax),%rax
     993:	48 85 c0             	test   %rax,%rax
     996:	74 0b                	je     9a3 <hid_resume+0xc3>
     998:	4c 89 ef             	mov    %r13,%rdi
     99b:	ff d0                	callq  *%rax
     99d:	85 c0                	test   %eax,%eax
     99f:	44 0f 48 f0          	cmovs  %eax,%r14d
     9a3:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 9aa <hid_resume+0xca>
     9aa:	75 46                	jne    9f2 <hid_resume+0x112>
     9ac:	31 c0                	xor    %eax,%eax
     9ae:	48 8b 1c 24          	mov    (%rsp),%rbx
     9b2:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
     9b7:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
     9bc:	4c 8b 74 24 18       	mov    0x18(%rsp),%r14
     9c1:	c9                   	leaveq 
     9c2:	c3                   	retq   
     9c3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     9c8:	49 8d bc 24 e0 28 00 	lea    0x28e0(%r12),%rdi
     9cf:	00 
     9d0:	e8 00 00 00 00       	callq  9d5 <hid_resume+0xf5>
     9d5:	eb 89                	jmp    960 <hid_resume+0x80>
     9d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     9de:	00 00 
     9e0:	4c 89 ef             	mov    %r13,%rdi
     9e3:	e8 c8 f6 ff ff       	callq  b0 <hid_io_error>
     9e8:	4c 89 e7             	mov    %r12,%rdi
     9eb:	e8 e0 fb ff ff       	callq  5d0 <usbhid_restart_queues>
     9f0:	eb b1                	jmp    9a3 <hid_resume+0xc3>
     9f2:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 9f9 <hid_resume+0x119>
     9f9:	74 b1                	je     9ac <hid_resume+0xcc>
     9fb:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # a02 <hid_resume+0x122>
     a02:	74 a8                	je     9ac <hid_resume+0xcc>
     a04:	44 89 f1             	mov    %r14d,%ecx
     a07:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
     a0e:	48 89 de             	mov    %rbx,%rsi
     a11:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     a18:	31 c0                	xor    %eax,%eax
     a1a:	e8 00 00 00 00       	callq  a1f <hid_resume+0x13f>
     a1f:	eb 8b                	jmp    9ac <hid_resume+0xcc>
     a21:	66 66 66 66 66 66 2e 	nopw   %cs:0x0(%rax,%rax,1)
     a28:	0f 1f 84 00 00 00 00 
     a2f:	00 

0000000000000a30 <hid_retry_timeout>:
     a30:	55                   	push   %rbp
     a31:	48 89 e5             	mov    %rsp,%rbp
     a34:	53                   	push   %rbx
     a35:	48 83 ec 08          	sub    $0x8,%rsp
     a39:	e8 00 00 00 00       	callq  a3e <hid_retry_timeout+0xe>
     a3e:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # a45 <hid_retry_timeout+0x15>
     a45:	48 89 fb             	mov    %rdi,%rbx
     a48:	48 8b 87 00 1c 00 00 	mov    0x1c00(%rdi),%rax
     a4f:	75 1b                	jne    a6c <hid_retry_timeout+0x3c>
     a51:	48 89 df             	mov    %rbx,%rdi
     a54:	e8 a7 f5 ff ff       	callq  0 <hid_start_in>
     a59:	85 c0                	test   %eax,%eax
     a5b:	74 08                	je     a65 <hid_retry_timeout+0x35>
     a5d:	48 89 df             	mov    %rbx,%rdi
     a60:	e8 4b f6 ff ff       	callq  b0 <hid_io_error>
     a65:	48 83 c4 08          	add    $0x8,%rsp
     a69:	5b                   	pop    %rbx
     a6a:	c9                   	leaveq 
     a6b:	c3                   	retq   
     a6c:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # a73 <hid_retry_timeout+0x43>
     a73:	74 dc                	je     a51 <hid_retry_timeout+0x21>
     a75:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # a7c <hid_retry_timeout+0x4c>
     a7c:	74 d3                	je     a51 <hid_retry_timeout+0x21>
     a7e:	48 8b 70 08          	mov    0x8(%rax),%rsi
     a82:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
     a89:	48 83 c6 30          	add    $0x30,%rsi
     a8d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     a94:	31 c0                	xor    %eax,%eax
     a96:	e8 00 00 00 00       	callq  a9b <hid_retry_timeout+0x6b>
     a9b:	eb b4                	jmp    a51 <hid_retry_timeout+0x21>
     a9d:	0f 1f 00             	nopl   (%rax)

0000000000000aa0 <hid_cancel_delayed_stuff>:
     aa0:	55                   	push   %rbp
     aa1:	48 89 e5             	mov    %rsp,%rbp
     aa4:	53                   	push   %rbx
     aa5:	48 83 ec 08          	sub    $0x8,%rsp
     aa9:	e8 00 00 00 00       	callq  aae <hid_cancel_delayed_stuff+0xe>
     aae:	48 89 fb             	mov    %rdi,%rbx
     ab1:	48 8d bf 98 28 00 00 	lea    0x2898(%rdi),%rdi
     ab8:	e8 00 00 00 00       	callq  abd <hid_cancel_delayed_stuff+0x1d>
     abd:	48 8d bb 00 29 00 00 	lea    0x2900(%rbx),%rdi
     ac4:	e8 00 00 00 00       	callq  ac9 <hid_cancel_delayed_stuff+0x29>
     ac9:	48 8d bb e0 28 00 00 	lea    0x28e0(%rbx),%rdi
     ad0:	e8 00 00 00 00       	callq  ad5 <hid_cancel_delayed_stuff+0x35>
     ad5:	48 83 c4 08          	add    $0x8,%rsp
     ad9:	5b                   	pop    %rbx
     ada:	c9                   	leaveq 
     adb:	c3                   	retq   
     adc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000ae0 <usbhid_disconnect>:
     ae0:	55                   	push   %rbp
     ae1:	48 89 e5             	mov    %rsp,%rbp
     ae4:	53                   	push   %rbx
     ae5:	48 83 ec 08          	sub    $0x8,%rsp
     ae9:	e8 00 00 00 00       	callq  aee <usbhid_disconnect+0xe>
     aee:	48 83 c7 30          	add    $0x30,%rdi
     af2:	e8 00 00 00 00       	callq  af7 <usbhid_disconnect+0x17>
     af7:	48 85 c0             	test   %rax,%rax
     afa:	74 1e                	je     b1a <usbhid_disconnect+0x3a>
     afc:	48 8b 98 00 1c 00 00 	mov    0x1c00(%rax),%rbx
     b03:	48 89 c7             	mov    %rax,%rdi
     b06:	e8 00 00 00 00       	callq  b0b <usbhid_disconnect+0x2b>
     b0b:	48 89 df             	mov    %rbx,%rdi
     b0e:	e8 00 00 00 00       	callq  b13 <usbhid_disconnect+0x33>
     b13:	48 83 c4 08          	add    $0x8,%rsp
     b17:	5b                   	pop    %rbx
     b18:	c9                   	leaveq 
     b19:	c3                   	retq   
     b1a:	be d0 04 00 00       	mov    $0x4d0,%esi
     b1f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     b26:	e8 00 00 00 00       	callq  b2b <usbhid_disconnect+0x4b>
     b2b:	eb e6                	jmp    b13 <usbhid_disconnect+0x33>
     b2d:	0f 1f 00             	nopl   (%rax)

0000000000000b30 <usbhid_parse>:
     b30:	55                   	push   %rbp
     b31:	48 89 e5             	mov    %rsp,%rbp
     b34:	41 57                	push   %r15
     b36:	41 56                	push   %r14
     b38:	41 55                	push   %r13
     b3a:	41 54                	push   %r12
     b3c:	53                   	push   %rbx
     b3d:	48 83 ec 58          	sub    $0x58,%rsp
     b41:	e8 00 00 00 00       	callq  b46 <usbhid_parse+0x16>
     b46:	48 89 7d b0          	mov    %rdi,-0x50(%rbp)
     b4a:	48 8b 87 88 18 00 00 	mov    0x1888(%rdi),%rax
     b51:	4c 8b 38             	mov    (%rax),%r15
     b54:	4c 8b 68 d8          	mov    -0x28(%rax),%r13
     b58:	49 8d 9f 78 ff ff ff 	lea    -0x88(%r15),%rbx
     b5f:	0f b7 b3 c2 02 00 00 	movzwl 0x2c2(%rbx),%esi
     b66:	0f b7 bb c0 02 00 00 	movzwl 0x2c0(%rbx),%edi
     b6d:	e8 00 00 00 00       	callq  b72 <usbhid_parse+0x42>
     b72:	89 45 ac             	mov    %eax,-0x54(%rbp)
     b75:	a8 04                	test   $0x4,%al
     b77:	0f 85 33 02 00 00    	jne    db0 <usbhid_parse+0x280>
     b7d:	41 80 7d 06 01       	cmpb   $0x1,0x6(%r13)
     b82:	0f 84 38 02 00 00    	je     dc0 <usbhid_parse+0x290>
     b88:	4c 8d 65 c8          	lea    -0x38(%rbp),%r12
     b8c:	41 8b 75 28          	mov    0x28(%r13),%esi
     b90:	49 8b 7d 20          	mov    0x20(%r13),%rdi
     b94:	4c 89 e1             	mov    %r12,%rcx
     b97:	ba 21 00 00 00       	mov    $0x21,%edx
     b9c:	e8 00 00 00 00       	callq  ba1 <usbhid_parse+0x71>
     ba1:	85 c0                	test   %eax,%eax
     ba3:	0f 85 87 01 00 00    	jne    d30 <usbhid_parse+0x200>
     ba9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
     bad:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
     bb1:	0f b7 42 02          	movzwl 0x2(%rdx),%eax
     bb5:	45 31 e4             	xor    %r12d,%r12d
     bb8:	89 41 30             	mov    %eax,0x30(%rcx)
     bbb:	0f b6 42 04          	movzbl 0x4(%rdx),%eax
     bbf:	89 41 38             	mov    %eax,0x38(%rcx)
     bc2:	0f b6 42 05          	movzbl 0x5(%rdx),%eax
     bc6:	84 c0                	test   %al,%al
     bc8:	0f 84 21 02 00 00    	je     def <usbhid_parse+0x2bf>
     bce:	0f b6 c0             	movzbl %al,%eax
     bd1:	ff c8                	dec    %eax
     bd3:	48 8d 4c 40 03       	lea    0x3(%rax,%rax,2),%rcx
     bd8:	31 c0                	xor    %eax,%eax
     bda:	eb 0d                	jmp    be9 <usbhid_parse+0xb9>
     bdc:	0f 1f 40 00          	nopl   0x0(%rax)
     be0:	48 83 c0 03          	add    $0x3,%rax
     be4:	48 39 c8             	cmp    %rcx,%rax
     be7:	74 16                	je     bff <usbhid_parse+0xcf>
     be9:	80 7c 02 06 22       	cmpb   $0x22,0x6(%rdx,%rax,1)
     bee:	75 f0                	jne    be0 <usbhid_parse+0xb0>
     bf0:	44 0f b7 64 02 07    	movzwl 0x7(%rdx,%rax,1),%r12d
     bf6:	48 83 c0 03          	add    $0x3,%rax
     bfa:	48 39 c8             	cmp    %rcx,%rax
     bfd:	75 ea                	jne    be9 <usbhid_parse+0xb9>
     bff:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
     c04:	3d ff 0f 00 00       	cmp    $0xfff,%eax
     c09:	0f 87 e0 01 00 00    	ja     def <usbhid_parse+0x2bf>
     c0f:	44 89 e7             	mov    %r12d,%edi
     c12:	be d0 00 00 00       	mov    $0xd0,%esi
     c17:	e8 00 00 00 00       	callq  c1c <usbhid_parse+0xec>
     c1c:	49 89 c6             	mov    %rax,%r14
     c1f:	48 85 c0             	test   %rax,%rax
     c22:	0f 84 da 01 00 00    	je     e02 <usbhid_parse+0x2d2>
     c28:	45 0f b6 4d 02       	movzbl 0x2(%r13),%r9d
     c2d:	41 8b b7 78 ff ff ff 	mov    -0x88(%r15),%esi
     c34:	45 31 c0             	xor    %r8d,%r8d
     c37:	b9 21 00 00 00       	mov    $0x21,%ecx
     c3c:	ba 0a 00 00 00       	mov    $0xa,%edx
     c41:	48 89 df             	mov    %rbx,%rdi
     c44:	c1 e6 08             	shl    $0x8,%esi
     c47:	c7 44 24 10 88 13 00 	movl   $0x1388,0x10(%rsp)
     c4e:	00 
     c4f:	81 ce 00 00 00 80    	or     $0x80000000,%esi
     c55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
     c5c:	00 
     c5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
     c64:	00 
     c65:	45 0f b7 fc          	movzwl %r12w,%r15d
     c69:	e8 00 00 00 00       	callq  c6e <usbhid_parse+0x13e>
     c6e:	45 0f b6 6d 02       	movzbl 0x2(%r13),%r13d
     c73:	49 63 d4             	movslq %r12d,%rdx
     c76:	45 0f b7 ed          	movzwl %r13w,%r13d
     c7a:	31 f6                	xor    %esi,%esi
     c7c:	4c 89 f7             	mov    %r14,%rdi
     c7f:	e8 00 00 00 00       	callq  c84 <usbhid_parse+0x154>
     c84:	44 89 6d bc          	mov    %r13d,-0x44(%rbp)
     c88:	41 bd 04 00 00 00    	mov    $0x4,%r13d
     c8e:	66 90                	xchg   %ax,%ax
     c90:	8b 33                	mov    (%rbx),%esi
     c92:	ba 06 00 00 00       	mov    $0x6,%edx
     c97:	c1 e6 08             	shl    $0x8,%esi
     c9a:	c7 44 24 10 88 13 00 	movl   $0x1388,0x10(%rsp)
     ca1:	00 
     ca2:	81 ce 80 00 00 80    	or     $0x80000080,%esi
     ca8:	44 89 7c 24 08       	mov    %r15d,0x8(%rsp)
     cad:	4c 89 34 24          	mov    %r14,(%rsp)
     cb1:	44 8b 4d bc          	mov    -0x44(%rbp),%r9d
     cb5:	41 b8 00 22 00 00    	mov    $0x2200,%r8d
     cbb:	b9 81 00 00 00       	mov    $0x81,%ecx
     cc0:	48 89 df             	mov    %rbx,%rdi
     cc3:	e8 00 00 00 00       	callq  cc8 <usbhid_parse+0x198>
     cc8:	41 ff cd             	dec    %r13d
     ccb:	89 c2                	mov    %eax,%edx
     ccd:	74 05                	je     cd4 <usbhid_parse+0x1a4>
     ccf:	41 39 c4             	cmp    %eax,%r12d
     cd2:	7f bc                	jg     c90 <usbhid_parse+0x160>
     cd4:	85 d2                	test   %edx,%edx
     cd6:	0f 88 a4 00 00 00    	js     d80 <usbhid_parse+0x250>
     cdc:	44 89 e2             	mov    %r12d,%edx
     cdf:	4c 89 f6             	mov    %r14,%rsi
     ce2:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
     ce6:	e8 00 00 00 00       	callq  ceb <usbhid_parse+0x1bb>
     ceb:	4c 89 f7             	mov    %r14,%rdi
     cee:	89 45 a0             	mov    %eax,-0x60(%rbp)
     cf1:	e8 00 00 00 00       	callq  cf6 <usbhid_parse+0x1c6>
     cf6:	8b 55 a0             	mov    -0x60(%rbp),%edx
     cf9:	85 d2                	test   %edx,%edx
     cfb:	0f 84 df 00 00 00    	je     de0 <usbhid_parse+0x2b0>
     d01:	8b 1d 00 00 00 00    	mov    0x0(%rip),%ebx        # d07 <usbhid_parse+0x1d7>
     d07:	85 db                	test   %ebx,%ebx
     d09:	0f 84 8d 00 00 00    	je     d9c <usbhid_parse+0x26c>
     d0f:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     d16:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     d1d:	31 c0                	xor    %eax,%eax
     d1f:	e8 00 00 00 00       	callq  d24 <usbhid_parse+0x1f4>
     d24:	8b 55 a0             	mov    -0x60(%rbp),%edx
     d27:	eb 73                	jmp    d9c <usbhid_parse+0x26c>
     d29:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
     d30:	41 80 7d 04 00       	cmpb   $0x0,0x4(%r13)
     d35:	74 20                	je     d57 <usbhid_parse+0x227>
     d37:	49 8b 45 10          	mov    0x10(%r13),%rax
     d3b:	4c 89 e1             	mov    %r12,%rcx
     d3e:	8b 70 38             	mov    0x38(%rax),%esi
     d41:	48 8b 78 30          	mov    0x30(%rax),%rdi
     d45:	ba 21 00 00 00       	mov    $0x21,%edx
     d4a:	e8 00 00 00 00       	callq  d4f <usbhid_parse+0x21f>
     d4f:	85 c0                	test   %eax,%eax
     d51:	0f 84 52 fe ff ff    	je     ba9 <usbhid_parse+0x79>
     d57:	44 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9d        # d5e <usbhid_parse+0x22e>
     d5e:	45 85 c9             	test   %r9d,%r9d
     d61:	74 4d                	je     db0 <usbhid_parse+0x280>
     d63:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     d6a:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     d71:	31 c0                	xor    %eax,%eax
     d73:	e8 00 00 00 00       	callq  d78 <usbhid_parse+0x248>
     d78:	ba ed ff ff ff       	mov    $0xffffffed,%edx
     d7d:	eb 1d                	jmp    d9c <usbhid_parse+0x26c>
     d7f:	90                   	nop
     d80:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # d86 <usbhid_parse+0x256>
     d86:	85 f6                	test   %esi,%esi
     d88:	0f 85 b6 00 00 00    	jne    e44 <usbhid_parse+0x314>
     d8e:	89 55 a0             	mov    %edx,-0x60(%rbp)
     d91:	4c 89 f7             	mov    %r14,%rdi
     d94:	e8 00 00 00 00       	callq  d99 <usbhid_parse+0x269>
     d99:	8b 55 a0             	mov    -0x60(%rbp),%edx
     d9c:	48 83 c4 58          	add    $0x58,%rsp
     da0:	89 d0                	mov    %edx,%eax
     da2:	5b                   	pop    %rbx
     da3:	41 5c                	pop    %r12
     da5:	41 5d                	pop    %r13
     da7:	41 5e                	pop    %r14
     da9:	41 5f                	pop    %r15
     dab:	c9                   	leaveq 
     dac:	c3                   	retq   
     dad:	0f 1f 00             	nopl   (%rax)
     db0:	ba ed ff ff ff       	mov    $0xffffffed,%edx
     db5:	eb e5                	jmp    d9c <usbhid_parse+0x26c>
     db7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     dbe:	00 00 
     dc0:	41 0f b6 55 07       	movzbl 0x7(%r13),%edx
     dc5:	83 c8 08             	or     $0x8,%eax
     dc8:	ff ca                	dec    %edx
     dca:	80 fa 01             	cmp    $0x1,%dl
     dcd:	0f 47 45 ac          	cmova  -0x54(%rbp),%eax
     dd1:	89 45 ac             	mov    %eax,-0x54(%rbp)
     dd4:	e9 af fd ff ff       	jmpq   b88 <usbhid_parse+0x58>
     dd9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
     de0:	8b 4d ac             	mov    -0x54(%rbp),%ecx
     de3:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
     de7:	09 88 d0 1a 00 00    	or     %ecx,0x1ad0(%rax)
     ded:	eb ad                	jmp    d9c <usbhid_parse+0x26c>
     def:	44 8b 05 00 00 00 00 	mov    0x0(%rip),%r8d        # df6 <usbhid_parse+0x2c6>
     df6:	45 85 c0             	test   %r8d,%r8d
     df9:	75 18                	jne    e13 <usbhid_parse+0x2e3>
     dfb:	ba ea ff ff ff       	mov    $0xffffffea,%edx
     e00:	eb 9a                	jmp    d9c <usbhid_parse+0x26c>
     e02:	8b 3d 00 00 00 00    	mov    0x0(%rip),%edi        # e08 <usbhid_parse+0x2d8>
     e08:	85 ff                	test   %edi,%edi
     e0a:	75 21                	jne    e2d <usbhid_parse+0x2fd>
     e0c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
     e11:	eb 89                	jmp    d9c <usbhid_parse+0x26c>
     e13:	44 89 e2             	mov    %r12d,%edx
     e16:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     e1d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     e24:	31 c0                	xor    %eax,%eax
     e26:	e8 00 00 00 00       	callq  e2b <usbhid_parse+0x2fb>
     e2b:	eb ce                	jmp    dfb <usbhid_parse+0x2cb>
     e2d:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     e34:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     e3b:	31 c0                	xor    %eax,%eax
     e3d:	e8 00 00 00 00       	callq  e42 <usbhid_parse+0x312>
     e42:	eb c8                	jmp    e0c <usbhid_parse+0x2dc>
     e44:	89 55 a0             	mov    %edx,-0x60(%rbp)
     e47:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     e4e:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     e55:	31 c0                	xor    %eax,%eax
     e57:	e8 00 00 00 00       	callq  e5c <usbhid_parse+0x32c>
     e5c:	8b 55 a0             	mov    -0x60(%rbp),%edx
     e5f:	e9 2a ff ff ff       	jmpq   d8e <usbhid_parse+0x25e>
     e64:	66 66 66 2e 0f 1f 84 	nopw   %cs:0x0(%rax,%rax,1)
     e6b:	00 00 00 00 00 

0000000000000e70 <hid_irq_out>:
     e70:	55                   	push   %rbp
     e71:	48 89 e5             	mov    %rsp,%rbp
     e74:	48 83 ec 20          	sub    $0x20,%rsp
     e78:	48 89 1c 24          	mov    %rbx,(%rsp)
     e7c:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
     e81:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
     e86:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
     e8b:	e8 00 00 00 00       	callq  e90 <hid_irq_out+0x20>
     e90:	4c 8b b7 b0 00 00 00 	mov    0xb0(%rdi),%r14
     e97:	8b 57 60             	mov    0x60(%rdi),%edx
     e9a:	4d 8b ae 00 1c 00 00 	mov    0x1c00(%r14),%r13
     ea1:	83 fa ac             	cmp    $0xffffffffffffffac,%edx
     ea4:	74 35                	je     edb <hid_irq_out+0x6b>
     ea6:	0f 8e b4 00 00 00    	jle    f60 <hid_irq_out+0xf0>
     eac:	83 fa fe             	cmp    $0xfffffffffffffffe,%edx
     eaf:	74 2a                	je     edb <hid_irq_out+0x6b>
     eb1:	85 d2                	test   %edx,%edx
     eb3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     eb8:	74 21                	je     edb <hid_irq_out+0x6b>
     eba:	83 fa b9             	cmp    $0xffffffffffffffb9,%edx
     ebd:	0f 1f 00             	nopl   (%rax)
     ec0:	74 19                	je     edb <hid_irq_out+0x6b>
     ec2:	48 8b 7f 48          	mov    0x48(%rdi),%rdi
     ec6:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
     ecd:	48 81 c7 88 00 00 00 	add    $0x88,%rdi
     ed4:	31 c0                	xor    %eax,%eax
     ed6:	e8 00 00 00 00       	callq  edb <hid_irq_out+0x6b>
     edb:	49 8d 9d 88 28 00 00 	lea    0x2888(%r13),%rbx
     ee2:	48 89 df             	mov    %rbx,%rdi
     ee5:	e8 00 00 00 00       	callq  eea <hid_irq_out+0x7a>
     eea:	49 89 c4             	mov    %rax,%r12
     eed:	41 0f b6 85 69 28 00 	movzbl 0x2869(%r13),%eax
     ef4:	00 
     ef5:	ff c0                	inc    %eax
     ef7:	83 e0 3f             	and    $0x3f,%eax
     efa:	41 88 85 69 28 00 00 	mov    %al,0x2869(%r13)
     f01:	41 38 85 68 28 00 00 	cmp    %al,0x2868(%r13)
     f08:	0f 84 98 00 00 00    	je     fa6 <hid_irq_out+0x136>
     f0e:	4c 89 f7             	mov    %r14,%rdi
     f11:	e8 ba f2 ff ff       	callq  1d0 <hid_submit_out>
     f16:	85 c0                	test   %eax,%eax
     f18:	74 21                	je     f3b <hid_irq_out+0xcb>
     f1a:	f0 41 80 a5 90 28 00 	lock andb $0xfb,0x2890(%r13)
     f21:	00 fb 
     f23:	31 c9                	xor    %ecx,%ecx
     f25:	49 8d bd 20 29 00 00 	lea    0x2920(%r13),%rdi
     f2c:	ba 01 00 00 00       	mov    $0x1,%edx
     f31:	be 03 00 00 00       	mov    $0x3,%esi
     f36:	e8 00 00 00 00       	callq  f3b <hid_irq_out+0xcb>
     f3b:	4c 89 e6             	mov    %r12,%rsi
     f3e:	48 89 df             	mov    %rbx,%rdi
     f41:	e8 00 00 00 00       	callq  f46 <hid_irq_out+0xd6>
     f46:	48 8b 1c 24          	mov    (%rsp),%rbx
     f4a:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
     f4f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
     f54:	4c 8b 74 24 18       	mov    0x18(%rsp),%r14
     f59:	c9                   	leaveq 
     f5a:	c3                   	retq   
     f5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
     f60:	83 fa 94             	cmp    $0xffffffffffffff94,%edx
     f63:	74 13                	je     f78 <hid_irq_out+0x108>
     f65:	83 fa 98             	cmp    $0xffffffffffffff98,%edx
     f68:	0f 85 54 ff ff ff    	jne    ec2 <hid_irq_out+0x52>
     f6e:	66 90                	xchg   %ax,%ax
     f70:	e9 66 ff ff ff       	jmpq   edb <hid_irq_out+0x6b>
     f75:	0f 1f 00             	nopl   (%rax)
     f78:	49 8d 9d 88 28 00 00 	lea    0x2888(%r13),%rbx
     f7f:	48 89 df             	mov    %rbx,%rdi
     f82:	e8 00 00 00 00       	callq  f87 <hid_irq_out+0x117>
     f87:	49 89 c4             	mov    %rax,%r12
     f8a:	41 0f b6 85 68 28 00 	movzbl 0x2868(%r13),%eax
     f91:	00 
     f92:	41 88 85 69 28 00 00 	mov    %al,0x2869(%r13)
     f99:	41 38 85 68 28 00 00 	cmp    %al,0x2868(%r13)
     fa0:	0f 85 68 ff ff ff    	jne    f0e <hid_irq_out+0x9e>
     fa6:	f0 41 80 a5 90 28 00 	lock andb $0xfb,0x2890(%r13)
     fad:	00 fb 
     faf:	4c 89 e6             	mov    %r12,%rsi
     fb2:	48 89 df             	mov    %rbx,%rdi
     fb5:	e8 00 00 00 00       	callq  fba <hid_irq_out+0x14a>
     fba:	49 8d bd 20 29 00 00 	lea    0x2920(%r13),%rdi
     fc1:	31 c9                	xor    %ecx,%ecx
     fc3:	ba 01 00 00 00       	mov    $0x1,%edx
     fc8:	be 03 00 00 00       	mov    $0x3,%esi
     fcd:	e8 00 00 00 00       	callq  fd2 <hid_irq_out+0x162>
     fd2:	e9 6f ff ff ff       	jmpq   f46 <hid_irq_out+0xd6>
     fd7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     fde:	00 00 

0000000000000fe0 <hid_free_buffers>:
     fe0:	55                   	push   %rbp
     fe1:	48 89 e5             	mov    %rsp,%rbp
     fe4:	41 54                	push   %r12
     fe6:	53                   	push   %rbx
     fe7:	e8 00 00 00 00       	callq  fec <hid_free_buffers+0xc>
     fec:	48 8b 9e 00 1c 00 00 	mov    0x1c00(%rsi),%rbx
     ff3:	49 89 fc             	mov    %rdi,%r12
     ff6:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
     ffa:	48 8b 53 20          	mov    0x20(%rbx),%rdx
     ffe:	8b 73 14             	mov    0x14(%rbx),%esi
    1001:	e8 00 00 00 00       	callq  1006 <hid_free_buffers+0x26>
    1006:	48 8b 8b 78 28 00 00 	mov    0x2878(%rbx),%rcx
    100d:	48 8b 93 70 28 00 00 	mov    0x2870(%rbx),%rdx
    1014:	8b 73 14             	mov    0x14(%rbx),%esi
    1017:	4c 89 e7             	mov    %r12,%rdi
    101a:	e8 00 00 00 00       	callq  101f <hid_free_buffers+0x3f>
    101f:	48 8b 7b 38          	mov    0x38(%rbx),%rdi
    1023:	e8 00 00 00 00       	callq  1028 <hid_free_buffers+0x48>
    1028:	48 8b 8b 50 18 00 00 	mov    0x1850(%rbx),%rcx
    102f:	48 8b 93 48 18 00 00 	mov    0x1848(%rbx),%rdx
    1036:	8b 73 14             	mov    0x14(%rbx),%esi
    1039:	4c 89 e7             	mov    %r12,%rdi
    103c:	e8 00 00 00 00       	callq  1041 <hid_free_buffers+0x61>
    1041:	5b                   	pop    %rbx
    1042:	41 5c                	pop    %r12
    1044:	c9                   	leaveq 
    1045:	c3                   	retq   
    1046:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    104d:	00 00 00 

0000000000001050 <usbhid_stop>:
    1050:	55                   	push   %rbp
    1051:	48 89 e5             	mov    %rsp,%rbp
    1054:	41 55                	push   %r13
    1056:	41 54                	push   %r12
    1058:	53                   	push   %rbx
    1059:	48 83 ec 08          	sub    $0x8,%rsp
    105d:	e8 00 00 00 00       	callq  1062 <usbhid_stop+0x12>
    1062:	48 8b 9f 00 1c 00 00 	mov    0x1c00(%rdi),%rbx
    1069:	49 89 fc             	mov    %rdi,%r12
    106c:	48 85 db             	test   %rbx,%rbx
    106f:	0f 84 b7 00 00 00    	je     112c <usbhid_stop+0xdc>
    1075:	f0 80 a3 91 28 00 00 	lock andb $0xfe,0x2891(%rbx)
    107c:	fe 
    107d:	4c 8d ab 88 28 00 00 	lea    0x2888(%rbx),%r13
    1084:	4c 89 ef             	mov    %r13,%rdi
    1087:	e8 00 00 00 00       	callq  108c <usbhid_stop+0x3c>
    108c:	f0 80 8b 90 28 00 00 	lock orb $0x80,0x2890(%rbx)
    1093:	80 
    1094:	4c 89 ef             	mov    %r13,%rdi
    1097:	e8 00 00 00 00       	callq  109c <usbhid_stop+0x4c>
    109c:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
    10a0:	e8 00 00 00 00       	callq  10a5 <usbhid_stop+0x55>
    10a5:	48 8b bb 60 18 00 00 	mov    0x1860(%rbx),%rdi
    10ac:	e8 00 00 00 00       	callq  10b1 <usbhid_stop+0x61>
    10b1:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
    10b5:	e8 00 00 00 00       	callq  10ba <usbhid_stop+0x6a>
    10ba:	48 89 df             	mov    %rbx,%rdi
    10bd:	e8 de f9 ff ff       	callq  aa0 <hid_cancel_delayed_stuff>
    10c2:	41 c7 84 24 cc 1a 00 	movl   $0x0,0x1acc(%r12)
    10c9:	00 00 00 00 00 
    10ce:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
    10d2:	e8 00 00 00 00       	callq  10d7 <usbhid_stop+0x87>
    10d7:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
    10db:	e8 00 00 00 00       	callq  10e0 <usbhid_stop+0x90>
    10e0:	48 8b bb 60 18 00 00 	mov    0x1860(%rbx),%rdi
    10e7:	e8 00 00 00 00       	callq  10ec <usbhid_stop+0x9c>
    10ec:	48 c7 43 18 00 00 00 	movq   $0x0,0x18(%rbx)
    10f3:	00 
    10f4:	48 c7 43 30 00 00 00 	movq   $0x0,0x30(%rbx)
    10fb:	00 
    10fc:	48 c7 83 60 18 00 00 	movq   $0x0,0x1860(%rbx)
    1103:	00 00 00 00 
    1107:	4c 89 e6             	mov    %r12,%rsi
    110a:	49 8b 84 24 88 18 00 	mov    0x1888(%r12),%rax
    1111:	00 
    1112:	48 8b 38             	mov    (%rax),%rdi
    1115:	48 81 ef 88 00 00 00 	sub    $0x88,%rdi
    111c:	e8 bf fe ff ff       	callq  fe0 <hid_free_buffers>
    1121:	48 83 c4 08          	add    $0x8,%rsp
    1125:	5b                   	pop    %rbx
    1126:	41 5c                	pop    %r12
    1128:	41 5d                	pop    %r13
    112a:	c9                   	leaveq 
    112b:	c3                   	retq   
    112c:	be 33 04 00 00       	mov    $0x433,%esi
    1131:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1138:	e8 00 00 00 00       	callq  113d <usbhid_stop+0xed>
    113d:	eb e2                	jmp    1121 <usbhid_stop+0xd1>
    113f:	90                   	nop

0000000000001140 <hid_ctrl>:
    1140:	55                   	push   %rbp
    1141:	48 89 e5             	mov    %rsp,%rbp
    1144:	48 83 ec 30          	sub    $0x30,%rsp
    1148:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
    114c:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
    1150:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
    1154:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
    1158:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
    115c:	e8 00 00 00 00       	callq  1161 <hid_ctrl+0x21>
    1161:	4c 8b af b0 00 00 00 	mov    0xb0(%rdi),%r13
    1168:	44 8b 77 60          	mov    0x60(%rdi),%r14d
    116c:	49 8b 9d 00 1c 00 00 	mov    0x1c00(%r13),%rbx
    1173:	49 89 ff             	mov    %rdi,%r15
    1176:	4c 8d a3 88 28 00 00 	lea    0x2888(%rbx),%r12
    117d:	4c 89 e7             	mov    %r12,%rdi
    1180:	e8 00 00 00 00       	callq  1185 <hid_ctrl+0x45>
    1185:	41 83 fe b9          	cmp    $0xffffffffffffffb9,%r14d
    1189:	0f 84 93 00 00 00    	je     1222 <hid_ctrl+0xe2>
    118f:	7e 5f                	jle    11f0 <hid_ctrl+0xb0>
    1191:	41 83 fe fe          	cmp    $0xfffffffffffffffe,%r14d
    1195:	0f 1f 00             	nopl   (%rax)
    1198:	0f 84 84 00 00 00    	je     1222 <hid_ctrl+0xe2>
    119e:	45 85 f6             	test   %r14d,%r14d
    11a1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    11a8:	0f 85 1a 01 00 00    	jne    12c8 <hid_ctrl+0x188>
    11ae:	0f b6 83 41 18 00 00 	movzbl 0x1841(%rbx),%eax
    11b5:	0f b6 d0             	movzbl %al,%edx
    11b8:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    11bc:	48 8d 34 d3          	lea    (%rbx,%rdx,8),%rsi
    11c0:	80 7e 40 80          	cmpb   $0x80,0x40(%rsi)
    11c4:	75 63                	jne    1229 <hid_ctrl+0xe9>
    11c6:	48 8b 46 48          	mov    0x48(%rsi),%rax
    11ca:	41 8b 8f 88 00 00 00 	mov    0x88(%r15),%ecx
    11d1:	49 8b 57 68          	mov    0x68(%r15),%rdx
    11d5:	8b 70 14             	mov    0x14(%rax),%esi
    11d8:	49 8b bf b0 00 00 00 	mov    0xb0(%r15),%rdi
    11df:	45 31 c0             	xor    %r8d,%r8d
    11e2:	e8 00 00 00 00       	callq  11e7 <hid_ctrl+0xa7>
    11e7:	0f b6 83 41 18 00 00 	movzbl 0x1841(%rbx),%eax
    11ee:	eb 39                	jmp    1229 <hid_ctrl+0xe9>
    11f0:	41 83 fe 98          	cmp    $0xffffffffffffff98,%r14d
    11f4:	74 2c                	je     1222 <hid_ctrl+0xe2>
    11f6:	41 83 fe ac          	cmp    $0xffffffffffffffac,%r14d
    11fa:	74 26                	je     1222 <hid_ctrl+0xe2>
    11fc:	41 83 fe 94          	cmp    $0xffffffffffffff94,%r14d
    1200:	0f 84 da 00 00 00    	je     12e0 <hid_ctrl+0x1a0>
    1206:	49 8b 7f 48          	mov    0x48(%r15),%rdi
    120a:	44 89 f2             	mov    %r14d,%edx
    120d:	48 81 c7 88 00 00 00 	add    $0x88,%rdi
    1214:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    121b:	31 c0                	xor    %eax,%eax
    121d:	e8 00 00 00 00       	callq  1222 <hid_ctrl+0xe2>
    1222:	0f b6 83 41 18 00 00 	movzbl 0x1841(%rbx),%eax
    1229:	ff c0                	inc    %eax
    122b:	88 83 41 18 00 00    	mov    %al,0x1841(%rbx)
    1231:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1238:	3a 83 40 18 00 00    	cmp    0x1840(%rbx),%al
    123e:	74 58                	je     1298 <hid_ctrl+0x158>
    1240:	4c 89 ef             	mov    %r13,%rdi
    1243:	e8 b8 f0 ff ff       	callq  300 <hid_submit_ctrl>
    1248:	85 c0                	test   %eax,%eax
    124a:	75 24                	jne    1270 <hid_ctrl+0x130>
    124c:	4c 89 e7             	mov    %r12,%rdi
    124f:	e8 00 00 00 00       	callq  1254 <hid_ctrl+0x114>
    1254:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    1258:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
    125c:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
    1260:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
    1264:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
    1268:	c9                   	leaveq 
    1269:	c3                   	retq   
    126a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1270:	f0 80 a3 90 28 00 00 	lock andb $0xfd,0x2890(%rbx)
    1277:	fd 
    1278:	31 c9                	xor    %ecx,%ecx
    127a:	48 8d bb 20 29 00 00 	lea    0x2920(%rbx),%rdi
    1281:	ba 01 00 00 00       	mov    $0x1,%edx
    1286:	be 03 00 00 00       	mov    $0x3,%esi
    128b:	e8 00 00 00 00       	callq  1290 <hid_ctrl+0x150>
    1290:	eb ba                	jmp    124c <hid_ctrl+0x10c>
    1292:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1298:	f0 80 a3 90 28 00 00 	lock andb $0xfd,0x2890(%rbx)
    129f:	fd 
    12a0:	4c 89 e7             	mov    %r12,%rdi
    12a3:	e8 00 00 00 00       	callq  12a8 <hid_ctrl+0x168>
    12a8:	48 8d bb 20 29 00 00 	lea    0x2920(%rbx),%rdi
    12af:	31 c9                	xor    %ecx,%ecx
    12b1:	ba 01 00 00 00       	mov    $0x1,%edx
    12b6:	be 03 00 00 00       	mov    $0x3,%esi
    12bb:	e8 00 00 00 00       	callq  12c0 <hid_ctrl+0x180>
    12c0:	eb 92                	jmp    1254 <hid_ctrl+0x114>
    12c2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    12c8:	41 83 fe e0          	cmp    $0xffffffffffffffe0,%r14d
    12cc:	0f 85 34 ff ff ff    	jne    1206 <hid_ctrl+0xc6>
    12d2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    12d8:	e9 45 ff ff ff       	jmpq   1222 <hid_ctrl+0xe2>
    12dd:	0f 1f 00             	nopl   (%rax)
    12e0:	0f b6 83 40 18 00 00 	movzbl 0x1840(%rbx),%eax
    12e7:	88 83 41 18 00 00    	mov    %al,0x1841(%rbx)
    12ed:	e9 46 ff ff ff       	jmpq   1238 <hid_ctrl+0xf8>
    12f2:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
    12f9:	1f 84 00 00 00 00 00 

0000000000001300 <hid_irq_in>:
    1300:	55                   	push   %rbp
    1301:	48 89 e5             	mov    %rsp,%rbp
    1304:	48 83 ec 20          	sub    $0x20,%rsp
    1308:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
    130c:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
    1310:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
    1314:	e8 00 00 00 00       	callq  1319 <hid_irq_in+0x19>
    1319:	4c 8b af b0 00 00 00 	mov    0xb0(%rdi),%r13
    1320:	8b 57 60             	mov    0x60(%rdi),%edx
    1323:	49 89 fc             	mov    %rdi,%r12
    1326:	49 8b 9d 00 1c 00 00 	mov    0x1c00(%r13),%rbx
    132d:	83 fa b9             	cmp    $0xffffffffffffffb9,%edx
    1330:	0f 84 da 00 00 00    	je     1410 <hid_irq_in+0x110>
    1336:	0f 8e a4 00 00 00    	jle    13e0 <hid_irq_in+0xe0>
    133c:	83 fa e0             	cmp    $0xffffffffffffffe0,%edx
    133f:	0f 84 13 01 00 00    	je     1458 <hid_irq_in+0x158>
    1345:	0f 1f 00             	nopl   (%rax)
    1348:	0f 8f 42 01 00 00    	jg     1490 <hid_irq_in+0x190>
    134e:	83 fa c2             	cmp    $0xffffffffffffffc2,%edx
    1351:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1358:	0f 84 b2 00 00 00    	je     1410 <hid_irq_in+0x110>
    135e:	49 8b 7c 24 48       	mov    0x48(%r12),%rdi
    1363:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    136a:	48 81 c7 88 00 00 00 	add    $0x88,%rdi
    1371:	31 c0                	xor    %eax,%eax
    1373:	e8 00 00 00 00       	callq  1378 <hid_irq_in+0x78>
    1378:	be 20 00 00 00       	mov    $0x20,%esi
    137d:	4c 89 e7             	mov    %r12,%rdi
    1380:	e8 00 00 00 00       	callq  1385 <hid_irq_in+0x85>
    1385:	85 c0                	test   %eax,%eax
    1387:	0f 84 a9 00 00 00    	je     1436 <hid_irq_in+0x136>
    138d:	f0 80 a3 90 28 00 00 	lock andb $0xf7,0x2890(%rbx)
    1394:	f7 
    1395:	83 f8 ff             	cmp    $0xffffffffffffffff,%eax
    1398:	0f 84 98 00 00 00    	je     1436 <hid_irq_in+0x136>
    139e:	49 8b 95 88 18 00 00 	mov    0x1888(%r13),%rdx
    13a5:	41 89 c1             	mov    %eax,%r9d
    13a8:	48 8b 12             	mov    (%rdx),%rdx
    13ab:	44 8b 43 10          	mov    0x10(%rbx),%r8d
    13af:	48 8d 8a 7c ff ff ff 	lea    -0x84(%rdx),%rcx
    13b6:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    13bd:	48 8b 52 b8          	mov    -0x48(%rdx),%rdx
    13c1:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    13c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
    13cc:	31 c0                	xor    %eax,%eax
    13ce:	e8 00 00 00 00       	callq  13d3 <hid_irq_in+0xd3>
    13d3:	4c 89 ef             	mov    %r13,%rdi
    13d6:	e8 d5 ec ff ff       	callq  b0 <hid_io_error>
    13db:	eb 59                	jmp    1436 <hid_irq_in+0x136>
    13dd:	0f 1f 00             	nopl   (%rax)
    13e0:	83 fa 94             	cmp    $0xffffffffffffff94,%edx
    13e3:	74 63                	je     1448 <hid_irq_in+0x148>
    13e5:	0f 1f 00             	nopl   (%rax)
    13e8:	0f 8e 0a 01 00 00    	jle    14f8 <hid_irq_in+0x1f8>
    13ee:	83 fa 98             	cmp    $0xffffffffffffff98,%edx
    13f1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    13f8:	74 4e                	je     1448 <hid_irq_in+0x148>
    13fa:	83 fa ac             	cmp    $0xffffffffffffffac,%edx
    13fd:	0f 1f 00             	nopl   (%rax)
    1400:	0f 85 58 ff ff ff    	jne    135e <hid_irq_in+0x5e>
    1406:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    140d:	00 00 00 
    1410:	48 8b 43 08          	mov    0x8(%rbx),%rax
    1414:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 141b <hid_irq_in+0x11b>
    141b:	48 8b 40 30          	mov    0x30(%rax),%rax
    141f:	48 89 90 a8 04 00 00 	mov    %rdx,0x4a8(%rax)
    1426:	f0 80 a3 90 28 00 00 	lock andb $0xf7,0x2890(%rbx)
    142d:	f7 
    142e:	4c 89 ef             	mov    %r13,%rdi
    1431:	e8 7a ec ff ff       	callq  b0 <hid_io_error>
    1436:	48 8b 5d e8          	mov    -0x18(%rbp),%rbx
    143a:	4c 8b 65 f0          	mov    -0x10(%rbp),%r12
    143e:	4c 8b 6d f8          	mov    -0x8(%rbp),%r13
    1442:	c9                   	leaveq 
    1443:	c3                   	retq   
    1444:	0f 1f 40 00          	nopl   0x0(%rax)
    1448:	f0 80 a3 90 28 00 00 	lock andb $0xf7,0x2890(%rbx)
    144f:	f7 
    1450:	eb e4                	jmp    1436 <hid_irq_in+0x136>
    1452:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1458:	48 8b 43 08          	mov    0x8(%rbx),%rax
    145c:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 1463 <hid_irq_in+0x163>
    1463:	48 8b 40 30          	mov    0x30(%rax),%rax
    1467:	48 89 90 a8 04 00 00 	mov    %rdx,0x4a8(%rax)
    146e:	f0 80 a3 90 28 00 00 	lock andb $0xf7,0x2890(%rbx)
    1475:	f7 
    1476:	f0 80 8b 90 28 00 00 	lock orb $0x40,0x2890(%rbx)
    147d:	40 
    147e:	48 8d bb e0 28 00 00 	lea    0x28e0(%rbx),%rdi
    1485:	e8 00 00 00 00       	callq  148a <hid_irq_in+0x18a>
    148a:	eb aa                	jmp    1436 <hid_irq_in+0x136>
    148c:	0f 1f 40 00          	nopl   0x0(%rax)
    1490:	83 fa fe             	cmp    $0xfffffffffffffffe,%edx
    1493:	74 b3                	je     1448 <hid_irq_in+0x148>
    1495:	85 d2                	test   %edx,%edx
    1497:	90                   	nop
    1498:	0f 85 c0 fe ff ff    	jne    135e <hid_irq_in+0x5e>
    149e:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 14a5 <hid_irq_in+0x1a5>
    14a5:	48 8b 43 08          	mov    0x8(%rbx),%rax
    14a9:	31 f6                	xor    %esi,%esi
    14ab:	48 8b 40 30          	mov    0x30(%rax),%rax
    14af:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    14b5:	48 89 90 a8 04 00 00 	mov    %rdx,0x4a8(%rax)
    14bc:	c7 83 d8 28 00 00 00 	movl   $0x0,0x28d8(%rbx)
    14c3:	00 00 00 
    14c6:	8b 8f 88 00 00 00    	mov    0x88(%rdi),%ecx
    14cc:	48 8b 57 68          	mov    0x68(%rdi),%rdx
    14d0:	48 8b bf b0 00 00 00 	mov    0xb0(%rdi),%rdi
    14d7:	e8 00 00 00 00       	callq  14dc <hid_irq_in+0x1dc>
    14dc:	4c 89 ef             	mov    %r13,%rdi
    14df:	e8 00 00 00 00       	callq  14e4 <hid_irq_in+0x1e4>
    14e4:	85 c0                	test   %eax,%eax
    14e6:	74 28                	je     1510 <hid_irq_in+0x210>
    14e8:	f0 80 8b 91 28 00 00 	lock orb $0x4,0x2891(%rbx)
    14ef:	04 
    14f0:	e9 83 fe ff ff       	jmpq   1378 <hid_irq_in+0x78>
    14f5:	0f 1f 00             	nopl   (%rax)
    14f8:	83 fa 92             	cmp    $0xffffffffffffff92,%edx
    14fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1500:	0f 85 58 fe ff ff    	jne    135e <hid_irq_in+0x5e>
    1506:	66 90                	xchg   %ax,%ax
    1508:	e9 03 ff ff ff       	jmpq   1410 <hid_irq_in+0x110>
    150d:	0f 1f 00             	nopl   (%rax)
    1510:	f0 80 a3 91 28 00 00 	lock andb $0xfb,0x2891(%rbx)
    1517:	fb 
    1518:	e9 5b fe ff ff       	jmpq   1378 <hid_irq_in+0x78>
    151d:	0f 1f 00             	nopl   (%rax)

0000000000001520 <usbhid_probe>:
    1520:	55                   	push   %rbp
    1521:	48 89 e5             	mov    %rsp,%rbp
    1524:	41 57                	push   %r15
    1526:	41 56                	push   %r14
    1528:	41 55                	push   %r13
    152a:	41 54                	push   %r12
    152c:	53                   	push   %rbx
    152d:	48 83 ec 18          	sub    $0x18,%rsp
    1531:	e8 00 00 00 00       	callq  1536 <usbhid_probe+0x16>
    1536:	44 8b 1d 00 00 00 00 	mov    0x0(%rip),%r11d        # 153d <usbhid_probe+0x1d>
    153d:	4c 8b 7f 08          	mov    0x8(%rdi),%r15
    1541:	48 8b 47 30          	mov    0x30(%rdi),%rax
    1545:	49 89 fd             	mov    %rdi,%r13
    1548:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    154c:	45 85 db             	test   %r11d,%r11d
    154f:	0f 85 ed 03 00 00    	jne    1942 <usbhid_probe+0x422>
    1555:	41 0f b6 5f 04       	movzbl 0x4(%r15),%ebx
    155a:	85 db                	test   %ebx,%ebx
    155c:	0f 84 c3 03 00 00    	je     1925 <usbhid_probe+0x405>
    1562:	ff cb                	dec    %ebx
    1564:	49 8b 4f 10          	mov    0x10(%r15),%rcx
    1568:	48 ff c3             	inc    %rbx
    156b:	31 c0                	xor    %eax,%eax
    156d:	48 c1 e3 06          	shl    $0x6,%rbx
    1571:	31 f6                	xor    %esi,%esi
    1573:	eb 0c                	jmp    1581 <usbhid_probe+0x61>
    1575:	0f 1f 00             	nopl   (%rax)
    1578:	48 83 c0 40          	add    $0x40,%rax
    157c:	48 39 d8             	cmp    %rbx,%rax
    157f:	74 20                	je     15a1 <usbhid_probe+0x81>
    1581:	0f b6 54 01 03       	movzbl 0x3(%rcx,%rax,1),%edx
    1586:	83 e2 03             	and    $0x3,%edx
    1589:	83 fa 03             	cmp    $0x3,%edx
    158c:	75 ea                	jne    1578 <usbhid_probe+0x58>
    158e:	0f be 54 01 02       	movsbl 0x2(%rcx,%rax,1),%edx
    1593:	48 83 c0 40          	add    $0x40,%rax
    1597:	c1 ea 1f             	shr    $0x1f,%edx
    159a:	01 d6                	add    %edx,%esi
    159c:	48 39 d8             	cmp    %rbx,%rax
    159f:	75 e0                	jne    1581 <usbhid_probe+0x61>
    15a1:	85 f6                	test   %esi,%esi
    15a3:	0f 84 7c 03 00 00    	je     1925 <usbhid_probe+0x405>
    15a9:	e8 00 00 00 00       	callq  15ae <usbhid_probe+0x8e>
    15ae:	48 89 c3             	mov    %rax,%rbx
    15b1:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
    15b7:	0f 87 a6 03 00 00    	ja     1963 <usbhid_probe+0x443>
    15bd:	49 8d 55 30          	lea    0x30(%r13),%rdx
    15c1:	48 89 c6             	mov    %rax,%rsi
    15c4:	48 89 d7             	mov    %rdx,%rdi
    15c7:	4c 8b 65 c0          	mov    -0x40(%rbp),%r12
    15cb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    15cf:	49 81 ec 88 00 00 00 	sub    $0x88,%r12
    15d6:	e8 00 00 00 00       	callq  15db <usbhid_probe+0xbb>
    15db:	48 c7 83 c0 1a 00 00 	movq   $0x0,0x1ac0(%rbx)
    15e2:	00 00 00 00 
    15e6:	48 c7 83 30 1c 00 00 	movq   $0x0,0x1c30(%rbx)
    15ed:	00 00 00 00 
    15f1:	48 c7 83 08 1c 00 00 	movq   $0x0,0x1c08(%rbx)
    15f8:	00 00 00 00 
    15fc:	48 c7 83 10 1c 00 00 	movq   $0x0,0x1c10(%rbx)
    1603:	00 00 00 00 
    1607:	48 c7 83 18 1c 00 00 	movq   $0x0,0x1c18(%rbx)
    160e:	00 00 00 00 
    1612:	48 c7 83 20 1c 00 00 	movq   $0x0,0x1c20(%rbx)
    1619:	00 00 00 00 
    161d:	48 c7 83 28 1c 00 00 	movq   $0x0,0x1c28(%rbx)
    1624:	00 00 00 00 
    1628:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    162c:	66 c7 43 24 03 00    	movw   $0x3,0x24(%rbx)
    1632:	48 89 83 88 18 00 00 	mov    %rax,0x1888(%rbx)
    1639:	41 0f b7 bc 24 c0 02 	movzwl 0x2c0(%r12),%edi
    1640:	00 00 
    1642:	89 7b 28             	mov    %edi,0x28(%rbx)
    1645:	41 0f b7 b4 24 c2 02 	movzwl 0x2c2(%r12),%esi
    164c:	00 00 
    164e:	c6 83 00 1b 00 00 00 	movb   $0x0,0x1b00(%rbx)
    1655:	89 73 2c             	mov    %esi,0x2c(%rbx)
    1658:	e8 00 00 00 00       	callq  165d <usbhid_probe+0x13d>
    165d:	89 83 d0 1a 00 00    	mov    %eax,0x1ad0(%rbx)
    1663:	49 8b 45 08          	mov    0x8(%r13),%rax
    1667:	80 78 07 02          	cmpb   $0x2,0x7(%rax)
    166b:	0f 84 97 02 00 00    	je     1908 <usbhid_probe+0x3e8>
    1671:	49 8b b4 24 00 04 00 	mov    0x400(%r12),%rsi
    1678:	00 
    1679:	48 85 f6             	test   %rsi,%rsi
    167c:	74 14                	je     1692 <usbhid_probe+0x172>
    167e:	4c 8d b3 00 1b 00 00 	lea    0x1b00(%rbx),%r14
    1685:	ba 80 00 00 00       	mov    $0x80,%edx
    168a:	4c 89 f7             	mov    %r14,%rdi
    168d:	e8 00 00 00 00       	callq  1692 <usbhid_probe+0x172>
    1692:	49 8b b4 24 f8 03 00 	mov    0x3f8(%r12),%rsi
    1699:	00 
    169a:	48 85 f6             	test   %rsi,%rsi
    169d:	74 3b                	je     16da <usbhid_probe+0x1ba>
    169f:	4c 8d b3 00 1b 00 00 	lea    0x1b00(%rbx),%r14
    16a6:	49 83 bc 24 00 04 00 	cmpq   $0x0,0x400(%r12)
    16ad:	00 00 
    16af:	74 1c                	je     16cd <usbhid_probe+0x1ad>
    16b1:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    16b8:	ba 80 00 00 00       	mov    $0x80,%edx
    16bd:	4c 89 f7             	mov    %r14,%rdi
    16c0:	e8 00 00 00 00       	callq  16c5 <usbhid_probe+0x1a5>
    16c5:	49 8b b4 24 f8 03 00 	mov    0x3f8(%r12),%rsi
    16cc:	00 
    16cd:	ba 80 00 00 00       	mov    $0x80,%edx
    16d2:	4c 89 f7             	mov    %r14,%rdi
    16d5:	e8 00 00 00 00       	callq  16da <usbhid_probe+0x1ba>
    16da:	80 bb 00 1b 00 00 00 	cmpb   $0x0,0x1b00(%rbx)
    16e1:	0f 84 e9 01 00 00    	je     18d0 <usbhid_probe+0x3b0>
    16e7:	4c 8d b3 80 1b 00 00 	lea    0x1b80(%rbx),%r14
    16ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    16f2:	4d 8d 44 24 04       	lea    0x4(%r12),%r8
    16f7:	48 8b 42 b8          	mov    -0x48(%rdx),%rax
    16fb:	be 40 00 00 00       	mov    $0x40,%esi
    1700:	48 8b 48 10          	mov    0x10(%rax),%rcx
    1704:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    170b:	4c 89 f7             	mov    %r14,%rdi
    170e:	31 c0                	xor    %eax,%eax
    1710:	e8 00 00 00 00       	callq  1715 <usbhid_probe+0x1f5>
    1715:	ba 40 00 00 00       	mov    $0x40,%edx
    171a:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    1721:	4c 89 f7             	mov    %r14,%rdi
    1724:	e8 00 00 00 00       	callq  1729 <usbhid_probe+0x209>
    1729:	4c 89 f7             	mov    %r14,%rdi
    172c:	e8 00 00 00 00       	callq  1731 <usbhid_probe+0x211>
    1731:	48 83 f8 3e          	cmp    $0x3e,%rax
    1735:	0f 86 65 01 00 00    	jbe    18a0 <usbhid_probe+0x380>
    173b:	48 8d 93 c0 1b 00 00 	lea    0x1bc0(%rbx),%rdx
    1742:	41 0f b6 b4 24 c8 02 	movzbl 0x2c8(%r12),%esi
    1749:	00 00 
    174b:	b9 40 00 00 00       	mov    $0x40,%ecx
    1750:	4c 89 e7             	mov    %r12,%rdi
    1753:	e8 00 00 00 00       	callq  1758 <usbhid_probe+0x238>
    1758:	85 c0                	test   %eax,%eax
    175a:	0f 8e b8 01 00 00    	jle    1918 <usbhid_probe+0x3f8>
    1760:	be 02 00 00 00       	mov    $0x2,%esi
    1765:	bf d0 c0 00 00       	mov    $0xc0d0,%edi
    176a:	e8 00 00 00 00       	callq  176f <usbhid_probe+0x24f>
    176f:	44 8b 15 00 00 00 00 	mov    0x0(%rip),%r10d        # 1776 <usbhid_probe+0x256>
    1776:	49 89 c4             	mov    %rax,%r12
    1779:	45 85 d2             	test   %r10d,%r10d
    177c:	0f 85 e9 01 00 00    	jne    196b <usbhid_probe+0x44b>
    1782:	41 be f4 ff ff ff    	mov    $0xfffffff4,%r14d
    1788:	4d 85 e4             	test   %r12,%r12
    178b:	0f 84 ef 00 00 00    	je     1880 <usbhid_probe+0x360>
    1791:	4c 89 a3 00 1c 00 00 	mov    %r12,0x1c00(%rbx)
    1798:	49 8d bc 24 20 29 00 	lea    0x2920(%r12),%rdi
    179f:	00 
    17a0:	49 89 1c 24          	mov    %rbx,(%r12)
    17a4:	4d 89 6c 24 08       	mov    %r13,0x8(%r12)
    17a9:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    17b0:	41 0f b6 47 02       	movzbl 0x2(%r15),%eax
    17b5:	41 89 44 24 10       	mov    %eax,0x10(%r12)
    17ba:	e8 00 00 00 00       	callq  17bf <usbhid_probe+0x29f>
    17bf:	49 8d 84 24 e8 28 00 	lea    0x28e8(%r12),%rax
    17c6:	00 
    17c7:	31 d2                	xor    %edx,%edx
    17c9:	31 f6                	xor    %esi,%esi
    17cb:	49 89 84 24 e8 28 00 	mov    %rax,0x28e8(%r12)
    17d2:	00 
    17d3:	49 89 84 24 f0 28 00 	mov    %rax,0x28f0(%r12)
    17da:	00 
    17db:	49 8d bc 24 98 28 00 	lea    0x2898(%r12),%rdi
    17e2:	00 
    17e3:	49 8d 84 24 08 29 00 	lea    0x2908(%r12),%rax
    17ea:	00 
    17eb:	49 c7 84 24 e0 28 00 	movq   $0x4100,0x28e0(%r12)
    17f2:	00 00 41 00 00 
    17f7:	49 89 84 24 08 29 00 	mov    %rax,0x2908(%r12)
    17fe:	00 
    17ff:	49 89 84 24 10 29 00 	mov    %rax,0x2910(%r12)
    1806:	00 
    1807:	49 c7 84 24 f8 28 00 	movq   $0x0,0x28f8(%r12)
    180e:	00 00 00 00 00 
    1813:	49 c7 84 24 00 29 00 	movq   $0x4100,0x2900(%r12)
    181a:	00 00 41 00 00 
    181f:	49 c7 84 24 18 29 00 	movq   $0x0,0x2918(%r12)
    1826:	00 00 00 00 00 
    182b:	49 c7 84 24 b8 28 00 	movq   $0x0,0x28b8(%r12)
    1832:	00 00 00 00 00 
    1837:	49 89 9c 24 c0 28 00 	mov    %rbx,0x28c0(%r12)
    183e:	00 
    183f:	e8 00 00 00 00       	callq  1844 <usbhid_probe+0x324>
    1844:	41 c7 84 24 88 28 00 	movl   $0x0,0x2888(%r12)
    184b:	00 00 00 00 00 
    1850:	48 89 df             	mov    %rbx,%rdi
    1853:	e8 00 00 00 00       	callq  1858 <usbhid_probe+0x338>
    1858:	41 89 c6             	mov    %eax,%r14d
    185b:	85 c0                	test   %eax,%eax
    185d:	74 29                	je     1888 <usbhid_probe+0x368>
    185f:	83 f8 ed             	cmp    $0xffffffffffffffed,%eax
    1862:	74 14                	je     1878 <usbhid_probe+0x358>
    1864:	89 c2                	mov    %eax,%edx
    1866:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    186d:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
    1871:	31 c0                	xor    %eax,%eax
    1873:	e8 00 00 00 00       	callq  1878 <usbhid_probe+0x358>
    1878:	4c 89 e7             	mov    %r12,%rdi
    187b:	e8 00 00 00 00       	callq  1880 <usbhid_probe+0x360>
    1880:	48 89 df             	mov    %rbx,%rdi
    1883:	e8 00 00 00 00       	callq  1888 <usbhid_probe+0x368>
    1888:	48 83 c4 18          	add    $0x18,%rsp
    188c:	44 89 f0             	mov    %r14d,%eax
    188f:	5b                   	pop    %rbx
    1890:	41 5c                	pop    %r12
    1892:	41 5d                	pop    %r13
    1894:	41 5e                	pop    %r14
    1896:	41 5f                	pop    %r15
    1898:	c9                   	leaveq 
    1899:	c3                   	retq   
    189a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    18a0:	49 8b 55 00          	mov    0x0(%r13),%rdx
    18a4:	48 8d bc 03 80 1b 00 	lea    0x1b80(%rbx,%rax,1),%rdi
    18ab:	00 
    18ac:	0f b6 4a 02          	movzbl 0x2(%rdx),%ecx
    18b0:	be 40 00 00 00       	mov    $0x40,%esi
    18b5:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    18bc:	48 29 c6             	sub    %rax,%rsi
    18bf:	31 c0                	xor    %eax,%eax
    18c1:	e8 00 00 00 00       	callq  18c6 <usbhid_probe+0x3a6>
    18c6:	e9 70 fe ff ff       	jmpq   173b <usbhid_probe+0x21b>
    18cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    18d0:	41 0f b7 8c 24 c0 02 	movzwl 0x2c0(%r12),%ecx
    18d7:	00 00 
    18d9:	48 8d bb 00 1b 00 00 	lea    0x1b00(%rbx),%rdi
    18e0:	45 0f b7 84 24 c2 02 	movzwl 0x2c2(%r12),%r8d
    18e7:	00 00 
    18e9:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    18f0:	be 80 00 00 00       	mov    $0x80,%esi
    18f5:	31 c0                	xor    %eax,%eax
    18f7:	e8 00 00 00 00       	callq  18fc <usbhid_probe+0x3dc>
    18fc:	e9 e6 fd ff ff       	jmpq   16e7 <usbhid_probe+0x1c7>
    1901:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1908:	c7 43 34 01 00 00 00 	movl   $0x1,0x34(%rbx)
    190f:	e9 5d fd ff ff       	jmpq   1671 <usbhid_probe+0x151>
    1914:	0f 1f 40 00          	nopl   0x0(%rax)
    1918:	c6 83 c0 1b 00 00 00 	movb   $0x0,0x1bc0(%rbx)
    191f:	90                   	nop
    1920:	e9 3b fe ff ff       	jmpq   1760 <usbhid_probe+0x240>
    1925:	49 8d 7d 30          	lea    0x30(%r13),%rdi
    1929:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    1930:	31 c0                	xor    %eax,%eax
    1932:	41 be ed ff ff ff    	mov    $0xffffffed,%r14d
    1938:	e8 00 00 00 00       	callq  193d <usbhid_probe+0x41d>
    193d:	e9 46 ff ff ff       	jmpq   1888 <usbhid_probe+0x368>
    1942:	48 8b 07             	mov    (%rdi),%rax
    1945:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    194c:	0f b6 50 02          	movzbl 0x2(%rax),%edx
    1950:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1957:	31 c0                	xor    %eax,%eax
    1959:	e8 00 00 00 00       	callq  195e <usbhid_probe+0x43e>
    195e:	e9 f2 fb ff ff       	jmpq   1555 <usbhid_probe+0x35>
    1963:	41 89 c6             	mov    %eax,%r14d
    1966:	e9 1d ff ff ff       	jmpq   1888 <usbhid_probe+0x368>
    196b:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    1972:	00 00 
    1974:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
    197a:	4c 8b 35 00 00 00 00 	mov    0x0(%rip),%r14        # 1981 <usbhid_probe+0x461>
    1981:	4d 85 f6             	test   %r14,%r14
    1984:	74 30                	je     19b6 <usbhid_probe+0x496>
    1986:	49 8b 06             	mov    (%r14),%rax
    1989:	49 8b 7e 08          	mov    0x8(%r14),%rdi
    198d:	41 b9 d0 80 00 00    	mov    $0x80d0,%r9d
    1993:	49 83 c6 10          	add    $0x10,%r14
    1997:	41 b8 00 40 00 00    	mov    $0x4000,%r8d
    199d:	b9 40 29 00 00       	mov    $0x2940,%ecx
    19a2:	4c 89 e2             	mov    %r12,%rdx
    19a5:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    19ac:	ff d0                	callq  *%rax
    19ae:	49 8b 06             	mov    (%r14),%rax
    19b1:	48 85 c0             	test   %rax,%rax
    19b4:	75 d3                	jne    1989 <usbhid_probe+0x469>
    19b6:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    19bd:	00 00 
    19bf:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
    19c5:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
    19cc:	a8 08                	test   $0x8,%al
    19ce:	0f 84 ae fd ff ff    	je     1782 <usbhid_probe+0x262>
    19d4:	e8 00 00 00 00       	callq  19d9 <usbhid_probe+0x4b9>
    19d9:	e9 a4 fd ff ff       	jmpq   1782 <usbhid_probe+0x262>
    19de:	66 90                	xchg   %ax,%ax

00000000000019e0 <usbhid_get_power>:
    19e0:	55                   	push   %rbp
    19e1:	48 89 e5             	mov    %rsp,%rbp
    19e4:	e8 00 00 00 00       	callq  19e9 <usbhid_get_power+0x9>
    19e9:	48 8b 87 00 1c 00 00 	mov    0x1c00(%rdi),%rax
    19f0:	48 8b 78 08          	mov    0x8(%rax),%rdi
    19f4:	e8 00 00 00 00       	callq  19f9 <usbhid_get_power+0x19>
    19f9:	c9                   	leaveq 
    19fa:	c3                   	retq   
    19fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001a00 <__usbhid_restart_queues>:
    1a00:	55                   	push   %rbp
    1a01:	48 89 e5             	mov    %rsp,%rbp
    1a04:	53                   	push   %rbx
    1a05:	48 83 ec 08          	sub    $0x8,%rsp
    1a09:	e8 00 00 00 00       	callq  1a0e <__usbhid_restart_queues+0xe>
    1a0e:	48 89 fb             	mov    %rdi,%rbx
    1a11:	48 8b bf 08 d7 ff ff 	mov    -0x28f8(%rdi),%rdi
    1a18:	e8 00 00 00 00       	callq  1a1d <__usbhid_restart_queues+0x1d>
    1a1d:	85 c0                	test   %eax,%eax
    1a1f:	78 0c                	js     1a2d <__usbhid_restart_queues+0x2d>
    1a21:	48 8b bb 08 d7 ff ff 	mov    -0x28f8(%rbx),%rdi
    1a28:	e8 00 00 00 00       	callq  1a2d <__usbhid_restart_queues+0x2d>
    1a2d:	48 83 c4 08          	add    $0x8,%rsp
    1a31:	5b                   	pop    %rbx
    1a32:	c9                   	leaveq 
    1a33:	c3                   	retq   
    1a34:	66 66 66 2e 0f 1f 84 	nopw   %cs:0x0(%rax,%rax,1)
    1a3b:	00 00 00 00 00 

0000000000001a40 <usbhid_put_power>:
    1a40:	55                   	push   %rbp
    1a41:	48 89 e5             	mov    %rsp,%rbp
    1a44:	e8 00 00 00 00       	callq  1a49 <usbhid_put_power+0x9>
    1a49:	48 8b 87 00 1c 00 00 	mov    0x1c00(%rdi),%rax
    1a50:	48 8b 78 08          	mov    0x8(%rax),%rdi
    1a54:	e8 00 00 00 00       	callq  1a59 <usbhid_put_power+0x19>
    1a59:	c9                   	leaveq 
    1a5a:	c3                   	retq   
    1a5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001a60 <usbhid_power>:
    1a60:	55                   	push   %rbp
    1a61:	48 89 e5             	mov    %rsp,%rbp
    1a64:	e8 00 00 00 00       	callq  1a69 <usbhid_power+0x9>
    1a69:	83 fe 02             	cmp    $0x2,%esi
    1a6c:	74 2a                	je     1a98 <usbhid_power+0x38>
    1a6e:	31 c0                	xor    %eax,%eax
    1a70:	83 fe 20             	cmp    $0x20,%esi
    1a73:	74 0b                	je     1a80 <usbhid_power+0x20>
    1a75:	c9                   	leaveq 
    1a76:	c3                   	retq   
    1a77:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    1a7e:	00 00 
    1a80:	48 8b 87 00 1c 00 00 	mov    0x1c00(%rdi),%rax
    1a87:	48 8b 78 08          	mov    0x8(%rax),%rdi
    1a8b:	e8 00 00 00 00       	callq  1a90 <usbhid_power+0x30>
    1a90:	c9                   	leaveq 
    1a91:	c3                   	retq   
    1a92:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1a98:	48 8b 87 00 1c 00 00 	mov    0x1c00(%rdi),%rax
    1a9f:	48 8b 78 08          	mov    0x8(%rax),%rdi
    1aa3:	e8 00 00 00 00       	callq  1aa8 <usbhid_power+0x48>
    1aa8:	31 c0                	xor    %eax,%eax
    1aaa:	c9                   	leaveq 
    1aab:	c3                   	retq   
    1aac:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001ab0 <hid_reset>:
    1ab0:	55                   	push   %rbp
    1ab1:	48 89 e5             	mov    %rsp,%rbp
    1ab4:	48 83 ec 20          	sub    $0x20,%rsp
    1ab8:	48 89 1c 24          	mov    %rbx,(%rsp)
    1abc:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
    1ac1:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
    1ac6:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
    1acb:	e8 00 00 00 00       	callq  1ad0 <hid_reset+0x20>
    1ad0:	48 8b 47 b0          	mov    -0x50(%rdi),%rax
    1ad4:	48 89 fb             	mov    %rdi,%rbx
    1ad7:	4c 8d af 20 d7 ff ff 	lea    -0x28e0(%rdi),%r13
    1ade:	4c 8b a7 20 d7 ff ff 	mov    -0x28e0(%rdi),%r12
    1ae5:	a8 40                	test   $0x40,%al
    1ae7:	74 7f                	je     1b68 <hid_reset+0xb8>
    1ae9:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 1af0 <hid_reset+0x40>
    1af0:	0f 85 45 01 00 00    	jne    1c3b <hid_reset+0x18b>
    1af6:	48 8b 83 38 d7 ff ff 	mov    -0x28c8(%rbx),%rax
    1afd:	8b 70 58             	mov    0x58(%rax),%esi
    1b00:	49 8b 84 24 88 18 00 	mov    0x1888(%r12),%rax
    1b07:	00 
    1b08:	48 8b 38             	mov    (%rax),%rdi
    1b0b:	48 81 ef 88 00 00 00 	sub    $0x88,%rdi
    1b12:	e8 00 00 00 00       	callq  1b17 <hid_reset+0x67>
    1b17:	41 89 c6             	mov    %eax,%r14d
    1b1a:	f0 41 80 a5 90 28 00 	lock andb $0xbf,0x2890(%r13)
    1b21:	00 bf 
    1b23:	4c 89 e7             	mov    %r12,%rdi
    1b26:	e8 d5 e4 ff ff       	callq  0 <hid_start_in>
    1b2b:	41 83 fe ed          	cmp    $0xffffffffffffffed,%r14d
    1b2f:	74 1d                	je     1b4e <hid_reset+0x9e>
    1b31:	7e 7d                	jle    1bb0 <hid_reset+0x100>
    1b33:	41 83 fe fc          	cmp    $0xfffffffffffffffc,%r14d
    1b37:	90                   	nop
    1b38:	74 14                	je     1b4e <hid_reset+0x9e>
    1b3a:	45 85 f6             	test   %r14d,%r14d
    1b3d:	0f 1f 00             	nopl   (%rax)
    1b40:	75 74                	jne    1bb6 <hid_reset+0x106>
    1b42:	48 8b 43 b0          	mov    -0x50(%rbx),%rax
    1b46:	a8 08                	test   $0x8,%al
    1b48:	0f 84 aa 00 00 00    	je     1bf8 <hid_reset+0x148>
    1b4e:	48 8b 1c 24          	mov    (%rsp),%rbx
    1b52:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
    1b57:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
    1b5c:	4c 8b 74 24 18       	mov    0x18(%rsp),%r14
    1b61:	c9                   	leaveq 
    1b62:	c3                   	retq   
    1b63:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1b68:	a8 10                	test   $0x10,%al
    1b6a:	74 da                	je     1b46 <hid_reset+0x96>
    1b6c:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 1b73 <hid_reset+0xc3>
    1b73:	0f 85 01 01 00 00    	jne    1c7a <hid_reset+0x1ca>
    1b79:	49 8b 84 24 88 18 00 	mov    0x1888(%r12),%rax
    1b80:	00 
    1b81:	48 8b b3 28 d7 ff ff 	mov    -0x28d8(%rbx),%rsi
    1b88:	48 8b 38             	mov    (%rax),%rdi
    1b8b:	48 81 ef 88 00 00 00 	sub    $0x88,%rdi
    1b92:	e8 00 00 00 00       	callq  1b97 <hid_reset+0xe7>
    1b97:	41 89 c6             	mov    %eax,%r14d
    1b9a:	85 c0                	test   %eax,%eax
    1b9c:	74 6a                	je     1c08 <hid_reset+0x158>
    1b9e:	f0 41 80 a5 90 28 00 	lock andb $0xef,0x2890(%r13)
    1ba5:	00 ef 
    1ba7:	eb 82                	jmp    1b2b <hid_reset+0x7b>
    1ba9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1bb0:	41 83 fe 8f          	cmp    $0xffffffffffffff8f,%r14d
    1bb4:	74 98                	je     1b4e <hid_reset+0x9e>
    1bb6:	49 8b 84 24 88 18 00 	mov    0x1888(%r12),%rax
    1bbd:	00 
    1bbe:	45 89 f1             	mov    %r14d,%r9d
    1bc1:	48 8b 00             	mov    (%rax),%rax
    1bc4:	44 8b 83 30 d7 ff ff 	mov    -0x28d0(%rbx),%r8d
    1bcb:	48 8d 88 7c ff ff ff 	lea    -0x84(%rax),%rcx
    1bd2:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    1bd9:	48 8b 40 b8          	mov    -0x48(%rax),%rax
    1bdd:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1be4:	48 8b 50 10          	mov    0x10(%rax),%rdx
    1be8:	31 c0                	xor    %eax,%eax
    1bea:	e8 00 00 00 00       	callq  1bef <hid_reset+0x13f>
    1bef:	e9 5a ff ff ff       	jmpq   1b4e <hid_reset+0x9e>
    1bf4:	0f 1f 40 00          	nopl   0x0(%rax)
    1bf8:	4c 89 e7             	mov    %r12,%rdi
    1bfb:	e8 b0 e4 ff ff       	callq  b0 <hid_io_error>
    1c00:	e9 49 ff ff ff       	jmpq   1b4e <hid_reset+0x9e>
    1c05:	0f 1f 00             	nopl   (%rax)
    1c08:	49 8b 84 24 88 18 00 	mov    0x1888(%r12),%rax
    1c0f:	00 
    1c10:	48 8b 38             	mov    (%rax),%rdi
    1c13:	48 81 ef 88 00 00 00 	sub    $0x88,%rdi
    1c1a:	e8 00 00 00 00       	callq  1c1f <hid_reset+0x16f>
    1c1f:	41 89 c6             	mov    %eax,%r14d
    1c22:	49 8b 84 24 88 18 00 	mov    0x1888(%r12),%rax
    1c29:	00 
    1c2a:	48 8b 38             	mov    (%rax),%rdi
    1c2d:	48 83 c7 60          	add    $0x60,%rdi
    1c31:	e8 00 00 00 00       	callq  1c36 <hid_reset+0x186>
    1c36:	e9 63 ff ff ff       	jmpq   1b9e <hid_reset+0xee>
    1c3b:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 1c42 <hid_reset+0x192>
    1c42:	0f 84 ae fe ff ff    	je     1af6 <hid_reset+0x46>
    1c48:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 1c4f <hid_reset+0x19f>
    1c4f:	0f 84 a1 fe ff ff    	je     1af6 <hid_reset+0x46>
    1c55:	48 8b b7 28 d7 ff ff 	mov    -0x28d8(%rdi),%rsi
    1c5c:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    1c63:	48 83 c6 30          	add    $0x30,%rsi
    1c67:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1c6e:	31 c0                	xor    %eax,%eax
    1c70:	e8 00 00 00 00       	callq  1c75 <hid_reset+0x1c5>
    1c75:	e9 7c fe ff ff       	jmpq   1af6 <hid_reset+0x46>
    1c7a:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 1c81 <hid_reset+0x1d1>
    1c81:	0f 84 f2 fe ff ff    	je     1b79 <hid_reset+0xc9>
    1c87:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 1c8e <hid_reset+0x1de>
    1c8e:	0f 84 e5 fe ff ff    	je     1b79 <hid_reset+0xc9>
    1c94:	48 8b b7 28 d7 ff ff 	mov    -0x28d8(%rdi),%rsi
    1c9b:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    1ca2:	48 83 c6 30          	add    $0x30,%rsi
    1ca6:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1cad:	31 c0                	xor    %eax,%eax
    1caf:	e8 00 00 00 00       	callq  1cb4 <hid_reset+0x204>
    1cb4:	e9 c0 fe ff ff       	jmpq   1b79 <hid_reset+0xc9>
    1cb9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001cc0 <usbhid_output_raw_report>:
    1cc0:	55                   	push   %rbp
    1cc1:	48 89 e5             	mov    %rsp,%rbp
    1cc4:	53                   	push   %rbx
    1cc5:	48 83 ec 38          	sub    $0x38,%rsp
    1cc9:	e8 00 00 00 00       	callq  1cce <usbhid_output_raw_report+0xe>
    1cce:	48 8b 87 00 1c 00 00 	mov    0x1c00(%rdi),%rax
    1cd5:	48 8b 9f 88 18 00 00 	mov    0x1888(%rdi),%rbx
    1cdc:	4c 8b 13             	mov    (%rbx),%r10
    1cdf:	48 8b 58 08          	mov    0x8(%rax),%rbx
    1ce3:	49 8d ba 78 ff ff ff 	lea    -0x88(%r10),%rdi
    1cea:	48 8b 80 60 18 00 00 	mov    0x1860(%rax),%rax
    1cf1:	4c 8b 4b 08          	mov    0x8(%rbx),%r9
    1cf5:	48 85 c0             	test   %rax,%rax
    1cf8:	74 46                	je     1d40 <usbhid_output_raw_report+0x80>
    1cfa:	31 db                	xor    %ebx,%ebx
    1cfc:	80 3e 00             	cmpb   $0x0,(%rsi)
    1cff:	74 2f                	je     1d30 <usbhid_output_raw_report+0x70>
    1d01:	8b 40 58             	mov    0x58(%rax),%eax
    1d04:	89 d1                	mov    %edx,%ecx
    1d06:	41 b9 88 13 00 00    	mov    $0x1388,%r9d
    1d0c:	48 89 f2             	mov    %rsi,%rdx
    1d0f:	4c 8d 45 ec          	lea    -0x14(%rbp),%r8
    1d13:	89 c6                	mov    %eax,%esi
    1d15:	e8 00 00 00 00       	callq  1d1a <usbhid_output_raw_report+0x5a>
    1d1a:	85 c0                	test   %eax,%eax
    1d1c:	75 09                	jne    1d27 <usbhid_output_raw_report+0x67>
    1d1e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d21:	83 fb 01             	cmp    $0x1,%ebx
    1d24:	83 d8 ff             	sbb    $0xffffffffffffffff,%eax
    1d27:	48 83 c4 38          	add    $0x38,%rsp
    1d2b:	5b                   	pop    %rbx
    1d2c:	c9                   	leaveq 
    1d2d:	c3                   	retq   
    1d2e:	66 90                	xchg   %ax,%ax
    1d30:	48 ff c6             	inc    %rsi
    1d33:	48 ff ca             	dec    %rdx
    1d36:	b3 01                	mov    $0x1,%bl
    1d38:	eb c7                	jmp    1d01 <usbhid_output_raw_report+0x41>
    1d3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1d40:	44 0f b6 06          	movzbl (%rsi),%r8d
    1d44:	31 db                	xor    %ebx,%ebx
    1d46:	45 84 c0             	test   %r8b,%r8b
    1d49:	75 0b                	jne    1d56 <usbhid_output_raw_report+0x96>
    1d4b:	48 ff c6             	inc    %rsi
    1d4e:	48 ff ca             	dec    %rdx
    1d51:	bb 01 00 00 00       	mov    $0x1,%ebx
    1d56:	41 8b 82 78 ff ff ff 	mov    -0x88(%r10),%eax
    1d5d:	45 0f b6 49 02       	movzbl 0x2(%r9),%r9d
    1d62:	c1 e0 08             	shl    $0x8,%eax
    1d65:	0f b7 d2             	movzwl %dx,%edx
    1d68:	0d 00 00 00 80       	or     $0x80000000,%eax
    1d6d:	89 54 24 08          	mov    %edx,0x8(%rsp)
    1d71:	48 89 34 24          	mov    %rsi,(%rsp)
    1d75:	0f b6 c9             	movzbl %cl,%ecx
    1d78:	45 0f b6 c0          	movzbl %r8b,%r8d
    1d7c:	ff c1                	inc    %ecx
    1d7e:	c7 44 24 10 88 13 00 	movl   $0x1388,0x10(%rsp)
    1d85:	00 
    1d86:	c1 e1 08             	shl    $0x8,%ecx
    1d89:	ba 09 00 00 00       	mov    $0x9,%edx
    1d8e:	41 09 c8             	or     %ecx,%r8d
    1d91:	89 c6                	mov    %eax,%esi
    1d93:	45 0f b7 c0          	movzwl %r8w,%r8d
    1d97:	b9 21 00 00 00       	mov    $0x21,%ecx
    1d9c:	e8 00 00 00 00       	callq  1da1 <usbhid_output_raw_report+0xe1>
    1da1:	85 c0                	test   %eax,%eax
    1da3:	7e 82                	jle    1d27 <usbhid_output_raw_report+0x67>
    1da5:	80 fb 01             	cmp    $0x1,%bl
    1da8:	83 d8 ff             	sbb    $0xffffffffffffffff,%eax
    1dab:	e9 77 ff ff ff       	jmpq   1d27 <usbhid_output_raw_report+0x67>

0000000000001db0 <usbhid_find_interface>:
    1db0:	55                   	push   %rbp
    1db1:	48 89 e5             	mov    %rsp,%rbp
    1db4:	e8 00 00 00 00       	callq  1db9 <usbhid_find_interface+0x9>
    1db9:	89 fe                	mov    %edi,%esi
    1dbb:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1dc2:	e8 00 00 00 00       	callq  1dc7 <usbhid_find_interface+0x17>
    1dc7:	c9                   	leaveq 
    1dc8:	c3                   	retq   
    1dc9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001dd0 <usbhid_close>:
    1dd0:	55                   	push   %rbp
    1dd1:	48 89 e5             	mov    %rsp,%rbp
    1dd4:	48 83 ec 20          	sub    $0x20,%rsp
    1dd8:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
    1ddc:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
    1de0:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
    1de4:	e8 00 00 00 00       	callq  1de9 <usbhid_close+0x19>
    1de9:	48 89 fb             	mov    %rdi,%rbx
    1dec:	4c 8b a7 00 1c 00 00 	mov    0x1c00(%rdi),%r12
    1df3:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1dfa:	4d 8d ac 24 88 28 00 	lea    0x2888(%r12),%r13
    1e01:	00 
    1e02:	e8 00 00 00 00       	callq  1e07 <usbhid_close+0x37>
    1e07:	4c 89 ef             	mov    %r13,%rdi
    1e0a:	e8 00 00 00 00       	callq  1e0f <usbhid_close+0x3f>
    1e0f:	8b 83 fc 1a 00 00    	mov    0x1afc(%rbx),%eax
    1e15:	ff c8                	dec    %eax
    1e17:	89 83 fc 1a 00 00    	mov    %eax,0x1afc(%rbx)
    1e1d:	85 c0                	test   %eax,%eax
    1e1f:	74 27                	je     1e48 <usbhid_close+0x78>
    1e21:	4c 89 ef             	mov    %r13,%rdi
    1e24:	e8 00 00 00 00       	callq  1e29 <usbhid_close+0x59>
    1e29:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1e30:	e8 00 00 00 00       	callq  1e35 <usbhid_close+0x65>
    1e35:	48 8b 5d e8          	mov    -0x18(%rbp),%rbx
    1e39:	4c 8b 65 f0          	mov    -0x10(%rbp),%r12
    1e3d:	4c 8b 6d f8          	mov    -0x8(%rbp),%r13
    1e41:	c9                   	leaveq 
    1e42:	c3                   	retq   
    1e43:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1e48:	4c 89 ef             	mov    %r13,%rdi
    1e4b:	e8 00 00 00 00       	callq  1e50 <usbhid_close+0x80>
    1e50:	4c 89 e7             	mov    %r12,%rdi
    1e53:	e8 48 ec ff ff       	callq  aa0 <hid_cancel_delayed_stuff>
    1e58:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
    1e5d:	e8 00 00 00 00       	callq  1e62 <usbhid_close+0x92>
    1e62:	49 8b 44 24 08       	mov    0x8(%r12),%rax
    1e67:	80 60 28 f7          	andb   $0xf7,0x28(%rax)
    1e6b:	eb bc                	jmp    1e29 <usbhid_close+0x59>
    1e6d:	0f 1f 00             	nopl   (%rax)

0000000000001e70 <usbhid_open>:
    1e70:	55                   	push   %rbp
    1e71:	48 89 e5             	mov    %rsp,%rbp
    1e74:	41 54                	push   %r12
    1e76:	53                   	push   %rbx
    1e77:	e8 00 00 00 00       	callq  1e7c <usbhid_open+0xc>
    1e7c:	48 89 fb             	mov    %rdi,%rbx
    1e7f:	4c 8b a7 00 1c 00 00 	mov    0x1c00(%rdi),%r12
    1e86:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1e8d:	e8 00 00 00 00       	callq  1e92 <usbhid_open+0x22>
    1e92:	8b 83 fc 1a 00 00    	mov    0x1afc(%rbx),%eax
    1e98:	8d 50 01             	lea    0x1(%rax),%edx
    1e9b:	85 c0                	test   %eax,%eax
    1e9d:	89 93 fc 1a 00 00    	mov    %edx,0x1afc(%rbx)
    1ea3:	75 2d                	jne    1ed2 <usbhid_open+0x62>
    1ea5:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
    1eaa:	e8 00 00 00 00       	callq  1eaf <usbhid_open+0x3f>
    1eaf:	85 c0                	test   %eax,%eax
    1eb1:	78 3f                	js     1ef2 <usbhid_open+0x82>
    1eb3:	49 8b 44 24 08       	mov    0x8(%r12),%rax
    1eb8:	48 89 df             	mov    %rbx,%rdi
    1ebb:	80 48 28 08          	orb    $0x8,0x28(%rax)
    1ebf:	e8 3c e1 ff ff       	callq  0 <hid_start_in>
    1ec4:	85 c0                	test   %eax,%eax
    1ec6:	75 20                	jne    1ee8 <usbhid_open+0x78>
    1ec8:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
    1ecd:	e8 00 00 00 00       	callq  1ed2 <usbhid_open+0x62>
    1ed2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1ed9:	e8 00 00 00 00       	callq  1ede <usbhid_open+0x6e>
    1ede:	31 c0                	xor    %eax,%eax
    1ee0:	5b                   	pop    %rbx
    1ee1:	41 5c                	pop    %r12
    1ee3:	c9                   	leaveq 
    1ee4:	c3                   	retq   
    1ee5:	0f 1f 00             	nopl   (%rax)
    1ee8:	48 89 df             	mov    %rbx,%rdi
    1eeb:	e8 c0 e1 ff ff       	callq  b0 <hid_io_error>
    1ef0:	eb d6                	jmp    1ec8 <usbhid_open+0x58>
    1ef2:	ff 8b fc 1a 00 00    	decl   0x1afc(%rbx)
    1ef8:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1eff:	e8 00 00 00 00       	callq  1f04 <usbhid_open+0x94>
    1f04:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
    1f09:	eb d5                	jmp    1ee0 <usbhid_open+0x70>
    1f0b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001f10 <usbhid_wait_io>:
    1f10:	55                   	push   %rbp
    1f11:	48 89 e5             	mov    %rsp,%rbp
    1f14:	41 56                	push   %r14
    1f16:	41 55                	push   %r13
    1f18:	41 54                	push   %r12
    1f1a:	53                   	push   %rbx
    1f1b:	48 83 ec 30          	sub    $0x30,%rsp
    1f1f:	e8 00 00 00 00       	callq  1f24 <usbhid_wait_io+0x14>
    1f24:	48 8b 9f 00 1c 00 00 	mov    0x1c00(%rdi),%rbx
    1f2b:	48 8b 93 90 28 00 00 	mov    0x2890(%rbx),%rdx
    1f32:	48 89 d0             	mov    %rdx,%rax
    1f35:	48 d1 ea             	shr    %rdx
    1f38:	48 c1 e8 02          	shr    $0x2,%rax
    1f3c:	48 09 d0             	or     %rdx,%rax
    1f3f:	a8 01                	test   $0x1,%al
    1f41:	0f 84 a1 00 00 00    	je     1fe8 <usbhid_wait_io+0xd8>
    1f47:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    1f4e:	00 00 
    1f50:	4c 8d 65 b0          	lea    -0x50(%rbp),%r12
    1f54:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    1f58:	48 c7 45 b0 00 00 00 	movq   $0x0,-0x50(%rbp)
    1f5f:	00 
    1f60:	49 8d 44 24 18       	lea    0x18(%r12),%rax
    1f65:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
    1f6c:	00 
    1f6d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    1f71:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    1f75:	4c 8d ab 20 29 00 00 	lea    0x2920(%rbx),%r13
    1f7c:	41 be b8 0b 00 00    	mov    $0xbb8,%r14d
    1f82:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1f88:	ba 02 00 00 00       	mov    $0x2,%edx
    1f8d:	4c 89 e6             	mov    %r12,%rsi
    1f90:	4c 89 ef             	mov    %r13,%rdi
    1f93:	e8 00 00 00 00       	callq  1f98 <usbhid_wait_io+0x88>
    1f98:	48 8b 83 90 28 00 00 	mov    0x2890(%rbx),%rax
    1f9f:	a8 02                	test   $0x2,%al
    1fa1:	75 04                	jne    1fa7 <usbhid_wait_io+0x97>
    1fa3:	a8 04                	test   $0x4,%al
    1fa5:	74 31                	je     1fd8 <usbhid_wait_io+0xc8>
    1fa7:	4c 89 f7             	mov    %r14,%rdi
    1faa:	e8 00 00 00 00       	callq  1faf <usbhid_wait_io+0x9f>
    1faf:	49 89 c6             	mov    %rax,%r14
    1fb2:	48 85 c0             	test   %rax,%rax
    1fb5:	75 d1                	jne    1f88 <usbhid_wait_io+0x78>
    1fb7:	4c 89 e6             	mov    %r12,%rsi
    1fba:	4c 89 ef             	mov    %r13,%rdi
    1fbd:	e8 00 00 00 00       	callq  1fc2 <usbhid_wait_io+0xb2>
    1fc2:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 1fc8 <usbhid_wait_io+0xb8>
    1fc8:	85 c9                	test   %ecx,%ecx
    1fca:	75 2b                	jne    1ff7 <usbhid_wait_io+0xe7>
    1fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1fd1:	eb 17                	jmp    1fea <usbhid_wait_io+0xda>
    1fd3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    1fd8:	4c 89 e6             	mov    %r12,%rsi
    1fdb:	4c 89 ef             	mov    %r13,%rdi
    1fde:	e8 00 00 00 00       	callq  1fe3 <usbhid_wait_io+0xd3>
    1fe3:	4d 85 f6             	test   %r14,%r14
    1fe6:	74 da                	je     1fc2 <usbhid_wait_io+0xb2>
    1fe8:	31 c0                	xor    %eax,%eax
    1fea:	48 83 c4 30          	add    $0x30,%rsp
    1fee:	5b                   	pop    %rbx
    1fef:	41 5c                	pop    %r12
    1ff1:	41 5d                	pop    %r13
    1ff3:	41 5e                	pop    %r14
    1ff5:	c9                   	leaveq 
    1ff6:	c3                   	retq   
    1ff7:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    1ffe:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    2005:	31 c0                	xor    %eax,%eax
    2007:	e8 00 00 00 00       	callq  200c <usbhid_wait_io+0xfc>
    200c:	eb be                	jmp    1fcc <usbhid_wait_io+0xbc>
    200e:	66 90                	xchg   %ax,%ax

0000000000002010 <hid_suspend>:
    2010:	55                   	push   %rbp
    2011:	48 89 e5             	mov    %rsp,%rbp
    2014:	48 83 ec 40          	sub    $0x40,%rsp
    2018:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
    201c:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
    2020:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
    2024:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
    2028:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
    202c:	e8 00 00 00 00       	callq  2031 <hid_suspend+0x21>
    2031:	89 75 c8             	mov    %esi,-0x38(%rbp)
    2034:	48 8d 5f 30          	lea    0x30(%rdi),%rbx
    2038:	48 89 df             	mov    %rbx,%rdi
    203b:	e8 00 00 00 00       	callq  2040 <hid_suspend+0x30>
    2040:	8b 75 c8             	mov    -0x38(%rbp),%esi
    2043:	49 89 c4             	mov    %rax,%r12
    2046:	41 89 f6             	mov    %esi,%r14d
    2049:	4c 8b a8 00 1c 00 00 	mov    0x1c00(%rax),%r13
    2050:	41 81 e6 00 04 00 00 	and    $0x400,%r14d
    2057:	75 47                	jne    20a0 <hid_suspend+0x90>
    2059:	48 8b 80 b8 1a 00 00 	mov    0x1ab8(%rax),%rax
    2060:	48 85 c0             	test   %rax,%rax
    2063:	0f 84 97 01 00 00    	je     2200 <hid_suspend+0x1f0>
    2069:	48 8b 40 70          	mov    0x70(%rax),%rax
    206d:	48 85 c0             	test   %rax,%rax
    2070:	0f 84 8a 01 00 00    	je     2200 <hid_suspend+0x1f0>
    2076:	4c 89 e7             	mov    %r12,%rdi
    2079:	ff d0                	callq  *%rax
    207b:	85 c0                	test   %eax,%eax
    207d:	0f 1f 00             	nopl   (%rax)
    2080:	0f 89 7a 01 00 00    	jns    2200 <hid_suspend+0x1f0>
    2086:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    208a:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
    208e:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
    2092:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
    2096:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
    209a:	c9                   	leaveq 
    209b:	c3                   	retq   
    209c:	0f 1f 40 00          	nopl   0x0(%rax)
    20a0:	4d 8d bd 88 28 00 00 	lea    0x2888(%r13),%r15
    20a7:	4c 89 ff             	mov    %r15,%rdi
    20aa:	e8 00 00 00 00       	callq  20af <hid_suspend+0x9f>
    20af:	49 8b 85 90 28 00 00 	mov    0x2890(%r13),%rax
    20b6:	8b 75 c8             	mov    -0x38(%rbp),%esi
    20b9:	a8 10                	test   $0x10,%al
    20bb:	0f 85 0f 01 00 00    	jne    21d0 <hid_suspend+0x1c0>
    20c1:	a8 40                	test   $0x40,%al
    20c3:	0f 85 07 01 00 00    	jne    21d0 <hid_suspend+0x1c0>
    20c9:	a8 04                	test   $0x4,%al
    20cb:	0f 85 ff 00 00 00    	jne    21d0 <hid_suspend+0x1c0>
    20d1:	a8 02                	test   $0x2,%al
    20d3:	0f 85 f7 00 00 00    	jne    21d0 <hid_suspend+0x1c0>
    20d9:	f6 c4 04             	test   $0x4,%ah
    20dc:	0f 1f 40 00          	nopl   0x0(%rax)
    20e0:	0f 85 ea 00 00 00    	jne    21d0 <hid_suspend+0x1c0>
    20e6:	45 8b 85 38 29 00 00 	mov    0x2938(%r13),%r8d
    20ed:	45 85 c0             	test   %r8d,%r8d
    20f0:	74 0e                	je     2100 <hid_suspend+0xf0>
    20f2:	8b 3d 00 00 00 00    	mov    0x0(%rip),%edi        # 20f8 <hid_suspend+0xe8>
    20f8:	85 ff                	test   %edi,%edi
    20fa:	0f 84 d0 00 00 00    	je     21d0 <hid_suspend+0x1c0>
    2100:	f0 41 80 8d 91 28 00 	lock orb $0x2,0x2891(%r13)
    2107:	00 02 
    2109:	89 75 c8             	mov    %esi,-0x38(%rbp)
    210c:	4c 89 ff             	mov    %r15,%rdi
    210f:	e8 00 00 00 00       	callq  2114 <hid_suspend+0x104>
    2114:	49 8b 84 24 b8 1a 00 	mov    0x1ab8(%r12),%rax
    211b:	00 
    211c:	8b 75 c8             	mov    -0x38(%rbp),%esi
    211f:	48 85 c0             	test   %rax,%rax
    2122:	74 16                	je     213a <hid_suspend+0x12a>
    2124:	48 8b 40 70          	mov    0x70(%rax),%rax
    2128:	48 85 c0             	test   %rax,%rax
    212b:	74 0d                	je     213a <hid_suspend+0x12a>
    212d:	4c 89 e7             	mov    %r12,%rdi
    2130:	ff d0                	callq  *%rax
    2132:	85 c0                	test   %eax,%eax
    2134:	0f 88 4c ff ff ff    	js     2086 <hid_suspend+0x76>
    213a:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 2140 <hid_suspend+0x130>
    2140:	85 f6                	test   %esi,%esi
    2142:	75 34                	jne    2178 <hid_suspend+0x168>
    2144:	45 85 f6             	test   %r14d,%r14d
    2147:	0f 85 f3 00 00 00    	jne    2240 <hid_suspend+0x230>
    214d:	4c 89 ef             	mov    %r13,%rdi
    2150:	e8 4b e9 ff ff       	callq  aa0 <hid_cancel_delayed_stuff>
    2155:	4c 89 ef             	mov    %r13,%rdi
    2158:	e8 c3 e6 ff ff       	callq  820 <hid_cease_io>
    215d:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 2164 <hid_suspend+0x154>
    2164:	0f 85 05 01 00 00    	jne    226f <hid_suspend+0x25f>
    216a:	31 c0                	xor    %eax,%eax
    216c:	e9 15 ff ff ff       	jmpq   2086 <hid_suspend+0x76>
    2171:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2178:	4c 89 ef             	mov    %r13,%rdi
    217b:	e8 20 e9 ff ff       	callq  aa0 <hid_cancel_delayed_stuff>
    2180:	4c 89 ef             	mov    %r13,%rdi
    2183:	e8 98 e6 ff ff       	callq  820 <hid_cease_io>
    2188:	45 85 f6             	test   %r14d,%r14d
    218b:	74 d0                	je     215d <hid_suspend+0x14d>
    218d:	41 f6 85 91 28 00 00 	testb  $0x4,0x2891(%r13)
    2194:	04 
    2195:	74 c6                	je     215d <hid_suspend+0x14d>
    2197:	4c 89 e7             	mov    %r12,%rdi
    219a:	e8 61 de ff ff       	callq  0 <hid_start_in>
    219f:	85 c0                	test   %eax,%eax
    21a1:	0f 88 16 01 00 00    	js     22bd <hid_suspend+0x2ad>
    21a7:	49 8b 45 08          	mov    0x8(%r13),%rax
    21ab:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 21b2 <hid_suspend+0x1a2>
    21b2:	48 8b 40 30          	mov    0x30(%rax),%rax
    21b6:	48 89 90 a8 04 00 00 	mov    %rdx,0x4a8(%rax)
    21bd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
    21c2:	e9 bf fe ff ff       	jmpq   2086 <hid_suspend+0x76>
    21c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    21ce:	00 00 
    21d0:	49 8b 45 08          	mov    0x8(%r13),%rax
    21d4:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 21db <hid_suspend+0x1cb>
    21db:	48 8b 40 30          	mov    0x30(%rax),%rax
    21df:	4c 89 ff             	mov    %r15,%rdi
    21e2:	48 89 90 a8 04 00 00 	mov    %rdx,0x4a8(%rax)
    21e9:	e8 00 00 00 00       	callq  21ee <hid_suspend+0x1de>
    21ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
    21f3:	e9 8e fe ff ff       	jmpq   2086 <hid_suspend+0x76>
    21f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    21ff:	00 
    2200:	4d 8d bd 88 28 00 00 	lea    0x2888(%r13),%r15
    2207:	4c 89 ff             	mov    %r15,%rdi
    220a:	e8 00 00 00 00       	callq  220f <hid_suspend+0x1ff>
    220f:	f0 41 80 8d 91 28 00 	lock orb $0x2,0x2891(%r13)
    2216:	00 02 
    2218:	4c 89 ff             	mov    %r15,%rdi
    221b:	e8 00 00 00 00       	callq  2220 <hid_suspend+0x210>
    2220:	4c 89 e7             	mov    %r12,%rdi
    2223:	e8 00 00 00 00       	callq  2228 <hid_suspend+0x218>
    2228:	89 c2                	mov    %eax,%edx
    222a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
    222f:	85 d2                	test   %edx,%edx
    2231:	0f 89 03 ff ff ff    	jns    213a <hid_suspend+0x12a>
    2237:	e9 4a fe ff ff       	jmpq   2086 <hid_suspend+0x76>
    223c:	0f 1f 40 00          	nopl   0x0(%rax)
    2240:	4c 89 ff             	mov    %r15,%rdi
    2243:	e8 00 00 00 00       	callq  2248 <hid_suspend+0x238>
    2248:	41 f6 85 91 28 00 00 	testb  $0x8,0x2891(%r13)
    224f:	08 
    2250:	75 5e                	jne    22b0 <hid_suspend+0x2a0>
    2252:	4c 89 ff             	mov    %r15,%rdi
    2255:	e8 00 00 00 00       	callq  225a <hid_suspend+0x24a>
    225a:	4c 89 ef             	mov    %r13,%rdi
    225d:	e8 3e e8 ff ff       	callq  aa0 <hid_cancel_delayed_stuff>
    2262:	4c 89 ef             	mov    %r13,%rdi
    2265:	e8 b6 e5 ff ff       	callq  820 <hid_cease_io>
    226a:	e9 1e ff ff ff       	jmpq   218d <hid_suspend+0x17d>
    226f:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 2276 <hid_suspend+0x266>
    2276:	0f 84 ee fe ff ff    	je     216a <hid_suspend+0x15a>
    227c:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 2283 <hid_suspend+0x273>
    2283:	0f 84 e1 fe ff ff    	je     216a <hid_suspend+0x15a>
    2289:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    2290:	48 89 de             	mov    %rbx,%rsi
    2293:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    229a:	31 c0                	xor    %eax,%eax
    229c:	e8 00 00 00 00       	callq  22a1 <hid_suspend+0x291>
    22a1:	31 c0                	xor    %eax,%eax
    22a3:	e9 de fd ff ff       	jmpq   2086 <hid_suspend+0x76>
    22a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    22af:	00 
    22b0:	4c 89 ff             	mov    %r15,%rdi
    22b3:	e8 00 00 00 00       	callq  22b8 <hid_suspend+0x2a8>
    22b8:	e9 ea fe ff ff       	jmpq   21a7 <hid_suspend+0x197>
    22bd:	4c 89 e7             	mov    %r12,%rdi
    22c0:	e8 eb dd ff ff       	callq  b0 <hid_io_error>
    22c5:	e9 dd fe ff ff       	jmpq   21a7 <hid_suspend+0x197>
    22ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000022d0 <usbhid_submit_report>:
    22d0:	55                   	push   %rbp
    22d1:	48 89 e5             	mov    %rsp,%rbp
    22d4:	48 83 ec 50          	sub    $0x50,%rsp
    22d8:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
    22dc:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
    22e0:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
    22e4:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
    22e8:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
    22ec:	e8 00 00 00 00       	callq  22f1 <usbhid_submit_report+0x21>
    22f1:	48 89 f3             	mov    %rsi,%rbx
    22f4:	41 89 d6             	mov    %edx,%r14d
    22f7:	4c 8b bf 00 1c 00 00 	mov    0x1c00(%rdi),%r15
    22fe:	49 89 fc             	mov    %rdi,%r12
    2301:	49 81 c7 88 28 00 00 	add    $0x2888,%r15
    2308:	4c 89 ff             	mov    %r15,%rdi
    230b:	e8 00 00 00 00       	callq  2310 <usbhid_submit_report+0x40>
    2310:	4d 8b ac 24 00 1c 00 	mov    0x1c00(%r12),%r13
    2317:	00 
    2318:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    231c:	8b 53 10             	mov    0x10(%rbx),%edx
    231f:	8b 83 1c 02 00 00    	mov    0x21c(%rbx),%eax
    2325:	41 80 fe 80          	cmp    $0x80,%r14b
    2329:	0f 84 f1 01 00 00    	je     2520 <usbhid_submit_report+0x250>
    232f:	31 ff                	xor    %edi,%edi
    2331:	85 d2                	test   %edx,%edx
    2333:	40 0f 95 c7          	setne  %dil
    2337:	ff c8                	dec    %eax
    2339:	c1 e8 03             	shr    $0x3,%eax
    233c:	45 84 f6             	test   %r14b,%r14b
    233f:	8d 7c 07 01          	lea    0x1(%rdi,%rax,1),%edi
    2343:	40 0f 94 c6          	sete   %sil
    2347:	0f 84 eb 00 00 00    	je     2438 <usbhid_submit_report+0x168>
    234d:	41 0f b6 95 40 18 00 	movzbl 0x1840(%r13),%edx
    2354:	00 
    2355:	8d 4a 01             	lea    0x1(%rdx),%ecx
    2358:	0f b6 c1             	movzbl %cl,%eax
    235b:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    235e:	41 38 8d 41 18 00 00 	cmp    %cl,0x1841(%r13)
    2365:	0f 84 05 02 00 00    	je     2570 <usbhid_submit_report+0x2a0>
    236b:	40 84 f6             	test   %sil,%sil
    236e:	74 49                	je     23b9 <usbhid_submit_report+0xe9>
    2370:	be 20 00 00 00       	mov    $0x20,%esi
    2375:	89 55 b8             	mov    %edx,-0x48(%rbp)
    2378:	48 63 ff             	movslq %edi,%rdi
    237b:	e8 00 00 00 00       	callq  2380 <usbhid_submit_report+0xb0>
    2380:	8b 55 b8             	mov    -0x48(%rbp),%edx
    2383:	48 63 d2             	movslq %edx,%rdx
    2386:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    238a:	49 89 44 d5 50       	mov    %rax,0x50(%r13,%rdx,8)
    238f:	41 0f b6 85 40 18 00 	movzbl 0x1840(%r13),%eax
    2396:	00 
    2397:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    239b:	49 8b 74 c5 50       	mov    0x50(%r13,%rax,8),%rsi
    23a0:	48 85 f6             	test   %rsi,%rsi
    23a3:	0f 84 07 02 00 00    	je     25b0 <usbhid_submit_report+0x2e0>
    23a9:	48 89 df             	mov    %rbx,%rdi
    23ac:	e8 00 00 00 00       	callq  23b1 <usbhid_submit_report+0xe1>
    23b1:	41 0f b6 95 40 18 00 	movzbl 0x1840(%r13),%edx
    23b8:	00 
    23b9:	48 63 d2             	movslq %edx,%rdx
    23bc:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
    23c0:	49 89 5c c5 48       	mov    %rbx,0x48(%r13,%rax,8)
    23c5:	41 0f b6 85 40 18 00 	movzbl 0x1840(%r13),%eax
    23cc:	00 
    23cd:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    23d1:	45 88 74 c5 40       	mov    %r14b,0x40(%r13,%rax,8)
    23d6:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
    23da:	41 88 85 40 18 00 00 	mov    %al,0x1840(%r13)
    23e1:	f0 41 0f ba ad 90 28 	lock btsl $0x1,0x2890(%r13)
    23e8:	00 00 01 
    23eb:	19 c0                	sbb    %eax,%eax
    23ed:	85 c0                	test   %eax,%eax
    23ef:	0f 84 43 01 00 00    	je     2538 <usbhid_submit_report+0x268>
    23f5:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 23fc <usbhid_submit_report+0x12c>
    23fc:	49 8b 95 58 18 00 00 	mov    0x1858(%r13),%rdx
    2403:	48 81 c2 dc 05 00 00 	add    $0x5dc,%rdx
    240a:	48 39 c2             	cmp    %rax,%rdx
    240d:	0f 88 4d 01 00 00    	js     2560 <usbhid_submit_report+0x290>
    2413:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    2417:	4c 89 ff             	mov    %r15,%rdi
    241a:	e8 00 00 00 00       	callq  241f <usbhid_submit_report+0x14f>
    241f:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    2423:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
    2427:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
    242b:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
    242f:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
    2433:	c9                   	leaveq 
    2434:	c3                   	retq   
    2435:	0f 1f 00             	nopl   (%rax)
    2438:	49 83 bd 60 18 00 00 	cmpq   $0x0,0x1860(%r13)
    243f:	00 
    2440:	0f 84 07 ff ff ff    	je     234d <usbhid_submit_report+0x7d>
    2446:	83 7b 14 01          	cmpl   $0x1,0x14(%rbx)
    244a:	0f 85 fd fe ff ff    	jne    234d <usbhid_submit_report+0x7d>
    2450:	41 0f b6 95 68 28 00 	movzbl 0x2868(%r13),%edx
    2457:	00 
    2458:	41 0f b6 85 69 28 00 	movzbl 0x2869(%r13),%eax
    245f:	00 
    2460:	44 8d 72 01          	lea    0x1(%rdx),%r14d
    2464:	41 83 e6 3f          	and    $0x3f,%r14d
    2468:	41 39 c6             	cmp    %eax,%r14d
    246b:	0f 84 75 01 00 00    	je     25e6 <usbhid_submit_report+0x316>
    2471:	be 20 00 00 00       	mov    $0x20,%esi
    2476:	89 55 b8             	mov    %edx,-0x48(%rbp)
    2479:	48 63 ff             	movslq %edi,%rdi
    247c:	e8 00 00 00 00       	callq  2481 <usbhid_submit_report+0x1b1>
    2481:	8b 55 b8             	mov    -0x48(%rbp),%edx
    2484:	48 63 d2             	movslq %edx,%rdx
    2487:	48 c1 e2 04          	shl    $0x4,%rdx
    248b:	49 89 84 15 70 18 00 	mov    %rax,0x1870(%r13,%rdx,1)
    2492:	00 
    2493:	41 0f b6 85 68 28 00 	movzbl 0x2868(%r13),%eax
    249a:	00 
    249b:	48 c1 e0 04          	shl    $0x4,%rax
    249f:	49 8b b4 05 70 18 00 	mov    0x1870(%r13,%rax,1),%rsi
    24a6:	00 
    24a7:	48 85 f6             	test   %rsi,%rsi
    24aa:	0f 84 1b 01 00 00    	je     25cb <usbhid_submit_report+0x2fb>
    24b0:	48 89 df             	mov    %rbx,%rdi
    24b3:	e8 00 00 00 00       	callq  24b8 <usbhid_submit_report+0x1e8>
    24b8:	41 0f b6 85 68 28 00 	movzbl 0x2868(%r13),%eax
    24bf:	00 
    24c0:	48 c1 e0 04          	shl    $0x4,%rax
    24c4:	49 89 9c 05 68 18 00 	mov    %rbx,0x1868(%r13,%rax,1)
    24cb:	00 
    24cc:	45 88 b5 68 28 00 00 	mov    %r14b,0x2868(%r13)
    24d3:	f0 41 0f ba ad 90 28 	lock btsl $0x2,0x2890(%r13)
    24da:	00 00 02 
    24dd:	19 c0                	sbb    %eax,%eax
    24df:	85 c0                	test   %eax,%eax
    24e1:	0f 84 a9 00 00 00    	je     2590 <usbhid_submit_report+0x2c0>
    24e7:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 24ee <usbhid_submit_report+0x21e>
    24ee:	49 8b 95 80 28 00 00 	mov    0x2880(%r13),%rdx
    24f5:	48 81 c2 dc 05 00 00 	add    $0x5dc,%rdx
    24fc:	48 39 c2             	cmp    %rax,%rdx
    24ff:	0f 89 0e ff ff ff    	jns    2413 <usbhid_submit_report+0x143>
    2505:	49 8b bd 60 18 00 00 	mov    0x1860(%r13),%rdi
    250c:	e8 00 00 00 00       	callq  2511 <usbhid_submit_report+0x241>
    2511:	e9 fd fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    2516:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    251d:	00 00 00 
    2520:	41 f6 84 24 d0 1a 00 	testb  $0x8,0x1ad0(%r12)
    2527:	00 08 
    2529:	0f 84 00 fe ff ff    	je     232f <usbhid_submit_report+0x5f>
    252f:	90                   	nop
    2530:	e9 de fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    2535:	0f 1f 00             	nopl   (%rax)
    2538:	4c 89 e7             	mov    %r12,%rdi
    253b:	e8 c0 dd ff ff       	callq  300 <hid_submit_ctrl>
    2540:	85 c0                	test   %eax,%eax
    2542:	0f 84 cb fe ff ff    	je     2413 <usbhid_submit_report+0x143>
    2548:	f0 41 80 a5 90 28 00 	lock andb $0xfd,0x2890(%r13)
    254f:	00 fd 
    2551:	e9 bd fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    2556:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    255d:	00 00 00 
    2560:	49 8b 7d 30          	mov    0x30(%r13),%rdi
    2564:	e8 00 00 00 00       	callq  2569 <usbhid_submit_report+0x299>
    2569:	e9 a5 fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    256e:	66 90                	xchg   %ax,%ax
    2570:	49 8d bc 24 88 18 00 	lea    0x1888(%r12),%rdi
    2577:	00 
    2578:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    257f:	31 c0                	xor    %eax,%eax
    2581:	e8 00 00 00 00       	callq  2586 <usbhid_submit_report+0x2b6>
    2586:	e9 88 fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    258b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2590:	4c 89 e7             	mov    %r12,%rdi
    2593:	e8 38 dc ff ff       	callq  1d0 <hid_submit_out>
    2598:	85 c0                	test   %eax,%eax
    259a:	0f 84 73 fe ff ff    	je     2413 <usbhid_submit_report+0x143>
    25a0:	f0 41 80 a5 90 28 00 	lock andb $0xfb,0x2890(%r13)
    25a7:	00 fb 
    25a9:	e9 65 fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    25ae:	66 90                	xchg   %ax,%ax
    25b0:	49 8d bc 24 88 18 00 	lea    0x1888(%r12),%rdi
    25b7:	00 
    25b8:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    25bf:	31 c0                	xor    %eax,%eax
    25c1:	e8 00 00 00 00       	callq  25c6 <usbhid_submit_report+0x2f6>
    25c6:	e9 48 fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    25cb:	49 8d bc 24 88 18 00 	lea    0x1888(%r12),%rdi
    25d2:	00 
    25d3:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    25da:	31 c0                	xor    %eax,%eax
    25dc:	e8 00 00 00 00       	callq  25e1 <usbhid_submit_report+0x311>
    25e1:	e9 2d fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    25e6:	49 8d bc 24 88 18 00 	lea    0x1888(%r12),%rdi
    25ed:	00 
    25ee:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    25f5:	31 c0                	xor    %eax,%eax
    25f7:	e8 00 00 00 00       	callq  25fc <usbhid_submit_report+0x32c>
    25fc:	e9 12 fe ff ff       	jmpq   2413 <usbhid_submit_report+0x143>
    2601:	66 66 66 66 66 66 2e 	nopw   %cs:0x0(%rax,%rax,1)
    2608:	0f 1f 84 00 00 00 00 
    260f:	00 

0000000000002610 <usb_hidinput_input_event>:
    2610:	55                   	push   %rbp
    2611:	48 89 e5             	mov    %rsp,%rbp
    2614:	48 83 ec 50          	sub    $0x50,%rsp
    2618:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
    261c:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
    2620:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
    2624:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
    2628:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
    262c:	e8 00 00 00 00       	callq  2631 <usb_hidinput_input_event+0x21>
    2631:	89 55 b0             	mov    %edx,-0x50(%rbp)
    2634:	89 75 b8             	mov    %esi,-0x48(%rbp)
    2637:	48 89 fb             	mov    %rdi,%rbx
    263a:	41 89 ce             	mov    %ecx,%r14d
    263d:	4c 8d af 28 02 00 00 	lea    0x228(%rdi),%r13
    2644:	4c 89 ef             	mov    %r13,%rdi
    2647:	e8 00 00 00 00       	callq  264c <usb_hidinput_input_event+0x3c>
    264c:	8b 75 b8             	mov    -0x48(%rbp),%esi
    264f:	49 89 c4             	mov    %rax,%r12
    2652:	4c 8b b8 00 1c 00 00 	mov    0x1c00(%rax),%r15
    2659:	83 fe 15             	cmp    $0x15,%esi
    265c:	8b 55 b0             	mov    -0x50(%rbp),%edx
    265f:	75 27                	jne    2688 <usb_hidinput_input_event+0x78>
    2661:	44 89 f1             	mov    %r14d,%ecx
    2664:	48 89 df             	mov    %rbx,%rdi
    2667:	e8 00 00 00 00       	callq  266c <usb_hidinput_input_event+0x5c>
    266c:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    2670:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
    2674:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
    2678:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
    267c:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
    2680:	c9                   	leaveq 
    2681:	c3                   	retq   
    2682:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    268d:	83 fe 11             	cmp    $0x11,%esi
    2690:	75 da                	jne    266c <usb_hidinput_input_event+0x5c>
    2692:	48 8d 4d c8          	lea    -0x38(%rbp),%rcx
    2696:	4c 89 e7             	mov    %r12,%rdi
    2699:	e8 00 00 00 00       	callq  269e <usb_hidinput_input_event+0x8e>
    269e:	89 c3                	mov    %eax,%ebx
    26a0:	83 f8 ff             	cmp    $0xffffffffffffffff,%eax
    26a3:	74 76                	je     271b <usb_hidinput_input_event+0x10b>
    26a5:	44 89 f2             	mov    %r14d,%edx
    26a8:	89 c6                	mov    %eax,%esi
    26aa:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
    26ae:	e8 00 00 00 00       	callq  26b3 <usb_hidinput_input_event+0xa3>
    26b3:	45 85 f6             	test   %r14d,%r14d
    26b6:	74 40                	je     26f8 <usb_hidinput_input_event+0xe8>
    26b8:	49 8d 9f 88 28 00 00 	lea    0x2888(%r15),%rbx
    26bf:	48 89 df             	mov    %rbx,%rdi
    26c2:	e8 00 00 00 00       	callq  26c7 <usb_hidinput_input_event+0xb7>
    26c7:	41 ff 87 38 29 00 00 	incl   0x2938(%r15)
    26ce:	48 89 c6             	mov    %rax,%rsi
    26d1:	48 89 df             	mov    %rbx,%rdi
    26d4:	e8 00 00 00 00       	callq  26d9 <usb_hidinput_input_event+0xc9>
    26d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    26dd:	31 d2                	xor    %edx,%edx
    26df:	48 8b 70 50          	mov    0x50(%rax),%rsi
    26e3:	4c 89 e7             	mov    %r12,%rdi
    26e6:	e8 00 00 00 00       	callq  26eb <usb_hidinput_input_event+0xdb>
    26eb:	31 c0                	xor    %eax,%eax
    26ed:	e9 7a ff ff ff       	jmpq   266c <usb_hidinput_input_event+0x5c>
    26f2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    26f8:	49 8d 9f 88 28 00 00 	lea    0x2888(%r15),%rbx
    26ff:	48 89 df             	mov    %rbx,%rdi
    2702:	e8 00 00 00 00       	callq  2707 <usb_hidinput_input_event+0xf7>
    2707:	41 ff 8f 38 29 00 00 	decl   0x2938(%r15)
    270e:	48 89 c6             	mov    %rax,%rsi
    2711:	48 89 df             	mov    %rbx,%rdi
    2714:	e8 00 00 00 00       	callq  2719 <usb_hidinput_input_event+0x109>
    2719:	eb be                	jmp    26d9 <usb_hidinput_input_event+0xc9>
    271b:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    2722:	4c 89 ef             	mov    %r13,%rdi
    2725:	31 c0                	xor    %eax,%eax
    2727:	e8 00 00 00 00       	callq  272c <usb_hidinput_input_event+0x11c>
    272c:	89 d8                	mov    %ebx,%eax
    272e:	e9 39 ff ff ff       	jmpq   266c <usb_hidinput_input_event+0x5c>
    2733:	66 66 66 66 2e 0f 1f 	nopw   %cs:0x0(%rax,%rax,1)
    273a:	84 00 00 00 00 00 

0000000000002740 <usbhid_set_leds>:
    2740:	55                   	push   %rbp
    2741:	48 89 e5             	mov    %rsp,%rbp
    2744:	41 55                	push   %r13
    2746:	41 54                	push   %r12
    2748:	53                   	push   %rbx
    2749:	48 83 ec 08          	sub    $0x8,%rsp
    274d:	e8 00 00 00 00       	callq  2752 <usbhid_set_leds+0x12>
    2752:	49 89 fc             	mov    %rdi,%r12
    2755:	4c 8b 87 60 08 00 00 	mov    0x860(%rdi),%r8
    275c:	4c 8d af 60 08 00 00 	lea    0x860(%rdi),%r13
    2763:	4d 8b 18             	mov    (%r8),%r11
    2766:	4d 39 e8             	cmp    %r13,%r8
    2769:	41 0f 18 0b          	prefetcht0 (%r11)
    276d:	74 69                	je     27d8 <usbhid_set_leds+0x98>
    276f:	45 8b 90 18 02 00 00 	mov    0x218(%r8),%r10d
    2776:	45 31 c9             	xor    %r9d,%r9d
    2779:	45 85 d2             	test   %r10d,%r10d
    277c:	74 76                	je     27f4 <usbhid_set_leds+0xb4>
    277e:	49 8b 58 18          	mov    0x18(%r8),%rbx
    2782:	8b 4b 18             	mov    0x18(%rbx),%ecx
    2785:	85 c9                	test   %ecx,%ecx
    2787:	74 5f                	je     27e8 <usbhid_set_leds+0xa8>
    2789:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
    278d:	31 f6                	xor    %esi,%esi
    278f:	eb 0d                	jmp    279e <usbhid_set_leds+0x5e>
    2791:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2798:	ff c6                	inc    %esi
    279a:	39 ce                	cmp    %ecx,%esi
    279c:	73 4a                	jae    27e8 <usbhid_set_leds+0xa8>
    279e:	48 63 c6             	movslq %esi,%rax
    27a1:	48 c1 e0 04          	shl    $0x4,%rax
    27a5:	8b 04 38             	mov    (%rax,%rdi,1),%eax
    27a8:	89 c2                	mov    %eax,%edx
    27aa:	66 31 d2             	xor    %dx,%dx
    27ad:	81 fa 00 00 08 00    	cmp    $0x80000,%edx
    27b3:	75 e3                	jne    2798 <usbhid_set_leds+0x58>
    27b5:	66 83 f8 01          	cmp    $0x1,%ax
    27b9:	75 dd                	jne    2798 <usbhid_set_leds+0x58>
    27bb:	83 fe ff             	cmp    $0xffffffffffffffff,%esi
    27be:	74 18                	je     27d8 <usbhid_set_leds+0x98>
    27c0:	31 d2                	xor    %edx,%edx
    27c2:	48 89 df             	mov    %rbx,%rdi
    27c5:	e8 00 00 00 00       	callq  27ca <usbhid_set_leds+0x8a>
    27ca:	48 8b 73 50          	mov    0x50(%rbx),%rsi
    27ce:	31 d2                	xor    %edx,%edx
    27d0:	4c 89 e7             	mov    %r12,%rdi
    27d3:	e8 00 00 00 00       	callq  27d8 <usbhid_set_leds+0x98>
    27d8:	48 83 c4 08          	add    $0x8,%rsp
    27dc:	5b                   	pop    %rbx
    27dd:	41 5c                	pop    %r12
    27df:	41 5d                	pop    %r13
    27e1:	c9                   	leaveq 
    27e2:	c3                   	retq   
    27e3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    27e8:	41 ff c1             	inc    %r9d
    27eb:	49 83 c0 08          	add    $0x8,%r8
    27ef:	45 39 ca             	cmp    %r9d,%r10d
    27f2:	77 8a                	ja     277e <usbhid_set_leds+0x3e>
    27f4:	4d 89 d8             	mov    %r11,%r8
    27f7:	e9 67 ff ff ff       	jmpq   2763 <usbhid_set_leds+0x23>
    27fc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000002800 <usbhid_init_reports>:
    2800:	55                   	push   %rbp
    2801:	48 89 e5             	mov    %rsp,%rbp
    2804:	41 56                	push   %r14
    2806:	41 55                	push   %r13
    2808:	41 54                	push   %r12
    280a:	53                   	push   %rbx
    280b:	e8 00 00 00 00       	callq  2810 <usbhid_init_reports+0x10>
    2810:	48 89 fb             	mov    %rdi,%rbx
    2813:	4c 8b a7 00 1c 00 00 	mov    0x1c00(%rdi),%r12
    281a:	4c 8b 6f 48          	mov    0x48(%rdi),%r13
    281e:	4c 8d 77 48          	lea    0x48(%rdi),%r14
    2822:	eb 18                	jmp    283c <usbhid_init_reports+0x3c>
    2824:	0f 1f 40 00          	nopl   0x0(%rax)
    2828:	4c 89 ee             	mov    %r13,%rsi
    282b:	ba 80 00 00 00       	mov    $0x80,%edx
    2830:	48 89 df             	mov    %rbx,%rdi
    2833:	e8 00 00 00 00       	callq  2838 <usbhid_init_reports+0x38>
    2838:	4d 8b 6d 00          	mov    0x0(%r13),%r13
    283c:	49 8b 45 00          	mov    0x0(%r13),%rax
    2840:	4d 39 f5             	cmp    %r14,%r13
    2843:	0f 18 08             	prefetcht0 (%rax)
    2846:	75 e0                	jne    2828 <usbhid_init_reports+0x28>
    2848:	4c 8b ab 78 10 00 00 	mov    0x1078(%rbx),%r13
    284f:	4c 8d b3 78 10 00 00 	lea    0x1078(%rbx),%r14
    2856:	eb 1c                	jmp    2874 <usbhid_init_reports+0x74>
    2858:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    285f:	00 
    2860:	4c 89 ee             	mov    %r13,%rsi
    2863:	ba 80 00 00 00       	mov    $0x80,%edx
    2868:	48 89 df             	mov    %rbx,%rdi
    286b:	e8 00 00 00 00       	callq  2870 <usbhid_init_reports+0x70>
    2870:	4d 8b 6d 00          	mov    0x0(%r13),%r13
    2874:	49 8b 45 00          	mov    0x0(%r13),%rax
    2878:	4d 39 f5             	cmp    %r14,%r13
    287b:	0f 18 08             	prefetcht0 (%rax)
    287e:	75 e0                	jne    2860 <usbhid_init_reports+0x60>
    2880:	48 89 df             	mov    %rbx,%rdi
    2883:	e8 00 00 00 00       	callq  2888 <usbhid_init_reports+0x88>
    2888:	85 c0                	test   %eax,%eax
    288a:	74 60                	je     28ec <usbhid_init_reports+0xec>
    288c:	45 31 ed             	xor    %r13d,%r13d
    288f:	90                   	nop
    2890:	eb 17                	jmp    28a9 <usbhid_init_reports+0xa9>
    2892:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2898:	a8 04                	test   $0x4,%al
    289a:	75 32                	jne    28ce <usbhid_init_reports+0xce>
    289c:	48 89 df             	mov    %rbx,%rdi
    289f:	90                   	nop
    28a0:	e8 00 00 00 00       	callq  28a5 <usbhid_init_reports+0xa5>
    28a5:	85 c0                	test   %eax,%eax
    28a7:	74 3e                	je     28e7 <usbhid_init_reports+0xe7>
    28a9:	41 09 c5             	or     %eax,%r13d
    28ac:	49 8b 84 24 90 28 00 	mov    0x2890(%r12),%rax
    28b3:	00 
    28b4:	a8 02                	test   $0x2,%al
    28b6:	74 e0                	je     2898 <usbhid_init_reports+0x98>
    28b8:	49 8b 7c 24 30       	mov    0x30(%r12),%rdi
    28bd:	e8 00 00 00 00       	callq  28c2 <usbhid_init_reports+0xc2>
    28c2:	49 8b 84 24 90 28 00 	mov    0x2890(%r12),%rax
    28c9:	00 
    28ca:	a8 04                	test   $0x4,%al
    28cc:	74 ce                	je     289c <usbhid_init_reports+0x9c>
    28ce:	49 8b bc 24 60 18 00 	mov    0x1860(%r12),%rdi
    28d5:	00 
    28d6:	e8 00 00 00 00       	callq  28db <usbhid_init_reports+0xdb>
    28db:	48 89 df             	mov    %rbx,%rdi
    28de:	e8 00 00 00 00       	callq  28e3 <usbhid_init_reports+0xe3>
    28e3:	85 c0                	test   %eax,%eax
    28e5:	75 c2                	jne    28a9 <usbhid_init_reports+0xa9>
    28e7:	45 85 ed             	test   %r13d,%r13d
    28ea:	75 0c                	jne    28f8 <usbhid_init_reports+0xf8>
    28ec:	5b                   	pop    %rbx
    28ed:	41 5c                	pop    %r12
    28ef:	41 5d                	pop    %r13
    28f1:	41 5e                	pop    %r14
    28f3:	c9                   	leaveq 
    28f4:	c3                   	retq   
    28f5:	0f 1f 00             	nopl   (%rax)
    28f8:	48 8d bb 88 18 00 00 	lea    0x1888(%rbx),%rdi
    28ff:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    2906:	e8 00 00 00 00       	callq  290b <usbhid_init_reports+0x10b>
    290b:	5b                   	pop    %rbx
    290c:	41 5c                	pop    %r12
    290e:	41 5d                	pop    %r13
    2910:	41 5e                	pop    %r14
    2912:	c9                   	leaveq 
    2913:	c3                   	retq   
    2914:	66 66 66 2e 0f 1f 84 	nopw   %cs:0x0(%rax,%rax,1)
    291b:	00 00 00 00 00 

0000000000002920 <usbhid_start>:
    2920:	55                   	push   %rbp
    2921:	48 89 e5             	mov    %rsp,%rbp
    2924:	41 57                	push   %r15
    2926:	41 56                	push   %r14
    2928:	41 55                	push   %r13
    292a:	41 54                	push   %r12
    292c:	53                   	push   %rbx
    292d:	48 83 ec 48          	sub    $0x48,%rsp
    2931:	e8 00 00 00 00       	callq  2936 <usbhid_start+0x16>
    2936:	48 8b 87 88 18 00 00 	mov    0x1888(%rdi),%rax
    293d:	4c 8b a7 00 1c 00 00 	mov    0x1c00(%rdi),%r12
    2944:	4c 8b 10             	mov    (%rax),%r10
    2947:	4c 8b 78 d8          	mov    -0x28(%rax),%r15
    294b:	48 89 fb             	mov    %rdi,%rbx
    294e:	49 8d 84 24 90 28 00 	lea    0x2890(%r12),%rax
    2955:	00 
    2956:	49 81 ea 88 00 00 00 	sub    $0x88,%r10
    295d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    2961:	f0 41 80 a4 24 90 28 	lock andb $0x7f,0x2890(%r12)
    2968:	00 00 7f 
    296b:	b8 40 00 00 00       	mov    $0x40,%eax
    2970:	41 c7 44 24 14 40 00 	movl   $0x40,0x14(%r12)
    2977:	00 00 
    2979:	48 8d 77 48          	lea    0x48(%rdi),%rsi
    297d:	48 8b 57 48          	mov    0x48(%rdi),%rdx
    2981:	eb 2d                	jmp    29b0 <usbhid_start+0x90>
    2983:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2988:	44 8b 43 40          	mov    0x40(%rbx),%r8d
    298c:	8b 8a 1c 02 00 00    	mov    0x21c(%rdx),%ecx
    2992:	ff c9                	dec    %ecx
    2994:	c1 e9 03             	shr    $0x3,%ecx
    2997:	41 8d 4c 08 01       	lea    0x1(%r8,%rcx,1),%ecx
    299c:	39 c1                	cmp    %eax,%ecx
    299e:	76 08                	jbe    29a8 <usbhid_start+0x88>
    29a0:	41 89 4c 24 14       	mov    %ecx,0x14(%r12)
    29a5:	48 8b 3a             	mov    (%rdx),%rdi
    29a8:	48 89 fa             	mov    %rdi,%rdx
    29ab:	41 8b 44 24 14       	mov    0x14(%r12),%eax
    29b0:	48 8b 3a             	mov    (%rdx),%rdi
    29b3:	48 39 f2             	cmp    %rsi,%rdx
    29b6:	0f 18 0f             	prefetcht0 (%rdi)
    29b9:	75 cd                	jne    2988 <usbhid_start+0x68>
    29bb:	48 8b 93 60 08 00 00 	mov    0x860(%rbx),%rdx
    29c2:	4c 8d 8b 60 08 00 00 	lea    0x860(%rbx),%r9
    29c9:	eb 30                	jmp    29fb <usbhid_start+0xdb>
    29cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    29d0:	44 8b 83 58 08 00 00 	mov    0x858(%rbx),%r8d
    29d7:	8b 8a 1c 02 00 00    	mov    0x21c(%rdx),%ecx
    29dd:	ff c9                	dec    %ecx
    29df:	c1 e9 03             	shr    $0x3,%ecx
    29e2:	41 8d 4c 08 01       	lea    0x1(%r8,%rcx,1),%ecx
    29e7:	39 c1                	cmp    %eax,%ecx
    29e9:	76 08                	jbe    29f3 <usbhid_start+0xd3>
    29eb:	41 89 4c 24 14       	mov    %ecx,0x14(%r12)
    29f0:	48 8b 3a             	mov    (%rdx),%rdi
    29f3:	48 89 fa             	mov    %rdi,%rdx
    29f6:	41 8b 44 24 14       	mov    0x14(%r12),%eax
    29fb:	48 8b 3a             	mov    (%rdx),%rdi
    29fe:	4c 39 ca             	cmp    %r9,%rdx
    2a01:	0f 18 0f             	prefetcht0 (%rdi)
    2a04:	75 ca                	jne    29d0 <usbhid_start+0xb0>
    2a06:	48 8b 93 78 10 00 00 	mov    0x1078(%rbx),%rdx
    2a0d:	4c 8d 8b 78 10 00 00 	lea    0x1078(%rbx),%r9
    2a14:	eb 35                	jmp    2a4b <usbhid_start+0x12b>
    2a16:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a1d:	00 00 00 
    2a20:	44 8b 83 70 10 00 00 	mov    0x1070(%rbx),%r8d
    2a27:	8b 8a 1c 02 00 00    	mov    0x21c(%rdx),%ecx
    2a2d:	ff c9                	dec    %ecx
    2a2f:	c1 e9 03             	shr    $0x3,%ecx
    2a32:	41 8d 4c 08 01       	lea    0x1(%r8,%rcx,1),%ecx
    2a37:	39 c1                	cmp    %eax,%ecx
    2a39:	76 08                	jbe    2a43 <usbhid_start+0x123>
    2a3b:	41 89 4c 24 14       	mov    %ecx,0x14(%r12)
    2a40:	48 8b 3a             	mov    (%rdx),%rdi
    2a43:	48 89 fa             	mov    %rdi,%rdx
    2a46:	41 8b 44 24 14       	mov    0x14(%r12),%eax
    2a4b:	48 8b 3a             	mov    (%rdx),%rdi
    2a4e:	4c 39 ca             	cmp    %r9,%rdx
    2a51:	0f 18 0f             	prefetcht0 (%rdi)
    2a54:	75 ca                	jne    2a20 <usbhid_start+0x100>
    2a56:	3d 00 10 00 00       	cmp    $0x1000,%eax
    2a5b:	76 09                	jbe    2a66 <usbhid_start+0x146>
    2a5d:	41 c7 44 24 14 00 10 	movl   $0x1000,0x14(%r12)
    2a64:	00 00 
    2a66:	48 8b 43 48          	mov    0x48(%rbx),%rax
    2a6a:	31 d2                	xor    %edx,%edx
    2a6c:	eb 1c                	jmp    2a8a <usbhid_start+0x16a>
    2a6e:	66 90                	xchg   %ax,%ax
    2a70:	8b 7b 40             	mov    0x40(%rbx),%edi
    2a73:	8b 80 1c 02 00 00    	mov    0x21c(%rax),%eax
    2a79:	ff c8                	dec    %eax
    2a7b:	c1 e8 03             	shr    $0x3,%eax
    2a7e:	8d 44 07 01          	lea    0x1(%rdi,%rax,1),%eax
    2a82:	39 c2                	cmp    %eax,%edx
    2a84:	0f 42 d0             	cmovb  %eax,%edx
    2a87:	48 89 c8             	mov    %rcx,%rax
    2a8a:	48 8b 08             	mov    (%rax),%rcx
    2a8d:	48 39 c6             	cmp    %rax,%rsi
    2a90:	0f 18 09             	prefetcht0 (%rcx)
    2a93:	75 db                	jne    2a70 <usbhid_start+0x150>
    2a95:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%rbp)
    2a9c:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
    2aa2:	4c 89 d7             	mov    %r10,%rdi
    2aa5:	0f 47 55 cc          	cmova  -0x34(%rbp),%edx
    2aa9:	89 55 cc             	mov    %edx,-0x34(%rbp)
    2aac:	ba d0 00 00 00       	mov    $0xd0,%edx
    2ab1:	4c 8b ab 00 1c 00 00 	mov    0x1c00(%rbx),%r13
    2ab8:	41 8b 75 14          	mov    0x14(%r13),%esi
    2abc:	49 8d 4d 28          	lea    0x28(%r13),%rcx
    2ac0:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2ac4:	e8 00 00 00 00       	callq  2ac9 <usbhid_start+0x1a9>
    2ac9:	49 8d 8d 78 28 00 00 	lea    0x2878(%r13),%rcx
    2ad0:	49 89 45 20          	mov    %rax,0x20(%r13)
    2ad4:	41 8b 75 14          	mov    0x14(%r13),%esi
    2ad8:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2adc:	ba d0 00 00 00       	mov    $0xd0,%edx
    2ae1:	4c 89 d7             	mov    %r10,%rdi
    2ae4:	e8 00 00 00 00       	callq  2ae9 <usbhid_start+0x1c9>
    2ae9:	be d0 00 00 00       	mov    $0xd0,%esi
    2aee:	49 89 85 70 28 00 00 	mov    %rax,0x2870(%r13)
    2af5:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    2afc:	e8 00 00 00 00       	callq  2b01 <usbhid_start+0x1e1>
    2b01:	44 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9d        # 2b08 <usbhid_start+0x1e8>
    2b08:	4c 63 35 00 00 00 00 	movslq 0x0(%rip),%r14        # 2b0f <usbhid_start+0x1ef>
    2b0f:	45 85 c9             	test   %r9d,%r9d
    2b12:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2b16:	0f 85 32 04 00 00    	jne    2f4e <usbhid_start+0x62e>
    2b1c:	49 89 45 38          	mov    %rax,0x38(%r13)
    2b20:	41 8b 75 14          	mov    0x14(%r13),%esi
    2b24:	4c 89 d7             	mov    %r10,%rdi
    2b27:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2b2b:	49 8d 8d 50 18 00 00 	lea    0x1850(%r13),%rcx
    2b32:	ba d0 00 00 00       	mov    $0xd0,%edx
    2b37:	e8 00 00 00 00       	callq  2b3c <usbhid_start+0x21c>
    2b3c:	49 83 7d 20 00       	cmpq   $0x0,0x20(%r13)
    2b41:	49 89 85 48 18 00 00 	mov    %rax,0x1848(%r13)
    2b48:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2b4c:	75 69                	jne    2bb7 <usbhid_start+0x297>
    2b4e:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
    2b53:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2b57:	e8 00 00 00 00       	callq  2b5c <usbhid_start+0x23c>
    2b5c:	49 8b bc 24 60 18 00 	mov    0x1860(%r12),%rdi
    2b63:	00 
    2b64:	e8 00 00 00 00       	callq  2b69 <usbhid_start+0x249>
    2b69:	49 8b 7c 24 30       	mov    0x30(%r12),%rdi
    2b6e:	e8 00 00 00 00       	callq  2b73 <usbhid_start+0x253>
    2b73:	49 c7 44 24 18 00 00 	movq   $0x0,0x18(%r12)
    2b7a:	00 00 
    2b7c:	49 c7 84 24 60 18 00 	movq   $0x0,0x1860(%r12)
    2b83:	00 00 00 00 00 
    2b88:	49 c7 44 24 30 00 00 	movq   $0x0,0x30(%r12)
    2b8f:	00 00 
    2b91:	48 89 de             	mov    %rbx,%rsi
    2b94:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2b98:	4c 89 d7             	mov    %r10,%rdi
    2b9b:	e8 40 e4 ff ff       	callq  fe0 <hid_free_buffers>
    2ba0:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    2ba5:	0f 1f 00             	nopl   (%rax)
    2ba8:	48 83 c4 48          	add    $0x48,%rsp
    2bac:	5b                   	pop    %rbx
    2bad:	41 5c                	pop    %r12
    2baf:	41 5d                	pop    %r13
    2bb1:	41 5e                	pop    %r14
    2bb3:	41 5f                	pop    %r15
    2bb5:	c9                   	leaveq 
    2bb6:	c3                   	retq   
    2bb7:	49 83 bd 70 28 00 00 	cmpq   $0x0,0x2870(%r13)
    2bbe:	00 
    2bbf:	74 8d                	je     2b4e <usbhid_start+0x22e>
    2bc1:	49 83 7d 38 00       	cmpq   $0x0,0x38(%r13)
    2bc6:	74 86                	je     2b4e <usbhid_start+0x22e>
    2bc8:	48 85 c0             	test   %rax,%rax
    2bcb:	74 81                	je     2b4e <usbhid_start+0x22e>
    2bcd:	41 80 7f 04 00       	cmpb   $0x0,0x4(%r15)
    2bd2:	0f 84 5b 01 00 00    	je     2d33 <usbhid_start+0x413>
    2bd8:	48 8d 83 00 1b 00 00 	lea    0x1b00(%rbx),%rax
    2bdf:	45 31 f6             	xor    %r14d,%r14d
    2be2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    2be6:	4d 89 e5             	mov    %r12,%r13
    2be9:	eb 16                	jmp    2c01 <usbhid_start+0x2e1>
    2beb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2bf0:	41 ff c6             	inc    %r14d
    2bf3:	41 0f b6 47 04       	movzbl 0x4(%r15),%eax
    2bf8:	44 39 f0             	cmp    %r14d,%eax
    2bfb:	0f 86 2f 01 00 00    	jbe    2d30 <usbhid_start+0x410>
    2c01:	45 89 f4             	mov    %r14d,%r12d
    2c04:	49 c1 e4 06          	shl    $0x6,%r12
    2c08:	4d 03 67 10          	add    0x10(%r15),%r12
    2c0c:	41 0f b6 44 24 03    	movzbl 0x3(%r12),%eax
    2c12:	83 e0 03             	and    $0x3,%eax
    2c15:	83 f8 03             	cmp    $0x3,%eax
    2c18:	75 d6                	jne    2bf0 <usbhid_start+0x2d0>
    2c1a:	41 0f b6 54 24 06    	movzbl 0x6(%r12),%edx
    2c20:	f6 83 d3 1a 00 00 10 	testb  $0x10,0x1ad3(%rbx)
    2c27:	74 0b                	je     2c34 <usbhid_start+0x314>
    2c29:	41 83 7a 1c 03       	cmpl   $0x3,0x1c(%r10)
    2c2e:	0f 84 db 02 00 00    	je     2f0f <usbhid_start+0x5ef>
    2c34:	41 89 d0             	mov    %edx,%r8d
    2c37:	48 8b 43 10          	mov    0x10(%rbx),%rax
    2c3b:	81 78 04 02 00 01 00 	cmpl   $0x10002,0x4(%rax)
    2c42:	0f 84 b8 01 00 00    	je     2e00 <usbhid_start+0x4e0>
    2c48:	41 80 7c 24 02 00    	cmpb   $0x0,0x2(%r12)
    2c4e:	0f 88 c4 01 00 00    	js     2e18 <usbhid_start+0x4f8>
    2c54:	49 83 bd 60 18 00 00 	cmpq   $0x0,0x1860(%r13)
    2c5b:	00 
    2c5c:	75 92                	jne    2bf0 <usbhid_start+0x2d0>
    2c5e:	31 ff                	xor    %edi,%edi
    2c60:	44 89 45 98          	mov    %r8d,-0x68(%rbp)
    2c64:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2c68:	be d0 00 00 00       	mov    $0xd0,%esi
    2c6d:	e8 00 00 00 00       	callq  2c72 <usbhid_start+0x352>
    2c72:	49 89 85 60 18 00 00 	mov    %rax,0x1860(%r13)
    2c79:	48 85 c0             	test   %rax,%rax
    2c7c:	44 8b 45 98          	mov    -0x68(%rbp),%r8d
    2c80:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2c84:	0f 84 6f 02 00 00    	je     2ef9 <usbhid_start+0x5d9>
    2c8a:	41 8b 12             	mov    (%r10),%edx
    2c8d:	41 0f b6 4c 24 02    	movzbl 0x2(%r12),%ecx
    2c93:	c1 e2 08             	shl    $0x8,%edx
    2c96:	c1 e1 0f             	shl    $0xf,%ecx
    2c99:	09 ca                	or     %ecx,%edx
    2c9b:	49 8b 8d 70 28 00 00 	mov    0x2870(%r13),%rcx
    2ca2:	81 ca 00 00 00 40    	or     $0x40000000,%edx
    2ca8:	4c 89 50 48          	mov    %r10,0x48(%rax)
    2cac:	89 50 58             	mov    %edx,0x58(%rax)
    2caf:	48 89 48 68          	mov    %rcx,0x68(%rax)
    2cb3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
    2cba:	00 00 00 
    2cbd:	48 c7 80 b8 00 00 00 	movq   $0x0,0xb8(%rax)
    2cc4:	00 00 00 00 
    2cc8:	48 89 98 b0 00 00 00 	mov    %rbx,0xb0(%rax)
    2ccf:	41 8b 52 1c          	mov    0x1c(%r10),%edx
    2cd3:	83 fa 05             	cmp    $0x5,%edx
    2cd6:	74 09                	je     2ce1 <usbhid_start+0x3c1>
    2cd8:	83 fa 03             	cmp    $0x3,%edx
    2cdb:	0f 85 03 02 00 00    	jne    2ee4 <usbhid_start+0x5c4>
    2ce1:	41 8d 48 ff          	lea    -0x1(%r8),%ecx
    2ce5:	ba 01 00 00 00       	mov    $0x1,%edx
    2cea:	d3 e2                	shl    %cl,%edx
    2cec:	89 90 a8 00 00 00    	mov    %edx,0xa8(%rax)
    2cf2:	c7 80 a0 00 00 00 ff 	movl   $0xffffffff,0xa0(%rax)
    2cf9:	ff ff ff 
    2cfc:	41 ff c6             	inc    %r14d
    2cff:	49 8b 85 60 18 00 00 	mov    0x1860(%r13),%rax
    2d06:	49 8b 95 78 28 00 00 	mov    0x2878(%r13),%rdx
    2d0d:	48 89 50 70          	mov    %rdx,0x70(%rax)
    2d11:	49 8b 85 60 18 00 00 	mov    0x1860(%r13),%rax
    2d18:	83 48 64 04          	orl    $0x4,0x64(%rax)
    2d1c:	41 0f b6 47 04       	movzbl 0x4(%r15),%eax
    2d21:	44 39 f0             	cmp    %r14d,%eax
    2d24:	0f 87 d7 fe ff ff    	ja     2c01 <usbhid_start+0x2e1>
    2d2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2d30:	4d 89 ec             	mov    %r13,%r12
    2d33:	31 ff                	xor    %edi,%edi
    2d35:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2d39:	be d0 00 00 00       	mov    $0xd0,%esi
    2d3e:	e8 00 00 00 00       	callq  2d43 <usbhid_start+0x423>
    2d43:	49 89 44 24 30       	mov    %rax,0x30(%r12)
    2d48:	48 85 c0             	test   %rax,%rax
    2d4b:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2d4f:	0f 84 f9 fd ff ff    	je     2b4e <usbhid_start+0x22e>
    2d55:	49 8b 94 24 48 18 00 	mov    0x1848(%r12),%rdx
    2d5c:	00 
    2d5d:	49 8b 4c 24 38       	mov    0x38(%r12),%rcx
    2d62:	4c 89 50 48          	mov    %r10,0x48(%rax)
    2d66:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%rax)
    2d6d:	48 89 88 90 00 00 00 	mov    %rcx,0x90(%rax)
    2d74:	48 89 50 68          	mov    %rdx,0x68(%rax)
    2d78:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%rax)
    2d7f:	00 00 00 
    2d82:	48 c7 80 b8 00 00 00 	movq   $0x0,0xb8(%rax)
    2d89:	00 00 00 00 
    2d8d:	48 89 98 b0 00 00 00 	mov    %rbx,0xb0(%rax)
    2d94:	49 8b 44 24 30       	mov    0x30(%r12),%rax
    2d99:	49 8b 94 24 50 18 00 	mov    0x1850(%r12),%rdx
    2da0:	00 
    2da1:	48 89 50 70          	mov    %rdx,0x70(%rax)
    2da5:	49 8b 44 24 30       	mov    0x30(%r12),%rax
    2daa:	83 48 64 04          	orl    $0x4,0x64(%rax)
    2dae:	f6 83 d3 1a 00 00 20 	testb  $0x20,0x1ad3(%rbx)
    2db5:	0f 84 14 01 00 00    	je     2ecf <usbhid_start+0x5af>
    2dbb:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
    2dbf:	f0 80 49 01 01       	lock orb $0x1,0x1(%rcx)
    2dc4:	31 c0                	xor    %eax,%eax
    2dc6:	66 41 81 7f 06 01 01 	cmpw   $0x101,0x6(%r15)
    2dcd:	0f 85 d5 fd ff ff    	jne    2ba8 <usbhid_start+0x288>
    2dd3:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2dd7:	48 89 df             	mov    %rbx,%rdi
    2dda:	e8 00 00 00 00       	callq  2ddf <usbhid_start+0x4bf>
    2ddf:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2de3:	31 c0                	xor    %eax,%eax
    2de5:	41 80 8a 24 01 00 00 	orb    $0x2,0x124(%r10)
    2dec:	02 
    2ded:	48 83 c4 48          	add    $0x48,%rsp
    2df1:	5b                   	pop    %rbx
    2df2:	41 5c                	pop    %r12
    2df4:	41 5d                	pop    %r13
    2df6:	41 5e                	pop    %r14
    2df8:	41 5f                	pop    %r15
    2dfa:	c9                   	leaveq 
    2dfb:	c3                   	retq   
    2dfc:	0f 1f 40 00          	nopl   0x0(%rax)
    2e00:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 2e06 <usbhid_start+0x4e6>
    2e06:	85 c0                	test   %eax,%eax
    2e08:	44 0f 45 c0          	cmovne %eax,%r8d
    2e0c:	41 80 7c 24 02 00    	cmpb   $0x0,0x2(%r12)
    2e12:	0f 89 3c fe ff ff    	jns    2c54 <usbhid_start+0x334>
    2e18:	49 83 7d 18 00       	cmpq   $0x0,0x18(%r13)
    2e1d:	0f 85 cd fd ff ff    	jne    2bf0 <usbhid_start+0x2d0>
    2e23:	31 ff                	xor    %edi,%edi
    2e25:	44 89 45 98          	mov    %r8d,-0x68(%rbp)
    2e29:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2e2d:	be d0 00 00 00       	mov    $0xd0,%esi
    2e32:	e8 00 00 00 00       	callq  2e37 <usbhid_start+0x517>
    2e37:	49 89 45 18          	mov    %rax,0x18(%r13)
    2e3b:	48 85 c0             	test   %rax,%rax
    2e3e:	44 8b 45 98          	mov    -0x68(%rbp),%r8d
    2e42:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2e46:	0f 84 b9 00 00 00    	je     2f05 <usbhid_start+0x5e5>
    2e4c:	41 8b 12             	mov    (%r10),%edx
    2e4f:	41 0f b6 4c 24 02    	movzbl 0x2(%r12),%ecx
    2e55:	c1 e2 08             	shl    $0x8,%edx
    2e58:	c1 e1 0f             	shl    $0xf,%ecx
    2e5b:	09 ca                	or     %ecx,%edx
    2e5d:	49 8b 4d 20          	mov    0x20(%r13),%rcx
    2e61:	81 ca 80 00 00 40    	or     $0x40000080,%edx
    2e67:	4c 89 50 48          	mov    %r10,0x48(%rax)
    2e6b:	89 50 58             	mov    %edx,0x58(%rax)
    2e6e:	48 89 48 68          	mov    %rcx,0x68(%rax)
    2e72:	8b 55 cc             	mov    -0x34(%rbp),%edx
    2e75:	48 c7 80 b8 00 00 00 	movq   $0x0,0xb8(%rax)
    2e7c:	00 00 00 00 
    2e80:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
    2e86:	48 89 98 b0 00 00 00 	mov    %rbx,0xb0(%rax)
    2e8d:	41 8b 52 1c          	mov    0x1c(%r10),%edx
    2e91:	83 fa 05             	cmp    $0x5,%edx
    2e94:	74 05                	je     2e9b <usbhid_start+0x57b>
    2e96:	83 fa 03             	cmp    $0x3,%edx
    2e99:	75 55                	jne    2ef0 <usbhid_start+0x5d0>
    2e9b:	41 8d 48 ff          	lea    -0x1(%r8),%ecx
    2e9f:	ba 01 00 00 00       	mov    $0x1,%edx
    2ea4:	d3 e2                	shl    %cl,%edx
    2ea6:	89 90 a8 00 00 00    	mov    %edx,0xa8(%rax)
    2eac:	c7 80 a0 00 00 00 ff 	movl   $0xffffffff,0xa0(%rax)
    2eb3:	ff ff ff 
    2eb6:	49 8b 45 18          	mov    0x18(%r13),%rax
    2eba:	49 8b 55 28          	mov    0x28(%r13),%rdx
    2ebe:	48 89 50 70          	mov    %rdx,0x70(%rax)
    2ec2:	49 8b 45 18          	mov    0x18(%r13),%rax
    2ec6:	83 48 64 04          	orl    $0x4,0x64(%rax)
    2eca:	e9 21 fd ff ff       	jmpq   2bf0 <usbhid_start+0x2d0>
    2ecf:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2ed3:	48 89 df             	mov    %rbx,%rdi
    2ed6:	e8 00 00 00 00       	callq  2edb <usbhid_start+0x5bb>
    2edb:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2edf:	e9 d7 fe ff ff       	jmpq   2dbb <usbhid_start+0x49b>
    2ee4:	44 89 80 a8 00 00 00 	mov    %r8d,0xa8(%rax)
    2eeb:	e9 02 fe ff ff       	jmpq   2cf2 <usbhid_start+0x3d2>
    2ef0:	44 89 80 a8 00 00 00 	mov    %r8d,0xa8(%rax)
    2ef7:	eb b3                	jmp    2eac <usbhid_start+0x58c>
    2ef9:	4d 89 ec             	mov    %r13,%r12
    2efc:	49 8b 7d 18          	mov    0x18(%r13),%rdi
    2f00:	e9 4e fc ff ff       	jmpq   2b53 <usbhid_start+0x233>
    2f05:	4d 89 ec             	mov    %r13,%r12
    2f08:	31 ff                	xor    %edi,%edi
    2f0a:	e9 44 fc ff ff       	jmpq   2b53 <usbhid_start+0x233>
    2f0f:	8d 04 d5 00 00 00 00 	lea    0x0(,%rdx,8),%eax
    2f16:	83 c9 ff             	or     $0xffffffffffffffff,%ecx
    2f19:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2f1d:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
    2f21:	44 0f bd c0          	bsr    %eax,%r8d
    2f25:	44 0f 44 c1          	cmove  %ecx,%r8d
    2f29:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    2f30:	41 ff c0             	inc    %r8d
    2f33:	31 c0                	xor    %eax,%eax
    2f35:	44 89 c1             	mov    %r8d,%ecx
    2f38:	44 89 45 98          	mov    %r8d,-0x68(%rbp)
    2f3c:	e8 00 00 00 00       	callq  2f41 <usbhid_start+0x621>
    2f41:	44 8b 45 98          	mov    -0x68(%rbp),%r8d
    2f45:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2f49:	e9 e9 fc ff ff       	jmpq   2c37 <usbhid_start+0x317>
    2f4e:	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
    2f55:	00 00 
    2f57:	ff 82 44 e0 ff ff    	incl   -0x1fbc(%rdx)
    2f5d:	4c 8b 1d 00 00 00 00 	mov    0x0(%rip),%r11        # 2f64 <usbhid_start+0x644>
    2f64:	4d 85 db             	test   %r11,%r11
    2f67:	74 5d                	je     2fc6 <usbhid_start+0x6a6>
    2f69:	49 8b 13             	mov    (%r11),%rdx
    2f6c:	4c 89 6d b0          	mov    %r13,-0x50(%rbp)
    2f70:	4c 89 65 a8          	mov    %r12,-0x58(%rbp)
    2f74:	49 89 dd             	mov    %rbx,%r13
    2f77:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    2f7b:	49 89 c4             	mov    %rax,%r12
    2f7e:	4c 89 db             	mov    %r11,%rbx
    2f81:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
    2f85:	b9 08 00 00 00       	mov    $0x8,%ecx
    2f8a:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2f8e:	48 83 c3 10          	add    $0x10,%rbx
    2f92:	41 b9 d0 00 00 00    	mov    $0xd0,%r9d
    2f98:	4d 89 f0             	mov    %r14,%r8
    2f9b:	4c 89 e2             	mov    %r12,%rdx
    2f9e:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    2fa5:	ff 55 b8             	callq  *-0x48(%rbp)
    2fa8:	48 8b 0b             	mov    (%rbx),%rcx
    2fab:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2faf:	48 89 4d b8          	mov    %rcx,-0x48(%rbp)
    2fb3:	48 85 c9             	test   %rcx,%rcx
    2fb6:	75 c9                	jne    2f81 <usbhid_start+0x661>
    2fb8:	4c 89 e0             	mov    %r12,%rax
    2fbb:	4c 89 eb             	mov    %r13,%rbx
    2fbe:	4c 8b 65 a8          	mov    -0x58(%rbp),%r12
    2fc2:	4c 8b 6d b0          	mov    -0x50(%rbp),%r13
    2fc6:	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
    2fcd:	00 00 
    2fcf:	ff 8a 44 e0 ff ff    	decl   -0x1fbc(%rdx)
    2fd5:	48 8b 92 38 e0 ff ff 	mov    -0x1fc8(%rdx),%rdx
    2fdc:	80 e2 08             	and    $0x8,%dl
    2fdf:	0f 84 37 fb ff ff    	je     2b1c <usbhid_start+0x1fc>
    2fe5:	48 89 45 98          	mov    %rax,-0x68(%rbp)
    2fe9:	4c 89 55 a0          	mov    %r10,-0x60(%rbp)
    2fed:	e8 00 00 00 00       	callq  2ff2 <usbhid_start+0x6d2>
    2ff2:	4c 8b 55 a0          	mov    -0x60(%rbp),%r10
    2ff6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
    2ffa:	e9 1d fb ff ff       	jmpq   2b1c <usbhid_start+0x1fc>
    2fff:	90                   	nop

0000000000003000 <usbhid_lookup_quirk>:
    3000:	55                   	push   %rbp
    3001:	48 89 e5             	mov    %rsp,%rbp
    3004:	41 56                	push   %r14
    3006:	41 55                	push   %r13
    3008:	41 54                	push   %r12
    300a:	53                   	push   %rbx
    300b:	e8 00 00 00 00       	callq  3010 <usbhid_lookup_quirk+0x10>
    3010:	41 89 fc             	mov    %edi,%r12d
    3013:	41 89 f5             	mov    %esi,%r13d
    3016:	66 81 fe ff 02       	cmp    $0x2ff,%si
    301b:	76 14                	jbe    3031 <usbhid_lookup_quirk+0x31>
    301d:	66 81 ff 04 04       	cmp    $0x404,%di
    3022:	75 0d                	jne    3031 <usbhid_lookup_quirk+0x31>
    3024:	41 be 00 00 00 20    	mov    $0x20000000,%r14d
    302a:	66 81 fe ff 03       	cmp    $0x3ff,%si
    302f:	76 67                	jbe    3098 <usbhid_lookup_quirk+0x98>
    3031:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3038:	e8 00 00 00 00       	callq  303d <usbhid_lookup_quirk+0x3d>
    303d:	48 8b 1d 00 00 00 00 	mov    0x0(%rip),%rbx        # 3044 <usbhid_lookup_quirk+0x44>
    3044:	48 83 eb 08          	sub    $0x8,%rbx
    3048:	eb 0a                	jmp    3054 <usbhid_lookup_quirk+0x54>
    304a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3050:	48 8d 58 f8          	lea    -0x8(%rax),%rbx
    3054:	48 8b 43 08          	mov    0x8(%rbx),%rax
    3058:	48 8d 53 08          	lea    0x8(%rbx),%rdx
    305c:	0f 18 08             	prefetcht0 (%rax)
    305f:	48 81 fa 00 00 00 00 	cmp    $0x0,%rdx
    3066:	74 40                	je     30a8 <usbhid_lookup_quirk+0xa8>
    3068:	66 44 3b 23          	cmp    (%rbx),%r12w
    306c:	75 e2                	jne    3050 <usbhid_lookup_quirk+0x50>
    306e:	66 44 3b 6b 02       	cmp    0x2(%rbx),%r13w
    3073:	75 db                	jne    3050 <usbhid_lookup_quirk+0x50>
    3075:	48 85 db             	test   %rbx,%rbx
    3078:	74 2e                	je     30a8 <usbhid_lookup_quirk+0xa8>
    307a:	8b 15 00 00 00 00    	mov    0x0(%rip),%edx        # 3080 <usbhid_lookup_quirk+0x80>
    3080:	85 d2                	test   %edx,%edx
    3082:	0f 85 98 00 00 00    	jne    3120 <usbhid_lookup_quirk+0x120>
    3088:	44 8b 73 04          	mov    0x4(%rbx),%r14d
    308c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3093:	e8 00 00 00 00       	callq  3098 <usbhid_lookup_quirk+0x98>
    3098:	44 89 f0             	mov    %r14d,%eax
    309b:	5b                   	pop    %rbx
    309c:	41 5c                	pop    %r12
    309e:	41 5d                	pop    %r13
    30a0:	41 5e                	pop    %r14
    30a2:	c9                   	leaveq 
    30a3:	c3                   	retq   
    30a4:	0f 1f 40 00          	nopl   0x0(%rax)
    30a8:	48 c7 c0 00 00 00 00 	mov    $0x0,%rax
    30af:	31 db                	xor    %ebx,%ebx
    30b1:	ba d6 06 00 00       	mov    $0x6d6,%edx
    30b6:	eb 15                	jmp    30cd <usbhid_lookup_quirk+0xcd>
    30b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    30bf:	00 
    30c0:	0f b7 50 08          	movzwl 0x8(%rax),%edx
    30c4:	48 83 c0 08          	add    $0x8,%rax
    30c8:	66 85 d2             	test   %dx,%dx
    30cb:	74 1c                	je     30e9 <usbhid_lookup_quirk+0xe9>
    30cd:	66 41 39 d4          	cmp    %dx,%r12w
    30d1:	75 ed                	jne    30c0 <usbhid_lookup_quirk+0xc0>
    30d3:	66 44 3b 68 02       	cmp    0x2(%rax),%r13w
    30d8:	0f b7 50 08          	movzwl 0x8(%rax),%edx
    30dc:	48 0f 44 d8          	cmove  %rax,%rbx
    30e0:	48 83 c0 08          	add    $0x8,%rax
    30e4:	66 85 d2             	test   %dx,%dx
    30e7:	75 e4                	jne    30cd <usbhid_lookup_quirk+0xcd>
    30e9:	45 31 f6             	xor    %r14d,%r14d
    30ec:	48 85 db             	test   %rbx,%rbx
    30ef:	74 9b                	je     308c <usbhid_lookup_quirk+0x8c>
    30f1:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 30f7 <usbhid_lookup_quirk+0xf7>
    30f7:	85 c0                	test   %eax,%eax
    30f9:	74 8d                	je     3088 <usbhid_lookup_quirk+0x88>
    30fb:	0f b7 0b             	movzwl (%rbx),%ecx
    30fe:	8b 53 04             	mov    0x4(%rbx),%edx
    3101:	44 0f b7 43 02       	movzwl 0x2(%rbx),%r8d
    3106:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    310d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3114:	31 c0                	xor    %eax,%eax
    3116:	e8 00 00 00 00       	callq  311b <usbhid_lookup_quirk+0x11b>
    311b:	e9 68 ff ff ff       	jmpq   3088 <usbhid_lookup_quirk+0x88>
    3120:	41 0f b7 cc          	movzwl %r12w,%ecx
    3124:	8b 53 04             	mov    0x4(%rbx),%edx
    3127:	45 0f b7 c5          	movzwl %r13w,%r8d
    312b:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    3132:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3139:	31 c0                	xor    %eax,%eax
    313b:	e8 00 00 00 00       	callq  3140 <usbhid_lookup_quirk+0x140>
    3140:	e9 43 ff ff ff       	jmpq   3088 <usbhid_lookup_quirk+0x88>
    3145:	66 66 2e 0f 1f 84 00 	nopw   %cs:0x0(%rax,%rax,1)
    314c:	00 00 00 00 

0000000000003150 <usbhid_quirks_exit>:
    3150:	55                   	push   %rbp
    3151:	48 89 e5             	mov    %rsp,%rbp
    3154:	53                   	push   %rbx
    3155:	48 83 ec 08          	sub    $0x8,%rsp
    3159:	e8 00 00 00 00       	callq  315e <usbhid_quirks_exit+0xe>
    315e:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3165:	e8 00 00 00 00       	callq  316a <usbhid_quirks_exit+0x1a>
    316a:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 3171 <usbhid_quirks_exit+0x21>
    3171:	48 8d 7a f8          	lea    -0x8(%rdx),%rdi
    3175:	48 81 fa 00 00 00 00 	cmp    $0x0,%rdx
    317c:	48 8b 47 08          	mov    0x8(%rdi),%rax
    3180:	74 55                	je     31d7 <usbhid_quirks_exit+0x87>
    3182:	48 8d 58 f8          	lea    -0x8(%rax),%rbx
    3186:	eb 0e                	jmp    3196 <usbhid_quirks_exit+0x46>
    3188:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    318f:	00 
    3190:	48 89 df             	mov    %rbx,%rdi
    3193:	48 89 cb             	mov    %rcx,%rbx
    3196:	48 8b 57 10          	mov    0x10(%rdi),%rdx
    319a:	48 b9 00 02 20 00 00 	mov    $0xdead000000200200,%rcx
    31a1:	00 ad de 
    31a4:	48 89 50 08          	mov    %rdx,0x8(%rax)
    31a8:	48 be 00 01 10 00 00 	mov    $0xdead000000100100,%rsi
    31af:	00 ad de 
    31b2:	48 89 02             	mov    %rax,(%rdx)
    31b5:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
    31b9:	48 89 77 08          	mov    %rsi,0x8(%rdi)
    31bd:	e8 00 00 00 00       	callq  31c2 <usbhid_quirks_exit+0x72>
    31c2:	48 8b 43 08          	mov    0x8(%rbx),%rax
    31c6:	48 8d 53 08          	lea    0x8(%rbx),%rdx
    31ca:	48 8d 48 f8          	lea    -0x8(%rax),%rcx
    31ce:	48 81 fa 00 00 00 00 	cmp    $0x0,%rdx
    31d5:	75 b9                	jne    3190 <usbhid_quirks_exit+0x40>
    31d7:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    31de:	e8 00 00 00 00       	callq  31e3 <usbhid_quirks_exit+0x93>
    31e3:	48 83 c4 08          	add    $0x8,%rsp
    31e7:	5b                   	pop    %rbx
    31e8:	c9                   	leaveq 
    31e9:	c3                   	retq   
    31ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000031f0 <usbhid_quirks_init>:
    31f0:	55                   	push   %rbp
    31f1:	48 89 e5             	mov    %rsp,%rbp
    31f4:	41 57                	push   %r15
    31f6:	41 56                	push   %r14
    31f8:	41 55                	push   %r13
    31fa:	41 54                	push   %r12
    31fc:	53                   	push   %rbx
    31fd:	48 83 ec 48          	sub    $0x48,%rsp
    3201:	e8 00 00 00 00       	callq  3206 <usbhid_quirks_init+0x16>
    3206:	45 31 f6             	xor    %r14d,%r14d
    3209:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    320d:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    3214:	00 00 
    3216:	48 8d 90 28 e0 ff ff 	lea    -0x1fd8(%rax),%rdx
    321d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
    3221:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
    3225:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
    3229:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
    322d:	4a 8b 3c 32          	mov    (%rdx,%r14,1),%rdi
    3231:	48 85 ff             	test   %rdi,%rdi
    3234:	0f 84 f3 00 00 00    	je     332d <usbhid_quirks_init+0x13d>
    323a:	31 c0                	xor    %eax,%eax
    323c:	4c 8d 45 c8          	lea    -0x38(%rbp),%r8
    3240:	48 8d 4d cc          	lea    -0x34(%rbp),%rcx
    3244:	48 8d 55 ce          	lea    -0x32(%rbp),%rdx
    3248:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    324f:	e8 00 00 00 00       	callq  3254 <usbhid_quirks_init+0x64>
    3254:	83 f8 03             	cmp    $0x3,%eax
    3257:	0f 85 15 01 00 00    	jne    3372 <usbhid_quirks_init+0x182>
    325d:	0f b7 5d ce          	movzwl -0x32(%rbp),%ebx
    3261:	44 8b 7d c8          	mov    -0x38(%rbp),%r15d
    3265:	44 0f b7 6d cc       	movzwl -0x34(%rbp),%r13d
    326a:	66 85 db             	test   %bx,%bx
    326d:	0f 84 ef 00 00 00    	je     3362 <usbhid_quirks_init+0x172>
    3273:	be d0 00 00 00       	mov    $0xd0,%esi
    3278:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    327f:	e8 00 00 00 00       	callq  3284 <usbhid_quirks_init+0x94>
    3284:	44 8b 05 00 00 00 00 	mov    0x0(%rip),%r8d        # 328b <usbhid_quirks_init+0x9b>
    328b:	49 89 c4             	mov    %rax,%r12
    328e:	45 85 c0             	test   %r8d,%r8d
    3291:	48 63 05 00 00 00 00 	movslq 0x0(%rip),%rax        # 3298 <usbhid_quirks_init+0xa8>
    3298:	0f 85 0d 01 00 00    	jne    33ab <usbhid_quirks_init+0x1bb>
    329e:	4d 85 e4             	test   %r12,%r12
    32a1:	0f 84 e3 00 00 00    	je     338a <usbhid_quirks_init+0x19a>
    32a7:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    32ae:	66 41 89 1c 24       	mov    %bx,(%r12)
    32b3:	66 45 89 6c 24 02    	mov    %r13w,0x2(%r12)
    32b9:	45 89 7c 24 04       	mov    %r15d,0x4(%r12)
    32be:	e8 00 00 00 00       	callq  32c3 <usbhid_quirks_init+0xd3>
    32c3:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 32ca <usbhid_quirks_init+0xda>
    32ca:	48 83 ef 08          	sub    $0x8,%rdi
    32ce:	eb 04                	jmp    32d4 <usbhid_quirks_init+0xe4>
    32d0:	48 8d 78 f8          	lea    -0x8(%rax),%rdi
    32d4:	48 8b 47 08          	mov    0x8(%rdi),%rax
    32d8:	48 8d 57 08          	lea    0x8(%rdi),%rdx
    32dc:	0f 18 08             	prefetcht0 (%rax)
    32df:	48 81 fa 00 00 00 00 	cmp    $0x0,%rdx
    32e6:	74 58                	je     3340 <usbhid_quirks_init+0x150>
    32e8:	66 3b 1f             	cmp    (%rdi),%bx
    32eb:	75 e3                	jne    32d0 <usbhid_quirks_init+0xe0>
    32ed:	66 44 3b 6f 02       	cmp    0x2(%rdi),%r13w
    32f2:	75 dc                	jne    32d0 <usbhid_quirks_init+0xe0>
    32f4:	49 89 44 24 08       	mov    %rax,0x8(%r12)
    32f9:	49 8d 54 24 08       	lea    0x8(%r12),%rdx
    32fe:	48 89 50 08          	mov    %rdx,0x8(%rax)
    3302:	48 8b 47 10          	mov    0x10(%rdi),%rax
    3306:	49 89 44 24 10       	mov    %rax,0x10(%r12)
    330b:	48 89 10             	mov    %rdx,(%rax)
    330e:	e8 00 00 00 00       	callq  3313 <usbhid_quirks_init+0x123>
    3313:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    331a:	e8 00 00 00 00       	callq  331f <usbhid_quirks_init+0x12f>
    331f:	49 83 c6 08          	add    $0x8,%r14
    3323:	49 83 fe 20          	cmp    $0x20,%r14
    3327:	0f 85 fc fe ff ff    	jne    3229 <usbhid_quirks_init+0x39>
    332d:	48 83 c4 48          	add    $0x48,%rsp
    3331:	31 c0                	xor    %eax,%eax
    3333:	5b                   	pop    %rbx
    3334:	41 5c                	pop    %r12
    3336:	41 5d                	pop    %r13
    3338:	41 5e                	pop    %r14
    333a:	41 5f                	pop    %r15
    333c:	c9                   	leaveq 
    333d:	c3                   	retq   
    333e:	66 90                	xchg   %ax,%ax
    3340:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 3347 <usbhid_quirks_init+0x157>
    3347:	49 8d 4c 24 08       	lea    0x8(%r12),%rcx
    334c:	48 89 0d 00 00 00 00 	mov    %rcx,0x0(%rip)        # 3353 <usbhid_quirks_init+0x163>
    3353:	49 89 54 24 08       	mov    %rdx,0x8(%r12)
    3358:	49 89 44 24 10       	mov    %rax,0x10(%r12)
    335d:	48 89 08             	mov    %rcx,(%rax)
    3360:	eb b1                	jmp    3313 <usbhid_quirks_init+0x123>
    3362:	44 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9d        # 3369 <usbhid_quirks_init+0x179>
    3369:	45 85 c9             	test   %r9d,%r9d
    336c:	0f 85 ba 00 00 00    	jne    342c <usbhid_quirks_init+0x23c>
    3372:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
    3376:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    337d:	4a 8b 34 30          	mov    (%rax,%r14,1),%rsi
    3381:	31 c0                	xor    %eax,%eax
    3383:	e8 00 00 00 00       	callq  3388 <usbhid_quirks_init+0x198>
    3388:	eb 95                	jmp    331f <usbhid_quirks_init+0x12f>
    338a:	8b 3d 00 00 00 00    	mov    0x0(%rip),%edi        # 3390 <usbhid_quirks_init+0x1a0>
    3390:	85 ff                	test   %edi,%edi
    3392:	74 de                	je     3372 <usbhid_quirks_init+0x182>
    3394:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    339b:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    33a2:	31 c0                	xor    %eax,%eax
    33a4:	e8 00 00 00 00       	callq  33a9 <usbhid_quirks_init+0x1b9>
    33a9:	eb c7                	jmp    3372 <usbhid_quirks_init+0x182>
    33ab:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
    33af:	ff 42 1c             	incl   0x1c(%rdx)
    33b2:	4c 8b 15 00 00 00 00 	mov    0x0(%rip),%r10        # 33b9 <usbhid_quirks_init+0x1c9>
    33b9:	4d 85 d2             	test   %r10,%r10
    33bc:	74 4a                	je     3408 <usbhid_quirks_init+0x218>
    33be:	4d 8b 1a             	mov    (%r10),%r11
    33c1:	4c 89 75 98          	mov    %r14,-0x68(%rbp)
    33c5:	66 89 5d 96          	mov    %bx,-0x6a(%rbp)
    33c9:	45 89 ee             	mov    %r13d,%r14d
    33cc:	4c 89 d3             	mov    %r10,%rbx
    33cf:	49 89 c5             	mov    %rax,%r13
    33d2:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
    33d6:	41 b9 d0 00 00 00    	mov    $0xd0,%r9d
    33dc:	48 83 c3 10          	add    $0x10,%rbx
    33e0:	4d 89 e8             	mov    %r13,%r8
    33e3:	b9 18 00 00 00       	mov    $0x18,%ecx
    33e8:	4c 89 e2             	mov    %r12,%rdx
    33eb:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    33f2:	41 ff d3             	callq  *%r11
    33f5:	4c 8b 1b             	mov    (%rbx),%r11
    33f8:	4d 85 db             	test   %r11,%r11
    33fb:	75 d5                	jne    33d2 <usbhid_quirks_init+0x1e2>
    33fd:	45 89 f5             	mov    %r14d,%r13d
    3400:	0f b7 5d 96          	movzwl -0x6a(%rbp),%ebx
    3404:	4c 8b 75 98          	mov    -0x68(%rbp),%r14
    3408:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
    340c:	ff 48 1c             	decl   0x1c(%rax)
    340f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
    3413:	48 8b 82 38 e0 ff ff 	mov    -0x1fc8(%rdx),%rax
    341a:	a8 08                	test   $0x8,%al
    341c:	0f 84 7c fe ff ff    	je     329e <usbhid_quirks_init+0xae>
    3422:	e8 00 00 00 00       	callq  3427 <usbhid_quirks_init+0x237>
    3427:	e9 72 fe ff ff       	jmpq   329e <usbhid_quirks_init+0xae>
    342c:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    3433:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    343a:	31 c0                	xor    %eax,%eax
    343c:	e8 00 00 00 00       	callq  3441 <usbhid_quirks_init+0x251>
    3441:	e9 2c ff ff ff       	jmpq   3372 <usbhid_quirks_init+0x182>
    3446:	90                   	nop
    3447:	90                   	nop
    3448:	90                   	nop
    3449:	90                   	nop
    344a:	90                   	nop
    344b:	90                   	nop
    344c:	90                   	nop
    344d:	90                   	nop
    344e:	90                   	nop
    344f:	90                   	nop

0000000000003450 <hiddev_lookup_report>:
    3450:	55                   	push   %rbp
    3451:	48 89 e5             	mov    %rsp,%rbp
    3454:	e8 00 00 00 00       	callq  3459 <hiddev_lookup_report+0x9>
    3459:	8b 06                	mov    (%rsi),%eax
    345b:	8b 56 04             	mov    0x4(%rsi),%edx
    345e:	ff c8                	dec    %eax
    3460:	83 f8 02             	cmp    $0x2,%eax
    3463:	76 0b                	jbe    3470 <hiddev_lookup_report+0x20>
    3465:	31 c0                	xor    %eax,%eax
    3467:	c9                   	leaveq 
    3468:	c3                   	retq   
    3469:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3470:	89 d1                	mov    %edx,%ecx
    3472:	89 c0                	mov    %eax,%eax
    3474:	30 c9                	xor    %cl,%cl
    3476:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
    347c:	74 22                	je     34a0 <hiddev_lookup_report+0x50>
    347e:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
    3484:	74 3a                	je     34c0 <hiddev_lookup_report+0x70>
    3486:	85 c9                	test   %ecx,%ecx
    3488:	75 db                	jne    3465 <hiddev_lookup_report+0x15>
    348a:	89 d2                	mov    %edx,%edx
    348c:	48 69 c0 03 01 00 00 	imul   $0x103,%rax,%rax
    3493:	48 8d 44 02 0a       	lea    0xa(%rdx,%rax,1),%rax
    3498:	48 8b 44 c7 08       	mov    0x8(%rdi,%rax,8),%rax
    349d:	c9                   	leaveq 
    349e:	c3                   	retq   
    349f:	90                   	nop
    34a0:	48 69 d0 18 08 00 00 	imul   $0x818,%rax,%rdx
    34a7:	48 8b 4c 17 48       	mov    0x48(%rdi,%rdx,1),%rcx
    34ac:	48 8d 54 17 48       	lea    0x48(%rdi,%rdx,1),%rdx
    34b1:	48 39 d1             	cmp    %rdx,%rcx
    34b4:	74 af                	je     3465 <hiddev_lookup_report+0x15>
    34b6:	8b 51 10             	mov    0x10(%rcx),%edx
    34b9:	89 56 04             	mov    %edx,0x4(%rsi)
    34bc:	eb cc                	jmp    348a <hiddev_lookup_report+0x3a>
    34be:	66 90                	xchg   %ax,%ax
    34c0:	48 69 c8 03 01 00 00 	imul   $0x103,%rax,%rcx
    34c7:	0f b6 d2             	movzbl %dl,%edx
    34ca:	48 8d 54 0a 0a       	lea    0xa(%rdx,%rcx,1),%rdx
    34cf:	48 8b 54 d7 08       	mov    0x8(%rdi,%rdx,8),%rdx
    34d4:	48 85 d2             	test   %rdx,%rdx
    34d7:	74 8c                	je     3465 <hiddev_lookup_report+0x15>
    34d9:	48 69 c8 18 08 00 00 	imul   $0x818,%rax,%rcx
    34e0:	48 8b 12             	mov    (%rdx),%rdx
    34e3:	48 8d 4c 0f 48       	lea    0x48(%rdi,%rcx,1),%rcx
    34e8:	48 39 ca             	cmp    %rcx,%rdx
    34eb:	0f 84 74 ff ff ff    	je     3465 <hiddev_lookup_report+0x15>
    34f1:	8b 52 10             	mov    0x10(%rdx),%edx
    34f4:	89 56 04             	mov    %edx,0x4(%rsi)
    34f7:	eb 91                	jmp    348a <hiddev_lookup_report+0x3a>
    34f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000003500 <hiddev_write>:
    3500:	55                   	push   %rbp
    3501:	48 89 e5             	mov    %rsp,%rbp
    3504:	e8 00 00 00 00       	callq  3509 <hiddev_write+0x9>
    3509:	48 c7 c0 ea ff ff ff 	mov    $0xffffffffffffffea,%rax
    3510:	c9                   	leaveq 
    3511:	c3                   	retq   
    3512:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
    3519:	1f 84 00 00 00 00 00 

0000000000003520 <hiddev_poll>:
    3520:	55                   	push   %rbp
    3521:	48 89 e5             	mov    %rsp,%rbp
    3524:	53                   	push   %rbx
    3525:	48 83 ec 08          	sub    $0x8,%rsp
    3529:	e8 00 00 00 00       	callq  352e <hiddev_poll+0xe>
    352e:	48 89 f0             	mov    %rsi,%rax
    3531:	48 8b 9f 98 00 00 00 	mov    0x98(%rdi),%rbx
    3538:	48 8b b3 18 c0 00 00 	mov    0xc018(%rbx),%rsi
    353f:	48 83 c6 28          	add    $0x28,%rsi
    3543:	48 85 c0             	test   %rax,%rax
    3546:	75 30                	jne    3578 <hiddev_poll+0x58>
    3548:	8b 93 00 c0 00 00    	mov    0xc000(%rbx),%edx
    354e:	b8 41 00 00 00       	mov    $0x41,%eax
    3553:	3b 93 04 c0 00 00    	cmp    0xc004(%rbx),%edx
    3559:	75 0f                	jne    356a <hiddev_poll+0x4a>
    355b:	48 8b 83 18 c0 00 00 	mov    0xc018(%rbx),%rax
    3562:	83 38 01             	cmpl   $0x1,(%rax)
    3565:	19 c0                	sbb    %eax,%eax
    3567:	83 e0 18             	and    $0x18,%eax
    356a:	48 83 c4 08          	add    $0x8,%rsp
    356e:	5b                   	pop    %rbx
    356f:	c9                   	leaveq 
    3570:	c3                   	retq   
    3571:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3578:	48 85 f6             	test   %rsi,%rsi
    357b:	74 cb                	je     3548 <hiddev_poll+0x28>
    357d:	48 89 c2             	mov    %rax,%rdx
    3580:	ff 10                	callq  *(%rax)
    3582:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3588:	eb be                	jmp    3548 <hiddev_poll+0x28>
    358a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000003590 <hiddev_usbd_probe>:
    3590:	55                   	push   %rbp
    3591:	48 89 e5             	mov    %rsp,%rbp
    3594:	e8 00 00 00 00       	callq  3599 <hiddev_usbd_probe+0x9>
    3599:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
    359e:	c9                   	leaveq 
    359f:	c3                   	retq   

00000000000035a0 <hiddev_exit>:
    35a0:	55                   	push   %rbp
    35a1:	48 89 e5             	mov    %rsp,%rbp
    35a4:	e8 00 00 00 00       	callq  35a9 <hiddev_exit+0x9>
    35a9:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    35b0:	e8 00 00 00 00       	callq  35b5 <hiddev_exit+0x15>
    35b5:	c9                   	leaveq 
    35b6:	c3                   	retq   
    35b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    35be:	00 00 

00000000000035c0 <hiddev_disconnect>:
    35c0:	55                   	push   %rbp
    35c1:	48 89 e5             	mov    %rsp,%rbp
    35c4:	48 83 ec 20          	sub    $0x20,%rsp
    35c8:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
    35cc:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
    35d0:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
    35d4:	e8 00 00 00 00       	callq  35d9 <hiddev_disconnect+0x19>
    35d9:	48 8b 9f e8 1a 00 00 	mov    0x1ae8(%rdi),%rbx
    35e0:	4c 8b af 00 1c 00 00 	mov    0x1c00(%rdi),%r13
    35e7:	4c 8d 63 08          	lea    0x8(%rbx),%r12
    35eb:	4c 89 e7             	mov    %r12,%rdi
    35ee:	e8 00 00 00 00       	callq  35f3 <hiddev_disconnect+0x33>
    35f3:	4c 89 e7             	mov    %r12,%rdi
    35f6:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
    35fc:	e8 00 00 00 00       	callq  3601 <hiddev_disconnect+0x41>
    3601:	49 8b 7d 08          	mov    0x8(%r13),%rdi
    3605:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    360c:	e8 00 00 00 00       	callq  3611 <hiddev_disconnect+0x51>
    3611:	8b 43 04             	mov    0x4(%rbx),%eax
    3614:	85 c0                	test   %eax,%eax
    3616:	75 18                	jne    3630 <hiddev_disconnect+0x70>
    3618:	48 89 df             	mov    %rbx,%rdi
    361b:	e8 00 00 00 00       	callq  3620 <hiddev_disconnect+0x60>
    3620:	48 8b 5d e8          	mov    -0x18(%rbp),%rbx
    3624:	4c 8b 65 f0          	mov    -0x10(%rbp),%r12
    3628:	4c 8b 6d f8          	mov    -0x8(%rbp),%r13
    362c:	c9                   	leaveq 
    362d:	c3                   	retq   
    362e:	66 90                	xchg   %ax,%ax
    3630:	48 8b 7b 40          	mov    0x40(%rbx),%rdi
    3634:	e8 00 00 00 00       	callq  3639 <hiddev_disconnect+0x79>
    3639:	48 8d 7b 28          	lea    0x28(%rbx),%rdi
    363d:	31 c9                	xor    %ecx,%ecx
    363f:	ba 01 00 00 00       	mov    $0x1,%edx
    3644:	be 01 00 00 00       	mov    $0x1,%esi
    3649:	e8 00 00 00 00       	callq  364e <hiddev_disconnect+0x8e>
    364e:	eb d0                	jmp    3620 <hiddev_disconnect+0x60>

0000000000003650 <hiddev_fasync>:
    3650:	55                   	push   %rbp
    3651:	48 89 e5             	mov    %rsp,%rbp
    3654:	e8 00 00 00 00       	callq  3659 <hiddev_fasync+0x9>
    3659:	48 8b 8e 98 00 00 00 	mov    0x98(%rsi),%rcx
    3660:	48 81 c1 10 c0 00 00 	add    $0xc010,%rcx
    3667:	e8 00 00 00 00       	callq  366c <hiddev_fasync+0x1c>
    366c:	c9                   	leaveq 
    366d:	c3                   	retq   
    366e:	66 90                	xchg   %ax,%ax

0000000000003670 <hiddev_release>:
    3670:	55                   	push   %rbp
    3671:	48 89 e5             	mov    %rsp,%rbp
    3674:	53                   	push   %rbx
    3675:	48 83 ec 08          	sub    $0x8,%rsp
    3679:	e8 00 00 00 00       	callq  367e <hiddev_release+0xe>
    367e:	48 8b 9e 98 00 00 00 	mov    0x98(%rsi),%rbx
    3685:	48 8b bb 18 c0 00 00 	mov    0xc018(%rbx),%rdi
    368c:	48 83 c7 58          	add    $0x58,%rdi
    3690:	e8 00 00 00 00       	callq  3695 <hiddev_release+0x25>
    3695:	48 8b 8b 20 c0 00 00 	mov    0xc020(%rbx),%rcx
    369c:	48 8b 93 28 c0 00 00 	mov    0xc028(%rbx),%rdx
    36a3:	48 be 00 01 10 00 00 	mov    $0xdead000000100100,%rsi
    36aa:	00 ad de 
    36ad:	48 89 51 08          	mov    %rdx,0x8(%rcx)
    36b1:	48 89 0a             	mov    %rcx,(%rdx)
    36b4:	48 89 b3 20 c0 00 00 	mov    %rsi,0xc020(%rbx)
    36bb:	48 b9 00 02 20 00 00 	mov    $0xdead000000200200,%rcx
    36c2:	00 ad de 
    36c5:	48 8b bb 18 c0 00 00 	mov    0xc018(%rbx),%rdi
    36cc:	48 89 c6             	mov    %rax,%rsi
    36cf:	48 83 c7 58          	add    $0x58,%rdi
    36d3:	48 89 8b 28 c0 00 00 	mov    %rcx,0xc028(%rbx)
    36da:	e8 00 00 00 00       	callq  36df <hiddev_release+0x6f>
    36df:	48 8b 93 18 c0 00 00 	mov    0xc018(%rbx),%rdx
    36e6:	8b 42 04             	mov    0x4(%rdx),%eax
    36e9:	ff c8                	dec    %eax
    36eb:	89 42 04             	mov    %eax,0x4(%rdx)
    36ee:	85 c0                	test   %eax,%eax
    36f0:	75 12                	jne    3704 <hiddev_release+0x94>
    36f2:	48 8b bb 18 c0 00 00 	mov    0xc018(%rbx),%rdi
    36f9:	8b 17                	mov    (%rdi),%edx
    36fb:	85 d2                	test   %edx,%edx
    36fd:	75 19                	jne    3718 <hiddev_release+0xa8>
    36ff:	e8 00 00 00 00       	callq  3704 <hiddev_release+0x94>
    3704:	48 89 df             	mov    %rbx,%rdi
    3707:	e8 00 00 00 00       	callq  370c <hiddev_release+0x9c>
    370c:	48 83 c4 08          	add    $0x8,%rsp
    3710:	31 c0                	xor    %eax,%eax
    3712:	5b                   	pop    %rbx
    3713:	c9                   	leaveq 
    3714:	c3                   	retq   
    3715:	0f 1f 00             	nopl   (%rax)
    3718:	48 8b 7f 40          	mov    0x40(%rdi),%rdi
    371c:	e8 00 00 00 00       	callq  3721 <hiddev_release+0xb1>
    3721:	48 8b 83 18 c0 00 00 	mov    0xc018(%rbx),%rax
    3728:	48 8b 78 40          	mov    0x40(%rax),%rdi
    372c:	e8 00 00 00 00       	callq  3731 <hiddev_release+0xc1>
    3731:	eb d1                	jmp    3704 <hiddev_release+0x94>
    3733:	66 66 66 66 2e 0f 1f 	nopw   %cs:0x0(%rax,%rax,1)
    373a:	84 00 00 00 00 00 

0000000000003740 <hiddev_open>:
    3740:	55                   	push   %rbp
    3741:	48 89 e5             	mov    %rsp,%rbp
    3744:	48 83 ec 20          	sub    $0x20,%rsp
    3748:	48 89 1c 24          	mov    %rbx,(%rsp)
    374c:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
    3751:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
    3756:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
    375b:	e8 00 00 00 00       	callq  3760 <hiddev_open+0x20>
    3760:	31 c0                	xor    %eax,%eax
    3762:	49 89 fc             	mov    %rdi,%r12
    3765:	48 89 f3             	mov    %rsi,%rbx
    3768:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    376f:	e8 00 00 00 00       	callq  3774 <hiddev_open+0x34>
    3774:	41 8b 7c 24 58       	mov    0x58(%r12),%edi
    3779:	81 e7 ff ff 0f 00    	and    $0xfffff,%edi
    377f:	e8 00 00 00 00       	callq  3784 <hiddev_open+0x44>
    3784:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    378b:	49 89 c4             	mov    %rax,%r12
    378e:	31 c0                	xor    %eax,%eax
    3790:	e8 00 00 00 00       	callq  3795 <hiddev_open+0x55>
    3795:	4d 85 e4             	test   %r12,%r12
    3798:	75 1e                	jne    37b8 <hiddev_open+0x78>
    379a:	41 be ed ff ff ff    	mov    $0xffffffed,%r14d
    37a0:	44 89 f0             	mov    %r14d,%eax
    37a3:	48 8b 1c 24          	mov    (%rsp),%rbx
    37a7:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
    37ac:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
    37b1:	4c 8b 74 24 18       	mov    0x18(%rsp),%r14
    37b6:	c9                   	leaveq 
    37b7:	c3                   	retq   
    37b8:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    37bf:	31 c0                	xor    %eax,%eax
    37c1:	e8 00 00 00 00       	callq  37c6 <hiddev_open+0x86>
    37c6:	49 8d 7c 24 30       	lea    0x30(%r12),%rdi
    37cb:	e8 00 00 00 00       	callq  37d0 <hiddev_open+0x90>
    37d0:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    37d7:	49 89 c4             	mov    %rax,%r12
    37da:	31 c0                	xor    %eax,%eax
    37dc:	e8 00 00 00 00       	callq  37e1 <hiddev_open+0xa1>
    37e1:	4d 8b ac 24 e8 1a 00 	mov    0x1ae8(%r12),%r13
    37e8:	00 
    37e9:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    37f0:	31 c0                	xor    %eax,%eax
    37f2:	e8 00 00 00 00       	callq  37f7 <hiddev_open+0xb7>
    37f7:	be 04 00 00 00       	mov    $0x4,%esi
    37fc:	bf d0 c0 00 00       	mov    $0xc0d0,%edi
    3801:	e8 00 00 00 00       	callq  3806 <hiddev_open+0xc6>
    3806:	83 3d 00 00 00 00 00 	cmpl   $0x0,0x0(%rip)        # 380d <hiddev_open+0xcd>
    380d:	49 89 c4             	mov    %rax,%r12
    3810:	0f 85 92 01 00 00    	jne    39a8 <hiddev_open+0x268>
    3816:	41 be f4 ff ff ff    	mov    $0xfffffff4,%r14d
    381c:	4d 85 e4             	test   %r12,%r12
    381f:	0f 84 7b ff ff ff    	je     37a0 <hiddev_open+0x60>
    3825:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    382c:	31 c0                	xor    %eax,%eax
    382e:	41 b6 ed             	mov    $0xed,%r14b
    3831:	e8 00 00 00 00       	callq  3836 <hiddev_open+0xf6>
    3836:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    383d:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    3844:	49 8d bc 24 30 c0 00 	lea    0xc030(%r12),%rdi
    384b:	00 
    384c:	e8 00 00 00 00       	callq  3851 <hiddev_open+0x111>
    3851:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3858:	31 c0                	xor    %eax,%eax
    385a:	e8 00 00 00 00       	callq  385f <hiddev_open+0x11f>
    385f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3866:	31 c0                	xor    %eax,%eax
    3868:	4d 89 ac 24 18 c0 00 	mov    %r13,0xc018(%r12)
    386f:	00 
    3870:	e8 00 00 00 00       	callq  3875 <hiddev_open+0x135>
    3875:	31 c0                	xor    %eax,%eax
    3877:	4c 89 a3 98 00 00 00 	mov    %r12,0x98(%rbx)
    387e:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3885:	e8 00 00 00 00       	callq  388a <hiddev_open+0x14a>
    388a:	49 8b 84 24 18 c0 00 	mov    0xc018(%r12),%rax
    3891:	00 
    3892:	83 38 00             	cmpl   $0x0,(%rax)
    3895:	0f 84 d9 00 00 00    	je     3974 <hiddev_open+0x234>
    389b:	8b 50 04             	mov    0x4(%rax),%edx
    389e:	8d 4a 01             	lea    0x1(%rdx),%ecx
    38a1:	85 d2                	test   %edx,%edx
    38a3:	89 48 04             	mov    %ecx,0x4(%rax)
    38a6:	75 11                	jne    38b9 <hiddev_open+0x179>
    38a8:	49 8b 7d 40          	mov    0x40(%r13),%rdi
    38ac:	e8 00 00 00 00       	callq  38b1 <hiddev_open+0x171>
    38b1:	85 c0                	test   %eax,%eax
    38b3:	0f 88 b5 00 00 00    	js     396e <hiddev_open+0x22e>
    38b9:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    38c0:	31 c0                	xor    %eax,%eax
    38c2:	e8 00 00 00 00       	callq  38c7 <hiddev_open+0x187>
    38c7:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    38ce:	00 
    38cf:	48 83 c7 58          	add    $0x58,%rdi
    38d3:	e8 00 00 00 00       	callq  38d8 <hiddev_open+0x198>
    38d8:	49 8b 45 50          	mov    0x50(%r13),%rax
    38dc:	49 8d 94 24 20 c0 00 	lea    0xc020(%r12),%rdx
    38e3:	00 
    38e4:	49 8d 4d 48          	lea    0x48(%r13),%rcx
    38e8:	49 89 55 50          	mov    %rdx,0x50(%r13)
    38ec:	49 89 8c 24 20 c0 00 	mov    %rcx,0xc020(%r12)
    38f3:	00 
    38f4:	49 89 84 24 28 c0 00 	mov    %rax,0xc028(%r12)
    38fb:	00 
    38fc:	48 89 10             	mov    %rdx,(%rax)
    38ff:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    3906:	00 
    3907:	48 83 c7 58          	add    $0x58,%rdi
    390b:	e8 00 00 00 00       	callq  3910 <hiddev_open+0x1d0>
    3910:	31 c0                	xor    %eax,%eax
    3912:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3919:	e8 00 00 00 00       	callq  391e <hiddev_open+0x1de>
    391e:	49 8b 94 24 18 c0 00 	mov    0xc018(%r12),%rdx
    3925:	00 
    3926:	8b 42 04             	mov    0x4(%rdx),%eax
    3929:	8d 48 01             	lea    0x1(%rax),%ecx
    392c:	85 c0                	test   %eax,%eax
    392e:	89 4a 04             	mov    %ecx,0x4(%rdx)
    3931:	75 25                	jne    3958 <hiddev_open+0x218>
    3933:	49 8b 84 24 18 c0 00 	mov    0xc018(%r12),%rax
    393a:	00 
    393b:	83 38 00             	cmpl   $0x0,(%rax)
    393e:	74 18                	je     3958 <hiddev_open+0x218>
    3940:	4d 8b 6d 40          	mov    0x40(%r13),%r13
    3944:	4c 89 ef             	mov    %r13,%rdi
    3947:	e8 00 00 00 00       	callq  394c <hiddev_open+0x20c>
    394c:	85 c0                	test   %eax,%eax
    394e:	78 1e                	js     396e <hiddev_open+0x22e>
    3950:	4c 89 ef             	mov    %r13,%rdi
    3953:	e8 00 00 00 00       	callq  3958 <hiddev_open+0x218>
    3958:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    395f:	31 c0                	xor    %eax,%eax
    3961:	45 31 f6             	xor    %r14d,%r14d
    3964:	e8 00 00 00 00       	callq  3969 <hiddev_open+0x229>
    3969:	e9 32 fe ff ff       	jmpq   37a0 <hiddev_open+0x60>
    396e:	41 be fb ff ff ff    	mov    $0xfffffffb,%r14d
    3974:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    397b:	31 c0                	xor    %eax,%eax
    397d:	e8 00 00 00 00       	callq  3982 <hiddev_open+0x242>
    3982:	4c 89 e7             	mov    %r12,%rdi
    3985:	48 c7 83 98 00 00 00 	movq   $0x0,0x98(%rbx)
    398c:	00 00 00 00 
    3990:	e8 00 00 00 00       	callq  3995 <hiddev_open+0x255>
    3995:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    399c:	31 c0                	xor    %eax,%eax
    399e:	e8 00 00 00 00       	callq  39a3 <hiddev_open+0x263>
    39a3:	e9 f8 fd ff ff       	jmpq   37a0 <hiddev_open+0x60>
    39a8:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    39af:	00 00 
    39b1:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
    39b7:	4c 8b 35 00 00 00 00 	mov    0x0(%rip),%r14        # 39be <hiddev_open+0x27e>
    39be:	4d 85 f6             	test   %r14,%r14
    39c1:	74 30                	je     39f3 <hiddev_open+0x2b3>
    39c3:	49 8b 06             	mov    (%r14),%rax
    39c6:	49 8b 7e 08          	mov    0x8(%r14),%rdi
    39ca:	41 b9 d0 80 00 00    	mov    $0x80d0,%r9d
    39d0:	49 83 c6 10          	add    $0x10,%r14
    39d4:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
    39da:	b9 50 c0 00 00       	mov    $0xc050,%ecx
    39df:	4c 89 e2             	mov    %r12,%rdx
    39e2:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    39e9:	ff d0                	callq  *%rax
    39eb:	49 8b 06             	mov    (%r14),%rax
    39ee:	48 85 c0             	test   %rax,%rax
    39f1:	75 d3                	jne    39c6 <hiddev_open+0x286>
    39f3:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    39fa:	00 00 
    39fc:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
    3a02:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
    3a09:	a8 08                	test   $0x8,%al
    3a0b:	0f 84 05 fe ff ff    	je     3816 <hiddev_open+0xd6>
    3a11:	e8 00 00 00 00       	callq  3a16 <hiddev_open+0x2d6>
    3a16:	e9 fb fd ff ff       	jmpq   3816 <hiddev_open+0xd6>
    3a1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000003a20 <hiddev_ioctl_string>:
    3a20:	55                   	push   %rbp
    3a21:	48 89 e5             	mov    %rsp,%rbp
    3a24:	48 83 ec 40          	sub    $0x40,%rsp
    3a28:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
    3a2c:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
    3a30:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
    3a34:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
    3a38:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
    3a3c:	e8 00 00 00 00       	callq  3a41 <hiddev_ioctl_string+0x21>
    3a41:	48 8b 47 40          	mov    0x40(%rdi),%rax
    3a45:	48 89 d3             	mov    %rdx,%rbx
    3a48:	48 8b 80 88 18 00 00 	mov    0x1888(%rax),%rax
    3a4f:	4c 8b 20             	mov    (%rax),%r12
    3a52:	48 89 d0             	mov    %rdx,%rax
    3a55:	e8 00 00 00 00       	callq  3a5a <hiddev_ioctl_string+0x3a>
    3a5a:	49 89 d5             	mov    %rdx,%r13
    3a5d:	85 c0                	test   %eax,%eax
    3a5f:	74 1f                	je     3a80 <hiddev_ioctl_string+0x60>
    3a61:	41 bf f2 ff ff ff    	mov    $0xfffffff2,%r15d
    3a67:	44 89 f8             	mov    %r15d,%eax
    3a6a:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    3a6e:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
    3a72:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
    3a76:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
    3a7a:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
    3a7e:	c9                   	leaveq 
    3a7f:	c3                   	retq   
    3a80:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3a87:	be d0 00 00 00       	mov    $0xd0,%esi
    3a8c:	e8 00 00 00 00       	callq  3a91 <hiddev_ioctl_string+0x71>
    3a91:	8b 3d 00 00 00 00    	mov    0x0(%rip),%edi        # 3a97 <hiddev_ioctl_string+0x77>
    3a97:	49 89 c6             	mov    %rax,%r14
    3a9a:	4c 63 3d 00 00 00 00 	movslq 0x0(%rip),%r15        # 3aa1 <hiddev_ioctl_string+0x81>
    3aa1:	85 ff                	test   %edi,%edi
    3aa3:	75 6b                	jne    3b10 <hiddev_ioctl_string+0xf0>
    3aa5:	41 bf f4 ff ff ff    	mov    $0xfffffff4,%r15d
    3aab:	4d 85 f6             	test   %r14,%r14
    3aae:	74 b7                	je     3a67 <hiddev_ioctl_string+0x47>
    3ab0:	49 8d bc 24 78 ff ff 	lea    -0x88(%r12),%rdi
    3ab7:	ff 
    3ab8:	b9 ff 00 00 00       	mov    $0xff,%ecx
    3abd:	4c 89 f2             	mov    %r14,%rdx
    3ac0:	44 89 ee             	mov    %r13d,%esi
    3ac3:	e8 00 00 00 00       	callq  3ac8 <hiddev_ioctl_string+0xa8>
    3ac8:	41 89 c7             	mov    %eax,%r15d
    3acb:	85 c0                	test   %eax,%eax
    3acd:	78 2e                	js     3afd <hiddev_ioctl_string+0xdd>
    3acf:	41 8d 57 01          	lea    0x1(%r15),%edx
    3ad3:	48 8d 7b 04          	lea    0x4(%rbx),%rdi
    3ad7:	4c 89 f6             	mov    %r14,%rsi
    3ada:	e8 00 00 00 00       	callq  3adf <hiddev_ioctl_string+0xbf>
    3adf:	85 c0                	test   %eax,%eax
    3ae1:	75 0d                	jne    3af0 <hiddev_ioctl_string+0xd0>
    3ae3:	4c 89 f7             	mov    %r14,%rdi
    3ae6:	e8 00 00 00 00       	callq  3aeb <hiddev_ioctl_string+0xcb>
    3aeb:	e9 77 ff ff ff       	jmpq   3a67 <hiddev_ioctl_string+0x47>
    3af0:	4c 89 f7             	mov    %r14,%rdi
    3af3:	e8 00 00 00 00       	callq  3af8 <hiddev_ioctl_string+0xd8>
    3af8:	e9 64 ff ff ff       	jmpq   3a61 <hiddev_ioctl_string+0x41>
    3afd:	4c 89 f7             	mov    %r14,%rdi
    3b00:	41 bf ea ff ff ff    	mov    $0xffffffea,%r15d
    3b06:	e8 00 00 00 00       	callq  3b0b <hiddev_ioctl_string+0xeb>
    3b0b:	e9 57 ff ff ff       	jmpq   3a67 <hiddev_ioctl_string+0x47>
    3b10:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    3b17:	00 00 
    3b19:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
    3b1f:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 3b26 <hiddev_ioctl_string+0x106>
    3b26:	48 85 c0             	test   %rax,%rax
    3b29:	74 36                	je     3b61 <hiddev_ioctl_string+0x141>
    3b2b:	4c 8b 10             	mov    (%rax),%r10
    3b2e:	48 8b 78 08          	mov    0x8(%rax),%rdi
    3b32:	41 b9 d0 00 00 00    	mov    $0xd0,%r9d
    3b38:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    3b3c:	4d 89 f8             	mov    %r15,%r8
    3b3f:	b9 00 01 00 00       	mov    $0x100,%ecx
    3b44:	4c 89 f2             	mov    %r14,%rdx
    3b47:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    3b4e:	41 ff d2             	callq  *%r10
    3b51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    3b55:	48 83 c0 10          	add    $0x10,%rax
    3b59:	4c 8b 10             	mov    (%rax),%r10
    3b5c:	4d 85 d2             	test   %r10,%r10
    3b5f:	75 cd                	jne    3b2e <hiddev_ioctl_string+0x10e>
    3b61:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    3b68:	00 00 
    3b6a:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
    3b70:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
    3b77:	a8 08                	test   $0x8,%al
    3b79:	0f 84 26 ff ff ff    	je     3aa5 <hiddev_ioctl_string+0x85>
    3b7f:	e8 00 00 00 00       	callq  3b84 <hiddev_ioctl_string+0x164>
    3b84:	e9 1c ff ff ff       	jmpq   3aa5 <hiddev_ioctl_string+0x85>
    3b89:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000003b90 <hiddev_ioctl_usage>:
    3b90:	55                   	push   %rbp
    3b91:	48 89 e5             	mov    %rsp,%rbp
    3b94:	41 57                	push   %r15
    3b96:	41 56                	push   %r14
    3b98:	41 55                	push   %r13
    3b9a:	41 54                	push   %r12
    3b9c:	53                   	push   %rbx
    3b9d:	48 83 ec 38          	sub    $0x38,%rsp
    3ba1:	e8 00 00 00 00       	callq  3ba6 <hiddev_ioctl_usage+0x16>
    3ba6:	4c 8b 77 40          	mov    0x40(%rdi),%r14
    3baa:	41 89 f4             	mov    %esi,%r12d
    3bad:	49 89 d5             	mov    %rdx,%r13
    3bb0:	be d0 00 00 00       	mov    $0xd0,%esi
    3bb5:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    3bbc:	e8 00 00 00 00       	callq  3bc1 <hiddev_ioctl_usage+0x31>
    3bc1:	44 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9d        # 3bc8 <hiddev_ioctl_usage+0x38>
    3bc8:	48 89 c3             	mov    %rax,%rbx
    3bcb:	4c 63 3d 00 00 00 00 	movslq 0x0(%rip),%r15        # 3bd2 <hiddev_ioctl_usage+0x42>
    3bd2:	45 85 c9             	test   %r9d,%r9d
    3bd5:	0f 85 b5 03 00 00    	jne    3f90 <hiddev_ioctl_usage+0x400>
    3bdb:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    3be0:	48 85 db             	test   %rbx,%rbx
    3be3:	0f 84 93 01 00 00    	je     3d7c <hiddev_ioctl_usage+0x1ec>
    3be9:	41 81 fc 14 48 1c 50 	cmp    $0x501c4814,%r12d
    3bf0:	41 0f 94 c7          	sete   %r15b
    3bf4:	41 81 fc 13 48 1c d0 	cmp    $0xd01c4813,%r12d
    3bfb:	0f 94 c0             	sete   %al
    3bfe:	41 08 c7             	or     %al,%r15b
    3c01:	0f 85 89 01 00 00    	jne    3d90 <hiddev_ioctl_usage+0x200>
    3c07:	ba 18 00 00 00       	mov    $0x18,%edx
    3c0c:	4c 89 ee             	mov    %r13,%rsi
    3c0f:	48 89 df             	mov    %rbx,%rdi
    3c12:	e8 00 00 00 00       	callq  3c17 <hiddev_ioctl_usage+0x87>
    3c17:	48 85 c0             	test   %rax,%rax
    3c1a:	0f 85 5e 03 00 00    	jne    3f7e <hiddev_ioctl_usage+0x3ee>
    3c20:	41 81 fc 0d 48 18 c0 	cmp    $0xc018480d,%r12d
    3c27:	0f 84 db 00 00 00    	je     3d08 <hiddev_ioctl_usage+0x178>
    3c2d:	41 81 fc 13 48 1c d0 	cmp    $0xd01c4813,%r12d
    3c34:	0f 84 66 01 00 00    	je     3da0 <hiddev_ioctl_usage+0x210>
    3c3a:	41 81 fc 0b 48 18 c0 	cmp    $0xc018480b,%r12d
    3c41:	0f 84 59 01 00 00    	je     3da0 <hiddev_ioctl_usage+0x210>
    3c47:	8b 03                	mov    (%rbx),%eax
    3c49:	83 f8 01             	cmp    $0x1,%eax
    3c4c:	0f 84 86 02 00 00    	je     3ed8 <hiddev_ioctl_usage+0x348>
    3c52:	83 7b 04 ff          	cmpl   $0xffffffffffffffff,0x4(%rbx)
    3c56:	0f 85 50 01 00 00    	jne    3dac <hiddev_ioctl_usage+0x21c>
    3c5c:	ff c8                	dec    %eax
    3c5e:	83 f8 02             	cmp    $0x2,%eax
    3c61:	0f 87 71 02 00 00    	ja     3ed8 <hiddev_ioctl_usage+0x348>
    3c67:	89 c0                	mov    %eax,%eax
    3c69:	48 69 c0 18 08 00 00 	imul   $0x818,%rax,%rax
    3c70:	4d 8b 54 06 48       	mov    0x48(%r14,%rax,1),%r10
    3c75:	49 8d 44 06 48       	lea    0x48(%r14,%rax,1),%rax
    3c7a:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    3c7e:	4d 8b 3a             	mov    (%r10),%r15
    3c81:	4c 3b 55 b0          	cmp    -0x50(%rbp),%r10
    3c85:	41 0f 18 0f          	prefetcht0 (%r15)
    3c89:	0f 84 49 02 00 00    	je     3ed8 <hiddev_ioctl_usage+0x348>
    3c8f:	41 8b 82 18 02 00 00 	mov    0x218(%r10),%eax
    3c96:	89 45 bc             	mov    %eax,-0x44(%rbp)
    3c99:	85 c0                	test   %eax,%eax
    3c9b:	74 5e                	je     3cfb <hiddev_ioctl_usage+0x16b>
    3c9d:	4d 89 d6             	mov    %r10,%r14
    3ca0:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
    3ca7:	45 31 db             	xor    %r11d,%r11d
    3caa:	49 8b 46 18          	mov    0x18(%r14),%rax
    3cae:	8b 70 18             	mov    0x18(%rax),%esi
    3cb1:	85 f6                	test   %esi,%esi
    3cb3:	74 35                	je     3cea <hiddev_ioctl_usage+0x15a>
    3cb5:	48 8b 78 10          	mov    0x10(%rax),%rdi
    3cb9:	44 8b 43 10          	mov    0x10(%rbx),%r8d
    3cbd:	44 39 07             	cmp    %r8d,(%rdi)
    3cc0:	0f 84 e8 01 00 00    	je     3eae <hiddev_ioctl_usage+0x31e>
    3cc6:	31 d2                	xor    %edx,%edx
    3cc8:	eb 17                	jmp    3ce1 <hiddev_ioctl_usage+0x151>
    3cca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3cd0:	48 63 ca             	movslq %edx,%rcx
    3cd3:	48 c1 e1 04          	shl    $0x4,%rcx
    3cd7:	44 39 04 39          	cmp    %r8d,(%rcx,%rdi,1)
    3cdb:	0f 84 d7 01 00 00    	je     3eb8 <hiddev_ioctl_usage+0x328>
    3ce1:	ff c2                	inc    %edx
    3ce3:	41 89 d1             	mov    %edx,%r9d
    3ce6:	39 f2                	cmp    %esi,%edx
    3ce8:	72 e6                	jb     3cd0 <hiddev_ioctl_usage+0x140>
    3cea:	41 ff c3             	inc    %r11d
    3ced:	49 83 c6 08          	add    $0x8,%r14
    3cf1:	44 89 5d b8          	mov    %r11d,-0x48(%rbp)
    3cf5:	44 3b 5d bc          	cmp    -0x44(%rbp),%r11d
    3cf9:	72 af                	jb     3caa <hiddev_ioctl_usage+0x11a>
    3cfb:	4d 89 fa             	mov    %r15,%r10
    3cfe:	e9 7b ff ff ff       	jmpq   3c7e <hiddev_ioctl_usage+0xee>
    3d03:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    3d08:	8b 03                	mov    (%rbx),%eax
    3d0a:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
    3d0e:	89 45 c0             	mov    %eax,-0x40(%rbp)
    3d11:	4c 89 f7             	mov    %r14,%rdi
    3d14:	8b 43 04             	mov    0x4(%rbx),%eax
    3d17:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    3d1a:	e8 31 f7 ff ff       	callq  3450 <hiddev_lookup_report>
    3d1f:	48 85 c0             	test   %rax,%rax
    3d22:	0f 84 b0 01 00 00    	je     3ed8 <hiddev_ioctl_usage+0x348>
    3d28:	8b 53 08             	mov    0x8(%rbx),%edx
    3d2b:	3b 90 18 02 00 00    	cmp    0x218(%rax),%edx
    3d31:	0f 83 a1 01 00 00    	jae    3ed8 <hiddev_ioctl_usage+0x348>
    3d37:	89 d2                	mov    %edx,%edx
    3d39:	48 8b 54 d0 18       	mov    0x18(%rax,%rdx,8),%rdx
    3d3e:	8b 43 0c             	mov    0xc(%rbx),%eax
    3d41:	3b 42 18             	cmp    0x18(%rdx),%eax
    3d44:	0f 83 8e 01 00 00    	jae    3ed8 <hiddev_ioctl_usage+0x348>
    3d4a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
    3d4e:	89 c0                	mov    %eax,%eax
    3d50:	48 c1 e0 04          	shl    $0x4,%rax
    3d54:	8b 04 10             	mov    (%rax,%rdx,1),%eax
    3d57:	ba 18 00 00 00       	mov    $0x18,%edx
    3d5c:	89 43 10             	mov    %eax,0x10(%rbx)
    3d5f:	48 89 de             	mov    %rbx,%rsi
    3d62:	4c 89 ef             	mov    %r13,%rdi
    3d65:	e8 00 00 00 00       	callq  3d6a <hiddev_ioctl_usage+0x1da>
    3d6a:	85 c0                	test   %eax,%eax
    3d6c:	0f 85 0c 02 00 00    	jne    3f7e <hiddev_ioctl_usage+0x3ee>
    3d72:	48 89 df             	mov    %rbx,%rdi
    3d75:	e8 00 00 00 00       	callq  3d7a <hiddev_ioctl_usage+0x1ea>
    3d7a:	31 c0                	xor    %eax,%eax
    3d7c:	48 83 c4 38          	add    $0x38,%rsp
    3d80:	5b                   	pop    %rbx
    3d81:	41 5c                	pop    %r12
    3d83:	41 5d                	pop    %r13
    3d85:	41 5e                	pop    %r14
    3d87:	41 5f                	pop    %r15
    3d89:	c9                   	leaveq 
    3d8a:	c3                   	retq   
    3d8b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    3d90:	ba 1c 10 00 00       	mov    $0x101c,%edx
    3d95:	e9 72 fe ff ff       	jmpq   3c0c <hiddev_ioctl_usage+0x7c>
    3d9a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3da0:	8b 03                	mov    (%rbx),%eax
    3da2:	83 7b 04 ff          	cmpl   $0xffffffffffffffff,0x4(%rbx)
    3da6:	0f 84 b0 fe ff ff    	je     3c5c <hiddev_ioctl_usage+0xcc>
    3dac:	89 45 c0             	mov    %eax,-0x40(%rbp)
    3daf:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
    3db3:	8b 43 04             	mov    0x4(%rbx),%eax
    3db6:	4c 89 f7             	mov    %r14,%rdi
    3db9:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    3dbc:	e8 8f f6 ff ff       	callq  3450 <hiddev_lookup_report>
    3dc1:	48 85 c0             	test   %rax,%rax
    3dc4:	0f 84 0e 01 00 00    	je     3ed8 <hiddev_ioctl_usage+0x348>
    3dca:	8b 53 08             	mov    0x8(%rbx),%edx
    3dcd:	3b 90 18 02 00 00    	cmp    0x218(%rax),%edx
    3dd3:	0f 83 ff 00 00 00    	jae    3ed8 <hiddev_ioctl_usage+0x348>
    3dd9:	89 d2                	mov    %edx,%edx
    3ddb:	41 81 fc 10 48 18 40 	cmp    $0x40184810,%r12d
    3de2:	48 8b 44 d0 18       	mov    0x18(%rax,%rdx,8),%rax
    3de7:	0f 84 64 01 00 00    	je     3f51 <hiddev_ioctl_usage+0x3c1>
    3ded:	8b 4b 0c             	mov    0xc(%rbx),%ecx
    3df0:	8b 50 28             	mov    0x28(%rax),%edx
    3df3:	39 d1                	cmp    %edx,%ecx
    3df5:	0f 83 dd 00 00 00    	jae    3ed8 <hiddev_ioctl_usage+0x348>
    3dfb:	45 84 ff             	test   %r15b,%r15b
    3dfe:	74 1a                	je     3e1a <hiddev_ioctl_usage+0x28a>
    3e00:	8b 73 18             	mov    0x18(%rbx),%esi
    3e03:	81 fe 00 04 00 00    	cmp    $0x400,%esi
    3e09:	0f 87 c9 00 00 00    	ja     3ed8 <hiddev_ioctl_usage+0x348>
    3e0f:	8d 0c 0e             	lea    (%rsi,%rcx,1),%ecx
    3e12:	39 ca                	cmp    %ecx,%edx
    3e14:	0f 82 be 00 00 00    	jb     3ed8 <hiddev_ioctl_usage+0x348>
    3e1a:	41 81 fc 14 48 1c 50 	cmp    $0x501c4814,%r12d
    3e21:	0f 84 e1 00 00 00    	je     3f08 <hiddev_ioctl_usage+0x378>
    3e27:	76 5f                	jbe    3e88 <hiddev_ioctl_usage+0x2f8>
    3e29:	41 81 fc 0b 48 18 c0 	cmp    $0xc018480b,%r12d
    3e30:	0f 84 b4 00 00 00    	je     3eea <hiddev_ioctl_usage+0x35a>
    3e36:	41 81 fc 13 48 1c d0 	cmp    $0xd01c4813,%r12d
    3e3d:	0f 1f 00             	nopl   (%rax)
    3e40:	0f 85 2c ff ff ff    	jne    3d72 <hiddev_ioctl_usage+0x1e2>
    3e46:	44 8b 43 18          	mov    0x18(%rbx),%r8d
    3e4a:	45 85 c0             	test   %r8d,%r8d
    3e4d:	0f 1f 00             	nopl   (%rax)
    3e50:	74 28                	je     3e7a <hiddev_ioctl_usage+0x2ea>
    3e52:	44 8b 4b 0c          	mov    0xc(%rbx),%r9d
    3e56:	31 c9                	xor    %ecx,%ecx
    3e58:	31 d2                	xor    %edx,%edx
    3e5a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3e60:	48 63 f2             	movslq %edx,%rsi
    3e63:	44 01 c9             	add    %r9d,%ecx
    3e66:	48 8b 78 30          	mov    0x30(%rax),%rdi
    3e6a:	ff c2                	inc    %edx
    3e6c:	8b 0c 8f             	mov    (%rdi,%rcx,4),%ecx
    3e6f:	44 39 c2             	cmp    %r8d,%edx
    3e72:	89 4c b3 1c          	mov    %ecx,0x1c(%rbx,%rsi,4)
    3e76:	89 d1                	mov    %edx,%ecx
    3e78:	72 e6                	jb     3e60 <hiddev_ioctl_usage+0x2d0>
    3e7a:	ba 1c 10 00 00       	mov    $0x101c,%edx
    3e7f:	e9 db fe ff ff       	jmpq   3d5f <hiddev_ioctl_usage+0x1cf>
    3e84:	0f 1f 40 00          	nopl   0x0(%rax)
    3e88:	41 81 fc 0c 48 18 40 	cmp    $0x4018480c,%r12d
    3e8f:	0f 84 aa 00 00 00    	je     3f3f <hiddev_ioctl_usage+0x3af>
    3e95:	41 81 fc 10 48 18 40 	cmp    $0x40184810,%r12d
    3e9c:	0f 1f 40 00          	nopl   0x0(%rax)
    3ea0:	0f 85 cc fe ff ff    	jne    3d72 <hiddev_ioctl_usage+0x1e2>
    3ea6:	8b 53 0c             	mov    0xc(%rbx),%edx
    3ea9:	e9 af 00 00 00       	jmpq   3f5d <hiddev_ioctl_usage+0x3cd>
    3eae:	45 31 c9             	xor    %r9d,%r9d
    3eb1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3eb8:	41 8b 52 10          	mov    0x10(%r10),%edx
    3ebc:	48 85 c0             	test   %rax,%rax
    3ebf:	89 53 04             	mov    %edx,0x4(%rbx)
    3ec2:	8b 55 b8             	mov    -0x48(%rbp),%edx
    3ec5:	44 89 4b 0c          	mov    %r9d,0xc(%rbx)
    3ec9:	89 53 08             	mov    %edx,0x8(%rbx)
    3ecc:	0f 85 48 ff ff ff    	jne    3e1a <hiddev_ioctl_usage+0x28a>
    3ed2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3ed8:	48 89 df             	mov    %rbx,%rdi
    3edb:	e8 00 00 00 00       	callq  3ee0 <hiddev_ioctl_usage+0x350>
    3ee0:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
    3ee5:	e9 92 fe ff ff       	jmpq   3d7c <hiddev_ioctl_usage+0x1ec>
    3eea:	8b 53 0c             	mov    0xc(%rbx),%edx
    3eed:	48 8b 40 30          	mov    0x30(%rax),%rax
    3ef1:	8b 04 90             	mov    (%rax,%rdx,4),%eax
    3ef4:	ba 18 00 00 00       	mov    $0x18,%edx
    3ef9:	89 43 14             	mov    %eax,0x14(%rbx)
    3efc:	e9 5e fe ff ff       	jmpq   3d5f <hiddev_ioctl_usage+0x1cf>
    3f01:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3f08:	44 8b 43 18          	mov    0x18(%rbx),%r8d
    3f0c:	45 85 c0             	test   %r8d,%r8d
    3f0f:	0f 84 5d fe ff ff    	je     3d72 <hiddev_ioctl_usage+0x1e2>
    3f15:	31 c9                	xor    %ecx,%ecx
    3f17:	31 d2                	xor    %edx,%edx
    3f19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3f20:	03 4b 0c             	add    0xc(%rbx),%ecx
    3f23:	48 63 fa             	movslq %edx,%rdi
    3f26:	48 8b 70 30          	mov    0x30(%rax),%rsi
    3f2a:	ff c2                	inc    %edx
    3f2c:	8b 7c bb 1c          	mov    0x1c(%rbx,%rdi,4),%edi
    3f30:	89 3c 8e             	mov    %edi,(%rsi,%rcx,4)
    3f33:	89 d1                	mov    %edx,%ecx
    3f35:	3b 53 18             	cmp    0x18(%rbx),%edx
    3f38:	72 e6                	jb     3f20 <hiddev_ioctl_usage+0x390>
    3f3a:	e9 33 fe ff ff       	jmpq   3d72 <hiddev_ioctl_usage+0x1e2>
    3f3f:	8b 53 0c             	mov    0xc(%rbx),%edx
    3f42:	48 8b 40 30          	mov    0x30(%rax),%rax
    3f46:	8b 4b 14             	mov    0x14(%rbx),%ecx
    3f49:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
    3f4c:	e9 21 fe ff ff       	jmpq   3d72 <hiddev_ioctl_usage+0x1e2>
    3f51:	8b 53 0c             	mov    0xc(%rbx),%edx
    3f54:	3b 50 18             	cmp    0x18(%rax),%edx
    3f57:	0f 83 7b ff ff ff    	jae    3ed8 <hiddev_ioctl_usage+0x348>
    3f5d:	48 8b 40 10          	mov    0x10(%rax),%rax
    3f61:	89 d2                	mov    %edx,%edx
    3f63:	48 89 df             	mov    %rbx,%rdi
    3f66:	48 c1 e2 04          	shl    $0x4,%rdx
    3f6a:	8b 44 02 04          	mov    0x4(%rdx,%rax,1),%eax
    3f6e:	89 45 a8             	mov    %eax,-0x58(%rbp)
    3f71:	e8 00 00 00 00       	callq  3f76 <hiddev_ioctl_usage+0x3e6>
    3f76:	8b 45 a8             	mov    -0x58(%rbp),%eax
    3f79:	e9 fe fd ff ff       	jmpq   3d7c <hiddev_ioctl_usage+0x1ec>
    3f7e:	48 89 df             	mov    %rbx,%rdi
    3f81:	e8 00 00 00 00       	callq  3f86 <hiddev_ioctl_usage+0x3f6>
    3f86:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
    3f8b:	e9 ec fd ff ff       	jmpq   3d7c <hiddev_ioctl_usage+0x1ec>
    3f90:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    3f97:	00 00 
    3f99:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
    3f9f:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 3fa6 <hiddev_ioctl_usage+0x416>
    3fa6:	48 85 c0             	test   %rax,%rax
    3fa9:	74 4b                	je     3ff6 <hiddev_ioctl_usage+0x466>
    3fab:	4d 89 f3             	mov    %r14,%r11
    3fae:	4c 8b 10             	mov    (%rax),%r10
    3fb1:	45 89 e6             	mov    %r12d,%r14d
    3fb4:	49 89 dc             	mov    %rbx,%r12
    3fb7:	48 89 c3             	mov    %rax,%rbx
    3fba:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
    3fbe:	41 b9 d0 00 00 00    	mov    $0xd0,%r9d
    3fc4:	4c 89 5d a8          	mov    %r11,-0x58(%rbp)
    3fc8:	48 83 c3 10          	add    $0x10,%rbx
    3fcc:	4d 89 f8             	mov    %r15,%r8
    3fcf:	b9 1c 10 00 00       	mov    $0x101c,%ecx
    3fd4:	4c 89 e2             	mov    %r12,%rdx
    3fd7:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    3fde:	41 ff d2             	callq  *%r10
    3fe1:	4c 8b 13             	mov    (%rbx),%r10
    3fe4:	4c 8b 5d a8          	mov    -0x58(%rbp),%r11
    3fe8:	4d 85 d2             	test   %r10,%r10
    3feb:	75 cd                	jne    3fba <hiddev_ioctl_usage+0x42a>
    3fed:	4c 89 e3             	mov    %r12,%rbx
    3ff0:	45 89 f4             	mov    %r14d,%r12d
    3ff3:	4d 89 de             	mov    %r11,%r14
    3ff6:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    3ffd:	00 00 
    3fff:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
    4005:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
    400c:	a8 08                	test   $0x8,%al
    400e:	0f 84 c7 fb ff ff    	je     3bdb <hiddev_ioctl_usage+0x4b>
    4014:	e8 00 00 00 00       	callq  4019 <hiddev_ioctl_usage+0x489>
    4019:	e9 bd fb ff ff       	jmpq   3bdb <hiddev_ioctl_usage+0x4b>
    401e:	66 90                	xchg   %ax,%ax

0000000000004020 <hiddev_ioctl>:
    4020:	55                   	push   %rbp
    4021:	48 89 e5             	mov    %rsp,%rbp
    4024:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
    402b:	48 89 5d e0          	mov    %rbx,-0x20(%rbp)
    402f:	4c 89 65 e8          	mov    %r12,-0x18(%rbp)
    4033:	4c 89 6d f0          	mov    %r13,-0x10(%rbp)
    4037:	4c 89 75 f8          	mov    %r14,-0x8(%rbp)
    403b:	e8 00 00 00 00       	callq  4040 <hiddev_ioctl+0x20>
    4040:	49 89 d4             	mov    %rdx,%r12
    4043:	48 8b 8f 98 00 00 00 	mov    0x98(%rdi),%rcx
    404a:	48 8b 99 18 c0 00 00 	mov    0xc018(%rcx),%rbx
    4051:	4c 8b 6b 40          	mov    0x40(%rbx),%r13
    4055:	49 8b 95 00 1c 00 00 	mov    0x1c00(%r13),%rdx
    405c:	4d 85 ed             	test   %r13,%r13
    405f:	0f 84 db 00 00 00    	je     4140 <hiddev_ioctl+0x120>
    4065:	8b 03                	mov    (%rbx),%eax
    4067:	85 c0                	test   %eax,%eax
    4069:	0f 84 d1 00 00 00    	je     4140 <hiddev_ioctl+0x120>
    406f:	49 8b 85 88 18 00 00 	mov    0x1888(%r13),%rax
    4076:	81 fe 01 48 04 80    	cmp    $0x80044801,%esi
    407c:	48 8b 00             	mov    (%rax),%rax
    407f:	0f 84 4b 02 00 00    	je     42d0 <hiddev_ioctl+0x2b0>
    4085:	0f 87 d5 00 00 00    	ja     4160 <hiddev_ioctl+0x140>
    408b:	81 fe 07 48 0c 40    	cmp    $0x400c4807,%esi
    4091:	0f 84 81 02 00 00    	je     4318 <hiddev_ioctl+0x2f8>
    4097:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    409e:	00 00 
    40a0:	0f 87 9a 01 00 00    	ja     4240 <hiddev_ioctl+0x220>
    40a6:	81 fe 05 48 00 00    	cmp    $0x4805,%esi
    40ac:	0f 1f 40 00          	nopl   0x0(%rax)
    40b0:	0f 84 9a 03 00 00    	je     4450 <hiddev_ioctl+0x430>
    40b6:	81 fe 0f 48 04 40    	cmp    $0x4004480f,%esi
    40bc:	0f 1f 40 00          	nopl   0x0(%rax)
    40c0:	0f 84 4a 03 00 00    	je     4410 <hiddev_ioctl+0x3f0>
    40c6:	81 fe 02 48 00 00    	cmp    $0x4802,%esi
    40cc:	0f 1f 40 00          	nopl   0x0(%rax)
    40d0:	0f 84 aa 03 00 00    	je     4480 <hiddev_ioctl+0x460>
    40d6:	48 89 f2             	mov    %rsi,%rdx
    40d9:	0f b6 c6             	movzbl %dh,%eax
    40dc:	83 f8 48             	cmp    $0x48,%eax
    40df:	0f 85 5b 02 00 00    	jne    4340 <hiddev_ioctl+0x320>
    40e5:	89 f0                	mov    %esi,%eax
    40e7:	c1 e8 1e             	shr    $0x1e,%eax
    40ea:	83 f8 02             	cmp    $0x2,%eax
    40ed:	0f 85 4d 02 00 00    	jne    4340 <hiddev_ioctl+0x320>
    40f3:	40 0f b6 c6          	movzbl %sil,%eax
    40f7:	83 f8 06             	cmp    $0x6,%eax
    40fa:	0f 85 22 06 00 00    	jne    4722 <hiddev_ioctl+0x702>
    4100:	49 81 c5 00 1b 00 00 	add    $0x1b00,%r13
    4107:	31 c0                	xor    %eax,%eax
    4109:	48 83 c9 ff          	or     $0xffffffffffffffff,%rcx
    410d:	4c 89 ef             	mov    %r13,%rdi
    4110:	c1 ee 10             	shr    $0x10,%esi
    4113:	f2 ae                	repnz scas %es:(%rdi),%al
    4115:	81 e6 ff 3f 00 00    	and    $0x3fff,%esi
    411b:	f7 d1                	not    %ecx
    411d:	4c 89 e7             	mov    %r12,%rdi
    4120:	39 f1                	cmp    %esi,%ecx
    4122:	89 cb                	mov    %ecx,%ebx
    4124:	0f 47 de             	cmova  %esi,%ebx
    4127:	4c 89 ee             	mov    %r13,%rsi
    412a:	89 da                	mov    %ebx,%edx
    412c:	e8 00 00 00 00       	callq  4131 <hiddev_ioctl+0x111>
    4131:	48 89 c2             	mov    %rax,%rdx
    4134:	48 63 c3             	movslq %ebx,%rax
    4137:	85 d2                	test   %edx,%edx
    4139:	74 0c                	je     4147 <hiddev_ioctl+0x127>
    413b:	e9 c8 01 00 00       	jmpq   4308 <hiddev_ioctl+0x2e8>
    4140:	48 c7 c0 fb ff ff ff 	mov    $0xfffffffffffffffb,%rax
    4147:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
    414b:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
    414f:	4c 8b 6d f0          	mov    -0x10(%rbp),%r13
    4153:	4c 8b 75 f8          	mov    -0x8(%rbp),%r14
    4157:	c9                   	leaveq 
    4158:	c3                   	retq   
    4159:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    4160:	81 fe 11 48 10 c0    	cmp    $0xc0104811,%esi
    4166:	0f 84 7c 01 00 00    	je     42e8 <hiddev_ioctl+0x2c8>
    416c:	0f 87 8e 00 00 00    	ja     4200 <hiddev_ioctl+0x1e0>
    4172:	81 fe 03 48 1c 80    	cmp    $0x801c4803,%esi
    4178:	0f 84 72 04 00 00    	je     45f0 <hiddev_ioctl+0x5d0>
    417e:	66 90                	xchg   %ax,%ax
    4180:	0f 86 5a 02 00 00    	jbe    43e0 <hiddev_ioctl+0x3c0>
    4186:	81 fe 04 48 04 81    	cmp    $0x81044804,%esi
    418c:	0f 1f 40 00          	nopl   0x0(%rax)
    4190:	0f 84 22 04 00 00    	je     45b8 <hiddev_ioctl+0x598>
    4196:	81 fe 09 48 0c c0    	cmp    $0xc00c4809,%esi
    419c:	0f 1f 40 00          	nopl   0x0(%rax)
    41a0:	0f 85 30 ff ff ff    	jne    40d6 <hiddev_ioctl+0xb6>
    41a6:	48 8d 5d d0          	lea    -0x30(%rbp),%rbx
    41aa:	ba 0c 00 00 00       	mov    $0xc,%edx
    41af:	4c 89 e6             	mov    %r12,%rsi
    41b2:	48 89 df             	mov    %rbx,%rdi
    41b5:	e8 00 00 00 00       	callq  41ba <hiddev_ioctl+0x19a>
    41ba:	48 85 c0             	test   %rax,%rax
    41bd:	0f 85 45 01 00 00    	jne    4308 <hiddev_ioctl+0x2e8>
    41c3:	48 89 de             	mov    %rbx,%rsi
    41c6:	4c 89 ef             	mov    %r13,%rdi
    41c9:	e8 82 f2 ff ff       	callq  3450 <hiddev_lookup_report>
    41ce:	48 85 c0             	test   %rax,%rax
    41d1:	0f 84 69 01 00 00    	je     4340 <hiddev_ioctl+0x320>
    41d7:	8b 80 18 02 00 00    	mov    0x218(%rax),%eax
    41dd:	ba 0c 00 00 00       	mov    $0xc,%edx
    41e2:	89 45 d8             	mov    %eax,-0x28(%rbp)
    41e5:	48 89 de             	mov    %rbx,%rsi
    41e8:	4c 89 e7             	mov    %r12,%rdi
    41eb:	e8 00 00 00 00       	callq  41f0 <hiddev_ioctl+0x1d0>
    41f0:	85 c0                	test   %eax,%eax
    41f2:	0f 85 10 01 00 00    	jne    4308 <hiddev_ioctl+0x2e8>
    41f8:	31 c0                	xor    %eax,%eax
    41fa:	e9 48 ff ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    41ff:	90                   	nop
    4200:	81 fe 0d 48 18 c0    	cmp    $0xc018480d,%esi
    4206:	0f 84 64 01 00 00    	je     4370 <hiddev_ioctl+0x350>
    420c:	0f 1f 40 00          	nopl   0x0(%rax)
    4210:	0f 86 b2 01 00 00    	jbe    43c8 <hiddev_ioctl+0x3a8>
    4216:	81 fe 0a 48 38 c0    	cmp    $0xc038480a,%esi
    421c:	0f 1f 40 00          	nopl   0x0(%rax)
    4220:	0f 84 a9 02 00 00    	je     44cf <hiddev_ioctl+0x4af>
    4226:	81 fe 13 48 1c d0    	cmp    $0xd01c4813,%esi
    422c:	0f 1f 40 00          	nopl   0x0(%rax)
    4230:	0f 85 a0 fe ff ff    	jne    40d6 <hiddev_ioctl+0xb6>
    4236:	66 90                	xchg   %ax,%ax
    4238:	e9 33 01 00 00       	jmpq   4370 <hiddev_ioctl+0x350>
    423d:	0f 1f 00             	nopl   (%rax)
    4240:	81 fe 0c 48 18 40    	cmp    $0x4018480c,%esi
    4246:	66 90                	xchg   %ax,%ax
    4248:	0f 84 22 01 00 00    	je     4370 <hiddev_ioctl+0x350>
    424e:	66 90                	xchg   %ax,%ax
    4250:	0f 87 fa 00 00 00    	ja     4350 <hiddev_ioctl+0x330>
    4256:	81 fe 08 48 0c 40    	cmp    $0x400c4808,%esi
    425c:	0f 1f 40 00          	nopl   0x0(%rax)
    4260:	0f 85 70 fe ff ff    	jne    40d6 <hiddev_ioctl+0xb6>
    4266:	4c 8d 75 d0          	lea    -0x30(%rbp),%r14
    426a:	ba 0c 00 00 00       	mov    $0xc,%edx
    426f:	4c 89 e6             	mov    %r12,%rsi
    4272:	4c 89 f7             	mov    %r14,%rdi
    4275:	e8 00 00 00 00       	callq  427a <hiddev_ioctl+0x25a>
    427a:	48 85 c0             	test   %rax,%rax
    427d:	0f 85 85 00 00 00    	jne    4308 <hiddev_ioctl+0x2e8>
    4283:	83 7d d0 01          	cmpl   $0x1,-0x30(%rbp)
    4287:	0f 84 b3 00 00 00    	je     4340 <hiddev_ioctl+0x320>
    428d:	4c 89 f6             	mov    %r14,%rsi
    4290:	4c 89 ef             	mov    %r13,%rdi
    4293:	e8 b8 f1 ff ff       	callq  3450 <hiddev_lookup_report>
    4298:	49 89 c6             	mov    %rax,%r14
    429b:	48 85 c0             	test   %rax,%rax
    429e:	0f 84 9c 00 00 00    	je     4340 <hiddev_ioctl+0x320>
    42a4:	4c 8d 63 08          	lea    0x8(%rbx),%r12
    42a8:	4c 89 e7             	mov    %r12,%rdi
    42ab:	e8 00 00 00 00       	callq  42b0 <hiddev_ioctl+0x290>
    42b0:	83 3b 00             	cmpl   $0x0,(%rbx)
    42b3:	0f 85 65 04 00 00    	jne    471e <hiddev_ioctl+0x6fe>
    42b9:	4c 89 e7             	mov    %r12,%rdi
    42bc:	e8 00 00 00 00       	callq  42c1 <hiddev_ioctl+0x2a1>
    42c1:	31 c0                	xor    %eax,%eax
    42c3:	e9 7f fe ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    42c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    42cf:	00 
    42d0:	b8 04 00 01 00       	mov    $0x10004,%eax
    42d5:	4c 89 e1             	mov    %r12,%rcx
    42d8:	e8 00 00 00 00       	callq  42dd <hiddev_ioctl+0x2bd>
    42dd:	48 98                	cltq   
    42df:	e9 63 fe ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    42e4:	0f 1f 40 00          	nopl   0x0(%rax)
    42e8:	48 8d 5d c0          	lea    -0x40(%rbp),%rbx
    42ec:	ba 10 00 00 00       	mov    $0x10,%edx
    42f1:	4c 89 e6             	mov    %r12,%rsi
    42f4:	48 89 df             	mov    %rbx,%rdi
    42f7:	e8 00 00 00 00       	callq  42fc <hiddev_ioctl+0x2dc>
    42fc:	48 85 c0             	test   %rax,%rax
    42ff:	0f 84 5a 03 00 00    	je     465f <hiddev_ioctl+0x63f>
    4305:	0f 1f 00             	nopl   (%rax)
    4308:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    430f:	e9 33 fe ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    4314:	0f 1f 40 00          	nopl   0x0(%rax)
    4318:	4c 8d 75 d0          	lea    -0x30(%rbp),%r14
    431c:	ba 0c 00 00 00       	mov    $0xc,%edx
    4321:	4c 89 e6             	mov    %r12,%rsi
    4324:	4c 89 f7             	mov    %r14,%rdi
    4327:	e8 00 00 00 00       	callq  432c <hiddev_ioctl+0x30c>
    432c:	48 85 c0             	test   %rax,%rax
    432f:	75 d7                	jne    4308 <hiddev_ioctl+0x2e8>
    4331:	83 7d d0 02          	cmpl   $0x2,-0x30(%rbp)
    4335:	0f 85 9a 03 00 00    	jne    46d5 <hiddev_ioctl+0x6b5>
    433b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4340:	48 c7 c0 ea ff ff ff 	mov    $0xffffffffffffffea,%rax
    4347:	e9 fb fd ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    434c:	0f 1f 40 00          	nopl   0x0(%rax)
    4350:	81 fe 10 48 18 40    	cmp    $0x40184810,%esi
    4356:	74 18                	je     4370 <hiddev_ioctl+0x350>
    4358:	81 fe 14 48 1c 50    	cmp    $0x501c4814,%esi
    435e:	66 90                	xchg   %ax,%ax
    4360:	0f 85 70 fd ff ff    	jne    40d6 <hiddev_ioctl+0xb6>
    4366:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    436d:	00 00 00 
    4370:	89 b5 58 ff ff ff    	mov    %esi,-0xa8(%rbp)
    4376:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
    437a:	4c 89 ef             	mov    %r13,%rdi
    437d:	e8 00 00 00 00       	callq  4382 <hiddev_ioctl+0x362>
    4382:	44 8b 13             	mov    (%rbx),%r10d
    4385:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
    438c:	45 85 d2             	test   %r10d,%r10d
    438f:	8b b5 58 ff ff ff    	mov    -0xa8(%rbp),%esi
    4395:	74 11                	je     43a8 <hiddev_ioctl+0x388>
    4397:	4c 89 e2             	mov    %r12,%rdx
    439a:	48 89 df             	mov    %rbx,%rdi
    439d:	e8 ee f7 ff ff       	callq  3b90 <hiddev_ioctl_usage>
    43a2:	48 98                	cltq   
    43a4:	0f 1f 40 00          	nopl   0x0(%rax)
    43a8:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
    43af:	4c 89 ef             	mov    %r13,%rdi
    43b2:	e8 00 00 00 00       	callq  43b7 <hiddev_ioctl+0x397>
    43b7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
    43be:	e9 84 fd ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    43c3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    43c8:	81 fe 0b 48 18 c0    	cmp    $0xc018480b,%esi
    43ce:	0f 85 02 fd ff ff    	jne    40d6 <hiddev_ioctl+0xb6>
    43d4:	eb 9a                	jmp    4370 <hiddev_ioctl+0x350>
    43d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    43dd:	00 00 00 
    43e0:	81 fe 0e 48 04 80    	cmp    $0x8004480e,%esi
    43e6:	66 90                	xchg   %ax,%ax
    43e8:	0f 85 e8 fc ff ff    	jne    40d6 <hiddev_ioctl+0xb6>
    43ee:	8b 81 08 c0 00 00    	mov    0xc008(%rcx),%eax
    43f4:	4c 89 e1             	mov    %r12,%rcx
    43f7:	e8 00 00 00 00       	callq  43fc <hiddev_ioctl+0x3dc>
    43fc:	85 c0                	test   %eax,%eax
    43fe:	0f 85 04 ff ff ff    	jne    4308 <hiddev_ioctl+0x2e8>
    4404:	31 c0                	xor    %eax,%eax
    4406:	e9 3c fd ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    440b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4410:	4c 89 e0             	mov    %r12,%rax
    4413:	e8 00 00 00 00       	callq  4418 <hiddev_ioctl+0x3f8>
    4418:	85 c0                	test   %eax,%eax
    441a:	0f 85 e8 fe ff ff    	jne    4308 <hiddev_ioctl+0x2e8>
    4420:	f7 c2 fc ff ff ff    	test   $0xfffffffc,%edx
    4426:	0f 85 14 ff ff ff    	jne    4340 <hiddev_ioctl+0x320>
    442c:	89 d0                	mov    %edx,%eax
    442e:	83 e0 03             	and    $0x3,%eax
    4431:	83 f8 02             	cmp    $0x2,%eax
    4434:	0f 84 06 ff ff ff    	je     4340 <hiddev_ioctl+0x320>
    443a:	89 91 08 c0 00 00    	mov    %edx,0xc008(%rcx)
    4440:	31 c0                	xor    %eax,%eax
    4442:	e9 00 fd ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    4447:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    444e:	00 00 
    4450:	4c 8d 63 08          	lea    0x8(%rbx),%r12
    4454:	4c 89 e7             	mov    %r12,%rdi
    4457:	e8 00 00 00 00       	callq  445c <hiddev_ioctl+0x43c>
    445c:	44 8b 1b             	mov    (%rbx),%r11d
    445f:	45 85 db             	test   %r11d,%r11d
    4462:	0f 84 40 02 00 00    	je     46a8 <hiddev_ioctl+0x688>
    4468:	4c 89 ef             	mov    %r13,%rdi
    446b:	e8 00 00 00 00       	callq  4470 <hiddev_ioctl+0x450>
    4470:	4c 89 e7             	mov    %r12,%rdi
    4473:	e8 00 00 00 00       	callq  4478 <hiddev_ioctl+0x458>
    4478:	31 c0                	xor    %eax,%eax
    447a:	e9 c8 fc ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    447f:	90                   	nop
    4480:	41 8b 45 20          	mov    0x20(%r13),%eax
    4484:	49 39 c4             	cmp    %rax,%r12
    4487:	0f 83 b3 fe ff ff    	jae    4340 <hiddev_ioctl+0x320>
    448d:	41 8b 5d 1c          	mov    0x1c(%r13),%ebx
    4491:	85 db                	test   %ebx,%ebx
    4493:	0f 84 a7 fe ff ff    	je     4340 <hiddev_ioctl+0x320>
    4499:	49 8b 4d 10          	mov    0x10(%r13),%rcx
    449d:	31 f6                	xor    %esi,%esi
    449f:	31 c0                	xor    %eax,%eax
    44a1:	eb 11                	jmp    44b4 <hiddev_ioctl+0x494>
    44a3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    44a8:	ff c0                	inc    %eax
    44aa:	89 c6                	mov    %eax,%esi
    44ac:	39 c3                	cmp    %eax,%ebx
    44ae:	0f 86 08 02 00 00    	jbe    46bc <hiddev_ioctl+0x69c>
    44b4:	48 63 d0             	movslq %eax,%rdx
    44b7:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    44bb:	83 3c 91 01          	cmpl   $0x1,(%rcx,%rdx,4)
    44bf:	75 e7                	jne    44a8 <hiddev_ioctl+0x488>
    44c1:	4d 85 e4             	test   %r12,%r12
    44c4:	0f 84 f2 01 00 00    	je     46bc <hiddev_ioctl+0x69c>
    44ca:	49 ff cc             	dec    %r12
    44cd:	eb d9                	jmp    44a8 <hiddev_ioctl+0x488>
    44cf:	48 8d 9d 60 ff ff ff 	lea    -0xa0(%rbp),%rbx
    44d6:	ba 38 00 00 00       	mov    $0x38,%edx
    44db:	4c 89 e6             	mov    %r12,%rsi
    44de:	48 89 df             	mov    %rbx,%rdi
    44e1:	e8 00 00 00 00       	callq  44e6 <hiddev_ioctl+0x4c6>
    44e6:	48 85 c0             	test   %rax,%rax
    44e9:	0f 85 19 fe ff ff    	jne    4308 <hiddev_ioctl+0x2e8>
    44ef:	8b 85 60 ff ff ff    	mov    -0xa0(%rbp),%eax
    44f5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
    44f9:	89 45 d0             	mov    %eax,-0x30(%rbp)
    44fc:	4c 89 ef             	mov    %r13,%rdi
    44ff:	8b 85 64 ff ff ff    	mov    -0x9c(%rbp),%eax
    4505:	89 45 d4             	mov    %eax,-0x2c(%rbp)
    4508:	e8 43 ef ff ff       	callq  3450 <hiddev_lookup_report>
    450d:	48 85 c0             	test   %rax,%rax
    4510:	0f 84 2a fe ff ff    	je     4340 <hiddev_ioctl+0x320>
    4516:	8b 95 68 ff ff ff    	mov    -0x98(%rbp),%edx
    451c:	3b 90 18 02 00 00    	cmp    0x218(%rax),%edx
    4522:	0f 83 18 fe ff ff    	jae    4340 <hiddev_ioctl+0x320>
    4528:	89 d2                	mov    %edx,%edx
    452a:	b9 0e 00 00 00       	mov    $0xe,%ecx
    452f:	48 8b 54 d0 18       	mov    0x18(%rax,%rdx,8),%rdx
    4534:	48 89 df             	mov    %rbx,%rdi
    4537:	31 c0                	xor    %eax,%eax
    4539:	f3 ab                	rep stos %eax,%es:(%rdi)
    453b:	8b 45 d0             	mov    -0x30(%rbp),%eax
    453e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%rbp)
    4544:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    4547:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%rbp)
    454d:	8b 42 28             	mov    0x28(%rdx),%eax
    4550:	ff c8                	dec    %eax
    4552:	89 85 68 ff ff ff    	mov    %eax,-0x98(%rbp)
    4558:	8b 42 18             	mov    0x18(%rdx),%eax
    455b:	89 85 6c ff ff ff    	mov    %eax,-0x94(%rbp)
    4561:	8b 42 1c             	mov    0x1c(%rdx),%eax
    4564:	89 85 70 ff ff ff    	mov    %eax,-0x90(%rbp)
    456a:	8b 02                	mov    (%rdx),%eax
    456c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
    4572:	8b 42 04             	mov    0x4(%rdx),%eax
    4575:	89 85 78 ff ff ff    	mov    %eax,-0x88(%rbp)
    457b:	8b 42 08             	mov    0x8(%rdx),%eax
    457e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%rbp)
    4584:	8b 42 38             	mov    0x38(%rdx),%eax
    4587:	89 45 80             	mov    %eax,-0x80(%rbp)
    458a:	8b 42 3c             	mov    0x3c(%rdx),%eax
    458d:	89 45 84             	mov    %eax,-0x7c(%rbp)
    4590:	8b 42 40             	mov    0x40(%rdx),%eax
    4593:	89 45 88             	mov    %eax,-0x78(%rbp)
    4596:	8b 42 44             	mov    0x44(%rdx),%eax
    4599:	89 45 8c             	mov    %eax,-0x74(%rbp)
    459c:	8b 42 48             	mov    0x48(%rdx),%eax
    459f:	89 45 90             	mov    %eax,-0x70(%rbp)
    45a2:	8b 42 4c             	mov    0x4c(%rdx),%eax
    45a5:	ba 38 00 00 00       	mov    $0x38,%edx
    45aa:	89 45 94             	mov    %eax,-0x6c(%rbp)
    45ad:	e9 33 fc ff ff       	jmpq   41e5 <hiddev_ioctl+0x1c5>
    45b2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    45b8:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
    45bc:	4c 89 ef             	mov    %r13,%rdi
    45bf:	e8 00 00 00 00       	callq  45c4 <hiddev_ioctl+0x5a4>
    45c4:	44 8b 33             	mov    (%rbx),%r14d
    45c7:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
    45ce:	45 85 f6             	test   %r14d,%r14d
    45d1:	0f 84 d1 fd ff ff    	je     43a8 <hiddev_ioctl+0x388>
    45d7:	4c 89 e2             	mov    %r12,%rdx
    45da:	be 04 48 04 81       	mov    $0x81044804,%esi
    45df:	48 89 df             	mov    %rbx,%rdi
    45e2:	e8 39 f4 ff ff       	callq  3a20 <hiddev_ioctl_string>
    45e7:	48 98                	cltq   
    45e9:	e9 ba fd ff ff       	jmpq   43a8 <hiddev_ioctl+0x388>
    45ee:	66 90                	xchg   %ax,%ax
    45f0:	c7 45 a0 03 00 00 00 	movl   $0x3,-0x60(%rbp)
    45f7:	48 8d 88 78 ff ff ff 	lea    -0x88(%rax),%rcx
    45fe:	48 8b 58 b8          	mov    -0x48(%rax),%rbx
    4602:	48 8d 75 a0          	lea    -0x60(%rbp),%rsi
    4606:	8b 5b 08             	mov    0x8(%rbx),%ebx
    4609:	4c 89 e7             	mov    %r12,%rdi
    460c:	89 5d a4             	mov    %ebx,-0x5c(%rbp)
    460f:	8b 80 78 ff ff ff    	mov    -0x88(%rax),%eax
    4615:	89 45 a8             	mov    %eax,-0x58(%rbp)
    4618:	8b 42 10             	mov    0x10(%rdx),%eax
    461b:	ba 1c 00 00 00       	mov    $0x1c,%edx
    4620:	89 45 ac             	mov    %eax,-0x54(%rbp)
    4623:	0f b7 81 c0 02 00 00 	movzwl 0x2c0(%rcx),%eax
    462a:	66 89 45 b0          	mov    %ax,-0x50(%rbp)
    462e:	0f b7 81 c2 02 00 00 	movzwl 0x2c2(%rcx),%eax
    4635:	66 89 45 b2          	mov    %ax,-0x4e(%rbp)
    4639:	0f b7 81 c4 02 00 00 	movzwl 0x2c4(%rcx),%eax
    4640:	66 89 45 b4          	mov    %ax,-0x4c(%rbp)
    4644:	41 8b 45 20          	mov    0x20(%r13),%eax
    4648:	89 45 b8             	mov    %eax,-0x48(%rbp)
    464b:	e8 00 00 00 00       	callq  4650 <hiddev_ioctl+0x630>
    4650:	85 c0                	test   %eax,%eax
    4652:	0f 85 b0 fc ff ff    	jne    4308 <hiddev_ioctl+0x2e8>
    4658:	31 c0                	xor    %eax,%eax
    465a:	e9 e8 fa ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    465f:	8b 45 c0             	mov    -0x40(%rbp),%eax
    4662:	41 3b 45 1c          	cmp    0x1c(%r13),%eax
    4666:	0f 83 d4 fc ff ff    	jae    4340 <hiddev_ioctl+0x320>
    466c:	49 8b 55 10          	mov    0x10(%r13),%rdx
    4670:	89 c0                	mov    %eax,%eax
    4672:	48 6b c0 0c          	imul   $0xc,%rax,%rax
    4676:	8b 04 10             	mov    (%rax,%rdx,1),%eax
    4679:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    467c:	8b 45 c0             	mov    -0x40(%rbp),%eax
    467f:	49 8b 55 10          	mov    0x10(%r13),%rdx
    4683:	48 6b c0 0c          	imul   $0xc,%rax,%rax
    4687:	8b 54 10 04          	mov    0x4(%rax,%rdx,1),%edx
    468b:	89 55 c8             	mov    %edx,-0x38(%rbp)
    468e:	49 8b 55 10          	mov    0x10(%r13),%rdx
    4692:	8b 44 10 08          	mov    0x8(%rax,%rdx,1),%eax
    4696:	ba 10 00 00 00       	mov    $0x10,%edx
    469b:	89 45 cc             	mov    %eax,-0x34(%rbp)
    469e:	e9 42 fb ff ff       	jmpq   41e5 <hiddev_ioctl+0x1c5>
    46a3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    46a8:	4c 89 e7             	mov    %r12,%rdi
    46ab:	e8 00 00 00 00       	callq  46b0 <hiddev_ioctl+0x690>
    46b0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
    46b7:	e9 8b fa ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    46bc:	39 de                	cmp    %ebx,%esi
    46be:	66 90                	xchg   %ax,%ax
    46c0:	0f 84 7a fc ff ff    	je     4340 <hiddev_ioctl+0x320>
    46c6:	48 98                	cltq   
    46c8:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    46cc:	8b 44 81 04          	mov    0x4(%rcx,%rax,4),%eax
    46d0:	e9 72 fa ff ff       	jmpq   4147 <hiddev_ioctl+0x127>
    46d5:	4c 89 f6             	mov    %r14,%rsi
    46d8:	4c 89 ef             	mov    %r13,%rdi
    46db:	e8 70 ed ff ff       	callq  3450 <hiddev_lookup_report>
    46e0:	49 89 c6             	mov    %rax,%r14
    46e3:	48 85 c0             	test   %rax,%rax
    46e6:	0f 84 54 fc ff ff    	je     4340 <hiddev_ioctl+0x320>
    46ec:	4c 8d 63 08          	lea    0x8(%rbx),%r12
    46f0:	4c 89 e7             	mov    %r12,%rdi
    46f3:	e8 00 00 00 00       	callq  46f8 <hiddev_ioctl+0x6d8>
    46f8:	ba 80 00 00 00       	mov    $0x80,%edx
    46fd:	83 3b 00             	cmpl   $0x0,(%rbx)
    4700:	0f 84 b3 fb ff ff    	je     42b9 <hiddev_ioctl+0x299>
    4706:	4c 89 ef             	mov    %r13,%rdi
    4709:	4c 89 f6             	mov    %r14,%rsi
    470c:	e8 00 00 00 00       	callq  4711 <hiddev_ioctl+0x6f1>
    4711:	4c 89 ef             	mov    %r13,%rdi
    4714:	e8 00 00 00 00       	callq  4719 <hiddev_ioctl+0x6f9>
    4719:	e9 9b fb ff ff       	jmpq   42b9 <hiddev_ioctl+0x299>
    471e:	31 d2                	xor    %edx,%edx
    4720:	eb e4                	jmp    4706 <hiddev_ioctl+0x6e6>
    4722:	83 f8 12             	cmp    $0x12,%eax
    4725:	0f 1f 00             	nopl   (%rax)
    4728:	0f 85 12 fc ff ff    	jne    4340 <hiddev_ioctl+0x320>
    472e:	49 81 c5 80 1b 00 00 	add    $0x1b80,%r13
    4735:	e9 cd f9 ff ff       	jmpq   4107 <hiddev_ioctl+0xe7>
    473a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000004740 <hiddev_compat_ioctl>:
    4740:	55                   	push   %rbp
    4741:	48 89 e5             	mov    %rsp,%rbp
    4744:	e8 00 00 00 00       	callq  4749 <hiddev_compat_ioctl+0x9>
    4749:	89 d2                	mov    %edx,%edx
    474b:	e8 d0 f8 ff ff       	callq  4020 <hiddev_ioctl>
    4750:	c9                   	leaveq 
    4751:	c3                   	retq   
    4752:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
    4759:	1f 84 00 00 00 00 00 

0000000000004760 <hiddev_read>:
    4760:	55                   	push   %rbp
    4761:	48 89 e5             	mov    %rsp,%rbp
    4764:	48 81 ec c0 00 00 00 	sub    $0xc0,%rsp
    476b:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
    476f:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
    4773:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
    4777:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
    477b:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
    477f:	e8 00 00 00 00       	callq  4784 <hiddev_read+0x24>
    4784:	49 89 d5             	mov    %rdx,%r13
    4787:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
    478e:	00 
    478f:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
    4796:	00 
    4797:	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
    479e:	00 00 
    47a0:	4c 8d 7d 90          	lea    -0x70(%rbp),%r15
    47a4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
    47a8:	49 8d 47 18          	lea    0x18(%r15),%rax
    47ac:	49 89 fe             	mov    %rdi,%r14
    47af:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
    47b3:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    47b7:	4c 8b a7 98 00 00 00 	mov    0x98(%rdi),%r12
    47be:	41 8b 8c 24 08 c0 00 	mov    0xc008(%r12),%ecx
    47c5:	00 
    47c6:	83 e1 01             	and    $0x1,%ecx
    47c9:	83 f9 01             	cmp    $0x1,%ecx
    47cc:	48 19 c0             	sbb    %rax,%rax
    47cf:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
    47d3:	48 83 c0 18          	add    $0x18,%rax
    47d7:	83 f9 01             	cmp    $0x1,%ecx
    47da:	19 db                	sbb    %ebx,%ebx
    47dc:	83 e3 f0             	and    $0xfffffffffffffff0,%ebx
    47df:	83 c3 18             	add    $0x18,%ebx
    47e2:	49 39 c5             	cmp    %rax,%r13
    47e5:	73 19                	jae    4800 <hiddev_read+0xa0>
    47e7:	31 c0                	xor    %eax,%eax
    47e9:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
    47ed:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
    47f1:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
    47f5:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
    47f9:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
    47fd:	c9                   	leaveq 
    47fe:	c3                   	retq   
    47ff:	90                   	nop
    4800:	49 8d 84 24 30 c0 00 	lea    0xc030(%r12),%rax
    4807:	00 
    4808:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
    480f:	48 89 45 80          	mov    %rax,-0x80(%rbp)
    4813:	48 89 c7             	mov    %rax,%rdi
    4816:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    481d:	e8 00 00 00 00       	callq  4822 <hiddev_read+0xc2>
    4822:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
    4829:	89 c1                	mov    %eax,%ecx
    482b:	4c 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%r8
    4832:	48 c7 c0 00 fe ff ff 	mov    $0xfffffffffffffe00,%rax
    4839:	85 c9                	test   %ecx,%ecx
    483b:	75 ac                	jne    47e9 <hiddev_read+0x89>
    483d:	41 8b b4 24 00 c0 00 	mov    0xc000(%r12),%esi
    4844:	00 
    4845:	41 8b 84 24 04 c0 00 	mov    0xc004(%r12),%eax
    484c:	00 
    484d:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
    4854:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
    485b:	4c 89 b5 70 ff ff ff 	mov    %r14,-0x90(%rbp)
    4862:	4c 89 45 88          	mov    %r8,-0x78(%rbp)
    4866:	39 c6                	cmp    %eax,%esi
    4868:	0f 84 27 01 00 00    	je     4995 <hiddev_read+0x235>
    486e:	45 31 f6             	xor    %r14d,%r14d
    4871:	e9 88 00 00 00       	jmpq   48fe <hiddev_read+0x19e>
    4876:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    487d:	00 00 00 
    4880:	48 98                	cltq   
    4882:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    4886:	48 c1 e0 03          	shl    $0x3,%rax
    488a:	42 83 7c 20 08 ff    	cmpl   $0xffffffffffffffff,0x8(%rax,%r12,1)
    4890:	74 45                	je     48d7 <hiddev_read+0x177>
    4892:	41 8b 44 04 10       	mov    0x10(%r12,%rax,1),%eax
    4897:	49 63 fe             	movslq %r14d,%rdi
    489a:	89 45 c0             	mov    %eax,-0x40(%rbp)
    489d:	48 03 7d 88          	add    -0x78(%rbp),%rdi
    48a1:	49 63 84 24 04 c0 00 	movslq 0xc004(%r12),%rax
    48a8:	00 
    48a9:	ba 08 00 00 00       	mov    $0x8,%edx
    48ae:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    48b2:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
    48b6:	41 8b 44 c4 14       	mov    0x14(%r12,%rax,8),%eax
    48bb:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    48be:	e8 00 00 00 00       	callq  48c3 <hiddev_read+0x163>
    48c3:	85 c0                	test   %eax,%eax
    48c5:	0f 85 b5 00 00 00    	jne    4980 <hiddev_read+0x220>
    48cb:	41 83 c6 08          	add    $0x8,%r14d
    48cf:	41 8b b4 24 00 c0 00 	mov    0xc000(%r12),%esi
    48d6:	00 
    48d7:	41 8b 84 24 04 c0 00 	mov    0xc004(%r12),%eax
    48de:	00 
    48df:	ff c0                	inc    %eax
    48e1:	25 ff 07 00 00       	and    $0x7ff,%eax
    48e6:	41 89 84 24 04 c0 00 	mov    %eax,0xc004(%r12)
    48ed:	00 
    48ee:	39 c6                	cmp    %eax,%esi
    48f0:	74 5e                	je     4950 <hiddev_read+0x1f0>
    48f2:	41 8d 14 1e          	lea    (%r14,%rbx,1),%edx
    48f6:	48 63 d2             	movslq %edx,%rdx
    48f9:	49 39 d5             	cmp    %rdx,%r13
    48fc:	72 54                	jb     4952 <hiddev_read+0x1f2>
    48fe:	41 8b 94 24 08 c0 00 	mov    0xc008(%r12),%edx
    4905:	00 
    4906:	f6 c2 01             	test   $0x1,%dl
    4909:	0f 84 71 ff ff ff    	je     4880 <hiddev_read+0x120>
    490f:	48 98                	cltq   
    4911:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
    4915:	41 83 7c cc 08 ff    	cmpl   $0xffffffffffffffff,0x8(%r12,%rcx,8)
    491b:	75 05                	jne    4922 <hiddev_read+0x1c2>
    491d:	83 e2 02             	and    $0x2,%edx
    4920:	74 b5                	je     48d7 <hiddev_read+0x177>
    4922:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    4926:	49 63 fe             	movslq %r14d,%rdi
    4929:	49 8d 34 c4          	lea    (%r12,%rax,8),%rsi
    492d:	48 03 7d 88          	add    -0x78(%rbp),%rdi
    4931:	ba 18 00 00 00       	mov    $0x18,%edx
    4936:	e8 00 00 00 00       	callq  493b <hiddev_read+0x1db>
    493b:	85 c0                	test   %eax,%eax
    493d:	75 41                	jne    4980 <hiddev_read+0x220>
    493f:	41 83 c6 18          	add    $0x18,%r14d
    4943:	41 8b b4 24 00 c0 00 	mov    0xc000(%r12),%esi
    494a:	00 
    494b:	eb 8a                	jmp    48d7 <hiddev_read+0x177>
    494d:	0f 1f 00             	nopl   (%rax)
    4950:	89 f0                	mov    %esi,%eax
    4952:	45 85 f6             	test   %r14d,%r14d
    4955:	0f 84 0b ff ff ff    	je     4866 <hiddev_read+0x106>
    495b:	48 8b 7d 80          	mov    -0x80(%rbp),%rdi
    495f:	44 89 b5 50 ff ff ff 	mov    %r14d,-0xb0(%rbp)
    4966:	e8 00 00 00 00       	callq  496b <hiddev_read+0x20b>
    496b:	8b 8d 50 ff ff ff    	mov    -0xb0(%rbp),%ecx
    4971:	48 63 c1             	movslq %ecx,%rax
    4974:	e9 70 fe ff ff       	jmpq   47e9 <hiddev_read+0x89>
    4979:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    4980:	48 8b 7d 80          	mov    -0x80(%rbp),%rdi
    4984:	e8 00 00 00 00       	callq  4989 <hiddev_read+0x229>
    4989:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    4990:	e9 54 fe ff ff       	jmpq   47e9 <hiddev_read+0x89>
    4995:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    499c:	00 
    499d:	ba 01 00 00 00       	mov    $0x1,%edx
    49a2:	48 83 c7 28          	add    $0x28,%rdi
    49a6:	4c 89 fe             	mov    %r15,%rsi
    49a9:	e8 00 00 00 00       	callq  49ae <hiddev_read+0x24e>
    49ae:	41 8b 84 24 00 c0 00 	mov    0xc000(%r12),%eax
    49b5:	00 
    49b6:	41 3b 84 24 04 c0 00 	cmp    0xc004(%r12),%eax
    49bd:	00 
    49be:	0f 85 1b 01 00 00    	jne    4adf <hiddev_read+0x37f>
    49c4:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
    49cb:	f6 42 39 08          	testb  $0x8,0x39(%rdx)
    49cf:	0f 85 c6 00 00 00    	jne    4a9b <hiddev_read+0x33b>
    49d5:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
    49dc:	48 8b 42 08          	mov    0x8(%rdx),%rax
    49e0:	48 8b 40 10          	mov    0x10(%rax),%rax
    49e4:	a8 04                	test   $0x4,%al
    49e6:	0f 85 2f 01 00 00    	jne    4b1b <hiddev_read+0x3bb>
    49ec:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    49f3:	00 
    49f4:	8b 0f                	mov    (%rdi),%ecx
    49f6:	85 c9                	test   %ecx,%ecx
    49f8:	0f 84 14 01 00 00    	je     4b12 <hiddev_read+0x3b2>
    49fe:	89 9d 64 ff ff ff    	mov    %ebx,-0x9c(%rbp)
    4a04:	4c 89 ad 58 ff ff ff 	mov    %r13,-0xa8(%rbp)
    4a0b:	48 8b 5d 80          	mov    -0x80(%rbp),%rbx
    4a0f:	4c 8b ad 70 ff ff ff 	mov    -0x90(%rbp),%r13
    4a16:	4c 8b b5 68 ff ff ff 	mov    -0x98(%rbp),%r14
    4a1d:	eb 57                	jmp    4a76 <hiddev_read+0x316>
    4a1f:	90                   	nop
    4a20:	48 c7 45 c8 01 00 00 	movq   $0x1,-0x38(%rbp)
    4a27:	00 
    4a28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    4a2c:	49 87 06             	xchg   %rax,(%r14)
    4a2f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    4a33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    4a37:	41 8b 84 24 00 c0 00 	mov    0xc000(%r12),%eax
    4a3e:	00 
    4a3f:	41 3b 84 24 04 c0 00 	cmp    0xc004(%r12),%eax
    4a46:	00 
    4a47:	0f 85 85 00 00 00    	jne    4ad2 <hiddev_read+0x372>
    4a4d:	41 f6 45 39 08       	testb  $0x8,0x39(%r13)
    4a52:	75 47                	jne    4a9b <hiddev_read+0x33b>
    4a54:	49 8b 46 08          	mov    0x8(%r14),%rax
    4a58:	48 8b 40 10          	mov    0x10(%rax),%rax
    4a5c:	a8 04                	test   $0x4,%al
    4a5e:	0f 85 b7 00 00 00    	jne    4b1b <hiddev_read+0x3bb>
    4a64:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    4a6b:	00 
    4a6c:	8b 17                	mov    (%rdi),%edx
    4a6e:	85 d2                	test   %edx,%edx
    4a70:	0f 84 9c 00 00 00    	je     4b12 <hiddev_read+0x3b2>
    4a76:	48 89 df             	mov    %rbx,%rdi
    4a79:	e8 00 00 00 00       	callq  4a7e <hiddev_read+0x31e>
    4a7e:	e8 00 00 00 00       	callq  4a83 <hiddev_read+0x323>
    4a83:	48 89 df             	mov    %rbx,%rdi
    4a86:	e8 00 00 00 00       	callq  4a8b <hiddev_read+0x32b>
    4a8b:	85 c0                	test   %eax,%eax
    4a8d:	74 91                	je     4a20 <hiddev_read+0x2c0>
    4a8f:	48 c7 c0 fc ff ff ff 	mov    $0xfffffffffffffffc,%rax
    4a96:	e9 4e fd ff ff       	jmpq   47e9 <hiddev_read+0x89>
    4a9b:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    4aa2:	00 
    4aa3:	48 c7 c0 f5 ff ff ff 	mov    $0xfffffffffffffff5,%rax
    4aaa:	48 89 85 50 ff ff ff 	mov    %rax,-0xb0(%rbp)
    4ab1:	48 83 c7 28          	add    $0x28,%rdi
    4ab5:	4c 89 fe             	mov    %r15,%rsi
    4ab8:	e8 00 00 00 00       	callq  4abd <hiddev_read+0x35d>
    4abd:	48 8b 7d 80          	mov    -0x80(%rbp),%rdi
    4ac1:	e8 00 00 00 00       	callq  4ac6 <hiddev_read+0x366>
    4ac6:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
    4acd:	e9 17 fd ff ff       	jmpq   47e9 <hiddev_read+0x89>
    4ad2:	8b 9d 64 ff ff ff    	mov    -0x9c(%rbp),%ebx
    4ad8:	4c 8b ad 58 ff ff ff 	mov    -0xa8(%rbp),%r13
    4adf:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    4ae6:	00 
    4ae7:	4c 89 fe             	mov    %r15,%rsi
    4aea:	48 83 c7 28          	add    $0x28,%rdi
    4aee:	e8 00 00 00 00       	callq  4af3 <hiddev_read+0x393>
    4af3:	41 8b b4 24 00 c0 00 	mov    0xc000(%r12),%esi
    4afa:	00 
    4afb:	41 8b 84 24 04 c0 00 	mov    0xc004(%r12),%eax
    4b02:	00 
    4b03:	39 c6                	cmp    %eax,%esi
    4b05:	0f 85 63 fd ff ff    	jne    486e <hiddev_read+0x10e>
    4b0b:	89 f0                	mov    %esi,%eax
    4b0d:	e9 54 fd ff ff       	jmpq   4866 <hiddev_read+0x106>
    4b12:	48 c7 c0 fb ff ff ff 	mov    $0xfffffffffffffffb,%rax
    4b19:	eb 8f                	jmp    4aaa <hiddev_read+0x34a>
    4b1b:	49 8b bc 24 18 c0 00 	mov    0xc018(%r12),%rdi
    4b22:	00 
    4b23:	48 c7 c0 00 fe ff ff 	mov    $0xfffffffffffffe00,%rax
    4b2a:	e9 7b ff ff ff       	jmpq   4aaa <hiddev_read+0x34a>
    4b2f:	90                   	nop

0000000000004b30 <hiddev_devnode>:
    4b30:	55                   	push   %rbp
    4b31:	48 89 e5             	mov    %rsp,%rbp
    4b34:	e8 00 00 00 00       	callq  4b39 <hiddev_devnode+0x9>
    4b39:	48 8b 57 50          	mov    0x50(%rdi),%rdx
    4b3d:	48 85 d2             	test   %rdx,%rdx
    4b40:	74 1e                	je     4b60 <hiddev_devnode+0x30>
    4b42:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    4b49:	bf d0 00 00 00       	mov    $0xd0,%edi
    4b4e:	31 c0                	xor    %eax,%eax
    4b50:	e8 00 00 00 00       	callq  4b55 <hiddev_devnode+0x25>
    4b55:	c9                   	leaveq 
    4b56:	c3                   	retq   
    4b57:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    4b5e:	00 00 
    4b60:	48 8b 57 10          	mov    0x10(%rdi),%rdx
    4b64:	eb dc                	jmp    4b42 <hiddev_devnode+0x12>
    4b66:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    4b6d:	00 00 00 

0000000000004b70 <hiddev_connect>:
    4b70:	55                   	push   %rbp
    4b71:	48 89 e5             	mov    %rsp,%rbp
    4b74:	41 57                	push   %r15
    4b76:	41 56                	push   %r14
    4b78:	41 55                	push   %r13
    4b7a:	41 54                	push   %r12
    4b7c:	53                   	push   %rbx
    4b7d:	48 83 ec 08          	sub    $0x8,%rsp
    4b81:	e8 00 00 00 00       	callq  4b86 <hiddev_connect+0x16>
    4b86:	48 89 fb             	mov    %rdi,%rbx
    4b89:	4c 8b af 00 1c 00 00 	mov    0x1c00(%rdi),%r13
    4b90:	85 f6                	test   %esi,%esi
    4b92:	75 6c                	jne    4c00 <hiddev_connect+0x90>
    4b94:	8b 4f 1c             	mov    0x1c(%rdi),%ecx
    4b97:	85 c9                	test   %ecx,%ecx
    4b99:	74 51                	je     4bec <hiddev_connect+0x7c>
    4b9b:	48 8b 47 10          	mov    0x10(%rdi),%rax
    4b9f:	31 d2                	xor    %edx,%edx
    4ba1:	eb 0f                	jmp    4bb2 <hiddev_connect+0x42>
    4ba3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4ba8:	ff c2                	inc    %edx
    4baa:	48 83 c0 0c          	add    $0xc,%rax
    4bae:	39 ca                	cmp    %ecx,%edx
    4bb0:	73 36                	jae    4be8 <hiddev_connect+0x78>
    4bb2:	83 38 01             	cmpl   $0x1,(%rax)
    4bb5:	75 f1                	jne    4ba8 <hiddev_connect+0x38>
    4bb7:	8b 70 04             	mov    0x4(%rax),%esi
    4bba:	8d be 00 00 ff ff    	lea    -0x10000(%rsi),%edi
    4bc0:	83 ff 08             	cmp    $0x8,%edi
    4bc3:	76 e3                	jbe    4ba8 <hiddev_connect+0x38>
    4bc5:	81 fe 80 00 01 00    	cmp    $0x10080,%esi
    4bcb:	74 db                	je     4ba8 <hiddev_connect+0x38>
    4bcd:	81 fe 01 00 0c 00    	cmp    $0xc0001,%esi
    4bd3:	74 d3                	je     4ba8 <hiddev_connect+0x38>
    4bd5:	81 ee 02 00 0d 00    	sub    $0xd0002,%esi
    4bdb:	83 fe 04             	cmp    $0x4,%esi
    4bde:	66 90                	xchg   %ax,%ax
    4be0:	76 c6                	jbe    4ba8 <hiddev_connect+0x38>
    4be2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    4be8:	39 ca                	cmp    %ecx,%edx
    4bea:	75 14                	jne    4c00 <hiddev_connect+0x90>
    4bec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    4bf1:	48 83 c4 08          	add    $0x8,%rsp
    4bf5:	5b                   	pop    %rbx
    4bf6:	41 5c                	pop    %r12
    4bf8:	41 5d                	pop    %r13
    4bfa:	41 5e                	pop    %r14
    4bfc:	41 5f                	pop    %r15
    4bfe:	c9                   	leaveq 
    4bff:	c3                   	retq   
    4c00:	be d0 80 00 00       	mov    $0x80d0,%esi
    4c05:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    4c0c:	e8 00 00 00 00       	callq  4c11 <hiddev_connect+0xa1>
    4c11:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 4c17 <hiddev_connect+0xa7>
    4c17:	49 89 c4             	mov    %rax,%r12
    4c1a:	4c 63 35 00 00 00 00 	movslq 0x0(%rip),%r14        # 4c21 <hiddev_connect+0xb1>
    4c21:	85 f6                	test   %esi,%esi
    4c23:	0f 85 a2 00 00 00    	jne    4ccb <hiddev_connect+0x15b>
    4c29:	4d 85 e4             	test   %r12,%r12
    4c2c:	74 be                	je     4bec <hiddev_connect+0x7c>
    4c2e:	49 8d 7c 24 28       	lea    0x28(%r12),%rdi
    4c33:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    4c3a:	e8 00 00 00 00       	callq  4c3f <hiddev_connect+0xcf>
    4c3f:	49 8d 44 24 48       	lea    0x48(%r12),%rax
    4c44:	49 8d 7c 24 08       	lea    0x8(%r12),%rdi
    4c49:	49 89 44 24 48       	mov    %rax,0x48(%r12)
    4c4e:	49 89 44 24 50       	mov    %rax,0x50(%r12)
    4c53:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
    4c5a:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    4c61:	41 c7 44 24 58 00 00 	movl   $0x0,0x58(%r12)
    4c68:	00 00 
    4c6a:	e8 00 00 00 00       	callq  4c6f <hiddev_connect+0xff>
    4c6f:	4c 89 a3 e8 1a 00 00 	mov    %r12,0x1ae8(%rbx)
    4c76:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    4c7d:	49 89 5c 24 40       	mov    %rbx,0x40(%r12)
    4c82:	41 c7 04 24 01 00 00 	movl   $0x1,(%r12)
    4c89:	00 
    4c8a:	49 8b 7d 08          	mov    0x8(%r13),%rdi
    4c8e:	e8 00 00 00 00       	callq  4c93 <hiddev_connect+0x123>
    4c93:	85 c0                	test   %eax,%eax
    4c95:	0f 84 56 ff ff ff    	je     4bf1 <hiddev_connect+0x81>
    4c9b:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    4ca2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    4ca9:	31 c0                	xor    %eax,%eax
    4cab:	e8 00 00 00 00       	callq  4cb0 <hiddev_connect+0x140>
    4cb0:	48 c7 83 e8 1a 00 00 	movq   $0x0,0x1ae8(%rbx)
    4cb7:	00 00 00 00 
    4cbb:	4c 89 e7             	mov    %r12,%rdi
    4cbe:	e8 00 00 00 00       	callq  4cc3 <hiddev_connect+0x153>
    4cc3:	83 c8 ff             	or     $0xffffffffffffffff,%eax
    4cc6:	e9 26 ff ff ff       	jmpq   4bf1 <hiddev_connect+0x81>
    4ccb:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    4cd2:	00 00 
    4cd4:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
    4cda:	4c 8b 3d 00 00 00 00 	mov    0x0(%rip),%r15        # 4ce1 <hiddev_connect+0x171>
    4ce1:	4d 85 ff             	test   %r15,%r15
    4ce4:	74 2d                	je     4d13 <hiddev_connect+0x1a3>
    4ce6:	49 8b 07             	mov    (%r15),%rax
    4ce9:	49 8b 7f 08          	mov    0x8(%r15),%rdi
    4ced:	41 b9 d0 80 00 00    	mov    $0x80d0,%r9d
    4cf3:	49 83 c7 10          	add    $0x10,%r15
    4cf7:	4d 89 f0             	mov    %r14,%r8
    4cfa:	b9 60 00 00 00       	mov    $0x60,%ecx
    4cff:	4c 89 e2             	mov    %r12,%rdx
    4d02:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    4d09:	ff d0                	callq  *%rax
    4d0b:	49 8b 07             	mov    (%r15),%rax
    4d0e:	48 85 c0             	test   %rax,%rax
    4d11:	75 d6                	jne    4ce9 <hiddev_connect+0x179>
    4d13:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    4d1a:	00 00 
    4d1c:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
    4d22:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
    4d29:	a8 08                	test   $0x8,%al
    4d2b:	0f 84 f8 fe ff ff    	je     4c29 <hiddev_connect+0xb9>
    4d31:	e8 00 00 00 00       	callq  4d36 <hiddev_connect+0x1c6>
    4d36:	e9 ee fe ff ff       	jmpq   4c29 <hiddev_connect+0xb9>
    4d3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000004d40 <hiddev_send_event>:
    4d40:	55                   	push   %rbp
    4d41:	48 89 e5             	mov    %rsp,%rbp
    4d44:	41 57                	push   %r15
    4d46:	41 56                	push   %r14
    4d48:	41 55                	push   %r13
    4d4a:	41 54                	push   %r12
    4d4c:	53                   	push   %rbx
    4d4d:	48 83 ec 18          	sub    $0x18,%rsp
    4d51:	e8 00 00 00 00       	callq  4d56 <hiddev_send_event+0x16>
    4d56:	4c 8b a7 e8 1a 00 00 	mov    0x1ae8(%rdi),%r12
    4d5d:	48 89 f3             	mov    %rsi,%rbx
    4d60:	4d 8d 6c 24 58       	lea    0x58(%r12),%r13
    4d65:	4d 8d 7c 24 48       	lea    0x48(%r12),%r15
    4d6a:	4c 89 ef             	mov    %r13,%rdi
    4d6d:	e8 00 00 00 00       	callq  4d72 <hiddev_send_event+0x32>
    4d72:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    4d76:	4d 8b 74 24 48       	mov    0x48(%r12),%r14
    4d7b:	49 81 ee 20 c0 00 00 	sub    $0xc020,%r14
    4d82:	eb 79                	jmp    4dfd <hiddev_send_event+0xbd>
    4d84:	0f 1f 40 00          	nopl   0x0(%rax)
    4d88:	83 7b 08 ff          	cmpl   $0xffffffffffffffff,0x8(%rbx)
    4d8c:	75 0a                	jne    4d98 <hiddev_send_event+0x58>
    4d8e:	41 f6 86 08 c0 00 00 	testb  $0x2,0xc008(%r14)
    4d95:	02 
    4d96:	74 5e                	je     4df6 <hiddev_send_event+0xb6>
    4d98:	49 63 86 00 c0 00 00 	movslq 0xc000(%r14),%rax
    4d9f:	48 8b 0b             	mov    (%rbx),%rcx
    4da2:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    4da6:	49 8d be 10 c0 00 00 	lea    0xc010(%r14),%rdi
    4dad:	49 89 0c d6          	mov    %rcx,(%r14,%rdx,8)
    4db1:	48 8d 04 d5 00 00 00 	lea    0x0(,%rdx,8),%rax
    4db8:	00 
    4db9:	be 1d 00 00 00       	mov    $0x1d,%esi
    4dbe:	48 8b 53 08          	mov    0x8(%rbx),%rdx
    4dc2:	4a 89 54 30 08       	mov    %rdx,0x8(%rax,%r14,1)
    4dc7:	48 8b 53 10          	mov    0x10(%rbx),%rdx
    4dcb:	4a 89 54 30 10       	mov    %rdx,0x10(%rax,%r14,1)
    4dd0:	ba 01 00 02 00       	mov    $0x20001,%edx
    4dd5:	41 8b 86 00 c0 00 00 	mov    0xc000(%r14),%eax
    4ddc:	ff c0                	inc    %eax
    4dde:	25 ff 07 00 00       	and    $0x7ff,%eax
    4de3:	41 89 86 00 c0 00 00 	mov    %eax,0xc000(%r14)
    4dea:	e8 00 00 00 00       	callq  4def <hiddev_send_event+0xaf>
    4def:	49 8b 86 20 c0 00 00 	mov    0xc020(%r14),%rax
    4df6:	4c 8d b0 e0 3f ff ff 	lea    -0xc020(%rax),%r14
    4dfd:	49 8b 86 20 c0 00 00 	mov    0xc020(%r14),%rax
    4e04:	49 8d 96 20 c0 00 00 	lea    0xc020(%r14),%rdx
    4e0b:	0f 18 08             	prefetcht0 (%rax)
    4e0e:	49 39 d7             	cmp    %rdx,%r15
    4e11:	0f 85 71 ff ff ff    	jne    4d88 <hiddev_send_event+0x48>
    4e17:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
    4e1b:	4c 89 ef             	mov    %r13,%rdi
    4e1e:	e8 00 00 00 00       	callq  4e23 <hiddev_send_event+0xe3>
    4e23:	49 8d 7c 24 28       	lea    0x28(%r12),%rdi
    4e28:	31 c9                	xor    %ecx,%ecx
    4e2a:	ba 01 00 00 00       	mov    $0x1,%edx
    4e2f:	be 01 00 00 00       	mov    $0x1,%esi
    4e34:	e8 00 00 00 00       	callq  4e39 <hiddev_send_event+0xf9>
    4e39:	48 83 c4 18          	add    $0x18,%rsp
    4e3d:	5b                   	pop    %rbx
    4e3e:	41 5c                	pop    %r12
    4e40:	41 5d                	pop    %r13
    4e42:	41 5e                	pop    %r14
    4e44:	41 5f                	pop    %r15
    4e46:	c9                   	leaveq 
    4e47:	c3                   	retq   
    4e48:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    4e4f:	00 

0000000000004e50 <hiddev_report_event>:
    4e50:	55                   	push   %rbp
    4e51:	48 89 e5             	mov    %rsp,%rbp
    4e54:	48 83 ec 20          	sub    $0x20,%rsp
    4e58:	e8 00 00 00 00       	callq  4e5d <hiddev_report_event+0xd>
    4e5d:	b8 01 00 00 00       	mov    $0x1,%eax
    4e62:	8b 56 14             	mov    0x14(%rsi),%edx
    4e65:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
    4e6c:	00 
    4e6d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
    4e74:	00 
    4e75:	85 d2                	test   %edx,%edx
    4e77:	74 12                	je     4e8b <hiddev_report_event+0x3b>
    4e79:	b0 02                	mov    $0x2,%al
    4e7b:	83 fa 01             	cmp    $0x1,%edx
    4e7e:	74 0b                	je     4e8b <hiddev_report_event+0x3b>
    4e80:	31 c0                	xor    %eax,%eax
    4e82:	83 fa 02             	cmp    $0x2,%edx
    4e85:	0f 94 c0             	sete   %al
    4e88:	8d 04 40             	lea    (%rax,%rax,2),%eax
    4e8b:	89 45 e0             	mov    %eax,-0x20(%rbp)
    4e8e:	8b 46 10             	mov    0x10(%rsi),%eax
    4e91:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
    4e98:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    4e9b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
    4e9f:	e8 9c fe ff ff       	callq  4d40 <hiddev_send_event>
    4ea4:	c9                   	leaveq 
    4ea5:	c3                   	retq   
    4ea6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    4ead:	00 00 00 

0000000000004eb0 <hiddev_hid_event>:
    4eb0:	55                   	push   %rbp
    4eb1:	48 89 e5             	mov    %rsp,%rbp
    4eb4:	48 83 ec 20          	sub    $0x20,%rsp
    4eb8:	e8 00 00 00 00       	callq  4ebd <hiddev_hid_event+0xd>
    4ebd:	b8 01 00 00 00       	mov    $0x1,%eax
    4ec2:	44 8b 46 2c          	mov    0x2c(%rsi),%r8d
    4ec6:	45 85 c0             	test   %r8d,%r8d
    4ec9:	74 14                	je     4edf <hiddev_hid_event+0x2f>
    4ecb:	b0 02                	mov    $0x2,%al
    4ecd:	41 83 f8 01          	cmp    $0x1,%r8d
    4ed1:	74 0c                	je     4edf <hiddev_hid_event+0x2f>
    4ed3:	31 c0                	xor    %eax,%eax
    4ed5:	41 83 f8 02          	cmp    $0x2,%r8d
    4ed9:	0f 94 c0             	sete   %al
    4edc:	8d 04 40             	lea    (%rax,%rax,2),%eax
    4edf:	89 45 e0             	mov    %eax,-0x20(%rbp)
    4ee2:	48 8b 46 50          	mov    0x50(%rsi),%rax
    4ee6:	8b 40 10             	mov    0x10(%rax),%eax
    4ee9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    4eec:	8b 46 58             	mov    0x58(%rsi),%eax
    4eef:	89 45 e8             	mov    %eax,-0x18(%rbp)
    4ef2:	48 89 d0             	mov    %rdx,%rax
    4ef5:	48 2b 46 10          	sub    0x10(%rsi),%rax
    4ef9:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    4efc:	48 c1 f8 04          	sar    $0x4,%rax
    4f00:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
    4f04:	89 45 ec             	mov    %eax,-0x14(%rbp)
    4f07:	8b 02                	mov    (%rdx),%eax
    4f09:	89 45 f0             	mov    %eax,-0x10(%rbp)
    4f0c:	e8 2f fe ff ff       	callq  4d40 <hiddev_send_event>
    4f11:	c9                   	leaveq 
    4f12:	c3                   	retq   
    4f13:	90                   	nop
    4f14:	90                   	nop
    4f15:	90                   	nop
    4f16:	90                   	nop
    4f17:	90                   	nop
    4f18:	90                   	nop
    4f19:	90                   	nop
    4f1a:	90                   	nop
    4f1b:	90                   	nop
    4f1c:	90                   	nop
    4f1d:	90                   	nop
    4f1e:	90                   	nop
    4f1f:	90                   	nop

0000000000004f20 <pidff_find_special_field>:
    4f20:	55                   	push   %rbp
    4f21:	48 89 e5             	mov    %rsp,%rbp
    4f24:	e8 00 00 00 00       	callq  4f29 <pidff_find_special_field+0x9>
    4f29:	44 8b 87 18 02 00 00 	mov    0x218(%rdi),%r8d
    4f30:	45 85 c0             	test   %r8d,%r8d
    4f33:	74 28                	je     4f5d <pidff_find_special_field+0x3d>
    4f35:	81 ce 00 00 0f 00    	or     $0xf0000,%esi
    4f3b:	31 c9                	xor    %ecx,%ecx
    4f3d:	0f 1f 00             	nopl   (%rax)
    4f40:	48 8b 47 18          	mov    0x18(%rdi),%rax
    4f44:	39 70 04             	cmp    %esi,0x4(%rax)
    4f47:	75 09                	jne    4f52 <pidff_find_special_field+0x32>
    4f49:	44 8b 48 28          	mov    0x28(%rax),%r9d
    4f4d:	45 85 c9             	test   %r9d,%r9d
    4f50:	75 16                	jne    4f68 <pidff_find_special_field+0x48>
    4f52:	ff c1                	inc    %ecx
    4f54:	48 83 c7 08          	add    $0x8,%rdi
    4f58:	41 39 c8             	cmp    %ecx,%r8d
    4f5b:	77 e3                	ja     4f40 <pidff_find_special_field+0x20>
    4f5d:	31 c0                	xor    %eax,%eax
    4f5f:	c9                   	leaveq 
    4f60:	c3                   	retq   
    4f61:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    4f68:	85 d2                	test   %edx,%edx
    4f6a:	74 f3                	je     4f5f <pidff_find_special_field+0x3f>
    4f6c:	83 78 38 01          	cmpl   $0x1,0x38(%rax)
    4f70:	74 ed                	je     4f5f <pidff_find_special_field+0x3f>
    4f72:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    4f79:	31 c0                	xor    %eax,%eax
    4f7b:	e8 00 00 00 00       	callq  4f80 <pidff_find_special_field+0x60>
    4f80:	31 c0                	xor    %eax,%eax
    4f82:	c9                   	leaveq 
    4f83:	c3                   	retq   
    4f84:	66 66 66 2e 0f 1f 84 	nopw   %cs:0x0(%rax,%rax,1)
    4f8b:	00 00 00 00 00 

0000000000004f90 <pidff_find_fields>:
    4f90:	55                   	push   %rbp
    4f91:	48 89 e5             	mov    %rsp,%rbp
    4f94:	41 57                	push   %r15
    4f96:	41 56                	push   %r14
    4f98:	41 55                	push   %r13
    4f9a:	41 54                	push   %r12
    4f9c:	53                   	push   %rbx
    4f9d:	48 83 ec 28          	sub    $0x28,%rsp
    4fa1:	e8 00 00 00 00       	callq  4fa6 <pidff_find_fields+0x16>
    4fa6:	48 89 d3             	mov    %rdx,%rbx
    4fa9:	89 4d cc             	mov    %ecx,-0x34(%rbp)
    4fac:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    4fb0:	85 c9                	test   %ecx,%ecx
    4fb2:	0f 8e d7 00 00 00    	jle    508f <pidff_find_fields+0xff>
    4fb8:	49 89 fd             	mov    %rdi,%r13
    4fbb:	49 89 f6             	mov    %rsi,%r14
    4fbe:	45 31 c9             	xor    %r9d,%r9d
    4fc1:	49 bc 00 00 00 00 00 	mov    $0x20000000000000,%r12
    4fc8:	00 20 00 
    4fcb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    4fd0:	31 d2                	xor    %edx,%edx
    4fd2:	44 8b 93 18 02 00 00 	mov    0x218(%rbx),%r10d
    4fd9:	49 89 df             	mov    %rbx,%r15
    4fdc:	45 85 d2             	test   %r10d,%r10d
    4fdf:	75 2e                	jne    500f <pidff_find_fields+0x7f>
    4fe1:	e9 ba 00 00 00       	jmpq   50a0 <pidff_find_fields+0x110>
    4fe6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    4fed:	00 00 00 
    4ff0:	4c 85 25 00 00 00 00 	test   %r12,0x0(%rip)        # 4ff7 <pidff_find_fields+0x67>
    4ff7:	0f 85 c5 00 00 00    	jne    50c2 <pidff_find_fields+0x132>
    4ffd:	ff c2                	inc    %edx
    4fff:	49 83 c7 08          	add    $0x8,%r15
    5003:	39 93 18 02 00 00    	cmp    %edx,0x218(%rbx)
    5009:	0f 86 91 00 00 00    	jbe    50a0 <pidff_find_fields+0x110>
    500f:	49 8b 7f 18          	mov    0x18(%r15),%rdi
    5013:	8b 77 18             	mov    0x18(%rdi),%esi
    5016:	3b 77 28             	cmp    0x28(%rdi),%esi
    5019:	75 d5                	jne    4ff0 <pidff_find_fields+0x60>
    501b:	85 f6                	test   %esi,%esi
    501d:	74 de                	je     4ffd <pidff_find_fields+0x6d>
    501f:	4c 8b 5f 10          	mov    0x10(%rdi),%r11
    5023:	45 0f b6 16          	movzbl (%r14),%r10d
    5027:	41 81 ca 00 00 0f 00 	or     $0xf0000,%r10d
    502e:	45 39 13             	cmp    %r10d,(%r11)
    5031:	0f 84 84 00 00 00    	je     50bb <pidff_find_fields+0x12b>
    5037:	31 c9                	xor    %ecx,%ecx
    5039:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    5040:	ff c1                	inc    %ecx
    5042:	39 ce                	cmp    %ecx,%esi
    5044:	76 b7                	jbe    4ffd <pidff_find_fields+0x6d>
    5046:	4c 63 c1             	movslq %ecx,%r8
    5049:	4c 89 c0             	mov    %r8,%rax
    504c:	48 c1 e0 04          	shl    $0x4,%rax
    5050:	46 39 14 18          	cmp    %r10d,(%rax,%r11,1)
    5054:	75 ea                	jne    5040 <pidff_find_fields+0xb0>
    5056:	49 c1 e0 02          	shl    $0x2,%r8
    505a:	4c 85 25 00 00 00 00 	test   %r12,0x0(%rip)        # 5061 <pidff_find_fields+0xd1>
    5061:	0f 85 96 00 00 00    	jne    50fd <pidff_find_fields+0x16d>
    5067:	4c 63 fa             	movslq %edx,%r15
    506a:	49 89 7d 00          	mov    %rdi,0x0(%r13)
    506e:	4a 8b 44 fb 18       	mov    0x18(%rbx,%r15,8),%rax
    5073:	4c 03 40 30          	add    0x30(%rax),%r8
    5077:	4d 89 45 08          	mov    %r8,0x8(%r13)
    507b:	41 ff c1             	inc    %r9d
    507e:	49 83 c5 10          	add    $0x10,%r13
    5082:	49 ff c6             	inc    %r14
    5085:	44 39 4d cc          	cmp    %r9d,-0x34(%rbp)
    5089:	0f 8f 41 ff ff ff    	jg     4fd0 <pidff_find_fields+0x40>
    508f:	31 c0                	xor    %eax,%eax
    5091:	48 83 c4 28          	add    $0x28,%rsp
    5095:	5b                   	pop    %rbx
    5096:	41 5c                	pop    %r12
    5098:	41 5d                	pop    %r13
    509a:	41 5e                	pop    %r14
    509c:	41 5f                	pop    %r15
    509e:	c9                   	leaveq 
    509f:	c3                   	retq   
    50a0:	44 8b 5d c8          	mov    -0x38(%rbp),%r11d
    50a4:	45 85 db             	test   %r11d,%r11d
    50a7:	74 d2                	je     507b <pidff_find_fields+0xeb>
    50a9:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 50b0 <pidff_find_fields+0x120>
    50b0:	0f 85 8f 00 00 00    	jne    5145 <pidff_find_fields+0x1b5>
    50b6:	83 c8 ff             	or     $0xffffffffffffffff,%eax
    50b9:	eb d6                	jmp    5091 <pidff_find_fields+0x101>
    50bb:	45 31 c0             	xor    %r8d,%r8d
    50be:	31 c9                	xor    %ecx,%ecx
    50c0:	eb 98                	jmp    505a <pidff_find_fields+0xca>
    50c2:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 50c9 <pidff_find_fields+0x139>
    50c9:	0f 84 2e ff ff ff    	je     4ffd <pidff_find_fields+0x6d>
    50cf:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 50d6 <pidff_find_fields+0x146>
    50d6:	0f 84 21 ff ff ff    	je     4ffd <pidff_find_fields+0x6d>
    50dc:	89 55 b8             	mov    %edx,-0x48(%rbp)
    50df:	44 89 4d c0          	mov    %r9d,-0x40(%rbp)
    50e3:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    50ea:	31 c0                	xor    %eax,%eax
    50ec:	e8 00 00 00 00       	callq  50f1 <pidff_find_fields+0x161>
    50f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
    50f4:	44 8b 4d c0          	mov    -0x40(%rbp),%r9d
    50f8:	e9 00 ff ff ff       	jmpq   4ffd <pidff_find_fields+0x6d>
    50fd:	4c 63 fa             	movslq %edx,%r15
    5100:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5107 <pidff_find_fields+0x177>
    5107:	0f 84 5d ff ff ff    	je     506a <pidff_find_fields+0xda>
    510d:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5114 <pidff_find_fields+0x184>
    5114:	0f 84 50 ff ff ff    	je     506a <pidff_find_fields+0xda>
    511a:	44 89 ce             	mov    %r9d,%esi
    511d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5124:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
    5128:	44 89 4d c0          	mov    %r9d,-0x40(%rbp)
    512c:	31 c0                	xor    %eax,%eax
    512e:	e8 00 00 00 00       	callq  5133 <pidff_find_fields+0x1a3>
    5133:	4a 8b 7c fb 18       	mov    0x18(%rbx,%r15,8),%rdi
    5138:	4c 8b 45 b8          	mov    -0x48(%rbp),%r8
    513c:	44 8b 4d c0          	mov    -0x40(%rbp),%r9d
    5140:	e9 25 ff ff ff       	jmpq   506a <pidff_find_fields+0xda>
    5145:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 514c <pidff_find_fields+0x1bc>
    514c:	0f 84 64 ff ff ff    	je     50b6 <pidff_find_fields+0x126>
    5152:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5159 <pidff_find_fields+0x1c9>
    5159:	0f 84 57 ff ff ff    	je     50b6 <pidff_find_fields+0x126>
    515f:	44 89 ce             	mov    %r9d,%esi
    5162:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5169:	31 c0                	xor    %eax,%eax
    516b:	e8 00 00 00 00       	callq  5170 <pidff_find_fields+0x1e0>
    5170:	83 c8 ff             	or     $0xffffffffffffffff,%eax
    5173:	e9 19 ff ff ff       	jmpq   5091 <pidff_find_fields+0x101>
    5178:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    517f:	00 

0000000000005180 <pidff_set>:
    5180:	55                   	push   %rbp
    5181:	48 89 e5             	mov    %rsp,%rbp
    5184:	e8 00 00 00 00       	callq  5189 <pidff_set+0x9>
    5189:	ba 01 80 00 80       	mov    $0x80008001,%edx
    518e:	48 8b 07             	mov    (%rdi),%rax
    5191:	0f b7 f6             	movzwl %si,%esi
    5194:	44 8b 40 38          	mov    0x38(%rax),%r8d
    5198:	8b 48 3c             	mov    0x3c(%rax),%ecx
    519b:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
    519f:	44 29 c1             	sub    %r8d,%ecx
    51a2:	0f af ce             	imul   %esi,%ecx
    51a5:	89 c8                	mov    %ecx,%eax
    51a7:	f7 ea                	imul   %edx
    51a9:	01 ca                	add    %ecx,%edx
    51ab:	c1 f9 1f             	sar    $0x1f,%ecx
    51ae:	c1 fa 0f             	sar    $0xf,%edx
    51b1:	29 ca                	sub    %ecx,%edx
    51b3:	44 01 c2             	add    %r8d,%edx
    51b6:	41 89 11             	mov    %edx,(%r9)
    51b9:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 51c0 <pidff_set+0x40>
    51c0:	75 02                	jne    51c4 <pidff_set+0x44>
    51c2:	c9                   	leaveq 
    51c3:	c3                   	retq   
    51c4:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 51cb <pidff_set+0x4b>
    51cb:	74 f5                	je     51c2 <pidff_set+0x42>
    51cd:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 51d4 <pidff_set+0x54>
    51d4:	74 ec                	je     51c2 <pidff_set+0x42>
    51d6:	48 8b 47 08          	mov    0x8(%rdi),%rax
    51da:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    51e1:	8b 10                	mov    (%rax),%edx
    51e3:	31 c0                	xor    %eax,%eax
    51e5:	e8 00 00 00 00       	callq  51ea <pidff_set+0x6a>
    51ea:	c9                   	leaveq 
    51eb:	c3                   	retq   
    51ec:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000051f0 <pidff_set_signed>:
    51f0:	55                   	push   %rbp
    51f1:	48 89 e5             	mov    %rsp,%rbp
    51f4:	e8 00 00 00 00       	callq  51f9 <pidff_set_signed+0x9>
    51f9:	48 8b 07             	mov    (%rdi),%rax
    51fc:	8b 48 38             	mov    0x38(%rax),%ecx
    51ff:	85 c9                	test   %ecx,%ecx
    5201:	78 45                	js     5248 <pidff_set_signed+0x58>
    5203:	66 85 f6             	test   %si,%si
    5206:	78 78                	js     5280 <pidff_set_signed+0x90>
    5208:	44 8b 40 3c          	mov    0x3c(%rax),%r8d
    520c:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
    5210:	0f bf f6             	movswl %si,%esi
    5213:	41 29 c8             	sub    %ecx,%r8d
    5216:	ba 03 00 01 80       	mov    $0x80010003,%edx
    521b:	44 0f af c6          	imul   %esi,%r8d
    521f:	44 89 c0             	mov    %r8d,%eax
    5222:	f7 ea                	imul   %edx
    5224:	44 01 c2             	add    %r8d,%edx
    5227:	41 c1 f8 1f          	sar    $0x1f,%r8d
    522b:	c1 fa 0e             	sar    $0xe,%edx
    522e:	44 29 c2             	sub    %r8d,%edx
    5231:	01 ca                	add    %ecx,%edx
    5233:	41 89 11             	mov    %edx,(%r9)
    5236:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 523d <pidff_set_signed+0x4d>
    523d:	75 69                	jne    52a8 <pidff_set_signed+0xb8>
    523f:	c9                   	leaveq 
    5240:	c3                   	retq   
    5241:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    5248:	0f bf f6             	movswl %si,%esi
    524b:	31 d2                	xor    %edx,%edx
    524d:	4c 8b 47 08          	mov    0x8(%rdi),%r8
    5251:	83 fe 00             	cmp    $0x0,%esi
    5254:	74 21                	je     5277 <pidff_set_signed+0x87>
    5256:	7e 78                	jle    52d0 <pidff_set_signed+0xe0>
    5258:	44 8b 48 3c          	mov    0x3c(%rax),%r9d
    525c:	ba 03 00 01 80       	mov    $0x80010003,%edx
    5261:	44 0f af ce          	imul   %esi,%r9d
    5265:	44 89 c8             	mov    %r9d,%eax
    5268:	f7 ea                	imul   %edx
    526a:	44 01 ca             	add    %r9d,%edx
    526d:	41 c1 f9 1f          	sar    $0x1f,%r9d
    5271:	c1 fa 0e             	sar    $0xe,%edx
    5274:	44 29 ca             	sub    %r9d,%edx
    5277:	41 89 10             	mov    %edx,(%r8)
    527a:	eb ba                	jmp    5236 <pidff_set_signed+0x46>
    527c:	0f 1f 40 00          	nopl   0x0(%rax)
    5280:	8b 40 3c             	mov    0x3c(%rax),%eax
    5283:	4c 8b 47 08          	mov    0x8(%rdi),%r8
    5287:	29 c8                	sub    %ecx,%eax
    5289:	0f bf f6             	movswl %si,%esi
    528c:	89 f2                	mov    %esi,%edx
    528e:	f7 da                	neg    %edx
    5290:	0f af d0             	imul   %eax,%edx
    5293:	85 d2                	test   %edx,%edx
    5295:	8d 82 ff 7f 00 00    	lea    0x7fff(%rdx),%eax
    529b:	0f 48 d0             	cmovs  %eax,%edx
    529e:	c1 fa 0f             	sar    $0xf,%edx
    52a1:	01 ca                	add    %ecx,%edx
    52a3:	41 89 10             	mov    %edx,(%r8)
    52a6:	eb 8e                	jmp    5236 <pidff_set_signed+0x46>
    52a8:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 52af <pidff_set_signed+0xbf>
    52af:	74 8e                	je     523f <pidff_set_signed+0x4f>
    52b1:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 52b8 <pidff_set_signed+0xc8>
    52b8:	74 85                	je     523f <pidff_set_signed+0x4f>
    52ba:	48 8b 47 08          	mov    0x8(%rdi),%rax
    52be:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    52c5:	8b 10                	mov    (%rax),%edx
    52c7:	31 c0                	xor    %eax,%eax
    52c9:	e8 00 00 00 00       	callq  52ce <pidff_set_signed+0xde>
    52ce:	c9                   	leaveq 
    52cf:	c3                   	retq   
    52d0:	0f af ce             	imul   %esi,%ecx
    52d3:	85 c9                	test   %ecx,%ecx
    52d5:	8d 91 ff 7f 00 00    	lea    0x7fff(%rcx),%edx
    52db:	0f 49 d1             	cmovns %ecx,%edx
    52de:	c1 fa 0f             	sar    $0xf,%edx
    52e1:	f7 da                	neg    %edx
    52e3:	eb 92                	jmp    5277 <pidff_set_signed+0x87>
    52e5:	66 66 2e 0f 1f 84 00 	nopw   %cs:0x0(%rax,%rax,1)
    52ec:	00 00 00 00 

00000000000052f0 <pidff_playback_pid>:
    52f0:	55                   	push   %rbp
    52f1:	48 89 e5             	mov    %rsp,%rbp
    52f4:	e8 00 00 00 00       	callq  52f9 <pidff_playback_pid+0x9>
    52f9:	48 8b 87 b8 02 00 00 	mov    0x2b8(%rdi),%rax
    5300:	85 d2                	test   %edx,%edx
    5302:	89 30                	mov    %esi,(%rax)
    5304:	74 32                	je     5338 <pidff_playback_pid+0x48>
    5306:	48 8b 87 08 03 00 00 	mov    0x308(%rdi),%rax
    530d:	8b 8f 4c 03 00 00    	mov    0x34c(%rdi),%ecx
    5313:	48 8b 40 30          	mov    0x30(%rax),%rax
    5317:	89 08                	mov    %ecx,(%rax)
    5319:	48 8b 87 c8 02 00 00 	mov    0x2c8(%rdi),%rax
    5320:	89 10                	mov    %edx,(%rax)
    5322:	48 8b 77 10          	mov    0x10(%rdi),%rsi
    5326:	31 d2                	xor    %edx,%edx
    5328:	48 8b 3f             	mov    (%rdi),%rdi
    532b:	e8 00 00 00 00       	callq  5330 <pidff_playback_pid+0x40>
    5330:	c9                   	leaveq 
    5331:	c3                   	retq   
    5332:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5338:	48 8b 87 08 03 00 00 	mov    0x308(%rdi),%rax
    533f:	8b 97 50 03 00 00    	mov    0x350(%rdi),%edx
    5345:	48 8b 40 30          	mov    0x30(%rax),%rax
    5349:	89 10                	mov    %edx,(%rax)
    534b:	eb d5                	jmp    5322 <pidff_playback_pid+0x32>
    534d:	0f 1f 00             	nopl   (%rax)

0000000000005350 <pidff_playback>:
    5350:	55                   	push   %rbp
    5351:	48 89 e5             	mov    %rsp,%rbp
    5354:	e8 00 00 00 00       	callq  5359 <pidff_playback+0x9>
    5359:	48 8b 87 f0 00 00 00 	mov    0xf0(%rdi),%rax
    5360:	48 63 f6             	movslq %esi,%rsi
    5363:	48 8b 78 30          	mov    0x30(%rax),%rdi
    5367:	8b b4 b7 54 03 00 00 	mov    0x354(%rdi,%rsi,4),%esi
    536e:	e8 7d ff ff ff       	callq  52f0 <pidff_playback_pid>
    5373:	31 c0                	xor    %eax,%eax
    5375:	c9                   	leaveq 
    5376:	c3                   	retq   
    5377:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    537e:	00 00 

0000000000005380 <pidff_autocenter>:
    5380:	55                   	push   %rbp
    5381:	48 89 e5             	mov    %rsp,%rbp
    5384:	41 54                	push   %r12
    5386:	53                   	push   %rbx
    5387:	e8 00 00 00 00       	callq  538c <pidff_autocenter+0xc>
    538c:	48 89 fb             	mov    %rdi,%rbx
    538f:	41 89 f4             	mov    %esi,%r12d
    5392:	48 8b 87 60 02 00 00 	mov    0x260(%rdi),%rax
    5399:	66 85 f6             	test   %si,%si
    539c:	0f 84 9e 00 00 00    	je     5440 <pidff_autocenter+0xc0>
    53a2:	8b 70 38             	mov    0x38(%rax),%esi
    53a5:	ba 01 00 00 00       	mov    $0x1,%edx
    53aa:	e8 41 ff ff ff       	callq  52f0 <pidff_playback_pid>
    53af:	48 8b 43 78          	mov    0x78(%rbx),%rax
    53b3:	48 8b 93 60 02 00 00 	mov    0x260(%rbx),%rdx
    53ba:	41 0f b7 f4          	movzwl %r12w,%esi
    53be:	8b 52 38             	mov    0x38(%rdx),%edx
    53c1:	48 8d bb 90 00 00 00 	lea    0x90(%rbx),%rdi
    53c8:	89 10                	mov    %edx,(%rax)
    53ca:	48 8b 83 e8 02 00 00 	mov    0x2e8(%rbx),%rax
    53d1:	8b 93 34 03 00 00    	mov    0x334(%rbx),%edx
    53d7:	48 8b 40 30          	mov    0x30(%rax),%rax
    53db:	89 10                	mov    %edx,(%rax)
    53dd:	48 8b 83 88 00 00 00 	mov    0x88(%rbx),%rax
    53e4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    53ea:	48 8b 83 a8 00 00 00 	mov    0xa8(%rbx),%rax
    53f1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    53f7:	48 8b 83 b8 00 00 00 	mov    0xb8(%rbx),%rax
    53fe:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    5404:	e8 77 fd ff ff       	callq  5180 <pidff_set>
    5409:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
    5410:	31 d2                	xor    %edx,%edx
    5412:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
    5418:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
    541f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    5425:	48 8b 73 08          	mov    0x8(%rbx),%rsi
    5429:	48 8b 3b             	mov    (%rbx),%rdi
    542c:	e8 00 00 00 00       	callq  5431 <pidff_autocenter+0xb1>
    5431:	5b                   	pop    %rbx
    5432:	41 5c                	pop    %r12
    5434:	c9                   	leaveq 
    5435:	c3                   	retq   
    5436:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    543d:	00 00 00 
    5440:	8b 70 38             	mov    0x38(%rax),%esi
    5443:	31 d2                	xor    %edx,%edx
    5445:	e8 a6 fe ff ff       	callq  52f0 <pidff_playback_pid>
    544a:	5b                   	pop    %rbx
    544b:	41 5c                	pop    %r12
    544d:	c9                   	leaveq 
    544e:	c3                   	retq   
    544f:	90                   	nop

0000000000005450 <pidff_set_autocenter>:
    5450:	55                   	push   %rbp
    5451:	48 89 e5             	mov    %rsp,%rbp
    5454:	e8 00 00 00 00       	callq  5459 <pidff_set_autocenter+0x9>
    5459:	48 8b 87 f0 00 00 00 	mov    0xf0(%rdi),%rax
    5460:	0f b7 f6             	movzwl %si,%esi
    5463:	48 8b 78 30          	mov    0x30(%rax),%rdi
    5467:	e8 14 ff ff ff       	callq  5380 <pidff_autocenter>
    546c:	c9                   	leaveq 
    546d:	c3                   	retq   
    546e:	66 90                	xchg   %ax,%ax

0000000000005470 <pidff_set_gain>:
    5470:	55                   	push   %rbp
    5471:	48 89 e5             	mov    %rsp,%rbp
    5474:	53                   	push   %rbx
    5475:	48 83 ec 08          	sub    $0x8,%rsp
    5479:	e8 00 00 00 00       	callq  547e <pidff_set_gain+0xe>
    547e:	48 8b 87 f0 00 00 00 	mov    0xf0(%rdi),%rax
    5485:	0f b7 f6             	movzwl %si,%esi
    5488:	48 8b 58 30          	mov    0x30(%rax),%rbx
    548c:	48 8d bb 50 02 00 00 	lea    0x250(%rbx),%rdi
    5493:	e8 e8 fc ff ff       	callq  5180 <pidff_set>
    5498:	48 8b 73 18          	mov    0x18(%rbx),%rsi
    549c:	48 8b 3b             	mov    (%rbx),%rdi
    549f:	31 d2                	xor    %edx,%edx
    54a1:	e8 00 00 00 00       	callq  54a6 <pidff_set_gain+0x36>
    54a6:	48 83 c4 08          	add    $0x8,%rsp
    54aa:	5b                   	pop    %rbx
    54ab:	c9                   	leaveq 
    54ac:	c3                   	retq   
    54ad:	0f 1f 00             	nopl   (%rax)

00000000000054b0 <pidff_set_envelope_report>:
    54b0:	55                   	push   %rbp
    54b1:	48 89 e5             	mov    %rsp,%rbp
    54b4:	53                   	push   %rbx
    54b5:	48 83 ec 08          	sub    $0x8,%rsp
    54b9:	e8 00 00 00 00       	callq  54be <pidff_set_envelope_report+0xe>
    54be:	b9 ff 7f 00 00       	mov    $0x7fff,%ecx
    54c3:	48 8b 87 e8 00 00 00 	mov    0xe8(%rdi),%rax
    54ca:	48 8b 97 68 02 00 00 	mov    0x268(%rdi),%rdx
    54d1:	48 89 fb             	mov    %rdi,%rbx
    54d4:	8b 12                	mov    (%rdx),%edx
    54d6:	41 b8 03 00 01 80    	mov    $0x80010003,%r8d
    54dc:	89 10                	mov    %edx,(%rax)
    54de:	48 8b 87 f0 00 00 00 	mov    0xf0(%rdi),%rax
    54e5:	0f b7 56 02          	movzwl 0x2(%rsi),%edx
    54e9:	44 8b 48 38          	mov    0x38(%rax),%r9d
    54ed:	66 85 d2             	test   %dx,%dx
    54f0:	4c 8b 97 f8 00 00 00 	mov    0xf8(%rdi),%r10
    54f7:	8b 40 3c             	mov    0x3c(%rax),%eax
    54fa:	0f b7 fa             	movzwl %dx,%edi
    54fd:	0f 48 f9             	cmovs  %ecx,%edi
    5500:	44 29 c8             	sub    %r9d,%eax
    5503:	0f af f8             	imul   %eax,%edi
    5506:	89 f8                	mov    %edi,%eax
    5508:	41 f7 e8             	imul   %r8d
    550b:	01 fa                	add    %edi,%edx
    550d:	c1 ff 1f             	sar    $0x1f,%edi
    5510:	c1 fa 0e             	sar    $0xe,%edx
    5513:	29 fa                	sub    %edi,%edx
    5515:	44 01 ca             	add    %r9d,%edx
    5518:	41 89 12             	mov    %edx,(%r10)
    551b:	0f b7 56 06          	movzwl 0x6(%rsi),%edx
    551f:	48 8b 83 10 01 00 00 	mov    0x110(%rbx),%rax
    5526:	66 85 d2             	test   %dx,%dx
    5529:	4c 8b 8b 18 01 00 00 	mov    0x118(%rbx),%r9
    5530:	0f b7 fa             	movzwl %dx,%edi
    5533:	0f 49 cf             	cmovns %edi,%ecx
    5536:	8b 78 38             	mov    0x38(%rax),%edi
    5539:	8b 40 3c             	mov    0x3c(%rax),%eax
    553c:	29 f8                	sub    %edi,%eax
    553e:	0f af c8             	imul   %eax,%ecx
    5541:	89 c8                	mov    %ecx,%eax
    5543:	41 f7 e8             	imul   %r8d
    5546:	01 ca                	add    %ecx,%edx
    5548:	c1 f9 1f             	sar    $0x1f,%ecx
    554b:	c1 fa 0e             	sar    $0xe,%edx
    554e:	29 ca                	sub    %ecx,%edx
    5550:	01 fa                	add    %edi,%edx
    5552:	41 89 11             	mov    %edx,(%r9)
    5555:	48 8b 83 08 01 00 00 	mov    0x108(%rbx),%rax
    555c:	0f b7 16             	movzwl (%rsi),%edx
    555f:	89 10                	mov    %edx,(%rax)
    5561:	48 8b 83 28 01 00 00 	mov    0x128(%rbx),%rax
    5568:	0f b7 56 04          	movzwl 0x4(%rsi),%edx
    556c:	89 10                	mov    %edx,(%rax)
    556e:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 5575 <pidff_set_envelope_report+0xc5>
    5575:	75 15                	jne    558c <pidff_set_envelope_report+0xdc>
    5577:	48 8b 73 48          	mov    0x48(%rbx),%rsi
    557b:	48 8b 3b             	mov    (%rbx),%rdi
    557e:	31 d2                	xor    %edx,%edx
    5580:	e8 00 00 00 00       	callq  5585 <pidff_set_envelope_report+0xd5>
    5585:	48 83 c4 08          	add    $0x8,%rsp
    5589:	5b                   	pop    %rbx
    558a:	c9                   	leaveq 
    558b:	c3                   	retq   
    558c:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5593 <pidff_set_envelope_report+0xe3>
    5593:	74 e2                	je     5577 <pidff_set_envelope_report+0xc7>
    5595:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 559c <pidff_set_envelope_report+0xec>
    559c:	74 d9                	je     5577 <pidff_set_envelope_report+0xc7>
    559e:	48 8b 83 f8 00 00 00 	mov    0xf8(%rbx),%rax
    55a5:	0f b7 76 02          	movzwl 0x2(%rsi),%esi
    55a9:	8b 10                	mov    (%rax),%edx
    55ab:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    55b2:	31 c0                	xor    %eax,%eax
    55b4:	e8 00 00 00 00       	callq  55b9 <pidff_set_envelope_report+0x109>
    55b9:	eb bc                	jmp    5577 <pidff_set_envelope_report+0xc7>
    55bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000055c0 <pidff_set_effect_report>:
    55c0:	55                   	push   %rbp
    55c1:	48 89 e5             	mov    %rsp,%rbp
    55c4:	e8 00 00 00 00       	callq  55c9 <pidff_set_effect_report+0x9>
    55c9:	48 8b 47 78          	mov    0x78(%rdi),%rax
    55cd:	48 8b 97 68 02 00 00 	mov    0x268(%rdi),%rdx
    55d4:	8b 12                	mov    (%rdx),%edx
    55d6:	89 10                	mov    %edx,(%rax)
    55d8:	48 8b 87 e8 02 00 00 	mov    0x2e8(%rdi),%rax
    55df:	48 8b 97 e0 02 00 00 	mov    0x2e0(%rdi),%rdx
    55e6:	48 8b 40 30          	mov    0x30(%rax),%rax
    55ea:	48 8b 52 30          	mov    0x30(%rdx),%rdx
    55ee:	8b 12                	mov    (%rdx),%edx
    55f0:	89 10                	mov    %edx,(%rax)
    55f2:	48 8b 87 88 00 00 00 	mov    0x88(%rdi),%rax
    55f9:	0f b7 56 0a          	movzwl 0xa(%rsi),%edx
    55fd:	89 10                	mov    %edx,(%rax)
    55ff:	48 8b 87 a8 00 00 00 	mov    0xa8(%rdi),%rax
    5606:	0f b7 56 06          	movzwl 0x6(%rsi),%edx
    560a:	89 10                	mov    %edx,(%rax)
    560c:	48 8b 87 b8 00 00 00 	mov    0xb8(%rdi),%rax
    5613:	0f b7 56 08          	movzwl 0x8(%rsi),%edx
    5617:	89 10                	mov    %edx,(%rax)
    5619:	48 8b 87 98 00 00 00 	mov    0x98(%rdi),%rax
    5620:	48 8b 97 90 00 00 00 	mov    0x90(%rdi),%rdx
    5627:	8b 52 3c             	mov    0x3c(%rdx),%edx
    562a:	89 10                	mov    %edx,(%rax)
    562c:	ba 01 80 00 80       	mov    $0x80008001,%edx
    5631:	48 8b 87 c8 00 00 00 	mov    0xc8(%rdi),%rax
    5638:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
    563e:	48 8b 87 f0 02 00 00 	mov    0x2f0(%rdi),%rax
    5645:	44 8b 40 38          	mov    0x38(%rax),%r8d
    5649:	4c 8b 48 30          	mov    0x30(%rax),%r9
    564d:	8b 48 3c             	mov    0x3c(%rax),%ecx
    5650:	0f b7 46 04          	movzwl 0x4(%rsi),%eax
    5654:	44 29 c1             	sub    %r8d,%ecx
    5657:	0f af c8             	imul   %eax,%ecx
    565a:	89 c8                	mov    %ecx,%eax
    565c:	f7 ea                	imul   %edx
    565e:	01 ca                	add    %ecx,%edx
    5660:	c1 f9 1f             	sar    $0x1f,%ecx
    5663:	c1 fa 0f             	sar    $0xf,%edx
    5666:	29 ca                	sub    %ecx,%edx
    5668:	44 01 c2             	add    %r8d,%edx
    566b:	41 89 11             	mov    %edx,(%r9)
    566e:	48 8b 87 d8 00 00 00 	mov    0xd8(%rdi),%rax
    5675:	0f b7 56 0c          	movzwl 0xc(%rsi),%edx
    5679:	89 10                	mov    %edx,(%rax)
    567b:	48 8b 77 08          	mov    0x8(%rdi),%rsi
    567f:	31 d2                	xor    %edx,%edx
    5681:	48 8b 3f             	mov    (%rdi),%rdi
    5684:	e8 00 00 00 00       	callq  5689 <pidff_set_effect_report+0xc9>
    5689:	c9                   	leaveq 
    568a:	c3                   	retq   
    568b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000005690 <pidff_set_condition_report>:
    5690:	55                   	push   %rbp
    5691:	48 89 e5             	mov    %rsp,%rbp
    5694:	41 57                	push   %r15
    5696:	41 56                	push   %r14
    5698:	41 55                	push   %r13
    569a:	41 54                	push   %r12
    569c:	53                   	push   %rbx
    569d:	48 83 ec 28          	sub    $0x28,%rsp
    56a1:	e8 00 00 00 00       	callq  56a6 <pidff_set_condition_report+0x16>
    56a6:	45 31 ed             	xor    %r13d,%r13d
    56a9:	48 8b 87 38 01 00 00 	mov    0x138(%rdi),%rax
    56b0:	48 8b 97 68 02 00 00 	mov    0x268(%rdi),%rdx
    56b7:	49 89 fc             	mov    %rdi,%r12
    56ba:	8b 12                	mov    (%rdx),%edx
    56bc:	4c 8d bf 80 01 00 00 	lea    0x180(%rdi),%r15
    56c3:	89 10                	mov    %edx,(%rax)
    56c5:	4c 8d b7 90 01 00 00 	lea    0x190(%rdi),%r14
    56cc:	48 8d 87 50 01 00 00 	lea    0x150(%rdi),%rax
    56d3:	48 89 f3             	mov    %rsi,%rbx
    56d6:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    56da:	48 8d 87 60 01 00 00 	lea    0x160(%rdi),%rax
    56e1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    56e5:	48 8d 87 70 01 00 00 	lea    0x170(%rdi),%rax
    56ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    56f0:	48 8d 87 a0 01 00 00 	lea    0x1a0(%rdi),%rax
    56f7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    56fb:	49 8b 84 24 48 01 00 	mov    0x148(%r12),%rax
    5702:	00 
    5703:	44 89 28             	mov    %r13d,(%rax)
    5706:	41 ff c5             	inc    %r13d
    5709:	0f bf 73 1a          	movswl 0x1a(%rbx),%esi
    570d:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
    5711:	e8 da fa ff ff       	callq  51f0 <pidff_set_signed>
    5716:	0f bf 73 14          	movswl 0x14(%rbx),%esi
    571a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
    571e:	e8 cd fa ff ff       	callq  51f0 <pidff_set_signed>
    5723:	0f bf 73 16          	movswl 0x16(%rbx),%esi
    5727:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
    572b:	e8 c0 fa ff ff       	callq  51f0 <pidff_set_signed>
    5730:	0f b7 73 10          	movzwl 0x10(%rbx),%esi
    5734:	4c 89 ff             	mov    %r15,%rdi
    5737:	e8 44 fa ff ff       	callq  5180 <pidff_set>
    573c:	0f b7 73 12          	movzwl 0x12(%rbx),%esi
    5740:	4c 89 f7             	mov    %r14,%rdi
    5743:	e8 38 fa ff ff       	callq  5180 <pidff_set>
    5748:	0f b7 73 18          	movzwl 0x18(%rbx),%esi
    574c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
    5750:	48 83 c3 0c          	add    $0xc,%rbx
    5754:	e8 27 fa ff ff       	callq  5180 <pidff_set>
    5759:	31 d2                	xor    %edx,%edx
    575b:	49 8b 74 24 50       	mov    0x50(%r12),%rsi
    5760:	49 8b 3c 24          	mov    (%r12),%rdi
    5764:	e8 00 00 00 00       	callq  5769 <pidff_set_condition_report+0xd9>
    5769:	41 83 fd 02          	cmp    $0x2,%r13d
    576d:	75 8c                	jne    56fb <pidff_set_condition_report+0x6b>
    576f:	48 83 c4 28          	add    $0x28,%rsp
    5773:	5b                   	pop    %rbx
    5774:	41 5c                	pop    %r12
    5776:	41 5d                	pop    %r13
    5778:	41 5e                	pop    %r14
    577a:	41 5f                	pop    %r15
    577c:	c9                   	leaveq 
    577d:	c3                   	retq   
    577e:	66 90                	xchg   %ax,%ax

0000000000005780 <pidff_find_reports>:
    5780:	55                   	push   %rbp
    5781:	48 89 e5             	mov    %rsp,%rbp
    5784:	41 57                	push   %r15
    5786:	41 56                	push   %r14
    5788:	41 55                	push   %r13
    578a:	41 54                	push   %r12
    578c:	53                   	push   %rbx
    578d:	48 83 ec 18          	sub    $0x18,%rsp
    5791:	e8 00 00 00 00       	callq  5796 <pidff_find_reports+0x16>
    5796:	49 bf 00 00 00 00 00 	mov    $0x20000000000000,%r15
    579d:	00 20 00 
    57a0:	48 89 fb             	mov    %rdi,%rbx
    57a3:	48 63 f6             	movslq %esi,%rsi
    57a6:	48 69 f6 18 08 00 00 	imul   $0x818,%rsi,%rsi
    57ad:	4c 8b 64 37 48       	mov    0x48(%rdi,%rsi,1),%r12
    57b2:	4c 8d 6c 37 48       	lea    0x48(%rdi,%rsi,1),%r13
    57b7:	49 8b 3c 24          	mov    (%r12),%rdi
    57bb:	4d 39 ec             	cmp    %r13,%r12
    57be:	0f 18 0f             	prefetcht0 (%rdi)
    57c1:	0f 84 88 00 00 00    	je     584f <pidff_find_reports+0xcf>
    57c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    57ce:	00 00 
    57d0:	45 8b b4 24 18 02 00 	mov    0x218(%r12),%r14d
    57d7:	00 
    57d8:	45 85 f6             	test   %r14d,%r14d
    57db:	74 63                	je     5840 <pidff_find_reports+0xc0>
    57dd:	4d 8b 4c 24 18       	mov    0x18(%r12),%r9
    57e2:	41 8b 71 04          	mov    0x4(%r9),%esi
    57e6:	81 fe 21 00 0f 00    	cmp    $0xf0021,%esi
    57ec:	74 70                	je     585e <pidff_find_reports+0xde>
    57ee:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8
    57f5:	41 be 01 00 00 00    	mov    $0x1,%r14d
    57fb:	4c 89 c1             	mov    %r8,%rcx
    57fe:	66 90                	xchg   %ax,%ax
    5800:	0f b6 01             	movzbl (%rcx),%eax
    5803:	0d 00 00 0f 00       	or     $0xf0000,%eax
    5808:	39 c6                	cmp    %eax,%esi
    580a:	74 5c                	je     5868 <pidff_find_reports+0xe8>
    580c:	41 ff c6             	inc    %r14d
    580f:	48 ff c1             	inc    %rcx
    5812:	41 83 fe 0d          	cmp    $0xd,%r14d
    5816:	75 e8                	jne    5800 <pidff_find_reports+0x80>
    5818:	49 8b 41 10          	mov    0x10(%r9),%rax
    581c:	8b 40 04             	mov    0x4(%rax),%eax
    581f:	85 c0                	test   %eax,%eax
    5821:	7e 1d                	jle    5840 <pidff_find_reports+0xc0>
    5823:	48 98                	cltq   
    5825:	48 8d 44 40 fd       	lea    -0x3(%rax,%rax,2),%rax
    582a:	48 c1 e0 02          	shl    $0x2,%rax
    582e:	48 03 43 10          	add    0x10(%rbx),%rax
    5832:	83 38 02             	cmpl   $0x2,(%rax)
    5835:	74 4c                	je     5883 <pidff_find_reports+0x103>
    5837:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    583e:	00 00 
    5840:	49 89 fc             	mov    %rdi,%r12
    5843:	49 8b 3c 24          	mov    (%r12),%rdi
    5847:	4d 39 ec             	cmp    %r13,%r12
    584a:	0f 18 0f             	prefetcht0 (%rdi)
    584d:	75 81                	jne    57d0 <pidff_find_reports+0x50>
    584f:	48 83 c4 18          	add    $0x18,%rsp
    5853:	5b                   	pop    %rbx
    5854:	41 5c                	pop    %r12
    5856:	41 5d                	pop    %r13
    5858:	41 5e                	pop    %r14
    585a:	41 5f                	pop    %r15
    585c:	c9                   	leaveq 
    585d:	c3                   	retq   
    585e:	45 31 f6             	xor    %r14d,%r14d
    5861:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    5868:	4c 85 3d 00 00 00 00 	test   %r15,0x0(%rip)        # 586f <pidff_find_reports+0xef>
    586f:	0f 85 96 00 00 00    	jne    590b <pidff_find_reports+0x18b>
    5875:	4d 63 f6             	movslq %r14d,%r14
    5878:	4e 89 64 f2 08       	mov    %r12,0x8(%rdx,%r14,8)
    587d:	49 8b 3c 24          	mov    (%r12),%rdi
    5881:	eb bd                	jmp    5840 <pidff_find_reports+0xc0>
    5883:	8b 48 04             	mov    0x4(%rax),%ecx
    5886:	81 f9 21 00 0f 00    	cmp    $0xf0021,%ecx
    588c:	74 78                	je     5906 <pidff_find_reports+0x186>
    588e:	41 be 01 00 00 00    	mov    $0x1,%r14d
    5894:	eb 16                	jmp    58ac <pidff_find_reports+0x12c>
    5896:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    589d:	00 00 00 
    58a0:	41 ff c6             	inc    %r14d
    58a3:	49 ff c0             	inc    %r8
    58a6:	41 83 fe 0d          	cmp    $0xd,%r14d
    58aa:	74 94                	je     5840 <pidff_find_reports+0xc0>
    58ac:	41 0f b6 00          	movzbl (%r8),%eax
    58b0:	0d 00 00 0f 00       	or     $0xf0000,%eax
    58b5:	39 c1                	cmp    %eax,%ecx
    58b7:	75 e7                	jne    58a0 <pidff_find_reports+0x120>
    58b9:	4d 63 f6             	movslq %r14d,%r14
    58bc:	4a 83 7c f2 08 00    	cmpq   $0x0,0x8(%rdx,%r14,8)
    58c2:	0f 85 78 ff ff ff    	jne    5840 <pidff_find_reports+0xc0>
    58c8:	4c 85 3d 00 00 00 00 	test   %r15,0x0(%rip)        # 58cf <pidff_find_reports+0x14f>
    58cf:	74 a7                	je     5878 <pidff_find_reports+0xf8>
    58d1:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 58d8 <pidff_find_reports+0x158>
    58d8:	74 9e                	je     5878 <pidff_find_reports+0xf8>
    58da:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 58e1 <pidff_find_reports+0x161>
    58e1:	74 95                	je     5878 <pidff_find_reports+0xf8>
    58e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    58e7:	41 0f b6 b6 00 00 00 	movzbl 0x0(%r14),%esi
    58ee:	00 
    58ef:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    58f6:	31 c0                	xor    %eax,%eax
    58f8:	e8 00 00 00 00       	callq  58fd <pidff_find_reports+0x17d>
    58fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
    5901:	e9 72 ff ff ff       	jmpq   5878 <pidff_find_reports+0xf8>
    5906:	45 31 f6             	xor    %r14d,%r14d
    5909:	eb ae                	jmp    58b9 <pidff_find_reports+0x139>
    590b:	4d 63 f6             	movslq %r14d,%r14
    590e:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5915 <pidff_find_reports+0x195>
    5915:	0f 84 5d ff ff ff    	je     5878 <pidff_find_reports+0xf8>
    591b:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5922 <pidff_find_reports+0x1a2>
    5922:	0f 84 50 ff ff ff    	je     5878 <pidff_find_reports+0xf8>
    5928:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    592c:	41 0f b6 b6 00 00 00 	movzbl 0x0(%r14),%esi
    5933:	00 
    5934:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    593b:	31 c0                	xor    %eax,%eax
    593d:	e8 00 00 00 00       	callq  5942 <pidff_find_reports+0x1c2>
    5942:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
    5946:	e9 2d ff ff ff       	jmpq   5878 <pidff_find_reports+0xf8>
    594b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000005950 <pidff_request_effect_upload>:
    5950:	55                   	push   %rbp
    5951:	48 89 e5             	mov    %rsp,%rbp
    5954:	41 55                	push   %r13
    5956:	41 54                	push   %r12
    5958:	53                   	push   %rbx
    5959:	48 83 ec 08          	sub    $0x8,%rsp
    595d:	e8 00 00 00 00       	callq  5962 <pidff_request_effect_upload+0x12>
    5962:	31 d2                	xor    %edx,%edx
    5964:	48 8b 87 e0 02 00 00 	mov    0x2e0(%rdi),%rax
    596b:	48 89 fb             	mov    %rdi,%rbx
    596e:	48 8b 40 30          	mov    0x30(%rax),%rax
    5972:	41 89 f4             	mov    %esi,%r12d
    5975:	89 30                	mov    %esi,(%rax)
    5977:	48 8b 77 40          	mov    0x40(%rdi),%rsi
    597b:	48 8b 3f             	mov    (%rdi),%rdi
    597e:	e8 00 00 00 00       	callq  5983 <pidff_request_effect_upload+0x33>
    5983:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 598a <pidff_request_effect_upload+0x3a>
    598a:	0f 85 0b 01 00 00    	jne    5a9b <pidff_request_effect_upload+0x14b>
    5990:	48 8b 83 68 02 00 00 	mov    0x268(%rbx),%rax
    5997:	45 31 e4             	xor    %r12d,%r12d
    599a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    59a0:	49 bd 00 00 00 00 00 	mov    $0x20000000000000,%r13
    59a7:	00 20 00 
    59aa:	48 8b 83 00 03 00 00 	mov    0x300(%rbx),%rax
    59b1:	48 8b 40 30          	mov    0x30(%rax),%rax
    59b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    59bb:	48 8b 3b             	mov    (%rbx),%rdi
    59be:	e8 00 00 00 00       	callq  59c3 <pidff_request_effect_upload+0x73>
    59c3:	eb 14                	jmp    59d9 <pidff_request_effect_upload+0x89>
    59c5:	0f 1f 00             	nopl   (%rax)
    59c8:	3b 83 48 03 00 00    	cmp    0x348(%rbx),%eax
    59ce:	74 60                	je     5a30 <pidff_request_effect_upload+0xe0>
    59d0:	41 ff c4             	inc    %r12d
    59d3:	41 83 fc 3c          	cmp    $0x3c,%r12d
    59d7:	74 77                	je     5a50 <pidff_request_effect_upload+0x100>
    59d9:	4c 85 2d 00 00 00 00 	test   %r13,0x0(%rip)        # 59e0 <pidff_request_effect_upload+0x90>
    59e0:	0f 85 88 00 00 00    	jne    5a6e <pidff_request_effect_upload+0x11e>
    59e6:	48 8b 73 28          	mov    0x28(%rbx),%rsi
    59ea:	ba 80 00 00 00       	mov    $0x80,%edx
    59ef:	48 8b 3b             	mov    (%rbx),%rdi
    59f2:	e8 00 00 00 00       	callq  59f7 <pidff_request_effect_upload+0xa7>
    59f7:	48 8b 3b             	mov    (%rbx),%rdi
    59fa:	e8 00 00 00 00       	callq  59ff <pidff_request_effect_upload+0xaf>
    59ff:	48 8b 83 00 03 00 00 	mov    0x300(%rbx),%rax
    5a06:	48 8b 40 30          	mov    0x30(%rax),%rax
    5a0a:	8b 00                	mov    (%rax),%eax
    5a0c:	3b 83 44 03 00 00    	cmp    0x344(%rbx),%eax
    5a12:	75 b4                	jne    59c8 <pidff_request_effect_upload+0x78>
    5a14:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 5a1b <pidff_request_effect_upload+0xcb>
    5a1b:	0f 85 aa 00 00 00    	jne    5acb <pidff_request_effect_upload+0x17b>
    5a21:	31 c0                	xor    %eax,%eax
    5a23:	48 83 c4 08          	add    $0x8,%rsp
    5a27:	5b                   	pop    %rbx
    5a28:	41 5c                	pop    %r12
    5a2a:	41 5d                	pop    %r13
    5a2c:	c9                   	leaveq 
    5a2d:	c3                   	retq   
    5a2e:	66 90                	xchg   %ax,%ax
    5a30:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 5a37 <pidff_request_effect_upload+0xe7>
    5a37:	0f 85 ce 00 00 00    	jne    5b0b <pidff_request_effect_upload+0x1bb>
    5a3d:	48 83 c4 08          	add    $0x8,%rsp
    5a41:	b8 e4 ff ff ff       	mov    $0xffffffe4,%eax
    5a46:	5b                   	pop    %rbx
    5a47:	41 5c                	pop    %r12
    5a49:	41 5d                	pop    %r13
    5a4b:	c9                   	leaveq 
    5a4c:	c3                   	retq   
    5a4d:	0f 1f 00             	nopl   (%rax)
    5a50:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5a57:	31 c0                	xor    %eax,%eax
    5a59:	e8 00 00 00 00       	callq  5a5e <pidff_request_effect_upload+0x10e>
    5a5e:	48 83 c4 08          	add    $0x8,%rsp
    5a62:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
    5a67:	5b                   	pop    %rbx
    5a68:	41 5c                	pop    %r12
    5a6a:	41 5d                	pop    %r13
    5a6c:	c9                   	leaveq 
    5a6d:	c3                   	retq   
    5a6e:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5a75 <pidff_request_effect_upload+0x125>
    5a75:	0f 84 6b ff ff ff    	je     59e6 <pidff_request_effect_upload+0x96>
    5a7b:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5a82 <pidff_request_effect_upload+0x132>
    5a82:	0f 84 5e ff ff ff    	je     59e6 <pidff_request_effect_upload+0x96>
    5a88:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5a8f:	31 c0                	xor    %eax,%eax
    5a91:	e8 00 00 00 00       	callq  5a96 <pidff_request_effect_upload+0x146>
    5a96:	e9 4b ff ff ff       	jmpq   59e6 <pidff_request_effect_upload+0x96>
    5a9b:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5aa2 <pidff_request_effect_upload+0x152>
    5aa2:	0f 84 e8 fe ff ff    	je     5990 <pidff_request_effect_upload+0x40>
    5aa8:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5aaf <pidff_request_effect_upload+0x15f>
    5aaf:	0f 84 db fe ff ff    	je     5990 <pidff_request_effect_upload+0x40>
    5ab5:	44 89 e6             	mov    %r12d,%esi
    5ab8:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5abf:	31 c0                	xor    %eax,%eax
    5ac1:	e8 00 00 00 00       	callq  5ac6 <pidff_request_effect_upload+0x176>
    5ac6:	e9 c5 fe ff ff       	jmpq   5990 <pidff_request_effect_upload+0x40>
    5acb:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5ad2 <pidff_request_effect_upload+0x182>
    5ad2:	0f 84 49 ff ff ff    	je     5a21 <pidff_request_effect_upload+0xd1>
    5ad8:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5adf <pidff_request_effect_upload+0x18f>
    5adf:	0f 84 3c ff ff ff    	je     5a21 <pidff_request_effect_upload+0xd1>
    5ae5:	48 8b 83 78 02 00 00 	mov    0x278(%rbx),%rax
    5aec:	83 ce ff             	or     $0xffffffffffffffff,%esi
    5aef:	48 85 c0             	test   %rax,%rax
    5af2:	74 02                	je     5af6 <pidff_request_effect_upload+0x1a6>
    5af4:	8b 30                	mov    (%rax),%esi
    5af6:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5afd:	31 c0                	xor    %eax,%eax
    5aff:	e8 00 00 00 00       	callq  5b04 <pidff_request_effect_upload+0x1b4>
    5b04:	31 c0                	xor    %eax,%eax
    5b06:	e9 18 ff ff ff       	jmpq   5a23 <pidff_request_effect_upload+0xd3>
    5b0b:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 5b12 <pidff_request_effect_upload+0x1c2>
    5b12:	0f 84 25 ff ff ff    	je     5a3d <pidff_request_effect_upload+0xed>
    5b18:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 5b1f <pidff_request_effect_upload+0x1cf>
    5b1f:	0f 84 18 ff ff ff    	je     5a3d <pidff_request_effect_upload+0xed>
    5b25:	48 8b 83 78 02 00 00 	mov    0x278(%rbx),%rax
    5b2c:	83 ce ff             	or     $0xffffffffffffffff,%esi
    5b2f:	48 85 c0             	test   %rax,%rax
    5b32:	74 02                	je     5b36 <pidff_request_effect_upload+0x1e6>
    5b34:	8b 30                	mov    (%rax),%esi
    5b36:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5b3d:	31 c0                	xor    %eax,%eax
    5b3f:	e8 00 00 00 00       	callq  5b44 <pidff_request_effect_upload+0x1f4>
    5b44:	b8 e4 ff ff ff       	mov    $0xffffffe4,%eax
    5b49:	e9 d5 fe ff ff       	jmpq   5a23 <pidff_request_effect_upload+0xd3>
    5b4e:	66 90                	xchg   %ax,%ax

0000000000005b50 <hid_pidff_init>:
    5b50:	55                   	push   %rbp
    5b51:	48 89 e5             	mov    %rsp,%rbp
    5b54:	41 57                	push   %r15
    5b56:	41 56                	push   %r14
    5b58:	41 55                	push   %r13
    5b5a:	41 54                	push   %r12
    5b5c:	53                   	push   %rbx
    5b5d:	48 83 ec 18          	sub    $0x18,%rsp
    5b61:	e8 00 00 00 00       	callq  5b66 <hid_pidff_init+0x16>
    5b66:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 5b6d <hid_pidff_init+0x1d>
    5b6d:	48 8b 87 d8 1a 00 00 	mov    0x1ad8(%rdi),%rax
    5b74:	49 89 fc             	mov    %rdi,%r12
    5b77:	4c 8b 68 18          	mov    0x18(%rax),%r13
    5b7b:	0f 85 11 0a 00 00    	jne    6592 <hid_pidff_init+0xa42>
    5b81:	49 8d 84 24 60 08 00 	lea    0x860(%r12),%rax
    5b88:	00 
    5b89:	49 39 84 24 60 08 00 	cmp    %rax,0x860(%r12)
    5b90:	00 
    5b91:	0f 84 21 09 00 00    	je     64b8 <hid_pidff_init+0x968>
    5b97:	be d0 80 00 00       	mov    $0x80d0,%esi
    5b9c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    5ba3:	e8 00 00 00 00       	callq  5ba8 <hid_pidff_init+0x58>
    5ba8:	4c 63 35 00 00 00 00 	movslq 0x0(%rip),%r14        # 5baf <hid_pidff_init+0x5f>
    5baf:	48 89 c3             	mov    %rax,%rbx
    5bb2:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 5bb8 <hid_pidff_init+0x68>
    5bb8:	85 c0                	test   %eax,%eax
    5bba:	0f 85 ff 09 00 00    	jne    65bf <hid_pidff_init+0xa6f>
    5bc0:	41 be f4 ff ff ff    	mov    $0xfffffff4,%r14d
    5bc6:	48 85 db             	test   %rbx,%rbx
    5bc9:	0f 84 d1 08 00 00    	je     64a0 <hid_pidff_init+0x950>
    5bcf:	4c 89 e7             	mov    %r12,%rdi
    5bd2:	4c 89 23             	mov    %r12,(%rbx)
    5bd5:	48 89 da             	mov    %rbx,%rdx
    5bd8:	be 01 00 00 00       	mov    $0x1,%esi
    5bdd:	e8 9e fb ff ff       	callq  5780 <pidff_find_reports>
    5be2:	be 02 00 00 00       	mov    $0x2,%esi
    5be7:	4c 89 e7             	mov    %r12,%rdi
    5bea:	48 89 da             	mov    %rbx,%rdx
    5bed:	49 89 dc             	mov    %rbx,%r12
    5bf0:	e8 8b fb ff ff       	callq  5780 <pidff_find_reports>
    5bf5:	48 89 d8             	mov    %rbx,%rax
    5bf8:	31 f6                	xor    %esi,%esi
    5bfa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5c00:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
    5c05:	0f 84 2d 09 00 00    	je     6538 <hid_pidff_init+0x9e8>
    5c0b:	ff c6                	inc    %esi
    5c0d:	48 83 c0 08          	add    $0x8,%rax
    5c11:	83 fe 08             	cmp    $0x8,%esi
    5c14:	75 ea                	jne    5c00 <hid_pidff_init+0xb0>
    5c16:	48 8b 53 08          	mov    0x8(%rbx),%rdx
    5c1a:	48 8d 7b 70          	lea    0x70(%rbx),%rdi
    5c1e:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    5c24:	b9 07 00 00 00       	mov    $0x7,%ecx
    5c29:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    5c30:	e8 5b f3 ff ff       	callq  4f90 <pidff_find_fields>
    5c35:	85 c0                	test   %eax,%eax
    5c37:	0f 85 35 09 00 00    	jne    6572 <hid_pidff_init+0xa22>
    5c3d:	45 31 c0             	xor    %r8d,%r8d
    5c40:	48 8b 53 28          	mov    0x28(%rbx),%rdx
    5c44:	48 8d bb 60 02 00 00 	lea    0x260(%rbx),%rdi
    5c4b:	b9 02 00 00 00       	mov    $0x2,%ecx
    5c50:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    5c57:	e8 34 f3 ff ff       	callq  4f90 <pidff_find_fields>
    5c5c:	48 83 bb 68 02 00 00 	cmpq   $0x0,0x268(%rbx)
    5c63:	00 
    5c64:	0f 84 18 09 00 00    	je     6582 <hid_pidff_init+0xa32>
    5c6a:	48 8b 53 10          	mov    0x10(%rbx),%rdx
    5c6e:	48 8d bb b0 02 00 00 	lea    0x2b0(%rbx),%rdi
    5c75:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    5c7b:	b9 02 00 00 00       	mov    $0x2,%ecx
    5c80:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    5c87:	e8 04 f3 ff ff       	callq  4f90 <pidff_find_fields>
    5c8c:	85 c0                	test   %eax,%eax
    5c8e:	0f 85 ce 08 00 00    	jne    6562 <hid_pidff_init+0xa12>
    5c94:	48 8b 53 30          	mov    0x30(%rbx),%rdx
    5c98:	48 8d bb d0 02 00 00 	lea    0x2d0(%rbx),%rdi
    5c9f:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    5ca5:	b9 01 00 00 00       	mov    $0x1,%ecx
    5caa:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    5cb1:	e8 da f2 ff ff       	callq  4f90 <pidff_find_fields>
    5cb6:	85 c0                	test   %eax,%eax
    5cb8:	0f 85 5d 0a 00 00    	jne    671b <hid_pidff_init+0xbcb>
    5cbe:	48 8b 53 48          	mov    0x48(%rbx),%rdx
    5cc2:	48 8d bb e0 00 00 00 	lea    0xe0(%rbx),%rdi
    5cc9:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    5ccf:	b9 05 00 00 00       	mov    $0x5,%ecx
    5cd4:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    5cdb:	e8 b0 f2 ff ff       	callq  4f90 <pidff_find_fields>
    5ce0:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 5ce7 <hid_pidff_init+0x197>
    5ce7:	41 89 c6             	mov    %eax,%r14d
    5cea:	0f 85 fe 09 00 00    	jne    66ee <hid_pidff_init+0xb9e>
    5cf0:	48 8b 7b 40          	mov    0x40(%rbx),%rdi
    5cf4:	ba 01 00 00 00       	mov    $0x1,%edx
    5cf9:	be 25 00 00 00       	mov    $0x25,%esi
    5cfe:	e8 1d f2 ff ff       	callq  4f20 <pidff_find_special_field>
    5d03:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
    5d07:	ba 01 00 00 00       	mov    $0x1,%edx
    5d0c:	be 25 00 00 00       	mov    $0x25,%esi
    5d11:	48 89 83 e0 02 00 00 	mov    %rax,0x2e0(%rbx)
    5d18:	e8 03 f2 ff ff       	callq  4f20 <pidff_find_special_field>
    5d1d:	31 d2                	xor    %edx,%edx
    5d1f:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
    5d23:	be 57 00 00 00       	mov    $0x57,%esi
    5d28:	48 89 83 e8 02 00 00 	mov    %rax,0x2e8(%rbx)
    5d2f:	e8 ec f1 ff ff       	callq  4f20 <pidff_find_special_field>
    5d34:	48 8b 7b 38          	mov    0x38(%rbx),%rdi
    5d38:	ba 01 00 00 00       	mov    $0x1,%edx
    5d3d:	be 96 00 00 00       	mov    $0x96,%esi
    5d42:	48 89 83 f0 02 00 00 	mov    %rax,0x2f0(%rbx)
    5d49:	e8 d2 f1 ff ff       	callq  4f20 <pidff_find_special_field>
    5d4e:	48 8b 7b 28          	mov    0x28(%rbx),%rdi
    5d52:	ba 01 00 00 00       	mov    $0x1,%edx
    5d57:	be 8b 00 00 00       	mov    $0x8b,%esi
    5d5c:	48 89 83 f8 02 00 00 	mov    %rax,0x2f8(%rbx)
    5d63:	e8 b8 f1 ff ff       	callq  4f20 <pidff_find_special_field>
    5d68:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
    5d6c:	48 89 83 00 03 00 00 	mov    %rax,0x300(%rbx)
    5d73:	ba 01 00 00 00       	mov    $0x1,%edx
    5d78:	be 78 00 00 00       	mov    $0x78,%esi
    5d7d:	e8 9e f1 ff ff       	callq  4f20 <pidff_find_special_field>
    5d82:	48 89 83 08 03 00 00 	mov    %rax,0x308(%rbx)
    5d89:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 5d90 <hid_pidff_init+0x240>
    5d90:	0f 85 2b 09 00 00    	jne    66c1 <hid_pidff_init+0xb71>
    5d96:	48 83 bb e0 02 00 00 	cmpq   $0x0,0x2e0(%rbx)
    5d9d:	00 
    5d9e:	0f 84 0a 09 00 00    	je     66ae <hid_pidff_init+0xb5e>
    5da4:	48 83 bb e8 02 00 00 	cmpq   $0x0,0x2e8(%rbx)
    5dab:	00 
    5dac:	0f 84 fc 08 00 00    	je     66ae <hid_pidff_init+0xb5e>
    5db2:	48 83 bb f0 02 00 00 	cmpq   $0x0,0x2f0(%rbx)
    5db9:	00 
    5dba:	0f 84 db 08 00 00    	je     669b <hid_pidff_init+0xb4b>
    5dc0:	4c 8b 9b f8 02 00 00 	mov    0x2f8(%rbx),%r11
    5dc7:	4d 85 db             	test   %r11,%r11
    5dca:	0f 84 b8 08 00 00    	je     6688 <hid_pidff_init+0xb38>
    5dd0:	48 83 bb 00 03 00 00 	cmpq   $0x0,0x300(%rbx)
    5dd7:	00 
    5dd8:	0f 84 97 08 00 00    	je     6675 <hid_pidff_init+0xb25>
    5dde:	48 83 bb 08 03 00 00 	cmpq   $0x0,0x308(%rbx)
    5de5:	00 
    5de6:	0f 84 76 08 00 00    	je     6662 <hid_pidff_init+0xb12>
    5dec:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8
    5df3:	49 89 da             	mov    %rbx,%r10
    5df6:	4d 89 c1             	mov    %r8,%r9
    5df9:	41 8b 73 18          	mov    0x18(%r11),%esi
    5dfd:	85 f6                	test   %esi,%esi
    5dff:	74 35                	je     5e36 <hid_pidff_init+0x2e6>
    5e01:	49 8b 7b 10          	mov    0x10(%r11),%rdi
    5e05:	41 0f b6 09          	movzbl (%r9),%ecx
    5e09:	31 c0                	xor    %eax,%eax
    5e0b:	81 c9 00 00 0f 00    	or     $0xf0000,%ecx
    5e11:	ba 01 00 00 00       	mov    $0x1,%edx
    5e16:	39 0f                	cmp    %ecx,(%rdi)
    5e18:	75 16                	jne    5e30 <hid_pidff_init+0x2e0>
    5e1a:	e9 0d 07 00 00       	jmpq   652c <hid_pidff_init+0x9dc>
    5e1f:	90                   	nop
    5e20:	48 63 d0             	movslq %eax,%rdx
    5e23:	48 c1 e2 04          	shl    $0x4,%rdx
    5e27:	39 0c 3a             	cmp    %ecx,(%rdx,%rdi,1)
    5e2a:	0f 84 f9 06 00 00    	je     6529 <hid_pidff_init+0x9d9>
    5e30:	ff c0                	inc    %eax
    5e32:	39 f0                	cmp    %esi,%eax
    5e34:	72 ea                	jb     5e20 <hid_pidff_init+0x2d0>
    5e36:	49 83 c2 04          	add    $0x4,%r10
    5e3a:	49 ff c1             	inc    %r9
    5e3d:	49 81 f9 00 00 00 00 	cmp    $0x0,%r9
    5e44:	75 b3                	jne    5df9 <hid_pidff_init+0x2a9>
    5e46:	4c 8b 93 f8 02 00 00 	mov    0x2f8(%rbx),%r10
    5e4d:	49 89 d9             	mov    %rbx,%r9
    5e50:	41 8b 72 18          	mov    0x18(%r10),%esi
    5e54:	85 f6                	test   %esi,%esi
    5e56:	74 3e                	je     5e96 <hid_pidff_init+0x346>
    5e58:	49 8b 7a 10          	mov    0x10(%r10),%rdi
    5e5c:	41 0f b6 08          	movzbl (%r8),%ecx
    5e60:	31 c0                	xor    %eax,%eax
    5e62:	81 c9 00 00 0f 00    	or     $0xf0000,%ecx
    5e68:	ba 01 00 00 00       	mov    $0x1,%edx
    5e6d:	39 0f                	cmp    %ecx,(%rdi)
    5e6f:	75 1f                	jne    5e90 <hid_pidff_init+0x340>
    5e71:	e9 83 06 00 00       	jmpq   64f9 <hid_pidff_init+0x9a9>
    5e76:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    5e7d:	00 00 00 
    5e80:	48 63 d0             	movslq %eax,%rdx
    5e83:	48 c1 e2 04          	shl    $0x4,%rdx
    5e87:	39 0c 3a             	cmp    %ecx,(%rdx,%rdi,1)
    5e8a:	0f 84 66 06 00 00    	je     64f6 <hid_pidff_init+0x9a6>
    5e90:	ff c0                	inc    %eax
    5e92:	39 c6                	cmp    %eax,%esi
    5e94:	77 ea                	ja     5e80 <hid_pidff_init+0x330>
    5e96:	49 83 c1 04          	add    $0x4,%r9
    5e9a:	49 ff c0             	inc    %r8
    5e9d:	49 81 f8 00 00 00 00 	cmp    $0x0,%r8
    5ea4:	75 aa                	jne    5e50 <hid_pidff_init+0x300>
    5ea6:	4c 8b 93 e0 02 00 00 	mov    0x2e0(%rbx),%r10
    5ead:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8
    5eb4:	49 89 d9             	mov    %rbx,%r9
    5eb7:	45 31 db             	xor    %r11d,%r11d
    5eba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5ec0:	41 8b 72 18          	mov    0x18(%r10),%esi
    5ec4:	85 f6                	test   %esi,%esi
    5ec6:	74 3e                	je     5f06 <hid_pidff_init+0x3b6>
    5ec8:	49 8b 7a 10          	mov    0x10(%r10),%rdi
    5ecc:	41 0f b6 08          	movzbl (%r8),%ecx
    5ed0:	31 c0                	xor    %eax,%eax
    5ed2:	81 c9 00 00 0f 00    	or     $0xf0000,%ecx
    5ed8:	ba 01 00 00 00       	mov    $0x1,%edx
    5edd:	39 0f                	cmp    %ecx,(%rdi)
    5edf:	75 1f                	jne    5f00 <hid_pidff_init+0x3b0>
    5ee1:	e9 ed 05 00 00       	jmpq   64d3 <hid_pidff_init+0x983>
    5ee6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    5eed:	00 00 00 
    5ef0:	48 63 d0             	movslq %eax,%rdx
    5ef3:	48 c1 e2 04          	shl    $0x4,%rdx
    5ef7:	3b 0c 3a             	cmp    (%rdx,%rdi,1),%ecx
    5efa:	0f 84 d0 05 00 00    	je     64d0 <hid_pidff_init+0x980>
    5f00:	ff c0                	inc    %eax
    5f02:	39 f0                	cmp    %esi,%eax
    5f04:	72 ea                	jb     5ef0 <hid_pidff_init+0x3a0>
    5f06:	49 83 c1 04          	add    $0x4,%r9
    5f0a:	49 ff c0             	inc    %r8
    5f0d:	49 81 f8 00 00 00 00 	cmp    $0x0,%r8
    5f14:	75 aa                	jne    5ec0 <hid_pidff_init+0x370>
    5f16:	45 85 db             	test   %r11d,%r11d
    5f19:	0f 84 52 09 00 00    	je     6871 <hid_pidff_init+0xd21>
    5f1f:	4c 8b 93 00 03 00 00 	mov    0x300(%rbx),%r10
    5f26:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8
    5f2d:	49 89 d9             	mov    %rbx,%r9
    5f30:	45 31 db             	xor    %r11d,%r11d
    5f33:	41 8b 72 18          	mov    0x18(%r10),%esi
    5f37:	85 f6                	test   %esi,%esi
    5f39:	74 3b                	je     5f76 <hid_pidff_init+0x426>
    5f3b:	49 8b 7a 10          	mov    0x10(%r10),%rdi
    5f3f:	41 0f b6 08          	movzbl (%r8),%ecx
    5f43:	31 c0                	xor    %eax,%eax
    5f45:	81 c9 00 00 0f 00    	or     $0xf0000,%ecx
    5f4b:	ba 01 00 00 00       	mov    $0x1,%edx
    5f50:	39 0f                	cmp    %ecx,(%rdi)
    5f52:	75 1c                	jne    5f70 <hid_pidff_init+0x420>
    5f54:	e9 af 05 00 00       	jmpq   6508 <hid_pidff_init+0x9b8>
    5f59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    5f60:	48 63 d0             	movslq %eax,%rdx
    5f63:	48 c1 e2 04          	shl    $0x4,%rdx
    5f67:	3b 0c 3a             	cmp    (%rdx,%rdi,1),%ecx
    5f6a:	0f 84 95 05 00 00    	je     6505 <hid_pidff_init+0x9b5>
    5f70:	ff c0                	inc    %eax
    5f72:	39 c6                	cmp    %eax,%esi
    5f74:	77 ea                	ja     5f60 <hid_pidff_init+0x410>
    5f76:	49 83 c1 04          	add    $0x4,%r9
    5f7a:	49 ff c0             	inc    %r8
    5f7d:	49 81 f8 00 00 00 00 	cmp    $0x0,%r8
    5f84:	75 ad                	jne    5f33 <hid_pidff_init+0x3e3>
    5f86:	41 83 fb 02          	cmp    $0x2,%r11d
    5f8a:	0f 85 ce 08 00 00    	jne    685e <hid_pidff_init+0xd0e>
    5f90:	4c 8b 93 08 03 00 00 	mov    0x308(%rbx),%r10
    5f97:	49 c7 c0 00 00 00 00 	mov    $0x0,%r8
    5f9e:	49 89 d9             	mov    %rbx,%r9
    5fa1:	45 31 db             	xor    %r11d,%r11d
    5fa4:	41 8b 72 18          	mov    0x18(%r10),%esi
    5fa8:	85 f6                	test   %esi,%esi
    5faa:	74 3a                	je     5fe6 <hid_pidff_init+0x496>
    5fac:	49 8b 7a 10          	mov    0x10(%r10),%rdi
    5fb0:	41 0f b6 08          	movzbl (%r8),%ecx
    5fb4:	31 c0                	xor    %eax,%eax
    5fb6:	81 c9 00 00 0f 00    	or     $0xf0000,%ecx
    5fbc:	ba 01 00 00 00       	mov    $0x1,%edx
    5fc1:	39 0f                	cmp    %ecx,(%rdi)
    5fc3:	75 1b                	jne    5fe0 <hid_pidff_init+0x490>
    5fc5:	e9 50 05 00 00       	jmpq   651a <hid_pidff_init+0x9ca>
    5fca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    5fd0:	48 63 d0             	movslq %eax,%rdx
    5fd3:	48 c1 e2 04          	shl    $0x4,%rdx
    5fd7:	3b 0c 3a             	cmp    (%rdx,%rdi,1),%ecx
    5fda:	0f 84 37 05 00 00    	je     6517 <hid_pidff_init+0x9c7>
    5fe0:	ff c0                	inc    %eax
    5fe2:	39 c6                	cmp    %eax,%esi
    5fe4:	77 ea                	ja     5fd0 <hid_pidff_init+0x480>
    5fe6:	49 83 c1 04          	add    $0x4,%r9
    5fea:	49 ff c0             	inc    %r8
    5fed:	49 81 f8 00 00 00 00 	cmp    $0x0,%r8
    5ff4:	75 ae                	jne    5fa4 <hid_pidff_init+0x454>
    5ff6:	41 83 fb 02          	cmp    $0x2,%r11d
    5ffa:	0f 85 43 07 00 00    	jne    6743 <hid_pidff_init+0xbf3>
    6000:	48 8b 83 e8 02 00 00 	mov    0x2e8(%rbx),%rax
    6007:	8b bb 18 03 00 00    	mov    0x318(%rbx),%edi
    600d:	48 8b 48 10          	mov    0x10(%rax),%rcx
    6011:	48 8b 93 e0 02 00 00 	mov    0x2e0(%rbx),%rdx
    6018:	48 63 c7             	movslq %edi,%rax
    601b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
    601f:	48 c1 e0 04          	shl    $0x4,%rax
    6023:	8b 34 01             	mov    (%rcx,%rax,1),%esi
    6026:	3b 34 02             	cmp    (%rdx,%rax,1),%esi
    6029:	0f 85 ff 06 00 00    	jne    672e <hid_pidff_init+0xbde>
    602f:	be 01 00 00 00       	mov    $0x1,%esi
    6034:	49 63 84 24 1c 03 00 	movslq 0x31c(%r12),%rax
    603b:	00 
    603c:	48 c1 e0 04          	shl    $0x4,%rax
    6040:	44 8b 04 01          	mov    (%rcx,%rax,1),%r8d
    6044:	44 3b 04 02          	cmp    (%rdx,%rax,1),%r8d
    6048:	0f 85 e2 06 00 00    	jne    6730 <hid_pidff_init+0xbe0>
    604e:	ff c6                	inc    %esi
    6050:	49 83 c4 04          	add    $0x4,%r12
    6054:	83 fe 0b             	cmp    $0xb,%esi
    6057:	75 db                	jne    6034 <hid_pidff_init+0x4e4>
    6059:	85 ff                	test   %edi,%edi
    605b:	74 09                	je     6066 <hid_pidff_init+0x516>
    605d:	f0 41 80 8d ba 00 00 	lock orb $0x4,0xba(%r13)
    6064:	00 04 
    6066:	83 bb 1c 03 00 00 00 	cmpl   $0x0,0x31c(%rbx)
    606d:	74 09                	je     6078 <hid_pidff_init+0x528>
    606f:	f0 41 80 8d ba 00 00 	lock orb $0x80,0xba(%r13)
    6076:	00 80 
    6078:	83 bb 20 03 00 00 00 	cmpl   $0x0,0x320(%rbx)
    607f:	74 12                	je     6093 <hid_pidff_init+0x543>
    6081:	f0 41 80 8d bb 00 00 	lock orb $0x1,0xbb(%r13)
    6088:	00 01 
    608a:	f0 41 80 8d ba 00 00 	lock orb $0x2,0xba(%r13)
    6091:	00 02 
    6093:	83 bb 24 03 00 00 00 	cmpl   $0x0,0x324(%rbx)
    609a:	74 12                	je     60ae <hid_pidff_init+0x55e>
    609c:	f0 41 80 8d bb 00 00 	lock orb $0x4,0xbb(%r13)
    60a3:	00 04 
    60a5:	f0 41 80 8d ba 00 00 	lock orb $0x2,0xba(%r13)
    60ac:	00 02 
    60ae:	83 bb 28 03 00 00 00 	cmpl   $0x0,0x328(%rbx)
    60b5:	74 12                	je     60c9 <hid_pidff_init+0x579>
    60b7:	f0 41 80 8d bb 00 00 	lock orb $0x2,0xbb(%r13)
    60be:	00 02 
    60c0:	f0 41 80 8d ba 00 00 	lock orb $0x2,0xba(%r13)
    60c7:	00 02 
    60c9:	83 bb 2c 03 00 00 00 	cmpl   $0x0,0x32c(%rbx)
    60d0:	74 12                	je     60e4 <hid_pidff_init+0x594>
    60d2:	f0 41 80 8d bb 00 00 	lock orb $0x8,0xbb(%r13)
    60d9:	00 08 
    60db:	f0 41 80 8d ba 00 00 	lock orb $0x2,0xba(%r13)
    60e2:	00 02 
    60e4:	83 bb 30 03 00 00 00 	cmpl   $0x0,0x330(%rbx)
    60eb:	74 12                	je     60ff <hid_pidff_init+0x5af>
    60ed:	f0 41 80 8d bb 00 00 	lock orb $0x10,0xbb(%r13)
    60f4:	00 10 
    60f6:	f0 41 80 8d ba 00 00 	lock orb $0x2,0xba(%r13)
    60fd:	00 02 
    60ff:	83 bb 34 03 00 00 00 	cmpl   $0x0,0x334(%rbx)
    6106:	74 09                	je     6111 <hid_pidff_init+0x5c1>
    6108:	f0 41 80 8d ba 00 00 	lock orb $0x8,0xba(%r13)
    610f:	00 08 
    6111:	83 bb 38 03 00 00 00 	cmpl   $0x0,0x338(%rbx)
    6118:	74 09                	je     6123 <hid_pidff_init+0x5d3>
    611a:	f0 41 80 8d ba 00 00 	lock orb $0x20,0xba(%r13)
    6121:	00 20 
    6123:	83 bb 3c 03 00 00 00 	cmpl   $0x0,0x33c(%rbx)
    612a:	74 09                	je     6135 <hid_pidff_init+0x5e5>
    612c:	f0 41 80 8d ba 00 00 	lock orb $0x40,0xba(%r13)
    6133:	00 40 
    6135:	83 bb 40 03 00 00 00 	cmpl   $0x0,0x340(%rbx)
    613c:	74 09                	je     6147 <hid_pidff_init+0x5f7>
    613e:	f0 41 80 8d ba 00 00 	lock orb $0x10,0xba(%r13)
    6145:	00 10 
    6147:	45 85 f6             	test   %r14d,%r14d
    614a:	74 48                	je     6194 <hid_pidff_init+0x644>
    614c:	b8 52 00 00 00       	mov    $0x52,%eax
    6151:	f0 41 0f b3 85 b0 00 	lock btr %eax,0xb0(%r13)
    6158:	00 00 
    615a:	19 c0                	sbb    %eax,%eax
    615c:	85 c0                	test   %eax,%eax
    615e:	0f 85 99 07 00 00    	jne    68fd <hid_pidff_init+0xdad>
    6164:	b8 57 00 00 00       	mov    $0x57,%eax
    6169:	f0 41 0f b3 85 b0 00 	lock btr %eax,0xb0(%r13)
    6170:	00 00 
    6172:	19 c0                	sbb    %eax,%eax
    6174:	85 c0                	test   %eax,%eax
    6176:	0f 85 6e 07 00 00    	jne    68ea <hid_pidff_init+0xd9a>
    617c:	b8 51 00 00 00       	mov    $0x51,%eax
    6181:	f0 41 0f b3 85 b0 00 	lock btr %eax,0xb0(%r13)
    6188:	00 00 
    618a:	19 c0                	sbb    %eax,%eax
    618c:	85 c0                	test   %eax,%eax
    618e:	0f 85 7c 07 00 00    	jne    6910 <hid_pidff_init+0xdc0>
    6194:	49 8b 85 b8 00 00 00 	mov    0xb8(%r13),%rax
    619b:	4d 8d a5 b0 00 00 00 	lea    0xb0(%r13),%r12
    61a2:	a9 00 00 04 00       	test   $0x40000,%eax
    61a7:	0f 85 1d 06 00 00    	jne    67ca <hid_pidff_init+0xc7a>
    61ad:	a9 00 00 80 00       	test   $0x800000,%eax
    61b2:	0f 85 dc 05 00 00    	jne    6794 <hid_pidff_init+0xc44>
    61b8:	48 89 c2             	mov    %rax,%rdx
    61bb:	48 89 c1             	mov    %rax,%rcx
    61be:	48 c1 ea 15          	shr    $0x15,%rdx
    61c2:	48 c1 e9 13          	shr    $0x13,%rcx
    61c6:	48 09 ca             	or     %rcx,%rdx
    61c9:	80 e2 01             	and    $0x1,%dl
    61cc:	75 16                	jne    61e4 <hid_pidff_init+0x694>
    61ce:	48 89 c2             	mov    %rax,%rdx
    61d1:	48 89 c1             	mov    %rax,%rcx
    61d4:	48 c1 ea 16          	shr    $0x16,%rdx
    61d8:	48 c1 e9 14          	shr    $0x14,%rcx
    61dc:	48 09 ca             	or     %rcx,%rdx
    61df:	80 e2 01             	and    $0x1,%dl
    61e2:	74 31                	je     6215 <hid_pidff_init+0x6c5>
    61e4:	48 8b 53 50          	mov    0x50(%rbx),%rdx
    61e8:	48 8d bb 30 01 00 00 	lea    0x130(%rbx),%rdi
    61ef:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    61f5:	b9 08 00 00 00       	mov    $0x8,%ecx
    61fa:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    6201:	e8 8a ed ff ff       	callq  4f90 <pidff_find_fields>
    6206:	85 c0                	test   %eax,%eax
    6208:	0f 85 15 07 00 00    	jne    6923 <hid_pidff_init+0xdd3>
    620e:	49 8b 85 b8 00 00 00 	mov    0xb8(%r13),%rax
    6215:	a9 00 00 02 00       	test   $0x20000,%eax
    621a:	0f 85 e0 05 00 00    	jne    6800 <hid_pidff_init+0xcb0>
    6220:	45 31 c0             	xor    %r8d,%r8d
    6223:	48 8b 53 20          	mov    0x20(%rbx),%rdx
    6227:	48 8d bb 80 02 00 00 	lea    0x280(%rbx),%rdi
    622e:	b9 03 00 00 00       	mov    $0x3,%ecx
    6233:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    623a:	e8 51 ed ff ff       	callq  4f90 <pidff_find_fields>
    623f:	48 8d 83 50 02 00 00 	lea    0x250(%rbx),%rax
    6246:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    624c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    6250:	b9 01 00 00 00       	mov    $0x1,%ecx
    6255:	48 8b 53 18          	mov    0x18(%rbx),%rdx
    6259:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    6260:	48 89 c7             	mov    %rax,%rdi
    6263:	e8 28 ed ff ff       	callq  4f90 <pidff_find_fields>
    6268:	85 c0                	test   %eax,%eax
    626a:	75 07                	jne    6273 <hid_pidff_init+0x723>
    626c:	f0 41 80 4c 24 0c 01 	lock orb $0x1,0xc(%r12)
    6273:	4c 8b 3b             	mov    (%rbx),%r15
    6276:	48 8b 83 f8 02 00 00 	mov    0x2f8(%rbx),%rax
    627d:	8b 93 14 03 00 00    	mov    0x314(%rbx),%edx
    6283:	48 8b 40 30          	mov    0x30(%rax),%rax
    6287:	4c 89 ff             	mov    %r15,%rdi
    628a:	89 10                	mov    %edx,(%rax)
    628c:	31 d2                	xor    %edx,%edx
    628e:	48 8b 73 38          	mov    0x38(%rbx),%rsi
    6292:	e8 00 00 00 00       	callq  6297 <hid_pidff_init+0x747>
    6297:	4c 89 ff             	mov    %r15,%rdi
    629a:	e8 00 00 00 00       	callq  629f <hid_pidff_init+0x74f>
    629f:	31 d2                	xor    %edx,%edx
    62a1:	48 8b 73 38          	mov    0x38(%rbx),%rsi
    62a5:	4c 89 ff             	mov    %r15,%rdi
    62a8:	e8 00 00 00 00       	callq  62ad <hid_pidff_init+0x75d>
    62ad:	4c 89 ff             	mov    %r15,%rdi
    62b0:	e8 00 00 00 00       	callq  62b5 <hid_pidff_init+0x765>
    62b5:	48 8b 83 f8 02 00 00 	mov    0x2f8(%rbx),%rax
    62bc:	8b 93 10 03 00 00    	mov    0x310(%rbx),%edx
    62c2:	48 8b 40 30          	mov    0x30(%rax),%rax
    62c6:	4c 89 ff             	mov    %r15,%rdi
    62c9:	89 10                	mov    %edx,(%rax)
    62cb:	31 d2                	xor    %edx,%edx
    62cd:	48 8b 73 38          	mov    0x38(%rbx),%rsi
    62d1:	e8 00 00 00 00       	callq  62d6 <hid_pidff_init+0x786>
    62d6:	4c 89 ff             	mov    %r15,%rdi
    62d9:	e8 00 00 00 00       	callq  62de <hid_pidff_init+0x78e>
    62de:	48 8b 73 20          	mov    0x20(%rbx),%rsi
    62e2:	ba 80 00 00 00       	mov    $0x80,%edx
    62e7:	4c 89 ff             	mov    %r15,%rdi
    62ea:	e8 00 00 00 00       	callq  62ef <hid_pidff_init+0x79f>
    62ef:	4c 89 ff             	mov    %r15,%rdi
    62f2:	e8 00 00 00 00       	callq  62f7 <hid_pidff_init+0x7a7>
    62f7:	48 8b 83 98 02 00 00 	mov    0x298(%rbx),%rax
    62fe:	48 85 c0             	test   %rax,%rax
    6301:	74 58                	je     635b <hid_pidff_init+0x80b>
    6303:	41 be 01 00 00 00    	mov    $0x1,%r14d
    6309:	83 38 01             	cmpl   $0x1,(%rax)
    630c:	7e 0f                	jle    631d <hid_pidff_init+0x7cd>
    630e:	eb 4b                	jmp    635b <hid_pidff_init+0x80b>
    6310:	41 83 fe 15          	cmp    $0x15,%r14d
    6314:	0f 84 46 04 00 00    	je     6760 <hid_pidff_init+0xc10>
    631a:	41 ff c6             	inc    %r14d
    631d:	48 b8 00 00 00 00 00 	mov    $0x20000000000000,%rax
    6324:	00 20 00 
    6327:	48 85 05 00 00 00 00 	test   %rax,0x0(%rip)        # 632e <hid_pidff_init+0x7de>
    632e:	0f 85 a3 06 00 00    	jne    69d7 <hid_pidff_init+0xe87>
    6334:	48 8b 73 20          	mov    0x20(%rbx),%rsi
    6338:	ba 80 00 00 00       	mov    $0x80,%edx
    633d:	4c 89 ff             	mov    %r15,%rdi
    6340:	e8 00 00 00 00       	callq  6345 <hid_pidff_init+0x7f5>
    6345:	4c 89 ff             	mov    %r15,%rdi
    6348:	e8 00 00 00 00       	callq  634d <hid_pidff_init+0x7fd>
    634d:	48 8b 83 98 02 00 00 	mov    0x298(%rbx),%rax
    6354:	8b 30                	mov    (%rax),%esi
    6356:	83 fe 01             	cmp    $0x1,%esi
    6359:	7e b5                	jle    6310 <hid_pidff_init+0x7c0>
    635b:	41 f6 85 bc 00 00 00 	testb  $0x1,0xbc(%r13)
    6362:	01 
    6363:	0f 85 0a 04 00 00    	jne    6773 <hid_pidff_init+0xc23>
    6369:	be 01 00 00 00       	mov    $0x1,%esi
    636e:	48 89 df             	mov    %rbx,%rdi
    6371:	e8 da f5 ff ff       	callq  5950 <pidff_request_effect_upload>
    6376:	41 89 c6             	mov    %eax,%r14d
    6379:	85 c0                	test   %eax,%eax
    637b:	0f 85 83 06 00 00    	jne    6a04 <hid_pidff_init+0xeb4>
    6381:	48 8b 93 68 02 00 00 	mov    0x268(%rbx),%rdx
    6388:	48 8b 83 60 02 00 00 	mov    0x260(%rbx),%rax
    638f:	8b 40 38             	mov    0x38(%rax),%eax
    6392:	ff c0                	inc    %eax
    6394:	39 02                	cmp    %eax,(%rdx)
    6396:	0f 85 e6 05 00 00    	jne    6982 <hid_pidff_init+0xe32>
    639c:	be ff ff 00 00       	mov    $0xffff,%esi
    63a1:	48 89 df             	mov    %rbx,%rdi
    63a4:	e8 d7 ef ff ff       	callq  5380 <pidff_autocenter>
    63a9:	f0 41 80 4c 24 0c 02 	lock orb $0x2,0xc(%r12)
    63b0:	48 8b 83 d8 02 00 00 	mov    0x2d8(%rbx),%rax
    63b7:	48 8b 93 68 02 00 00 	mov    0x268(%rbx),%rdx
    63be:	8b 12                	mov    (%rdx),%edx
    63c0:	89 10                	mov    %edx,(%rax)
    63c2:	31 d2                	xor    %edx,%edx
    63c4:	48 8b 73 30          	mov    0x30(%rbx),%rsi
    63c8:	48 8b 3b             	mov    (%rbx),%rdi
    63cb:	e8 00 00 00 00       	callq  63d0 <hid_pidff_init+0x880>
    63d0:	48 8b 83 60 02 00 00 	mov    0x260(%rbx),%rax
    63d7:	44 8b 60 3c          	mov    0x3c(%rax),%r12d
    63db:	41 ff c4             	inc    %r12d
    63de:	44 2b 60 38          	sub    0x38(%rax),%r12d
    63e2:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 63e9 <hid_pidff_init+0x899>
    63e9:	0f 85 63 05 00 00    	jne    6952 <hid_pidff_init+0xe02>
    63ef:	48 8b 83 98 02 00 00 	mov    0x298(%rbx),%rax
    63f6:	48 85 c0             	test   %rax,%rax
    63f9:	74 0d                	je     6408 <hid_pidff_init+0x8b8>
    63fb:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 6402 <hid_pidff_init+0x8b2>
    6402:	0f 85 0f 06 00 00    	jne    6a17 <hid_pidff_init+0xec7>
    6408:	48 8b 83 88 02 00 00 	mov    0x288(%rbx),%rax
    640f:	48 85 c0             	test   %rax,%rax
    6412:	74 0d                	je     6421 <hid_pidff_init+0x8d1>
    6414:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 641b <hid_pidff_init+0x8cb>
    641b:	0f 85 74 05 00 00    	jne    6995 <hid_pidff_init+0xe45>
    6421:	48 8b 83 a8 02 00 00 	mov    0x2a8(%rbx),%rax
    6428:	48 85 c0             	test   %rax,%rax
    642b:	74 0c                	je     6439 <hid_pidff_init+0x8e9>
    642d:	44 8b 38             	mov    (%rax),%r15d
    6430:	45 85 ff             	test   %r15d,%r15d
    6433:	0f 84 8b 05 00 00    	je     69c4 <hid_pidff_init+0xe74>
    6439:	41 83 fc 40          	cmp    $0x40,%r12d
    643d:	be 40 00 00 00       	mov    $0x40,%esi
    6442:	4c 89 ef             	mov    %r13,%rdi
    6445:	41 0f 4e f4          	cmovle %r12d,%esi
    6449:	e8 00 00 00 00       	callq  644e <hid_pidff_init+0x8fe>
    644e:	41 89 c6             	mov    %eax,%r14d
    6451:	85 c0                	test   %eax,%eax
    6453:	0f 85 fc 00 00 00    	jne    6555 <hid_pidff_init+0xa05>
    6459:	49 8b 85 f0 00 00 00 	mov    0xf0(%r13),%rax
    6460:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6467:	48 89 58 30          	mov    %rbx,0x30(%rax)
    646b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
    6472:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
    6479:	00 
    647a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
    6481:	00 
    6482:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
    6489:	00 
    648a:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
    6491:	00 
    6492:	31 c0                	xor    %eax,%eax
    6494:	e8 00 00 00 00       	callq  6499 <hid_pidff_init+0x949>
    6499:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    64a0:	48 83 c4 18          	add    $0x18,%rsp
    64a4:	44 89 f0             	mov    %r14d,%eax
    64a7:	5b                   	pop    %rbx
    64a8:	41 5c                	pop    %r12
    64aa:	41 5d                	pop    %r13
    64ac:	41 5e                	pop    %r14
    64ae:	41 5f                	pop    %r15
    64b0:	c9                   	leaveq 
    64b1:	c3                   	retq   
    64b2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    64b8:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 64bf <hid_pidff_init+0x96f>
    64bf:	0f 85 6a 01 00 00    	jne    662f <hid_pidff_init+0xadf>
    64c5:	41 be ed ff ff ff    	mov    $0xffffffed,%r14d
    64cb:	eb d3                	jmp    64a0 <hid_pidff_init+0x950>
    64cd:	0f 1f 00             	nopl   (%rax)
    64d0:	8d 50 01             	lea    0x1(%rax),%edx
    64d3:	41 89 91 18 03 00 00 	mov    %edx,0x318(%r9)
    64da:	41 ff c3             	inc    %r11d
    64dd:	49 83 c1 04          	add    $0x4,%r9
    64e1:	49 ff c0             	inc    %r8
    64e4:	49 81 f8 00 00 00 00 	cmp    $0x0,%r8
    64eb:	0f 85 cf f9 ff ff    	jne    5ec0 <hid_pidff_init+0x370>
    64f1:	e9 20 fa ff ff       	jmpq   5f16 <hid_pidff_init+0x3c6>
    64f6:	8d 50 01             	lea    0x1(%rax),%edx
    64f9:	41 89 91 10 03 00 00 	mov    %edx,0x310(%r9)
    6500:	e9 91 f9 ff ff       	jmpq   5e96 <hid_pidff_init+0x346>
    6505:	8d 50 01             	lea    0x1(%rax),%edx
    6508:	41 89 91 44 03 00 00 	mov    %edx,0x344(%r9)
    650f:	41 ff c3             	inc    %r11d
    6512:	e9 5f fa ff ff       	jmpq   5f76 <hid_pidff_init+0x426>
    6517:	8d 50 01             	lea    0x1(%rax),%edx
    651a:	41 89 91 4c 03 00 00 	mov    %edx,0x34c(%r9)
    6521:	41 ff c3             	inc    %r11d
    6524:	e9 bd fa ff ff       	jmpq   5fe6 <hid_pidff_init+0x496>
    6529:	8d 50 01             	lea    0x1(%rax),%edx
    652c:	41 89 92 10 03 00 00 	mov    %edx,0x310(%r10)
    6533:	e9 fe f8 ff ff       	jmpq   5e36 <hid_pidff_init+0x2e6>
    6538:	49 bc 00 00 00 00 00 	mov    $0x20000000000000,%r12
    653f:	00 20 00 
    6542:	4c 85 25 00 00 00 00 	test   %r12,0x0(%rip)        # 6549 <hid_pidff_init+0x9f9>
    6549:	0f 85 35 03 00 00    	jne    6884 <hid_pidff_init+0xd34>
    654f:	41 be ed ff ff ff    	mov    $0xffffffed,%r14d
    6555:	48 89 df             	mov    %rbx,%rdi
    6558:	e8 00 00 00 00       	callq  655d <hid_pidff_init+0xa0d>
    655d:	e9 3e ff ff ff       	jmpq   64a0 <hid_pidff_init+0x950>
    6562:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6569:	31 c0                	xor    %eax,%eax
    656b:	e8 00 00 00 00       	callq  6570 <hid_pidff_init+0xa20>
    6570:	eb dd                	jmp    654f <hid_pidff_init+0x9ff>
    6572:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6579:	31 c0                	xor    %eax,%eax
    657b:	e8 00 00 00 00       	callq  6580 <hid_pidff_init+0xa30>
    6580:	eb cd                	jmp    654f <hid_pidff_init+0x9ff>
    6582:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6589:	31 c0                	xor    %eax,%eax
    658b:	e8 00 00 00 00       	callq  6590 <hid_pidff_init+0xa40>
    6590:	eb bd                	jmp    654f <hid_pidff_init+0x9ff>
    6592:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 6599 <hid_pidff_init+0xa49>
    6599:	0f 84 e2 f5 ff ff    	je     5b81 <hid_pidff_init+0x31>
    659f:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 65a6 <hid_pidff_init+0xa56>
    65a6:	0f 84 d5 f5 ff ff    	je     5b81 <hid_pidff_init+0x31>
    65ac:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    65b3:	31 c0                	xor    %eax,%eax
    65b5:	e8 00 00 00 00       	callq  65ba <hid_pidff_init+0xa6a>
    65ba:	e9 c2 f5 ff ff       	jmpq   5b81 <hid_pidff_init+0x31>
    65bf:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    65c6:	00 00 
    65c8:	ff 80 44 e0 ff ff    	incl   -0x1fbc(%rax)
    65ce:	4c 8b 3d 00 00 00 00 	mov    0x0(%rip),%r15        # 65d5 <hid_pidff_init+0xa85>
    65d5:	4d 85 ff             	test   %r15,%r15
    65d8:	74 2d                	je     6607 <hid_pidff_init+0xab7>
    65da:	49 8b 07             	mov    (%r15),%rax
    65dd:	49 8b 7f 08          	mov    0x8(%r15),%rdi
    65e1:	41 b9 d0 80 00 00    	mov    $0x80d0,%r9d
    65e7:	49 83 c7 10          	add    $0x10,%r15
    65eb:	4d 89 f0             	mov    %r14,%r8
    65ee:	b9 58 04 00 00       	mov    $0x458,%ecx
    65f3:	48 89 da             	mov    %rbx,%rdx
    65f6:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    65fd:	ff d0                	callq  *%rax
    65ff:	49 8b 07             	mov    (%r15),%rax
    6602:	48 85 c0             	test   %rax,%rax
    6605:	75 d6                	jne    65dd <hid_pidff_init+0xa8d>
    6607:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
    660e:	00 00 
    6610:	ff 88 44 e0 ff ff    	decl   -0x1fbc(%rax)
    6616:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
    661d:	a8 08                	test   $0x8,%al
    661f:	0f 84 9b f5 ff ff    	je     5bc0 <hid_pidff_init+0x70>
    6625:	e8 00 00 00 00       	callq  662a <hid_pidff_init+0xada>
    662a:	e9 91 f5 ff ff       	jmpq   5bc0 <hid_pidff_init+0x70>
    662f:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 6636 <hid_pidff_init+0xae6>
    6636:	0f 84 89 fe ff ff    	je     64c5 <hid_pidff_init+0x975>
    663c:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 6643 <hid_pidff_init+0xaf3>
    6643:	0f 84 7c fe ff ff    	je     64c5 <hid_pidff_init+0x975>
    6649:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6650:	31 c0                	xor    %eax,%eax
    6652:	41 be ed ff ff ff    	mov    $0xffffffed,%r14d
    6658:	e8 00 00 00 00       	callq  665d <hid_pidff_init+0xb0d>
    665d:	e9 3e fe ff ff       	jmpq   64a0 <hid_pidff_init+0x950>
    6662:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6669:	31 c0                	xor    %eax,%eax
    666b:	e8 00 00 00 00       	callq  6670 <hid_pidff_init+0xb20>
    6670:	e9 da fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    6675:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    667c:	31 c0                	xor    %eax,%eax
    667e:	e8 00 00 00 00       	callq  6683 <hid_pidff_init+0xb33>
    6683:	e9 c7 fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    6688:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    668f:	31 c0                	xor    %eax,%eax
    6691:	e8 00 00 00 00       	callq  6696 <hid_pidff_init+0xb46>
    6696:	e9 b4 fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    669b:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    66a2:	31 c0                	xor    %eax,%eax
    66a4:	e8 00 00 00 00       	callq  66a9 <hid_pidff_init+0xb59>
    66a9:	e9 a1 fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    66ae:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    66b5:	31 c0                	xor    %eax,%eax
    66b7:	e8 00 00 00 00       	callq  66bc <hid_pidff_init+0xb6c>
    66bc:	e9 8e fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    66c1:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 66c8 <hid_pidff_init+0xb78>
    66c8:	0f 84 c8 f6 ff ff    	je     5d96 <hid_pidff_init+0x246>
    66ce:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 66d5 <hid_pidff_init+0xb85>
    66d5:	0f 84 bb f6 ff ff    	je     5d96 <hid_pidff_init+0x246>
    66db:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    66e2:	31 c0                	xor    %eax,%eax
    66e4:	e8 00 00 00 00       	callq  66e9 <hid_pidff_init+0xb99>
    66e9:	e9 a8 f6 ff ff       	jmpq   5d96 <hid_pidff_init+0x246>
    66ee:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 66f5 <hid_pidff_init+0xba5>
    66f5:	0f 84 f5 f5 ff ff    	je     5cf0 <hid_pidff_init+0x1a0>
    66fb:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 6702 <hid_pidff_init+0xbb2>
    6702:	0f 84 e8 f5 ff ff    	je     5cf0 <hid_pidff_init+0x1a0>
    6708:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    670f:	31 c0                	xor    %eax,%eax
    6711:	e8 00 00 00 00       	callq  6716 <hid_pidff_init+0xbc6>
    6716:	e9 d5 f5 ff ff       	jmpq   5cf0 <hid_pidff_init+0x1a0>
    671b:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6722:	31 c0                	xor    %eax,%eax
    6724:	e8 00 00 00 00       	callq  6729 <hid_pidff_init+0xbd9>
    6729:	e9 21 fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    672e:	31 f6                	xor    %esi,%esi
    6730:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6737:	31 c0                	xor    %eax,%eax
    6739:	e8 00 00 00 00       	callq  673e <hid_pidff_init+0xbee>
    673e:	e9 0c fe ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    6743:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    674a:	31 c0                	xor    %eax,%eax
    674c:	e8 00 00 00 00       	callq  6751 <hid_pidff_init+0xc01>
    6751:	e9 f9 fd ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    6756:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    675d:	00 00 00 
    6760:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6767:	31 c0                	xor    %eax,%eax
    6769:	e8 00 00 00 00       	callq  676e <hid_pidff_init+0xc1e>
    676e:	e9 e8 fb ff ff       	jmpq   635b <hid_pidff_init+0x80b>
    6773:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
    6777:	be ff ff 00 00       	mov    $0xffff,%esi
    677c:	e8 ff e9 ff ff       	callq  5180 <pidff_set>
    6781:	48 8b 73 18          	mov    0x18(%rbx),%rsi
    6785:	31 d2                	xor    %edx,%edx
    6787:	48 8b 3b             	mov    (%rbx),%rdi
    678a:	e8 00 00 00 00       	callq  678f <hid_pidff_init+0xc3f>
    678f:	e9 d5 fb ff ff       	jmpq   6369 <hid_pidff_init+0x819>
    6794:	48 8b 53 68          	mov    0x68(%rbx),%rdx
    6798:	48 8d bb 20 02 00 00 	lea    0x220(%rbx),%rdi
    679f:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    67a5:	b9 03 00 00 00       	mov    $0x3,%ecx
    67aa:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    67b1:	e8 da e7 ff ff       	callq  4f90 <pidff_find_fields>
    67b6:	85 c0                	test   %eax,%eax
    67b8:	0f 85 86 00 00 00    	jne    6844 <hid_pidff_init+0xcf4>
    67be:	49 8b 85 b8 00 00 00 	mov    0xb8(%r13),%rax
    67c5:	e9 ee f9 ff ff       	jmpq   61b8 <hid_pidff_init+0x668>
    67ca:	48 8b 53 60          	mov    0x60(%rbx),%rdx
    67ce:	48 8d bb 00 02 00 00 	lea    0x200(%rbx),%rdi
    67d5:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    67db:	b9 02 00 00 00       	mov    $0x2,%ecx
    67e0:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    67e7:	e8 a4 e7 ff ff       	callq  4f90 <pidff_find_fields>
    67ec:	85 c0                	test   %eax,%eax
    67ee:	0f 85 52 02 00 00    	jne    6a46 <hid_pidff_init+0xef6>
    67f4:	49 8b 85 b8 00 00 00 	mov    0xb8(%r13),%rax
    67fb:	e9 ad f9 ff ff       	jmpq   61ad <hid_pidff_init+0x65d>
    6800:	48 8b 53 58          	mov    0x58(%rbx),%rdx
    6804:	48 8d bb b0 01 00 00 	lea    0x1b0(%rbx),%rdi
    680b:	41 b8 01 00 00 00    	mov    $0x1,%r8d
    6811:	b9 05 00 00 00       	mov    $0x5,%ecx
    6816:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
    681d:	e8 6e e7 ff ff       	callq  4f90 <pidff_find_fields>
    6822:	85 c0                	test   %eax,%eax
    6824:	0f 84 f6 f9 ff ff    	je     6220 <hid_pidff_init+0x6d0>
    682a:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6831:	31 c0                	xor    %eax,%eax
    6833:	e8 00 00 00 00       	callq  6838 <hid_pidff_init+0xce8>
    6838:	f0 41 80 64 24 0a fd 	lock andb $0xfd,0xa(%r12)
    683f:	e9 dc f9 ff ff       	jmpq   6220 <hid_pidff_init+0x6d0>
    6844:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    684b:	31 c0                	xor    %eax,%eax
    684d:	e8 00 00 00 00       	callq  6852 <hid_pidff_init+0xd02>
    6852:	f0 41 80 64 24 0a 7f 	lock andb $0x7f,0xa(%r12)
    6859:	e9 60 ff ff ff       	jmpq   67be <hid_pidff_init+0xc6e>
    685e:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6865:	31 c0                	xor    %eax,%eax
    6867:	e8 00 00 00 00       	callq  686c <hid_pidff_init+0xd1c>
    686c:	e9 de fc ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    6871:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6878:	31 c0                	xor    %eax,%eax
    687a:	e8 00 00 00 00       	callq  687f <hid_pidff_init+0xd2f>
    687f:	e9 cb fc ff ff       	jmpq   654f <hid_pidff_init+0x9ff>
    6884:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 688b <hid_pidff_init+0xd3b>
    688b:	0f 84 be fc ff ff    	je     654f <hid_pidff_init+0x9ff>
    6891:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 6898 <hid_pidff_init+0xd48>
    6898:	75 26                	jne    68c0 <hid_pidff_init+0xd70>
    689a:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 68a1 <hid_pidff_init+0xd51>
    68a1:	0f 84 a8 fc ff ff    	je     654f <hid_pidff_init+0x9ff>
    68a7:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    68ae:	31 c0                	xor    %eax,%eax
    68b0:	41 be ed ff ff ff    	mov    $0xffffffed,%r14d
    68b6:	e8 00 00 00 00       	callq  68bb <hid_pidff_init+0xd6b>
    68bb:	e9 95 fc ff ff       	jmpq   6555 <hid_pidff_init+0xa05>
    68c0:	31 c0                	xor    %eax,%eax
    68c2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    68c9:	e8 00 00 00 00       	callq  68ce <hid_pidff_init+0xd7e>
    68ce:	4c 85 25 00 00 00 00 	test   %r12,0x0(%rip)        # 68d5 <hid_pidff_init+0xd85>
    68d5:	0f 84 74 fc ff ff    	je     654f <hid_pidff_init+0x9ff>
    68db:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 68e2 <hid_pidff_init+0xd92>
    68e2:	0f 84 67 fc ff ff    	je     654f <hid_pidff_init+0x9ff>
    68e8:	eb b0                	jmp    689a <hid_pidff_init+0xd4a>
    68ea:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    68f1:	31 c0                	xor    %eax,%eax
    68f3:	e8 00 00 00 00       	callq  68f8 <hid_pidff_init+0xda8>
    68f8:	e9 7f f8 ff ff       	jmpq   617c <hid_pidff_init+0x62c>
    68fd:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6904:	31 c0                	xor    %eax,%eax
    6906:	e8 00 00 00 00       	callq  690b <hid_pidff_init+0xdbb>
    690b:	e9 54 f8 ff ff       	jmpq   6164 <hid_pidff_init+0x614>
    6910:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6917:	31 c0                	xor    %eax,%eax
    6919:	e8 00 00 00 00       	callq  691e <hid_pidff_init+0xdce>
    691e:	e9 71 f8 ff ff       	jmpq   6194 <hid_pidff_init+0x644>
    6923:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    692a:	31 c0                	xor    %eax,%eax
    692c:	e8 00 00 00 00       	callq  6931 <hid_pidff_init+0xde1>
    6931:	f0 41 80 64 24 0a f7 	lock andb $0xf7,0xa(%r12)
    6938:	f0 41 80 64 24 0a df 	lock andb $0xdf,0xa(%r12)
    693f:	f0 41 80 64 24 0a ef 	lock andb $0xef,0xa(%r12)
    6946:	f0 41 80 64 24 0a bf 	lock andb $0xbf,0xa(%r12)
    694d:	e9 bc f8 ff ff       	jmpq   620e <hid_pidff_init+0x6be>
    6952:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 6959 <hid_pidff_init+0xe09>
    6959:	0f 84 90 fa ff ff    	je     63ef <hid_pidff_init+0x89f>
    695f:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 6966 <hid_pidff_init+0xe16>
    6966:	0f 84 83 fa ff ff    	je     63ef <hid_pidff_init+0x89f>
    696c:	44 89 e6             	mov    %r12d,%esi
    696f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6976:	31 c0                	xor    %eax,%eax
    6978:	e8 00 00 00 00       	callq  697d <hid_pidff_init+0xe2d>
    697d:	e9 6d fa ff ff       	jmpq   63ef <hid_pidff_init+0x89f>
    6982:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6989:	31 c0                	xor    %eax,%eax
    698b:	e8 00 00 00 00       	callq  6990 <hid_pidff_init+0xe40>
    6990:	e9 1b fa ff ff       	jmpq   63b0 <hid_pidff_init+0x860>
    6995:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 699c <hid_pidff_init+0xe4c>
    699c:	0f 84 7f fa ff ff    	je     6421 <hid_pidff_init+0x8d1>
    69a2:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 69a9 <hid_pidff_init+0xe59>
    69a9:	0f 84 72 fa ff ff    	je     6421 <hid_pidff_init+0x8d1>
    69af:	8b 30                	mov    (%rax),%esi
    69b1:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    69b8:	31 c0                	xor    %eax,%eax
    69ba:	e8 00 00 00 00       	callq  69bf <hid_pidff_init+0xe6f>
    69bf:	e9 5d fa ff ff       	jmpq   6421 <hid_pidff_init+0x8d1>
    69c4:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    69cb:	31 c0                	xor    %eax,%eax
    69cd:	e8 00 00 00 00       	callq  69d2 <hid_pidff_init+0xe82>
    69d2:	e9 7e fb ff ff       	jmpq   6555 <hid_pidff_init+0xa05>
    69d7:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 69de <hid_pidff_init+0xe8e>
    69de:	0f 84 50 f9 ff ff    	je     6334 <hid_pidff_init+0x7e4>
    69e4:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 69eb <hid_pidff_init+0xe9b>
    69eb:	0f 84 43 f9 ff ff    	je     6334 <hid_pidff_init+0x7e4>
    69f1:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    69f8:	31 c0                	xor    %eax,%eax
    69fa:	e8 00 00 00 00       	callq  69ff <hid_pidff_init+0xeaf>
    69ff:	e9 30 f9 ff ff       	jmpq   6334 <hid_pidff_init+0x7e4>
    6a04:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6a0b:	31 c0                	xor    %eax,%eax
    6a0d:	e8 00 00 00 00       	callq  6a12 <hid_pidff_init+0xec2>
    6a12:	e9 3e fb ff ff       	jmpq   6555 <hid_pidff_init+0xa05>
    6a17:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 6a1e <hid_pidff_init+0xece>
    6a1e:	0f 84 e4 f9 ff ff    	je     6408 <hid_pidff_init+0x8b8>
    6a24:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 6a2b <hid_pidff_init+0xedb>
    6a2b:	0f 84 d7 f9 ff ff    	je     6408 <hid_pidff_init+0x8b8>
    6a31:	8b 30                	mov    (%rax),%esi
    6a33:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6a3a:	31 c0                	xor    %eax,%eax
    6a3c:	e8 00 00 00 00       	callq  6a41 <hid_pidff_init+0xef1>
    6a41:	e9 c2 f9 ff ff       	jmpq   6408 <hid_pidff_init+0x8b8>
    6a46:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6a4d:	31 c0                	xor    %eax,%eax
    6a4f:	e8 00 00 00 00       	callq  6a54 <hid_pidff_init+0xf04>
    6a54:	f0 41 80 a5 ba 00 00 	lock andb $0xfb,0xba(%r13)
    6a5b:	00 fb 
    6a5d:	e9 92 fd ff ff       	jmpq   67f4 <hid_pidff_init+0xca4>
    6a62:	66 66 66 66 66 2e 0f 	nopw   %cs:0x0(%rax,%rax,1)
    6a69:	1f 84 00 00 00 00 00 

0000000000006a70 <pidff_upload_effect>:
    6a70:	55                   	push   %rbp
    6a71:	48 89 e5             	mov    %rsp,%rbp
    6a74:	41 55                	push   %r13
    6a76:	41 54                	push   %r12
    6a78:	53                   	push   %rbx
    6a79:	48 83 ec 08          	sub    $0x8,%rsp
    6a7d:	e8 00 00 00 00       	callq  6a82 <pidff_upload_effect+0x12>
    6a82:	48 8b 87 f0 00 00 00 	mov    0xf0(%rdi),%rax
    6a89:	48 89 f3             	mov    %rsi,%rbx
    6a8c:	4c 8b 68 30          	mov    0x30(%rax),%r13
    6a90:	49 89 d4             	mov    %rdx,%r12
    6a93:	0f b7 06             	movzwl (%rsi),%eax
    6a96:	83 e8 51             	sub    $0x51,%eax
    6a99:	66 83 f8 06          	cmp    $0x6,%ax
    6a9d:	76 21                	jbe    6ac0 <pidff_upload_effect+0x50>
    6a9f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6aa6:	31 c0                	xor    %eax,%eax
    6aa8:	e8 00 00 00 00       	callq  6aad <pidff_upload_effect+0x3d>
    6aad:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
    6ab2:	48 83 c4 08          	add    $0x8,%rsp
    6ab6:	5b                   	pop    %rbx
    6ab7:	41 5c                	pop    %r12
    6ab9:	41 5d                	pop    %r13
    6abb:	c9                   	leaveq 
    6abc:	c3                   	retq   
    6abd:	0f 1f 00             	nopl   (%rax)
    6ac0:	0f b7 c0             	movzwl %ax,%eax
    6ac3:	ff 24 c5 00 00 00 00 	jmpq   *0x0(,%rax,8)
    6aca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6ad0:	48 85 d2             	test   %rdx,%rdx
    6ad3:	0f 84 18 06 00 00    	je     70f1 <pidff_upload_effect+0x681>
    6ad9:	8b 43 08             	mov    0x8(%rbx),%eax
    6adc:	41 3b 44 24 08       	cmp    0x8(%r12),%eax
    6ae1:	0f 84 79 03 00 00    	je     6e60 <pidff_upload_effect+0x3f0>
    6ae7:	48 89 de             	mov    %rbx,%rsi
    6aea:	4c 89 ef             	mov    %r13,%rdi
    6aed:	e8 ce ea ff ff       	callq  55c0 <pidff_set_effect_report>
    6af2:	0f b7 43 1a          	movzwl 0x1a(%rbx),%eax
    6af6:	66 41 3b 44 24 1a    	cmp    0x1a(%r12),%ax
    6afc:	0f 84 06 03 00 00    	je     6e08 <pidff_upload_effect+0x398>
    6b02:	ba 01 00 00 00       	mov    $0x1,%edx
    6b07:	0f b7 43 26          	movzwl 0x26(%rbx),%eax
    6b0b:	66 41 3b 44 24 26    	cmp    0x26(%r12),%ax
    6b11:	0f 84 91 02 00 00    	je     6da8 <pidff_upload_effect+0x338>
    6b17:	48 89 de             	mov    %rbx,%rsi
    6b1a:	4c 89 ef             	mov    %r13,%rdi
    6b1d:	e8 6e eb ff ff       	callq  5690 <pidff_set_condition_report>
    6b22:	4d 85 e4             	test   %r12,%r12
    6b25:	0f 84 5d 03 00 00    	je     6e88 <pidff_upload_effect+0x418>
    6b2b:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 6b32 <pidff_upload_effect+0xc2>
    6b32:	0f 85 6b 03 00 00    	jne    6ea3 <pidff_upload_effect+0x433>
    6b38:	48 83 c4 08          	add    $0x8,%rsp
    6b3c:	31 c0                	xor    %eax,%eax
    6b3e:	5b                   	pop    %rbx
    6b3f:	41 5c                	pop    %r12
    6b41:	41 5d                	pop    %r13
    6b43:	c9                   	leaveq 
    6b44:	c3                   	retq   
    6b45:	0f 1f 00             	nopl   (%rax)
    6b48:	48 85 d2             	test   %rdx,%rdx
    6b4b:	0f 84 bc 05 00 00    	je     710d <pidff_upload_effect+0x69d>
    6b51:	8b 46 08             	mov    0x8(%rsi),%eax
    6b54:	3b 42 08             	cmp    0x8(%rdx),%eax
    6b57:	0f 84 7b 03 00 00    	je     6ed8 <pidff_upload_effect+0x468>
    6b5d:	48 89 de             	mov    %rbx,%rsi
    6b60:	4c 89 ef             	mov    %r13,%rdi
    6b63:	e8 58 ea ff ff       	callq  55c0 <pidff_set_effect_report>
    6b68:	8b 43 10             	mov    0x10(%rbx),%eax
    6b6b:	41 3b 44 24 10       	cmp    0x10(%r12),%eax
    6b70:	74 46                	je     6bb8 <pidff_upload_effect+0x148>
    6b72:	49 8b 85 28 02 00 00 	mov    0x228(%r13),%rax
    6b79:	49 8b 95 68 02 00 00 	mov    0x268(%r13),%rdx
    6b80:	49 8d bd 30 02 00 00 	lea    0x230(%r13),%rdi
    6b87:	8b 12                	mov    (%rdx),%edx
    6b89:	89 10                	mov    %edx,(%rax)
    6b8b:	0f bf 73 10          	movswl 0x10(%rbx),%esi
    6b8f:	e8 5c e6 ff ff       	callq  51f0 <pidff_set_signed>
    6b94:	0f bf 73 12          	movswl 0x12(%rbx),%esi
    6b98:	49 8d bd 40 02 00 00 	lea    0x240(%r13),%rdi
    6b9f:	e8 4c e6 ff ff       	callq  51f0 <pidff_set_signed>
    6ba4:	31 d2                	xor    %edx,%edx
    6ba6:	49 8b 75 68          	mov    0x68(%r13),%rsi
    6baa:	49 8b 7d 00          	mov    0x0(%r13),%rdi
    6bae:	e8 00 00 00 00       	callq  6bb3 <pidff_upload_effect+0x143>
    6bb3:	4d 85 e4             	test   %r12,%r12
    6bb6:	74 10                	je     6bc8 <pidff_upload_effect+0x158>
    6bb8:	0f b7 43 16          	movzwl 0x16(%rbx),%eax
    6bbc:	66 41 3b 44 24 16    	cmp    0x16(%r12),%ax
    6bc2:	0f 84 98 03 00 00    	je     6f60 <pidff_upload_effect+0x4f0>
    6bc8:	48 8d 73 14          	lea    0x14(%rbx),%rsi
    6bcc:	4c 89 ef             	mov    %r13,%rdi
    6bcf:	e8 dc e8 ff ff       	callq  54b0 <pidff_set_envelope_report>
    6bd4:	e9 49 ff ff ff       	jmpq   6b22 <pidff_upload_effect+0xb2>
    6bd9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    6be0:	48 85 d2             	test   %rdx,%rdx
    6be3:	0f 84 2f 04 00 00    	je     7018 <pidff_upload_effect+0x5a8>
    6be9:	8b 46 08             	mov    0x8(%rsi),%eax
    6bec:	3b 42 08             	cmp    0x8(%rdx),%eax
    6bef:	90                   	nop
    6bf0:	0f 84 ca 03 00 00    	je     6fc0 <pidff_upload_effect+0x550>
    6bf6:	48 89 de             	mov    %rbx,%rsi
    6bf9:	4c 89 ef             	mov    %r13,%rdi
    6bfc:	e8 bf e9 ff ff       	callq  55c0 <pidff_set_effect_report>
    6c01:	8b 43 14             	mov    0x14(%rbx),%eax
    6c04:	41 3b 44 24 14       	cmp    0x14(%r12),%eax
    6c09:	0f 84 89 03 00 00    	je     6f98 <pidff_upload_effect+0x528>
    6c0f:	49 8b 85 b8 01 00 00 	mov    0x1b8(%r13),%rax
    6c16:	49 8b 95 68 02 00 00 	mov    0x268(%r13),%rdx
    6c1d:	49 8d bd c0 01 00 00 	lea    0x1c0(%r13),%rdi
    6c24:	8b 12                	mov    (%rdx),%edx
    6c26:	89 10                	mov    %edx,(%rax)
    6c28:	0f bf 73 14          	movswl 0x14(%rbx),%esi
    6c2c:	e8 bf e5 ff ff       	callq  51f0 <pidff_set_signed>
    6c31:	0f bf 73 16          	movswl 0x16(%rbx),%esi
    6c35:	49 8d bd d0 01 00 00 	lea    0x1d0(%r13),%rdi
    6c3c:	e8 af e5 ff ff       	callq  51f0 <pidff_set_signed>
    6c41:	0f b7 73 18          	movzwl 0x18(%rbx),%esi
    6c45:	49 8d bd e0 01 00 00 	lea    0x1e0(%r13),%rdi
    6c4c:	e8 2f e5 ff ff       	callq  5180 <pidff_set>
    6c51:	0f b7 53 12          	movzwl 0x12(%rbx),%edx
    6c55:	49 8b 85 f8 01 00 00 	mov    0x1f8(%r13),%rax
    6c5c:	89 10                	mov    %edx,(%rax)
    6c5e:	31 d2                	xor    %edx,%edx
    6c60:	49 8b 75 58          	mov    0x58(%r13),%rsi
    6c64:	49 8b 7d 00          	mov    0x0(%r13),%rdi
    6c68:	e8 00 00 00 00       	callq  6c6d <pidff_upload_effect+0x1fd>
    6c6d:	4d 85 e4             	test   %r12,%r12
    6c70:	74 10                	je     6c82 <pidff_upload_effect+0x212>
    6c72:	0f b7 43 1c          	movzwl 0x1c(%rbx),%eax
    6c76:	66 41 3b 44 24 1c    	cmp    0x1c(%r12),%ax
    6c7c:	0f 84 5e 03 00 00    	je     6fe0 <pidff_upload_effect+0x570>
    6c82:	48 8d 73 1a          	lea    0x1a(%rbx),%rsi
    6c86:	4c 89 ef             	mov    %r13,%rdi
    6c89:	e8 22 e8 ff ff       	callq  54b0 <pidff_set_envelope_report>
    6c8e:	e9 8f fe ff ff       	jmpq   6b22 <pidff_upload_effect+0xb2>
    6c93:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6c98:	48 85 d2             	test   %rdx,%rdx
    6c9b:	0f 84 f8 03 00 00    	je     7099 <pidff_upload_effect+0x629>
    6ca1:	8b 46 08             	mov    0x8(%rsi),%eax
    6ca4:	3b 42 08             	cmp    0x8(%rdx),%eax
    6ca7:	0f 84 8b 02 00 00    	je     6f38 <pidff_upload_effect+0x4c8>
    6cad:	48 89 de             	mov    %rbx,%rsi
    6cb0:	4c 89 ef             	mov    %r13,%rdi
    6cb3:	e8 08 e9 ff ff       	callq  55c0 <pidff_set_effect_report>
    6cb8:	0f b7 43 10          	movzwl 0x10(%rbx),%eax
    6cbc:	66 41 3b 44 24 10    	cmp    0x10(%r12),%ax
    6cc2:	74 36                	je     6cfa <pidff_upload_effect+0x28a>
    6cc4:	49 8b 85 08 02 00 00 	mov    0x208(%r13),%rax
    6ccb:	49 8b 95 68 02 00 00 	mov    0x268(%r13),%rdx
    6cd2:	49 8d bd 10 02 00 00 	lea    0x210(%r13),%rdi
    6cd9:	8b 12                	mov    (%rdx),%edx
    6cdb:	89 10                	mov    %edx,(%rax)
    6cdd:	0f bf 73 10          	movswl 0x10(%rbx),%esi
    6ce1:	e8 0a e5 ff ff       	callq  51f0 <pidff_set_signed>
    6ce6:	31 d2                	xor    %edx,%edx
    6ce8:	49 8b 75 60          	mov    0x60(%r13),%rsi
    6cec:	49 8b 7d 00          	mov    0x0(%r13),%rdi
    6cf0:	e8 00 00 00 00       	callq  6cf5 <pidff_upload_effect+0x285>
    6cf5:	4d 85 e4             	test   %r12,%r12
    6cf8:	74 10                	je     6d0a <pidff_upload_effect+0x29a>
    6cfa:	0f b7 43 14          	movzwl 0x14(%rbx),%eax
    6cfe:	66 41 3b 44 24 14    	cmp    0x14(%r12),%ax
    6d04:	0f 84 f6 01 00 00    	je     6f00 <pidff_upload_effect+0x490>
    6d0a:	48 8d 73 12          	lea    0x12(%rbx),%rsi
    6d0e:	4c 89 ef             	mov    %r13,%rdi
    6d11:	e8 9a e7 ff ff       	callq  54b0 <pidff_set_envelope_report>
    6d16:	e9 07 fe ff ff       	jmpq   6b22 <pidff_upload_effect+0xb2>
    6d1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6d20:	48 85 d2             	test   %rdx,%rdx
    6d23:	0f 85 b0 fd ff ff    	jne    6ad9 <pidff_upload_effect+0x69>
    6d29:	41 8b b5 40 03 00 00 	mov    0x340(%r13),%esi
    6d30:	4c 89 ef             	mov    %r13,%rdi
    6d33:	e8 18 ec ff ff       	callq  5950 <pidff_request_effect_upload>
    6d38:	85 c0                	test   %eax,%eax
    6d3a:	74 59                	je     6d95 <pidff_upload_effect+0x325>
    6d3c:	e9 71 fd ff ff       	jmpq   6ab2 <pidff_upload_effect+0x42>
    6d41:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    6d48:	48 85 d2             	test   %rdx,%rdx
    6d4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6d50:	0f 85 83 fd ff ff    	jne    6ad9 <pidff_upload_effect+0x69>
    6d56:	41 8b b5 34 03 00 00 	mov    0x334(%r13),%esi
    6d5d:	4c 89 ef             	mov    %r13,%rdi
    6d60:	e8 eb eb ff ff       	callq  5950 <pidff_request_effect_upload>
    6d65:	85 c0                	test   %eax,%eax
    6d67:	74 2c                	je     6d95 <pidff_upload_effect+0x325>
    6d69:	e9 44 fd ff ff       	jmpq   6ab2 <pidff_upload_effect+0x42>
    6d6e:	66 90                	xchg   %ax,%ax
    6d70:	48 85 d2             	test   %rdx,%rdx
    6d73:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6d78:	0f 85 5b fd ff ff    	jne    6ad9 <pidff_upload_effect+0x69>
    6d7e:	41 8b b5 38 03 00 00 	mov    0x338(%r13),%esi
    6d85:	4c 89 ef             	mov    %r13,%rdi
    6d88:	e8 c3 eb ff ff       	callq  5950 <pidff_request_effect_upload>
    6d8d:	85 c0                	test   %eax,%eax
    6d8f:	0f 85 1d fd ff ff    	jne    6ab2 <pidff_upload_effect+0x42>
    6d95:	48 89 de             	mov    %rbx,%rsi
    6d98:	4c 89 ef             	mov    %r13,%rdi
    6d9b:	e8 20 e8 ff ff       	callq  55c0 <pidff_set_effect_report>
    6da0:	e9 72 fd ff ff       	jmpq   6b17 <pidff_upload_effect+0xa7>
    6da5:	0f 1f 00             	nopl   (%rax)
    6da8:	0f b7 43 20          	movzwl 0x20(%rbx),%eax
    6dac:	66 41 3b 44 24 20    	cmp    0x20(%r12),%ax
    6db2:	0f 85 5f fd ff ff    	jne    6b17 <pidff_upload_effect+0xa7>
    6db8:	0f b7 43 22          	movzwl 0x22(%rbx),%eax
    6dbc:	66 41 3b 44 24 22    	cmp    0x22(%r12),%ax
    6dc2:	0f 85 4f fd ff ff    	jne    6b17 <pidff_upload_effect+0xa7>
    6dc8:	0f b7 43 1c          	movzwl 0x1c(%rbx),%eax
    6dcc:	66 41 3b 44 24 1c    	cmp    0x1c(%r12),%ax
    6dd2:	0f 85 3f fd ff ff    	jne    6b17 <pidff_upload_effect+0xa7>
    6dd8:	0f b7 43 1e          	movzwl 0x1e(%rbx),%eax
    6ddc:	66 41 3b 44 24 1e    	cmp    0x1e(%r12),%ax
    6de2:	0f 85 2f fd ff ff    	jne    6b17 <pidff_upload_effect+0xa7>
    6de8:	0f b7 43 24          	movzwl 0x24(%rbx),%eax
    6dec:	66 41 3b 44 24 24    	cmp    0x24(%r12),%ax
    6df2:	0f 85 1f fd ff ff    	jne    6b17 <pidff_upload_effect+0xa7>
    6df8:	85 d2                	test   %edx,%edx
    6dfa:	0f 84 2b fd ff ff    	je     6b2b <pidff_upload_effect+0xbb>
    6e00:	e9 12 fd ff ff       	jmpq   6b17 <pidff_upload_effect+0xa7>
    6e05:	0f 1f 00             	nopl   (%rax)
    6e08:	0f b7 43 14          	movzwl 0x14(%rbx),%eax
    6e0c:	66 41 3b 44 24 14    	cmp    0x14(%r12),%ax
    6e12:	0f 85 ea fc ff ff    	jne    6b02 <pidff_upload_effect+0x92>
    6e18:	0f b7 43 16          	movzwl 0x16(%rbx),%eax
    6e1c:	66 41 3b 44 24 16    	cmp    0x16(%r12),%ax
    6e22:	0f 85 da fc ff ff    	jne    6b02 <pidff_upload_effect+0x92>
    6e28:	0f b7 43 10          	movzwl 0x10(%rbx),%eax
    6e2c:	66 41 3b 44 24 10    	cmp    0x10(%r12),%ax
    6e32:	0f 85 ca fc ff ff    	jne    6b02 <pidff_upload_effect+0x92>
    6e38:	0f b7 43 12          	movzwl 0x12(%rbx),%eax
    6e3c:	66 41 3b 44 24 12    	cmp    0x12(%r12),%ax
    6e42:	0f 85 ba fc ff ff    	jne    6b02 <pidff_upload_effect+0x92>
    6e48:	31 d2                	xor    %edx,%edx
    6e4a:	0f b7 43 18          	movzwl 0x18(%rbx),%eax
    6e4e:	66 41 3b 44 24 18    	cmp    0x18(%r12),%ax
    6e54:	0f 95 c2             	setne  %dl
    6e57:	e9 ab fc ff ff       	jmpq   6b07 <pidff_upload_effect+0x97>
    6e5c:	0f 1f 40 00          	nopl   0x0(%rax)
    6e60:	8b 43 04             	mov    0x4(%rbx),%eax
    6e63:	41 3b 44 24 04       	cmp    0x4(%r12),%eax
    6e68:	0f 85 79 fc ff ff    	jne    6ae7 <pidff_upload_effect+0x77>
    6e6e:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
    6e72:	66 41 3b 44 24 0c    	cmp    0xc(%r12),%ax
    6e78:	0f 85 69 fc ff ff    	jne    6ae7 <pidff_upload_effect+0x77>
    6e7e:	66 90                	xchg   %ax,%ax
    6e80:	e9 6d fc ff ff       	jmpq   6af2 <pidff_upload_effect+0x82>
    6e85:	0f 1f 00             	nopl   (%rax)
    6e88:	49 8b 95 68 02 00 00 	mov    0x268(%r13),%rdx
    6e8f:	48 0f bf 43 02       	movswq 0x2(%rbx),%rax
    6e94:	8b 12                	mov    (%rdx),%edx
    6e96:	41 89 94 85 54 03 00 	mov    %edx,0x354(%r13,%rax,4)
    6e9d:	00 
    6e9e:	e9 88 fc ff ff       	jmpq   6b2b <pidff_upload_effect+0xbb>
    6ea3:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 6eaa <pidff_upload_effect+0x43a>
    6eaa:	0f 84 88 fc ff ff    	je     6b38 <pidff_upload_effect+0xc8>
    6eb0:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 6eb7 <pidff_upload_effect+0x447>
    6eb7:	0f 84 7b fc ff ff    	je     6b38 <pidff_upload_effect+0xc8>
    6ebd:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    6ec4:	31 c0                	xor    %eax,%eax
    6ec6:	e8 00 00 00 00       	callq  6ecb <pidff_upload_effect+0x45b>
    6ecb:	31 c0                	xor    %eax,%eax
    6ecd:	e9 e0 fb ff ff       	jmpq   6ab2 <pidff_upload_effect+0x42>
    6ed2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    6ed8:	8b 46 04             	mov    0x4(%rsi),%eax
    6edb:	3b 42 04             	cmp    0x4(%rdx),%eax
    6ede:	0f 85 79 fc ff ff    	jne    6b5d <pidff_upload_effect+0xed>
    6ee4:	0f b7 46 0c          	movzwl 0xc(%rsi),%eax
    6ee8:	66 3b 42 0c          	cmp    0xc(%rdx),%ax
    6eec:	0f 85 6b fc ff ff    	jne    6b5d <pidff_upload_effect+0xed>
    6ef2:	e9 71 fc ff ff       	jmpq   6b68 <pidff_upload_effect+0xf8>
    6ef7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    6efe:	00 00 
    6f00:	0f b7 43 18          	movzwl 0x18(%rbx),%eax
    6f04:	66 41 3b 44 24 18    	cmp    0x18(%r12),%ax
    6f0a:	0f 85 fa fd ff ff    	jne    6d0a <pidff_upload_effect+0x29a>
    6f10:	0f b7 43 12          	movzwl 0x12(%rbx),%eax
    6f14:	66 41 3b 44 24 12    	cmp    0x12(%r12),%ax
    6f1a:	0f 85 ea fd ff ff    	jne    6d0a <pidff_upload_effect+0x29a>
    6f20:	0f b7 43 16          	movzwl 0x16(%rbx),%eax
    6f24:	66 41 3b 44 24 16    	cmp    0x16(%r12),%ax
    6f2a:	0f 85 da fd ff ff    	jne    6d0a <pidff_upload_effect+0x29a>
    6f30:	e9 f6 fb ff ff       	jmpq   6b2b <pidff_upload_effect+0xbb>
    6f35:	0f 1f 00             	nopl   (%rax)
    6f38:	8b 46 04             	mov    0x4(%rsi),%eax
    6f3b:	3b 42 04             	cmp    0x4(%rdx),%eax
    6f3e:	66 90                	xchg   %ax,%ax
    6f40:	0f 85 67 fd ff ff    	jne    6cad <pidff_upload_effect+0x23d>
    6f46:	0f b7 46 0c          	movzwl 0xc(%rsi),%eax
    6f4a:	66 3b 42 0c          	cmp    0xc(%rdx),%ax
    6f4e:	66 90                	xchg   %ax,%ax
    6f50:	0f 85 57 fd ff ff    	jne    6cad <pidff_upload_effect+0x23d>
    6f56:	e9 5d fd ff ff       	jmpq   6cb8 <pidff_upload_effect+0x248>
    6f5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    6f60:	0f b7 43 1a          	movzwl 0x1a(%rbx),%eax
    6f64:	66 41 3b 44 24 1a    	cmp    0x1a(%r12),%ax
    6f6a:	0f 85 58 fc ff ff    	jne    6bc8 <pidff_upload_effect+0x158>
    6f70:	0f b7 43 14          	movzwl 0x14(%rbx),%eax
    6f74:	66 41 3b 44 24 14    	cmp    0x14(%r12),%ax
    6f7a:	0f 85 48 fc ff ff    	jne    6bc8 <pidff_upload_effect+0x158>
    6f80:	0f b7 43 18          	movzwl 0x18(%rbx),%eax
    6f84:	66 41 3b 44 24 18    	cmp    0x18(%r12),%ax
    6f8a:	0f 85 38 fc ff ff    	jne    6bc8 <pidff_upload_effect+0x158>
    6f90:	e9 96 fb ff ff       	jmpq   6b2b <pidff_upload_effect+0xbb>
    6f95:	0f 1f 00             	nopl   (%rax)
    6f98:	0f b7 43 18          	movzwl 0x18(%rbx),%eax
    6f9c:	66 41 3b 44 24 18    	cmp    0x18(%r12),%ax
    6fa2:	0f 85 67 fc ff ff    	jne    6c0f <pidff_upload_effect+0x19f>
    6fa8:	0f b7 43 12          	movzwl 0x12(%rbx),%eax
    6fac:	66 41 3b 44 24 12    	cmp    0x12(%r12),%ax
    6fb2:	0f 85 57 fc ff ff    	jne    6c0f <pidff_upload_effect+0x19f>
    6fb8:	e9 b5 fc ff ff       	jmpq   6c72 <pidff_upload_effect+0x202>
    6fbd:	0f 1f 00             	nopl   (%rax)
    6fc0:	8b 46 04             	mov    0x4(%rsi),%eax
    6fc3:	3b 42 04             	cmp    0x4(%rdx),%eax
    6fc6:	0f 85 2a fc ff ff    	jne    6bf6 <pidff_upload_effect+0x186>
    6fcc:	0f b7 46 0c          	movzwl 0xc(%rsi),%eax
    6fd0:	66 3b 42 0c          	cmp    0xc(%rdx),%ax
    6fd4:	0f 85 1c fc ff ff    	jne    6bf6 <pidff_upload_effect+0x186>
    6fda:	e9 22 fc ff ff       	jmpq   6c01 <pidff_upload_effect+0x191>
    6fdf:	90                   	nop
    6fe0:	0f b7 43 20          	movzwl 0x20(%rbx),%eax
    6fe4:	66 41 3b 44 24 20    	cmp    0x20(%r12),%ax
    6fea:	0f 85 92 fc ff ff    	jne    6c82 <pidff_upload_effect+0x212>
    6ff0:	0f b7 43 1a          	movzwl 0x1a(%rbx),%eax
    6ff4:	66 41 3b 44 24 1a    	cmp    0x1a(%r12),%ax
    6ffa:	0f 85 82 fc ff ff    	jne    6c82 <pidff_upload_effect+0x212>
    7000:	0f b7 43 1e          	movzwl 0x1e(%rbx),%eax
    7004:	66 41 3b 44 24 1e    	cmp    0x1e(%r12),%ax
    700a:	0f 85 72 fc ff ff    	jne    6c82 <pidff_upload_effect+0x212>
    7010:	e9 16 fb ff ff       	jmpq   6b2b <pidff_upload_effect+0xbb>
    7015:	0f 1f 00             	nopl   (%rax)
    7018:	0f b7 46 10          	movzwl 0x10(%rsi),%eax
    701c:	83 e8 58             	sub    $0x58,%eax
    701f:	66 83 f8 04          	cmp    $0x4,%ax
    7023:	76 18                	jbe    703d <pidff_upload_effect+0x5cd>
    7025:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    702c:	31 c0                	xor    %eax,%eax
    702e:	e8 00 00 00 00       	callq  7033 <pidff_upload_effect+0x5c3>
    7033:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
    7038:	e9 75 fa ff ff       	jmpq   6ab2 <pidff_upload_effect+0x42>
    703d:	0f b7 c0             	movzwl %ax,%eax
    7040:	ff 24 c5 00 00 00 00 	jmpq   *0x0(,%rax,8)
    7047:	b8 05 00 00 00       	mov    $0x5,%eax
    704c:	48 98                	cltq   
    704e:	4c 89 ef             	mov    %r13,%rdi
    7051:	41 8b b4 85 18 03 00 	mov    0x318(%r13,%rax,4),%esi
    7058:	00 
    7059:	e8 f2 e8 ff ff       	callq  5950 <pidff_request_effect_upload>
    705e:	85 c0                	test   %eax,%eax
    7060:	0f 85 4c fa ff ff    	jne    6ab2 <pidff_upload_effect+0x42>
    7066:	48 89 de             	mov    %rbx,%rsi
    7069:	4c 89 ef             	mov    %r13,%rdi
    706c:	e8 4f e5 ff ff       	callq  55c0 <pidff_set_effect_report>
    7071:	e9 99 fb ff ff       	jmpq   6c0f <pidff_upload_effect+0x19f>
    7076:	b8 03 00 00 00       	mov    $0x3,%eax
    707b:	eb cf                	jmp    704c <pidff_upload_effect+0x5dc>
    707d:	b8 04 00 00 00       	mov    $0x4,%eax
    7082:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    7088:	eb c2                	jmp    704c <pidff_upload_effect+0x5dc>
    708a:	b8 02 00 00 00       	mov    $0x2,%eax
    708f:	90                   	nop
    7090:	eb ba                	jmp    704c <pidff_upload_effect+0x5dc>
    7092:	b8 06 00 00 00       	mov    $0x6,%eax
    7097:	eb b3                	jmp    704c <pidff_upload_effect+0x5dc>
    7099:	41 8b b5 18 03 00 00 	mov    0x318(%r13),%esi
    70a0:	4c 89 ef             	mov    %r13,%rdi
    70a3:	e8 a8 e8 ff ff       	callq  5950 <pidff_request_effect_upload>
    70a8:	85 c0                	test   %eax,%eax
    70aa:	0f 85 02 fa ff ff    	jne    6ab2 <pidff_upload_effect+0x42>
    70b0:	48 89 de             	mov    %rbx,%rsi
    70b3:	4c 89 ef             	mov    %r13,%rdi
    70b6:	e8 05 e5 ff ff       	callq  55c0 <pidff_set_effect_report>
    70bb:	49 8b 95 68 02 00 00 	mov    0x268(%r13),%rdx
    70c2:	49 8b 85 08 02 00 00 	mov    0x208(%r13),%rax
    70c9:	8b 12                	mov    (%rdx),%edx
    70cb:	49 8d bd 10 02 00 00 	lea    0x210(%r13),%rdi
    70d2:	89 10                	mov    %edx,(%rax)
    70d4:	0f bf 73 10          	movswl 0x10(%rbx),%esi
    70d8:	e8 13 e1 ff ff       	callq  51f0 <pidff_set_signed>
    70dd:	49 8b 75 60          	mov    0x60(%r13),%rsi
    70e1:	31 d2                	xor    %edx,%edx
    70e3:	49 8b 7d 00          	mov    0x0(%r13),%rdi
    70e7:	e8 00 00 00 00       	callq  70ec <pidff_upload_effect+0x67c>
    70ec:	e9 19 fc ff ff       	jmpq   6d0a <pidff_upload_effect+0x29a>
    70f1:	41 8b b5 3c 03 00 00 	mov    0x33c(%r13),%esi
    70f8:	4c 89 ef             	mov    %r13,%rdi
    70fb:	e8 50 e8 ff ff       	callq  5950 <pidff_request_effect_upload>
    7100:	85 c0                	test   %eax,%eax
    7102:	0f 84 8d fc ff ff    	je     6d95 <pidff_upload_effect+0x325>
    7108:	e9 a5 f9 ff ff       	jmpq   6ab2 <pidff_upload_effect+0x42>
    710d:	41 8b b5 1c 03 00 00 	mov    0x31c(%r13),%esi
    7114:	4c 89 ef             	mov    %r13,%rdi
    7117:	e8 34 e8 ff ff       	callq  5950 <pidff_request_effect_upload>
    711c:	85 c0                	test   %eax,%eax
    711e:	0f 85 8e f9 ff ff    	jne    6ab2 <pidff_upload_effect+0x42>
    7124:	48 89 de             	mov    %rbx,%rsi
    7127:	4c 89 ef             	mov    %r13,%rdi
    712a:	e8 91 e4 ff ff       	callq  55c0 <pidff_set_effect_report>
    712f:	90                   	nop
    7130:	e9 3d fa ff ff       	jmpq   6b72 <pidff_upload_effect+0x102>
    7135:	66 66 2e 0f 1f 84 00 	nopw   %cs:0x0(%rax,%rax,1)
    713c:	00 00 00 00 

0000000000007140 <pidff_erase_effect>:
    7140:	55                   	push   %rbp
    7141:	48 89 e5             	mov    %rsp,%rbp
    7144:	41 54                	push   %r12
    7146:	53                   	push   %rbx
    7147:	e8 00 00 00 00       	callq  714c <pidff_erase_effect+0xc>
    714c:	f6 05 00 00 00 00 20 	testb  $0x20,0x0(%rip)        # 7153 <pidff_erase_effect+0x13>
    7153:	48 8b 87 f0 00 00 00 	mov    0xf0(%rdi),%rax
    715a:	48 8b 58 30          	mov    0x30(%rax),%rbx
    715e:	48 63 c6             	movslq %esi,%rax
    7161:	44 8b a4 83 54 03 00 	mov    0x354(%rbx,%rax,4),%r12d
    7168:	00 
    7169:	75 34                	jne    719f <pidff_erase_effect+0x5f>
    716b:	48 8b 3b             	mov    (%rbx),%rdi
    716e:	e8 00 00 00 00       	callq  7173 <pidff_erase_effect+0x33>
    7173:	44 89 e6             	mov    %r12d,%esi
    7176:	48 89 df             	mov    %rbx,%rdi
    7179:	31 d2                	xor    %edx,%edx
    717b:	e8 70 e1 ff ff       	callq  52f0 <pidff_playback_pid>
    7180:	48 8b 83 d8 02 00 00 	mov    0x2d8(%rbx),%rax
    7187:	31 d2                	xor    %edx,%edx
    7189:	44 89 20             	mov    %r12d,(%rax)
    718c:	48 8b 73 30          	mov    0x30(%rbx),%rsi
    7190:	48 8b 3b             	mov    (%rbx),%rdi
    7193:	e8 00 00 00 00       	callq  7198 <pidff_erase_effect+0x58>
    7198:	5b                   	pop    %rbx
    7199:	31 c0                	xor    %eax,%eax
    719b:	41 5c                	pop    %r12
    719d:	c9                   	leaveq 
    719e:	c3                   	retq   
    719f:	f6 05 00 00 00 00 04 	testb  $0x4,0x0(%rip)        # 71a6 <pidff_erase_effect+0x66>
    71a6:	74 c3                	je     716b <pidff_erase_effect+0x2b>
    71a8:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 71af <pidff_erase_effect+0x6f>
    71af:	74 ba                	je     716b <pidff_erase_effect+0x2b>
    71b1:	44 89 e2             	mov    %r12d,%edx
    71b4:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    71bb:	31 c0                	xor    %eax,%eax
    71bd:	e8 00 00 00 00       	callq  71c2 <pidff_erase_effect+0x82>
    71c2:	eb a7                	jmp    716b <pidff_erase_effect+0x2b>

Disassembly of section .init.text:

0000000000000000 <hid_init>:
   0:	55                   	push   %rbp
   1:	45 31 c0             	xor    %r8d,%r8d
   4:	48 89 e5             	mov    %rsp,%rbp
   7:	31 c9                	xor    %ecx,%ecx
   9:	53                   	push   %rbx
   a:	ba 01 00 00 00       	mov    $0x1,%edx
   f:	48 83 ec 08          	sub    $0x8,%rsp
  13:	be 0e 00 00 00       	mov    $0xe,%esi
  18:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  1f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  24:	e8 00 00 00 00       	callq  29 <hid_init+0x29>
  29:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # 30 <hid_init+0x30>
  30:	48 85 c0             	test   %rax,%rax
  33:	0f 84 85 00 00 00    	je     be <hid_init+0xbe>
  39:	31 f6                	xor    %esi,%esi
  3b:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
  42:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  49:	e8 00 00 00 00       	callq  4e <hid_init+0x4e>
  4e:	89 c3                	mov    %eax,%ebx
  50:	85 c0                	test   %eax,%eax
  52:	75 5e                	jne    b2 <hid_init+0xb2>
  54:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  5b:	e8 00 00 00 00       	callq  60 <hid_init+0x60>
  60:	89 c3                	mov    %eax,%ebx
  62:	85 c0                	test   %eax,%eax
  64:	75 40                	jne    a6 <hid_init+0xa6>
  66:	e8 00 00 00 00       	callq  6b <hid_init+0x6b>
  6b:	89 c3                	mov    %eax,%ebx
  6d:	85 c0                	test   %eax,%eax
  6f:	75 30                	jne    a1 <hid_init+0xa1>
  71:	31 f6                	xor    %esi,%esi
  73:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
  7a:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  81:	e8 00 00 00 00       	callq  86 <hid_init+0x86>
  86:	89 c3                	mov    %eax,%ebx
  88:	85 c0                	test   %eax,%eax
  8a:	75 10                	jne    9c <hid_init+0x9c>
  8c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  93:	31 c0                	xor    %eax,%eax
  95:	e8 00 00 00 00       	callq  9a <hid_init+0x9a>
  9a:	eb 22                	jmp    be <hid_init+0xbe>
  9c:	e8 00 00 00 00       	callq  a1 <hid_init+0xa1>
  a1:	e8 00 00 00 00       	callq  a6 <hid_init+0xa6>
  a6:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  ad:	e8 00 00 00 00       	callq  b2 <hid_init+0xb2>
  b2:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # b9 <hid_init+0xb9>
  b9:	e8 00 00 00 00       	callq  be <hid_init+0xbe>
  be:	89 d8                	mov    %ebx,%eax
  c0:	5a                   	pop    %rdx
  c1:	5b                   	pop    %rbx
  c2:	c9                   	leaveq 
  c3:	c3                   	retq   

00000000000000c4 <hiddev_init>:
  c4:	55                   	push   %rbp
  c5:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
  cc:	48 89 e5             	mov    %rsp,%rbp
  cf:	31 f6                	xor    %esi,%esi
  d1:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  d8:	e8 00 00 00 00       	callq  dd <hiddev_init+0x19>
  dd:	c9                   	leaveq 
  de:	c3                   	retq   

Disassembly of section .exit.text:

0000000000000000 <hid_exit>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	e8 00 00 00 00       	callq  9 <hid_exit+0x9>
   9:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  10:	e8 00 00 00 00       	callq  15 <hid_exit+0x15>
  15:	e8 00 00 00 00       	callq  1a <hid_exit+0x1a>
  1a:	e8 00 00 00 00       	callq  1f <hid_exit+0x1f>
  1f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
  26:	e8 00 00 00 00       	callq  2b <hid_exit+0x2b>
  2b:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 32 <hid_exit+0x32>
  32:	e8 00 00 00 00       	callq  37 <hid_exit+0x37>
  37:	c9                   	leaveq 
  38:	c3                   	retq   

--------------080700030705030700040101--
