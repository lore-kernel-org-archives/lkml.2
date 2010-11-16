Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab0KPWCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:02:54 -0500
Received: from sunjammer.sugarlabs.org ([140.186.70.53]:51140 "EHLO
	sunjammer.sugarlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab0KPWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:02:50 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2010 17:02:49 EST
Subject: Re: pc300too on a modern kernel?
From: Bernie Innocenti <bernie@codewiz.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Ward Vandewege <ward@gnu.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <m3sjz34mka.fsf@intrepid.localdomain>
References: <20100902131531.GA19028@countzero.vandewege.net>
	 <m3mxrw1lg0.fsf@intrepid.localdomain>
	 <1289421869.9336.49.camel@giskard.codewiz.org>
	 <m3sjz34mka.fsf@intrepid.localdomain>
Content-Type: multipart/mixed; boundary="=-jgcCTJp9Xl8Eh3JxyeXW"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Tue, 16 Nov 2010 16:56:59 -0500
Message-ID: <1289944619.2677.22.camel@giskard.codewiz.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jgcCTJp9Xl8Eh3JxyeXW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[cc += lkml]

On Sun, 2010-11-14 at 22:33 +0100, Krzysztof Halasa wrote:
> Well... could be a hardware problem. I'd make sure the card sits well in
> the PCI slot.

Nope, the card works perfectly in the old box and the bug triggers in
any PCI slot of the new box (running the new kernel with the pc300too
driver).


> Also... it's rather improbable, but I'd look at the SCA-II chip. There
> were certain chips with a hardware bug which could cause such problems.
> Chips with Hitachi logo and "R" letter after the lot code were ok, and
> all later chips made by Renesas (either missing any logo or with
> Renesas' - no "R" letter there) were ok.
> 
> The faulty chips were marked with Hitachi logo and were missing the "R"
> letter after the lot code. I think Hitachi fixed it in 1999 or so.
> I'm not sure if this bug could manifest itself when only one SCA channel
> was in use. The app note doesn't say a word about it, but I think I only
> experienced the problem (with an older card, not PC300) when both
> channels were simultaneously in use.

Looks like we've hit this bug! Here's a photo of the board to confirm
it's the bogus chip:

 http://people.sugarlabs.org/bernie/pc300too-photo.jpg


> It could also be some PLX PCI9050 oddity. Can you show me output of
> "lspci -vv" command (may be limited to the PC300 device)?

Attached as pc300too-lspci.out

> Also, please say something about the machine (CPU, motherboard). What
> speed are you trying to use it with?

Attached as pc300too-dmidecode.out

The most interesting thing is probably the dmesg output:


[   59.175900] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[   59.176639] bernie: cp=3b4, bp=1ef18, len=56, unused=12
[   67.159314] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   67.163214] bernie: cp=39c, bp=1e298, len=56, unused=12
[   68.425601] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   68.426123] bernie: cp=39c, bp=1e298, len=77, unused=12
[   70.312068] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[   70.314393] bernie: cp=3c0, bp=1f558, len=1504, unused=12

So it seems that sometimes the controller doesn't always clear the EOM
(0x80) status bit after transmitting a frame. Size and contents of the
packet doesn't seem to matter We're using a single T1 channel.

To obtain this debug output, I modified the driver as follows:

--- linux-2.6.36.orig/drivers/net/wan/hd64572.c	2010-10-20 16:30:22.000000000 -0400
+++ linux-2.6.36/drivers/net/wan/hd64572.c	2010-11-12 20:48:03.000000000 -0500
@@ -567,11 +567,20 @@ static netdev_tx_t sca_xmit(struct sk_bu
 	card_t *card = port->card;
 	pkt_desc __iomem *desc;
 	u32 buff, len;
+	uint8_t stat;
 
 	spin_lock_irq(&port->lock);
 
 	desc = desc_address(port, port->txin + 1, 1);
-	BUG_ON(readb(&desc->stat)); /* previous xmit should stop queue */
+
+	//BUG_ON(readb(&desc->stat)); /* previous xmit should stop queue */
+	stat = readb(&desc->stat); /* previous xmit should stop queue */
+	if (stat) {
+		printk(KERN_EMERG "bernie: stat=0x%02x, desc_address=%p, port->chan=%d\n", stat, desc, port->chan);
+		printk(KERN_EMERG "bernie: cp=%x, bp=%x, len=%d, unused=%x\n", readw(&desc->cp), readl(&desc->bp), readw(&desc->len), readb(&desc->unused));
+		printk(KERN_EMERG "bernie: %s TX(%i):", dev->name, skb->len);
+		debug_frame(skb);
+	}
 
 #ifdef DEBUG_PKT
 	printk(KERN_DEBUG "%s TX(%i):", dev->name, skb->len);


With this patch applied, our system doesn't crash any more and
communication works both ways with negligible packet loss.

Shall we submit a patch lowering the BUG_ON() to a KERN_ERR to report
the problem only once?

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

--=-jgcCTJp9Xl8Eh3JxyeXW
Content-Disposition: attachment; filename="pc300too-dmesg.out"
Content-Type: text/plain; name="pc300too-dmesg.out"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36 (root@newvalis.gnu.org) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Mon Nov 8 20:40:14 EST 2010
[    0.000000] Command line: root=/dev/md0 ro console=tty0 console=ttyS0,115200n8 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000098400 (usable)
[    0.000000]  BIOS-e820: 0000000000098400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000008fd81000 (usable)
[    0.000000]  BIOS-e820: 000000008fde0000 - 000000008fde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008fde3000 - 000000008fdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000008fdf0000 - 000000008fe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x150000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFF0000000 write-back
[    0.000000]   2 base 00008FE00000 mask FFFFFFE00000 uncachable
[    0.000000]   3 base 000100000000 mask FFFFC0000000 write-back
[    0.000000]   4 base 000140000000 mask FFFFF0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000150000000 aka 5376M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000008fe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x8fd81 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f59c0] f59c0
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-000000008fd81000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 008fc00000 page 2M
[    0.000000]  008fc00000 - 008fd81000 page 4k
[    0.000000] kernel direct mapping tables up to 8fd81000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000150000000
[    0.000000]  0100000000 - 0140000000 page 1G
[    0.000000]  0140000000 - 0150000000 page 2M
[    0.000000] kernel direct mapping tables up to 150000000 @ a000-c000
[    0.000000] RAMDISK: 378c1000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7360 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 000000008fde3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 000000008fde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 000000008fde30c0 0747E (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 000000008fde0000 00040
[    0.000000] ACPI: SSDT 000000008fdea600 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 000000008fdeaec0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 000000008fdeaf00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 000000008fdeaf40 0032A (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 000000008fdea540 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000150000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000150000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00049fffff] PMD -> [ffff880100200000-ffff8801033fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00150000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000098
[    0.000000]     0: 0x00000100 -> 0x0008fd81
[    0.000000]     0: 0x00100000 -> 0x00150000
[    0.000000] On node 0 totalpages: 916760
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3935 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 570809 pages, LIFO batch:31
[    0.000000]   Normal zone: 4480 pages used for memmap
[    0.000000]   Normal zone: 323200 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] PM: Registered nosave memory: 0000000000098000 - 0000000000099000
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000008fd81000 - 000000008fde0000
[    0.000000] PM: Registered nosave memory: 000000008fde0000 - 000000008fde3000
[    0.000000] PM: Registered nosave memory: 000000008fde3000 - 000000008fdf0000
[    0.000000] PM: Registered nosave memory: 000000008fdf0000 - 000000008fe00000
[    0.000000] PM: Registered nosave memory: 000000008fe00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 8fe00000 (gap: 8fe00000:50200000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001800000 s78976 r8192 d23424 u524288
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 897944
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md0 ro console=tty0 console=ttyS0,115200n8 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 14000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] early_res array is doubled to 128 at [b000 - bfff]
[    0.000000] Subtract (58 early reservations)
[    0.000000]   #1 [0001000000 - 00015dcba0]   TEXT DATA BSS
[    0.000000]   #2 [00378c1000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [00015dd000 - 00015dd106]             BRK
[    0.000000]   #4 [00000f59d0 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f59c0 - 00000f59d0]    MP-table mpf
[    0.000000]   #6 [0000098400 - 00000f1100]   BIOS reserved
[    0.000000]   #7 [00000f129c - 00000f59c0]   BIOS reserved
[    0.000000]   #8 [00000f1100 - 00000f129c]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 000000a000]         PGTABLE
[    0.000000]   #12 [000000a000 - 000000b000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [00015dd140 - 00015de140]         BOOTMEM
[    0.000000]   #15 [00015dcbc0 - 00015dce60]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0103400000]        MEMMAP 0
[    0.000000]   #19 [00015dce80 - 00015dd000]         BOOTMEM
[    0.000000]   #20 [00015de140 - 00015f6140]         BOOTMEM
[    0.000000]   #21 [00015f6140 - 0001602140]         BOOTMEM
[    0.000000]   #22 [0001603000 - 0001604000]         BOOTMEM
[    0.000000]   #23 [0001602140 - 0001602181]         BOOTMEM
[    0.000000]   #24 [00016021c0 - 0001602203]         BOOTMEM
[    0.000000]   #25 [0001602240 - 00016024a8]         BOOTMEM
[    0.000000]   #26 [00016024c0 - 0001602528]         BOOTMEM
[    0.000000]   #27 [0001602540 - 00016025a8]         BOOTMEM
[    0.000000]   #28 [00016025c0 - 0001602628]         BOOTMEM
[    0.000000]   #29 [0001602640 - 00016026a8]         BOOTMEM
[    0.000000]   #30 [00016026c0 - 0001602728]         BOOTMEM
[    0.000000]   #31 [0001602740 - 00016027a8]         BOOTMEM
[    0.000000]   #32 [00016027c0 - 0001602828]         BOOTMEM
[    0.000000]   #33 [0001602840 - 00016028a8]         BOOTMEM
[    0.000000]   #34 [00016028c0 - 0001602928]         BOOTMEM
[    0.000000]   #35 [0001602940 - 00016029a8]         BOOTMEM
[    0.000000]   #36 [00016029c0 - 00016029e0]         BOOTMEM
[    0.000000]   #37 [0001602a00 - 0001602a20]         BOOTMEM
[    0.000000]   #38 [0001602a40 - 0001602a76]         BOOTMEM
[    0.000000]   #39 [0001602a80 - 0001602ab6]         BOOTMEM
[    0.000000]   #40 [0001800000 - 000181b000]         BOOTMEM
[    0.000000]   #41 [0001880000 - 000189b000]         BOOTMEM
[    0.000000]   #42 [0001900000 - 000191b000]         BOOTMEM
[    0.000000]   #43 [0001980000 - 000199b000]         BOOTMEM
[    0.000000]   #44 [0001602ac0 - 0001602ac8]         BOOTMEM
[    0.000000]   #45 [0001602b00 - 0001602b08]         BOOTMEM
[    0.000000]   #46 [0001602b40 - 0001602b50]         BOOTMEM
[    0.000000]   #47 [0001602b80 - 0001602ba0]         BOOTMEM
[    0.000000]   #48 [0001602bc0 - 0001602cf0]         BOOTMEM
[    0.000000]   #49 [0001602d00 - 0001602d50]         BOOTMEM
[    0.000000]   #50 [0001602d80 - 0001602dd0]         BOOTMEM
[    0.000000]   #51 [0001604000 - 000160c000]         BOOTMEM
[    0.000000]   #52 [0020000000 - 0024000000]         BOOTMEM
[    0.000000]   #53 [0001602e00 - 0001602e20]         BOOTMEM
[    0.000000]   #54 [000199b000 - 000599b000]         BOOTMEM
[    0.000000]   #55 [000160c000 - 000162c000]         BOOTMEM
[    0.000000]   #56 [000162c000 - 000166c000]         BOOTMEM
[    0.000000]   #57 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3470308k/5505024k available (2811k kernel code, 1837984k absent, 196732k reserved, 1719k data, 608k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2310.063 MHz processor.
[    0.016005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4620.12 BogoMIPS (lpj=9240240)
[    0.024003] pid_max: default: 32768 minimum: 301
[    0.028037] Security Framework initialized
[    0.032004] SELinux:  Disabled at boot.
[    0.036372] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.044010] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.048648] Mount-cache hash table entries: 256
[    0.052110] Initializing cgroup subsys ns
[    0.056004] Initializing cgroup subsys cpuacct
[    0.060004] Initializing cgroup subsys devices
[    0.064025] tseg: 008fe00000
[    0.064027] CPU: Physical Processor ID: 0
[    0.068002] CPU: Processor Core ID: 0
[    0.072003] mce: CPU supports 6 MCE banks
[    0.076008] Performance Events: AMD PMU driver.
[    0.081524] ... version:                0
[    0.084002] ... bit width:              48
[    0.088002] ... generic registers:      4
[    0.092002] ... value mask:             0000ffffffffffff
[    0.096002] ... max period:             00007fffffffffff
[    0.100002] ... fixed-purpose events:   0
[    0.104002] ... event mask:             000000000000000f
[    0.108643] ACPI: Core revision 20100702
[    0.124061] Setting APIC routing to flat
[    0.128495] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.173697] CPU0: AMD Athlon(tm) II X4 605e Processor stepping 02
[    0.180000] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.456006] Brought up 4 CPUs
[    0.459006] Total of 4 processors activated (18482.86 BogoMIPS).
[    0.460405] NET: Registered protocol family 16
[    0.464039] node 0 link 0: io port [c000, ffff]
[    0.464039] TOM: 00000000b0000000 aka 2816M
[    0.468002] Fam 10h mmconf [e0000000, e00fffff]
[    0.468004] node 0 link 0: mmio [a0000, bffff]
[    0.468007] node 0 link 0: mmio [b0000000, dfffffff]
[    0.468009] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.468011] node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
[    0.468015] TOM2: 0000000150000000 aka 5376M
[    0.472002] bus: [00, 03] on node 0 link 0
[    0.472004] bus: 00 index 0 [io  0x0000-0xffff]
[    0.472007] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.472008] bus: 00 index 2 [mem 0xb0000000-0xdfffffff]
[    0.472010] bus: 00 index 3 [mem 0xe0400000-0xffffffff]
[    0.472012] bus: 00 index 4 [mem 0xe0100000-0xe03fffff]
[    0.472014] bus: 00 index 5 [mem 0x150000000-0xfcffffffff]
[    0.472044] ACPI: bus type pci registered
[    0.476040] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.488003] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.519273] PCI: Using configuration type 1 for base access
[    0.524052] bio: create slab <bio-0> at 0
[    0.528548] ACPI: EC: Look up EC in DSDT
[    0.538213] ACPI: Interpreter enabled
[    0.540003] ACPI: (supports S0 S3 S4 S5)
[    0.545257] ACPI: Using IOAPIC for interrupt routing
[    0.556116] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.564096] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.572166] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.576002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.584002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.592002] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.600002] pci_root PNP0A03:00: host bridge window [mem 0xaff00000-0xfebfffff]
[    0.604020] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.604103] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.604106] pci 0000:00:0a.0: PME# disabled
[    0.604147] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.604157] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.604166] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.604176] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.604185] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.604195] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.604249] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.604320] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.604403] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.604470] pci 0000:00:12.2: supports D1 D2
[    0.604472] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.604476] pci 0000:00:12.2: PME# disabled
[    0.604507] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.608074] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.608156] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.608223] pci 0000:00:13.2: supports D1 D2
[    0.608225] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.608229] pci 0000:00:13.2: PME# disabled
[    0.608352] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.608362] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.608371] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.608380] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.608389] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.608456] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.608511] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.608515] pci 0000:00:14.2: PME# disabled
[    0.608645] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.608791] pci 0000:01:05.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
[    0.608795] pci 0000:01:05.0: reg 14: [io  0xee00-0xeeff]
[    0.608800] pci 0000:01:05.0: reg 18: [mem 0xfdfe0000-0xfdfeffff]
[    0.608809] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.608820] pci 0000:01:05.0: supports D1 D2
[    0.608835] pci 0000:01:05.1: reg 10: [mem 0xfdffc000-0xfdffffff]
[    0.608857] pci 0000:01:05.1: supports D1 D2
[    0.608893] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.612003] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.612006] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.612009] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.612052] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
[    0.612071] pci 0000:02:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
[    0.612084] pci 0000:02:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
[    0.612094] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.612121] pci 0000:02:00.0: supports D1 D2
[    0.612123] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.612127] pci 0000:02:00.0: PME# disabled
[    0.620035] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.624005] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.624008] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.624012] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.624066] pci 0000:03:06.0: reg 10: [io  0xcf00-0xcf3f]
[    0.624127] pci 0000:03:06.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.624164] pci 0000:03:07.0: reg 10: [mem 0xcffff000-0xcffff07f]
[    0.624177] pci 0000:03:07.0: reg 14: [io  0xce00-0xce7f]
[    0.624189] pci 0000:03:07.0: reg 18: [mem 0xcfffe000-0xcfffe3ff]
[    0.624202] pci 0000:03:07.0: reg 1c: [mem 0xfdc80000-0xfdcfffff pref]
[    0.624225] pci 0000:03:07.0: reg 24: [mem 0xcfffd000-0xcfffd0ff]
[    0.624289] pci 0000:03:0e.0: reg 10: [mem 0xcfffc000-0xcfffc7ff]
[    0.624302] pci 0000:03:0e.0: reg 14: [mem 0xcfff8000-0xcfffbfff]
[    0.624379] pci 0000:03:0e.0: supports D1 D2
[    0.624381] pci 0000:03:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.624386] pci 0000:03:0e.0: PME# disabled
[    0.624419] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.632004] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.632008] pci 0000:00:14.4:   bridge window [mem 0xb0000000-0xcfffffff]
[    0.632013] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    0.632015] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.632018] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.632020] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.632023] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.632026] pci 0000:00:14.4:   bridge window [mem 0xaff00000-0xfebfffff] (subtractive decode)
[    0.632040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.632348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.632439] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.632482] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.648681] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.657277] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.665275] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.673277] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.681278] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.689273] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.697274] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.705278] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.713255] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.720004] vgaarb: loaded
[    0.724037] usbcore: registered new interface driver usbfs
[    0.728038] usbcore: registered new interface driver hub
[    0.732038] usbcore: registered new device driver usb
[    0.740038] PCI: Using ACPI for IRQ routing
[    0.744003] PCI: pci_cache_line_size set to 64 bytes
[    0.744010] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.752077] reserve RAM buffer: 0000000000098400 - 000000000009ffff 
[    0.752079] reserve RAM buffer: 000000008fd81000 - 000000008fffffff 
[    0.752101] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.757361] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.766036] Switching to clocksource tsc
[    0.768938] pnp: PnP ACPI init
[    0.772036] ACPI: bus type pnp registered
[    0.776768] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.789423] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.802746] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:06.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.818038] pnp 00:0d: disabling [mem 0x000d4400-0x000d7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.830061] pnp 00:0d: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.842084] pnp 00:0d: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.854106] pnp 00:0d: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.866131] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.878154] pnp 00:0d: disabling [mem 0x00100000-0x8fddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.890323] pnp: PnP ACPI: found 14 devices
[    0.894543] ACPI: ACPI bus type pnp unregistered
[    0.899194] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.905145] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.911092] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.917041] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.922994] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.928939] system 00:02: [io  0x040b] has been reserved
[    0.934280] system 00:02: [io  0x04d6] has been reserved
[    0.939618] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.945566] system 00:02: [io  0x0c14] has been reserved
[    0.950905] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.956854] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.962800] system 00:02: [io  0x0c6f] has been reserved
[    0.968140] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.974088] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.980041] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.985988] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.991936] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.997883] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    1.003837] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    1.009784] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    1.015738] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    1.022995] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.029639] system 00:0d: [mem 0x8fde0000-0x8fdfffff] could not be reserved
[    1.036631] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
[    1.043273] system 00:0d: [mem 0x8fef0000-0xafeeffff] could not be reserved
[    1.050258] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.057247] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
[    1.064243] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
[    1.078044] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.083303] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.089426] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    1.096246] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.104019] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
[    1.111270] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    1.116531] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    1.122652] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    1.129466] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    1.137245] pci 0000:03:06.0: BAR 6: assigned [mem 0xfdc00000-0xfdc0ffff pref]
[    1.144499] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    1.149759] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    1.155888] pci 0000:00:14.4:   bridge window [mem 0xb0000000-0xcfffffff]
[    1.162711] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    1.169984] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.176719] pci 0000:00:0a.0: setting latency timer to 64
[    1.176727] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.176729] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.176731] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.176733] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    1.176736] pci_bus 0000:00: resource 8 [mem 0xaff00000-0xfebfffff]
[    1.176738] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    1.176740] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    1.176743] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.176745] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    1.176748] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    1.176750] pci_bus 0000:02: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    1.176752] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    1.176755] pci_bus 0000:03: resource 1 [mem 0xb0000000-0xcfffffff]
[    1.176757] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff pref]
[    1.176759] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    1.176761] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    1.176763] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    1.176766] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    1.176768] pci_bus 0000:03: resource 8 [mem 0xaff00000-0xfebfffff]
[    1.176845] NET: Registered protocol family 2
[    1.181393] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.189919] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.199981] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.207019] TCP: Hash tables configured (established 524288 bind 65536)
[    1.213668] TCP reno registered
[    1.216859] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.222925] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.229537] NET: Registered protocol family 1
[    1.233942] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    1.380053] pci 0000:01:05.0: Boot video device
[    1.380069] PCI: CLS 4 bytes, default 64
[    1.380114] Trying to unpack rootfs image as initramfs...
[    1.533921] Freeing initrd memory: 7356k freed
[    1.541095] PCI-DMA: Disabling AGP.
[    1.544806] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    1.550422] PCI-DMA: using GART IOMMU.
[    1.554207] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.564867] audit: initializing netlink socket (disabled)
[    1.570315] type=2000 audit(1289958061.568:1): initialized
[    1.576099] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.582687] VFS: Disk quotas dquot_6.5.2
[    1.586685] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.593223] msgmni has been set to 6921
[    1.597325] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.604766] io scheduler noop registered
[    1.608722] io scheduler deadline registered
[    1.614324] io scheduler cfq registered (default)
[    1.619930] Linux agpgart interface v0.103
[    1.624075] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.650900] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.677736] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.684940] brd: module loaded
[    1.688237] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.694453] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.704320] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.709515] mice: PS/2 mouse device common for all mice
[    1.714885] rtc_cmos 00:05: RTC can wake from S4
[    1.719648] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.725809] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.732264] cpuidle: using governor ladder
[    1.736397] cpuidle: using governor menu
[    1.740565] TCP cubic registered
[    1.742773] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.750385] NET: Registered protocol family 17
[    1.754867] Registering the dns_resolver key type
[    1.759787] registered taskstats version 1
[    1.764206] rtc_cmos 00:05: setting system clock to 2010-11-17 01:41:03 UTC (1289958063)
[    1.772481] Freeing unused kernel memory: 608k freed
[    1.858877] udevd (521): /proc/521/oom_adj is deprecated, please use /proc/521/oom_score_adj instead.
[    2.046448] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.052474] Floppy drive(s): fd0 is 1.44M
[    2.070120] SCSI subsystem initialized
[    2.075593] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.081004] FDC 0 is a post-1991 82077
[    2.086187] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    2.113258] Uniform Multi-Platform E-IDE driver
[    2.133777] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.139570] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.146680] r8169 0000:02:00.0: setting latency timer to 64
[    2.146717] r8169 0000:02:00.0: irq 40 for MSI/MSI-X
[    2.146913] r8169 0000:02:00.0: eth0: RTL8168c/8111c at 0xffffc9000067e000, 6c:f0:49:7a:b7:cc, XID 1c4000c0 IRQ 40
[    2.160721] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.168187] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.171423] libata version 3.00 loaded.
[    2.173604] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 1
[    2.181195] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    2.189726] 3c59x 0000:03:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.196769] 3c59x: Donald Becker and others.
[    2.201143] 0000:03:06.0: 3Com PCI 3c905 Boomerang 100baseTx at 000000000001cf00.
[    2.231351] ohci1394 0000:03:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.244050] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.251033] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.258418] usb usb1: Product: OHCI Host Controller
[    2.263425] usb usb1: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.268930] usb usb1: SerialNumber: 0000:00:12.0
[    2.273740] hub 1-0:1.0: USB hub found
[    2.277604] hub 1-0:1.0: 3 ports detected
[    2.281856] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.289177] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    2.294569] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 2
[    2.302150] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    2.307991] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[cfffc000-cfffc7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    2.364034] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.370982] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.378421] usb usb2: Product: OHCI Host Controller
[    2.383385] usb usb2: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.388946] usb usb2: SerialNumber: 0000:00:12.1
[    2.393768] hub 2-0:1.0: USB hub found
[    2.397605] hub 2-0:1.0: 3 ports detected
[    2.401888] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.409238] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.414624] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 3
[    2.422245] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    2.488027] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.494996] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.502410] usb usb3: Product: OHCI Host Controller
[    2.507427] usb usb3: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.512926] usb usb3: SerialNumber: 0000:00:13.0
[    2.517758] hub 3-0:1.0: USB hub found
[    2.521610] hub 3-0:1.0: 3 ports detected
[    2.525854] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.533156] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    2.538538] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 4
[    2.546123] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    2.608026] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.614986] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.622383] usb usb4: Product: OHCI Host Controller
[    2.627401] usb usb4: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.632978] usb usb4: SerialNumber: 0000:00:13.1
[    2.637825] hub 4-0:1.0: USB hub found
[    2.641637] hub 4-0:1.0: 3 ports detected
[    2.645934] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.653267] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.658685] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 5
[    2.666289] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    2.732026] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.739001] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.746453] usb usb5: Product: OHCI Host Controller
[    2.751428] usb usb5: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.756917] usb usb5: SerialNumber: 0000:00:14.5
[    2.761777] hub 5-0:1.0: USB hub found
[    2.765660] hub 5-0:1.0: 2 ports detected
[    2.769940] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.777481] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.782937] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 6
[    2.790625] ehci_hcd 0000:00:12.2: debug port 1
[    2.795397] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    2.812054] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.817997] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    2.824952] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.832329] usb usb6: Product: EHCI Host Controller
[    2.837318] usb usb6: Manufacturer: Linux 2.6.36 ehci_hcd
[    2.842866] usb usb6: SerialNumber: 0000:00:12.2
[    2.847701] hub 6-0:1.0: USB hub found
[    2.851548] hub 6-0:1.0: 6 ports detected
[    2.855849] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.863217] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.868592] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 7
[    2.876211] ehci_hcd 0000:00:13.2: debug port 1
[    2.880937] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    2.896056] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.901958] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    2.908917] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.916285] usb usb7: Product: EHCI Host Controller
[    2.921301] usb usb7: Manufacturer: Linux 2.6.36 ehci_hcd
[    2.926796] usb usb7: SerialNumber: 0000:00:13.2
[    2.931614] hub 7-0:1.0: USB hub found
[    2.935477] hub 7-0:1.0: 6 ports detected
[    2.939772] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    2.946832] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.954398] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    2.961624]     ide0: BM-DMA at 0xfa00-0xfa07
[    2.966114] atiixp 0000:00:14.1: simplex device: DMA disabled
[    2.971979] ide1: DMA disabled
[    2.975151] Probing IDE interface ide0...
[    3.544078] Probing IDE interface ide1...
[    3.588179] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[003a0966006cf049]
[    4.104102] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.108841] ide1 at 0x170-0x177,0x376 on irq 15
[    4.113668] ahci 0000:00:11.0: version 3.0
[    4.113683] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.120801] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.129152] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    4.138018] scsi0 : ahci
[    4.140802] scsi1 : ahci
[    4.143525] scsi2 : ahci
[    4.146219] scsi3 : ahci
[    4.148946] scsi4 : ahci
[    4.151632] scsi5 : ahci
[    4.154358] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    4.161893] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    4.169449] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    4.177010] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    4.184559] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    4.192102] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    4.516078] ata4: SATA link down (SStatus 0 SControl 300)
[    4.516142] ata3: SATA link down (SStatus 0 SControl 300)
[    4.516186] ata5: SATA link down (SStatus 0 SControl 300)
[    4.516227] ata6: SATA link down (SStatus 0 SControl 300)
[    4.688060] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.688560] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.688820] ata2.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102HD, max UDMA/133
[    4.688824] ata2.00: 78165360 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.689080] ata2.00: configured for UDMA/133
[    4.720185] ata1.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102HD, max UDMA/133
[    4.727069] ata1.00: 78165360 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.734042] ata1.00: configured for UDMA/133
[    4.752187] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 2CV1 PQ: 0 ANSI: 5
[    4.760699] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 2CV1 PQ: 0 ANSI: 5
[    4.782669] sd 1:0:0:0: [sdb] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    4.782674] sd 0:0:0:0: [sda] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    4.782746] sd 0:0:0:0: [sda] Write Protect is off
[    4.782749] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.782774] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.783154]  sda: sda1 sda2
[    4.815336] sd 1:0:0:0: [sdb] Write Protect is off
[    4.815396] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.824977] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.825040] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.834662]  sdb: sdb1 sdb2
[    4.837887] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.932765] md: raid1 personality registered for level 1
[    4.944673] md: md0 stopped.
[    4.953404] md: bind<sdb1>
[    4.956419] md: bind<sda1>
[    4.967540] md/raid1:md0: active with 2 out of 2 mirrors
[    4.973014] md0: detected capacity change from 0 to 35998597120
[    4.979233] md: md1 stopped.
[    4.981142]  md0: unknown partition table
[    5.023019] EXT3-fs: barriers not enabled
[    5.027421] kjournald starting.  Commit interval 5 seconds
[    5.027455] EXT3-fs (md0): mounted filesystem with writeback data mode
[    5.250966] udevd version 125 started
[    5.524398] input: PC Speaker as /class/input/input1
[    5.605992] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.618541] ACPI: acpi_idle registered with cpuidle
[    5.629723] input: Power Button as /class/input/input2
[    5.635078] ACPI: Power Button [PWRB]
[    5.637239] ACPI: WMI: Mapper loaded
[    5.642615] input: Power Button as /class/input/input3
[    5.647867] ACPI: Power Button [PWRF]
[    5.688020] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f]
[    5.698920] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.732031] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602 ss_vid 1022 ss_did 9602
[    5.740442] shpchp 0000:00:01.0: Cannot reserve MMIO region
[    5.768022] shpchp 0000:00:0a.0: HPC vendor_id 1022 device_id 9609 ss_vid 1022 ss_did 9601
[    5.776395] shpchp 0000:00:0a.0: Cannot reserve MMIO region
[    5.782109] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.853688] parport_pc 00:0a: reported by Plug and Play ACPI
[    5.859591] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    5.873870] Error: Driver 'pcspkr' is already registered, aborting...
[    5.960033] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.997815] HDLC support module revision 1.22
[    6.040078] PC300 0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.201322] pc300: PC300/RSV, 256 KB RAM at 0xfdc80000, IRQ21, using 10 TX + 71 RX packets rings
[    6.210649] hdlc0: PC300 channel 0
[    6.214407] hdlc1: PC300 channel 1
[    6.261377] hda_codec: ALC889A: BIOS auto-probing.
[    6.272233] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.279685] HDA Intel 0000:01:05.1: setting latency timer to 64
[    6.986897] EXT3-fs (md0): using internal journal
[    8.015522] loop: module loaded
[    8.052997] md: md1 stopped.
[    8.072959] md: bind<sdb2>
[    8.102415] md/raid1:md1: active with 1 out of 2 mirrors
[    8.107893] md1: detected capacity change from 0 to 4016177152
[    8.114443]  md1: unknown partition table
[    8.169943] Adding 3922044k swap on /dev/md1.  Priority:-1 extents:1 across:3922044k 
[    8.275781] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.295476] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.401941] r8169 0000:02:00.0: eth0: link up
[    8.405942] r8169 0000:02:00.0: eth0: link up
[    8.448733] eth1:  setting full-duplex.
[    8.491742] hdlc0: Carrier detected
[    8.818002] NET: Registered protocol family 10
[    8.823034] lo: Disabled Privacy Extensions
[   16.233712] hdlc0: Link up (peer uptime 0d18h55m19s)
[   19.488046] eth0: no IPv6 routers present
[   19.584022] eth1: no IPv6 routers present
[   59.175900] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[   59.176639] bernie: cp=3b4, bp=1ef18, len=56, unused=12
[   59.184040] bernie: hdlc0 TX(1504): 0F 00 08 00 45 00 05 DC E6 3B 40 00 3F 06 A1 DB C7 E8 4C A5 62 89 36 EE ED 41 00 19 82 4F FB AD B5 E8 FC F2 80 10 00 5C 19 D1 00 00 01 01 08 0A 41 46 1E 20 CE D6 C0 D2 72 73 61 2D 73 68 61 31 3B 20 63 3D 6E 6F 66 77 73 3B 20 64 3D 67 6D 61 69 6C 2E 63 6F 6D 3B 20 73 3D 67 61 6D 6D 61 3B 0D 0A 09 68...
[   67.159314] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   67.163214] bernie: cp=39c, bp=1e298, len=56, unused=12
[   67.168039] bernie: hdlc0 TX(62): 0F 00 08 00 45 00 00 3A 3D 62 40 00 3F 11 16 AA C7 E8 4C A5 8C BA 46 5F 84 2D 00 35 00 26 27 6E 0B A1 01 00 00 01 00 00 00 00 00 00 04 6D 78 31 30 03 67 6E 75 03 6F 72 67 00 00 01 00 01
[   68.425601] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   68.426123] bernie: cp=39c, bp=1e298, len=77, unused=12
[   68.426123] bernie: hdlc0 TX(69): 0F 00 08 00 45 00 00 41 42 5A 40 00 3F 11 11 AB C7 E8 4C A5 8C BA 46 5F CC E7 00 35 00 2D 6F 55 21 B4 01 00 00 01 00 00 00 00 00 00 01 65 02 6D 78 04 6D 61 69 6C 05 79 61 68 6F 6F 03 63 6F 6D 00 00 1C 00 01
[   70.312068] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[   70.314393] bernie: cp=3c0, bp=1f558, len=1504, unused=12
[   70.314393] bernie: hdlc0 TX(1474): 0F 00 08 00 45 00 05 BE 66 F5 40 00 3F 06 23 1F C7 E8 4C A5 4A 7D 4D 1B A9 3E 00 19 8E ED 22 77 3D 22 95 EF 80 10 00 5C 16 44 00 00 01 01 08 0A 41 46 49 A8 C4 92 9B A9 52 65 63 65 69 76 65 64 3A 20 66 72 6F 6D 20 5B 31 32 37 2E 30 2E 30 2E 31 5D 20 28 70 6F 72 74 3D 34 37 39 30 37 20 68 65 6C 6F 3D...
[   70.443466] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[   70.444392] bernie: cp=3a8, bp=1e8d8, len=76, unused=12
[   70.444392] bernie: hdlc0 TX(1504): 0F 00 08 00 45 00 05 DC 73 8B 40 00 3F 06 A4 58 C7 E8 4C A5 C3 9F 46 0B E0 A0 00 19 8A CF 46 5D 86 1E C0 30 80 10 00 5C 18 2A 00 00 01 01 08 0A 41 46 4A 05 16 CF 9B 47 52 65 63 65 69 76 65 64 3A 20 66 72 6F 6D 20 5B 31 32 37 2E 30 2E 30 2E 31 5D 20 28 70 6F 72 74 3D 36 30 35 31 34 20 68 65 6C 6F 3D...
[   73.776240] bernie: stat=0x80, desc_address=ffffc90011100384, port->chan=0
[   73.780127] bernie: cp=390, bp=1dc58, len=273, unused=12
[   73.780127] bernie: hdlc0 TX(64): 0F 00 08 00 45 00 00 3C 92 BA 40 00 3F 06 C1 8E C7 E8 4C AC 8C BA 46 24 A2 6C 00 50 30 AB 36 DE 00 00 00 00 A0 02 16 D0 5F B2 00 00 02 04 05 B4 04 02 08 0A 3B 60 A4 64 00 00 00 00 01 03 03 07
[   78.215881] bernie: stat=0x80, desc_address=ffffc90011100360, port->chan=0
[   78.219613] bernie: cp=36c, bp=1c998, len=50, unused=12
[   78.219613] bernie: hdlc0 TX(323): 0F 00 08 00 45 00 01 3F C7 32 40 00 3F 06 8C 2A C7 E8 4C AC 8C BA 46 0D BE 90 00 19 34 B2 6F C4 CD CF 00 43 80 18 00 42 18 EE 00 00 01 01 08 0A 3B 60 A8 BD 90 88 EA 5A 16 03 01 01 06 10 00 01 02 01 00 97 89 09 5E 3E E2 01 34 A2 1C B4 4F 66 13 96 6B 2F 5A EA 65 91 3D 51 ED 00 9D 64 7C E1 33 ED 1A 3B...
[   92.256355] bernie: stat=0x80, desc_address=ffffc900111003c0, port->chan=0
[   92.260297] bernie: cp=354, bp=1fb98, len=1504, unused=12
[   92.260297] bernie: hdlc0 TX(382): 0F 00 08 00 45 00 01 7A E2 75 40 00 3F 06 C9 DE C7 E8 4C A5 48 22 31 7A BC 9F 00 19 A2 BC 7F 4F 35 96 74 35 80 18 01 32 51 17 00 00 01 01 08 0A 41 46 9F 59 39 53 59 DD 16 03 01 01 06 10 00 01 02 01 00 42 79 A7 4B B8 36 6A 84 71 CA 57 84 92 AC 5A E5 05 49 F1 35 89 E6 AC E2 B8 1D 93 95 76 98 84 82 1E...
[   99.097689] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   99.100726] bernie: cp=39c, bp=1e298, len=1504, unused=12
[   99.100726] bernie: hdlc0 TX(93): 0F 00 08 00 45 00 00 59 26 08 40 00 3F 06 7D 1C C7 E8 4C A5 82 88 01 65 E6 D9 00 19 98 8C 66 3C 6E C4 D3 B7 80 18 00 BD 89 CA 00 00 01 01 08 0A 41 46 BA 32 3F BF 92 AF 15 03 01 00 20 50 35 A1 23 AC CD ED 7C 8F 33 2E 3F 82 0E 88 FD 80 90 70 B7 30 72 68 9E 8A 37 73 D2 63 71 2B 31
[  106.656297] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[  106.658742] bernie: cp=3c0, bp=1f558, len=1474, unused=12
[  106.658742] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 24 32 40 00 3F 06 30 BD C7 E8 4C A5 4A 06 88 41 9A 7A 00 19 B0 87 F3 65 91 47 BB 65 80 10 00 5C E7 91 00 00 01 01 08 0A 41 46 D7 AA 93 5B 70 7F
[  109.223945] bernie: stat=0x80, desc_address=ffffc90011100378, port->chan=0
[  109.226964] bernie: cp=384, bp=1d618, len=56, unused=12
[  109.226964] bernie: hdlc0 TX(437): 0F 00 08 00 45 00 01 B1 82 CD 40 00 3F 06 0B 54 C7 E8 4C A5 4A 7D 4D 1B AC 03 00 19 B2 1D 73 91 FD 5E 3C 05 80 18 00 5C 58 B7 00 00 01 01 08 0A 41 46 E1 C1 C7 5D 6E D7 6F 6E 6D 65 6E 74 20 62 65 66 6F 72 65 20 70 72 69 6E 74 69 6E 67 20 74 68 69 73 20 65 6D 61 69 6C 0D 0A 3E 0D 0A 3E 20 5F 5F 5F 5F...
[  137.824245] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[  137.826918] bernie: cp=3a8, bp=1e8d8, len=56, unused=12
[  137.826918] bernie: hdlc0 TX(62): 0F 00 08 00 45 00 00 3A 04 B6 40 00 3F 06 FF E1 C7 E8 4C A5 11 94 11 05 DE 68 00 19 C9 B3 4B 2C C1 7D 20 BA 80 18 00 6C 79 0A 00 00 01 01 08 0A 41 47 51 6E 0E 44 A7 CB 51 55 49 54 0D 0A
[  146.835503] bernie: stat=0x80, desc_address=ffffc90011100378, port->chan=0
[  146.837804] bernie: cp=384, bp=1d618, len=1504, unused=12
[  146.837804] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 0F 68 40 00 3F 06 80 36 C7 E8 4C A5 4A 7D 4D 1B AE 8A 00 19 D6 0A 7C 87 4D 04 C4 05 80 10 00 5C 4F 8F 00 00 01 01 08 0A 41 47 74 A6 1A 32 98 4C
[  181.782010] bernie: stat=0x80, desc_address=ffffc90011100354, port->chan=0
[  181.784576] bernie: cp=360, bp=1c358, len=1474, unused=12
[  181.784576] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 CA E3 40 00 3F 06 DE 00 C7 E8 4C A5 5E 88 1F CA E5 D1 00 19 F5 34 3E 77 B6 06 48 B6 80 10 01 14 37 FC 00 00 01 01 08 0A 41 47 FD 05 1B 7B 38 B1
[  272.745752] bernie: stat=0x80, desc_address=ffffc90011100360, port->chan=0
[  272.748026] bernie: cp=36c, bp=1c998, len=1474, unused=12
[  272.748026] bernie: hdlc0 TX(81): 0F 00 08 00 45 00 00 4D 60 69 40 00 3F 11 F3 8F C7 E8 4C A5 8C BA 46 5F AE 02 00 35 00 39 51 DC 95 7D 01 00 00 01 00 00 00 00 00 00 04 61 6C 74 34 0D 67 6D 61 69 6C 2D 73 6D 74 70 2D 69 6E 01 6C 06 67 6F 6F 67 6C 65 03 63 6F 6D 00 00 01 00 01
[  294.233029] bernie: stat=0x80, desc_address=ffffc9001110036c, port->chan=0
[  294.235817] bernie: cp=378, bp=1cfd8, len=56, unused=12
[  294.235817] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 30 E8 40 00 3F 06 86 2E C7 E8 4C A5 CC 0D A4 12 D8 49 00 19 60 0A 83 70 C3 A2 9F 6C 80 10 00 5C 2E 12 00 00 01 01 08 0A 41 49 B4 3E 05 52 A9 DA
[  316.166931] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[  316.166931] bernie: cp=3b4, bp=1ef18, len=1474, unused=12
[  316.166931] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 9E FA 40 00 3F 06 EE A3 C7 E8 4C A5 4A 7D 4F 1B D8 D9 00 19 74 7C 97 70 1E D3 84 7F 80 10 00 5C CA 58 00 00 01 01 08 0A 41 4A 09 FA C4 81 65 EA
[  331.715177] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[  331.717278] bernie: cp=3a8, bp=1e8d8, len=198, unused=12
[  331.717278] bernie: hdlc0 TX(254): 0F 00 08 00 45 00 00 FA B8 47 40 00 3F 06 27 74 C7 E8 4C A5 42 6F 04 46 84 07 00 19 81 E2 FA 93 1A 88 32 FB 80 18 01 11 D2 2E 00 00 01 01 08 0A 41 4A 46 AB 0C 6C 6C 3B 16 03 01 00 86 10 00 00 82 00 80 1C 61 03 1E 89 F4 45 85 F1 88 C9 24 E7 61 6F E7 97 1F 7D EF CC 09 1C FB EA 15 2F 17 BD C4 7A 9B 39...
[  378.162278] bernie: stat=0x80, desc_address=ffffc90011100354, port->chan=0
[  378.164352] bernie: cp=360, bp=1c358, len=65, unused=12
[  378.164352] bernie: hdlc0 TX(62): 0F 00 08 00 45 00 00 3A FB FD 40 00 3F 11 58 0E C7 E8 4C A5 8C BA 46 5F DD 40 00 35 00 26 61 A2 78 3E 01 00 00 01 00 00 00 00 00 00 04 6D 78 31 30 03 67 6E 75 03 6F 72 67 00 00 1C 00 01
[  378.589909] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[  378.592006] bernie: cp=3c0, bp=1f558, len=1504, unused=12
[  378.592006] bernie: hdlc0 TX(373): 0F 00 08 00 45 00 01 71 32 56 40 00 3F 06 88 69 C7 E8 4C A5 80 6B EA CE A9 EC 00 19 AD 6F D8 0D 12 C7 B1 58 50 18 44 70 42 24 00 00 5F 7E F6 30 BD 36 18 E5 48 EC 0E BA 7F 64 4A 52 D6 E2 AB DB F5 79 F6 8A 4D 6B 01 02 54 11 68 89 1A 1B 22 A9 DF 37 EF 64 07 6C 62 2D 5A 88 56 5C F3 E7 2F 24 1B BD B9 7C...
[  378.736328] bernie: stat=0x82, desc_address=ffffc9001110036c, port->chan=0
[  378.740006] bernie: cp=378, bp=1cfd8, len=198, unused=12
[  378.740006] bernie: hdlc0 TX(1504): 0F 00 08 00 45 00 05 DC CD 47 40 00 3F 06 C1 32 C7 E8 4C A9 CF 2E C3 E1 00 50 81 10 94 B4 72 7A 4E 0C 13 8E 50 10 19 20 95 F5 00 00 69 A6 FA 8B AD 3B AA 01 90 A1 65 D5 AD 6E 0E 56 C0 36 05 25 B6 B9 AF BA D2 7E 7A A2 A0 85 4A 24 68 37 AB B8 38 3D B7 09 52 0D 8D AA 4B 01 05 AD 3C DD D5 7C EB CB 85 2C...
[  379.063796] bernie: stat=0x80, desc_address=ffffc9001110036c, port->chan=0
[  379.066167] bernie: cp=378, bp=1cfd8, len=56, unused=12
[  379.066167] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 79 9B 40 00 3F 06 4B 10 C7 E8 4C A5 CF 7E 93 0C C9 D7 00 19 AE BA 84 C3 74 20 B1 8A 80 10 00 6C C9 0C 00 00 01 01 08 0A 41 4A FF 5A 71 C0 60 AC
[  394.457672] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[  394.461574] bernie: cp=3a8, bp=1e8d8, len=44, unused=12
[  394.461574] bernie: hdlc0 TX(1474): 0F 00 08 00 45 00 05 BE FB 34 40 00 3F 06 8C DF C7 E8 4C A5 4A 7D 4F 1B DD 52 00 19 BC 90 EB 2E 74 37 B2 F3 80 10 00 5C 0B 22 00 00 01 01 08 0A 41 4B 3B AD C0 2E 86 4D 20 6F 6E 6C 79 20 77 72 69 74 65 20 74 68 65 20 66 69 6C 65 2C 20 72 61 74 68 65 72 20 74 68 61 6E 0D 0A 3E 3E 20 74 72 79 69 6E 67...
[  402.361173] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[  402.364012] bernie: cp=3b4, bp=1ef18, len=62, unused=12
[  402.364012] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 3D A4 40 00 3F 06 A3 72 C7 E8 4C A5 40 12 06 0E E1 B6 00 19 C4 0C 6B F6 95 20 43 2D 80 10 00 6C 3E C2 00 00 01 01 08 0A 41 4B 5A 47 08 58 4E D6
[  520.614583] bernie: stat=0x80, desc_address=ffffc90011100378, port->chan=0
[  520.618174] bernie: cp=384, bp=1d618, len=56, unused=12
[  520.618174] bernie: hdlc0 TX(93): 0F 00 08 00 45 00 00 59 5D 9D 40 00 3F 06 0E 9A C7 E8 4C A5 59 91 61 49 EA EA 00 19 2C E2 62 45 5D 93 A7 5A 80 18 03 DB 6F 6F 00 00 01 01 08 0A 41 4D 28 79 1A A5 41 5F 17 03 01 00 20 69 A6 32 DA 13 C4 A6 EB 4B C6 55 B2 48 D2 CB 8C 02 61 87 FC B8 FB AF 79 3B 93 71 42 54 43 F5 C2

--=-jgcCTJp9Xl8Eh3JxyeXW
Content-Disposition: attachment; filename="pc300too-lspci.out"
Content-Type: text/plain; name="pc300too-lspci.out"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate
	Subsystem: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32
	Region 3: Memory at <ignored> (64-bit, non-prefetchable)
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [b]
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 99
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fde00000-fdffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)
	Kernel modules: shpchp

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: 00000000fdb00000-00000000fdbfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  a, PowerLimit 25.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 9601
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel modules: shpchp

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at ff00 [size=8]
	Region 1: I/O ports at fe00 [size=4]
	Region 2: I/O ports at fd00 [size=8]
	Region 3: I/O ports at fc00 [size=4]
	Region 4: I/O ports at fb00 [size=16]
	Region 5: Memory at fe02f000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at fe029000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
	Subsystem: Giga-byte Technology Device 4385
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel modules: i2c-piix4

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at fa00 [size=16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ATIIXP_IDE
	Kernel modules: atiixp, ide-pci-generic, ata_generic

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
	Subsystem: Giga-byte Technology Device a102
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at fe024000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
	Subsystem: ATI Technologies Inc SB700/SB800 LPC host controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: b0000000-cfffffff
	Prefetchable memory behind bridge: fdc00000-fdcfffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fe028000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc Device 9710 (prog-if 00 [VGA controller])
	Subsystem: Giga-byte Technology Device d000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at ee00 [size=256]
	Region 2: Memory at fdfe0000 (32-bit, non-prefetchable) [size=64K]
	Region 5: Memory at fde00000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

01:05.1 Audio device: ATI Technologies Inc Device 970f
	Subsystem: Giga-byte Technology Device 960f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at fdffc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 40
	Region 0: I/O ports at de00 [size=256]
	Region 2: Memory at fdbff000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at fdbe0000 (64-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at fdb00000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0f00c  Data: 4141
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 78-56-34-12-78-56-34-12
	Kernel driver in use: r8169
	Kernel modules: r8169

03:06.0 Ethernet controller: 3Com Corporation 3c905 100BaseTX [Boomerang]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (750ns min, 2000ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at cf00 [size=64]
	[virtual] Expansion ROM at fdc00000 [disabled] [size=64K]
	Kernel driver in use: 3c59x
	Kernel modules: 3c59x

03:07.0 Communication controller: Cyclades Corporation PC300/RSV or /X21 (2 ports) (rev 01)
	Subsystem: Cyclades Corporation Device 0301
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at cffff000 (32-bit, non-prefetchable) [size=128]
	Region 1: I/O ports at ce00 [size=128]
	Region 2: Memory at cfffe000 (32-bit, non-prefetchable) [size=1K]
	Region 3: Memory at fdc80000 (32-bit, prefetchable) [size=512K]
	Region 5: Memory at cfffd000 (32-bit, non-prefetchable) [size=256]
	Kernel driver in use: PC300
	Kernel modules: pc300too

03:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 1000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at cfffc000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at cfff8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394


--=-jgcCTJp9Xl8Eh3JxyeXW
Content-Disposition: attachment; filename="pc300too-dmidecode.out"
Content-Type: text/plain; name="pc300too-dmidecode.out"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

# dmidecode 2.9
SMBIOS 2.4 present.
56 structures occupying 2903 bytes.
Table at 0x000F0100.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Award Software International, Inc.
	Version: F5
	Release Date: 11/30/2009
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		AGP is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Gigabyte Technology Co., Ltd.
	Product Name: GA-MA785GMT-UD2H
	Version:  
	Serial Number:  
	UUID: 36434630-3439-3741-4237-4343FFFFFFFF
	Wake-up Type: Power Switch
	SKU Number:  
	Family:  

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Gigabyte Technology Co., Ltd.
	Product Name: GA-MA785GMT-UD2H
	Version: x.x
	Serial Number:  

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: Gigabyte Technology Co., Ltd.
	Type: Desktop
	Lock: Not Present
	Version:  
	Serial Number:  
	Asset Tag:  
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: Socket M2
	Type: Central Processor
	Family: Athlon
	Manufacturer: AMD
	ID: 52 0F 10 00 FF FB 8B 17
	Signature: Family 16, Model 5, Stepping 2
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Hyper-threading technology)
	Version: AMD Athlon(tm) II X4 605e Processor
	Voltage: 1.0 V
	External Clock: 200 MHz
	Max Speed: 3000 MHz
	Current Speed: 2300 MHz
	Status: Populated, Enabled
	Upgrade: Socket 754
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000C
	L3 Cache Handle: Not Provided
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x0005, DMI type 5, 24 bytes
Memory Controller Information
	Error Detecting Method: 64-bit ECC
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 4096 MB
	Maximum Total Memory Size: 16384 MB
	Supported Speeds:
		70 ns
		60 ns
		50 ns
	Supported Memory Types:
		Standard
		DIMM
	Memory Module Voltage: 2.9 V
	Associated Memory Slots: 4
		0x0006
		0x0007
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		None

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A0
	Bank Connections: 1
	Current Speed: 42 ns
	Type: Other Unknown EDO
	Installed Size: 2048 MB (Single-bank Connection)
	Enabled Size: 2048 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A1
	Bank Connections: 2
	Current Speed: 42 ns
	Type: Other Unknown EDO
	Installed Size: 2048 MB (Single-bank Connection)
	Enabled Size: 2048 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A2
	Bank Connections: 3
	Current Speed: 42 ns
	Type: Other Unknown EDO
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A3
	Bank Connections: 4
	Current Speed: 42 ns
	Type: Other Unknown EDO
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: External Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: External Cache
	Configuration: Disabled, Not Socketed, Level 2
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 0 KB
	Maximum Size: 1024 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PRIMARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator:  
	External Connector Type: None
	Port Type: Other

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FDD
	Internal Connector Type: On Board Floppy
	External Reference Designator:  
	External Connector Type: None
	Port Type: 8251 FIFO Compatible

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:  
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT1
	Internal Connector Type: DB-25 female
	External Reference Designator:  
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Keyboard
	Internal Connector Type: Other
	External Reference Designator:  
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Mouse
	Internal Connector Type: PS/2
	External Reference Designator: No Detected
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0020, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Long
	ID: 7
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Long
	ID: 6
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0022, DMI type 9, 13 bytes
System Slot Information
	Designation: AGP
	Type: 32-bit AGP
	Current Usage: Available
	Length: Long
	ID: 8
	Characteristics:
		5.0 V is provided

Handle 0x0023, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express x16
	Type: x16 PCI Express
	Current Usage: Unknown
	Length: Other
	ID: 0
	Characteristics:
		3.3 V is provided

Handle 0x0024, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express x1
	Type: x1 PCI Express
	Current Usage: Unknown
	Length: Other
	ID: 0
	Characteristics:
		3.3 V is provided

Handle 0x0025, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 3
		n|US|iso8859-1
		n|US|iso8859-1
		r|CA|iso8859-1
	Currently Installed Language: n|US|iso8859-1

Handle 0x0026, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 16 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0027, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0026
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: A0
	Bank Locator: Bank0/1
	Type: Unknown
	Type Detail: None
	Speed: 1066 MHz (0.9 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x0028, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0026
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: A1
	Bank Locator: Bank2/3
	Type: Unknown
	Type Detail: None
	Speed: 1066 MHz (0.9 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x0029, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0026
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: A2
	Bank Locator: Bank4/5
	Type: Unknown
	Type Detail: None
	Speed: 1066 MHz (0.9 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x002A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0026
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: A3
	Bank Locator: Bank6/7
	Type: Unknown
	Type Detail: None
	Speed: 1066 MHz (0.9 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x002B, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x0026
	Partition Width: 32

Handle 0x002C, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0027
	Memory Array Mapped Address Handle: 0x002B
	Partition Row Position: 1

Handle 0x002D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00080000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0028
	Memory Array Mapped Address Handle: 0x002B
	Partition Row Position: 1

Handle 0x002E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0029
	Memory Array Mapped Address Handle: 0x002B
	Partition Row Position: 1

Handle 0x002F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x002A
	Memory Array Mapped Address Handle: 0x002B
	Partition Row Position: 1

Handle 0x0030, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0031, DMI type 188, 212 bytes
OEM-specific Type
	Header and Data:
		BC D4 31 00 00 00 00 B0 00 00 00 00 00 00 00 50
		01 00 00 00 00 06 76 00 00 00 00 00 08 00 00 00
		00 60 58 02 00 00 01 00 03 00 00 00 00 00 4F 01
		00 00 00 00 01 00 00 00 00 00 00 00 02 00 00 00
		00 00 00 00 03 00 00 00 00 00 00 00 04 00 00 00
		00 00 00 00 05 00 00 00 00 00 00 00 06 00 00 00
		00 00 00 00 07 00 00 00 03 50 00 B0 01 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 E0 3F 78 00
		00 00 00 00 00 00 00 00 00 00 00 00 06 00 C8 0D
		48 00 02 18 07 00 00 00 C4 00 14 00 23 51 10 EF
		44 68 32 00 00 00 01 00 00 02 00 00 40 00 00 00
		5C 00 B0 4A 0C 09 48 3F 00 00 00 00 00 00 00 00
		00 00 00 00

Handle 0x0032, DMI type 190, 212 bytes
OEM-specific Type
	Header and Data:
		BE D4 32 00 C4 05 00 00 00 00 00 00 24 B4 40 14
		FB 0F E0 2C 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 E0 3F 78 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 06 00 C8 0D
		48 00 02 18 00 00 00 00 29 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 29 00 00 00 00 00 00 00
		24 B4 40 14 FB 0F E0 2C 01 01 00 00 00 00 00 00
		00 02 00 00 00 00 00 00 40 00 00 00 07 00 00 00
		C4 00 14 00 23 51 10 EF 44 68 32 00 00 00 01 00
		0C 09 48 3F 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00

Handle 0x0033, DMI type 192, 244 bytes
OEM-specific Type
	Header and Data:
		C0 F4 33 00 06 40 00 00 22 32 11 20 E7 88 71 0E
		FE 2E 0D 00 00 00 00 00 22 32 11 20 1A 20 25 2A
		1A 00 05 0A 33 36 3A 3B 13 16 1A 1B 2E 00 00 00
		00 00 08 06 0A 0C 08 06 0A 0C 0E 0A 08 08 0E 0A
		08 08 0C 00 74 D0 41 05 FE 2E 0D 00 00 00 00 00
		71 00 77 00 79 00 7F 00 81 00 11 00 17 00 19 00
		1F 00 00 00 11 00 17 00 19 00 1F 00 00 00 11 00
		17 00 19 00 1F 00 00 00 83 00 8E 00 92 00 9A 00
		03 00 0E 00 12 00 1A 00 03 00 0E 00 12 00 1A 00
		03 00 0E 00 12 00 1A 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00

Handle 0x0034, DMI type 194, 244 bytes
OEM-specific Type
	Header and Data:
		C2 F4 34 00 06 40 00 00 22 32 11 20 E7 88 71 0E
		FE 2E 0C 00 00 00 00 00 22 32 11 20 15 1D 24 28
		15 1D 04 08 31 34 37 38 11 14 17 18 2C 00 00 00
		00 00 0A 0A 0C 0A 0A 0A 0C 0A 0A 0A 0C 0A 0A 0A
		0C 0A 0A 00 60 C3 92 26 FE 2E 0C 00 00 00 00 00
		78 00 7D 00 7E 00 83 00 86 00 18 00 1D 00 1E 00
		03 00 00 00 18 00 1D 00 1E 00 03 00 00 00 18 00
		1D 00 1E 00 03 00 00 00 89 00 8F 00 95 00 9E 00
		09 00 0F 00 15 00 1E 00 09 00 0F 00 15 00 1E 00
		09 00 0F 00 15 00 1E 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00

Handle 0x0035, DMI type 196, 244 bytes
OEM-specific Type
	Header and Data:
		C4 F4 35 00 06 40 00 00 07 00 0D 00 13 00 1A 00
		00 00 00 00 07 00 0D 00 13 00 1A 00 00 00 07 00
		0D 00 13 00 1A 00 00 00 00 00 07 00 0D 00 22 00
		24 00 28 00 28 00 02 00 04 00 08 00 08 00 02 00
		04 00 08 00 08 00 02 00 04 00 08 00 08 00 07 0D
		13 1A 22 24 28 28 69 00 00 00 38 01 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00

Handle 0x0036, DMI type 198, 244 bytes
OEM-specific Type
	Header and Data:
		C6 F4 36 00 06 40 00 00 03 00 0B 00 14 00 16 00
		02 00 00 00 03 00 0B 00 14 00 16 00 02 00 03 00
		0B 00 14 00 16 00 02 00 00 00 03 00 0B 00 1F 00
		23 00 27 00 26 00 1F 00 03 00 07 00 06 00 1F 00
		03 00 07 00 06 00 1F 00 03 00 07 00 06 00 03 0B
		14 16 1F 23 27 26 02 00 00 00 0F 01 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00

Handle 0x0037, DMI type 127, 4 bytes
End Of Table


--=-jgcCTJp9Xl8Eh3JxyeXW
Content-Disposition: attachment; filename="pc300too-dmesg.out"
Content-Type: text/plain; name="pc300too-dmesg.out"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36 (root@newvalis.gnu.org) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Mon Nov 8 20:40:14 EST 2010
[    0.000000] Command line: root=/dev/md0 ro console=tty0 console=ttyS0,115200n8 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000098400 (usable)
[    0.000000]  BIOS-e820: 0000000000098400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000008fd81000 (usable)
[    0.000000]  BIOS-e820: 000000008fde0000 - 000000008fde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008fde3000 - 000000008fdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000008fdf0000 - 000000008fe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000150000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x150000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFF0000000 write-back
[    0.000000]   2 base 00008FE00000 mask FFFFFFE00000 uncachable
[    0.000000]   3 base 000100000000 mask FFFFC0000000 write-back
[    0.000000]   4 base 000140000000 mask FFFFF0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000150000000 aka 5376M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000008fe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x8fd81 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f59c0] f59c0
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-000000008fd81000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 008fc00000 page 2M
[    0.000000]  008fc00000 - 008fd81000 page 4k
[    0.000000] kernel direct mapping tables up to 8fd81000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000150000000
[    0.000000]  0100000000 - 0140000000 page 1G
[    0.000000]  0140000000 - 0150000000 page 2M
[    0.000000] kernel direct mapping tables up to 150000000 @ a000-c000
[    0.000000] RAMDISK: 378c1000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7360 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 000000008fde3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 000000008fde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 000000008fde30c0 0747E (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 000000008fde0000 00040
[    0.000000] ACPI: SSDT 000000008fdea600 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 000000008fdeaec0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 000000008fdeaf00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 000000008fdeaf40 0032A (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 000000008fdea540 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000150000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000150000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00049fffff] PMD -> [ffff880100200000-ffff8801033fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00150000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000098
[    0.000000]     0: 0x00000100 -> 0x0008fd81
[    0.000000]     0: 0x00100000 -> 0x00150000
[    0.000000] On node 0 totalpages: 916760
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3935 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 570809 pages, LIFO batch:31
[    0.000000]   Normal zone: 4480 pages used for memmap
[    0.000000]   Normal zone: 323200 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] PM: Registered nosave memory: 0000000000098000 - 0000000000099000
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000008fd81000 - 000000008fde0000
[    0.000000] PM: Registered nosave memory: 000000008fde0000 - 000000008fde3000
[    0.000000] PM: Registered nosave memory: 000000008fde3000 - 000000008fdf0000
[    0.000000] PM: Registered nosave memory: 000000008fdf0000 - 000000008fe00000
[    0.000000] PM: Registered nosave memory: 000000008fe00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 8fe00000 (gap: 8fe00000:50200000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001800000 s78976 r8192 d23424 u524288
[    0.000000] pcpu-alloc: s78976 r8192 d23424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 897944
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md0 ro console=tty0 console=ttyS0,115200n8 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 14000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] early_res array is doubled to 128 at [b000 - bfff]
[    0.000000] Subtract (58 early reservations)
[    0.000000]   #1 [0001000000 - 00015dcba0]   TEXT DATA BSS
[    0.000000]   #2 [00378c1000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [00015dd000 - 00015dd106]             BRK
[    0.000000]   #4 [00000f59d0 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f59c0 - 00000f59d0]    MP-table mpf
[    0.000000]   #6 [0000098400 - 00000f1100]   BIOS reserved
[    0.000000]   #7 [00000f129c - 00000f59c0]   BIOS reserved
[    0.000000]   #8 [00000f1100 - 00000f129c]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 000000a000]         PGTABLE
[    0.000000]   #12 [000000a000 - 000000b000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [00015dd140 - 00015de140]         BOOTMEM
[    0.000000]   #15 [00015dcbc0 - 00015dce60]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0103400000]        MEMMAP 0
[    0.000000]   #19 [00015dce80 - 00015dd000]         BOOTMEM
[    0.000000]   #20 [00015de140 - 00015f6140]         BOOTMEM
[    0.000000]   #21 [00015f6140 - 0001602140]         BOOTMEM
[    0.000000]   #22 [0001603000 - 0001604000]         BOOTMEM
[    0.000000]   #23 [0001602140 - 0001602181]         BOOTMEM
[    0.000000]   #24 [00016021c0 - 0001602203]         BOOTMEM
[    0.000000]   #25 [0001602240 - 00016024a8]         BOOTMEM
[    0.000000]   #26 [00016024c0 - 0001602528]         BOOTMEM
[    0.000000]   #27 [0001602540 - 00016025a8]         BOOTMEM
[    0.000000]   #28 [00016025c0 - 0001602628]         BOOTMEM
[    0.000000]   #29 [0001602640 - 00016026a8]         BOOTMEM
[    0.000000]   #30 [00016026c0 - 0001602728]         BOOTMEM
[    0.000000]   #31 [0001602740 - 00016027a8]         BOOTMEM
[    0.000000]   #32 [00016027c0 - 0001602828]         BOOTMEM
[    0.000000]   #33 [0001602840 - 00016028a8]         BOOTMEM
[    0.000000]   #34 [00016028c0 - 0001602928]         BOOTMEM
[    0.000000]   #35 [0001602940 - 00016029a8]         BOOTMEM
[    0.000000]   #36 [00016029c0 - 00016029e0]         BOOTMEM
[    0.000000]   #37 [0001602a00 - 0001602a20]         BOOTMEM
[    0.000000]   #38 [0001602a40 - 0001602a76]         BOOTMEM
[    0.000000]   #39 [0001602a80 - 0001602ab6]         BOOTMEM
[    0.000000]   #40 [0001800000 - 000181b000]         BOOTMEM
[    0.000000]   #41 [0001880000 - 000189b000]         BOOTMEM
[    0.000000]   #42 [0001900000 - 000191b000]         BOOTMEM
[    0.000000]   #43 [0001980000 - 000199b000]         BOOTMEM
[    0.000000]   #44 [0001602ac0 - 0001602ac8]         BOOTMEM
[    0.000000]   #45 [0001602b00 - 0001602b08]         BOOTMEM
[    0.000000]   #46 [0001602b40 - 0001602b50]         BOOTMEM
[    0.000000]   #47 [0001602b80 - 0001602ba0]         BOOTMEM
[    0.000000]   #48 [0001602bc0 - 0001602cf0]         BOOTMEM
[    0.000000]   #49 [0001602d00 - 0001602d50]         BOOTMEM
[    0.000000]   #50 [0001602d80 - 0001602dd0]         BOOTMEM
[    0.000000]   #51 [0001604000 - 000160c000]         BOOTMEM
[    0.000000]   #52 [0020000000 - 0024000000]         BOOTMEM
[    0.000000]   #53 [0001602e00 - 0001602e20]         BOOTMEM
[    0.000000]   #54 [000199b000 - 000599b000]         BOOTMEM
[    0.000000]   #55 [000160c000 - 000162c000]         BOOTMEM
[    0.000000]   #56 [000162c000 - 000166c000]         BOOTMEM
[    0.000000]   #57 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 3470308k/5505024k available (2811k kernel code, 1837984k absent, 196732k reserved, 1719k data, 608k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2310.063 MHz processor.
[    0.016005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4620.12 BogoMIPS (lpj=9240240)
[    0.024003] pid_max: default: 32768 minimum: 301
[    0.028037] Security Framework initialized
[    0.032004] SELinux:  Disabled at boot.
[    0.036372] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.044010] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.048648] Mount-cache hash table entries: 256
[    0.052110] Initializing cgroup subsys ns
[    0.056004] Initializing cgroup subsys cpuacct
[    0.060004] Initializing cgroup subsys devices
[    0.064025] tseg: 008fe00000
[    0.064027] CPU: Physical Processor ID: 0
[    0.068002] CPU: Processor Core ID: 0
[    0.072003] mce: CPU supports 6 MCE banks
[    0.076008] Performance Events: AMD PMU driver.
[    0.081524] ... version:                0
[    0.084002] ... bit width:              48
[    0.088002] ... generic registers:      4
[    0.092002] ... value mask:             0000ffffffffffff
[    0.096002] ... max period:             00007fffffffffff
[    0.100002] ... fixed-purpose events:   0
[    0.104002] ... event mask:             000000000000000f
[    0.108643] ACPI: Core revision 20100702
[    0.124061] Setting APIC routing to flat
[    0.128495] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.173697] CPU0: AMD Athlon(tm) II X4 605e Processor stepping 02
[    0.180000] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.456006] Brought up 4 CPUs
[    0.459006] Total of 4 processors activated (18482.86 BogoMIPS).
[    0.460405] NET: Registered protocol family 16
[    0.464039] node 0 link 0: io port [c000, ffff]
[    0.464039] TOM: 00000000b0000000 aka 2816M
[    0.468002] Fam 10h mmconf [e0000000, e00fffff]
[    0.468004] node 0 link 0: mmio [a0000, bffff]
[    0.468007] node 0 link 0: mmio [b0000000, dfffffff]
[    0.468009] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.468011] node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
[    0.468015] TOM2: 0000000150000000 aka 5376M
[    0.472002] bus: [00, 03] on node 0 link 0
[    0.472004] bus: 00 index 0 [io  0x0000-0xffff]
[    0.472007] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.472008] bus: 00 index 2 [mem 0xb0000000-0xdfffffff]
[    0.472010] bus: 00 index 3 [mem 0xe0400000-0xffffffff]
[    0.472012] bus: 00 index 4 [mem 0xe0100000-0xe03fffff]
[    0.472014] bus: 00 index 5 [mem 0x150000000-0xfcffffffff]
[    0.472044] ACPI: bus type pci registered
[    0.476040] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.488003] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.519273] PCI: Using configuration type 1 for base access
[    0.524052] bio: create slab <bio-0> at 0
[    0.528548] ACPI: EC: Look up EC in DSDT
[    0.538213] ACPI: Interpreter enabled
[    0.540003] ACPI: (supports S0 S3 S4 S5)
[    0.545257] ACPI: Using IOAPIC for interrupt routing
[    0.556116] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.564096] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.572166] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.576002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.584002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.592002] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.600002] pci_root PNP0A03:00: host bridge window [mem 0xaff00000-0xfebfffff]
[    0.604020] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.604103] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.604106] pci 0000:00:0a.0: PME# disabled
[    0.604147] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.604157] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.604166] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.604176] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.604185] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.604195] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.604249] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.604320] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.604403] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.604470] pci 0000:00:12.2: supports D1 D2
[    0.604472] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.604476] pci 0000:00:12.2: PME# disabled
[    0.604507] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.608074] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.608156] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.608223] pci 0000:00:13.2: supports D1 D2
[    0.608225] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.608229] pci 0000:00:13.2: PME# disabled
[    0.608352] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.608362] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.608371] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.608380] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.608389] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.608456] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.608511] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.608515] pci 0000:00:14.2: PME# disabled
[    0.608645] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.608791] pci 0000:01:05.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
[    0.608795] pci 0000:01:05.0: reg 14: [io  0xee00-0xeeff]
[    0.608800] pci 0000:01:05.0: reg 18: [mem 0xfdfe0000-0xfdfeffff]
[    0.608809] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.608820] pci 0000:01:05.0: supports D1 D2
[    0.608835] pci 0000:01:05.1: reg 10: [mem 0xfdffc000-0xfdffffff]
[    0.608857] pci 0000:01:05.1: supports D1 D2
[    0.608893] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.612003] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.612006] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.612009] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.612052] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
[    0.612071] pci 0000:02:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
[    0.612084] pci 0000:02:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
[    0.612094] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.612121] pci 0000:02:00.0: supports D1 D2
[    0.612123] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.612127] pci 0000:02:00.0: PME# disabled
[    0.620035] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.624005] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.624008] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.624012] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.624066] pci 0000:03:06.0: reg 10: [io  0xcf00-0xcf3f]
[    0.624127] pci 0000:03:06.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.624164] pci 0000:03:07.0: reg 10: [mem 0xcffff000-0xcffff07f]
[    0.624177] pci 0000:03:07.0: reg 14: [io  0xce00-0xce7f]
[    0.624189] pci 0000:03:07.0: reg 18: [mem 0xcfffe000-0xcfffe3ff]
[    0.624202] pci 0000:03:07.0: reg 1c: [mem 0xfdc80000-0xfdcfffff pref]
[    0.624225] pci 0000:03:07.0: reg 24: [mem 0xcfffd000-0xcfffd0ff]
[    0.624289] pci 0000:03:0e.0: reg 10: [mem 0xcfffc000-0xcfffc7ff]
[    0.624302] pci 0000:03:0e.0: reg 14: [mem 0xcfff8000-0xcfffbfff]
[    0.624379] pci 0000:03:0e.0: supports D1 D2
[    0.624381] pci 0000:03:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.624386] pci 0000:03:0e.0: PME# disabled
[    0.624419] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.632004] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.632008] pci 0000:00:14.4:   bridge window [mem 0xb0000000-0xcfffffff]
[    0.632013] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    0.632015] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.632018] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.632020] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.632023] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.632026] pci 0000:00:14.4:   bridge window [mem 0xaff00000-0xfebfffff] (subtractive decode)
[    0.632040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.632348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.632439] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.632482] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.648681] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.657277] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.665275] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.673277] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.681278] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.689273] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.697274] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.705278] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.713255] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.720004] vgaarb: loaded
[    0.724037] usbcore: registered new interface driver usbfs
[    0.728038] usbcore: registered new interface driver hub
[    0.732038] usbcore: registered new device driver usb
[    0.740038] PCI: Using ACPI for IRQ routing
[    0.744003] PCI: pci_cache_line_size set to 64 bytes
[    0.744010] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.752077] reserve RAM buffer: 0000000000098400 - 000000000009ffff 
[    0.752079] reserve RAM buffer: 000000008fd81000 - 000000008fffffff 
[    0.752101] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.757361] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.766036] Switching to clocksource tsc
[    0.768938] pnp: PnP ACPI init
[    0.772036] ACPI: bus type pnp registered
[    0.776768] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.789423] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.802746] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:06.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.818038] pnp 00:0d: disabling [mem 0x000d4400-0x000d7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.830061] pnp 00:0d: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.842084] pnp 00:0d: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.854106] pnp 00:0d: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.866131] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.878154] pnp 00:0d: disabling [mem 0x00100000-0x8fddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.890323] pnp: PnP ACPI: found 14 devices
[    0.894543] ACPI: ACPI bus type pnp unregistered
[    0.899194] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.905145] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.911092] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.917041] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.922994] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.928939] system 00:02: [io  0x040b] has been reserved
[    0.934280] system 00:02: [io  0x04d6] has been reserved
[    0.939618] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.945566] system 00:02: [io  0x0c14] has been reserved
[    0.950905] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.956854] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.962800] system 00:02: [io  0x0c6f] has been reserved
[    0.968140] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.974088] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.980041] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.985988] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.991936] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.997883] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    1.003837] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    1.009784] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    1.015738] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    1.022995] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.029639] system 00:0d: [mem 0x8fde0000-0x8fdfffff] could not be reserved
[    1.036631] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
[    1.043273] system 00:0d: [mem 0x8fef0000-0xafeeffff] could not be reserved
[    1.050258] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.057247] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
[    1.064243] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
[    1.078044] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.083303] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.089426] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    1.096246] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.104019] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
[    1.111270] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    1.116531] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    1.122652] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    1.129466] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    1.137245] pci 0000:03:06.0: BAR 6: assigned [mem 0xfdc00000-0xfdc0ffff pref]
[    1.144499] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    1.149759] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    1.155888] pci 0000:00:14.4:   bridge window [mem 0xb0000000-0xcfffffff]
[    1.162711] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    1.169984] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.176719] pci 0000:00:0a.0: setting latency timer to 64
[    1.176727] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.176729] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.176731] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.176733] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    1.176736] pci_bus 0000:00: resource 8 [mem 0xaff00000-0xfebfffff]
[    1.176738] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    1.176740] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    1.176743] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.176745] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    1.176748] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    1.176750] pci_bus 0000:02: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    1.176752] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    1.176755] pci_bus 0000:03: resource 1 [mem 0xb0000000-0xcfffffff]
[    1.176757] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff pref]
[    1.176759] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    1.176761] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    1.176763] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    1.176766] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    1.176768] pci_bus 0000:03: resource 8 [mem 0xaff00000-0xfebfffff]
[    1.176845] NET: Registered protocol family 2
[    1.181393] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.189919] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.199981] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.207019] TCP: Hash tables configured (established 524288 bind 65536)
[    1.213668] TCP reno registered
[    1.216859] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.222925] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.229537] NET: Registered protocol family 1
[    1.233942] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    1.380053] pci 0000:01:05.0: Boot video device
[    1.380069] PCI: CLS 4 bytes, default 64
[    1.380114] Trying to unpack rootfs image as initramfs...
[    1.533921] Freeing initrd memory: 7356k freed
[    1.541095] PCI-DMA: Disabling AGP.
[    1.544806] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    1.550422] PCI-DMA: using GART IOMMU.
[    1.554207] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.564867] audit: initializing netlink socket (disabled)
[    1.570315] type=2000 audit(1289958061.568:1): initialized
[    1.576099] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.582687] VFS: Disk quotas dquot_6.5.2
[    1.586685] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.593223] msgmni has been set to 6921
[    1.597325] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.604766] io scheduler noop registered
[    1.608722] io scheduler deadline registered
[    1.614324] io scheduler cfq registered (default)
[    1.619930] Linux agpgart interface v0.103
[    1.624075] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.650900] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.677736] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.684940] brd: module loaded
[    1.688237] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.694453] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.704320] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.709515] mice: PS/2 mouse device common for all mice
[    1.714885] rtc_cmos 00:05: RTC can wake from S4
[    1.719648] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.725809] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.732264] cpuidle: using governor ladder
[    1.736397] cpuidle: using governor menu
[    1.740565] TCP cubic registered
[    1.742773] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.750385] NET: Registered protocol family 17
[    1.754867] Registering the dns_resolver key type
[    1.759787] registered taskstats version 1
[    1.764206] rtc_cmos 00:05: setting system clock to 2010-11-17 01:41:03 UTC (1289958063)
[    1.772481] Freeing unused kernel memory: 608k freed
[    1.858877] udevd (521): /proc/521/oom_adj is deprecated, please use /proc/521/oom_score_adj instead.
[    2.046448] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.052474] Floppy drive(s): fd0 is 1.44M
[    2.070120] SCSI subsystem initialized
[    2.075593] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.081004] FDC 0 is a post-1991 82077
[    2.086187] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    2.113258] Uniform Multi-Platform E-IDE driver
[    2.133777] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.139570] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.146680] r8169 0000:02:00.0: setting latency timer to 64
[    2.146717] r8169 0000:02:00.0: irq 40 for MSI/MSI-X
[    2.146913] r8169 0000:02:00.0: eth0: RTL8168c/8111c at 0xffffc9000067e000, 6c:f0:49:7a:b7:cc, XID 1c4000c0 IRQ 40
[    2.160721] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.168187] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.171423] libata version 3.00 loaded.
[    2.173604] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 1
[    2.181195] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    2.189726] 3c59x 0000:03:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.196769] 3c59x: Donald Becker and others.
[    2.201143] 0000:03:06.0: 3Com PCI 3c905 Boomerang 100baseTx at 000000000001cf00.
[    2.231351] ohci1394 0000:03:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.244050] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.251033] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.258418] usb usb1: Product: OHCI Host Controller
[    2.263425] usb usb1: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.268930] usb usb1: SerialNumber: 0000:00:12.0
[    2.273740] hub 1-0:1.0: USB hub found
[    2.277604] hub 1-0:1.0: 3 ports detected
[    2.281856] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.289177] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    2.294569] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 2
[    2.302150] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    2.307991] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[cfffc000-cfffc7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    2.364034] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.370982] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.378421] usb usb2: Product: OHCI Host Controller
[    2.383385] usb usb2: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.388946] usb usb2: SerialNumber: 0000:00:12.1
[    2.393768] hub 2-0:1.0: USB hub found
[    2.397605] hub 2-0:1.0: 3 ports detected
[    2.401888] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.409238] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.414624] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 3
[    2.422245] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    2.488027] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.494996] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.502410] usb usb3: Product: OHCI Host Controller
[    2.507427] usb usb3: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.512926] usb usb3: SerialNumber: 0000:00:13.0
[    2.517758] hub 3-0:1.0: USB hub found
[    2.521610] hub 3-0:1.0: 3 ports detected
[    2.525854] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.533156] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    2.538538] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 4
[    2.546123] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    2.608026] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.614986] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.622383] usb usb4: Product: OHCI Host Controller
[    2.627401] usb usb4: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.632978] usb usb4: SerialNumber: 0000:00:13.1
[    2.637825] hub 4-0:1.0: USB hub found
[    2.641637] hub 4-0:1.0: 3 ports detected
[    2.645934] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.653267] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.658685] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 5
[    2.666289] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    2.732026] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.739001] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.746453] usb usb5: Product: OHCI Host Controller
[    2.751428] usb usb5: Manufacturer: Linux 2.6.36 ohci_hcd
[    2.756917] usb usb5: SerialNumber: 0000:00:14.5
[    2.761777] hub 5-0:1.0: USB hub found
[    2.765660] hub 5-0:1.0: 2 ports detected
[    2.769940] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.777481] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.782937] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 6
[    2.790625] ehci_hcd 0000:00:12.2: debug port 1
[    2.795397] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    2.812054] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.817997] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    2.824952] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.832329] usb usb6: Product: EHCI Host Controller
[    2.837318] usb usb6: Manufacturer: Linux 2.6.36 ehci_hcd
[    2.842866] usb usb6: SerialNumber: 0000:00:12.2
[    2.847701] hub 6-0:1.0: USB hub found
[    2.851548] hub 6-0:1.0: 6 ports detected
[    2.855849] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.863217] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.868592] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 7
[    2.876211] ehci_hcd 0000:00:13.2: debug port 1
[    2.880937] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    2.896056] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.901958] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    2.908917] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.916285] usb usb7: Product: EHCI Host Controller
[    2.921301] usb usb7: Manufacturer: Linux 2.6.36 ehci_hcd
[    2.926796] usb usb7: SerialNumber: 0000:00:13.2
[    2.931614] hub 7-0:1.0: USB hub found
[    2.935477] hub 7-0:1.0: 6 ports detected
[    2.939772] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    2.946832] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.954398] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    2.961624]     ide0: BM-DMA at 0xfa00-0xfa07
[    2.966114] atiixp 0000:00:14.1: simplex device: DMA disabled
[    2.971979] ide1: DMA disabled
[    2.975151] Probing IDE interface ide0...
[    3.544078] Probing IDE interface ide1...
[    3.588179] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[003a0966006cf049]
[    4.104102] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.108841] ide1 at 0x170-0x177,0x376 on irq 15
[    4.113668] ahci 0000:00:11.0: version 3.0
[    4.113683] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.120801] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.129152] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    4.138018] scsi0 : ahci
[    4.140802] scsi1 : ahci
[    4.143525] scsi2 : ahci
[    4.146219] scsi3 : ahci
[    4.148946] scsi4 : ahci
[    4.151632] scsi5 : ahci
[    4.154358] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    4.161893] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    4.169449] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    4.177010] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    4.184559] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    4.192102] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    4.516078] ata4: SATA link down (SStatus 0 SControl 300)
[    4.516142] ata3: SATA link down (SStatus 0 SControl 300)
[    4.516186] ata5: SATA link down (SStatus 0 SControl 300)
[    4.516227] ata6: SATA link down (SStatus 0 SControl 300)
[    4.688060] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.688560] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.688820] ata2.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102HD, max UDMA/133
[    4.688824] ata2.00: 78165360 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.689080] ata2.00: configured for UDMA/133
[    4.720185] ata1.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102HD, max UDMA/133
[    4.727069] ata1.00: 78165360 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.734042] ata1.00: configured for UDMA/133
[    4.752187] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 2CV1 PQ: 0 ANSI: 5
[    4.760699] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 2CV1 PQ: 0 ANSI: 5
[    4.782669] sd 1:0:0:0: [sdb] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    4.782674] sd 0:0:0:0: [sda] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    4.782746] sd 0:0:0:0: [sda] Write Protect is off
[    4.782749] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.782774] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.783154]  sda: sda1 sda2
[    4.815336] sd 1:0:0:0: [sdb] Write Protect is off
[    4.815396] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.824977] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.825040] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.834662]  sdb: sdb1 sdb2
[    4.837887] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.932765] md: raid1 personality registered for level 1
[    4.944673] md: md0 stopped.
[    4.953404] md: bind<sdb1>
[    4.956419] md: bind<sda1>
[    4.967540] md/raid1:md0: active with 2 out of 2 mirrors
[    4.973014] md0: detected capacity change from 0 to 35998597120
[    4.979233] md: md1 stopped.
[    4.981142]  md0: unknown partition table
[    5.023019] EXT3-fs: barriers not enabled
[    5.027421] kjournald starting.  Commit interval 5 seconds
[    5.027455] EXT3-fs (md0): mounted filesystem with writeback data mode
[    5.250966] udevd version 125 started
[    5.524398] input: PC Speaker as /class/input/input1
[    5.605992] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.618541] ACPI: acpi_idle registered with cpuidle
[    5.629723] input: Power Button as /class/input/input2
[    5.635078] ACPI: Power Button [PWRB]
[    5.637239] ACPI: WMI: Mapper loaded
[    5.642615] input: Power Button as /class/input/input3
[    5.647867] ACPI: Power Button [PWRF]
[    5.688020] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f]
[    5.698920] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.732031] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602 ss_vid 1022 ss_did 9602
[    5.740442] shpchp 0000:00:01.0: Cannot reserve MMIO region
[    5.768022] shpchp 0000:00:0a.0: HPC vendor_id 1022 device_id 9609 ss_vid 1022 ss_did 9601
[    5.776395] shpchp 0000:00:0a.0: Cannot reserve MMIO region
[    5.782109] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.853688] parport_pc 00:0a: reported by Plug and Play ACPI
[    5.859591] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    5.873870] Error: Driver 'pcspkr' is already registered, aborting...
[    5.960033] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.997815] HDLC support module revision 1.22
[    6.040078] PC300 0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.201322] pc300: PC300/RSV, 256 KB RAM at 0xfdc80000, IRQ21, using 10 TX + 71 RX packets rings
[    6.210649] hdlc0: PC300 channel 0
[    6.214407] hdlc1: PC300 channel 1
[    6.261377] hda_codec: ALC889A: BIOS auto-probing.
[    6.272233] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.279685] HDA Intel 0000:01:05.1: setting latency timer to 64
[    6.986897] EXT3-fs (md0): using internal journal
[    8.015522] loop: module loaded
[    8.052997] md: md1 stopped.
[    8.072959] md: bind<sdb2>
[    8.102415] md/raid1:md1: active with 1 out of 2 mirrors
[    8.107893] md1: detected capacity change from 0 to 4016177152
[    8.114443]  md1: unknown partition table
[    8.169943] Adding 3922044k swap on /dev/md1.  Priority:-1 extents:1 across:3922044k 
[    8.275781] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.295476] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.401941] r8169 0000:02:00.0: eth0: link up
[    8.405942] r8169 0000:02:00.0: eth0: link up
[    8.448733] eth1:  setting full-duplex.
[    8.491742] hdlc0: Carrier detected
[    8.818002] NET: Registered protocol family 10
[    8.823034] lo: Disabled Privacy Extensions
[   16.233712] hdlc0: Link up (peer uptime 0d18h55m19s)
[   19.488046] eth0: no IPv6 routers present
[   19.584022] eth1: no IPv6 routers present
[   59.175900] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[   59.176639] bernie: cp=3b4, bp=1ef18, len=56, unused=12
[   59.184040] bernie: hdlc0 TX(1504): 0F 00 08 00 45 00 05 DC E6 3B 40 00 3F 06 A1 DB C7 E8 4C A5 62 89 36 EE ED 41 00 19 82 4F FB AD B5 E8 FC F2 80 10 00 5C 19 D1 00 00 01 01 08 0A 41 46 1E 20 CE D6 C0 D2 72 73 61 2D 73 68 61 31 3B 20 63 3D 6E 6F 66 77 73 3B 20 64 3D 67 6D 61 69 6C 2E 63 6F 6D 3B 20 73 3D 67 61 6D 6D 61 3B 0D 0A 09 68...
[   67.159314] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   67.163214] bernie: cp=39c, bp=1e298, len=56, unused=12
[   67.168039] bernie: hdlc0 TX(62): 0F 00 08 00 45 00 00 3A 3D 62 40 00 3F 11 16 AA C7 E8 4C A5 8C BA 46 5F 84 2D 00 35 00 26 27 6E 0B A1 01 00 00 01 00 00 00 00 00 00 04 6D 78 31 30 03 67 6E 75 03 6F 72 67 00 00 01 00 01
[   68.425601] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   68.426123] bernie: cp=39c, bp=1e298, len=77, unused=12
[   68.426123] bernie: hdlc0 TX(69): 0F 00 08 00 45 00 00 41 42 5A 40 00 3F 11 11 AB C7 E8 4C A5 8C BA 46 5F CC E7 00 35 00 2D 6F 55 21 B4 01 00 00 01 00 00 00 00 00 00 01 65 02 6D 78 04 6D 61 69 6C 05 79 61 68 6F 6F 03 63 6F 6D 00 00 1C 00 01
[   70.312068] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[   70.314393] bernie: cp=3c0, bp=1f558, len=1504, unused=12
[   70.314393] bernie: hdlc0 TX(1474): 0F 00 08 00 45 00 05 BE 66 F5 40 00 3F 06 23 1F C7 E8 4C A5 4A 7D 4D 1B A9 3E 00 19 8E ED 22 77 3D 22 95 EF 80 10 00 5C 16 44 00 00 01 01 08 0A 41 46 49 A8 C4 92 9B A9 52 65 63 65 69 76 65 64 3A 20 66 72 6F 6D 20 5B 31 32 37 2E 30 2E 30 2E 31 5D 20 28 70 6F 72 74 3D 34 37 39 30 37 20 68 65 6C 6F 3D...
[   70.443466] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[   70.444392] bernie: cp=3a8, bp=1e8d8, len=76, unused=12
[   70.444392] bernie: hdlc0 TX(1504): 0F 00 08 00 45 00 05 DC 73 8B 40 00 3F 06 A4 58 C7 E8 4C A5 C3 9F 46 0B E0 A0 00 19 8A CF 46 5D 86 1E C0 30 80 10 00 5C 18 2A 00 00 01 01 08 0A 41 46 4A 05 16 CF 9B 47 52 65 63 65 69 76 65 64 3A 20 66 72 6F 6D 20 5B 31 32 37 2E 30 2E 30 2E 31 5D 20 28 70 6F 72 74 3D 36 30 35 31 34 20 68 65 6C 6F 3D...
[   73.776240] bernie: stat=0x80, desc_address=ffffc90011100384, port->chan=0
[   73.780127] bernie: cp=390, bp=1dc58, len=273, unused=12
[   73.780127] bernie: hdlc0 TX(64): 0F 00 08 00 45 00 00 3C 92 BA 40 00 3F 06 C1 8E C7 E8 4C AC 8C BA 46 24 A2 6C 00 50 30 AB 36 DE 00 00 00 00 A0 02 16 D0 5F B2 00 00 02 04 05 B4 04 02 08 0A 3B 60 A4 64 00 00 00 00 01 03 03 07
[   78.215881] bernie: stat=0x80, desc_address=ffffc90011100360, port->chan=0
[   78.219613] bernie: cp=36c, bp=1c998, len=50, unused=12
[   78.219613] bernie: hdlc0 TX(323): 0F 00 08 00 45 00 01 3F C7 32 40 00 3F 06 8C 2A C7 E8 4C AC 8C BA 46 0D BE 90 00 19 34 B2 6F C4 CD CF 00 43 80 18 00 42 18 EE 00 00 01 01 08 0A 3B 60 A8 BD 90 88 EA 5A 16 03 01 01 06 10 00 01 02 01 00 97 89 09 5E 3E E2 01 34 A2 1C B4 4F 66 13 96 6B 2F 5A EA 65 91 3D 51 ED 00 9D 64 7C E1 33 ED 1A 3B...
[   92.256355] bernie: stat=0x80, desc_address=ffffc900111003c0, port->chan=0
[   92.260297] bernie: cp=354, bp=1fb98, len=1504, unused=12
[   92.260297] bernie: hdlc0 TX(382): 0F 00 08 00 45 00 01 7A E2 75 40 00 3F 06 C9 DE C7 E8 4C A5 48 22 31 7A BC 9F 00 19 A2 BC 7F 4F 35 96 74 35 80 18 01 32 51 17 00 00 01 01 08 0A 41 46 9F 59 39 53 59 DD 16 03 01 01 06 10 00 01 02 01 00 42 79 A7 4B B8 36 6A 84 71 CA 57 84 92 AC 5A E5 05 49 F1 35 89 E6 AC E2 B8 1D 93 95 76 98 84 82 1E...
[   99.097689] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
[   99.100726] bernie: cp=39c, bp=1e298, len=1504, unused=12
[   99.100726] bernie: hdlc0 TX(93): 0F 00 08 00 45 00 00 59 26 08 40 00 3F 06 7D 1C C7 E8 4C A5 82 88 01 65 E6 D9 00 19 98 8C 66 3C 6E C4 D3 B7 80 18 00 BD 89 CA 00 00 01 01 08 0A 41 46 BA 32 3F BF 92 AF 15 03 01 00 20 50 35 A1 23 AC CD ED 7C 8F 33 2E 3F 82 0E 88 FD 80 90 70 B7 30 72 68 9E 8A 37 73 D2 63 71 2B 31
[  106.656297] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[  106.658742] bernie: cp=3c0, bp=1f558, len=1474, unused=12
[  106.658742] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 24 32 40 00 3F 06 30 BD C7 E8 4C A5 4A 06 88 41 9A 7A 00 19 B0 87 F3 65 91 47 BB 65 80 10 00 5C E7 91 00 00 01 01 08 0A 41 46 D7 AA 93 5B 70 7F
[  109.223945] bernie: stat=0x80, desc_address=ffffc90011100378, port->chan=0
[  109.226964] bernie: cp=384, bp=1d618, len=56, unused=12
[  109.226964] bernie: hdlc0 TX(437): 0F 00 08 00 45 00 01 B1 82 CD 40 00 3F 06 0B 54 C7 E8 4C A5 4A 7D 4D 1B AC 03 00 19 B2 1D 73 91 FD 5E 3C 05 80 18 00 5C 58 B7 00 00 01 01 08 0A 41 46 E1 C1 C7 5D 6E D7 6F 6E 6D 65 6E 74 20 62 65 66 6F 72 65 20 70 72 69 6E 74 69 6E 67 20 74 68 69 73 20 65 6D 61 69 6C 0D 0A 3E 0D 0A 3E 20 5F 5F 5F 5F...
[  137.824245] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[  137.826918] bernie: cp=3a8, bp=1e8d8, len=56, unused=12
[  137.826918] bernie: hdlc0 TX(62): 0F 00 08 00 45 00 00 3A 04 B6 40 00 3F 06 FF E1 C7 E8 4C A5 11 94 11 05 DE 68 00 19 C9 B3 4B 2C C1 7D 20 BA 80 18 00 6C 79 0A 00 00 01 01 08 0A 41 47 51 6E 0E 44 A7 CB 51 55 49 54 0D 0A
[  146.835503] bernie: stat=0x80, desc_address=ffffc90011100378, port->chan=0
[  146.837804] bernie: cp=384, bp=1d618, len=1504, unused=12
[  146.837804] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 0F 68 40 00 3F 06 80 36 C7 E8 4C A5 4A 7D 4D 1B AE 8A 00 19 D6 0A 7C 87 4D 04 C4 05 80 10 00 5C 4F 8F 00 00 01 01 08 0A 41 47 74 A6 1A 32 98 4C
[  181.782010] bernie: stat=0x80, desc_address=ffffc90011100354, port->chan=0
[  181.784576] bernie: cp=360, bp=1c358, len=1474, unused=12
[  181.784576] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 CA E3 40 00 3F 06 DE 00 C7 E8 4C A5 5E 88 1F CA E5 D1 00 19 F5 34 3E 77 B6 06 48 B6 80 10 01 14 37 FC 00 00 01 01 08 0A 41 47 FD 05 1B 7B 38 B1
[  272.745752] bernie: stat=0x80, desc_address=ffffc90011100360, port->chan=0
[  272.748026] bernie: cp=36c, bp=1c998, len=1474, unused=12
[  272.748026] bernie: hdlc0 TX(81): 0F 00 08 00 45 00 00 4D 60 69 40 00 3F 11 F3 8F C7 E8 4C A5 8C BA 46 5F AE 02 00 35 00 39 51 DC 95 7D 01 00 00 01 00 00 00 00 00 00 04 61 6C 74 34 0D 67 6D 61 69 6C 2D 73 6D 74 70 2D 69 6E 01 6C 06 67 6F 6F 67 6C 65 03 63 6F 6D 00 00 01 00 01
[  294.233029] bernie: stat=0x80, desc_address=ffffc9001110036c, port->chan=0
[  294.235817] bernie: cp=378, bp=1cfd8, len=56, unused=12
[  294.235817] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 30 E8 40 00 3F 06 86 2E C7 E8 4C A5 CC 0D A4 12 D8 49 00 19 60 0A 83 70 C3 A2 9F 6C 80 10 00 5C 2E 12 00 00 01 01 08 0A 41 49 B4 3E 05 52 A9 DA
[  316.166931] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[  316.166931] bernie: cp=3b4, bp=1ef18, len=1474, unused=12
[  316.166931] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 9E FA 40 00 3F 06 EE A3 C7 E8 4C A5 4A 7D 4F 1B D8 D9 00 19 74 7C 97 70 1E D3 84 7F 80 10 00 5C CA 58 00 00 01 01 08 0A 41 4A 09 FA C4 81 65 EA
[  331.715177] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[  331.717278] bernie: cp=3a8, bp=1e8d8, len=198, unused=12
[  331.717278] bernie: hdlc0 TX(254): 0F 00 08 00 45 00 00 FA B8 47 40 00 3F 06 27 74 C7 E8 4C A5 42 6F 04 46 84 07 00 19 81 E2 FA 93 1A 88 32 FB 80 18 01 11 D2 2E 00 00 01 01 08 0A 41 4A 46 AB 0C 6C 6C 3B 16 03 01 00 86 10 00 00 82 00 80 1C 61 03 1E 89 F4 45 85 F1 88 C9 24 E7 61 6F E7 97 1F 7D EF CC 09 1C FB EA 15 2F 17 BD C4 7A 9B 39...
[  378.162278] bernie: stat=0x80, desc_address=ffffc90011100354, port->chan=0
[  378.164352] bernie: cp=360, bp=1c358, len=65, unused=12
[  378.164352] bernie: hdlc0 TX(62): 0F 00 08 00 45 00 00 3A FB FD 40 00 3F 11 58 0E C7 E8 4C A5 8C BA 46 5F DD 40 00 35 00 26 61 A2 78 3E 01 00 00 01 00 00 00 00 00 00 04 6D 78 31 30 03 67 6E 75 03 6F 72 67 00 00 1C 00 01
[  378.589909] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
[  378.592006] bernie: cp=3c0, bp=1f558, len=1504, unused=12
[  378.592006] bernie: hdlc0 TX(373): 0F 00 08 00 45 00 01 71 32 56 40 00 3F 06 88 69 C7 E8 4C A5 80 6B EA CE A9 EC 00 19 AD 6F D8 0D 12 C7 B1 58 50 18 44 70 42 24 00 00 5F 7E F6 30 BD 36 18 E5 48 EC 0E BA 7F 64 4A 52 D6 E2 AB DB F5 79 F6 8A 4D 6B 01 02 54 11 68 89 1A 1B 22 A9 DF 37 EF 64 07 6C 62 2D 5A 88 56 5C F3 E7 2F 24 1B BD B9 7C...
[  378.736328] bernie: stat=0x82, desc_address=ffffc9001110036c, port->chan=0
[  378.740006] bernie: cp=378, bp=1cfd8, len=198, unused=12
[  378.740006] bernie: hdlc0 TX(1504): 0F 00 08 00 45 00 05 DC CD 47 40 00 3F 06 C1 32 C7 E8 4C A9 CF 2E C3 E1 00 50 81 10 94 B4 72 7A 4E 0C 13 8E 50 10 19 20 95 F5 00 00 69 A6 FA 8B AD 3B AA 01 90 A1 65 D5 AD 6E 0E 56 C0 36 05 25 B6 B9 AF BA D2 7E 7A A2 A0 85 4A 24 68 37 AB B8 38 3D B7 09 52 0D 8D AA 4B 01 05 AD 3C DD D5 7C EB CB 85 2C...
[  379.063796] bernie: stat=0x80, desc_address=ffffc9001110036c, port->chan=0
[  379.066167] bernie: cp=378, bp=1cfd8, len=56, unused=12
[  379.066167] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 79 9B 40 00 3F 06 4B 10 C7 E8 4C A5 CF 7E 93 0C C9 D7 00 19 AE BA 84 C3 74 20 B1 8A 80 10 00 6C C9 0C 00 00 01 01 08 0A 41 4A FF 5A 71 C0 60 AC
[  394.457672] bernie: stat=0x80, desc_address=ffffc9001110039c, port->chan=0
[  394.461574] bernie: cp=3a8, bp=1e8d8, len=44, unused=12
[  394.461574] bernie: hdlc0 TX(1474): 0F 00 08 00 45 00 05 BE FB 34 40 00 3F 06 8C DF C7 E8 4C A5 4A 7D 4F 1B DD 52 00 19 BC 90 EB 2E 74 37 B2 F3 80 10 00 5C 0B 22 00 00 01 01 08 0A 41 4B 3B AD C0 2E 86 4D 20 6F 6E 6C 79 20 77 72 69 74 65 20 74 68 65 20 66 69 6C 65 2C 20 72 61 74 68 65 72 20 74 68 61 6E 0D 0A 3E 3E 20 74 72 79 69 6E 67...
[  402.361173] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
[  402.364012] bernie: cp=3b4, bp=1ef18, len=62, unused=12
[  402.364012] bernie: hdlc0 TX(56): 0F 00 08 00 45 00 00 34 3D A4 40 00 3F 06 A3 72 C7 E8 4C A5 40 12 06 0E E1 B6 00 19 C4 0C 6B F6 95 20 43 2D 80 10 00 6C 3E C2 00 00 01 01 08 0A 41 4B 5A 47 08 58 4E D6
[  520.614583] bernie: stat=0x80, desc_address=ffffc90011100378, port->chan=0
[  520.618174] bernie: cp=384, bp=1d618, len=56, unused=12
[  520.618174] bernie: hdlc0 TX(93): 0F 00 08 00 45 00 00 59 5D 9D 40 00 3F 06 0E 9A C7 E8 4C A5 59 91 61 49 EA EA 00 19 2C E2 62 45 5D 93 A7 5A 80 18 03 DB 6F 6F 00 00 01 01 08 0A 41 4D 28 79 1A A5 41 5F 17 03 01 00 20 69 A6 32 DA 13 C4 A6 EB 4B C6 55 B2 48 D2 CB 8C 02 61 87 FC B8 FB AF 79 3B 93 71 42 54 43 F5 C2

--=-jgcCTJp9Xl8Eh3JxyeXW
Content-Type: image/jpeg; name="pc300too-photo.jpg"
Content-Disposition: attachment; filename="pc300too-photo.jpg"
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEBLAEsAAD/7QAoUGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAscAlAABkJl
cm5pZQD/4RIoRXhpZgAASUkqAAgAAAAJAA8BAgAGAAAAngAAABABAgAFAAAApAAAABIBAwABAAAA
AQAAABoBBQABAAAAegAAABsBBQABAAAAggAAACgBAwABAAAAAgAAADIBAgAUAAAAigAAABMCAwAB
AAAAAQAAAGmHBAABAAAAqgAAAAAAAAAsAQAAAQAAACwBAAABAAAAMjAxMDoxMToxNiAxMjozNDo0
NQBOb2tpYQBOOTAwAAAZAJqCBQABAAAA9BEAAJ2CBQABAAAA/BEAACKIAwABAAAAAAAAACeIAwAB
AAAAyAAAAACQBwAEAAAAMDIxMAOQAgAUAAAADBIAAAGRBwAAAAAAAAAAAAGSCgABAAAA7BEAAAKS
BQABAAAA5BEAAAiSAwABAAAAAAAAAAmSAwABAAAAAAAAAAqSBQABAAAABBIAAHySBwAAEAAA3AEA
AACgBwAEAAAAMDEwMAGgAwABAAAAAQAAAAKgBAABAAAAAAgAAAOgBAABAAAAAAYAAAGkAwABAAAA
AAAAAAKkAwABAAAAAAAAAAOkAwABAAAAAAAAAASkBQABAAAA3BEAAAakAwABAAAAAAAAAAekAwAB
AAAAAwAAAAikAwABAAAAAAAAAAmkAwABAAAAAAAAAAAAAAARAgQJABAAgFHtQMfF5QTC2OLwikas
EIVMf4iD4jpOFDcGRz00PPTRFH8VXgjFEHmZUg1IbqiG+CM3Bi7o5dNZU1l4kWE2uywRuATCMo8Z
fBvTKHq2wAsT+4hSVGAGv0O8jRP1Kaqq5tebfizkEuYLP8xvwmDUo2CNW3ZZDk5uGWCueDpPISKd
dY3alqiTay/kS4FVfMZsO0oHkAyyR72O2+RjOKe32BiT56AcWCQIpC7dtme1So4dQ1RQpQesHbXv
tPWWAyZ1nJer+jC/Jiu6Y0VOGspuNuV4bjTWw26DzNRq5hgfavp/1tIN4dbT8nGInrDjt9Wq4hqi
wwNkcHyy+KxgH0RtwPkZi1/8Rl2ALY1qc0IeHqjFEB++miBQu38CJr+vez02ohTqDVuRD4dvtcw2
mKEf+IPbB7fH4D/y4gcGqNaLVbJUxvCGu8QtMrbfi92ZcTnNrS5FYAbnzhO9eI3CNBe315t+LOQS
ayMROaE8pEAdKCh+jH+VUNyH5jc5Og4hxJ0mXw+WQpNFjunK3lVNxpc7i2wU3BCI+I6n5FA/TuZl
GErnvRwLJDmknKkrSLVKdCOXjwNglJJ6/8Vja7kNEXWcXK36ME0e+y0bVEQaJujs5dYGubHPmNrM
t6y3SjNq+n/W0g3h1tPycUeAPrLQCRkzcB/65fxbBeN36AvbXpi/7UDHxeUEwtji8IpGrBCFTH+I
g+I6ThQ3Bkc9NDz00RR/FV4IxRB5mVINSG6ohvgjNwYu6OXTWVNZeJFhNrssEbgEwjKPGXwb0yh6
tsALE/uIUlTBY5KGvI0T9SmqDubGLntlAr238DigN8JUX10bLXRp8dxNDCi3bzk6DiHEnSZfD5ZC
k0WO6creVU3GlzuLbBTcEIj4jqfkUD9O5mUYSue9HAskOaScqStItUp0I5ePA2CUknr/xWNruQ0R
dZxcrfowTR77LRtURBom6Ozl1ga5sc+Y2sy3rLdKM2r6f9bSDeHW0/JxR4A+stAJGTMMAcMDeaUF
46+n8KZ7otjYiSz2A7ahVjO2P7Bq35B08atqFun9671jPsCpDRQUGPHWQZmFU/yZUjdn6tNnz1tv
zZOxA32Rme5ojUzsbeIynuYoeFIZlUyogoGsJDxd40ePRWAGv0O8jT95oRnz1sibSVaAEvtqxczb
Ly/gvyc5awhu/Qqf48o3pPBLkW5mIOAp0MuDVLvpyumyCtfmirwHzEfaR141DwJ3jPu3popXmip+
S8D3vifdKsIfGCt0c1LlwWi/0h3FY/lePPIgcK2fuacNdzJutUUl/xGna0zDY0GRAPc3XflqZBAP
rKJcgnoNVrGoESpHgKMtltWhrriis+TbpYQjQaebVgT3/fJalTouKBZO0vwa/qDhxU3YBZPi1EQx
b2NHPTwl4Z0l7Y1BPWs//IaMTWeOSyVy8UoVmxcLb+5aEdMhCNtMZU3z2xZFUqoFiagoevY68Hhk
FXVFzTSXQ9hmQaS+O0C3sk7HLEhmmws4+7wWUiOTiSJ8Rn+4CtyH5jc5OspPjdHyw27QYztmu+fd
fz12a95LE8MrDOHiJLvxAp04jE8SSpOp02TawOv1zt0rSJmFa4CBUEvBFTvrHQh3wjTn/BrOGYJF
TwCGv7otht2KJ0HKA/w/3dax91eg5mq3Sttxw/HsMqD0ZivpKuH+hOOhoqLiK7PtAyyihLIpwsum
JQNz2Iu99gPwFu0zCxpGrBdKr/GDA4/pXzxPY4eLDg3NYDrx1uaChQMB2o/BVErT+LyCb5rnjAOJ
8RDuEyFhNo5l8p4nFiBSqgWJqIfSbSTweCtHj0VgBr9DfcR4pKEZF7fXm34s5BLuCz/MbxZUX6OJ
umt2fwwK3IfmN+vpF5GN0crggtDLg1S7OiYlPQrXXEtaBzEMU0dyu+gC7zhO5ixKGJoSZPDA6/XO
3ftnyBhrgFxS5cFov9IdhQZ0NDzy/s6Xn8NPCneUuolFToom6DYDsWM01s33V6DmauYY4qzD8bF6
PPSxqBEqiCOw45bVquIVosMDeaV8sh6n8KZemJLYhJWFAycW7TMLGtRqU8Wv8UeTM+lEMW9jiFW5
DeGdMfFwQZmFU/wIjzxn6tOG+IBvY5unA6juEO4TIUnsjmXynicWIFKqBYmoh9JtJPB4K0ePRWAG
v0N9xHikoRkO5tebfizkEuYLP8xvFkXgo4m6a3Z/DArch+Y36+kXkY3RyuCC0MuDVLsiJiU9CteX
O1oHMQxTR3K76ALvOES3LEoYmhJk8MDr9c7d+2fIGGuAXFLlwWi/0h3FY2u5DRF1nFyt+jBNHvst
G1REGibo7OXWBrmxz5jazLest0ozavp/1tIN4dbT8nFHgD6y0AkZM3Af+uX8WwXjd+gL216Yv+1A
x8XlBMLY4vCKRqwQhUx/iIPiOk4UNwZHPTQ89NEUfxVeCMUQeZlSDUhuqIb4IzcGLujl01lTWXiR
YTa7LBG4BMIyjxl8G9MoerbACxP7iFJUwWOShryNE/Upqg7mxi57ZQK9t/A4oDfCVF9dGy10afHc
TQwot285Og4hxJ0mXw+WQpNFjunK3lVNxpc7i2wU3BCI+I6n5FA/TuZlGErnvRwLJDmknKkrSLVK
dCOXjwNglJJ6/8Vja7kNEXWcXK36ME0e+y0bVEQaJujs5dYGubHPmNrMt6y3SjNq+n/W0g3h1tPy
cUeAPrLQCRkzcB/65fxbBeN36AvbXpi/7UDHxeUEwtji8IpGrBCFTH+Ig+I6ThQ3Bkc9NDz00RR/
FV4IxRB5mVINSG6ohvgjNwYu6OXTWVNZeJFhNrssEbgEwjKPGXwb0yh6tsALE/uIUlTBY5KGvI0T
9SmqDubGLntlAr238DigN8JUX10bLXRp8dxNDCi3bzk6DiHEnSZfD5ZCk0WO6creVU3GlzuLbBTc
EIj4jqfkUD9O5mUYSue9HAskOaScqStItUp0I5ePA2CUknr/xWNruQ0RdZxcrfowTR77LRtURBom
6Ozl1ga5sc+Y2sy3rLdKM2r6f9bSDeHW0/JxR4A+stAJGTNwH/rl/FsF43foC9temL/tQMfF5QTC
2OLwikasEIVMf4iD4jpOFDcGRz00PPTRFH8VXgjFEHmZUg1IbqiG+CM3Bi7o5dNZU1l4kWE2uywR
uATCMo8ZfBvTKHq2wAsT+4hSVMFjkoa8jRP1KaoO5sYue2UCvbfwOKA3wlRfXRstdGnx3E0MKLdv
OToOIcSdJl8PlkKTRY7pyt5VTcaXO4tsFNwQiPiOp+RQP07mZRhK570cCyQ5pJypK0i1SnQjl48D
YJSSev/FY2u5DRF1nFyt+jBNHvstG1REGibo7OXWBrmxz5jazLest0ozavp/1tIN4dbT8nFHgD6y
0AkZM3Af+uX8WwXjd+gL216Yv+1Ax8XlBMLY4vCKRqwQhUx/iIPiOk4UNwZHPTQ89NEUfxVeCMUQ
eZlSDUhuqIb4IzcGLujl01lTWXiRYTa7LBG4BMIyjxl8G9MoerbACxP7iFJUwWOShryNE/Upqg7m
xi57ZQK9t/A4oDfCVF9dGy10afHcTQwot285Og4hxJ0mXw+WQpNFjunK3lVNxpc7i2wU3BCI+I6n
5FA/TuZlGErnvRwLJDmknKkrSLVKdCOXjwNglJJ6/8Vja7kNEXWcXK36ME0e+y0bVEQaJujs5dYG
ubHPmNrMt6y3SjNq+n/W0g3h1tPycUeAPrLQCRkzcB/65fxbBeN36AvbXpi/7UDHxeUEwtji8IpG
rBCFTH+Ig+I6ThQ3Bkc9NDz00RR/FV4IxRB5mVINSG6ohvgjNwYu6OXTWVNZeJFhNrssEbgEwjKP
GXwb0yh6tsALE/uIUlTBY5KGvI0T9SmqDubGLntlAr238DigN8JUX10bLXRp8dxNDCi3bzk6DiHE
nSZfD5ZCk0WO6creVU3GlzuLbBTcEIj4jqfkUD9O5mUYSue9HAskOaScqStItUp0I5ePA2CUknr/
xWNruQ0RdZxcrfowTR77LRtURBom6Ozl1ga5sc+Y2sy3rLdKM2r6f9bSDeHW0/JxR4A+stAJGTNw
H/rl/FsF43foC9temL/tQMfF5QTC2OLwikasEIVMf4iD4jpOFDcGRz00PPTRFH8VXgjFEHmZUg1I
bqiG+CM3Bi7o5dNZU1l4kWE2uywRuATCMo8ZfBvTKHq2wAsT+4hSVMFjkoa8jRP1KaoO5sYue2UC
vbfwOKA3wlRfXRstdGnx3E0MKLdvOToOIcSdJl8PlkKTRY7pyt5VTcaXO4tsFNwQiPiOp+RQP07m
ZRhK570cCyQ5pJypK0i1SnQjl48DYJSSev/FY2u5DRF1nFyt+jBNHvstG1REGibo7OXWBrmxz5ja
zLest0ozavp/1tIN4dbT8nFHgD6y0AkZM3Af+uX8WwXjd+gL216Yv+1Ax8XlBMLY4vCKRqwQhUx/
iIPiOk4UNwZHPTQ89NEUfxVeCMUQeZlSDUhuqIb4IzcGLujl01lTWXiRYTa7LBG4BMIyjxl8G9Mo
erbACxP7iFJUwWOShryNE/Upqg7mxi57ZQK9t/A4oDfCVF9dGy10afHcTQwot285Og4hxJ0mXw+W
QpNFjunK3lVNxpc7i2wU3BCI+I6n5FA/TuZlGErnvRwLJDmknKkrSLVKdCOXjwNglJJ6/8Vja7kN
EXWcXK36ME0e+y0bVEQaJujs5dYGubHPmNrMt6y3SjNq+n/W0g3h1tPycUeAPrLQCRkzcB/65fxb
BeN36AvbXpi/7UDHxeUEwtji8IpGrBCFTH+Ig+I6ThQ3Bkc9NDz00RR/FV4IxRB5mVINSG6ohvgj
NwYu6OXTWVNZeJFhNrssEbgEwjKPGXwb0yh6tsALE/uIUlTBY5KGvI0T9SmqDubGLntlAr238Dig
N8JUX10bLXRp8dxNDCi3bzk6DiHEnSZfD5ZCk0WO6creVU3GlzuLbBTcEIj4jqfkUD9O5mUYSue9
HAskOaScqStItUp0I5ePA2CUknr/xWNruQ0RdZxcrfowTR77LRtURBom6Ozl1ga5sc+Y2sy3rLdK
M2r6f9bSDeHW0/JxR4A+stAJGTNwH/rl/FsF43foC9temL/tQMfF5QTC2OLwikasEIVMf4iD4jpO
FDcGRz00PPTRFH8VXgjFEHmZUg1IbqiG+CM3Bi7o5dNZU1l4kWE2uywRuATCMo8ZfBvTKHq2wAsT
+4hSVMFjkoa8jRP1KaoO5sYue2UCvbfwOKA3wlRfXRstdGnx3E0MKLdvOToOIcSdJl8PlkKTRY7p
yt5VTcaXO4tsFNwQiPiOp+RQP07mZRhK570cCyQ5pJypK0i1SnQjl48DYJSSev/FY2u5DRF1nFyt
+jBNHvstG1REGibo7OXWBrmxz5jazLest0ozavp/1tIN4dbT8nFHgD6y0AkZM3Af+uX8WwXjd+gL
216Yv+1Ax8XlBMLY4vCKRqwQhUx/iIPiOk4UAQAAAAEAAAApAQAAZAAAAAQAAAABAAAABwAAAMgA
AAAOAAAABQAAABoAAAAFAAAAMjAxMDoxMToxNiAxMjozNDo0NQD/4QG0aHR0cDovL25zLmFkb2Jl
LmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pO
VGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJF
eGVtcGkgKyBYTVAgQ29yZSA0LjEuMSI+CiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cu
dzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogIDxyZGY6RGVzY3JpcHRpb24gcmRm
OmFib3V0PSIiCiAgICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8i
PgogICA8ZGM6dHlwZT5JbWFnZTwvZGM6dHlwZT4KICAgPGRjOmZvcm1hdD5pbWFnZS9qcGVnPC9k
Yzpmb3JtYXQ+CiAgPC9yZGY6RGVzY3JpcHRpb24+CiA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgog
Cjw/eHBhY2tldCBlbmQ9InciPz7/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcU
FhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgo
KCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAMABAADASIA
AhEBAxEB/8QAHAAAAQUBAQEAAAAAAAAAAAAAAgEDBAUGAAcI/8QAWxAAAQMDAwIEAwUFBQUEBgAX
AQIDEQAEIQUSMQZBEyJRYRRxgQcykaGxFSNCwdEkM1Ji8BY0cuHxJUOCkggXJlNzotI1Y6OywjZE
ZJOz4idUdNNFVYOElMPE/8QAGwEAAwEBAQEBAAAAAAAAAAAAAAECAwQFBgf/xAA0EQACAgICAQMD
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
X50NaEz/2Z==


--=-jgcCTJp9Xl8Eh3JxyeXW--

