Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1G0A7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:59:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44582 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1G0A7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YOYOMNmLTn=MLdObwfUPLb-xOr1Xw7aLoEWcDb8esAX4A@mail.gmail.com>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
	<1310462166-31469-14-git-send-email-tj@kernel.org>
	<CAE9FiQU3+ceB+uDY6q2WyBvaTsJr-v9sRF7DDr_omNMf49o3Kg@mail.gmail.com>
	<CAOS58YOYOMNmLTn=MLdObwfUPLb-xOr1Xw7aLoEWcDb8esAX4A@mail.gmail.com>
Date: Tue, 26 Jul 2011 17:59:13 -0700
Message-ID: <CAE9FiQX5F2H_SaPTO0CxP9sAzmg0JSchonf1KXONOjkrB0rP+g@mail.gmail.com>
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 2:46 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Yinghai.
>
> On Tue, Jul 26, 2011 at 11:06 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> Wonder if we have a new function like
>>
>> __memblock_reserve(addr, size, name)
>>
>> in mm/memblock.c
>>
>> so could keep string for debug purpose instead of using _RET_IP_.
>>
>> with that, we can figure out what is in exact reserved position with boot log.
>
> If you look at the current users, the caller function name is unique
> except for one or two cases, so we can already tell who's doing what
> even without consulting the exact IP.  I can't see much point in
> providing debug strings explicitly.  The only benefit would be that it
> would be prettier but these are purely debug messages.  One thing
> which might make sense is preserving _RET_IP_ of callers of alloc
> functions so that reserve can show who's allocating instead of
> printing the alloc function each time.

yes, with bootmem wrap stage, the print out are all the same.

will have
__alloc_memory_core_early+0x63
everywhere.

add name print out for comparing, name could give some hint.

early console in decompress_kernel
decompress_kernel:
  input: [0x268a269-0x2e110ac], output: 0x1000000, heap: [0x2e16080-0x2e1e07f]..

Decompressing Linux... xz... Parsing ELF... done
Booting the kernel
[    0.000000] bootconsole [uart0] enabled
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x01c40639]
[    0.000000] .rodata: [0x01c46000-0x023e7fff]
[    0.000000]   .data: [0x023e8000-0x02521b7f]
[    0.000000]   .init: [0x02524000-0x027f3fff]
[    0.000000]    .bss: [0x027fe000-0x033affff]
[    0.000000]    .brk: [0x033b0000-0x033cffff]
[    0.000000] memblock_reserve: [0x01000000-0x033affff]
x86_64_start_reservations+0x67/0xaf TEXT DATA BSS
[    0.000000] memblock_reserve: [0x7baf3000-0x7f72ffff]
x86_64_start_reservations+0xa0/0xaf RAMDISK
[    0.000000] memblock_reserve: [0x00095400-0x000fffff]
reserve_ebda_region+0x62/0x64 * BIOS reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-tip-yh-06478-g4d387ec-dirty
(yhlu@linux-siqj.site) (gcc version 4.5.0 20100604 [gcc-4_5-branch
revision 160292] (SUSE Linux) ) #1155 SMP Tue Jul 26 17:28:15 PDT 2011
[    0.000000] Command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/x.gz rw root=/dev/ram0 debug ignore_loglevel
unknown_nmi_panic initcall_debug apic=debug pci=routeirq ip=dhcp
load_ramdisk=1 BOOT_IMAGE=kernel.org/bzImage_3.0_k8.2
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: [0x00000000000000-0x000000000957ff] (usable)
[    0.000000]  BIOS-e820: [0x00000000095800-0x0000000009ffff] (reserved)
[    0.000000]  BIOS-e820: [0x000000000e0000-0x000000000fffff] (reserved)
[    0.000000]  BIOS-e820: [0x00000000100000-0x0000007f74ffff] (usable)
[    0.000000]  BIOS-e820: [0x0000007f75e000-0x0000007f75ffff] type 9
[    0.000000]  BIOS-e820: [0x0000007f760000-0x0000007f76dfff] (ACPI data)
[    0.000000]  BIOS-e820: [0x0000007f76e000-0x0000007f7cffff] (ACPI NVS)
[    0.000000]  BIOS-e820: [0x0000007f7d0000-0x0000007f7dffff] (reserved)
[    0.000000]  BIOS-e820: [0x0000007f7ec000-0x0000008fffffff] (reserved)
[    0.000000]  BIOS-e820: [0x000000fee00000-0x000000fee00fff] (reserved)
[    0.000000]  BIOS-e820: [0x000000ffc00000-0x000000ffffffff] (reserved)
[    0.000000]  BIOS-e820: [0x00000100000000-0x0000807fffffff] (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820 update range: [0x00000000095000-0x000000000957ff]
(usable) ==> (reserved)
[    0.000000] aligned physical RAM map:
[    0.000000]  aligned: [0x00000000000000-0x00000000094fff] (usable)
[    0.000000]  aligned: [0x00000000095000-0x0000000009ffff] (reserved)
[    0.000000]  aligned: [0x000000000e0000-0x000000000fffff] (reserved)
[    0.000000]  aligned: [0x00000000100000-0x0000007f74ffff] (usable)
[    0.000000]  aligned: [0x0000007f75e000-0x0000007f75ffff] type 9
[    0.000000]  aligned: [0x0000007f760000-0x0000007f76dfff] (ACPI data)
[    0.000000]  aligned: [0x0000007f76e000-0x0000007f7cffff] (ACPI NVS)
[    0.000000]  aligned: [0x0000007f7d0000-0x0000007f7dffff] (reserved)
[    0.000000]  aligned: [0x0000007f7ec000-0x0000008fffffff] (reserved)
[    0.000000]  aligned: [0x000000fee00000-0x000000fee00fff] (reserved)
[    0.000000]  aligned: [0x000000ffc00000-0x000000ffffffff] (reserved)
[    0.000000]  aligned: [0x00000100000000-0x0000807fffffff] (usable)
[    0.000000] DMI present.
[    0.000000] DMI: Oracle Corporation  Sun Fire X4800/     , BIOS
11016600    05/17/2011
[    0.000000] e820 update range: [0x00000000000000-0x0000000000ffff]
(usable) ==> (reserved)
[    0.000000] e820 remove range: [0x000000000a0000-0x000000000fffff] (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x8080000 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: [0x0000007f800000-0x000000ffffffff]
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x7f750 max_arch_pfn = 0x400000000
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] memblock_reserve: [0x000ff780-0x000ff78f]
smp_scan_config+0xbf/0xfa * MP-table mpf
[    0.000000]   mpc: e77f0-e85a4
[    0.000000] memblock_reserve: [0x000e77f0-0x000e85a3]
smp_scan_config+0xdf/0xfa * MP-table mpc
[    0.000000] memblock_reserve: [0x033b0000-0x033b08a9]
setup_arch+0x593/0x847 BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x7fff6d5000 reserved size = 0x60584aa
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]	[0x00010000-0x00094fff], 0x85000 bytes
[    0.000000]  memory[0x1]	[0x00100000-0x7f74ffff], 0x7f650000 bytes
[    0.000000]  memory[0x2]	[0x100000000-0x807fffffff], 0x7f80000000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]	[0x00095400-0x000fffff], 0x6ac00 bytes
[    0.000000]  reserved[0x1]	[0x01000000-0x033b08a9], 0x23b08aa bytes
[    0.000000]  reserved[0x2]	[0x7baf3000-0x7f72ffff], 0x3c3d000 bytes
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] memblock_reserve: [0x00090000-0x00094fff]
setup_trampolines+0x79/0xae TRAMPOLINE
[    0.000000] Base memory trampoline at [ffff880000090000] 90000 size 20480
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @
[0x7f74e000-0x7f74ffff]
[    0.000000] memblock_reserve: [0x7f74e000-0x7f74ffff]
find_early_table_space.clone.0+0x16a/0x16f PGTABLE
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000807fffffff]
[    0.000000]  0100000000 - 8080000000 page 2M
[    0.000000] kernel direct mapping tables up to 8080000000 @
[0x807fe01000-0x807fffffff]
[    0.000000] memblock_reserve: [0x807fe01000-0x807fffffff]
find_early_table_space.clone.0+0x16a/0x16f PGTABLE
[    0.000000] RAMDISK: 7baf3000 - 7f730000
[    0.000000] ACPI: RSDP 00000000000fab60 00024 (v02 SUN   )
[    0.000000] ACPI: XSDT 000000007f760100 0009C (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007f760290 000F4 (v04 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007f760a30 0828E (v02 SUN    X4800
00000066 INTL 20051117)
[    0.000000] ACPI: FACS 000000007f76e000 00040
[    0.000000] ACPI: APIC 000000007f760390 00482 (v02 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: SPCR 000000007f760820 00050 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007f760870 0003C (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: SLIT 000000007f76096c 0006C (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: SPMI 000000007f7609e0 00041 (v05 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007f76e040 00139 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: HPET 000000007f76ba30 00038 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: SRAT 000000007f76ba70 009C0 (v02 SUN    X4800
00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 000000007f76e180 002C8 (v01 SUN    X4800
00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000007f7a0e20 0036D (v01 SUN       CpuPm
00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 000000007f76c430 00130 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: BERT 000000007f76c5c0 00030 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: ERST 000000007f76c5f0 00210 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: HEST 000000007f76c800 000A8 (v01 SUN    X4800
20110517 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 4 -> APIC 0x80 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x82 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x84 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x86 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x90 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x92 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x94 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x96 -> Node 4
[    0.000000] SRAT: PXM 5 -> APIC 0xa0 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xa2 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xa4 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xa6 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb0 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb2 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb4 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb6 -> Node 5
[    0.000000] SRAT: PXM 6 -> APIC 0xc0 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xc2 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xc4 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xc6 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd0 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd2 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd4 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd6 -> Node 6
[    0.000000] SRAT: PXM 7 -> APIC 0xe0 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xe2 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xe4 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xe6 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf0 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf2 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf4 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf6 -> Node 7
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 4 -> APIC 0x81 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x83 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x85 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x87 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x91 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x93 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x95 -> Node 4
[    0.000000] SRAT: PXM 4 -> APIC 0x97 -> Node 4
[    0.000000] SRAT: PXM 5 -> APIC 0xa1 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xa3 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xa5 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xa7 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb1 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb3 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb5 -> Node 5
[    0.000000] SRAT: PXM 5 -> APIC 0xb7 -> Node 5
[    0.000000] SRAT: PXM 6 -> APIC 0xc1 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xc3 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xc5 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xc7 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd1 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd3 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd5 -> Node 6
[    0.000000] SRAT: PXM 6 -> APIC 0xd7 -> Node 6
[    0.000000] SRAT: PXM 7 -> APIC 0xe1 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xe3 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xe5 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xe7 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf1 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf3 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf5 -> Node 7
[    0.000000] SRAT: PXM 7 -> APIC 0xf7 -> Node 7
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-1080000000
[    0.000000] SRAT: Node 1 PXM 1 1080000000-2080000000
[    0.000000] SRAT: Node 2 PXM 2 2080000000-3080000000
[    0.000000] SRAT: Node 3 PXM 3 3080000000-4080000000
[    0.000000] SRAT: Node 4 PXM 4 4080000000-5080000000
[    0.000000] SRAT: Node 5 PXM 5 5080000000-6080000000
[    0.000000] SRAT: Node 6 PXM 6 6080000000-7080000000
[    0.000000] SRAT: Node 7 PXM 7 7080000000-8080000000
[    0.000000] ACPI: SLIT: nodes = 8
[    0.000000]    10 15 20 15 15 20 20 20
[    0.000000]    15 10 15 20 20 15 20 20
[    0.000000]    20 15 10 15 20 20 15 20
[    0.000000]    15 20 15 10 20 20 20 15
[    0.000000]    15 20 20 20 10 15 15 20
[    0.000000]    20 15 20 20 15 10 20 15
[    0.000000]    20 20 15 20 15 20 10 15
[    0.000000]    20 20 20 15 20 15 15 10
[    0.000000] memblock_reserve: [0x807fe00000-0x807fe0003f]
numa_alloc_distance+0xd4/0x13e NODE DIST
[    0.000000] NUMA: Initialized distance table, cnt=8
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
[    0.000000] NUMA: Node 0 [0,80000000) + [100000000,1080000000) ->
[0,1080000000)
[    0.000000] Initmem setup node 0 [0000000000000000-000000107fffffff]
[    0.000000] memblock_reserve: [0x107fffb000-0x107fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000107fffb000 - 0x0000107fffffff]
[    0.000000] Initmem setup node 1 [0000001080000000-000000207fffffff]
[    0.000000] memblock_reserve: [0x207fffb000-0x207fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000207fffb000 - 0x0000207fffffff]
[    0.000000] Initmem setup node 2 [0000002080000000-000000307fffffff]
[    0.000000] memblock_reserve: [0x307fffb000-0x307fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000307fffb000 - 0x0000307fffffff]
[    0.000000] Initmem setup node 3 [0000003080000000-000000407fffffff]
[    0.000000] memblock_reserve: [0x407fffb000-0x407fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000407fffb000 - 0x0000407fffffff]
[    0.000000] Initmem setup node 4 [0000004080000000-000000507fffffff]
[    0.000000] memblock_reserve: [0x507fffb000-0x507fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000507fffb000 - 0x0000507fffffff]
[    0.000000] Initmem setup node 5 [0000005080000000-000000607fffffff]
[    0.000000] memblock_reserve: [0x607fffb000-0x607fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000607fffb000 - 0x0000607fffffff]
[    0.000000] Initmem setup node 6 [0000006080000000-000000707fffffff]
[    0.000000] memblock_reserve: [0x707fffb000-0x707fffffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000707fffb000 - 0x0000707fffffff]
[    0.000000] Initmem setup node 7 [0000007080000000-000000807fffffff]
[    0.000000] memblock_reserve: [0x807fdfb000-0x807fdfffff]
memblock_reserve+0x10/0x12
[    0.000000]   NODE_DATA [#000000807fdfb000 - 0x0000807fdfffff]
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x7fff6d5000 reserved size = 0x62864ea
[    0.000000]  memory.cnt  = 0xa
[    0.000000]  memory[0x0]	[0x00010000-0x00094fff], 0x85000 bytes on node 0
[    0.000000]  memory[0x1]	[0x00100000-0x7f74ffff], 0x7f650000 bytes on node 0
[    0.000000]  memory[0x2]	[0x100000000-0x107fffffff], 0xf80000000
bytes on node 0
[    0.000000]  memory[0x3]	[0x1080000000-0x207fffffff], 0x1000000000
bytes on node 1
[    0.000000]  memory[0x4]	[0x2080000000-0x307fffffff], 0x1000000000
bytes on node 2
[    0.000000]  memory[0x5]	[0x3080000000-0x407fffffff], 0x1000000000
bytes on node 3
[    0.000000]  memory[0x6]	[0x4080000000-0x507fffffff], 0x1000000000
bytes on node 4
[    0.000000]  memory[0x7]	[0x5080000000-0x607fffffff], 0x1000000000
bytes on node 5
[    0.000000]  memory[0x8]	[0x6080000000-0x707fffffff], 0x1000000000
bytes on node 6
[    0.000000]  memory[0x9]	[0x7080000000-0x807fffffff], 0x1000000000
bytes on node 7
[    0.000000]  reserved.cnt  = 0xe
[    0.000000]  reserved[0x0]	[0x00090000-0x00094fff], 0x5000 bytes
[    0.000000]  reserved[0x1]	[0x00095400-0x000fffff], 0x6ac00 bytes
[    0.000000]  reserved[0x2]	[0x01000000-0x033b08a9], 0x23b08aa bytes
[    0.000000]  reserved[0x3]	[0x7baf3000-0x7f72ffff], 0x3c3d000 bytes
[    0.000000]  reserved[0x4]	[0x7f74e000-0x7f74ffff], 0x2000 bytes
[    0.000000]  reserved[0x5]	[0x107fffb000-0x107fffffff], 0x5000 bytes
[    0.000000]  reserved[0x6]	[0x207fffb000-0x207fffffff], 0x5000 bytes
[    0.000000]  reserved[0x7]	[0x307fffb000-0x307fffffff], 0x5000 bytes
[    0.000000]  reserved[0x8]	[0x407fffb000-0x407fffffff], 0x5000 bytes
[    0.000000]  reserved[0x9]	[0x507fffb000-0x507fffffff], 0x5000 bytes
[    0.000000]  reserved[0xa]	[0x607fffb000-0x607fffffff], 0x5000 bytes
[    0.000000]  reserved[0xb]	[0x707fffb000-0x707fffffff], 0x5000 bytes
[    0.000000]  reserved[0xc]	[0x807fdfb000-0x807fe0003f], 0x5040 bytes
[    0.000000]  reserved[0xd]	[0x807fe01000-0x807fffffff], 0x1ff000 bytes
[    0.000000] memblock_reserve: [0x107fffa000-0x107fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x107fff9000-0x107fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x107fff8000-0x107fff8fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x207fffa000-0x207fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x207fff9000-0x207fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x307fffa000-0x307fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x307fff9000-0x307fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x407fffa000-0x407fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x407fff9000-0x407fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x507fffa000-0x507fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x507fff9000-0x507fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x607fffa000-0x607fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x607fff9000-0x607fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x707fffa000-0x707fffafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x707fff9000-0x707fff9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x807fdfa000-0x807fdfafff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x807fdf9000-0x807fdf9fff]
__alloc_memory_core_early+0x63/0xad sparse section
[    0.000000] memblock_reserve: [0x807f9f9000-0x807fdf8fff]
__alloc_memory_core_early+0x63/0xad usemap_map
[    0.000000] memblock_reserve: [0x107fff5000-0x107fff7fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x207fff6000-0x207fff8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x307fff6000-0x307fff8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x407fff6000-0x407fff8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x507fff6000-0x507fff8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x607fff6000-0x607fff8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x707fff6000-0x707fff8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x807f9f6000-0x807f9f8fff]
__alloc_memory_core_early+0x63/0xad usemap section
[    0.000000] memblock_reserve: [0x807f5f6000-0x807f9f5fff]
__alloc_memory_core_early+0x63/0xad map_map
[    0.000000] memblock_reserve: [0x103fe00000-0x107fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000] memblock_reserve: [0x107fff4000-0x107fff4fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0000000000-ffffea7fffffffff] PGD ->
ffff88107fff4000 on node 0
[    0.000000] memblock_reserve: [0x107fff3000-0x107fff3fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0000000000-ffffea003fffffff] PUD ->
ffff88107fff3000 on node 0
[    0.000000]    memblock_free: [0x1077e00000-0x107fdfffff]
[    0.000000] memblock_reserve: [0x203fe00000-0x207fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea0000000000-ffffea0039bfffff] PMD ->
[ffff88103fe00000-ffff881077dfffff] on node 0
[    0.000000] memblock_reserve: [0x207fff5000-0x207fff5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0040000000-ffffea007fffffff] PUD ->
ffff88207fff5000 on node 1
[    0.000000]    memblock_free: [0x2077e00000-0x207fdfffff]
[    0.000000] memblock_reserve: [0x303fe00000-0x307fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea0039c00000-ffffea0071bfffff] PMD ->
[ffff88203fe00000-ffff882077dfffff] on node 1
[    0.000000] memblock_reserve: [0x307fff5000-0x307fff5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0080000000-ffffea00bfffffff] PUD ->
ffff88307fff5000 on node 2
[    0.000000]    memblock_free: [0x3077e00000-0x307fdfffff]
[    0.000000] memblock_reserve: [0x403fe00000-0x407fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea0071c00000-ffffea00a9bfffff] PMD ->
[ffff88303fe00000-ffff883077dfffff] on node 2
[    0.000000] memblock_reserve: [0x407fff5000-0x407fff5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea00c0000000-ffffea00ffffffff] PUD ->
ffff88407fff5000 on node 3
[    0.000000]    memblock_free: [0x4077e00000-0x407fdfffff]
[    0.000000] memblock_reserve: [0x503fe00000-0x507fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea00a9c00000-ffffea00e1bfffff] PMD ->
[ffff88403fe00000-ffff884077dfffff] on node 3
[    0.000000] memblock_reserve: [0x507fff5000-0x507fff5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0100000000-ffffea013fffffff] PUD ->
ffff88507fff5000 on node 4
[    0.000000]    memblock_free: [0x5077e00000-0x507fdfffff]
[    0.000000] memblock_reserve: [0x603fe00000-0x607fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea00e1c00000-ffffea0119bfffff] PMD ->
[ffff88503fe00000-ffff885077dfffff] on node 4
[    0.000000] memblock_reserve: [0x607fff5000-0x607fff5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0140000000-ffffea017fffffff] PUD ->
ffff88607fff5000 on node 5
[    0.000000]    memblock_free: [0x6077e00000-0x607fdfffff]
[    0.000000] memblock_reserve: [0x703fe00000-0x707fdfffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea0119c00000-ffffea0151bfffff] PMD ->
[ffff88603fe00000-ffff886077dfffff] on node 5
[    0.000000] memblock_reserve: [0x707fff5000-0x707fff5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea0180000000-ffffea01bfffffff] PUD ->
ffff88707fff5000 on node 6
[    0.000000]    memblock_free: [0x7077e00000-0x707fdfffff]
[    0.000000] memblock_reserve: [0x803f400000-0x807f3fffff]
__alloc_memory_core_early+0x63/0xad vmemmap buf
[    0.000000]  [ffffea0151c00000-ffffea0189bfffff] PMD ->
[ffff88703fe00000-ffff887077dfffff] on node 6
[    0.000000] memblock_reserve: [0x807f5f5000-0x807f5f5fff]
__alloc_memory_core_early+0x63/0xad vmemmap block
[    0.000000]  [ffffea01c0000000-ffffea01ffffffff] PUD ->
ffff88807f5f5000 on node 7
[    0.000000]    memblock_free: [0x8077400000-0x807f3fffff]
[    0.000000]  [ffffea0189c00000-ffffea01c1bfffff] PMD ->
[ffff88803f400000-ffff8880773fffff] on node 7
[    0.000000]    memblock_free: [0x807f5f6000-0x807f9f5fff]
[    0.000000]    memblock_free: [0x807f9f9000-0x807fdf8fff]Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x08080000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000095
[    0.000000]     0: 0x00000100 -> 0x0007f750
[    0.000000]     0: 0x00100000 -> 0x01080000
[    0.000000]     1: 0x01080000 -> 0x02080000
[    0.000000]     2: 0x02080000 -> 0x03080000
[    0.000000]     3: 0x03080000 -> 0x04080000
[    0.000000]     4: 0x04080000 -> 0x05080000
[    0.000000]     5: 0x05080000 -> 0x06080000
[    0.000000]     6: 0x06080000 -> 0x07080000
[    0.000000]     7: 0x07080000 -> 0x08080000
[    0.000000] start - node_states[2]:
[    0.000000] On node 0 totalpages: 16774869
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000] memblock_reserve: [0x107ff9b000-0x107fff2fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 503688 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x107ff43000-0x107ff9afff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000]   Normal zone: 222208 pages used for memmap
[    0.000000]   Normal zone: 16030720 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x107feeb000-0x107ff42fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 1 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x207ff9d000-0x207fff4fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 2 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x307ff9d000-0x307fff4fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 3 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x407ff9d000-0x407fff4fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 4 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x507ff9d000-0x507fff4fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 5 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x607ff9d000-0x607fff4fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 6 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x707ff9d000-0x707fff4fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] On node 7 totalpages: 16777216
[    0.000000]   Normal zone: 229376 pages used for memmap
[    0.000000]   Normal zone: 16547840 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x807fda1000-0x807fdf8fff]
__alloc_memory_core_early+0x63/0xad pgdat
[    0.000000] after - node_states[2]: 0-7
[    0.000000] memblock_reserve: [0x807fda0000-0x807fda0fff]
__alloc_memory_core_early+0x63/0xad pgtable
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x80] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x82] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x84] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x86] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x90] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x92] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x94] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x96] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0xa0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0xa2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0xa4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0xa6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0xb0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0xb2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0xb4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0xb6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0xc0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xc2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xc4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xc6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xd0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xd2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xd4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xd6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xe0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xe2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xe4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xe6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xf0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xf2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xf4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0xf6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5e] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5f] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x60] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x61] lapic_id[0x81] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x62] lapic_id[0x83] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x63] lapic_id[0x85] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x64] lapic_id[0x87] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x65] lapic_id[0x91] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x66] lapic_id[0x93] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x67] lapic_id[0x95] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x68] lapic_id[0x97] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x69] lapic_id[0xa1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6a] lapic_id[0xa3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6b] lapic_id[0xa5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6c] lapic_id[0xa7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6d] lapic_id[0xb1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6e] lapic_id[0xb3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6f] lapic_id[0xb5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x70] lapic_id[0xb7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x71] lapic_id[0xc1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x72] lapic_id[0xc3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x73] lapic_id[0xc5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x74] lapic_id[0xc7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x75] lapic_id[0xd1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x76] lapic_id[0xd3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x77] lapic_id[0xd5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x78] lapic_id[0xd7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x79] lapic_id[0xe1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7a] lapic_id[0xe3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7b] lapic_id[0xe5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7c] lapic_id[0xe7] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7d] lapic_id[0xf1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7e] lapic_id[0xf3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7f] lapic_id[0xf5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0xf7] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec02000] gsi_base[24])
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec02000)
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec02000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec04000)
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec08000] gsi_base[72])
[    0.000000] mapped IOAPIC to ffffffffff5f7000 (fec08000)
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec08000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfec0c000] gsi_base[96])
[    0.000000] mapped IOAPIC to ffffffffff5f6000 (fec0c000)
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfec0c000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8,
APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8,
APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8,
APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8,
APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8,
APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8,
APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8,
APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8,
APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8,
APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8,
APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8,
APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8,
APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8,
APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8,
APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8,
APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] memblock_reserve: [0x807fe00f80-0x807fe00fc0]
__alloc_memory_core_early+0x63/0xad hpet res
[    0.000000] SMP: Allowing 128 CPUs, 0 hotplug CPUs
[    0.000000] memblock_reserve: [0x807fe00e00-0x807fe00f4e]
__alloc_memory_core_early+0x63/0xad ioapic res
[    0.000000] nr_irqs_gsi: 136
[    0.000000] memblock_reserve: [0x807fe00b00-0x807fe00dd7]
__alloc_memory_core_early+0x63/0xad e820 resources
[    0.000000] memblock_reserve: [0x807fe00a80-0x807fe00ae7]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00a00-0x807fe00a67]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00980-0x807fe009e7]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00900-0x807fe00967]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00880-0x807fe008e7]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00800-0x807fe00867]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00780-0x807fe007e7]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00700-0x807fe00767]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00680-0x807fe006e7]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00600-0x807fe00667]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00580-0x807fe005e7]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] memblock_reserve: [0x807fe00500-0x807fe00567]
__alloc_memory_core_early+0x63/0xad firmware map
[    0.000000] Allocating PCI resources starting at 90000000 (gap:
90000000:6ee00000)
[    0.000000] memblock_reserve: [0x807fe00400-0x807fe004d9]
__alloc_memory_core_early+0x63/0xad saved_command_l
[    0.000000] memblock_reserve: [0x807fe00300-0x807fe003d9]
__alloc_memory_core_early+0x63/0xad static_command_
[    0.000000] setup_percpu: NR_CPUS:255 nr_cpumask_bits:255
nr_cpu_ids:128 nr_node_ids:8
[    0.000000] memblock_reserve: [0x807fd9f000-0x807fd9ffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc_info
[    0.000000] memblock_reserve: [0x807fd9e000-0x807fd9efff]
__alloc_memory_core_early+0x63/0xad pcpu area
[    0.000000] memblock_reserve: [0x107de00000-0x107fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x107dfdb000-0x107dffffff]
[    0.000000]    memblock_free: [0x107e1db000-0x107e1fffff]
[    0.000000]    memblock_free: [0x107e3db000-0x107e3fffff]
[    0.000000]    memblock_free: [0x107e5db000-0x107e5fffff]
[    0.000000]    memblock_free: [0x107e7db000-0x107e7fffff]
[    0.000000]    memblock_free: [0x107e9db000-0x107e9fffff]
[    0.000000]    memblock_free: [0x107ebdb000-0x107ebfffff]
[    0.000000]    memblock_free: [0x107eddb000-0x107edfffff]
[    0.000000]    memblock_free: [0x107efdb000-0x107effffff]
[    0.000000]    memblock_free: [0x107f1db000-0x107f1fffff]
[    0.000000]    memblock_free: [0x107f3db000-0x107f3fffff]
[    0.000000]    memblock_free: [0x107f5db000-0x107f5fffff]
[    0.000000]    memblock_free: [0x107f7db000-0x107f7fffff]
[    0.000000]    memblock_free: [0x107f9db000-0x107f9fffff]
[    0.000000]    memblock_free: [0x107fbdb000-0x107fbfffff]
[    0.000000]    memblock_free: [0x107fddb000-0x107fdfffff]
[    0.000000] memblock_reserve: [0x207de00000-0x207fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x207dfdb000-0x207dffffff]
[    0.000000]    memblock_free: [0x207e1db000-0x207e1fffff]
[    0.000000]    memblock_free: [0x207e3db000-0x207e3fffff]
[    0.000000]    memblock_free: [0x207e5db000-0x207e5fffff]
[    0.000000]    memblock_free: [0x207e7db000-0x207e7fffff]
[    0.000000]    memblock_free: [0x207e9db000-0x207e9fffff]
[    0.000000]    memblock_free: [0x207ebdb000-0x207ebfffff]
[    0.000000]    memblock_free: [0x207eddb000-0x207edfffff]
[    0.000000]    memblock_free: [0x207efdb000-0x207effffff]
[    0.000000]    memblock_free: [0x207f1db000-0x207f1fffff]
[    0.000000]    memblock_free: [0x207f3db000-0x207f3fffff]
[    0.000000]    memblock_free: [0x207f5db000-0x207f5fffff]
[    0.000000]    memblock_free: [0x207f7db000-0x207f7fffff]
[    0.000000]    memblock_free: [0x207f9db000-0x207f9fffff]
[    0.000000]    memblock_free: [0x207fbdb000-0x207fbfffff]
[    0.000000]    memblock_free: [0x207fddb000-0x207fdfffff]
[    0.000000] memblock_reserve: [0x307de00000-0x307fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x307dfdb000-0x307dffffff]
[    0.000000]    memblock_free: [0x307e1db000-0x307e1fffff]
[    0.000000]    memblock_free: [0x307e3db000-0x307e3fffff]
[    0.000000]    memblock_free: [0x307e5db000-0x307e5fffff]
[    0.000000]    memblock_free: [0x307e7db000-0x307e7fffff]
[    0.000000]    memblock_free: [0x307e9db000-0x307e9fffff]
[    0.000000]    memblock_free: [0x307ebdb000-0x307ebfffff]
[    0.000000]    memblock_free: [0x307eddb000-0x307edfffff]
[    0.000000]    memblock_free: [0x307efdb000-0x307effffff]
[    0.000000]    memblock_free: [0x307f1db000-0x307f1fffff]
[    0.000000]    memblock_free: [0x307f3db000-0x307f3fffff]
[    0.000000]    memblock_free: [0x307f5db000-0x307f5fffff]
[    0.000000]    memblock_free: [0x307f7db000-0x307f7fffff]
[    0.000000]    memblock_free: [0x307f9db000-0x307f9fffff]
[    0.000000]    memblock_free: [0x307fbdb000-0x307fbfffff]
[    0.000000]    memblock_free: [0x307fddb000-0x307fdfffff]
[    0.000000] memblock_reserve: [0x407de00000-0x407fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x407dfdb000-0x407dffffff]
[    0.000000]    memblock_free: [0x407e1db000-0x407e1fffff]
[    0.000000]    memblock_free: [0x407e3db000-0x407e3fffff]
[    0.000000]    memblock_free: [0x407e5db000-0x407e5fffff]
[    0.000000]    memblock_free: [0x407e7db000-0x407e7fffff]
[    0.000000]    memblock_free: [0x407e9db000-0x407e9fffff]
[    0.000000]    memblock_free: [0x407ebdb000-0x407ebfffff]
[    0.000000]    memblock_free: [0x407eddb000-0x407edfffff]
[    0.000000]    memblock_free: [0x407efdb000-0x407effffff]
[    0.000000]    memblock_free: [0x407f1db000-0x407f1fffff]
[    0.000000]    memblock_free: [0x407f3db000-0x407f3fffff]
[    0.000000]    memblock_free: [0x407f5db000-0x407f5fffff]
[    0.000000]    memblock_free: [0x407f7db000-0x407f7fffff]
[    0.000000]    memblock_free: [0x407f9db000-0x407f9fffff]
[    0.000000]    memblock_free: [0x407fbdb000-0x407fbfffff]
[    0.000000]    memblock_free: [0x407fddb000-0x407fdfffff]
[    0.000000] memblock_reserve: [0x507de00000-0x507fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x507dfdb000-0x507dffffff]
[    0.000000]    memblock_free: [0x507e1db000-0x507e1fffff]
[    0.000000]    memblock_free: [0x507e3db000-0x507e3fffff]
[    0.000000]    memblock_free: [0x507e5db000-0x507e5fffff]
[    0.000000]    memblock_free: [0x507e7db000-0x507e7fffff]
[    0.000000]    memblock_free: [0x507e9db000-0x507e9fffff]
[    0.000000]    memblock_free: [0x507ebdb000-0x507ebfffff]
[    0.000000]    memblock_free: [0x507eddb000-0x507edfffff]
[    0.000000]    memblock_free: [0x507efdb000-0x507effffff]
[    0.000000]    memblock_free: [0x507f1db000-0x507f1fffff]
[    0.000000]    memblock_free: [0x507f3db000-0x507f3fffff]
[    0.000000]    memblock_free: [0x507f5db000-0x507f5fffff]
[    0.000000]    memblock_free: [0x507f7db000-0x507f7fffff]
[    0.000000]    memblock_free: [0x507f9db000-0x507f9fffff]
[    0.000000]    memblock_free: [0x507fbdb000-0x507fbfffff]
[    0.000000]    memblock_free: [0x507fddb000-0x507fdfffff]
[    0.000000] memblock_reserve: [0x607de00000-0x607fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x607dfdb000-0x607dffffff]
[    0.000000]    memblock_free: [0x607e1db000-0x607e1fffff]
[    0.000000]    memblock_free: [0x607e3db000-0x607e3fffff]
[    0.000000]    memblock_free: [0x607e5db000-0x607e5fffff]
[    0.000000]    memblock_free: [0x607e7db000-0x607e7fffff]
[    0.000000]    memblock_free: [0x607e9db000-0x607e9fffff]
[    0.000000] memblock: reserved array is doubled to 256 at
[0x807fd9c800-0x807fd9dfff]
[    0.000000] memblock_reserve: [0x807fd9c800-0x807fd9dfff]
memblock_reserve+0x10/0x12
[    0.000000]    memblock_free: [0x607ebdb000-0x607ebfffff]
[    0.000000]    memblock_free: [0x607eddb000-0x607edfffff]
[    0.000000]    memblock_free: [0x607efdb000-0x607effffff]
[    0.000000]    memblock_free: [0x607f1db000-0x607f1fffff]
[    0.000000]    memblock_free: [0x607f3db000-0x607f3fffff]
[    0.000000]    memblock_free: [0x607f5db000-0x607f5fffff]
[    0.000000]    memblock_free: [0x607f7db000-0x607f7fffff]
[    0.000000]    memblock_free: [0x607f9db000-0x607f9fffff]
[    0.000000]    memblock_free: [0x607fbdb000-0x607fbfffff]
[    0.000000]    memblock_free: [0x607fddb000-0x607fdfffff]
[    0.000000] memblock_reserve: [0x707de00000-0x707fdfffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x707dfdb000-0x707dffffff]
[    0.000000]    memblock_free: [0x707e1db000-0x707e1fffff]
[    0.000000]    memblock_free: [0x707e3db000-0x707e3fffff]
[    0.000000]    memblock_free: [0x707e5db000-0x707e5fffff]
[    0.000000]    memblock_free: [0x707e7db000-0x707e7fffff]
[    0.000000]    memblock_free: [0x707e9db000-0x707e9fffff]
[    0.000000]    memblock_free: [0x707ebdb000-0x707ebfffff]
[    0.000000]    memblock_free: [0x707eddb000-0x707edfffff]
[    0.000000]    memblock_free: [0x707efdb000-0x707effffff]
[    0.000000]    memblock_free: [0x707f1db000-0x707f1fffff]
[    0.000000]    memblock_free: [0x707f3db000-0x707f3fffff]
[    0.000000]    memblock_free: [0x707f5db000-0x707f5fffff]
[    0.000000]    memblock_free: [0x707f7db000-0x707f7fffff]
[    0.000000]    memblock_free: [0x707f9db000-0x707f9fffff]
[    0.000000]    memblock_free: [0x707fbdb000-0x707fbfffff]
[    0.000000]    memblock_free: [0x707fddb000-0x707fdfffff]
[    0.000000] memblock_reserve: [0x807d400000-0x807f3fffff]
__alloc_memory_core_early+0x63/0xad pcpu_alloc
[    0.000000]    memblock_free: [0x807d5db000-0x807d5fffff]
[    0.000000]    memblock_free: [0x807d7db000-0x807d7fffff]
[    0.000000]    memblock_free: [0x807d9db000-0x807d9fffff]
[    0.000000]    memblock_free: [0x807dbdb000-0x807dbfffff]
[    0.000000]    memblock_free: [0x807dddb000-0x807ddfffff]
[    0.000000]    memblock_free: [0x807dfdb000-0x807dffffff]
[    0.000000]    memblock_free: [0x807e1db000-0x807e1fffff]
[    0.000000]    memblock_free: [0x807e3db000-0x807e3fffff]
[    0.000000]    memblock_free: [0x807e5db000-0x807e5fffff]
[    0.000000]    memblock_free: [0x807e7db000-0x807e7fffff]
[    0.000000]    memblock_free: [0x807e9db000-0x807e9fffff]
[    0.000000]    memblock_free: [0x807ebdb000-0x807ebfffff]
[    0.000000]    memblock_free: [0x807eddb000-0x807edfffff]
[    0.000000]    memblock_free: [0x807efdb000-0x807effffff]
[    0.000000]    memblock_free: [0x807f1db000-0x807f1fffff]
[    0.000000]    memblock_free: [0x807f3db000-0x807f3fffff]
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88107de00000
s1913304 r8192 d24104 u2097152
[    0.000000] memblock_reserve: [0x807fe002c0-0x807fe002ff]
__alloc_memory_core_early+0x63/0xad pcpu group_offs
[    0.000000] memblock_reserve: [0x807fe00280-0x807fe002bf]
__alloc_memory_core_early+0x63/0xad pcpu group_size
[    0.000000] memblock_reserve: [0x807fe00080-0x807fe0027f]
__alloc_memory_core_early+0x63/0xad pcpu unit_map
[    0.000000] memblock_reserve: [0x807fd9c400-0x807fd9c7ff]
__alloc_memory_core_early+0x63/0xad pcpu unit_off
[    0.000000] pcpu-alloc: s1913304 r8192 d24104 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 [0] 001 [0] 002 [0] 003
[    0.000000] pcpu-alloc: [0] 004 [0] 005 [0] 006 [0] 007
[    0.000000] pcpu-alloc: [0] 064 [0] 065 [0] 066 [0] 067
[    0.000000] pcpu-alloc: [0] 068 [0] 069 [0] 070 [0] 071
[    0.000000] pcpu-alloc: [1] 008 [1] 009 [1] 010 [1] 011
[    0.000000] pcpu-alloc: [1] 012 [1] 013 [1] 014 [1] 015
[    0.000000] pcpu-alloc: [1] 072 [1] 073 [1] 074 [1] 075
[    0.000000] pcpu-alloc: [1] 076 [1] 077 [1] 078 [1] 079
[    0.000000] pcpu-alloc: [2] 016 [2] 017 [2] 018 [2] 019
[    0.000000] pcpu-alloc: [2] 020 [2] 021 [2] 022 [2] 023
[    0.000000] pcpu-alloc: [2] 080 [2] 081 [2] 082 [2] 083
[    0.000000] pcpu-alloc: [2] 084 [2] 085 [2] 086 [2] 087
[    0.000000] pcpu-alloc: [3] 024 [3] 025 [3] 026 [3] 027
[    0.000000] pcpu-alloc: [3] 028 [3] 029 [3] 030 [3] 031
[    0.000000] pcpu-alloc: [3] 088 [3] 089 [3] 090 [3] 091
[    0.000000] pcpu-alloc: [3] 092 [3] 093 [3] 094 [3] 095
[    0.000000] pcpu-alloc: [4] 032 [4] 033 [4] 034 [4] 035
[    0.000000] pcpu-alloc: [4] 036 [4] 037 [4] 038 [4] 039
[    0.000000] pcpu-alloc: [4] 096 [4] 097 [4] 098 [4] 099
[    0.000000] pcpu-alloc: [4] 100 [4] 101 [4] 102 [4] 103
[    0.000000] pcpu-alloc: [5] 040 [5] 041 [5] 042 [5] 043
[    0.000000] pcpu-alloc: [5] 044 [5] 045 [5] 046 [5] 047
[    0.000000] pcpu-alloc: [5] 104 [5] 105 [5] 106 [5] 107
[    0.000000] pcpu-alloc: [5] 108 [5] 109 [5] 110 [5] 111
[    0.000000] pcpu-alloc: [6] 048 [6] 049 [6] 050 [6] 051
[    0.000000] pcpu-alloc: [6] 052 [6] 053 [6] 054 [6] 055
[    0.000000] pcpu-alloc: [6] 112 [6] 113 [6] 114 [6] 115
[    0.000000] pcpu-alloc: [6] 116 [6] 117 [6] 118 [6] 119
[    0.000000] pcpu-alloc: [7] 056 [7] 057 [7] 058 [7] 059
[    0.000000] pcpu-alloc: [7] 060 [7] 061 [7] 062 [7] 063
[    0.000000] pcpu-alloc: [7] 120 [7] 121 [7] 122 [7] 123
[    0.000000] pcpu-alloc: [7] 124 [7] 125 [7] 126 [7] 127
[    0.000000] memblock_reserve: [0x807fd9c280-0x807fd9c3cf]
__alloc_memory_core_early+0x63/0xad pcpu slot
[    0.000000] memblock_reserve: [0x807fd9c200-0x807fd9c27f]
__alloc_memory_core_early+0x63/0xad pcpu chunk_stru
[    0.000000] memblock_reserve: [0x807fd9c180-0x807fd9c1ff]
__alloc_memory_core_early+0x63/0xad pcpu chunk_stru
[    0.000000]    memblock_free: [0x807fd9f000-0x807fd9ffff]
[    0.000000]    memblock_free: [0x807fd9e000-0x807fd9efff]
[    0.000000] build_zonelists: local_node: 0 next_best_node: 0 1 3 4 2 5 6 7
[    0.000000] build_zonelists: local_node: 1 next_best_node: 1 5 2 0 3 4 6 7
[    0.000000] build_zonelists: local_node: 2 next_best_node: 2 6 3 1 4 7 5 0
[    0.000000] build_zonelists: local_node: 3 next_best_node: 3 7 0 2 4 5 6 1
[    0.000000] build_zonelists: local_node: 4 next_best_node: 4 5 6 0 7 2 3 1
[    0.000000] build_zonelists: local_node: 5 next_best_node: 5 7 4 1 6 0 2 3
[    0.000000] build_zonelists: local_node: 6 next_best_node: 6 7 2 4 0 3 1 5
[    0.000000] build_zonelists: local_node: 7 next_best_node: 7 3 6 5 0 2 4 1
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.
Total pages: 132373200
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/x.gz rw root=/dev/ram0 debug ignore_loglevel
unknown_nmi_panic initcall_debug apic=debug pci=routeirq ip=dhcp
load_ramdisk=1 BOOT_IMAGE=kernel.org/bzImage_3.0_k8.2
[    0.000000] memblock_reserve: [0x807fd94180-0x807fd9c17f]
__alloc_memory_core_early+0x63/0xad large system ha
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] memblock_reserve: [0x77af3000-0x7baf2fff]
__alloc_memory_core_early+0x63/0xad swiotlb buffer
[    0.000000] memblock_reserve: [0x807fd74000-0x807fd93fff]
__alloc_memory_core_early+0x63/0xad swiotlb list
[    0.000000] memblock_reserve: [0x807fd34000-0x807fd73fff]
__alloc_memory_core_early+0x63/0xad swiotlb orig_ad
[    0.000000] memblock_reserve: [0x7f746000-0x7f74dfff]
__alloc_memory_core_early+0x63/0xad swiotlb overflo
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Queued invalidation will be enabled to support x2apic
and Intr-remapping.
[    0.000000]    memblock_free: [0x807fd9c800-0x807fd9dfff]
[    0.000000] memblock_reserve: [0x807fd9c800-0x807fd9dfff]
memblock_reserve+0x10/0x12
