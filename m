Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0ITRka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:40:30 -0400
Received: from atl.turmel.org ([74.117.157.138]:38015 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0ITRkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:40:25 -0400
Message-ID: <4C979C79.9090901@turmel.org>
Date: Mon, 20 Sep 2010 13:40:09 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org> <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz> <AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com> <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------030309090103050309000404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030309090103050309000404
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

On 09/20/2010 11:10 AM, Jiri Kosina wrote:
> Thanks Matt and Phill for confirming the line that triggers the oops. As I 
> am not able to reproduce it myself, it's a bit tricky to track down what 
> went wrong.
> 
> Could you please apply the patch below? It's printing the hid <-> hiddev 
> <-> usb_interface connections at various stages of probing and open. 
> Hopefully it'll reveal a little bit what goes wrong and where.
> 
> Thanks.
> 
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 3f72924..3159a63 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1155,6 +1155,8 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  	unsigned int i;
>  	int len;
>  
> +	printk("HID debug: hid_connect() -- hid: %p\n", hdev);
> +
>  	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
>  		connect_mask |= (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
>  	if (hdev->quirks & HID_QUIRK_HIDINPUT_FORCE)
> @@ -1169,8 +1171,11 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  		hdev->claimed |= HID_CLAIMED_INPUT;
>  	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
>  			!hdev->hiddev_connect(hdev,
> -				connect_mask & HID_CONNECT_HIDDEV_FORCE))
> +				connect_mask & HID_CONNECT_HIDDEV_FORCE)) {
>  		hdev->claimed |= HID_CLAIMED_HIDDEV;
> +		printk("HID debug: hid_connect() -- after hiddev_connect(), hid: %p, hiddev: %p\n",
> +				hdev, hdev->hiddev);
> +	}
>  	if ((connect_mask & HID_CONNECT_HIDRAW) && !hidraw_connect(hdev))
>  		hdev->claimed |= HID_CLAIMED_HIDRAW;
>  
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 599041a..d2491a1 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -1148,6 +1148,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
>  	if (IS_ERR(hid))
>  		return PTR_ERR(hid);
>  
> +	printk("HID debug: usbhid_probe() -- set intfdata(%p, %p)\n", intf, hid);
>  	usb_set_intfdata(intf, hid);
>  	hid->ll_driver = &usb_hid_driver;
>  	hid->hid_output_raw_report = usbhid_output_raw_report;
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index 681e620..9aab39a 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -282,6 +282,8 @@ static int hiddev_open(struct inode *inode, struct file *file)
>  	list->hiddev = hiddev;
>  	file->private_data = list;
>  
> +	printk("HID debug: hiddev_open(): hid: %p, hiddev: %p, intf: %p\n",
> +			hid, hiddev, intf);
>  	/*
>  	 * no need for locking because the USB major number
>  	 * is shared which usbcore guards against disconnect
> @@ -892,6 +894,8 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
>  	hid->hiddev = hiddev;
>  	hiddev->hid = hid;
>  	hiddev->exist = 1;
> +	printk("HID debug: hiddev_connect() -- hid: %p, hiddev: %p, intf: %p\n",
> +			hid, hiddev, usbhid->intf);
>  	retval = usb_register_dev(usbhid->intf, &hiddev_class);
>  	if (retval) {
>  		err_hid("Not able to get a minor for this device.");
> @@ -912,6 +916,8 @@ void hiddev_disconnect(struct hid_device *hid)
>  	struct hiddev *hiddev = hid->hiddev;
>  	struct usbhid_device *usbhid = hid->driver_data;
>  
> +	printk("HID debug: hiddev_disconnect() -- hid: %p, usbhid: %p, hiddev: %p\n",
> +			hid, usbhid, hiddev);
>  	mutex_lock(&hiddev->existancelock);
>  	hiddev->exist = 0;
>  	mutex_unlock(&hiddev->existancelock);
> 

dmesg attached.  Note: the timestamp of the BUG corresponds to hal startup when the external mouse is plugged in before booting.


--------------030309090103050309000404
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.36-rc4-00167-gd45c167 (root@scorpius) (gcc version 4.4.4 (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #19 SMP PREEMPT Mon Sep 20 13:29:04 EDT 2010
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
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: PIT calibration matches HPET. 1 loops
[    0.000000] Detected 2194.499 MHz processor.
[    0.006672] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.87 BogoMIPS (lpj=7314996)
[    0.006915] pid_max: default: 32768 minimum: 301
[    0.007430] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011857] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013310] Mount-cache hash table entries: 256
[    0.013498] Initializing cgroup subsys cpuacct
[    0.013625] Initializing cgroup subsys net_cls
[    0.013773] CPU: Physical Processor ID: 0
[    0.013893] CPU: Processor Core ID: 0
[    0.014013] mce: CPU supports 6 MCE banks
[    0.014138] CPU0: Thermal monitoring handled by SMI
[    0.014262] using mwait in idle threads.
[    0.014390] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.014702] PEBS disabled due to CPU errata.
[    0.014824] ... version:                2
[    0.014943] ... bit width:              40
[    0.015063] ... generic registers:      2
[    0.015181] ... value mask:             000000ffffffffff
[    0.015303] ... max period:             000000007fffffff
[    0.015425] ... fixed-purpose events:   3
[    0.015544] ... event mask:             0000000700000003
[    0.015723] ACPI: Core revision 20100702
[    0.024530] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.024657] ftrace: allocating 35048 entries in 138 pages
[    0.026716] Setting APIC routing to flat
[    0.027298] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061200] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.073349] Booting Node   0, Processors  #1 Ok.
[    0.009999] CPU1: Thermal monitoring handled by SMI
[    0.170019] Brought up 2 CPUs
[    0.170260] Total of 2 processors activated (8781.73 BogoMIPS).
[    0.170919] devtmpfs: initialized
[    0.170919] xor: automatically using best checksumming function: generic_sse
[    0.186531]    generic_sse:  8116.800 MB/sec
[    0.186652] xor: using function: generic_sse (8116.800 MB/sec)
[    0.186714] NET: Registered protocol family 16
[    0.186853] ACPI: bus type pci registered
[    0.186853] dca service started, version 1.12.1
[    0.186853] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.186884] PCI: not using MMCONFIG
[    0.187004] PCI: Using configuration type 1 for base access
[    0.193363] bio: create slab <bio-0> at 0
[    0.250047] raid6: int64x1   1712 MB/s
[    0.306546] raid6: int64x2   2165 MB/s
[    0.363230] raid6: int64x4   1650 MB/s
[    0.419906] raid6: int64x8   1460 MB/s
[    0.476543] raid6: sse2x1    3701 MB/s
[    0.533206] raid6: sse2x2    3884 MB/s
[    0.589871] raid6: sse2x4    6555 MB/s
[    0.589990] raid6: using algorithm sse2x4 (6555 MB/s)
[    0.591086] ACPI: EC: Look up EC in DSDT
[    0.592456] ACPI: Actual Package length (12) is larger than NumElements field (5), truncated
[    0.592698] 
[    0.596247] ACPI Warning: Incorrect checksum in table [ASF!] - 0xE9, should be 0x94 (20100702/tbutils-314)
[    0.596554] ACPI: SSDT 00000000bff46b71 000F3 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.597042] ACPI: Dynamic OEM Table Load:
[    0.597289] ACPI: SSDT (null) 000F3 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.597725] ACPI: SSDT 00000000bff46cda 0006C (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.598279] ACPI: Dynamic OEM Table Load:
[    0.598521] ACPI: SSDT (null) 0006C (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.599049] ACPI: SSDT 00000000bff46c64 00076 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.599691] ACPI: Dynamic OEM Table Load:
[    0.600002] ACPI: SSDT (null) 00076 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.600356] ACPI: SSDT 00000000bff46d46 00079 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.600914] ACPI: Dynamic OEM Table Load:
[    0.601160] ACPI: SSDT (null) 00079 (v02 TOSHIB A0056    20060921 MSFT 03000000)
[    0.601573] ACPI: Interpreter enabled
[    0.601692] ACPI: (supports S0 S3 S4 S5)
[    0.602073] ACPI: Using IOAPIC for interrupt routing
[    0.602220] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.603275] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.620776] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.620905] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.621168] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.621328] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.621328] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.621328] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.623369] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.623548] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xefffffff]
[    0.623723] pci_root PNP0A08:00: host bridge window [mem 0xf4000000-0xfebfffff]
[    0.623899] pci_root PNP0A08:00: host bridge window [mem 0xfec28000-0xfecfffff]
[    0.624075] pci_root PNP0A08:00: host bridge window [mem 0xfed00500-0xfed13fff]
[    0.624256] pci_root PNP0A08:00: host bridge window [mem 0xfed1a000-0xfed1bfff]
[    0.624432] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.624608] pci_root PNP0A08:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.624784] pci_root PNP0A08:00: host bridge window [mem 0xfedc0000-0xfedfffff]
[    0.624958] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xff9fffff]
[    0.625135] pci_root PNP0A08:00: host bridge window [mem 0xffc00000-0xffcfffff]
[    0.625394] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.625518] pci 0000:00:01.0: PME# disabled
[    0.625670] pci 0000:00:03.0: reg 10: [mem 0xffcffff0-0xffcfffff 64bit]
[    0.625831] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.625955] pci 0000:00:03.0: PME# disabled
[    0.626160] pci 0000:00:19.0: reg 10: [mem 0xffcc0000-0xffcdffff]
[    0.626294] pci 0000:00:19.0: reg 14: [mem 0xffcfe000-0xffcfefff]
[    0.626427] pci 0000:00:19.0: reg 18: [io  0xbfe0-0xbfff]
[    0.626738] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.626865] pci 0000:00:19.0: PME# disabled
[    0.627058] pci 0000:00:1a.0: reg 20: [io  0xbf80-0xbf9f]
[    0.628394] pci 0000:00:1a.1: reg 20: [io  0x0000-0x001f]
[    0.628590] pci 0000:00:1a.7: reg 10: [mem 0xffcff800-0xffcffbff]
[    0.628803] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.628930] pci 0000:00:1a.7: PME# disabled
[    0.629096] pci 0000:00:1b.0: reg 10: [mem 0x00000000-0x00003fff 64bit]
[    0.629300] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.629425] pci 0000:00:1b.0: PME# disabled
[    0.629654] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.629779] pci 0000:00:1c.0: PME# disabled
[    0.630144] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.630269] pci 0000:00:1c.1: PME# disabled
[    0.630503] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.630628] pci 0000:00:1c.2: PME# disabled
[    0.630837] pci 0000:00:1d.0: reg 20: [io  0x9fe0-0x9fff]
[    0.631053] pci 0000:00:1d.1: reg 20: [io  0x9f80-0x9f9f]
[    0.631269] pci 0000:00:1d.2: reg 20: [io  0x9f60-0x9f7f]
[    0.631465] pci 0000:00:1d.7: reg 10: [mem 0xffcff400-0xffcff7ff]
[    0.631677] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.631802] pci 0000:00:1d.7: PME# disabled
[    0.632142] pci 0000:00:1f.0: quirk: [io  0xd800-0xd87f] claimed by ICH6 ACPI/GPIO/TCO
[    0.632321] pci 0000:00:1f.0: quirk: [io  0xeec0-0xeeff] claimed by ICH6 GPIO
[    0.632447] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.632628] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)
[    0.632860] pci 0000:00:1f.1: reg 10: [io  0x9f58-0x9f5f]
[    0.632992] pci 0000:00:1f.1: reg 14: [io  0x9f54-0x9f57]
[    0.633123] pci 0000:00:1f.1: reg 18: [io  0x9f48-0x9f4f]
[    0.633254] pci 0000:00:1f.1: reg 1c: [io  0x9f44-0x9f47]
[    0.633346] pci 0000:00:1f.1: reg 20: [io  0x9f30-0x9f3f]
[    0.633543] pci 0000:00:1f.2: reg 10: [io  0x9f28-0x9f2f]
[    0.633674] pci 0000:00:1f.2: reg 14: [io  0x9f24-0x9f27]
[    0.633805] pci 0000:00:1f.2: reg 18: [io  0x9f18-0x9f1f]
[    0.633938] pci 0000:00:1f.2: reg 1c: [io  0x9f14-0x9f17]
[    0.634070] pci 0000:00:1f.2: reg 20: [io  0x9ee0-0x9eff]
[    0.634202] pci 0000:00:1f.2: reg 24: [mem 0xffcfd800-0xffcfdfff]
[    0.634371] pci 0000:00:1f.2: PME# supported from D3hot
[    0.634495] pci 0000:00:1f.2: PME# disabled
[    0.634700] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.634842] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.634985] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.635120] pci 0000:01:00.0: reg 24: [io  0xcf00-0xcf7f]
[    0.635253] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.635453] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.635576] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.635700] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdffffff]
[    0.635827] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.636134] pci 0000:02:00.0: reg 10: [mem 0xff9fe000-0xff9fffff 64bit]
[    0.636419] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.636548] pci 0000:02:00.0: PME# disabled
[    0.643375] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.643505] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.643632] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.643763] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.644004] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.644132] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.644259] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.644387] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.644625] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.644750] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
[    0.644877] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.645059] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.645332] pci 0000:06:0b.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.645484] pci 0000:06:0b.0: supports D1 D2
[    0.645605] pci 0000:06:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.645733] pci 0000:06:0b.0: PME# disabled
[    0.645904] pci 0000:06:0b.1: reg 10: [mem 0x00000000-0x000007ff]
[    0.646047] pci 0000:06:0b.1: reg 14: [mem 0x00000000-0x00003fff]
[    0.646266] pci 0000:06:0b.1: supports D1 D2
[    0.646387] pci 0000:06:0b.1: PME# supported from D0 D1 D2 D3hot
[    0.646514] pci 0000:06:0b.1: PME# disabled
[    0.646692] pci 0000:06:0b.2: reg 10: [mem 0x00000000-0x00000fff]
[    0.646926] pci 0000:06:0b.2: supports D1 D2
[    0.647047] pci 0000:06:0b.2: PME# supported from D0 D1 D2 D3hot
[    0.647174] pci 0000:06:0b.2: PME# disabled
[    0.647344] pci 0000:06:0b.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.647577] pci 0000:06:0b.3: supports D1 D2
[    0.647699] pci 0000:06:0b.3: PME# supported from D0 D1 D2 D3hot
[    0.647824] pci 0000:06:0b.3: PME# disabled
[    0.648001] pci 0000:00:1e.0: PCI bridge to [bus 06-07] (subtractive decode)
[    0.648128] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.648255] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.648438] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.648617] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.648795] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.648970] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.649149] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.649327] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xefffffff] (subtractive decode)
[    0.649506] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfebfffff] (subtractive decode)
[    0.649684] pci 0000:00:1e.0:   bridge window [mem 0xfec28000-0xfecfffff] (subtractive decode)
[    0.649864] pci 0000:00:1e.0:   bridge window [mem 0xfed00500-0xfed13fff] (subtractive decode)
[    0.650013] pci 0000:00:1e.0:   bridge window [mem 0xfed1a000-0xfed1bfff] (subtractive decode)
[    0.650192] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.650370] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.650549] pci 0000:00:1e.0:   bridge window [mem 0xfedc0000-0xfedfffff] (subtractive decode)
[    0.650727] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xff9fffff] (subtractive decode)
[    0.650905] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffcfffff] (subtractive decode)
[    0.651139] pci_bus 0000:07: [bus 07-0a] partially hidden behind transparent bridge 0000:06 [bus 06-07]
[    0.651350] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.651564] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.651772] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MPEX._PRT]
[    0.651934] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXCB._PRT]
[    0.652092] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.652249] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.657000] ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
[    0.657121] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
[    0.657813] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
[    0.658504] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
[    0.659194] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
[    0.660445] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
[    0.661135] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
[    0.661829] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
[    0.662484] HEST: Table is not found!
[    0.662484] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.662484] vgaarb: loaded
[    0.662484] SCSI subsystem initialized
[    0.663356] libata version 3.00 loaded.
[    0.663368] usbcore: registered new interface driver usbfs
[    0.663480] usbcore: registered new interface driver hub
[    0.663480] usbcore: registered new device driver usb
[    0.663480] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.663480] PCI: Using ACPI for IRQ routing
[    0.663593] PCI: pci_cache_line_size set to 64 bytes
[    0.663833] reserve RAM buffer: 000000000009bc00 - 000000000009ffff 
[    0.663904] reserve RAM buffer: 00000000bff40000 - 00000000bfffffff 
[    0.664105] NET: Registered protocol family 23
[    0.664105] Bluetooth: Core ver 2.15
[    0.664105] NET: Registered protocol family 31
[    0.664105] Bluetooth: HCI device and connection manager initialized
[    0.664105] Bluetooth: HCI socket layer initialized
[    0.664105] NET: Registered protocol family 8
[    0.664105] NET: Registered protocol family 20
[    0.664105] cfg80211: Calling CRDA to update world regulatory domain
[    0.666709] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.673351] Switching to clocksource tsc
[    0.682126] pnp: PnP ACPI init
[    0.682270] ACPI: bus type pnp registered
[    0.684737] pnp 00:09: disabling [io  0x0010-0x001f] because it overlaps 0000:00:1a.1 BAR 4 [io  0x0000-0x001f]
[    0.686741] pnp: PnP ACPI: found 13 devices
[    0.686862] ACPI: ACPI bus type pnp unregistered
[    0.686992] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.687117] system 00:00: [mem 0x000e8000-0x000fffff] could not be reserved
[    0.687242] system 00:00: [mem 0x00100000-0xbff3ffff] could not be reserved
[    0.687367] system 00:00: [mem 0xbff40000-0xbff4ffff] has been reserved
[    0.687492] system 00:00: [mem 0xbff50000-0xbfffffff] has been reserved
[    0.687615] system 00:00: [mem 0xfec00000-0xfec27fff] could not be reserved
[    0.687740] system 00:00: [mem 0xfed00400-0xfed004ff] has been reserved
[    0.687865] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.687989] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.688113] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.688238] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.688362] system 00:00: [mem 0xfeda0000-0xfedbffff] has been reserved
[    0.688486] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.688613] system 00:00: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.688737] system 00:00: [mem 0xffd00000-0xffffffff] has been reserved
[    0.690018] system 00:00: [mem 0x100000000-0x13bffffff] could not be reserved
[    0.690146] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.690274] system 00:09: [io  0x01e0-0x01ef] has been reserved
[    0.690398] system 00:09: [io  0x0480-0x048f] has been reserved
[    0.690521] system 00:09: [io  0xe000-0xe07f] has been reserved
[    0.690645] system 00:09: [io  0xe080-0xe0ff] has been reserved
[    0.690767] system 00:09: [io  0xe400-0xe47f] has been reserved
[    0.690891] system 00:09: [io  0xe480-0xe4ff] has been reserved
[    0.691014] system 00:09: [io  0xe800-0xe87f] has been reserved
[    0.691138] system 00:09: [io  0xe880-0xe8ff] has been reserved
[    0.691261] system 00:09: [io  0xec00-0xec7f] has been reserved
[    0.691385] system 00:09: [io  0xec80-0xecff] has been reserved
[    0.691508] system 00:09: [io  0xd800-0xd87f] has been reserved
[    0.691632] system 00:09: [io  0xd880-0xd89f] has been reserved
[    0.691755] system 00:09: [io  0xeec0-0xeeff] has been reserved
[    0.691879] system 00:09: [io  0x0690-0x06ff] has been reserved
[    0.692004] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.699700] pci 0000:00:1e.0: BAR 15: assigned [mem 0xc0000000-0xc3ffffff pref]
[    0.699885] pci 0000:00:1e.0: BAR 14: assigned [mem 0xc4000000-0xc9ffffff]
[    0.700011] pci 0000:00:1c.1: BAR 15: assigned [mem 0xca000000-0xca1fffff 64bit pref]
[    0.700189] pci 0000:00:1b.0: BAR 0: assigned [mem 0xca200000-0xca203fff 64bit]
[    0.700372] pci 0000:00:1b.0: BAR 0: set to [mem 0xca200000-0xca203fff 64bit] (PCI address [0xca200000-0xca203fff]
[    0.700553] pci 0000:00:1e.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.700676] pci 0000:00:1a.1: BAR 4: assigned [io  0x2000-0x201f]
[    0.700803] pci 0000:00:1a.1: BAR 4: set to [io  0x2000-0x201f] (PCI address [0x2000-0x201f]
[    0.700983] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    0.701160] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.701285] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.701409] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdffffff]
[    0.701533] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.701712] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.701835] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.701962] pci 0000:00:1c.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.702087] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.702217] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.702340] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.702467] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.702598] pci 0000:00:1c.1:   bridge window [mem 0xca000000-0xca1fffff 64bit pref]
[    0.702781] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.702902] pci 0000:00:1c.2:   bridge window [io  disabled]
[    0.703029] pci 0000:00:1c.2:   bridge window [mem disabled]
[    0.703156] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    0.703292] pci 0000:06:0b.0: BAR 15: assigned [mem 0xc0000000-0xc3ffffff pref]
[    0.703469] pci 0000:06:0b.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.703592] pci 0000:06:0b.1: BAR 1: assigned [mem 0xc8000000-0xc8003fff]
[    0.703719] pci 0000:06:0b.1: BAR 1: set to [mem 0xc8000000-0xc8003fff] (PCI address [0xc8000000-0xc8003fff]
[    0.703899] pci 0000:06:0b.0: BAR 0: assigned [mem 0xc8004000-0xc8004fff]
[    0.704027] pci 0000:06:0b.0: BAR 0: set to [mem 0xc8004000-0xc8004fff] (PCI address [0xc8004000-0xc8004fff]
[    0.704207] pci 0000:06:0b.2: BAR 0: assigned [mem 0xc8005000-0xc8005fff]
[    0.704335] pci 0000:06:0b.2: BAR 0: set to [mem 0xc8005000-0xc8005fff] (PCI address [0xc8005000-0xc8005fff]
[    0.704515] pci 0000:06:0b.1: BAR 0: assigned [mem 0xc8006000-0xc80067ff]
[    0.704644] pci 0000:06:0b.1: BAR 0: set to [mem 0xc8006000-0xc80067ff] (PCI address [0xc8006000-0xc80067ff]
[    0.704823] pci 0000:06:0b.0: BAR 13: assigned [io  0x1000-0x10ff]
[    0.704947] pci 0000:06:0b.0: BAR 14: assigned [io  0x1400-0x14ff]
[    0.705071] pci 0000:06:0b.3: BAR 0: assigned [mem 0xc8006800-0xc80068ff]
[    0.705198] pci 0000:06:0b.3: BAR 0: set to [mem 0xc8006800-0xc80068ff] (PCI address [0xc8006800-0xc80068ff]
[    0.705379] pci 0000:06:0b.0: CardBus bridge to [bus 07-0a]
[    0.705501] pci 0000:06:0b.0:   bridge window [io  0x1000-0x10ff]
[    0.705628] pci 0000:06:0b.0:   bridge window [io  0x1400-0x14ff]
[    0.705755] pci 0000:06:0b.0:   bridge window [mem 0xc0000000-0xc3ffffff pref]
[    0.705944] pci 0000:06:0b.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.706071] pci 0000:00:1e.0: PCI bridge to [bus 06-07]
[    0.706194] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.706321] pci 0000:00:1e.0:   bridge window [mem 0xc4000000-0xc9ffffff]
[    0.706448] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xc3ffffff pref]
[    0.706649] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.706776] pci 0000:00:01.0: setting latency timer to 64
[    0.706909] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.707035] pci 0000:00:1c.0: setting latency timer to 64
[    0.707167] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.707294] pci 0000:00:1c.1: setting latency timer to 64
[    0.707425] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.707551] pci 0000:00:1c.2: setting latency timer to 64
[    0.707680] pci 0000:00:1e.0: setting latency timer to 64
[    0.707813] pci 0000:06:0b.0: enabling device (0000 -> 0003)
[    0.707939] pci 0000:06:0b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.708070] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.708193] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.708317] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.708440] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.708564] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xefffffff]
[    0.708688] pci_bus 0000:00: resource 9 [mem 0xf4000000-0xfebfffff]
[    0.708812] pci_bus 0000:00: resource 10 [mem 0xfec28000-0xfecfffff]
[    0.708936] pci_bus 0000:00: resource 11 [mem 0xfed00500-0xfed13fff]
[    0.709064] pci_bus 0000:00: resource 12 [mem 0xfed1a000-0xfed1bfff]
[    0.709188] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.709312] pci_bus 0000:00: resource 14 [mem 0xfed90000-0xfed9ffff]
[    0.709436] pci_bus 0000:00: resource 15 [mem 0xfedc0000-0xfedfffff]
[    0.709559] pci_bus 0000:00: resource 16 [mem 0xfee01000-0xff9fffff]
[    0.709683] pci_bus 0000:00: resource 17 [mem 0xffc00000-0xffcfffff]
[    0.709809] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.709939] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfdffffff]
[    0.710063] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.710241] pci_bus 0000:02: resource 1 [mem 0xff900000-0xff9fffff]
[    0.710364] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    0.710487] pci_bus 0000:03: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.710611] pci_bus 0000:03: resource 2 [mem 0xca000000-0xca1fffff 64bit pref]
[    0.710789] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.710911] pci_bus 0000:06: resource 1 [mem 0xc4000000-0xc9ffffff]
[    0.711035] pci_bus 0000:06: resource 2 [mem 0xc0000000-0xc3ffffff pref]
[    0.711159] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.711282] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.711405] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.711529] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000dffff]
[    0.711653] pci_bus 0000:06: resource 8 [mem 0xc0000000-0xefffffff]
[    0.711776] pci_bus 0000:06: resource 9 [mem 0xf4000000-0xfebfffff]
[    0.711900] pci_bus 0000:06: resource 10 [mem 0xfec28000-0xfecfffff]
[    0.712024] pci_bus 0000:06: resource 11 [mem 0xfed00500-0xfed13fff]
[    0.712148] pci_bus 0000:06: resource 12 [mem 0xfed1a000-0xfed1bfff]
[    0.712271] pci_bus 0000:06: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.712395] pci_bus 0000:06: resource 14 [mem 0xfed90000-0xfed9ffff]
[    0.712518] pci_bus 0000:06: resource 15 [mem 0xfedc0000-0xfedfffff]
[    0.712641] pci_bus 0000:06: resource 16 [mem 0xfee01000-0xff9fffff]
[    0.712764] pci_bus 0000:06: resource 17 [mem 0xffc00000-0xffcfffff]
[    0.712888] pci_bus 0000:07: resource 0 [io  0x1000-0x10ff]
[    0.713011] pci_bus 0000:07: resource 1 [io  0x1400-0x14ff]
[    0.713134] pci_bus 0000:07: resource 2 [mem 0xc0000000-0xc3ffffff pref]
[    0.713264] pci_bus 0000:07: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.713418] NET: Registered protocol family 2
[    0.713693] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.715129] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.720164] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.720960] TCP: Hash tables configured (established 524288 bind 65536)
[    0.721083] TCP reno registered
[    0.721211] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.721382] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.721640] NET: Registered protocol family 1
[    0.721888] RPC: Registered udp transport module.
[    0.722010] RPC: Registered tcp transport module.
[    0.722131] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.722446] pci 0000:01:00.0: Boot video device
[    0.722588] PCI: CLS 32 bytes, default 64
[    0.722757] Trying to unpack rootfs image as initramfs...
[    0.894047] Freeing initrd memory: 8772k freed
[    0.898858] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.898990] Placing 64MB software IO TLB between ffff88000251b000 - ffff88000651b000
[    0.899167] software IO TLB at phys 0x251b000 - 0x651b000
[    0.899746] Simple Boot Flag value 0xb read from CMOS RAM was invalid
[    0.899875] Simple Boot Flag at 0x7c set to 0x1
[    0.900545] Intel AES-NI instructions are not detected.
[    0.900668] Intel PCLMULQDQ-NI instructions are not detected.
[    0.901306] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.903867] VFS: Disk quotas dquot_6.5.2
[    0.904062] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.904883] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.905439] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.906032] fuse init (API version 7.15)
[    0.906428] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.910052] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    0.910961] SGI XFS Quota Management subsystem
[    0.911379] Btrfs loaded
[    0.911504] msgmni has been set to 7784
[    0.912626] async_tx: api initialized (async)
[    0.912791] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.912973] io scheduler noop registered
[    0.913096] io scheduler deadline registered (default)
[    0.913695] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.915013] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.915137] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.915429] acpiphp: Slot [1] registered
[    0.915649] acpiphp: Slot [1-1] registered
[    0.915830] pci-stub: invalid id string ""
[    0.916199] ACPI: AC Adapter [ADP1] (off-line)
[    0.916470] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.916727] ACPI: Lid Switch [LID]
[    0.916946] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.917133] ACPI: Power Button [PWRB]
[    0.917659] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.917837] ACPI: Power Button [PWRF]
[    0.919120] acpi device:23: registered as cooling_device0
[    0.919393] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:22/LNXVIDEO:00/input/input3
[    0.919576] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
[    0.919902] ACPI: acpi_idle registered with cpuidle
[    0.920144] Marking TSC unstable due to TSC halts in idle
[    0.920359] Switching to clocksource hpet
[    0.922674] thermal LNXTHERM:01: registered as thermal_zone0
[    0.922797] ACPI: Thermal Zone [THRM] (69 C)
[    0.923658] ACPI: Battery Slot [BAT1] (battery present)
[    0.923734] ERST: Table is not found!
[    0.923735] GHES: HEST is not enabled!
[    0.924020] Linux agpgart interface v0.103
[    0.924093] [drm] Initialized drm 1.1.0 20060810
[    0.924304] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    0.924539] nouveau 0000:01:00.0: power state changed by ACPI to D0
[    0.924556] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.924570] nouveau 0000:01:00.0: setting latency timer to 64
[    0.929402] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x086a00a2)
[    0.936663] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    1.025514] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    1.025639] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    1.025761] [drm] nouveau 0000:01:00.0: Bios version 60.86.49.00
[    1.025886] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    1.026009] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    1.026132] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    1.026310] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 010003f3 00010035
[    1.026435] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02811300 00000028
[    1.026557] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02822312 00000030
[    1.026693] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 01833320 00000028
[    1.026817] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 0000000e 00000000
[    1.027015] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[    1.027140] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[    1.027319] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    1.027496] [drm] nouveau 0000:01:00.0:   2: 0x00001255: type 0x55 idx 2 tag 0x07
[    1.027672] [drm] nouveau 0000:01:00.0: unknown type, using 0x31
[    1.027794] [drm] nouveau 0000:01:00.0:   3: 0x00000351: type 0x51 idx 3 tag 0xff
[    1.027970] [drm] nouveau 0000:01:00.0: unknown type, using 0x00
[    1.028095] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC377
[    1.066789] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC6C3
[    1.100014] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD304
[    1.100198] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD3F6
[    1.106752] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD5F0
[    1.106930] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD655
[    1.130017] [drm] nouveau 0000:01:00.0: 0xD655: Condition still not met after 20ms, skipping following opcodes
[    1.130214] [drm] nouveau 0000:01:00.0: BIOS FP mode: 1680x1050 (119880kHz pixel clock)
[    1.130392] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    1.260825] [TTM] Zone  kernel: Available graphics memory: 1992730 kiB.
[    1.260949] [TTM] Initializing pool allocator.
[    1.293214] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    1.917295] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    1.924241] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
[    2.027971] [drm] nouveau 0000:01:00.0: allocated 1680x1050 fb: 0x40230000, bo ffff88013814d000
[    2.028280] fbcon: nouveaufb (fb0) is primary device
[    2.038001] Console: switching to colour frame buffer device 210x65
[    2.041795] fb0: nouveaufb frame buffer device
[    2.041814] drm: registered panic notifier
[    2.041837] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    2.041915] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.062757] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.084039] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.084710] brd: module loaded
[    2.085679] loop: module loaded
[    2.086193] Loading iSCSI transport class v2.0-870.
[    2.086735] iscsi: registered transport (tcp)
[    2.086906] SCSI Media Changer driver v0.25 
[    2.087002] ahci 0000:00:1f.2: version 3.0
[    2.087030] ahci 0000:00:1f.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    2.087088] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.087154] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x3 impl SATA mode
[    2.087165] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    2.087178] ahci 0000:00:1f.2: setting latency timer to 64
[    2.093389] scsi0 : ahci
[    2.093528] scsi1 : ahci
[    2.093650] scsi2 : ahci
[    2.093845] ata1: SATA max UDMA/133 abar m2048@0xffcfd800 port 0xffcfd900 irq 40
[    2.093857] ata2: SATA max UDMA/133 abar m2048@0xffcfd800 port 0xffcfd980 irq 40
[    2.093865] ata3: DUMMY
[    2.093984] ata_piix 0000:00:1f.1: version 2.13
[    2.094000] ata_piix 0000:00:1f.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.094041] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.094119] scsi3 : ata_piix
[    2.094239] scsi4 : ata_piix
[    2.094541] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x9f30 irq 14
[    2.094551] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x9f38 irq 15
[    2.094626] ata5: port disabled. ignoring.
[    2.094739] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    2.094748] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.094799] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    2.094807] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    2.095248] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.096163] e1000e 0000:00:19.0: setting latency timer to 64
[    2.097201] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    2.253703] ata4.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.40, max UDMA/33
[    2.266941] ata4.00: configured for UDMA/33
[    2.388903] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:15:b7:10:1e:f4
[    2.389288] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.390214] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
[    2.391125] CAN device driver interface
[    2.391958] sja1000 CAN netdevice driver
[    2.392827] VMware vmxnet3 virtual NIC driver - version 1.0.14.0-k-NAPI
[    2.393804] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.1.3 (June 24, 2010)
[    2.394634] tun: Universal TUN/TAP device driver, 1.6
[    2.395467] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.396400] console [netcon0] enabled
[    2.397207] netconsole: network logging started
[    2.398149] firewire_ohci 0000:06:0b.1: enabling device (0000 -> 0002)
[    2.398964] firewire_ohci 0000:06:0b.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.413363] ata2: SATA link down (SStatus 0 SControl 300)
[    2.413706] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.415153] ata1.00: unexpected _GTF length (8)
[    2.415771] ata1.00: ATA-8: Hitachi HTS725050A9A364, PC4OC70E, max UDMA/133
[    2.416358] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.418011] ata1.00: unexpected _GTF length (8)
[    2.418653] ata1.00: configured for UDMA/133
[    2.430105] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
[    2.430651] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.430741] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.432326] sd 0:0:0:0: [sda] Write Protect is off
[    2.433156] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.433346] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850S  1.40 PQ: 0 ANSI: 5
[    2.435012] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.439308] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.439674] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.440759] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.441644] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    2.450085] firewire_ohci: Added fw-ohci device 0000:06:0b.1, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    2.450907] aoe: AoE v47 initialised.
[    2.451588] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.452436] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.453409] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.454350] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.455369] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.456314] ehci_hcd 0000:00:1a.7: debug port 1
[    2.458347]  sda: sda1 sda2 sda3 sda4
[    2.459142] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.461156] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.461618] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xffcff800
[    2.473350] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.473947] hub 1-0:1.0: USB hub found
[    2.474758] hub 1-0:1.0: 4 ports detected
[    2.475794] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.476744] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.477706] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.478745] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.479686] ehci_hcd 0000:00:1d.7: debug port 1
[    2.484532] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.485017] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffcff400
[    2.496681] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.497289] hub 2-0:1.0: USB hub found
[    2.498097] hub 2-0:1.0: 6 ports detected
[    2.499137] uhci_hcd: USB Universal Host Controller Interface driver
[    2.500036] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.500977] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.501929] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.502940] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.503878] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bf80
[    2.504961] hub 3-0:1.0: USB hub found
[    2.505703] hub 3-0:1.0: 2 ports detected
[    2.506702] uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
[    2.507581] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.508515] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.509426] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.510414] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.511296] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002000
[    2.512343] hub 4-0:1.0: USB hub found
[    2.513055] hub 4-0:1.0: 2 ports detected
[    2.514025] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.514869] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.515766] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.516736] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.517577] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009fe0
[    2.518590] hub 5-0:1.0: USB hub found
[    2.519301] hub 5-0:1.0: 2 ports detected
[    2.520245] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.521070] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.521941] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.522870] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.523740] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009f80
[    2.524741] hub 6-0:1.0: USB hub found
[    2.525439] hub 6-0:1.0: 2 ports detected
[    2.526334] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.527140] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.527967] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.528853] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.529629] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009f60
[    2.530627] hub 7-0:1.0: USB hub found
[    2.531255] hub 7-0:1.0: 2 ports detected
[    2.532249] usbcore: registered new interface driver wusb-cbaf
[    2.532966] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.538116] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.538481] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.539396] mice: PS/2 mouse device common for all mice
[    2.540372] rtc_cmos 00:08: RTC can wake from S4
[    2.540906] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    2.541685] rtc0: alarms up to one year, 114 bytes nvram, hpet irqs
[    2.542505] i2c /dev entries driver
[    2.543757] lirc_dev: IR Remote Control driver registered, major 249 
[    2.544093] IR LIRC bridge handler initialized
[    2.544910] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    2.545875] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0xd860)
[    2.546648] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.547441] iTCO_vendor_support: vendor-support=0
[    2.548244] md: linear personality registered for level -1
[    2.549105] md: raid0 personality registered for level 0
[    2.549910] md: raid1 personality registered for level 1
[    2.550784] md: raid10 personality registered for level 10
[    2.551583] md: raid6 personality registered for level 6
[    2.552470] md: raid5 personality registered for level 5
[    2.552542] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.554111] md: raid4 personality registered for level 4
[    2.555095] device-mapper: uevent: version 1.0.3
[    2.555867] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    2.556713] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    2.557570] usbcore: registered new interface driver btusb
[    2.558390] EDAC MC: Ver: 2.1.0 Sep 19 2010
[    2.560276] cpuidle: using governor ladder
[    2.561262] cpuidle: using governor menu
[    2.561834] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.563168] usbcore: registered new interface driver hiddev
[    2.563587] usbcore: registered new interface driver usbhid
[    2.564318] usbhid: USB HID core driver
[    2.565614] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    2.566069] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    2.566920] HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    2.567756] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.568665] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    2.569478] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.603076] hda_codec: ALC262: SKU not ready 0x598301f0
[    2.603665] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[    2.611266] ALSA device list:
[    2.611560]   #0: HDA Intel at 0xca200000 irq 42
[    2.612569] oprofile: using NMI interrupt.
[    2.613351] Netfilter messages via NETLINK v0.30.
[    2.614180] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.615367] ctnetlink v0.93: registering with nfnetlink.
[    2.615939] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    2.616820] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    2.618076] xt_time: kernel timezone is -0000
[    2.619171] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.619545] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    2.620432] arp_tables: (C) 2002 David S. Miller
[    2.621329] TCP bic registered
[    2.622207] TCP cubic registered
[    2.623151] TCP westwood registered
[    2.624012] TCP highspeed registered
[    2.624843] TCP hybla registered
[    2.625715] TCP htcp registered
[    2.626571] TCP vegas registered
[    2.627443] TCP veno registered
[    2.628279] TCP scalable registered
[    2.628280] TCP lp registered
[    2.628281] TCP yeah registered
[    2.628283] TCP illinois registered
[    2.628284] Initializing XFRM netlink socket
[    2.632747] NET: Registered protocol family 10
[    2.633674] lo: Disabled Privacy Extensions
[    2.634562] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.634921] IPv6 over IPv4 tunneling driver
[    2.636123] sit0: Disabled Privacy Extensions
[    2.637273] ip6tnl0: Disabled Privacy Extensions
[    2.637862] NET: Registered protocol family 17
[    2.638287] NET: Registered protocol family 15
[    2.639105] Bridge firewalling registered
[    2.639835] Ebtables v2.0 registered
[    2.640659] can: controller area network core (rev 20090105 abi 8)
[    2.641438] NET: Registered protocol family 29
[    2.642213] can: raw protocol (rev 20090105)
[    2.643010] can: broadcast manager protocol (rev 20090105 t)
[    2.644650] IrCOMM protocol (Dag Brattli)
[    2.647627] Bluetooth: L2CAP ver 2.15
[    2.647852] Bluetooth: L2CAP socket layer initialized
[    2.648585] Bluetooth: SCO (Voice Link) ver 0.6
[    2.649322] Bluetooth: SCO socket layer initialized
[    2.650136] Bluetooth: RFCOMM TTY layer initialized
[    2.650802] Bluetooth: RFCOMM socket layer initialized
[    2.651536] Bluetooth: RFCOMM ver 1.11
[    2.652296] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.653011] Bluetooth: BNEP filters: protocol multicast
[    2.653764] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.654648] lec:lane_module_init: lec.c: Sep 19 2010 21:07:27 initialized
[    2.655235] mpoa:atm_mpoa_init: mpc.c: Sep 19 2010 21:07:26 initialized
[    2.655984] L2TP core driver, V2.0
[    2.656893] L2TP IP encapsulation support (L2TPv3)
[    2.657623] L2TP netlink interface
[    2.658244] L2TP ethernet pseudowire support (L2TPv3)
[    2.658992] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.659753] All bugs added by David S. Miller <davem@redhat.com>
[    2.661338] SCTP: Hash tables configured (established 65536 bind 65536)
[    2.662129] lib80211: common routines for IEEE802.11 drivers
[    2.662370] lib80211_crypt: registered algorithm 'NULL'
[    2.663052] Registering the dns_resolver key type
[    2.714970] registered taskstats version 1
[    2.715728] rtc_cmos 00:08: setting system clock to 2010-09-20 17:33:14 UTC (1285003994)
[    2.716033] Freeing unused kernel memory: 1012k freed
[    2.778492] udev: starting version 161
[    2.779161] udevd (1275): /proc/1275/oom_adj is deprecated, please use /proc/1275/oom_score_adj instead.
[    2.869773] sdhci: Secure Digital Host Controller Interface driver
[    2.870204] sdhci: Copyright(c) Pierre Ossman
[    2.870944] yenta_cardbus 0000:06:0b.0: CardBus bridge found [1179:0001]
[    2.871758] yenta_cardbus 0000:06:0b.0: Enabling burst memory read transactions
[    2.872471] yenta_cardbus 0000:06:0b.0: Using CSCINT to route CSC interrupts to PCI
[    2.874381] yenta_cardbus 0000:06:0b.0: Routing CardBus interrupts to PCI
[    2.875519] yenta_cardbus 0000:06:0b.0: TI: mfunc 0x01aa1022, devctl 0x64
[    2.950338] firewire_core: created device fw0: GUID 0000390000875f33, S400
[    3.086707] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    3.104511] yenta_cardbus 0000:06:0b.0: ISA IRQ mask 0x0cf8, PCI irq 20
[    3.104793] yenta_cardbus 0000:06:0b.0: Socket status: 30000410
[    3.105667] pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #07 to #0a
[    3.106579] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [io  0x1000-0x1fff]
[    3.107504] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [mem 0xc4000000-0xc9ffffff]
[    3.108437] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc4000000-0xc9ffffff: excluding 0xc4000000-0xc81fffff
[    3.109392] yenta_cardbus 0000:06:0b.0: pcmcia: parent PCI bridge window: [mem 0xc0000000-0xc3ffffff pref]
[    3.110378] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc0000000-0xc3ffffff: excluding 0xc0000000-0xc3ffffff
[    3.111889] sdhci-pci 0000:06:0b.3: SDHCI controller found [104c:803c] (rev 0)
[    3.112380] sdhci-pci 0000:06:0b.3: enabling device (0000 -> 0002)
[    3.113400] sdhci-pci 0000:06:0b.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.114659] Registered led device: mmc0::
[    3.115596] mmc0: SDHCI controller on PCI [0000:06:0b.3] using DMA
[    3.268784] HID debug: usbhid_probe() -- set intfdata(ffff880137d0ac00, ffff88013a7c0000)
[    3.278462] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input6
[    3.285212] HID debug: hid_connect() -- hid: ffff88013a7c0000
[    3.286141] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input7
[    3.287413] generic-usb 0003:046D:C51B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    3.288338] HID debug: usbhid_probe() -- set intfdata(ffff880137d0a400, ffff880138344000)
[    3.303524] HID debug: hid_connect() -- hid: ffff880138344000
[    3.304424] HID debug: hiddev_connect() -- hid: ffff880138344000, hiddev: ffff880137ce9f00, intf: ffff880137d0a400
[    3.305678] HID debug: hid_connect() -- after hiddev_connect(), hid: ffff880138344000, hiddev: ffff880137ce9f00
[    3.306609] generic-usb 0003:046D:C51B.0002: hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    3.311721] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input8
[    3.344484] dracut: Scanning devices sda4  for LVM volume groups 
[    3.360851] dracut: Reading all physical volumes. This may take a while...
[    3.361541] dracut: Found volume group "Group0" using metadata type lvm2
[    3.385436] dracut: The link /dev/Group0/Root should had been created by udev but it was not found. Falling back to direct link creation.
[    3.386174] dracut: 1 logical volume(s) in volume group "Group0" now active
[    3.536134] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    3.536897] usb 6-1: new full speed USB device using uhci_hcd and address 2
[    3.595345] dracut: Remounting /dev/disk/by-label/Root with -o acl,noatime,ro
[    3.610935] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: acl
[    3.624871] dracut: Mounted root filesystem /dev/mapper/Group0-Root
[    3.708588] dracut: Switching root
[    3.996751] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
[    3.997534] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc8200000-0xc9ffffff: excluding 0xc8f20000-0xc90fffff
[    4.004970] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 20)
[    6.645879] udev: starting version 161
[    7.957525] Detected Toshiba ACPI Bluetooth device - installing RFKill handler
[    7.959411] toshiba_bluetooth: Re-enabling Toshiba Bluetooth
[    8.031570] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    8.037464] input: Toshiba input device as /devices/virtual/input/input9
[    8.037501] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[    8.037503] toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
[    8.045706] Registered led device: toshiba::illumination
[    8.065591] tifm_7xx1 0000:06:0b.2: enabling device (0000 -> 0002)
[    8.065601] tifm_7xx1 0000:06:0b.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    8.224958] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    8.224961] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    8.225054] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.225063] iwlagn 0000:02:00.0: setting latency timer to 64
[    8.225112] iwlagn 0000:02:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[    8.264027] iwlagn 0000:02:00.0: device EEPROM VER=0x36, CALIB=0x5
[    8.264042] iwlagn 0000:02:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[    8.264120] iwlagn 0000:02:00.0: irq 43 for MSI/MSI-X
[    8.430256] iwlagn 0000:02:00.0: loaded firmware version 228.61.2.24
[    8.453852] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    8.610086] usb 6-2: new full speed USB device using uhci_hcd and address 3
[   10.612210] EXT4-fs (dm-0): re-mounted. Opts: acl
[   10.774815] REISERFS (device sda1): found reiserfs format "3.6" with standard journal
[   10.774844] REISERFS (device sda1): using ordered data mode
[   10.775071] REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   10.775501] REISERFS (device sda1): checking transaction log (sda1)
[   10.793259] REISERFS (device sda1): Using r5 hash to sort names
[   11.356047] Adding 4192960k swap on /dev/sda3.  Priority:-1 extents:1 across:4192960k 
[   14.846742] CE: hpet increased min_delta_ns to 7500 nsec
[   22.705849] HID debug: hiddev_open(): hid: ffff88013a7c0000, hiddev: (null), intf: ffff880137d0ac00
[   22.705859] BUG: unable to handle kernel NULL pointer dereference at (null)
[   22.706224] IP: [<ffffffff817d0a77>] hiddev_open+0x157/0x230
[   22.707118] PGD 137b4a067 PUD 137955067 PMD 0 
[   22.708008] Oops: 0000 [#1] PREEMPT SMP 
[   22.708119] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
[   22.708119] CPU 1 
[   22.708119] Modules linked in: tpm_infineon iwlagn iwlcore tifm_7xx1 toshiba_acpi tpm_tis tifm_core toshiba_bluetooth pcmcia sdhci_pci yenta_socket sdhci [last unloaded: scsi_wait_scan]
[   22.708119] 
[   22.708119] Pid: 3126, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00167-gd45c167 #19 Portable PC/TECRA A9
[   22.708119] RIP: 0010:[<ffffffff817d0a77>]  [<ffffffff817d0a77>] hiddev_open+0x157/0x230
[   22.708119] RSP: 0018:ffff880139e69c18  EFLAGS: 00010292
[   22.708119] RAX: 00000000ffffffed RBX: ffff880137d0ac00 RCX: ffffffff820c7de0
[   22.708119] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff820c7cd0
[   22.708119] RBP: ffff880139e69c58 R08: 00000000ffffffff R09: 0000000000000000
[   22.708119] R10: 0000000000000000 R11: 0000000000000002 R12: ffff880137af9600
[   22.708119] R13: ffff880139940000 R14: ffff88013a7c0000 R15: 0000000000000000
[   22.708119] FS:  00007f1c7d9b3700(0000) GS:ffff880002500000(0000) knlGS:0000000000000000
[   22.708119] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.708119] CR2: 0000000000000000 CR3: 000000013784b000 CR4: 00000000000006e0
[   22.708119] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.708119] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   22.708119] Process hald-probe-hidd (pid: 3126, threadinfo ffff880139e68000, task ffff880138efc990)
[   22.708119] Stack:
[   22.708119]  ffff88013ba68000 ffff880139e69fd8 ffff880139e68000 ffff880137af9600
[   22.708119] <0> ffffffff81b57c20 ffffffff81b66420 00000000ffffffed ffff880137affaf0
[   22.708119] <0> ffff880139e69c98 ffffffff8171794b 000000000029d5f6 ffff88013bb46d80
[   22.708119] Call Trace:
[   22.708119]  [<ffffffff8171794b>] usb_open+0x10b/0x2b0
[   22.708119]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
[   22.708119]  [<ffffffff81156c07>] chrdev_open+0x127/0x280
[   22.708119]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
[   22.708119]  [<ffffffff81151508>] __dentry_open+0x108/0x3a0
[   22.708119]  [<ffffffff811518b4>] nameidata_to_filp+0x54/0x70
[   22.708119]  [<ffffffff8115f668>] do_last+0x3b8/0x6c0
[   22.708119]  [<ffffffff811618a8>] do_filp_open+0x228/0x670
[   22.708119]  [<ffffffff81919b45>] ? T.827+0x135/0x230
[   22.708119]  [<ffffffff8116c4aa>] ? alloc_fd+0xfa/0x140
[   22.708119]  [<ffffffff811512c5>] do_sys_open+0x65/0x130
[   22.708119]  [<ffffffff811513d0>] sys_open+0x20/0x30
[   22.708119]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   22.708119] Code: 4c 89 fa 31 c0 4d 89 ac 24 98 00 00 00 48 89 d9 4c 89 f6 48 c7 c7 78 45 d3 81 e8 5c d5 2b 00 49 8b 95 18 c0 00 00 b8 ed ff ff ff <83> 3a 00 0f 84 8a 00 00 00 8b 42 04 8d 48 01 85 c0 89 4a 04 75 
[   22.708119] RIP  [<ffffffff817d0a77>] hiddev_open+0x157/0x230
[   22.708119]  RSP <ffff880139e69c18>
[   22.708119] CR2: 0000000000000000
[   22.751549] ---[ end trace de468cebffa9dc4c ]---
[   28.030347] idr_remove called for id=0 which is not allocated.
[   28.030364] Pid: 3202, comm: X Tainted: G      D     2.6.36-rc4-00167-gd45c167 #19
[   28.030373] Call Trace:
[   28.030384]  [<ffffffff814acbae>] idr_remove+0x7e/0x1f0
[   28.030394]  [<ffffffff8157d88f>] drm_mode_object_put+0x3f/0x60
[   28.030403]  [<ffffffff8157db3a>] drm_mode_destroy+0x1a/0x30
[   28.030413]  [<ffffffff815b8f5e>] nouveau_connector_get_modes+0x3e/0x3a0
[   28.030422]  [<ffffffff815b9e7a>] ? nouveau_connector_detect_lvds+0xea/0x2d0
[   28.030431]  [<ffffffff814ace7f>] ? idr_pre_get+0x5f/0x90
[   28.030441]  [<ffffffff8156cccb>] drm_helper_probe_single_connector_modes+0xdb/0x380
[   28.030451]  [<ffffffff81580aba>] drm_mode_getconnector+0x33a/0x360
[   28.030461]  [<ffffffff81571d1b>] drm_ioctl+0x40b/0x4b0
[   28.030469]  [<ffffffff81124b78>] ? handle_mm_fault+0x198/0xbd0
[   28.030477]  [<ffffffff81580780>] ? drm_mode_getconnector+0x0/0x360
[   28.030487]  [<ffffffff8106552b>] ? do_page_fault+0x19b/0x3e0
[   28.030496]  [<ffffffff81162f8f>] do_vfs_ioctl+0x9f/0x540
[   28.030503]  [<ffffffff8116347f>] sys_ioctl+0x4f/0x80
[   28.030511]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   28.236160] idr_remove called for id=0 which is not allocated.
[   28.236176] Pid: 3202, comm: X Tainted: G      D     2.6.36-rc4-00167-gd45c167 #19
[   28.236186] Call Trace:
[   28.236197]  [<ffffffff814acbae>] idr_remove+0x7e/0x1f0
[   28.236209]  [<ffffffff8157d88f>] drm_mode_object_put+0x3f/0x60
[   28.236217]  [<ffffffff8157db3a>] drm_mode_destroy+0x1a/0x30
[   28.236231]  [<ffffffff815b8f5e>] nouveau_connector_get_modes+0x3e/0x3a0
[   28.236240]  [<ffffffff815b9e7a>] ? nouveau_connector_detect_lvds+0xea/0x2d0
[   28.236252]  [<ffffffff8156cccb>] drm_helper_probe_single_connector_modes+0xdb/0x380
[   28.236265]  [<ffffffff81107571>] ? find_get_page+0x71/0xb0
[   28.236273]  [<ffffffff81580aba>] drm_mode_getconnector+0x33a/0x360
[   28.236282]  [<ffffffff81571d1b>] drm_ioctl+0x40b/0x4b0
[   28.236291]  [<ffffffff81124b78>] ? handle_mm_fault+0x198/0xbd0
[   28.236300]  [<ffffffff81580780>] ? drm_mode_getconnector+0x0/0x360
[   28.236310]  [<ffffffff8106552b>] ? do_page_fault+0x19b/0x3e0
[   28.236319]  [<ffffffff81162f8f>] do_vfs_ioctl+0x9f/0x540
[   28.236327]  [<ffffffff8116347f>] sys_ioctl+0x4f/0x80
[   28.236335]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
[   28.749115] [drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[   28.756128] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
[   33.620853] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   39.163647] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   39.216818] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   39.217350] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   43.701687] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   44.673620] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   44.726766] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   44.727298] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   45.160327] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   51.708434] wlan0: authenticate with 00:0f:66:ea:00:d0 (try 1)
[   51.710333] wlan0: authenticated
[   51.710384] wlan0: associate with 00:0f:66:ea:00:d0 (try 1)
[   51.712789] wlan0: RX AssocResp from 00:0f:66:ea:00:d0 (capab=0x431 status=0 aid=3)
[   51.712802] wlan0: associated
[   51.742505] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   62.270014] wlan0: no IPv6 routers present
[   63.620542] netconsole: local port 6665
[   63.620557] netconsole: local IP 192.168.19.67
[   63.620563] netconsole: interface 'wlan0'
[   63.620568] netconsole: remote port 514
[   63.620573] netconsole: remote IP 192.168.19.2
[   63.620651] netconsole: remote ethernet address 00:23:54:94:80:7c
[   63.620676] netconsole: wlan0 doesn't support polling, aborting.
[   67.948274] ata1.00: configured for UDMA/133
[   67.948289] ata1: EH complete
[   69.055320] EXT4-fs (dm-0): re-mounted. Opts: acl,commit=0
[   89.232824] idr_remove called for id=0 which is not allocated.
[   89.233882] Pid: 3202, comm: X Tainted: G      D     2.6.36-rc4-00167-gd45c167 #19
[   89.234873] Call Trace:
[   89.235864]  [<ffffffff814acbae>] idr_remove+0x7e/0x1f0
[   89.236850]  [<ffffffff8157d88f>] drm_mode_object_put+0x3f/0x60
[   89.237865]  [<ffffffff8157db3a>] drm_mode_destroy+0x1a/0x30
[   89.238832]  [<ffffffff815b8f5e>] nouveau_connector_get_modes+0x3e/0x3a0
[   89.239835]  [<ffffffff815b9e7a>] ? nouveau_connector_detect_lvds+0xea/0x2d0
[   89.240850]  [<ffffffff8156cccb>] drm_helper_probe_single_connector_modes+0xdb/0x380
[   89.241840]  [<ffffffff81107571>] ? find_get_page+0x71/0xb0
[   89.242829]  [<ffffffff81580aba>] drm_mode_getconnector+0x33a/0x360
[   89.243844]  [<ffffffff810690f4>] ? ptep_set_access_flags+0x34/0x40
[   89.244848]  [<ffffffff81571d1b>] drm_ioctl+0x40b/0x4b0
[   89.245863]  [<ffffffff81124f9b>] ? handle_mm_fault+0x5bb/0xbd0
[   89.246871]  [<ffffffff81580780>] ? drm_mode_getconnector+0x0/0x360
[   89.247864]  [<ffffffff8106552b>] ? do_page_fault+0x19b/0x3e0
[   89.248885]  [<ffffffff81162f8f>] do_vfs_ioctl+0x9f/0x540
[   89.249887]  [<ffffffff8116347f>] sys_ioctl+0x4f/0x80
[   89.250935]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b

--------------030309090103050309000404--
