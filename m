Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1H2Iby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:31:54 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:47780 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab1H2Ibm (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 29 Aug 2011 04:31:42 -0400
Message-Id: <4E5BDB090200002300030F12@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 29 Aug 2011 02:31:37 -0600
From: "Joey Lee" <jlee@suse.com>
To: <trenn@suse.de>
Cc: <devel@acpica.org>, <jnelson-suse@jamponi.net>, <lenb@kernel.org>,
        <x86@kernel.org>, <eric.piel@tremplin-utc.net>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH 2/2] ACPI: Implement overriding of arbitrary ACPI
 tables via initrd
References: <1314179290-31526-1-git-send-email-trenn@suse.de>
 <1314179290-31526-3-git-send-email-trenn@suse.de>
In-Reply-To: <1314179290-31526-3-git-send-email-trenn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part4A655279.5__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part4A655279.5__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

於 三，2011-08-24 於 11:48 +0200，Thomas Renninger 提到：
> Details can be found in:
> Documentation/acpi/initrd_table_override.txt
> 
> Additional dmesg output of a booted system with
> FACP (FADT), DSDT and SSDT (the 9th dynamically loaded one)
> tables overridden (with ### marked comments):
> 
> ### ACPI tables found glued to initrd
> DSDT ACPI table found in initrd - size: 16234
> FACP ACPI table found in initrd - size: 116
> SSDT ACPI table found in initrd - size: 334
> ### Re-printed e820 map via e820_update() with additionally created
> ### ACPI data section at 0xcff55000 where the ACPI tables passed via
> ### initrd where copied to
> modified physical RAM map:
> ...
>   ### New ACPI data section:
>   modified: 00000000cff55000 - 00000000cff5912c (ACPI data)
>   ### BIOS e820 provided ACPI data section:
>   modified: 00000000cff60000 - 00000000cff69000 (ACPI data)
> ...
> ### Total size of all ACPI tables glued to initrd
> ### The address is initrd_start which gets updated to
> ### initrd_start = initrd_start + "size of all ACPI tables glued to initrd"
> Found acpi tables of size: 16684 at 0xffff8800374c4000
> 
> Disabling lock debugging due to kernel taint
> ### initrd provided FACP and DSDT tables are used instead of BIOS provided ones
> ACPI: FACP @ 0x00000000cff68dd8 Phys table override, replaced with:
> ACPI: FACP 00000000cff58f6a 00074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
> ACPI: DSDT @ 0x00000000cff649d4 Phys table override, replaced with:
> ACPI: DSDT 00000000cff55000 04404 (v01  Intel BLAKFORD 06040000 MSFT 0100000E)
> ...
> ### Much later, the 9th (/sys/firmware/acpi/table/dynamic/SSDT9) dynamically
> ### loaded ACPI table matches and gets overridden:
> ACPI: SSDT @ 0x00000000cff64824 Phys table override, replaced with:
> ACPI: SSDT 00000000cff58fde 0014E (v01  PmRef  Cpu7Ist 00003000 INTL 20110316)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT           (null) 0014E (v01  PmRef  Cpu7Ist 00003000 INTL 20110316)
> ...
> 
> If the initrd does not start with a valid ACPI table signature or the ACPI
> table's checksum is wrong, there is no functional change.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: linux-acpi@vger.kernel.org
> CC: lenb@kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: x86@kernel.org
> ---

This patch works fine to me on Acer TravelMate 8572.
I added a debug message to _BCM method in DSDT then override it in
initrd by follow initrd_table_override.txt.

The attached is my dmesg log.

> +3) How does it work
> +-------------------
> +
> +# Extract the machine's ACPI tables:
> +acpidump >acpidump
> +acpixtract -a acpidump
> +# Disassemble, modify and recompile them:
> +iasl -d *.dat
> +# For example add this statement into a _PRT (PCI Routing Table) function
> +# of the DSDT:
> +Store("Hello World", debug)
> +iasl -sa *.dsl
> +# glue them together with the initrd. ACPI tables go first, original initrd
> +# goes on top:
> +cat TBL1.dat >>instrumented_initrd
> +cat TBL2.dat >>instrumented_initrd
> +cat TBL3.dat >>instrumented_initrd

I suggest use TBL1.aml to replace TBL1.dat in initrd_table_override.txt,
because iasl -sa default generate out *.aml file but not *.dat file, my
iasl version is Intel 20110112-64 [Feb 27 2011].
That will be more clear for the first time user to understand need cat
*.aml file.

Tested-by: Lee, Chun-Yi <jlee@suse.com>


Thank's
Joey Lee


--=__Part4A655279.5__=
Content-Type: text/plain; name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset=0A[    0.000000] =
Initializing cgroup subsys cpu=0A[    0.000000] Linux version 3.0.0-0.7-des=
ktop+ (linux@linux-cr4d.site) (gcc version 4.5.1 20101208 [gcc-4_5-branch =
revision 167585] (SUSE Linux) ) #1 SMP PREEMPT Thu Aug 25 04:01:42 CST =
2011=0A[    0.000000] Command line: root=3D/dev/disk/by-id/ata-Hitachi_HTS5=
45025B9A300_100305PBN206ASC35GYL-part2 resume=3D/dev/disk/by-id/ata-Hitachi=
_HTS545025B9A300_100305PBN206ASC35GYL-part1 splash=3Dsilent quiet =
vga=3D0x317 acpi.debug_level=3D0x2 acpi.debug_layer=3D0xFFFFFFFF=0A[    =
0.000000] BIOS-provided physical RAM map:=0A[    0.000000]  BIOS-e820: =
0000000000000000 - 000000000009c400 (usable)=0A[    0.000000]  BIOS-e820: =
000000000009c400 - 00000000000a0000 (reserved)=0A[    0.000000]  BIOS-e820:=
 00000000000e0000 - 0000000000100000 (reserved)=0A[    0.000000]  =
BIOS-e820: 0000000000100000 - 000000006f27c000 (usable)=0A[    0.000000]  =
BIOS-e820: 000000006f27c000 - 000000006f282000 (reserved)=0A[    0.000000] =
 BIOS-e820: 000000006f282000 - 000000006f3ee000 (usable)=0A[    0.000000]  =
BIOS-e820: 000000006f3ee000 - 000000006f40f000 (reserved)=0A[    0.000000] =
 BIOS-e820: 000000006f40f000 - 000000006f46f000 (usable)=0A[    0.000000]  =
BIOS-e820: 000000006f46f000 - 000000006f470000 (reserved)=0A[    0.000000] =
 BIOS-e820: 000000006f470000 - 000000006f4f1000 (ACPI NVS)=0A[    =
0.000000]  BIOS-e820: 000000006f4f1000 - 000000006f70f000 (reserved)=0A[   =
 0.000000]  BIOS-e820: 000000006f70f000 - 000000006f717000 (usable)=0A[    =
0.000000]  BIOS-e820: 000000006f717000 - 000000006f71f000 (reserved)=0A[   =
 0.000000]  BIOS-e820: 000000006f71f000 - 000000006f76f000 (usable)=0A[    =
0.000000]  BIOS-e820: 000000006f76f000 - 000000006f79f000 (ACPI NVS)=0A[   =
 0.000000]  BIOS-e820: 000000006f79f000 - 000000006f7df000 (usable)=0A[    =
0.000000]  BIOS-e820: 000000006f7df000 - 000000006f7ff000 (ACPI data)=0A[  =
  0.000000]  BIOS-e820: 000000006f7ff000 - 000000006f800000 (usable)=0A[   =
 0.000000]  BIOS-e820: 000000006f800000 - 000000007c000000 (reserved)=0A[  =
  0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=0A[ =
   0.000000]  BIOS-e820: 00000000f0604000 - 00000000f0605000 (reserved)=0A[=
    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)=0A=
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)=
=0A[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 =
(reserved)=0A[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000=
 (reserved)=0A[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee0100=
0 (reserved)=0A[    0.000000]  BIOS-e820: 00000000ff000000 - 00000001000000=
00 (reserved)=0A[    0.000000] NX (Execute Disable) protection: active=0A[ =
   0.000000] DMI present.=0A[    0.000000] DMI: Acer             S2.TXN03.0=
02     /BAP50-CP        , BIOS V1.27   04/25/2011=0A[    0.000000] e820 =
update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> =
(reserved)=0A[    0.000000] e820 remove range: 00000000000a0000 - =
0000000000100000 (usable)=0A[    0.000000] No AGP bridge found=0A[    =
0.000000] last_pfn =3D 0x6f800 max_arch_pfn =3D 0x400000000=0A[    =
0.000000] MTRR default type: uncachable=0A[    0.000000] MTRR fixed ranges =
enabled:=0A[    0.000000]   00000-9FFFF write-back=0A[    0.000000]   =
A0000-BFFFF uncachable=0A[    0.000000]   C0000-D3FFF write-protect=0A[    =
0.000000]   D4000-DFFFF uncachable=0A[    0.000000]   E0000-FFFFF =
write-through=0A[    0.000000] MTRR variable ranges enabled:=0A[    =
0.000000]   0 disabled=0A[    0.000000]   1 base 070000000 mask FF0000000 =
uncachable=0A[    0.000000]   2 base 000000000 mask F80000000 write-back=0A=
[    0.000000]   3 disabled=0A[    0.000000]   4 disabled=0A[    0.000000] =
  5 disabled=0A[    0.000000]   6 disabled=0A[    0.000000]   7 disabled=0A=
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106=0A[    0.000000] found SMP MP-table at [ffff8800000f6d40] f6d40=0A[   =
 0.000000] initial memory mapped : 0 - 20000000=0A[    0.000000] Base =
memory trampoline at [ffff880000097000] 97000 size 20480=0A[    0.000000] =
init_memory_mapping: 0000000000000000-000000006f800000=0A[    0.000000]  =
0000000000 - 006f800000 page 2M=0A[    0.000000] kernel direct mapping =
tables up to 6f800000 @ 6f7dc000-6f7df000=0A[    0.000000] RAMDISK: =
36b48000 - 37ff0000=0A[    0.000000] DSDT ACPI table found in initrd - =
size: 56678=0A[    0.000000] modified physical RAM map:=0A[    0.000000]  =
modified: 0000000000000000 - 0000000000010000 (reserved)=0A[    0.000000]  =
modified: 0000000000010000 - 000000000009c400 (usable)=0A[    0.000000]  =
modified: 000000000009c400 - 00000000000a0000 (reserved)=0A[    0.000000]  =
modified: 00000000000e0000 - 0000000000100000 (reserved)=0A[    0.000000]  =
modified: 0000000000100000 - 000000006f27c000 (usable)=0A[    0.000000]  =
modified: 000000006f27c000 - 000000006f282000 (reserved)=0A[    0.000000]  =
modified: 000000006f282000 - 000000006f3ee000 (usable)=0A[    0.000000]  =
modified: 000000006f3ee000 - 000000006f40f000 (reserved)=0A[    0.000000]  =
modified: 000000006f40f000 - 000000006f46f000 (usable)=0A[    0.000000]  =
modified: 000000006f46f000 - 000000006f470000 (reserved)=0A[    0.000000]  =
modified: 000000006f470000 - 000000006f4f1000 (ACPI NVS)=0A[    0.000000]  =
modified: 000000006f4f1000 - 000000006f70f000 (reserved)=0A[    0.000000]  =
modified: 000000006f70f000 - 000000006f717000 (usable)=0A[    0.000000]  =
modified: 000000006f717000 - 000000006f71f000 (reserved)=0A[    0.000000]  =
modified: 000000006f71f000 - 000000006f76f000 (usable)=0A[    0.000000]  =
modified: 000000006f76f000 - 000000006f79f000 (ACPI NVS)=0A[    0.000000]  =
modified: 000000006f79f000 - 000000006f7ce000 (usable)=0A[    0.000000]  =
modified: 000000006f7ce000 - 000000006f7dbd66 (ACPI data)=0A[    0.000000] =
 modified: 000000006f7dbd66 - 000000006f7df000 (usable)=0A[    0.000000]  =
modified: 000000006f7df000 - 000000006f7ff000 (ACPI data)=0A[    0.000000] =
 modified: 000000006f7ff000 - 000000006f800000 (usable)=0A[    0.000000]  =
modified: 000000006f800000 - 000000007c000000 (reserved)=0A[    0.000000]  =
modified: 00000000e0000000 - 00000000f0000000 (reserved)=0A[    0.000000]  =
modified: 00000000f0604000 - 00000000f0605000 (reserved)=0A[    0.000000]  =
modified: 00000000feaff000 - 00000000feb00000 (reserved)=0A[    0.000000]  =
modified: 00000000fec00000 - 00000000fec10000 (reserved)=0A[    0.000000]  =
modified: 00000000fed00000 - 00000000fed00400 (reserved)=0A[    0.000000]  =
modified: 00000000fed1c000 - 00000000fed90000 (reserved)=0A[    0.000000]  =
modified: 00000000fee00000 - 00000000fee01000 (reserved)=0A[    0.000000]  =
modified: 00000000ff000000 - 0000000100000000 (reserved)=0A[    0.000000] =
Found acpi tables of size: 56678 at 0xffff880036b48000=0A[    0.000000] =
ACPI: RSDP 00000000000f6c80 00024 (v02 PTLTD )=0A[    0.000000] ACPI: XSDT =
000000006f7f0d89 00064 (v01 ACRSYS ACRPRDCT 06040000  LTP 00000000)=0A[    =
0.000000] ACPI: FACP 000000006f7e1000 000F4 (v03 INTEL  CRESTLNE 06040000 =
ALAN 00000001)=0A[    0.000000] Disabling lock debugging due to kernel =
taint=0A[    0.000000] ACPI: DSDT @ 0x000000006f7e2000 Phys table =
override, replaced with:=0A[    0.000000] ACPI: DSDT 000000006f7ce000 =
0DD4E (v02 ACRSYS CALPELLA 06040000 INTL 20060912)=0A[    0.000000] ACPI: =
FACS 000000006f79bfc0 00040=0A[    0.000000] ACPI: HPET 000000006f7fecdb =
00038 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)=0A[    0.000000] ACPI: =
MCFG 000000006f7fed13 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)=0A=
[    0.000000] ACPI: APIC 000000006f7fed4f 00084 (v01 PTLTD  ? APIC   =
06040000  LTP 00000000)=0A[    0.000000] ACPI: BOOT 000000006f7fedd3 00028 =
(v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)=0A[    0.000000] ACPI: SLIC =
000000006f7fedfb 00176 (v01 ACRSYS ACRPRDCT 06040000 acer 00000000)=0A[    =
0.000000] ACPI: ASF! 000000006f7fef71 0008F (v16   CETP     CETP 06040000 =
PTL  00000001)=0A[    0.000000] ACPI: SSDT 000000006f7e0000 009F1 (v01  =
PmRef    CpuPm 00003000 INTL 20060912)=0A[    0.000000] ACPI: Local APIC =
address 0xfee00000=0A[    0.000000] No NUMA configuration found=0A[    =
0.000000] Faking a node at 0000000000000000-000000006f800000=0A[    =
0.000000] Initmem setup node 0 0000000000000000-000000006f800000=0A[    =
0.000000]   NODE_DATA [000000006f7ba000 - 000000006f7cdfff]=0A[    =
0.000000]  [ffffea0000000000-ffffea00019fffff] PMD -> [ffff88006ce00000-fff=
f88006e7fffff] on node 0=0A[    0.000000] Zone PFN ranges:=0A[    =
0.000000]   DMA      0x00000010 -> 0x00001000=0A[    0.000000]   DMA32    =
0x00001000 -> 0x00100000=0A[    0.000000]   Normal   empty=0A[    =
0.000000] Movable zone start PFN for each node=0A[    0.000000] early_node_=
map[8] active PFN ranges=0A[    0.000000]     0: 0x00000010 -> 0x0000009c=
=0A[    0.000000]     0: 0x00000100 -> 0x0006f27c=0A[    0.000000]     0: =
0x0006f282 -> 0x0006f3ee=0A[    0.000000]     0: 0x0006f40f -> 0x0006f46f=
=0A[    0.000000]     0: 0x0006f70f -> 0x0006f717=0A[    0.000000]     0: =
0x0006f71f -> 0x0006f76f=0A[    0.000000]     0: 0x0006f79f -> 0x0006f7df=
=0A[    0.000000]     0: 0x0006f7ff -> 0x0006f800=0A[    0.000000] On node =
0 totalpages: 455789=0A[    0.000000]   DMA zone: 56 pages used for =
memmap=0A[    0.000000]   DMA zone: 5 pages reserved=0A[    0.000000]   =
DMA zone: 3919 pages, LIFO batch:0=0A[    0.000000]   DMA32 zone: 6188 =
pages used for memmap=0A[    0.000000]   DMA32 zone: 445621 pages, LIFO =
batch:31=0A[    0.000000] ACPI: PM-Timer IO Port: 0x408=0A[    0.000000] =
ACPI: Local APIC address 0xfee00000=0A[    0.000000] ACPI: LAPIC (acpi_id[0=
x00] lapic_id[0x00] enabled)=0A[    0.000000] ACPI: LAPIC (acpi_id[0x01] =
lapic_id[0x04] enabled)=0A[    0.000000] ACPI: LAPIC (acpi_id[0x02] =
lapic_id[0x01] enabled)=0A[    0.000000] ACPI: LAPIC (acpi_id[0x03] =
lapic_id[0x05] enabled)=0A[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] =
high edge lint[0x1])=0A[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high =
edge lint[0x1])=0A[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge =
lint[0x1])=0A[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge =
lint[0x1])=0A[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] =
gsi_base[0])=0A[    0.000000] IOAPIC[0]: apic_id 2, version 32, address =
0xfec00000, GSI 0-23=0A[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 =
global_irq 2 high edge)=0A[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq =
9 global_irq 9 high level)=0A[    0.000000] ACPI: IRQ0 used by override.=0A=
[    0.000000] ACPI: IRQ2 used by override.=0A[    0.000000] ACPI: IRQ9 =
used by override.=0A[    0.000000] Using ACPI (MADT) for SMP configuration =
information=0A[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000=0A[=
    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs=0A[    0.000000] =
nr_irqs_gsi: 40=0A[    0.000000] PM: Registered nosave memory: 000000000009=
c000 - 000000000009d000=0A[    0.000000] PM: Registered nosave memory: =
000000000009d000 - 00000000000a0000=0A[    0.000000] PM: Registered nosave =
memory: 00000000000a0000 - 00000000000e0000=0A[    0.000000] PM: Registered=
 nosave memory: 00000000000e0000 - 0000000000100000=0A[    0.000000] PM: =
Registered nosave memory: 000000006f27c000 - 000000006f282000=0A[    =
0.000000] PM: Registered nosave memory: 000000006f3ee000 - 000000006f40f000=
=0A[    0.000000] PM: Registered nosave memory: 000000006f46f000 - =
000000006f470000=0A[    0.000000] PM: Registered nosave memory: 000000006f4=
70000 - 000000006f4f1000=0A[    0.000000] PM: Registered nosave memory: =
000000006f4f1000 - 000000006f70f000=0A[    0.000000] PM: Registered nosave =
memory: 000000006f717000 - 000000006f71f000=0A[    0.000000] PM: Registered=
 nosave memory: 000000006f76f000 - 000000006f79f000=0A[    0.000000] PM: =
Registered nosave memory: 000000006f7ce000 - 000000006f7db000=0A[    =
0.000000] PM: Registered nosave memory: 000000006f7db000 - 000000006f7dc000=
=0A[    0.000000] PM: Registered nosave memory: 000000006f7df000 - =
000000006f7ff000=0A[    0.000000] Allocating PCI resources starting at =
7c000000 (gap: 7c000000:64000000)=0A[    0.000000] Booting paravirtualized =
kernel on bare hardware=0A[    0.000000] setup_percpu: NR_CPUS:512 =
nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1=0A[    0.000000] PERCPU: =
Embedded 26 pages/cpu @ffff88006f000000 s74240 r8192 d24064 u524288=0A[    =
0.000000] pcpu-alloc: s74240 r8192 d24064 u524288 alloc=3D1*2097152=0A[    =
0.000000] pcpu-alloc: [0] 0 1 2 3 =0A[    0.000000] Built 1 zonelists in =
Node order, mobility grouping on.  Total pages: 449540=0A[    0.000000] =
Policy zone: DMA32=0A[    0.000000] Kernel command line: root=3D/dev/disk/b=
y-id/ata-Hitachi_HTS545025B9A300_100305PBN206ASC35GYL-part2 resume=3D/dev/d=
isk/by-id/ata-Hitachi_HTS545025B9A300_100305PBN206ASC35GYL-part1 splash=3Ds=
ilent quiet vga=3D0x317 acpi.debug_level=3D0x2 acpi.debug_layer=3D0xFFFFFFF=
F=0A[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)=0A[=
    0.000000] Checking aperture...=0A[    0.000000] No AGP bridge =
found=0A[    0.000000] Memory: 1760592k/1826816k available (5255k kernel =
code, 3660k absent, 62564k reserved, 6208k data, 936k init)=0A[    =
0.000000] Preemptible hierarchical RCU implementation.=0A[    0.000000] =
NR_IRQS:33024 nr_irqs:712 16=0A[    0.000000] Extended CMOS year: 2000=0A[ =
   0.000000] Console: colour dummy device 80x25=0A[    0.000000] console =
[tty0] enabled=0A[    0.000000] allocated 14680064 bytes of page_cgroup=0A[=
    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't =
want memory cgroups=0A[    0.000000] hpet clockevent registered=0A[    =
0.000000] Fast TSC calibration using PIT=0A[    0.001000] Detected =
2128.025 MHz processor.=0A[    0.000003] Calibrating delay loop (skipped), =
value calculated using timer frequency.. 4256.05 BogoMIPS (lpj=3D2128025)=
=0A[    0.000007] pid_max: default: 32768 minimum: 301=0A[    0.000094] =
Security Framework initialized=0A[    0.000111] AppArmor: AppArmor =
initialized=0A[    0.000348] Dentry cache hash table entries: 262144 =
(order: 9, 2097152 bytes)=0A[    0.000855] Inode-cache hash table entries: =
131072 (order: 8, 1048576 bytes)=0A[    0.001104] Mount-cache hash table =
entries: 256=0A[    0.001232] Initializing cgroup subsys cpuacct=0A[    =
0.001236] Initializing cgroup subsys memory=0A[    0.001251] Initializing =
cgroup subsys devices=0A[    0.001254] Initializing cgroup subsys =
freezer=0A[    0.001256] Initializing cgroup subsys net_cls=0A[    =
0.001258] Initializing cgroup subsys blkio=0A[    0.001296] CPU: Physical =
Processor ID: 0=0A[    0.001298] CPU: Processor Core ID: 0=0A[    =
0.001303] mce: CPU supports 9 MCE banks=0A[    0.001315] CPU0: Thermal =
monitoring enabled (TM1)=0A[    0.001323] using mwait in idle threads.=0A[ =
   0.002139] ACPI: Core revision 20110413=0A[    0.002274] ACPI Warning: =
Incorrect checksum in table [DSDT] - 0x95, should be 0x24 (20110413/tbutils=
-314)=0A[    0.020582] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1=
 pin2=3D-1=0A[    0.030582] CPU0: Intel(R) Core(TM) i3 CPU       M 330  @ =
2.13GHz stepping 02=0A[    0.132027] Performance Events: PEBS fmt1+, =
Westmere events, Intel PMU driver.=0A[    0.132034] ... version:           =
     3=0A[    0.132035] ... bit width:              48=0A[    0.132036] =
... generic registers:      4=0A[    0.132038] ... value mask:             =
0000ffffffffffff=0A[    0.132040] ... max period:             000000007ffff=
fff=0A[    0.132041] ... fixed-purpose events:   3=0A[    0.132042] ... =
event mask:             000000070000000f=0A[    0.138133] NMI watchdog =
enabled, takes one hw-pmu counter.=0A[    0.146046] Booting Node   0, =
Processors  #1=0A[    0.146052] smpboot cpu 1: start_ip =3D 97000=0A[    =
0.237133] NMI watchdog enabled, takes one hw-pmu counter.=0A[    0.243014] =
 #2=0A[    0.243018] smpboot cpu 2: start_ip =3D 97000=0A[    0.334068] =
NMI watchdog enabled, takes one hw-pmu counter.=0A[    0.339970]  #3 =
Ok.=0A[    0.339974] smpboot cpu 3: start_ip =3D 97000=0A[    0.431058] =
NMI watchdog enabled, takes one hw-pmu counter.=0A[    0.432892] Brought =
up 4 CPUs=0A[    0.432897] Total of 4 processors activated (17023.39 =
BogoMIPS).=0A[    0.435127] devtmpfs: initialized=0A[    0.436139] PM: =
Registering ACPI NVS region at 6f470000 (528384 bytes)=0A[    0.436169] =
PM: Registering ACPI NVS region at 6f76f000 (196608 bytes)=0A[    =
0.436326] print_constraints: dummy: =0A[    0.436358] Time: 16:11:19  =
Date: 08/29/11=0A[    0.436412] NET: Registered protocol family 16=0A[    =
0.436602] ACPI: bus type pci registered=0A[    0.436682] PCI: MMCONFIG for =
domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)=0A=
[    0.436685] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in =
E820=0A[    0.501131] PCI: Using configuration type 1 for base access=0A[  =
  0.502059] bio: create slab <bio-0> at 0=0A[    0.504909] ACPI: EC: Look =
up EC in DSDT=0A[    0.521923] [Firmware Bug]: ACPI: BIOS _OSI(Linux) =
query ignored=0A[    0.523045] ACPI: SSDT 000000006f71ac18 003AE (v01  =
PmRef  Cpu0Ist 00003000 INTL 20060912)=0A[    0.523728] ACPI: Dynamic OEM =
Table Load:=0A[    0.523731] ACPI: SSDT           (null) 003AE (v01  PmRef =
 Cpu0Ist 00003000 INTL 20060912)=0A[    0.523990] ACPI: SSDT 000000006f7180=
18 008FB (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)=0A[    0.524639] =
ACPI: Dynamic OEM Table Load:=0A[    0.524642] ACPI: SSDT           (null) =
008FB (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)=0A[    0.530287] ACPI: =
SSDT 000000006f719a98 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)=0A=
[    0.531042] ACPI: Dynamic OEM Table Load:=0A[    0.531045] ACPI: SSDT   =
        (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)=0A[    =
0.535043] ACPI: SSDT 000000006f717d98 00119 (v01  PmRef    ApCst 00003000 =
INTL 20060912)=0A[    0.535744] ACPI: Dynamic OEM Table Load:=0A[    =
0.535747] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 =
INTL 20060912)=0A[    0.539173] ACPI: Interpreter enabled=0A[    0.539176] =
ACPI: (supports S0 S3 S4 S5)=0A[    0.539204] ACPI: Using IOAPIC for =
interrupt routing=0A[    0.545359] ACPI: EC: GPE =3D 0x16, I/O: command/sta=
tus =3D 0x66, data =3D 0x62=0A[    0.545605] ACPI: No dock devices =
found.=0A[    0.545607] HEST: Table not found.=0A[    0.545610] PCI: Using =
host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" and report =
a bug=0A[    0.546201] \_SB_.PCI0:_OSC invalid UUID=0A[    0.546203] _OSC =
request data:1 8 1f =0A[    0.546207] ACPI: PCI Root Bridge [PCI0] (domain =
0000 [bus 00-fe])=0A[    0.547164] pci_root PNP0A08:00: host bridge window =
[io  0x0000-0x0cf7]=0A[    0.547167] pci_root PNP0A08:00: host bridge =
window [io  0x0d00-0xffff]=0A[    0.547169] pci_root PNP0A08:00: host =
bridge window [mem 0x000a0000-0x000bffff]=0A[    0.547172] pci_root =
PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]=0A[    =
0.547174] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbff=
f]=0A[    0.547176] pci_root PNP0A08:00: host bridge window [mem 0x000dc000=
-0x000dffff]=0A[    0.547179] pci_root PNP0A08:00: host bridge window [mem =
0x7c000000-0xfebfffff]=0A[    0.547193] pci 0000:00:00.0: [8086:0044] type =
0 class 0x000600=0A[    0.547213] DMAR: BIOS has allocated no shadow GTT; =
disabling IOMMU for graphics=0A[    0.547234] pci 0000:00:02.0: [8086:0046]=
 type 0 class 0x000300=0A[    0.547246] pci 0000:00:02.0: reg 10: [mem =
0xf0000000-0xf03fffff 64bit]=0A[    0.547253] pci 0000:00:02.0: reg 18: =
[mem 0xd0000000-0xdfffffff 64bit pref]=0A[    0.547259] pci 0000:00:02.0: =
reg 20: [io  0x1800-0x1807]=0A[    0.547325] pci 0000:00:16.0: [8086:3b64] =
type 0 class 0x000780=0A[    0.547355] pci 0000:00:16.0: reg 10: [mem =
0xf0805800-0xf080580f 64bit]=0A[    0.547435] pci 0000:00:16.0: PME# =
supported from D0 D3hot D3cold=0A[    0.547440] pci 0000:00:16.0: PME# =
disabled=0A[    0.547484] pci 0000:00:1a.0: [8086:3b3c] type 0 class =
0x000c03=0A[    0.547511] pci 0000:00:1a.0: reg 10: [mem 0xf0806000-0xf0806=
3ff]=0A[    0.547602] pci 0000:00:1a.0: PME# supported from D0 D3hot =
D3cold=0A[    0.547607] pci 0000:00:1a.0: PME# disabled=0A[    0.547639] =
pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403=0A[    0.547661] pci =
0000:00:1b.0: reg 10: [mem 0xf0600000-0xf0603fff 64bit]=0A[    0.547741] =
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold=0A[    0.547746] pci =
0000:00:1b.0: PME# disabled=0A[    0.547774] pci 0000:00:1c.0: [8086:3b42] =
type 1 class 0x000604=0A[    0.547859] pci 0000:00:1c.0: PME# supported =
from D0 D3hot D3cold=0A[    0.547864] pci 0000:00:1c.0: PME# disabled=0A[  =
  0.547900] pci 0000:00:1c.5: [8086:3b4c] type 1 class 0x000604=0A[    =
0.547983] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold=0A[    =
0.547988] pci 0000:00:1c.5: PME# disabled=0A[    0.548026] pci 0000:00:1d.0=
: [8086:3b34] type 0 class 0x000c03=0A[    0.548052] pci 0000:00:1d.0: reg =
10: [mem 0xf0806400-0xf08067ff]=0A[    0.548144] pci 0000:00:1d.0: PME# =
supported from D0 D3hot D3cold=0A[    0.548148] pci 0000:00:1d.0: PME# =
disabled=0A[    0.548175] pci 0000:00:1e.0: [8086:2448] type 1 class =
0x000604=0A[    0.548255] pci 0000:00:1f.0: [8086:3b09] type 0 class =
0x000601=0A[    0.548379] pci 0000:00:1f.2: [8086:3b29] type 0 class =
0x000106=0A[    0.548407] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]=0A[=
    0.548418] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]=0A[    =
0.548430] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]=0A[    0.548442] =
pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]=0A[    0.548453] pci =
0000:00:1f.2: reg 20: [io  0x1820-0x183f]=0A[    0.548465] pci 0000:00:1f.2=
: reg 24: [mem 0xf0805000-0xf08057ff]=0A[    0.548514] pci 0000:00:1f.2: =
PME# supported from D3hot=0A[    0.548519] pci 0000:00:1f.2: PME# =
disabled=0A[    0.548543] pci 0000:00:1f.3: [8086:3b30] type 0 class =
0x000c05=0A[    0.548564] pci 0000:00:1f.3: reg 10: [mem 0xf0806800-0xf0806=
8ff 64bit]=0A[    0.548595] pci 0000:00:1f.3: reg 20: [io  0x1840-0x185f]=
=0A[    0.548644] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180=0A[  =
  0.548673] pci 0000:00:1f.6: reg 10: [mem 0xf0604000-0xf0604fff 64bit]=0A[=
    0.548887] pci 0000:02:00.0: [14e4:1690] type 0 class 0x000200=0A[    =
0.548930] pci 0000:02:00.0: reg 10: [mem 0xf0400000-0xf040ffff 64bit]=0A[  =
  0.549105] pci 0000:02:00.0: PME# supported from D3hot D3cold=0A[    =
0.549113] pci 0000:02:00.0: PME# disabled=0A[    0.550892] pci 0000:00:1c.0=
: PCI bridge to [bus 02-02]=0A[    0.550902] pci 0000:00:1c.0:   bridge =
window [io  0xf000-0x0000] (disabled)=0A[    0.550911] pci 0000:00:1c.0:   =
bridge window [mem 0xf0400000-0xf04fffff]=0A[    0.550926] pci 0000:00:1c.0=
:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)=0A[    =
0.551079] pci 0000:09:00.0: [8086:422c] type 0 class 0x000280=0A[    =
0.551138] pci 0000:09:00.0: reg 10: [mem 0xf0500000-0xf0501fff 64bit]=0A[  =
  0.551335] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold=0A[    =
0.551362] pci 0000:09:00.0: PME# disabled=0A[    0.551496] pci 0000:00:1c.5=
: PCI bridge to [bus 09-09]=0A[    0.551501] pci 0000:00:1c.5:   bridge =
window [io  0xf000-0x0000] (disabled)=0A[    0.551507] pci 0000:00:1c.5:   =
bridge window [mem 0xf0500000-0xf05fffff]=0A[    0.551515] pci 0000:00:1c.5=
:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)=0A[    =
0.551591] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive =
decode)=0A[    0.551597] pci 0000:00:1e.0:   bridge window [io  0xf000-0x00=
00] (disabled)=0A[    0.551602] pci 0000:00:1e.0:   bridge window [mem =
0xfff00000-0x000fffff] (disabled)=0A[    0.551610] pci 0000:00:1e.0:   =
bridge window [mem 0xfff00000-0x000fffff pref] (disabled)=0A[    0.551613] =
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive =
decode)=0A[    0.551615] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xff=
ff] (subtractive decode)=0A[    0.551618] pci 0000:00:1e.0:   bridge =
window [mem 0x000a0000-0x000bffff] (subtractive decode)=0A[    0.551620] =
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive =
decode)=0A[    0.551623] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-=
0x000dbfff] (subtractive decode)=0A[    0.551625] pci 0000:00:1e.0:   =
bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)=0A[    =
0.551628] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] =
(subtractive decode)=0A[    0.551652] ACPI: PCI Interrupt Routing Table =
[\_SB_.PCI0._PRT]=0A[    0.551969] ACPI: PCI Interrupt Routing Table =
[\_SB_.PCI0.P0P1._PRT]=0A[    0.552136] ACPI: PCI Interrupt Routing Table =
[\_SB_.PCI0.RP01._PRT]=0A[    0.552230] ACPI: PCI Interrupt Routing Table =
[\_SB_.PCI0.RP06._PRT]=0A[    0.552365] \_SB_.PCI0:_OSC invalid UUID=0A[   =
 0.552367] _OSC request data:1 1f 1f =0A[    0.552371]  pci0000:00: =
Requesting ACPI _OSC control (0x1d)=0A[    0.552426] \_SB_.PCI0:_OSC =
invalid UUID=0A[    0.552428] _OSC request data:1 0 1d =0A[    0.552431]  =
pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: =
0x1d=0A[    0.552433] ACPI _OSC control for PCIe not granted, disabling =
ASPM=0A[    0.558205] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus =
ff])=0A[    0.558250] pci 0000:ff:00.0: [8086:2c62] type 0 class =
0x000600=0A[    0.558271] pci 0000:ff:00.1: [8086:2d01] type 0 class =
0x000600=0A[    0.558294] pci 0000:ff:02.0: [8086:2d10] type 0 class =
0x000600=0A[    0.558314] pci 0000:ff:02.1: [8086:2d11] type 0 class =
0x000600=0A[    0.558332] pci 0000:ff:02.2: [8086:2d12] type 0 class =
0x000600=0A[    0.558351] pci 0000:ff:02.3: [8086:2d13] type 0 class =
0x000600=0A[    0.558387]  pci0000:ff: Requesting ACPI _OSC control =
(0x1d)=0A[    0.558390]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND=
), returned control mask: 0x1d=0A[    0.558392] ACPI _OSC control for PCIe =
not granted, disabling ASPM=0A[    0.558684] ACPI: PCI Interrupt Link =
[LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)=0A[    0.558753] ACPI: PCI =
Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 15)=0A[    0.558826] =
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, =
disabled.=0A[    0.558894] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 =
7 11 12 14 15) *10=0A[    0.558964] ACPI: PCI Interrupt Link [LNKE] (IRQs =
1 3 4 5 6 7 10 12 14 15) *0, disabled.=0A[    0.559031] ACPI: PCI =
Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.=0A[    =
0.559098] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) =
*11=0A[    0.559166] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 =
12 14 15) *10=0A[    0.559254] vgaarb: device added: PCI:0000:00:02.0,decod=
es=3Dio+mem,owns=3Dio+mem,locks=3Dnone=0A[    0.559265] vgaarb: loaded=0A[ =
   0.559267] vgaarb: bridge control possible 0000:00:02.0=0A[    0.559448] =
SCSI subsystem initialized=0A[    0.559506] libata version 3.00 loaded.=0A[=
    0.559553] usbcore: registered new interface driver usbfs=0A[    =
0.559567] usbcore: registered new interface driver hub=0A[    0.559595] =
usbcore: registered new device driver usb=0A[    0.559665] PCI: Using ACPI =
for IRQ routing=0A[    0.569722] PCI: pci_cache_line_size set to 64 =
bytes=0A[    0.569912] reserve RAM buffer: 000000000009c400 - 000000000009f=
fff =0A[    0.569914] reserve RAM buffer: 000000006f27c000 - 000000006fffff=
ff =0A[    0.569921] reserve RAM buffer: 000000006f3ee000 - 000000006ffffff=
f =0A[    0.569926] reserve RAM buffer: 000000006f46f000 - 000000006fffffff=
 =0A[    0.569932] reserve RAM buffer: 000000006f717000 - 000000006fffffff =
=0A[    0.569936] reserve RAM buffer: 000000006f76f000 - 000000006fffffff =
=0A[    0.569940] reserve RAM buffer: 000000006f7ce000 - 000000006fffffff =
=0A[    0.569943] reserve RAM buffer: 000000006f7df000 - 000000006fffffff =
=0A[    0.569945] reserve RAM buffer: 000000006f800000 - 000000006fffffff =
=0A[    0.570046] NetLabel: Initializing=0A[    0.570048] NetLabel:  =
domain hash size =3D 128=0A[    0.570049] NetLabel:  protocols =3D =
UNLABELED CIPSOv4=0A[    0.570063] NetLabel:  unlabeled traffic allowed by =
default=0A[    0.570079] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, =
0, 0=0A[    0.570085] hpet0: 8 comparators, 64-bit 14.318180 MHz counter=0A=
[    0.572111] Switching to clocksource hpet=0A[    0.572827] Switched to =
NOHz mode on CPU #0=0A[    0.572939] Switched to NOHz mode on CPU #2=0A[   =
 0.572956] Switched to NOHz mode on CPU #1=0A[    0.572974] Switched to =
NOHz mode on CPU #3=0A[    0.573634] AppArmor: AppArmor Filesystem =
Enabled=0A[    0.573655] pnp: PnP ACPI init=0A[    0.573669] ACPI: bus =
type pnp registered=0A[    0.574216] pnp 00:00: [bus 00-fe]=0A[    =
0.574220] pnp 00:00: [io  0x0000-0x0cf7 window]=0A[    0.574222] pnp =
00:00: [io  0x0cf8-0x0cff]=0A[    0.574224] pnp 00:00: [io  0x0d00-0xffff =
window]=0A[    0.574226] pnp 00:00: [mem 0x000a0000-0x000bffff window]=0A[ =
   0.574229] pnp 00:00: [mem 0x000c0000-0x000c3fff window]=0A[    =
0.574231] pnp 00:00: [mem 0x000c4000-0x000c7fff window]=0A[    0.574233] =
pnp 00:00: [mem 0x000c8000-0x000cbfff window]=0A[    0.574235] pnp 00:00: =
[mem 0x000cc000-0x000cffff window]=0A[    0.574237] pnp 00:00: [mem =
0x000d0000-0x000d3fff window]=0A[    0.574239] pnp 00:00: [mem 0x000d4000-0=
x000d7fff window]=0A[    0.574241] pnp 00:00: [mem 0x000d8000-0x000dbfff =
window]=0A[    0.574243] pnp 00:00: [mem 0x000dc000-0x000dffff window]=0A[ =
   0.574246] pnp 00:00: [mem 0x000e0000-0x000e3fff window]=0A[    =
0.574249] pnp 00:00: [mem 0x000e4000-0x000e7fff window]=0A[    0.574251] =
pnp 00:00: [mem 0x000e8000-0x000ebfff window]=0A[    0.574253] pnp 00:00: =
[mem 0x000ec000-0x000effff window]=0A[    0.574255] pnp 00:00: [mem =
0x000f0000-0x000fffff window]=0A[    0.574257] pnp 00:00: [mem 0x7c000000-0=
xfebfffff window]=0A[    0.574259] pnp 00:00: [mem 0xfed40000-0xfed44fff =
window]=0A[    0.574322] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 =
PNP0a03 (active)=0A[    0.574393] pnp 00:01: [io  0x0000-0x001f]=0A[    =
0.574395] pnp 00:01: [io  0x0081-0x0091]=0A[    0.574397] pnp 00:01: [io  =
0x0093-0x009f]=0A[    0.574399] pnp 00:01: [io  0x00c0-0x00df]=0A[    =
0.574401] pnp 00:01: [dma 4]=0A[    0.574431] pnp 00:01: Plug and Play =
ACPI device, IDs PNP0200 (active)=0A[    0.574442] pnp 00:02: [mem =
0xff000000-0xffffffff]=0A[    0.574471] pnp 00:02: Plug and Play ACPI =
device, IDs INT0800 (active)=0A[    0.574578] pnp 00:03: [irq 0 =
disabled]=0A[    0.574589] pnp 00:03: [irq 8]=0A[    0.574591] pnp 00:03: =
[mem 0xfed00000-0xfed003ff]=0A[    0.574621] pnp 00:03: Plug and Play ACPI =
device, IDs PNP0103 (active)=0A[    0.574635] pnp 00:04: [io  0x00f0]=0A[  =
  0.574641] pnp 00:04: [irq 13]=0A[    0.574669] pnp 00:04: Plug and Play =
ACPI device, IDs PNP0c04 (active)=0A[    0.574683] pnp 00:05: [io  =
0x002e-0x002f]=0A[    0.574685] pnp 00:05: [io  0x004e-0x004f]=0A[    =
0.574687] pnp 00:05: [io  0x0061]=0A[    0.574689] pnp 00:05: [io  =
0x0063]=0A[    0.574691] pnp 00:05: [io  0x0065]=0A[    0.574692] pnp =
00:05: [io  0x0067]=0A[    0.574694] pnp 00:05: [io  0x0070]=0A[    =
0.574696] pnp 00:05: [io  0x0080]=0A[    0.574697] pnp 00:05: [io  =
0x0092]=0A[    0.574699] pnp 00:05: [io  0x00b2-0x00b3]=0A[    0.574701] =
pnp 00:05: [io  0x0680-0x069f]=0A[    0.574703] pnp 00:05: [io  0x0500-0x05=
0f]=0A[    0.574706] pnp 00:05: [io  0xffff]=0A[    0.574707] pnp 00:05: =
[io  0xffff]=0A[    0.574709] pnp 00:05: [io  0x0400-0x047f]=0A[    =
0.574711] pnp 00:05: [io  0x1180-0x11ff]=0A[    0.574713] pnp 00:05: [io  =
0x164e-0x164f]=0A[    0.574715] pnp 00:05: [io  0xfe00]=0A[    0.574770] =
system 00:05: [io  0x0680-0x069f] has been reserved=0A[    0.574773] =
system 00:05: [io  0x0500-0x050f] has been reserved=0A[    0.574776] =
system 00:05: [io  0xffff] has been reserved=0A[    0.574778] system =
00:05: [io  0xffff] has been reserved=0A[    0.574782] system 00:05: [io  =
0x0400-0x047f] has been reserved=0A[    0.574784] system 00:05: [io  =
0x1180-0x11ff] has been reserved=0A[    0.574787] system 00:05: [io  =
0x164e-0x164f] has been reserved=0A[    0.574790] system 00:05: [io  =
0xfe00] has been reserved=0A[    0.574793] system 00:05: Plug and Play =
ACPI device, IDs PNP0c02 (active)=0A[    0.574838] pnp 00:06: [io  =
0x06a0-0x06af]=0A[    0.574840] pnp 00:06: [io  0x06b0-0x06ff]=0A[    =
0.574887] system 00:06: [io  0x06a0-0x06af] has been reserved=0A[    =
0.574890] system 00:06: [io  0x06b0-0x06ff] has been reserved=0A[    =
0.574892] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)=0A[=
    0.574938] pnp 00:07: [io  0x0070-0x0077]=0A[    0.574971] pnp 00:07: =
Plug and Play ACPI device, IDs PNP0b00 (active)=0A[    0.574989] pnp =
00:08: [irq 12]=0A[    0.575021] pnp 00:08: Plug and Play ACPI device, IDs =
SYN1b20 SYN1b00 SYN0002 PNP0f13 (active)=0A[    0.575033] pnp 00:09: [io  =
0x0060]=0A[    0.575035] pnp 00:09: [io  0x0064]=0A[    0.575040] pnp =
00:09: [irq 1]=0A[    0.575070] pnp 00:09: Plug and Play ACPI device, IDs =
PNP0303 (active)=0A[    0.575510] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]=0A=
[    0.575512] pnp 00:0a: [mem 0xfed10000-0xfed13fff]=0A[    0.575514] pnp =
00:0a: [mem 0xfed18000-0xfed18fff]=0A[    0.575516] pnp 00:0a: [mem =
0xfed19000-0xfed19fff]=0A[    0.575518] pnp 00:0a: [mem 0xe0000000-0xefffff=
ff]=0A[    0.575520] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff =
disabled]=0A[    0.575523] pnp 00:0a: [mem 0xfeaff000-0xfeafffff]=0A[    =
0.575524] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]=0A[    0.575526] pnp =
00:0a: [mem 0xfed90000-0xfed8ffff disabled]=0A[    0.575529] pnp 00:0a: =
[mem 0xfed40000-0xfed44fff]=0A[    0.575530] pnp 00:0a: [mem 0xfed45000-0xf=
ed8ffff]=0A[    0.575532] pnp 00:0a: [mem 0xff000000-0xffffffff]=0A[    =
0.575534] pnp 00:0a: [mem 0xfee00000-0xfeefffff]=0A[    0.575603] system =
00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved=0A[    0.575606] =
system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved=0A[    =
0.575609] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved=0A[  =
  0.575612] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved=0A[=
    0.575615] system 00:0a: [mem 0xe0000000-0xefffffff] has been =
reserved=0A[    0.575618] system 00:0a: [mem 0xfeaff000-0xfeafffff] has =
been reserved=0A[    0.575621] system 00:0a: [mem 0xfed20000-0xfed3ffff] =
has been reserved=0A[    0.575624] system 00:0a: [mem 0xfed40000-0xfed44fff=
] has been reserved=0A[    0.575627] system 00:0a: [mem 0xfed45000-0xfed8ff=
ff] has been reserved=0A[    0.575630] system 00:0a: [mem 0xff000000-0xffff=
ffff] has been reserved=0A[    0.575633] system 00:0a: [mem 0xfee00000-0xfe=
efffff] could not be reserved=0A[    0.575636] system 00:0a: Plug and Play =
ACPI device, IDs PNP0c02 (active)=0A[    0.575809] pnp 00:0b: [bus ff]=0A[ =
   0.575856] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)=0A[=
    0.575869] pnp: PnP ACPI: found 12 devices=0A[    0.575870] ACPI: ACPI =
bus type pnp unregistered=0A[    0.581990] PCI: max bus depth: 1 pci_try_nu=
m: 2=0A[    0.582029] pci 0000:00:1c.5: BAR 15: assigned [mem 0x7c000000-0x=
7c1fffff 64bit pref]=0A[    0.582033] pci 0000:00:1c.5: BAR 13: assigned =
[io  0x2000-0x2fff]=0A[    0.582036] pci 0000:00:1c.0: BAR 15: assigned =
[mem 0x7c200000-0x7c3fffff 64bit pref]=0A[    0.582040] pci 0000:00:1c.0: =
BAR 13: assigned [io  0x3000-0x3fff]=0A[    0.582042] pci 0000:00:1c.0: =
PCI bridge to [bus 02-02]=0A[    0.582046] pci 0000:00:1c.0:   bridge =
window [io  0x3000-0x3fff]=0A[    0.582052] pci 0000:00:1c.0:   bridge =
window [mem 0xf0400000-0xf04fffff]=0A[    0.582058] pci 0000:00:1c.0:   =
bridge window [mem 0x7c200000-0x7c3fffff 64bit pref]=0A[    0.582066] pci =
0000:00:1c.5: PCI bridge to [bus 09-09]=0A[    0.582069] pci 0000:00:1c.5: =
  bridge window [io  0x2000-0x2fff]=0A[    0.582076] pci 0000:00:1c.5:   =
bridge window [mem 0xf0500000-0xf05fffff]=0A[    0.582081] pci 0000:00:1c.5=
:   bridge window [mem 0x7c000000-0x7c1fffff 64bit pref]=0A[    0.582090] =
pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]=0A[    0.582091] pci 0000:00:1e=
.0:   bridge window [io  disabled]=0A[    0.582098] pci 0000:00:1e.0:   =
bridge window [mem disabled]=0A[    0.582102] pci 0000:00:1e.0:   bridge =
window [mem pref disabled]=0A[    0.582125] pci 0000:00:1c.0: PCI INT A -> =
GSI 16 (level, low) -> IRQ 16=0A[    0.582131] pci 0000:00:1c.0: setting =
latency timer to 64=0A[    0.582143] pci 0000:00:1c.5: PCI INT B -> GSI 17 =
(level, low) -> IRQ 17=0A[    0.582148] pci 0000:00:1c.5: setting latency =
timer to 64=0A[    0.582157] pci 0000:00:1e.0: setting latency timer to =
64=0A[    0.582162] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]=0A[    =
0.582164] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]=0A[    0.582166] =
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]=0A[    0.582168] =
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]=0A[    0.582179] =
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]=0A[    0.582181] =
pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]=0A[    0.582183] =
pci_bus 0000:00: resource 10 [mem 0x7c000000-0xfebfffff]=0A[    0.582186] =
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]=0A[    0.582188] pci_bus =
0000:02: resource 1 [mem 0xf0400000-0xf04fffff]=0A[    0.582190] pci_bus =
0000:02: resource 2 [mem 0x7c200000-0x7c3fffff 64bit pref]=0A[    =
0.582192] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]=0A[    0.582194] =
pci_bus 0000:09: resource 1 [mem 0xf0500000-0xf05fffff]=0A[    0.582197] =
pci_bus 0000:09: resource 2 [mem 0x7c000000-0x7c1fffff 64bit pref]=0A[    =
0.582199] pci_bus 0000:0c: resource 4 [io  0x0000-0x0cf7]=0A[    0.582201] =
pci_bus 0000:0c: resource 5 [io  0x0d00-0xffff]=0A[    0.582203] pci_bus =
0000:0c: resource 6 [mem 0x000a0000-0x000bffff]=0A[    0.582206] pci_bus =
0000:0c: resource 7 [mem 0x000d4000-0x000d7fff]=0A[    0.582208] pci_bus =
0000:0c: resource 8 [mem 0x000d8000-0x000dbfff]=0A[    0.582210] pci_bus =
0000:0c: resource 9 [mem 0x000dc000-0x000dffff]=0A[    0.582212] pci_bus =
0000:0c: resource 10 [mem 0x7c000000-0xfebfffff]=0A[    0.582309] NET: =
Registered protocol family 2=0A[    0.582435] IP route cache hash table =
entries: 65536 (order: 7, 524288 bytes)=0A[    0.583111] TCP established =
hash table entries: 262144 (order: 10, 4194304 bytes)=0A[    0.584672] TCP =
bind hash table entries: 65536 (order: 8, 1048576 bytes)=0A[    0.585024] =
TCP: Hash tables configured (established 262144 bind 65536)=0A[    =
0.585026] TCP reno registered=0A[    0.585036] UDP hash table entries: =
1024 (order: 3, 32768 bytes)=0A[    0.585057] UDP-Lite hash table entries: =
1024 (order: 3, 32768 bytes)=0A[    0.585233] NET: Registered protocol =
family 1=0A[    0.585250] pci 0000:00:02.0: Boot video device=0A[    =
0.585393] PCI: CLS 64 bytes, default 64=0A[    0.585444] Unpacking =
initramfs...=0A[    1.021678] Freeing initrd memory: 21152k freed=0A[    =
1.026475] Simple Boot Flag at 0x36 set to 0x1=0A[    1.027164] audit: =
initializing netlink socket (disabled)=0A[    1.027179] type=3D2000 =
audit(1314634279.859:1): initialized=0A[    1.048261] HugeTLB registered 2 =
MB page size, pre-allocated 0 pages=0A[    1.048632] VFS: Disk quotas =
dquot_6.5.2=0A[    1.048673] Dquot-cache hash table entries: 512 (order 0, =
4096 bytes)=0A[    1.048897] msgmni has been set to 3479=0A[    1.049176] =
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)=0A[   =
 1.049211] io scheduler noop registered=0A[    1.049213] io scheduler =
deadline registered=0A[    1.049242] io scheduler cfq registered =
(default)=0A[    1.049564] vesafb: mode is 1024x768x16, linelength=3D2048, =
pages=3D84=0A[    1.049566] vesafb: scrolling: redraw=0A[    1.049569] =
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0=0A[    1.050408] =
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90010980000, using =
3072k, total 131008k=0A[    1.114201] Console: switching to colour frame =
buffer device 128x48=0A[    1.177848] fb0: VESA VGA frame buffer device=0A[=
    1.177859] intel_idle: MWAIT substates: 0x1120=0A[    1.177861] =
intel_idle: v0.4 model 0x25=0A[    1.177862] intel_idle: lapic_timer_reliab=
le_states 0xffffffff=0A[    1.177898] ERST: Table is not found!=0A[    =
1.177968] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled=0A[    =
1.299341] Non-volatile memory driver v1.3=0A[    1.299343] Linux agpgart =
interface v0.103=0A[    1.299424] agpgart-intel 0000:00:00.0: Intel HD =
Graphics Chipset=0A[    1.299577] agpgart-intel 0000:00:00.0: detected gtt =
size: 2097152K total, 262144K mappable=0A[    1.300615] agpgart-intel =
0000:00:00.0: detected 131072K stolen memory=0A[    1.300769] agpgart-intel=
 0000:00:00.0: AGP aperture is 256M @ 0xd0000000=0A[    1.300936] ahci =
0000:00:1f.2: version 3.0=0A[    1.300962] ahci 0000:00:1f.2: PCI INT B -> =
GSI 19 (level, low) -> IRQ 19=0A[    1.301013] ahci 0000:00:1f.2: irq 40 =
for MSI/MSI-X=0A[    1.301045] ahci: SSS flag set, parallel bus scan =
disabled=0A[    1.301083] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 =
ports 3 Gbps 0x3 impl SATA mode=0A[    1.301087] ahci 0000:00:1f.2: flags: =
64bit ncq sntf ilck stag pm led clo pio slum part ems apst =0A[    =
1.301093] ahci 0000:00:1f.2: setting latency timer to 64=0A[    1.303296] =
scsi0 : ahci=0A[    1.303409] scsi1 : ahci=0A[    1.303483] scsi2 : =
ahci=0A[    1.303554] scsi3 : ahci=0A[    1.303606] ata1: SATA max =
UDMA/133 abar m2048@0xf0805000 port 0xf0805100 irq 40=0A[    1.303609] =
ata2: SATA max UDMA/133 abar m2048@0xf0805000 port 0xf0805180 irq 40=0A[   =
 1.303611] ata3: DUMMY=0A[    1.303612] ata4: DUMMY=0A[    1.303712] Fixed =
MDIO Bus: probed=0A[    1.303717] ehci_hcd: USB 2.0 'Enhanced' Host =
Controller (EHCI) Driver=0A[    1.303736] ehci_hcd 0000:00:1a.0: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16=0A[    1.303754] ehci_hcd 0000:00:1a.0: =
setting latency timer to 64=0A[    1.303758] ehci_hcd 0000:00:1a.0: EHCI =
Host Controller=0A[    1.303784] ehci_hcd 0000:00:1a.0: new USB bus =
registered, assigned bus number 1=0A[    1.303819] ehci_hcd 0000:00:1a.0: =
debug port 2=0A[    1.307725] ehci_hcd 0000:00:1a.0: cache line size of 64 =
is not supported=0A[    1.307742] ehci_hcd 0000:00:1a.0: irq 16, io mem =
0xf0806000=0A[    1.316885] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI =
1.00=0A[    1.316932] usb usb1: New USB device found, idVendor=3D1d6b, =
idProduct=3D0002=0A[    1.316938] usb usb1: New USB device strings: =
Mfr=3D3, Product=3D2, SerialNumber=3D1=0A[    1.316943] usb usb1: Product: =
EHCI Host Controller=0A[    1.316948] usb usb1: Manufacturer: Linux =
3.0.0-0.7-desktop+ ehci_hcd=0A[    1.316952] usb usb1: SerialNumber: =
0000:00:1a.0=0A[    1.317064] hub 1-0:1.0: USB hub found=0A[    1.317068] =
hub 1-0:1.0: 3 ports detected=0A[    1.317149] ehci_hcd 0000:00:1d.0: PCI =
INT A -> GSI 23 (level, low) -> IRQ 23=0A[    1.317162] ehci_hcd 0000:00:1d=
.0: setting latency timer to 64=0A[    1.317166] ehci_hcd 0000:00:1d.0: =
EHCI Host Controller=0A[    1.317174] ehci_hcd 0000:00:1d.0: new USB bus =
registered, assigned bus number 2=0A[    1.317203] ehci_hcd 0000:00:1d.0: =
debug port 2=0A[    1.321193] ehci_hcd 0000:00:1d.0: cache line size of 64 =
is not supported=0A[    1.321209] ehci_hcd 0000:00:1d.0: irq 23, io mem =
0xf0806400=0A[    1.330875] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI =
1.00=0A[    1.330913] usb usb2: New USB device found, idVendor=3D1d6b, =
idProduct=3D0002=0A[    1.330918] usb usb2: New USB device strings: =
Mfr=3D3, Product=3D2, SerialNumber=3D1=0A[    1.330923] usb usb2: Product: =
EHCI Host Controller=0A[    1.330928] usb usb2: Manufacturer: Linux =
3.0.0-0.7-desktop+ ehci_hcd=0A[    1.330932] usb usb2: SerialNumber: =
0000:00:1d.0=0A[    1.331036] hub 2-0:1.0: USB hub found=0A[    1.331040] =
hub 2-0:1.0: 3 ports detected=0A[    1.331112] ohci_hcd: USB 1.1 'Open' =
Host Controller (OHCI) Driver=0A[    1.331123] uhci_hcd: USB Universal =
Host Controller Interface driver=0A[    1.331157] Initializing USB Mass =
Storage driver...=0A[    1.331178] usbcore: registered new interface =
driver usb-storage=0A[    1.331180] USB Mass Storage support registered.=0A=
[    1.331189] usbcore: registered new interface driver ums-alauda=0A[    =
1.331197] usbcore: registered new interface driver ums-cypress=0A[    =
1.331206] usbcore: registered new interface driver ums-datafab=0A[    =
1.331215] usbcore: registered new interface driver ums-freecom=0A[    =
1.331224] usbcore: registered new interface driver ums-isd200=0A[    =
1.331232] usbcore: registered new interface driver ums-jumpshot=0A[    =
1.331240] usbcore: registered new interface driver ums-karma=0A[    =
1.331250] usbcore: registered new interface driver ums-onetouch=0A[    =
1.331258] usbcore: registered new interface driver ums-sddr09=0A[    =
1.331267] usbcore: registered new interface driver ums-sddr55=0A[    =
1.331275] usbcore: registered new interface driver ums-usbat=0A[    =
1.331326] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at =
0x60,0x64 irq 1,12=0A[    1.337272] i8042: Detected active multiplexing =
controller, rev 1.1=0A[    1.340968] serio: i8042 KBD port at 0x60,0x64 =
irq 1=0A[    1.340998] serio: i8042 AUX0 port at 0x60,0x64 irq 12=0A[    =
1.341017] serio: i8042 AUX1 port at 0x60,0x64 irq 12=0A[    1.341037] =
serio: i8042 AUX2 port at 0x60,0x64 irq 12=0A[    1.341056] serio: i8042 =
AUX3 port at 0x60,0x64 irq 12=0A[    1.341136] mousedev: PS/2 mouse device =
common for all mice=0A[    1.341260] rtc_cmos 00:07: RTC can wake from =
S4=0A[    1.341373] rtc_cmos 00:07: rtc core: registered rtc_cmos as =
rtc0=0A[    1.341404] rtc0: alarms up to one month, y3k, 242 bytes nvram, =
hpet irqs=0A[    1.341514] cpuidle: using governor ladder=0A[    1.341668] =
cpuidle: using governor menu=0A[    1.341670] EFI Variables Facility v0.08 =
2004-May-17=0A[    1.341911] usbcore: registered new interface driver =
usbhid=0A[    1.341912] usbhid: USB HID core driver=0A[    1.342135] TCP =
cubic registered=0A[    1.342315] NET: Registered protocol family 10=0A[   =
 1.342943] lib80211: common routines for IEEE802.11 drivers=0A[    =
1.342946] lib80211_crypt: registered algorithm 'NULL'=0A[    1.342948] =
Registering the dns_resolver key type=0A[    1.342964] libceph: loaded =
(mon/osd proto 15/24, osdmap 5/6 5/6)=0A[    1.343052] PM: Checking =
hibernation image partition /dev/disk/by-id/ata-Hitachi_HTS545025B9A300_100=
305PBN206ASC35GYL-part1=0A[    1.362464] input: AT Translated Set 2 =
keyboard as /devices/platform/i8042/serio0/input/input0=0A[    1.609820] =
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=0A[    1.611083] =
ata1.00: ATA-8: Hitachi HTS545025B9A300, PB2OC60F, max UDMA/133=0A[    =
1.611088] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), =
AA=0A[    1.612661] ata1.00: configured for UDMA/133=0A[    1.613025] scsi =
0:0:0:0: Direct-Access     ATA      Hitachi HTS54502 PB2O PQ: 0 ANSI: =
5=0A[    1.613371] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: =
(250 GB/232 GiB)=0A[    1.613564] sd 0:0:0:0: [sda] Write Protect is =
off=0A[    1.613571] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00=0A[    =
1.613645] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA=0A[    1.618820] usb 1-1: new high speed USB =
device number 2 using ehci_hcd=0A[    1.646308]  sda: sda1 sda2 sda3=0A[   =
 1.647037] sd 0:0:0:0: [sda] Attached SCSI disk=0A[    1.733439] usb 1-1: =
New USB device found, idVendor=3D8087, idProduct=3D0020=0A[    1.733446] =
usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0=0A[=
    1.733774] hub 1-1:1.0: USB hub found=0A[    1.734007] hub 1-1:1.0: 6 =
ports detected=0A[    1.836710] usb 2-1: new high speed USB device number =
2 using ehci_hcd=0A[    1.917691] ata2: SATA link up 1.5 Gbps (SStatus 113 =
SControl 300)=0A[    1.918092] ata2.00: ATAPI: Optiarc DVD RW AD-7585H, =
KX04, max UDMA/100=0A[    1.920844] ata2.00: configured for UDMA/100=0A[   =
 1.924098] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7585H  KX04 =
PQ: 0 ANSI: 5=0A[    1.951108] usb 2-1: New USB device found, idVendor=3D80=
87, idProduct=3D0020=0A[    1.951116] usb 2-1: New USB device strings: =
Mfr=3D0, Product=3D0, SerialNumber=3D0=0A[    1.951396] hub 2-1:1.0: USB =
hub found=0A[    1.951593] hub 2-1:1.0: 8 ports detected=0A[    2.015911] =
usb 1-1.1: new high speed USB device number 3 using ehci_hcd=0A[    =
2.026624] Refined TSC clocksource calibration: 2127.999 MHz.=0A[    =
2.026633] Switching to clocksource tsc=0A[    2.133130] usb 1-1.1: New USB =
device found, idVendor=3D04f2, idProduct=3Db1d8=0A[    2.133137] usb =
1-1.1: New USB device strings: Mfr=3D2, Product=3D1, SerialNumber=3D0=0A[  =
  2.133143] usb 1-1.1: Product: 1.3M WebCam=0A[    2.133147] usb 1-1.1: =
Manufacturer: Sonix Technology Co., Ltd.=0A[    2.210776] usb 1-1.3: new =
high speed USB device number 4 using ehci_hcd=0A[    2.230675] Synaptics =
Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa44000/0xa0000=
=0A[    2.281343] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8=
042/serio2/input/input1=0A[    2.286227] PM: Hibernation image not present =
or could not be loaded.=0A[    2.286295] registered taskstats version =
1=0A[    2.286836]   Magic number: 7:505:187=0A[    2.287014] rtc_cmos =
00:07: setting system clock to 2011-08-29 16:11:21 UTC (1314634281)=0A[    =
2.291271] Freeing unused kernel memory: 936k freed=0A[    2.291536] Write =
protecting the kernel read-only data: 10240k=0A[    2.297540] usb 1-1.3: =
New USB device found, idVendor=3D12d1, idProduct=3D140c=0A[    2.297547] =
usb 1-1.3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D0=
=0A[    2.297553] usb 1-1.3: Product: HUAWEI Mobile=0A[    2.297557] usb =
1-1.3: Manufacturer: HUAWEI Technology=0A[    2.298524] Freeing unused =
kernel memory: 872k freed=0A[    2.310556] Freeing unused kernel memory: =
1708k freed=0A[    2.363000] thermal LNXTHERM:00: registered as thermal_zon=
e0=0A[    2.363006] ACPI: Thermal Zone [THRM] (39 C)=0A[    2.367748] =
ACPI: acpi_idle yielding to intel_idle=0A[    2.373635] usb 1-1.4: new =
high speed USB device number 5 using ehci_hcd=0A[    2.380961] udev[90]: =
starting version 166=0A[    2.400806] input: Lid Switch as /devices/LNXSYST=
M:00/device:00/PNP0C0D:00/input/input2=0A[    2.400957] ACPI: Lid Switch =
[LID]=0A[    2.401023] input: Power Button as /devices/LNXSYSTM:00/device:0=
0/PNP0C0C:00/input/input3=0A[    2.401067] ACPI: Power Button [PWRB]=0A[   =
 2.401122] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00=
/input/input4=0A[    2.401162] ACPI: Sleep Button [SLPB]=0A[    2.401248] =
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5=0A[   =
 2.401291] ACPI: Power Button [PWRF]=0A[    2.431733] [drm] Initialized =
drm 1.1.0 20060810=0A[    2.459323] usb 1-1.4: New USB device found, =
idVendor=3D1c7a, idProduct=3D0801=0A[    2.459327] usb 1-1.4: New USB =
device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3=0A[    2.459331] =
usb 1-1.4: Product: FingerPrinter Reader=0A[    2.459333] usb 1-1.4: =
Manufacturer: Generic=0A[    2.459335] usb 1-1.4: SerialNumber: 00000000000=
006=0A[    2.459653] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16=0A[    2.459665] i915 0000:00:02.0: setting latency timer to =
64=0A[    2.625680] i915 0000:00:02.0: irq 41 for MSI/MSI-X=0A[    =
2.625691] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).=0A[  =
  2.625695] [drm] Driver supports precise vblank timestamp query.=0A[    =
2.625766] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=3Dio+=
mem,decodes=3Dio+mem:owns=3Dio+mem=0A[    2.904268] checking generic =
(d0000000 7ff0000) vs hw (d0000000 10000000)=0A[    2.904272] fb: =
conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic =
driver=0A[    2.904291] Console: switching to colour dummy device =
80x25=0A[    2.904911] fbcon: inteldrmfb (fb0) is primary device=0A[    =
3.062972] Console: switching to colour frame buffer device 170x48=0A[    =
3.065834] fb0: inteldrmfb frame buffer device=0A[    3.065836] drm: =
registered panic notifier=0A[    3.076332] [ACPI Debug]  String [0x1A] =
"TEST initrd table override"=0A[    3.076471] [ACPI Debug]  String [0x1A] =
"TEST initrd table override"=0A[    3.076642] acpi device:04: registered =
as cooling_device4=0A[    3.076979] input: Video Bus as /devices/LNXSYSTM:0=
0/device:00/PNP0A08:00/LNXVIDEO:00/input/input6=0A[    3.077028] ACPI: =
Video Device [GFX0] (multi-head: yes  rom: no  post: no)=0A[    3.077070] =
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0=0A[    =
3.165172] PM: Marking nosave pages: 000000000009c000 - 0000000000100000=0A[=
    3.165183] PM: Marking nosave pages: 000000006f27c000 - 000000006f282000=
=0A[    3.165188] PM: Marking nosave pages: 000000006f3ee000 - 000000006f40=
f000=0A[    3.165193] PM: Marking nosave pages: 000000006f46f000 - =
000000006f70f000=0A[    3.165218] PM: Marking nosave pages: 000000006f71700=
0 - 000000006f71f000=0A[    3.165222] PM: Marking nosave pages: 000000006f7=
6f000 - 000000006f79f000=0A[    3.165228] PM: Marking nosave pages: =
000000006f7ce000 - 000000006f7dc000=0A[    3.165232] PM: Marking nosave =
pages: 000000006f7df000 - 000000006f7ff000=0A[    3.165237] PM: Basic =
memory bitmaps created=0A[    3.173517] PM: Basic memory bitmaps freed=0A[ =
   3.173522] video LNXVIDEO:00: Restoring backlight state=0A[    3.173556] =
[ACPI Debug]  String [0x1A] "TEST initrd table override"=0A[    3.237134] =
PM: Starting manual resume from disk=0A[    3.237138] PM: Hibernation =
image partition 8:1 present=0A[    3.237139] PM: Looking for hibernation =
image.=0A[    3.237395] PM: Image not found (code -22)=0A[    3.237401] =
PM: Hibernation image not present or could not be loaded.=0A[    3.388592] =
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_x=
attr=0A[    3.538397] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr=0A[ =
   7.485249] udev[396]: starting version 166=0A[    7.945311] ACPI: =
Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_=
PROCFS_POWER cleared=0A[    7.945325] ACPI: Battery Slot [BAT1] (battery =
present)=0A[    7.995510] ACPI: Deprecated procfs I/F for AC is loaded, =
please retry with CONFIG_ACPI_PROCFS_POWER cleared=0A[    7.995770] ACPI: =
AC Adapter [ACAD] (on-line)=0A[    8.468740] i801_smbus 0000:00:1f.3: PCI =
INT C -> GSI 18 (level, low) -> IRQ 18=0A[    8.673497] input: PC Speaker =
as /devices/platform/pcspkr/input/input7=0A[    8.782379] iTCO_vendor_suppo=
rt: vendor-support=3D0=0A[    8.815035] wmi: Mapper loaded=0A[    =
8.846429] cfg80211: Calling CRDA to update world regulatory domain=0A[    =
8.924291] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06=0A[    8.924384] =
iTCO_wdt: Found a HM55 TCO device (Version=3D2, TCOBASE=3D0x0460)=0A[    =
8.924459] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)=0A[    =
8.982243] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value =
(found 25, expected 29)=0A[    8.982273] intel ips 0000:00:1f.6: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18=0A[    8.982554] intel ips 0000:00:1f.6: =
IPS driver initialized, MCP temp limit 90=0A[    8.997225] sd 0:0:0:0: =
Attached scsi generic sg0 type 0=0A[    8.997310] scsi 1:0:0:0: Attached =
scsi generic sg1 type 5=0A[    9.140625] usbcore: registered new interface =
driver usbserial=0A[    9.140640] USB Serial support registered for =
generic=0A[    9.140728] usbcore: registered new interface driver =
usbserial_generic=0A[    9.140731] usbserial: USB Serial Driver core=0A[   =
 9.235437] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray=0A[    9.235445] cdrom: Uniform CD-ROM driver Revision: 3.20=0A[ =
   9.235679] sr 1:0:0:0: Attached scsi CD-ROM sr0=0A[    9.273248] =
tg3.c:v3.119 (May 18, 2011)=0A[    9.273303] tg3 0000:02:00.0: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16=0A[    9.273319] tg3 0000:02:00.0: =
setting latency timer to 64=0A[    9.335627] tg3 mdio bus: probed=0A[    =
9.384181] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM957760) rev 57780001] =
(PCI Express) MAC address c8:0a:a9:55:1b:22=0A[    9.384185] tg3 0000:02:00=
.0: eth0: attached PHY driver [Broadcom BCM57780] (mii_bus:phy_addr=3D200:0=
1)=0A[    9.384189] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] =
MIirq[0] ASF[0] TSOcap[1]=0A[    9.384191] tg3 0000:02:00.0: eth0: =
dma_rwctrl[76180000] dma_mask[64-bit]=0A[    9.601697] HDA Intel 0000:00:1b=
.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22=0A[    9.601833] HDA Intel =
0000:00:1b.0: irq 42 for MSI/MSI-X=0A[    9.601900] HDA Intel 0000:00:1b.0:=
 setting latency timer to 64=0A[    9.865339] Linux video capture =
interface: v2.00=0A[   10.091904] acer_wmi: Acer Laptop ACPI-WMI Extras=0A[=
   10.092579] acer_wmi: Function bitmap for Communication Button: =
0x841=0A[   10.092596] acer_wmi: Brightness must be controlled by generic =
video driver=0A[   10.092856] input: Acer WMI hotkeys as /devices/virtual/i=
nput/input8=0A[   10.115244] cfg80211: World regulatory domain updated:=0A[=
   10.115247] cfg80211:     (start_freq - end_freq @ bandwidth), (max_anten=
na_gain, max_eirp)=0A[   10.115250] cfg80211:     (2402000 KHz - 2472000 =
KHz @ 40000 KHz), (300 mBi, 2000 mBm)=0A[   10.115252] cfg80211:     =
(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)=0A[   =
10.115255] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 =
mBi, 2000 mBm)=0A[   10.115257] cfg80211:     (5170000 KHz - 5250000 KHz @ =
40000 KHz), (300 mBi, 2000 mBm)=0A[   10.115259] cfg80211:     (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)=0A[   10.150648] =
uvcvideo: Found UVC 1.00 device 1.3M WebCam (04f2:b1d8)=0A[   10.160463] =
input: 1.3M WebCam as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1=
:1.0/input/input9=0A[   10.160672] usbcore: registered new interface =
driver uvcvideo=0A[   10.160677] USB Video Class driver (v1.1.0)=0A[   =
10.735532] USB Serial support registered for GSM modem (1-port)=0A[   =
10.735656] option 1-1.3:1.0: GSM modem (1-port) converter detected=0A[   =
10.735899] usb 1-1.3: GSM modem (1-port) converter now attached to =
ttyUSB0=0A[   10.735918] option 1-1.3:1.1: GSM modem (1-port) converter =
detected=0A[   10.736083] usb 1-1.3: GSM modem (1-port) converter now =
attached to ttyUSB1=0A[   10.736107] option 1-1.3:1.2: GSM modem (1-port) =
converter detected=0A[   10.736211] usb 1-1.3: GSM modem (1-port) =
converter now attached to ttyUSB2=0A[   10.736233] option 1-1.3:1.3: GSM =
modem (1-port) converter detected=0A[   10.736326] usb 1-1.3: GSM modem =
(1-port) converter now attached to ttyUSB3=0A[   10.736364] usbcore: =
registered new interface driver option=0A[   10.736368] option: v0.7.2:USB =
Driver for GSM modems=0A[   10.817709] input: HDA Digital PCBeep as =
/devices/pci0000:00/0000:00:1b.0/input/input10=0A[   10.915929] iwlagn: =
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d=0A[   =
10.915936] iwlagn: Copyright(c) 2003-2011 Intel Corporation=0A[   =
10.916069] iwlagn 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ =
17=0A[   10.916125] iwlagn 0000:09:00.0: setting latency timer to 64=0A[   =
10.916217] iwlagn 0000:09:00.0: Detected Intel(R) Centrino(R) Advanced-N =
6200 AGN, REV=3D0x74=0A[   10.932864] iwlagn 0000:09:00.0: device EEPROM =
VER=3D0x434, CALIB=3D0x6=0A[   10.932870] iwlagn 0000:09:00.0: Device SKU: =
0Xb=0A[   10.932900] iwlagn 0000:09:00.0: Tunable channels: 13 802.11bg, =
24 802.11a channels=0A[   10.933243] iwlagn 0000:09:00.0: irq 43 for =
MSI/MSI-X=0A[   11.003702] iwlagn 0000:09:00.0: loaded firmware version =
9.193.4.1 build 19710=0A[   11.004064] Registered led device: phy0-led=0A[ =
  11.063390] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'=
=0A[   11.455858] Adding 2103292k swap on /dev/sda1.  Priority:-1 =
extents:1 across:2103292k =0A[   11.990600] device-mapper: uevent: version =
1.0.3=0A[   11.990749] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) =
initialised: dm-devel@redhat.com=0A[   12.373813] EXT4-fs (sda3): mounted =
filesystem with ordered data mode. Opts: acl,user_xattr=0A[   14.402537] =
microcode: CPU0 sig=3D0x20652, pf=3D0x10, revision=3D0x9=0A[   14.406219] =
microcode: CPU1 sig=3D0x20652, pf=3D0x10, revision=3D0x9=0A[   14.407566] =
microcode: CPU2 sig=3D0x20652, pf=3D0x10, revision=3D0x9=0A[   14.408754] =
microcode: CPU3 sig=3D0x20652, pf=3D0x10, revision=3D0x9=0A[   14.409977] =
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, =
Peter Oruba=0A[   14.799378] microcode: CPU0 updated to revision 0xc, date =
=3D 2010-06-10=0A[   14.799899] microcode: CPU1 updated to revision 0xc, =
date =3D 2010-06-10=0A[   14.800382] microcode: CPU2 updated to revision =
0xc, date =3D 2010-06-10=0A[   14.800925] microcode: CPU3 updated to =
revision 0xc, date =3D 2010-06-10=0A[   15.606341] ip6_tables: (C) =
2000-2006 Netfilter Core Team=0A[   15.719447] nf_conntrack version 0.5.0 =
(16384 buckets, 65536 max)=0A[   15.771477] ip_tables: (C) 2000-2006 =
Netfilter Core Team=0A[   17.007777] BIOS EDD facility v0.16 2004-Jun-25, =
1 devices found=0A[   19.412401] tg3 0000:02:00.0: irq 44 for MSI/MSI-X=0A[=
   20.171382] ADDRCONF(NETDEV_UP): eth0: link is not ready=0A[   20.359932]=
 tg3 0000:02:00.0: eth0: Link is down=0A[   20.517332] ADDRCONF(NETDEV_UP):=
 wlan0: link is not ready=0A[   20.729577] NET: Registered protocol family =
17=0A[   23.370597] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full =
duplex=0A[   23.370604] tg3 0000:02:00.0: eth0: Flow control is on for TX =
and on for RX=0A[   23.371015] ADDRCONF(NETDEV_CHANGE): eth0: link becomes =
ready=0A[   23.942707] [ACPI Debug]  String [0x1A] "TEST initrd table =
override"=0A[   23.942935] [ACPI Debug]  String [0x1A] "TEST initrd table =
override"=0A[   30.536090] fuse init (API version 7.16)=0A[   32.431417] =
SFW2-INext-ACC-TCP IN=3Deth0 OUT=3D MAC=3Dc8:0a:a9:55:1b:22:00:1d:72:9c:cd:=
ad:08:00 SRC=3D147.2.211.175 DST=3D147.2.211.58 LEN=3D60 TOS=3D0x00 =
PREC=3D0x00 TTL=3D64 ID=3D12285 DF PROTO=3DTCP SPT=3D57519 DPT=3D22 =
WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0 OPT (020405B40402080A015CCBFD00000000=
01030306) =0A[   34.250958] eth0: no IPv6 routers present=0A[   42.699766] =
EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=3D0=0A[   =
43.472545] [ACPI Debug]  String [0x1A] "TEST initrd table override"=0A[   =
44.375141] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr,commit=3D0=0A[ =
  55.637057] SFW2-INext-ACC-TCP IN=3Deth0 OUT=3D MAC=3Dc8:0a:a9:55:1b:22:00=
:1d:72:9c:cd:ad:08:00 SRC=3D147.2.211.175 DST=3D147.2.211.58 LEN=3D60 =
TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D34692 DF PROTO=3DTCP SPT=3D57527 =
DPT=3D22 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0 OPT (020405B40402080A015CE2A=
80000000001030306) =0A
--=__Part4A655279.5__=--
