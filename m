Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1IPMnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:43:35 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:34159 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab1IPMnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:43:31 -0400
Message-ID: <4E734467.3040703@bootc.net>
Date: Fri, 16 Sep 2011 13:43:19 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: iommu_iova leak
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

My home server, running a variety of 3.1-rc kernels (currently on -rc6 
as at 003f6c9) seems to be exhibiting a leak of iommu_iova slab objects.

At approx 10:25 today:
iommu_iova         77655  77703     64   59    1 : tunables  120   60    
8 : slabdata   1317   1317     60

At approx 13:15 today:
iommu_iova         88205  88205     64   59    1 : tunables  120   60    
8 : slabdata   1495   1495     60

At approx 13:40 today:
iommu_iova         89680  89680     64   59    1 : tunables  120   60    
8 : slabdata   1520   1520    120

In the very short term the number is up and down by a few hundred 
objects but the general trend is constantly upwards. After about 5 days' 
uptime I have some very serious IO slowdowns (narrowed down by a friend 
to SCSI command queueing) with a lot of time spent in
alloc_iova() and rb_prev() according to 'perf top'. Eventually these 
translate into softlockups and the machine becomes almost unusable.

I have only fairly recently started booting with intel_iommu=on and I 
haven't kept a kernel long enough to test with iommu_off to make sure 
that my hangups are caused by this, but it seems a good candidate.

I've included a dmesg below. Some non-obvious things: I'm using the LIO 
iSCSI target backed by iblock devices on LVM.

Thanks,
Chris

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc6+ (bootc@tarquin) (gcc version 
4.6.1 (Debian 4.6.1-4) ) #1 SMP Thu Sep 15 09:51:34 BST 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.1.0-rc6+ 
root=/dev/mapper/vg0-rootfs ro console=tty0 console=ttyS0,115200n8 
video=vesafb:mtrr:3,ywrap intel_iommu=on
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
[    0.000000]  BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ab997000 (usable)
[    0.000000]  BIOS-e820: 00000000ab997000 - 00000000bba18000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bba18000 - 00000000bead6000 (usable)
[    0.000000]  BIOS-e820: 00000000bead6000 - 00000000beae1000 (reserved)
[    0.000000]  BIOS-e820: 00000000beae1000 - 00000000bed17000 (usable)
[    0.000000]  BIOS-e820: 00000000bed17000 - 00000000bede0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bede0000 - 00000000befe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000befe0000 - 00000000befff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000befff000 - 00000000bf000000 (usable)
[    0.000000]  BIOS-e820: 00000000bf000000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed19000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Intel Corporation S1200BTL/S1200BTL, BIOS 
S1200BT.86B.01.00.0028.060220111153 06/02/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 200000000 mask E00000000 write-back
[    0.000000]   4 base 400000000 mask FC0000000 write-back
[    0.000000]   5 base 0FF800000 mask FFF800000 write-protect
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] last_pfn = 0xbf000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fc910] fc910
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf000000
[    0.000000]  0000000000 - 00bf000000 page 2M
[    0.000000] kernel direct mapping tables up to bf000000 @ 
bed13000-bed17000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 2M
[    0.000000] kernel direct mapping tables up to 440000000 @ 
43ffee000-440000000
[    0.000000] RAMDISK: 3696a000 - 374ad000
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000beffde18 000BC (v01  INTEL S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: FACP 00000000beffcd98 000F4 (v04 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: DSDT 00000000befee018 0CB35 (v02  INTEL S1200BTL 
00000000 INTL 20100331)
[    0.000000] ACPI: FACS 00000000beffdd40 00040
[    0.000000] ACPI: APIC 00000000beffb018 00652 (v03 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 00000000beffec18 00040 (v05 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000beffeb98 0003C (v01 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: WDDT 00000000beffef18 00040 (v01 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: HPET 00000000beffee98 00038 (v01 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000befe3018 010A8 (v02 INTEL  S1200BTL 
00001000 INTL 20100331)
[    0.000000] ACPI: BOOT 00000000beffee18 00028 (v01 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000befeb818 007C3 (v02 INTEL  S1200BTL 
00003000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000befec018 00996 (v02 INTEL  S1200BTL 
00003000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000befed698 0062C (v01 INTEL  S1200BTL 
00001000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000beffdb18 00069 (v01 INTEL  S1200BTL 
00001000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000befe9e18 0017B (v02 INTEL  S1200BTL 
00002000 INTL 20100331)
[    0.000000] ACPI: DMAR 00000000befe8f18 000B0 (v01 INTEL  S1200BTL 
00000001 INTL 00000001)
[    0.000000] ACPI: SPCR 00000000beffed98 00050 (v01 INTEL  S1200BTL 
06222004 INTL 20090903)
[    0.000000] ACPI: HEST 00000000beffcf18 000A8 (v01 INTEL  S1200BTL 
00000001 INTL 00000001)
[    0.000000] ACPI: BERT 00000000beffed18 00030 (v01 INTEL  S1200BTL 
00000001 INTL 00000001)
[    0.000000] ACPI: ERST 00000000befe8c98 00230 (v01 INTEL  S1200BTL 
00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 00000000beffc918 00130 (v01 INTEL  S1200BTL 
00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000440000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000440000000
[    0.000000]   NODE_DATA [000000043fffb000 - 000000043fffffff]
[    0.000000]  [ffffea0000000000-ffffea000edfffff] PMD -> 
[ffff88042f800000-ffff88043d7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000ab997
[    0.000000]     0: 0x000bba18 -> 0x000bead6
[    0.000000]     0: 0x000beae1 -> 0x000bed17
[    0.000000]     0: 0x000befff -> 0x000bf000
[    0.000000]     0: 0x00100000 -> 0x00440000
[    0.000000] On node 0 totalpages: 4123671
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3918 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 697540 pages, LIFO batch:31
[    0.000000]   Normal zone: 46592 pages used for memmap
[    0.000000]   Normal zone: 3361280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 128 CPUs, 124 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 
000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ab997000 - 
00000000bba18000
[    0.000000] PM: Registered nosave memory: 00000000bead6000 - 
00000000beae1000
[    0.000000] PM: Registered nosave memory: 00000000bed17000 - 
00000000bede0000
[    0.000000] PM: Registered nosave memory: 00000000bede0000 - 
00000000befe0000
[    0.000000] PM: Registered nosave memory: 00000000befe0000 - 
00000000befff000
[    0.000000] PM: Registered nosave memory: 00000000bf000000 - 
00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 
00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 
00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 
00000000fed19000
[    0.000000] PM: Registered nosave memory: 00000000fed19000 - 
00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 
00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 
00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 
00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: 
c0000000:38000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 
nr_cpu_ids:128 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88043e600000 s80768 
r8192 d21632 u131072
[    0.000000] pcpu-alloc: s80768 r8192 d21632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 
010 011 012 013 014 015
[    0.000000] pcpu-alloc: [0] 016 017 018 019 020 021 022 023 024 025 
026 027 028 029 030 031
[    0.000000] pcpu-alloc: [0] 032 033 034 035 036 037 038 039 040 041 
042 043 044 045 046 047
[    0.000000] pcpu-alloc: [0] 048 049 050 051 052 053 054 055 056 057 
058 059 060 061 062 063
[    0.000000] pcpu-alloc: [0] 064 065 066 067 068 069 070 071 072 073 
074 075 076 077 078 079
[    0.000000] pcpu-alloc: [0] 080 081 082 083 084 085 086 087 088 089 
090 091 092 093 094 095
[    0.000000] pcpu-alloc: [0] 096 097 098 099 100 101 102 103 104 105 
106 107 108 109 110 111
[    0.000000] pcpu-alloc: [0] 112 113 114 115 116 117 118 119 120 121 
122 123 124 125 126 127
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 4062738
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.1.0-rc6+ 
root=/dev/mapper/vg0-rootfs ro console=tty0 console=ttyS0,115200n8 
video=vesafb:mtrr:3,ywrap intel_iommu=on
[    0.000000] Intel-IOMMU: enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Queued invalidation will be enabled to support x2apic and 
Intr-remapping.
[    0.000000] Memory: 16165352k/17825792k available (3427k kernel code, 
1331108k absent, 329332k reserved, 3290k data, 560k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:1704 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 133169152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 3092.815 MHz processor.
[    0.000011] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 6185.63 BogoMIPS (lpj=12371260)
[    0.011980] pid_max: default: 131072 minimum: 1024
[    0.017406] Security Framework initialized
[    0.021988] SELinux:  Disabled at boot.
[    0.027406] Dentry cache hash table entries: 2097152 (order: 12, 
16777216 bytes)
[    0.038383] Inode-cache hash table entries: 1048576 (order: 11, 
8388608 bytes)
[    0.047559] Mount-cache hash table entries: 256
[    0.052858] Initializing cgroup subsys cpuacct
[    0.057842] Initializing cgroup subsys memory
[    0.062735] Initializing cgroup subsys devices
[    0.067716] Initializing cgroup subsys freezer
[    0.072675] Initializing cgroup subsys net_cls
[    0.077642] Initializing cgroup subsys blkio
[    0.082444] CPU: Physical Processor ID: 0
[    0.086926] CPU: Processor Core ID: 0
[    0.091021] mce: CPU supports 9 MCE banks
[    0.095504] CPU0: Thermal monitoring enabled (TM1)
[    0.100862] using mwait in idle threads.
[    0.105607] ACPI: Core revision 20110623
[    0.117471] DMAR: Host address width 36
[    0.121753] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.127701] IOMMU 0: reg_base_addr fed91000 ver 1:0 cap 
c9008020660262 ecap f010da
[    0.136159] DMAR: RMRR base: 0x000000bedbe000 end: 0x000000bedd1fff
[    0.143153] DMAR: No ATSR found
[    0.146725] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 0
[    0.152943] HPET id 0 under DRHD base 0xfed91000
[    0.158095] HPET id 0 under DRHD base 0xfed91000
[    0.163248] HPET id 0 under DRHD base 0xfed91000
[    0.168399] HPET id 0 under DRHD base 0xfed91000
[    0.173551] HPET id 0 under DRHD base 0xfed91000
[    0.178704] HPET id 0 under DRHD base 0xfed91000
[    0.183856] HPET id 0 under DRHD base 0xfed91000
[    0.189000] HPET id 0 under DRHD base 0xfed91000
[    0.194226] Enabled Interrupt-remapping
[    0.198505] Enabling x2apic
[    0.201620] Enabled x2apic
[    0.204649] Switched APIC routing to cluster x2apic.
[    0.210561] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.256936] CPU0: Intel(R) Xeon(R) CPU E31220 @ 3.10GHz stepping 07
[    0.370850] Performance Events: PEBS fmt1+, SandyBridge events, Intel 
PMU driver.
[    0.379243] ... version:                3
[    0.383716] ... bit width:              48
[    0.388287] ... generic registers:      8
[    0.392762] ... value mask:             0000ffffffffffff
[    0.398691] ... max period:             000000007fffffff
[    0.404620] ... fixed-purpose events:   3
[    0.409093] ... event mask:             00000007000000ff
[    0.415864] NMI watchdog enabled, takes one hw-pmu counter.
[    0.422193] Booting Node   0, Processors  #1
[    0.426776] smpboot cpu 1: start_ip = 96000
[    0.534895] NMI watchdog enabled, takes one hw-pmu counter.
[    0.541195]  #2
[    0.542954] smpboot cpu 2: start_ip = 96000
[    0.650865] NMI watchdog enabled, takes one hw-pmu counter.
[    0.657170]  #3
[    0.658931] smpboot cpu 3: start_ip = 96000
[    0.766844] NMI watchdog enabled, takes one hw-pmu counter.
[    0.773090] Brought up 4 CPUs
[    0.776404] Total of 4 processors activated (24742.60 BogoMIPS).
[    0.785512] devtmpfs: initialized
[    0.792099] PM: Registering ACPI NVS region at ab997000 (268963840 bytes)
[    0.809151] PM: Registering ACPI NVS region at bede0000 (2097152 bytes)
[    0.816773] print_constraints: dummy:
[    0.821027] NET: Registered protocol family 16
[    0.826061] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.834513] ACPI: bus type pci registered
[    0.839095] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.849488] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.862265] PCI: Using configuration type 1 for base access
[    0.869181] bio: create slab <bio-0> at 0
[    0.873804] ACPI: Added _OSI(Module Device)
[    0.878474] ACPI: Added _OSI(Processor Device)
[    0.883425] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.888674] ACPI: Added _OSI(Processor Aggregator Device)
[    0.896016] ACPI: EC: Look up EC in DSDT
[    0.897596] ACPI: Executed 1 blocks of module-level executable AML code
[    0.930749] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.938012] ACPI: SSDT 00000000bedac718 006A9 (v01  PmRef  Cpu0Cst 
00003001 INTL 20100331)
[    0.947616] ACPI: Dynamic OEM Table Load:
[    0.952115] ACPI: SSDT           (null) 006A9 (v01  PmRef  Cpu0Cst 
00003001 INTL 20100331)
[    0.970985] ACPI: SSDT 00000000bedada98 00303 (v01  PmRef    ApIst 
00003000 INTL 20100331)
[    0.980621] ACPI: Dynamic OEM Table Load:
[    0.985121] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 
00003000 INTL 20100331)
[    1.002822] ACPI: SSDT 00000000bedabd98 00119 (v01  PmRef    ApCst 
00003000 INTL 20100331)
[    1.012411] ACPI: Dynamic OEM Table Load:
[    1.016909] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 
00003000 INTL 20100331)
[    1.035332] ACPI: Interpreter enabled
[    1.039421] ACPI: (supports S0 S1 S5)
[    1.043562] ACPI: Using IOAPIC for interrupt routing
[    1.054739] ACPI: Power Resource [FN00] (off)
[    1.059680] ACPI: Power Resource [FN01] (off)
[    1.064619] ACPI: Power Resource [FN02] (off)
[    1.069558] ACPI: Power Resource [FN03] (off)
[    1.074496] ACPI: Power Resource [FN04] (off)
[    1.079973] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.086509] HEST: Table parsing has been initialized.
[    1.092142] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    1.102835] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.110183] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.117569] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.124952] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    1.133113] pci_root PNP0A08:00: host bridge window [mem 
0x000cc000-0x000cffff]
[    1.141272] pci_root PNP0A08:00: host bridge window [mem 
0x000d0000-0x000d3fff]
[    1.149433] pci_root PNP0A08:00: host bridge window [mem 
0x000d4000-0x000d7fff]
[    1.157593] pci_root PNP0A08:00: host bridge window [mem 
0x000d8000-0x000dbfff]
[    1.165753] pci_root PNP0A08:00: host bridge window [mem 
0x000dc000-0x000dffff]
[    1.173913] pci_root PNP0A08:00: host bridge window [mem 
0x000e0000-0x000e3fff]
[    1.182071] pci_root PNP0A08:00: host bridge window [mem 
0x000e4000-0x000e7fff]
[    1.190222] pci_root PNP0A08:00: host bridge window [mem 
0xc0000000-0xfeafffff]
[    1.198382] pci_root PNP0A08:00: host bridge window [mem 
0xfed40000-0xfed44fff]
[    1.206551] pci 0000:00:00.0: [8086:0108] type 0 class 0x000600
[    1.206578] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.206597] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.206599] pci 0000:00:01.0: PME# disabled
[    1.206644] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    1.206662] pci 0000:00:19.0: reg 10: [mem 0xc0b00000-0xc0b1ffff]
[    1.206670] pci 0000:00:19.0: reg 14: [mem 0xc0b70000-0xc0b70fff]
[    1.206678] pci 0000:00:19.0: reg 18: [io  0x4040-0x405f]
[    1.206723] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.206727] pci 0000:00:19.0: PME# disabled
[    1.206750] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.206769] pci 0000:00:1a.0: reg 10: [mem 0xc0b60000-0xc0b603ff]
[    1.206838] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.206841] pci 0000:00:1a.0: PME# disabled
[    1.206863] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.206920] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.206924] pci 0000:00:1c.0: PME# disabled
[    1.206950] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    1.207008] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.207011] pci 0000:00:1c.4: PME# disabled
[    1.207035] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.207093] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.207097] pci 0000:00:1c.5: PME# disabled
[    1.207126] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.207145] pci 0000:00:1d.0: reg 10: [mem 0xc0b50000-0xc0b503ff]
[    1.207213] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.207217] pci 0000:00:1d.0: PME# disabled
[    1.207236] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    1.207289] pci 0000:00:1f.0: [8086:1c54] type 0 class 0x000601
[    1.207397] pci 0000:00:1f.2: [8086:1c02] type 0 class 0x000106
[    1.207414] pci 0000:00:1f.2: reg 10: [io  0x4090-0x4097]
[    1.207421] pci 0000:00:1f.2: reg 14: [io  0x4080-0x4083]
[    1.207429] pci 0000:00:1f.2: reg 18: [io  0x4070-0x4077]
[    1.207436] pci 0000:00:1f.2: reg 1c: [io  0x4060-0x4063]
[    1.207443] pci 0000:00:1f.2: reg 20: [io  0x4020-0x403f]
[    1.207451] pci 0000:00:1f.2: reg 24: [mem 0xc0b40000-0xc0b407ff]
[    1.207480] pci 0000:00:1f.2: PME# supported from D3hot
[    1.207483] pci 0000:00:1f.2: PME# disabled
[    1.207500] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.207514] pci 0000:00:1f.3: reg 10: [mem 0xc0b30000-0xc0b300ff 64bit]
[    1.207533] pci 0000:00:1f.3: reg 20: [io  0x4000-0x401f]
[    1.207580] pci 0000:01:00.0: [13c1:1005] type 0 class 0x000104
[    1.207591] pci 0000:01:00.0: reg 10: [mem 0xc2000000-0xc3ffffff 
64bit pref]
[    1.207599] pci 0000:01:00.0: reg 18: [mem 0xc0a20000-0xc0a20fff 64bit]
[    1.207605] pci 0000:01:00.0: reg 20: [io  0x3000-0x30ff]
[    1.207615] pci 0000:01:00.0: reg 30: [mem 0xc0a00000-0xc0a1ffff pref]
[    1.207630] pci 0000:01:00.0: supports D1 D2
[    1.207642] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.213474] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    1.213476] pci 0000:00:01.0:   bridge window [mem 0xc0a00000-0xc0afffff]
[    1.213479] pci 0000:00:01.0:   bridge window [mem 
0xc2000000-0xc3ffffff 64bit pref]
[    1.213520] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.219436] pci 0000:03:00.0: [8086:10d3] type 0 class 0x000200
[    1.219467] pci 0000:03:00.0: reg 10: [mem 0xc0900000-0xc091ffff]
[    1.219511] pci 0000:03:00.0: reg 18: [io  0x2000-0x201f]
[    1.219534] pci 0000:03:00.0: reg 1c: [mem 0xc0920000-0xc0923fff]
[    1.219666] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.219674] pci 0000:03:00.0: PME# disabled
[    1.219733] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.225567] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
[    1.225571] pci 0000:00:1c.4:   bridge window [mem 0xc0900000-0xc09fffff]
[    1.225642] pci 0000:04:00.0: [102b:0522] type 0 class 0x000300
[    1.225668] pci 0000:04:00.0: reg 10: [mem 0xc4000000-0xc4ffffff pref]
[    1.225686] pci 0000:04:00.0: reg 14: [mem 0xc0810000-0xc0813fff]
[    1.225706] pci 0000:04:00.0: reg 18: [mem 0xc0000000-0xc07fffff]
[    1.225780] pci 0000:04:00.0: reg 30: [mem 0xc0800000-0xc080ffff pref]
[    1.225867] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    1.231705] pci 0000:00:1c.5:   bridge window [mem 0xc0000000-0xc08fffff]
[    1.231710] pci 0000:00:1c.5:   bridge window [mem 
0xc4000000-0xc4ffffff 64bit pref]
[    1.231767] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive 
decode)
[    1.239641] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    1.239643] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    1.239645] pci 0000:00:1e.0:   bridge window [mem 
0x000a0000-0x000bffff] (subtractive decode)
[    1.239647] pci 0000:00:1e.0:   bridge window [mem 
0x000cc000-0x000cffff] (subtractive decode)
[    1.239648] pci 0000:00:1e.0:   bridge window [mem 
0x000d0000-0x000d3fff] (subtractive decode)
[    1.239650] pci 0000:00:1e.0:   bridge window [mem 
0x000d4000-0x000d7fff] (subtractive decode)
[    1.239652] pci 0000:00:1e.0:   bridge window [mem 
0x000d8000-0x000dbfff] (subtractive decode)
[    1.239653] pci 0000:00:1e.0:   bridge window [mem 
0x000dc000-0x000dffff] (subtractive decode)
[    1.239655] pci 0000:00:1e.0:   bridge window [mem 
0x000e0000-0x000e3fff] (subtractive decode)
[    1.239658] pci 0000:00:1e.0:   bridge window [mem 
0x000e4000-0x000e7fff] (subtractive decode)
[    1.239659] pci 0000:00:1e.0:   bridge window [mem 
0xc0000000-0xfeafffff] (subtractive decode)
[    1.239661] pci 0000:00:1e.0:   bridge window [mem 
0xfed40000-0xfed44fff] (subtractive decode)
[    1.239693] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.239834] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.239878] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    1.239908] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.239937] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.239993] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    1.240258]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.247145]  pci0000:00: ACPI _OSC control (0x15) granted
[    1.257243] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    1.265090] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    1.272945] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    1.282086] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 
14 15)
[    1.289940] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 
14 15)
[    1.297791] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 10 11 12 
14 15)
[    1.305637] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 
14 15)
[    1.313488] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    1.321382] vgaarb: device added: 
PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.330415] vgaarb: loaded
[    1.333434] vgaarb: bridge control possible 0000:04:00.0
[    1.339390] PCI: Using ACPI for IRQ routing
[    1.345440] PCI: pci_cache_line_size set to 64 bytes
[    1.345508] reserve RAM buffer: 000000000009b400 - 000000000009ffff
[    1.345509] reserve RAM buffer: 00000000ab997000 - 00000000abffffff
[    1.345511] reserve RAM buffer: 00000000bead6000 - 00000000bfffffff
[    1.345514] reserve RAM buffer: 00000000bed17000 - 00000000bfffffff
[    1.345516] reserve RAM buffer: 00000000bf000000 - 00000000bfffffff
[    1.345619] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.352633] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.361147] Switching to clocksource hpet
[    1.366586] Switched to NOHz mode on CPU #0
[    1.366665] Switched to NOHz mode on CPU #1
[    1.366669] Switched to NOHz mode on CPU #2
[    1.366679] Switched to NOHz mode on CPU #3
[    1.386239] pnp: PnP ACPI init
[    1.389662] ACPI: bus type pnp registered
[    1.394369] pnp 00:00: [bus 00-3e]
[    1.394371] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.394372] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.394374] pnp 00:00: [io  0x0d00-0xffff window]
[    1.394375] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.394377] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.394378] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.394379] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.394381] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.394382] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.394383] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.394385] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.394386] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.394388] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.394389] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.394390] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.394392] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.394393] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.394395] pnp 00:00: [mem 0xc0000000-0xfeafffff window]
[    1.394396] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.394432] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    1.394456] pnp 00:01: [io  0x0000-0x001f]
[    1.394457] pnp 00:01: [io  0x0081-0x0091]
[    1.394458] pnp 00:01: [io  0x0093-0x009f]
[    1.394460] pnp 00:01: [io  0x00c0-0x00df]
[    1.394461] pnp 00:01: [dma 4]
[    1.394479] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.394486] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.394501] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.394570] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.394587] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.394595] pnp 00:04: [io  0x00f0]
[    1.394603] pnp 00:04: [irq 13]
[    1.394619] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.394627] pnp 00:05: [io  0x002e-0x002f]
[    1.394629] pnp 00:05: [io  0x004e-0x004f]
[    1.394631] pnp 00:05: [io  0x0061]
[    1.394632] pnp 00:05: [io  0x0063]
[    1.394633] pnp 00:05: [io  0x0065]
[    1.394634] pnp 00:05: [io  0x0067]
[    1.394635] pnp 00:05: [io  0x0070]
[    1.394636] pnp 00:05: [io  0x0080]
[    1.394638] pnp 00:05: [io  0x0092]
[    1.394639] pnp 00:05: [io  0x00b2-0x00b3]
[    1.394640] pnp 00:05: [io  0x0680-0x069f]
[    1.394641] pnp 00:05: [io  0xffff]
[    1.394642] pnp 00:05: [io  0xffff]
[    1.394644] pnp 00:05: [io  0xffff]
[    1.394645] pnp 00:05: [io  0x0400-0x0453]
[    1.394646] pnp 00:05: [io  0x0458-0x047f]
[    1.394647] pnp 00:05: [io  0x0500-0x057f]
[    1.394648] pnp 00:05: [io  0x164e-0x164f]
[    1.394650] pnp 00:05: [io  0x0900-0x090f]
[    1.394651] pnp 00:05: [io  0x0295-0x0296]
[    1.394681] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.401296] system 00:05: [io  0xffff] has been reserved
[    1.407234] system 00:05: [io  0xffff] has been reserved
[    1.413158] system 00:05: [io  0xffff] has been reserved
[    1.419092] system 00:05: [io  0x0400-0x0453] has been reserved
[    1.425708] system 00:05: [io  0x0458-0x047f] has been reserved
[    1.432311] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.438921] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.445531] system 00:05: [io  0x0900-0x090f] has been reserved
[    1.452144] system 00:05: [io  0x0295-0x0296] has been reserved
[    1.458756] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.458763] pnp 00:06: [io  0x0070-0x0077]
[    1.458769] pnp 00:06: [irq 8]
[    1.458787] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.458812] pnp 00:07: [io  0x0454-0x0457]
[    1.458839] system 00:07: [io  0x0454-0x0457] has been reserved
[    1.465453] system 00:07: Plug and Play ACPI device, IDs INT3f0d 
PNP0c02 (active)
[    1.465719] pnp 00:08: [io  0x03f8-0x03ff]
[    1.465725] pnp 00:08: [irq 4]
[    1.465727] pnp 00:08: [dma 0 disabled]
[    1.465782] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.466006] pnp 00:09: [io  0x02f8-0x02ff]
[    1.466011] pnp 00:09: [irq 3]
[    1.466013] pnp 00:09: [dma 0 disabled]
[    1.466063] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.466100] pnp 00:0a: [io  0x0ca2-0x0ca3]
[    1.466118] pnp 00:0a: Plug and Play ACPI device, IDs IPI0001 (active)
[    1.466260] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    1.466262] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    1.466263] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    1.466264] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    1.466266] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    1.466267] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    1.466268] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    1.466270] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    1.466271] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    1.466272] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    1.466274] pnp 00:0b: [mem 0xc0b90000-0xc0b90fff]
[    1.466306] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.473695] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.481082] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.488471] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.495860] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.503246] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.510635] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.518024] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.525412] system 00:0b: [mem 0xff000000-0xffffffff] could not be 
reserved
[    1.533187] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    1.540962] system 00:0b: [mem 0xc0b90000-0xc0b90fff] has been reserved
[    1.548349] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.548588] pnp 00:0c: [mem 0x00000000-0x0009cfff]
[    1.548629] system 00:0c: [mem 0x00000000-0x0009cfff] could not be 
reserved
[    1.556407] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.556451] pnp: PnP ACPI: found 13 devices
[    1.561125] ACPI: ACPI bus type pnp unregistered
[    1.572569] PCI: max bus depth: 1 pci_try_num: 2
[    1.572601] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.578438] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    1.585246] pci 0000:00:01.0:   bridge window [mem 0xc0a00000-0xc0afffff]
[    1.592828] pci 0000:00:01.0:   bridge window [mem 
0xc2000000-0xc3ffffff 64bit pref]
[    1.601475] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.607320] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.613156] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
[    1.619965] pci 0000:00:1c.4:   bridge window [mem 0xc0900000-0xc09fffff]
[    1.627551] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    1.633389] pci 0000:00:1c.5:   bridge window [mem 0xc0000000-0xc08fffff]
[    1.640972] pci 0000:00:1c.5:   bridge window [mem 
0xc4000000-0xc4ffffff 64bit pref]
[    1.649624] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    1.655474] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.662958] pci 0000:00:01.0: setting latency timer to 64
[    1.662964] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.670449] pci 0000:00:1c.0: setting latency timer to 64
[    1.670453] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.677940] pci 0000:00:1c.4: setting latency timer to 64
[    1.677946] pci 0000:00:1c.5: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.685432] pci 0000:00:1c.5: setting latency timer to 64
[    1.685439] pci 0000:00:1e.0: setting latency timer to 64
[    1.685442] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.685444] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.685445] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.685447] pci_bus 0000:00: resource 7 [mem 0x000cc000-0x000cffff]
[    1.685448] pci_bus 0000:00: resource 8 [mem 0x000d0000-0x000d3fff]
[    1.685449] pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000d7fff]
[    1.685451] pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff]
[    1.685452] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff]
[    1.685453] pci_bus 0000:00: resource 12 [mem 0x000e0000-0x000e3fff]
[    1.685455] pci_bus 0000:00: resource 13 [mem 0x000e4000-0x000e7fff]
[    1.685456] pci_bus 0000:00: resource 14 [mem 0xc0000000-0xfeafffff]
[    1.685458] pci_bus 0000:00: resource 15 [mem 0xfed40000-0xfed44fff]
[    1.685459] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    1.685461] pci_bus 0000:01: resource 1 [mem 0xc0a00000-0xc0afffff]
[    1.685462] pci_bus 0000:01: resource 2 [mem 0xc2000000-0xc3ffffff 
64bit pref]
[    1.685464] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    1.685465] pci_bus 0000:03: resource 1 [mem 0xc0900000-0xc09fffff]
[    1.685466] pci_bus 0000:04: resource 1 [mem 0xc0000000-0xc08fffff]
[    1.685468] pci_bus 0000:04: resource 2 [mem 0xc4000000-0xc4ffffff 
64bit pref]
[    1.685469] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    1.685471] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    1.685472] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    1.685473] pci_bus 0000:05: resource 7 [mem 0x000cc000-0x000cffff]
[    1.685475] pci_bus 0000:05: resource 8 [mem 0x000d0000-0x000d3fff]
[    1.685476] pci_bus 0000:05: resource 9 [mem 0x000d4000-0x000d7fff]
[    1.685477] pci_bus 0000:05: resource 10 [mem 0x000d8000-0x000dbfff]
[    1.685479] pci_bus 0000:05: resource 11 [mem 0x000dc000-0x000dffff]
[    1.685480] pci_bus 0000:05: resource 12 [mem 0x000e0000-0x000e3fff]
[    1.685481] pci_bus 0000:05: resource 13 [mem 0x000e4000-0x000e7fff]
[    1.685483] pci_bus 0000:05: resource 14 [mem 0xc0000000-0xfeafffff]
[    1.685484] pci_bus 0000:05: resource 15 [mem 0xfed40000-0xfed44fff]
[    1.685546] NET: Registered protocol family 2
[    1.690775] IP route cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    1.699941] TCP established hash table entries: 524288 (order: 11, 
8388608 bytes)
[    1.709283] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.716893] TCP: Hash tables configured (established 524288 bind 65536)
[    1.724282] TCP reno registered
[    1.727810] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    1.734666] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    1.742279] NET: Registered protocol family 1
[    1.837516] pci 0000:04:00.0: Boot video device
[    1.837530] PCI: CLS 64 bytes, default 64
[    1.837562] Unpacking initramfs...
[    2.017330] Freeing initrd memory: 11532k freed
[    2.023543] IOMMU 0 0xfed91000: using Queued invalidation
[    2.029584] IOMMU: Setting RMRR:
[    2.033195] IOMMU: Setting identity map for device 0000:00:1d.0 
[0xbedbe000 - 0xbedd1fff]
[    2.042362] IOMMU: Setting identity map for device 0000:00:1a.0 
[0xbedbe000 - 0xbedd1fff]
[    2.051511] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    2.057452] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 
- 0xffffff]
[    2.065798] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    2.074725] Simple Boot Flag at 0x4f set to 0x80
[    2.080269] audit: initializing netlink socket (disabled)
[    2.086309] type=2000 audit(1316107327.684:1): initialized
[    2.117546] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.154131] VFS: Disk quotas dquot_6.5.2
[    2.158575] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.165867] msgmni has been set to 31724
[    2.170405] alg: No test for stdrng (krng)
[    2.175011] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    2.183274] io scheduler noop registered
[    2.187654] io scheduler deadline registered
[    2.192439] io scheduler cfq registered (default)
[    2.197751] pcieport 0000:00:01.0: setting latency timer to 64
[    2.197779] pcieport 0000:00:01.0: irq 41 for MSI/MSI-X
[    2.197829] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.197874] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
[    2.197933] pcieport 0000:00:1c.4: setting latency timer to 64
[    2.197978] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    2.198037] pcieport 0000:00:1c.5: setting latency timer to 64
[    2.198082] pcieport 0000:00:1c.5: irq 44 for MSI/MSI-X
[    2.198154] pcieport 0000:00:01.0: Signaling PME through PCIe PME 
interrupt
[    2.205931] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    2.213220] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    2.213235] pcieport 0000:00:1c.0: Signaling PME through PCIe PME 
interrupt
[    2.221002] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.221016] pcieport 0000:00:1c.4: Signaling PME through PCIe PME 
interrupt
[    2.228793] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.236086] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    2.236099] pcieport 0000:00:1c.5: Signaling PME through PCIe PME 
interrupt
[    2.243875] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    2.251167] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    2.251213] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    2.258019] vesafb: scrolling: redraw
[    2.262110] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    2.270115] vesafb: framebuffer at 0xc4000000, mapped to 
0xffffc90006680000, using 3072k, total 3072k
[    2.302124] Console: switching to colour frame buffer device 128x48
[    2.330942] fb0: VESA VGA frame buffer device
[    2.336080] ERST: Error Record Serialization Table (ERST) support is 
initialized.
[    2.344917] GHES: APEI firmware first mode is enabled by APEI bit and 
WHEA _OSC.
[    2.353522] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.381459] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.409120] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.437831] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.498064] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.537526] Linux agpgart interface v0.103
[    2.542401] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.063508] i8042: Can't read CTR while initializing i8042
[    3.069850] i8042: probe of i8042 failed with error -5
[    3.075859] mousedev: PS/2 mouse device common for all mice
[    3.082319] Refined TSC clocksource calibration: 3092.973 MHz.
[    3.089072] Switching to clocksource tsc
[    3.093635] rtc_cmos 00:06: RTC can wake from S4
[    3.099080] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.106155] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    3.113913] cpuidle: using governor ladder
[    3.118646] cpuidle: using governor menu
[    3.123306] TCP cubic registered
[    3.127066] NET: Registered protocol family 10
[    3.132719] Mobile IPv6
[    3.144196] NET: Registered protocol family 17
[    3.158011] Registering the dns_resolver key type
[    3.172068] PM: Hibernation image not present or could not be loaded.
[    3.172077] registered taskstats version 1
[    3.200423] rtc_cmos 00:06: setting system clock to 2011-09-15 
17:22:11 UTC (1316107331)
[    3.218340] Initializing network drop monitor service
[    3.233764] Freeing unused kernel memory: 560k freed
[    3.248189] Write protecting the kernel read-only data: 6144k
[    3.265240] Freeing unused kernel memory: 652k freed
[    3.281497] Freeing unused kernel memory: 744k freed
[    3.307743] udevd[61]: starting version 172
[    3.327205] e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
[    3.342568] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    3.361574] SCSI subsystem initialized
[    3.361766] e1000e 0000:00:19.0: PCI INT A -> GSI 19 (level, low) -> 
IRQ 19
[    3.361778] e1000e 0000:00:19.0: setting latency timer to 64
[    3.361865] usbcore: registered new interface driver usbfs
[    3.361880] usbcore: registered new interface driver hub
[    3.361908] usbcore: registered new device driver usb
[    3.362142] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    3.435298] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.435321] ACPI: Fan [FAN0] (off)
[    3.435346] ACPI: Fan [FAN1] (off)
[    3.435370] ACPI: Fan [FAN2] (off)
[    3.435394] ACPI: Fan [FAN3] (off)
[    3.435417] ACPI: Fan [FAN4] (off)
[    3.511611] 3ware 9000 Storage Controller device driver for Linux 
v2.26.02.014.
[    3.527940] libata version 3.00 loaded.
[    3.528239] thermal LNXTHERM:00: registered as thermal_zone0
[    3.528894] 3w-9xxx 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    3.528898] 3w-9xxx 0000:01:00.0: setting latency timer to 64
[    3.558343] ACPI: Thermal Zone [TZ00] (28 C)
[    3.571098] thermal LNXTHERM:01: registered as thermal_zone1
[    3.585222] ACPI: Thermal Zone [TZ01] (30 C)
[    3.739968] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 
00:1e:67:14:69:f5
[    3.757043] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network 
Connection
[    3.772942] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 
0100FF-0FF
[    3.788907] e1000e 0000:03:00.0: Disabling ASPM L0s
[    3.788927] ehci_hcd 0000:00:1a.0: PCI INT B -> GSI 22 (level, low) 
-> IRQ 22
[    3.818711] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.818715] e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    3.818716] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.818747] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[    3.818789] ehci_hcd 0000:00:1a.0: debug port 2
[    3.822685] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.822699] ehci_hcd 0000:00:1a.0: irq 22, io mem 0xc0b60000
[    3.845033] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.845049] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.845051] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    3.845052] usb usb1: Product: EHCI Host Controller
[    3.845053] usb usb1: Manufacturer: Linux 3.1.0-rc6+ ehci_hcd
[    3.845054] usb usb1: SerialNumber: 0000:00:1a.0
[    3.845129] hub 1-0:1.0: USB hub found
[    3.845131] hub 1-0:1.0: 2 ports detected
[    3.845241] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) 
-> IRQ 20
[    3.845269] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.845278] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.845282] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    3.845390] ehci_hcd 0000:00:1d.0: debug port 2
[    3.849289] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.849299] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xc0b50000
[    4.078864] e1000e 0000:03:00.0: setting latency timer to 64
[    4.079105] e1000e 0000:03:00.0: irq 46 for MSI/MSI-X
[    4.079116] e1000e 0000:03:00.0: irq 47 for MSI/MSI-X
[    4.079127] e1000e 0000:03:00.0: irq 48 for MSI/MSI-X
[    4.080988] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.095254] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.110739] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.126731] usb usb2: Product: EHCI Host Controller
[    4.140251] usb usb2: Manufacturer: Linux 3.1.0-rc6+ ehci_hcd
[    4.154718] usb usb2: SerialNumber: 0000:00:1d.0
[    4.167962] hub 2-0:1.0: USB hub found
[    4.180016] hub 2-0:1.0: 2 ports detected
[    4.192339] ahci 0000:00:1f.2: version 3.0
[    4.192359] ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.199525] e1000e 0000:03:00.0: eth1: (PCI Express:2.5GT/s:Width x1) 
00:1e:67:14:69:f4
[    4.199527] e1000e 0000:03:00.0: eth1: Intel(R) PRO/1000 Network 
Connection
[    4.199615] e1000e 0000:03:00.0: eth1: MAC: 3, PHY: 8, PBA No: 1000FF-0FF
[    4.252935] scsi0 : 3ware 9000 Storage Controller
[    4.269741] 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 
0xc0a20000, IRQ: 16.
[    4.287160] ahci 0000:00:1f.2: irq 49 for MSI/MSI-X
[    4.300959] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 
0x3f impl SATA mode
[    4.318625] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio 
slum part ems apst
[    4.336303] ahci 0000:00:1f.2: setting latency timer to 64
[    4.373269] scsi1 : ahci
[    4.384838] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    4.384882] scsi2 : ahci
[    4.384934] scsi3 : ahci
[    4.384977] scsi4 : ahci
[    4.385015] scsi5 : ahci
[    4.385052] scsi6 : ahci
[    4.385125] ata1: SATA max UDMA/133 abar m2048@0xc0b40000 port 
0xc0b40100 irq 49
[    4.385128] ata2: SATA max UDMA/133 abar m2048@0xc0b40000 port 
0xc0b40180 irq 49
[    4.385131] ata3: SATA max UDMA/133 abar m2048@0xc0b40000 port 
0xc0b40200 irq 49
[    4.385134] ata4: SATA max UDMA/133 abar m2048@0xc0b40000 port 
0xc0b40280 irq 49
[    4.385137] ata5: SATA max UDMA/133 abar m2048@0xc0b40000 port 
0xc0b40300 irq 49
[    4.385139] ata6: SATA max UDMA/133 abar m2048@0xc0b40000 port 
0xc0b40380 irq 49
[    4.620860] 3w-9xxx: scsi0: Firmware FH9X 4.10.00.021, BIOS BE9X 
4.08.00.003, Ports: 128.
[    4.637862] scsi 0:0:0:0: Direct-Access     AMCC     9690SA-8I  DISK  
4.10 PQ: 0 ANSI: 5
[    4.655072] scsi 0:0:1:0: Direct-Access     AMCC     9690SA-8I  DISK  
4.10 PQ: 0 ANSI: 5
[    4.672155] scsi 0:0:2:0: Direct-Access     AMCC     9690SA-8I  DISK  
4.10 PQ: 0 ANSI: 5
[    4.701207] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    4.704855] ata5: SATA link down (SStatus 0 SControl 300)
[    4.704884] ata6: SATA link down (SStatus 0 SControl 300)
[    4.708967] ata2: SATA link down (SStatus 0 SControl 300)
[    4.709129] ata3: SATA link down (SStatus 0 SControl 300)
[    4.709300] ata4: SATA link down (SStatus 0 SControl 300)
[    4.716854] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.796173] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    4.811476] hub 1-1:1.0: USB hub found
[    4.823053] hub 1-1:1.0: 6 ports detected
[    4.854209] ata1.00: applying link speed limit horkage to 1.5 Gbps
[    4.944800] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    5.089119] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    5.103863] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[    5.119377] hub 2-1:1.0: USB hub found
[    5.130983] hub 2-1:1.0: 6 ports detected
[    5.212844] usb 1-1.1: new full speed USB device number 3 using ehci_hcd
[    5.317818] usb 1-1.1: New USB device found, idVendor=046b, 
idProduct=ff10
[    5.332774] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    5.348254] usb 1-1.1: Product: Virtual Keyboard and Mouse
[    5.361672] usb 1-1.1: Manufacturer: American Megatrends Inc.
[    5.375399] usb 1-1.1: SerialNumber: serial
[    5.405793] input: American Megatrends Inc. Virtual Keyboard and 
Mouse as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input0
[    5.435673] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID 
v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on 
usb-0000:00:1a.0-1.1/input0
[    5.468921] usb 2-1.1: new full speed USB device number 3 using ehci_hcd
[    5.485261] input: American Megatrends Inc. Virtual Keyboard and 
Mouse as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input1
[    5.516779] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID 
v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on 
usb-0000:00:1a.0-1.1/input1
[    5.550961] usbcore: registered new interface driver usbhid
[    5.566104] usbhid: USB HID core driver
[    5.630747] usb 2-1.1: New USB device found, idVendor=0403, 
idProduct=6001
[    5.647578] usb 2-1.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    5.665068] usb 2-1.1: Product: FT232R USB UART
[    5.679509] usb 2-1.1: Manufacturer: FTDI
[    5.693429] usb 2-1.1: SerialNumber: A8008E4U
[    5.780716] usb 2-1.2: new low speed USB device number 4 using ehci_hcd
[    5.896561] usb 2-1.2: New USB device found, idVendor=06da, 
idProduct=0002
[    5.913997] usb 2-1.2: New USB device strings: Mfr=4, Product=38, 
SerialNumber=0
[    5.932195] usb 2-1.2: Product: UPS USB Interface (V2.00)
[    5.948256] usb 2-1.2: Manufacturer: Phoenixtec Power
[   10.043672] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   10.197752] ata1.00: ATA-6: WD My Book, CC1H, max UDMA/133
[   10.213862] ata1.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 1)
[   10.390891] ata1.00: configured for UDMA/133
[   10.406016] scsi 1:0:0:0: Direct-Access     ATA      WD My Book       
CC1H PQ: 0 ANSI: 5
[   10.428667] sd 0:0:0:0: [sda] 8788998144 512-byte logical blocks: 
(4.49 TB/4.09 TiB)
[   10.447680] sd 1:0:0:0: [sdd] 2930277168 512-byte logical blocks: 
(1.50 TB/1.36 TiB)
[   10.447683] sd 0:0:1:0: [sdb] 15624912896 512-byte logical blocks: 
(7.99 TB/7.27 TiB)
[   10.486215] sd 0:0:2:0: [sdc] 3906228224 512-byte logical blocks: 
(1.99 TB/1.81 TiB)
[   10.486243] sd 1:0:0:0: [sdd] Write Protect is off
[   10.486244] sd 1:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   10.486256] sd 1:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   10.486909] sd 0:0:1:0: [sdb] Write Protect is off
[   10.486910] sd 0:0:1:0: [sdb] Mode Sense: 23 00 10 00
[   10.487990] sd 0:0:0:0: [sda] Write Protect is off
[   10.487991] sd 0:0:0:0: [sda] Mode Sense: 23 00 10 00
[   10.488427] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   10.489136] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   10.616564] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.617152] sd 0:0:2:0: [sdc] Write Protect is off
[   10.617153] sd 0:0:2:0: [sdc] Mode Sense: 23 00 10 00
[   10.618290] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   10.629985]  sdd: sdd1
[   10.642382]  sda: sda1 sda2 sda3 sda4
[   10.698006] sd 1:0:0:0: [sdd] Attached SCSI disk
[   10.698020] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   10.698055] sd 0:0:2:0: Attached scsi generic sg2 type 0
[   10.698558] sd 1:0:0:0: Attached scsi generic sg3 type 0
[   10.699658] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.705349]  sdc: sdc1
[   10.714881]  sdb: sdb1
[   10.807109] sd 0:0:1:0: [sdb] Attached SCSI disk
[   10.821914] sd 0:0:2:0: [sdc] Attached SCSI disk
[   11.312121] device-mapper: uevent: version 1.0.3
[   11.326573] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) 
initialised: dm-devel@redhat.com
[   11.558316] Btrfs loaded
[   11.789219] kjournald starting.  Commit interval 5 seconds
[   11.789257] EXT3-fs (dm-0): mounted filesystem with ordered data mode
[   12.871907] udevd[373]: starting version 172
[   13.223892] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[   13.241454] ACPI: Sleep Button [SLPB]
[   13.253975] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   13.270792] ACPI: Power Button [PWRF]
[   13.283385] ACPI: acpi_idle registered with cpuidle
[   13.284053] Monitor-Mwait will be used to enter C-1 state
[   13.284068] Monitor-Mwait will be used to enter C-3 state
[   13.284565] i801_smbus 0000:00:1f.3: PCI INT D -> GSI 22 (level, low) 
-> IRQ 22
[   13.437868] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   13.489068] usbcore: registered new interface driver usbserial
[   13.504519] USB Serial support registered for generic
[   13.519136] usbcore: registered new interface driver usbserial_generic
[   13.535400] usbserial: USB Serial Driver core
[   13.551219] udevd[435]: renamed network interface eth1 to rename3
[   13.570447] USB Serial support registered for FTDI USB Serial Device
[   13.586628] ftdi_sio 2-1.1:1.0: FTDI USB Serial Device converter detected
[   13.603308] usb 2-1.1: Detected FT232RL
[   13.603604] udevd[436]: renamed network interface eth0 to eth1
[   13.632191] usb 2-1.1: Number of endpoints 2
[   13.646004] usb 2-1.1: Endpoint 1 MaxPacketSize 64
[   13.660253] usb 2-1.1: Endpoint 2 MaxPacketSize 64
[   13.674336] usb 2-1.1: Setting MaxPacketSize 64
[   13.688638] usb 2-1.1: FTDI USB Serial Device converter now attached 
to ttyUSB0
[   13.705695] usbcore: registered new interface driver ftdi_sio
[   13.720828] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[   13.723143] udevd[435]: renamed network interface rename3 to eth0
[   13.800615] Error: Driver 'pcspkr' is already registered, aborting...
[   14.516164] EXT3-fs (dm-0): using internal journal
[   14.669406] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   14.830588] fuse init (API version 7.17)
[   14.866106] coretemp coretemp.0: TjMax is 94 C.
[   14.880131] coretemp coretemp.0: TjMax is 94 C.
[   14.894060] coretemp coretemp.0: TjMax is 94 C.
[   14.907856] coretemp coretemp.0: TjMax is 94 C.
[   14.965195] ipmi message handler version 39.2
[   14.979481] ipmi device interface
[   14.998653] IPMI System Interface driver.
[   15.011556] ipmi_si: probing via ACPI
[   15.024165] ipmi_si 00:0a: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[   15.040421] ipmi_si: Adding ACPI-specified kcs state machine
[   15.055597] ipmi_si: probing via SMBIOS
[   15.068675] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   15.084233] ipmi_si: Adding SMBIOS-specified kcs state machine 
duplicate interface
[   15.101838] ipmi_si: probing via SPMI
[   15.115098] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   15.130736] ipmi_si: Adding SPMI-specified kcs state machine 
duplicate interface
[   15.148333] ipmi_si: Trying ACPI-specified kcs state machine at i/o 
address 0xca2, slave address 0x0, irq 0
[   15.313094] ipmi_si 00:0a: Found new BMC (man_id: 0x000157, prod_id: 
0x0048, dev_id: 0x21)
[   15.331729] ipmi_si 00:0a: IPMI kcs interface initialized
[   20.506932] Adding 16777212k swap on /dev/mapper/vg0-swap.  
Priority:-1 extents:1 across:16777212k
[   23.219398] kjournald starting.  Commit interval 5 seconds
[   23.219546] EXT3-fs (sda3): using internal journal
[   23.219551] EXT3-fs (sda3): mounted filesystem with ordered data mode
[   23.345000] EXT4-fs (dm-4): mounted filesystem with ordered data 
mode. Opts: user_xattr
[   23.366049] EXT4-fs (dm-12): mounted filesystem with ordered data 
mode. Opts: (null)
[   23.425656] EXT4-fs (dm-7): mounted filesystem with writeback data 
mode. Opts: data=writeback
[   23.448663] EXT4-fs (dm-13): mounted filesystem with ordered data 
mode. Opts: journal_checksum
[   23.504529] EXT4-fs (dm-5): mounted filesystem with writeback data 
mode. Opts: data=writeback
[   23.541258] EXT4-fs (dm-6): mounted filesystem with ordered data 
mode. Opts: (null)
[   23.587982] EXT4-fs (dm-8): mounted filesystem with ordered data 
mode. Opts: (null)
[   23.679154] EXT4-fs (dm-9): mounted filesystem with ordered data 
mode. Opts: journal_checksum
[   23.749457] EXT4-fs (dm-2): mounted filesystem with ordered data 
mode. Opts: user_xattr
[   23.799248] EXT4-fs (dm-3): mounted filesystem with ordered data 
mode. Opts: user_xattr
[   23.869504] EXT4-fs (dm-1): mounted filesystem with ordered data 
mode. Opts: journal_checksum
[   24.768025] Bridge firewalling registered
[   24.783166] device eth0 entered promiscuous mode
[   24.874585] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.893966] ADDRCONF(NETDEV_UP): br0: link is not ready
[   28.188776] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: None
[   28.206890] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   28.222278] br0: port 1(eth0) entering forwarding state
[   28.236832] br0: port 1(eth0) entering forwarding state
[   28.252027] ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[   36.835788] RPC: Registered named UNIX socket transport module.
[   36.850990] RPC: Registered udp transport module.
[   36.864689] RPC: Registered tcp transport module.
[   36.878182] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   36.939881] FS-Cache: Loaded
[   36.982032] FS-Cache: Netfs 'nfs' registered for caching
[   37.000181] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   37.495087] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x17
[   37.524835] IPMI Watchdog: driver initialized
[   37.576396] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x17
[   37.593249] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x17
[   37.609036] wd_keepalive (1848): /proc/1848/oom_adj is deprecated, 
please use /proc/1848/oom_score_adj instead.
[   37.609932] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x17
[   37.611188] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   44.659927] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state 
recovery directory
[   44.698624] NFSD: starting 90-second grace period
[   51.010179] Ebtables v2.0 registered
[   51.221073] ip_tables: (C) 2000-2006 Netfilter Core Team
[   51.327968] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   63.015516] Unable to load target_core_stgt
[   63.032891] bio: create slab <bio-1> at 1
[  140.327818] MODE SENSE: unimplemented page/subpage: 0x1c/0x00
[38264.058705] EXT4-fs (dm-1): re-mounted. Opts: journal_checksum
[39410.390809] EXT4-fs (dm-1): re-mounted. Opts: journal_checksum
[41865.228424] alg: No test for __cbc-aes-aesni 
(cryptd(__driver-cbc-aes-aesni))
[41875.033718] EXT4-fs (dm-25): mounted filesystem with ordered data 
mode. Opts: journal_checksum
[48660.747279] MODE SENSE: unimplemented page/subpage: 0x1c/0x00
[58280.612224] EXT4-fs (dm-25): mounted filesystem with ordered data 
mode. Opts: journal_checksum

