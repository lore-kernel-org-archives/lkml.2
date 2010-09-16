Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0IPVbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:31:47 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:48030 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755975Ab0IPVbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:31:43 -0400
Date: Thu, 16 Sep 2010 17:31:38 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Subject: Regression, bisected: WARNING spam with ipsec since 2.6.35
Message-ID: <20100916213138.GA6605@elliptictech.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attempting to use IPSec since 2.6.35 has resulted in WARNINGs (one of
them is included further down) being spammed to the kernel log.  The
packets seem to be transmitted fine, but the constant printk's degrade
performance to the point of uselessness (there are about a half dozen
call traces for every packet transmitted).  I've attached the full log
after booting the kernel, running the setkey script, and sending a
single ping.

This is the setkey script I used to produce the issue:

  add 192.168.0.1 192.168.0.2 esp 0x6B8B4567  -f seq-pad
   -E rijndael-cbc 0x643C98696633487374B0DC5119495CFF
   -A null;
  
  add 192.168.0.2 192.168.0.1 esp 0x327B23C6  -f seq-pad
   -E rijndael-cbc 0x3D1B58BA507ED7AB2EB141F241B71EFB
   -A null;
  
  spdadd 192.168.0.2 192.168.0.1 any -P out ipsec
   esp/transport//require;
  spdadd 192.168.0.1 192.168.0.2 any -P in ipsec
   esp/transport//require;

and here's the first warning:

  ------------[ cut here ]------------
  WARNING: at include/linux/skbuff.h:472 xfrm_output_resume+0x4b8/0x50d()
  Hardware name:         
  Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
  Pid: 2391, comm: ping Not tainted 2.6.35 #3
  Call Trace:
   [<c102e21f>] warn_slowpath_common+0x65/0x7a
   [<c127ee2e>] ? xfrm_output_resume+0x4b8/0x50d
   [<c102e243>] warn_slowpath_null+0xf/0x13
   [<c127ee2e>] xfrm_output_resume+0x4b8/0x50d
   [<c127ee90>] xfrm_output2+0xd/0xf
   [<c127ef57>] xfrm_output+0xc5/0xce
   [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
   [<c1277fe0>] xfrm4_output+0x88/0x8f
   [<c124ce58>] ip_local_out+0x50/0x53
   [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
   [<c126578f>] raw_sendmsg+0x614/0x691
   [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
   [<c126d46c>] inet_sendmsg+0xbd/0xc6
   [<c1223f62>] sock_sendmsg+0xa5/0xbb
   [<c108deb6>] ? might_fault+0x6e/0x88
   [<c108deb6>] ? might_fault+0x6e/0x88
   [<c122bd43>] ? verify_iovec+0x3e/0x6b
   [<c1224368>] sys_sendmsg+0x149/0x196
   [<c1023c2b>] ? get_parent_ip+0xb/0x31
   [<c107e377>] ? unlock_page+0x3b/0x3e
   [<c108f99a>] ? handle_mm_fault+0x219/0x49b
   [<c1053d13>] ? lock_release_non_nested+0x86/0x221
   [<c108deb6>] ? might_fault+0x6e/0x88
   [<c108deb6>] ? might_fault+0x6e/0x88
   [<c12255ba>] sys_socketcall+0x146/0x18b
   [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
   [<c1002690>] sysenter_do_call+0x12/0x36
  ---[ end trace c8ae605bd7809dcc ]---

Bisection implicates the following commit:

  8764ab2ca7ab5055e1ca80f9cfa4970c34acb804 is the first bad commit
  commit 8764ab2ca7ab5055e1ca80f9cfa4970c34acb804
  Author: Steffen Klassert <steffen.klassert@secunet.com>
  Date:   Fri Jun 4 01:57:38 2010 +0000
  
      net: check for refcount if pop a stacked dst_entry
      
      xfrm triggers a warning if dst_pop() drops a refcount
      on a noref dst. This patch changes dst_pop() to
      skb_dst_pop(). skb_dst_pop() drops the refcnt only
      on a refcounted dst. Also we don't clone the child
      dst_entry, so it is not refcounted and we can use
      skb_dst_set_noref() in xfrm_output_one().
      
      Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
      Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
      Signed-off-by: David S. Miller <davem@davemloft.net>
  
  :040000 040000 3f0e1574919d0e581b3e9537a4d59ce397a926f1 f272ab5b895c46b3166d321a2da759c2a6e08ae0 M	include
  :040000 040000 a4fbff22e9ae9f57f4f8c5416f5a7be186635cab eb04849588cbe4b2b99030c2aa59e3433187c6df M	net
  
  git bisect start
  # bad: [9c03f1622af051004416dd3e24d8a0fa31e34178] Merge ssh://master.kernel.org/home/hpa/tree/sec
  git bisect bad 9c03f1622af051004416dd3e24d8a0fa31e34178
  # bad: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
  git bisect bad 9fe6206f400646a2322096b56c59891d530e8d51
  # good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
  git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
  # good: [e0bc5d4a54938eedcde14005210e6c08aa9727e4] Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging
  git bisect good e0bc5d4a54938eedcde14005210e6c08aa9727e4
  # good: [d30fda355188272430d3865db2ff9e24b4135ae3] posix-cpu-timers: avoid "task->signal != NULL" checks
  git bisect good d30fda355188272430d3865db2ff9e24b4135ae3
  # good: [9a9620db07b27700a4de9e86985735fffb78e2f8] Merge branch 'linux_next' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core
  git bisect good 9a9620db07b27700a4de9e86985735fffb78e2f8
  # bad: [985b823b919273fe1327d56d2196b4f92e5d0fae] drm/i915: fix hibernation since i915 self-reclaim fixes
  git bisect bad 985b823b919273fe1327d56d2196b4f92e5d0fae
  # bad: [b5edfefc65526b34960bbff3477ded477b0328f6] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
  git bisect bad b5edfefc65526b34960bbff3477ded477b0328f6
  # bad: [fcdcddbcbbd39a3363bd48414bfe44553b6d698a] microblaze: Fix sg_dma_len() regression
  git bisect bad fcdcddbcbbd39a3363bd48414bfe44553b6d698a
  # bad: [ed7dc1dfbcef301407a1e3138a49dc94e5a19d0a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
  git bisect bad ed7dc1dfbcef301407a1e3138a49dc94e5a19d0a
  # good: [90ec7819737d42a0ad1c2df1ff56016facae3c6e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
  git bisect good 90ec7819737d42a0ad1c2df1ff56016facae3c6e
  # good: [a1868dc2878e61778b9d6d8c61d5368e51d68a29] ixgbe: return IXGBE_ERR_RAR_INDEX when out of range
  git bisect good a1868dc2878e61778b9d6d8c61d5368e51d68a29
  # good: [7926e0bfbbc5ff81ddad0fda831eef7060e40997] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2
  git bisect good 7926e0bfbbc5ff81ddad0fda831eef7060e40997
  # bad: [ca739481662137b8f717bc21f16719cda3c33d6b] ixgbe: only check pfc bits in hang logic if pfc is enabled
  git bisect bad ca739481662137b8f717bc21f16719cda3c33d6b
  # good: [51a0d38de26226f2779912d92f155b93d539da9a] mac80211: fix dialog token allocator
  git bisect good 51a0d38de26226f2779912d92f155b93d539da9a
  # bad: [8764ab2ca7ab5055e1ca80f9cfa4970c34acb804] net: check for refcount if pop a stacked dst_entry
  git bisect bad 8764ab2ca7ab5055e1ca80f9cfa4970c34acb804
  # good: [4f4aeb7fd0f7e6ca008bb2147ba36cee13876595] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6
  git bisect good 4f4aeb7fd0f7e6ca008bb2147ba36cee13876595

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipsec-trace.log"

Linux version 2.6.35 (root@ulna) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #3 SMP PREEMPT Thu Sep 16 13:56:31 EDT 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ff40000 (usable)
 BIOS-e820: 000000001ff40000 - 000000001ff50000 (ACPI data)
 BIOS-e820: 000000001ff50000 - 0000000020000000 (ACPI NVS)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI 2.3 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x1ff40 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-DFFFF uncachable
  E0000-FFFFF write-back
MTRR variable ranges enabled:
  0 base 000000000 mask FE0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-000000001ff40000
 0000000000 - 0000400000 page 4k
 0000400000 - 001fc00000 page 2M
 001fc00000 - 001ff40000 page 4k
kernel direct mapping tables up to 1ff40000 @ 7000-c000
RAMDISK: 1eb50000 - 1ff30000
ACPI: RSDP 000f70e0 00014 (v00 ACPIAM)
ACPI: RSDT 1ff40000 00030 (v01 INTEL  D845EPT2 20020920 MSFT 00000097)
ACPI: FACP 1ff40200 00081 (v02 INTEL  D845EPT2 20020920 MSFT 00000097)
ACPI: DSDT 1ff40400 0420A (v01 INTEL  D845EPT2 0000010A MSFT 0100000D)
ACPI: FACS 1ff50000 00040
ACPI: APIC 1ff40300 00068 (v01 INTEL  D845EPT2 20020920 MSFT 00000097)
ACPI: ASF! 1ff44610 00084 (v16 AMIASF I845GASF 00000001 MSFT 0100000D)
ACPI: Local APIC address 0xfee00000
511MB LOWMEM available.
  mapped low ram: 0 - 1ff40000
  low ram: 0 - 1ff40000
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  Normal   0x00001000 -> 0x0001ff40
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0001ff40
On node 0 totalpages: 130782
free_area_init_node: node 0, pgdat c1453c00, node_mem_map c1a081a0
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3966 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125793 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 1 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 20000000 (gap: 20000000:e0000000)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 16 pages/cpu @c2000000 s41728 r0 d23808 u4194304
early_res array is doubled to 64 at [3000 - 37ff]
pcpu-alloc: s41728 r0 d23808 u4194304 alloc=1*4194304
pcpu-alloc: [0] 0 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129759
Kernel command line: ro root=/dev/mapper/vg_ulna-lv_root rd_LVM_LV=vg_ulna/lv_root rd_LVM_LV=vg_ulna/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us rhgb quiet console=ttyS0,115200n8 console=tty0
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Subtract (33 early reservations)
  #1 [0000001000 - 0000002000]   EX TRAMPOLINE
  #2 [0001000000 - 0001a00370]   TEXT DATA BSS
  #3 [001eb50000 - 001ff30000]         RAMDISK
  #4 [000009fc00 - 0000100000]   BIOS reserved
  #5 [0001a01000 - 0001a08110]             BRK
  #6 [0000002000 - 0000003000]      TRAMPOLINE
  #7 [0000007000 - 0000008000]         PGTABLE
  #8 [0001a08180 - 0001e08180]         BOOTMEM
  #9 [0001a00380 - 0001a00384]         BOOTMEM
  #10 [0001a00400 - 0001a00640]         BOOTMEM
  #11 [0001a00680 - 0001a006b0]         BOOTMEM
  #12 [0001e08180 - 0001e0c980]         BOOTMEM
  #13 [0001a00700 - 0001a00727]         BOOTMEM
  #14 [0001a00780 - 0001a00844]         BOOTMEM
  #15 [0001a00880 - 0001a008c0]         BOOTMEM
  #16 [0001a00900 - 0001a00940]         BOOTMEM
  #17 [0001a00980 - 0001a009c0]         BOOTMEM
  #18 [0001a00a00 - 0001a00a40]         BOOTMEM
  #19 [0001a00a80 - 0001a00ac0]         BOOTMEM
  #20 [0001a00b00 - 0001a00b40]         BOOTMEM
  #21 [0001a00b80 - 0001a00c6b]         BOOTMEM
  #22 [0001a00c80 - 0001a00d6b]         BOOTMEM
  #23 [0002000000 - 0002010000]         BOOTMEM
  #24 [0001a00d80 - 0001a00d84]         BOOTMEM
  #25 [0001a00e00 - 0001a00e04]         BOOTMEM
  #26 [0001a00e80 - 0001a00e84]         BOOTMEM
  #27 [0001a00f00 - 0001a00f04]         BOOTMEM
  #28 [0001e0e980 - 0001e0ea30]         BOOTMEM
  #29 [0001e0ea80 - 0001e0eb28]         BOOTMEM
  #30 [0001e0c980 - 0001e0e980]         BOOTMEM
  #31 [0001e0eb80 - 0001e4eb80]         BOOTMEM
  #32 [0001e4eb80 - 0001e6eb80]         BOOTMEM
Memory: 487920k/523520k available (2655k kernel code, 35208k reserved, 1799k data, 400k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
    vmalloc : 0xe0740000 - 0xfff15000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdff40000   ( 511 MB)
      .init : 0xc145a000 - 0xc14be000   ( 400 kB)
      .data : 0xc1297c30 - 0xc1459a98   (1799 kB)
      .text : 0xc1000000 - 0xc1297c30   (2655 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:512
CPU 0 irqstacks, hard=c2000000 soft=c2001000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3567 kB
 per task-struct memory footprint: 1152 bytes
Fast TSC calibration using PIT
Detected 2000.090 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.18 BogoMIPS (lpj=2000090)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU0: Hyper-Threading is disabled
mce: CPU supports 4 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
... version:                0
... bit width:              40
... generic registers:      18
... value mask:             000000ffffffffff
... max period:             0000007fffffffff
... fixed-purpose events:   0
... event mask:             000000000003ffff
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
ACPI: Core revision 20100428
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Pentium(R) 4 CPU 2.00GHz stepping 04
Brought up 1 CPUs
Total of 1 processors activated (4000.18 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 2 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x20000000-0xffffffff] (ignored)
pci 0000:00:00.0: reg 10: [mem 0xf4000000-0xf7ffffff pref]
pci 0000:00:1d.0: reg 20: [io  0xe800-0xe81f]
pci 0000:00:1d.1: reg 20: [io  0xe880-0xe89f]
pci 0000:00:1d.2: reg 20: [io  0xec00-0xec1f]
pci 0000:00:1d.7: reg 10: [mem 0xfebffc00-0xfebfffff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
pci 0000:00:1f.1: reg 24: [mem 0x00000000-0x000003ff]
pci 0000:00:1f.3: reg 20: [io  0xe000-0xe01f]
pci 0000:00:1f.5: reg 10: [io  0xe400-0xe4ff]
pci 0000:00:1f.5: reg 14: [io  0xe080-0xe0bf]
pci 0000:00:1f.5: reg 18: [mem 0xfebff800-0xfebff9ff]
pci 0000:00:1f.5: reg 1c: [mem 0xfebff400-0xfebff4ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:01:00.0: reg 10: [mem 0xe8000000-0xefffffff pref]
pci 0000:01:00.0: reg 14: [io  0xc800-0xc8ff]
pci 0000:01:00.0: reg 18: [mem 0xfa9f0000-0xfa9fffff]
pci 0000:01:00.0: reg 30: [mem 0xfa9c0000-0xfa9dffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:01.0:   bridge window [mem 0xfa900000-0xfa9fffff]
pci 0000:00:01.0:   bridge window [mem 0xe0600000-0xf06fffff pref]
pci 0000:02:00.0: reg 10: [mem 0xfeafc000-0xfeafffff]
pci 0000:02:00.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:02:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:01.0: reg 10: [mem 0xf1000000-0xf1ffffff pref]
pci 0000:02:01.0: reg 14: [mem 0xfd000000-0xfdffffff]
pci 0000:02:01.0: reg 18: [mem 0xfc000000-0xfcffffff]
pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1e.0:   bridge window [mem 0xfaa00000-0xfeafffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0700000-0xf27fffff pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 000000001ff40000 - 000000001fffffff 
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:09: [io  0x04d0-0x04d1] has been reserved
system 00:0d: [io  0x0400-0x047f] has been reserved
system 00:0d: [io  0x0680-0x06ff] has been reserved
system 00:0d: [io  0x0480-0x04bf] has been reserved
system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0e: [mem 0x000c0000-0x000dffff] could not be reserved
system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0e: [mem 0x00100000-0x1fffffff] could not be reserved
pci 0000:00:1f.1: BAR 5: assigned [mem 0x20000000-0x200003ff]
pci 0000:00:1f.1: BAR 5: set to [mem 0x20000000-0x200003ff] (PCI address [0x20000000-0x200003ff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:01.0:   bridge window [mem 0xfa900000-0xfa9fffff]
pci 0000:00:01.0:   bridge window [mem 0xe0600000-0xf06fffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 02-02]
pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1e.0:   bridge window [mem 0xfaa00000-0xfeafffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0700000-0xf27fffff pref]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:01: resource 1 [mem 0xfa900000-0xfa9fffff]
pci_bus 0000:01: resource 2 [mem 0xe0600000-0xf06fffff pref]
pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:02: resource 1 [mem 0xfaa00000-0xfeafffff]
pci_bus 0000:02: resource 2 [mem 0xf0700000-0xf27fffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
UDP hash table entries: 256 (order: 2, 20480 bytes)
UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 20352k freed
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 992
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
ACPI: acpi_idle registered with cpuidle
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 845G Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf4000000
Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using getrawmonotonic().
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] initializing kernel modesetting (RV100 0x1002:0x5159).
[drm] register mmio base: 0xFA9F0000
[drm] register mmio size: 65536
agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
radeon 0000:01:00.0: putting AGP V2 device into 4x mode
radeon 0000:01:00.0: GTT: 64M 0xF4000000 - 0xF7FFFFFF
radeon 0000:01:00.0: VRAM: 64M 0xE8000000 - 0xEBFFFFFF (64M used)
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=64M, BAR=128M
[drm] RAM width 64bits DDR
[TTM] Zone  kernel: Available graphics memory: 254142 kiB.
[TTM] Initializing pool allocator.
[drm] radeon: 64M of VRAM memory ready
[drm] radeon: 64M of GTT memory ready.
[drm] Loading R100 Microcode
[drm] radeon: ring at 0x00000000F4000000
[drm] ring test succeeded in 0 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Default TV standard: NTSC
[drm] 27.000000000 MHz TV ref clk
[drm] Default TV standard: NTSC
[drm] 27.000000000 MHz TV ref clk
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   S-video
[drm]   Encoders:
[drm]     TV1: INTERNAL_DAC2
[drm] fb mappable at 0xE8040000
[drm] vram apper at 0xE8000000
[drm] size 5242880
[drm] fb depth is 24
[drm]    pitch is 5120
Console: switching to colour frame buffer device 160x64
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] Initialized radeon 2.5.0 20080528 for 0000:01:00.0 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI Shortcut mode
kmemleak: Kernel memory leak detector initialized
Freeing unused kernel memory: 400k freed
kmemleak: Automatic memory scanning thread started
Write protecting the kernel text: 2656k
Write protecting the kernel read-only data: 1444k
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
dracut: dracut-005-3.fc13
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
udev: starting version 153
dracut: Starting plymouth daemon
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000e800
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebffc00
SCSI subsystem initialized
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e880
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ec00
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.00, max UDMA/66
ata2.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
ata2.00: 160086528 sectors, multi 16: LBA 
ata1.00: configured for UDMA/66
ata2.00: configured for UDMA/100
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.00 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 160086528 512-byte logical blocks: (81.9 GB/76.3 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
 sda:
sr 0:0:0:0: Attached scsi CD-ROM sr0
 sda1 sda2
sd 1:0:0:0: [sda] Attached SCSI disk
dracut: Scanning devices sda2  for LVM logical volumes vg_ulna/lv_root vg_ulna/lv_swap 
dracut: inactive '/dev/vg_ulna/lv_root' [74.84 GiB] inherit
dracut: inactive '/dev/vg_ulna/lv_swap' [1.00 GiB] inherit
dracut: The link /dev/vg_ulna/lv_root should had been created by udev but it was not found. Falling back to direct link creation.
dracut: The link /dev/vg_ulna/lv_swap should had been created by udev but it was not found. Falling back to direct link creation.
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_ulna-lv_root
dracut: Loading SELinux policy
dracut: /sbin/load_policy: Can't load policy: No such device
dracut: Switching root
readahead-collector: starting
readahead-collector: sorting
udev: starting version 153
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
skge 0000:02:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
skge: 1.13 addr 0xfeafc000 irq 21 chip Yukon-Lite rev 9
skge 0000:02:00.0: eth0: addr 00:24:01:04:f2:09
sr 0:0:0:0: Attached scsi generic sg0 type 5
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
sd 1:0:0:0: Attached scsi generic sg1 type 0
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
loop: module loaded
EXT4-fs (dm-0): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
Adding 1048572k swap on /dev/mapper/vg_ulna-lv_swap.  Priority:-1 extents:1 across:1048572k 
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (7948 buckets, 31792 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
skge 0000:02:00.0: eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
readahead-collector: finished
skge 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control none
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
eth0: no IPv6 routers present
kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
NET: Registered protocol family 15
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for authenc(digest_null,cbc(aes)) (authenc(digest_null-generic,cbc(aes-generic)))
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:472 xfrm_output_resume+0x4b8/0x50d()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Not tainted 2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c127ee2e>] ? xfrm_output_resume+0x4b8/0x50d
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c127ee2e>] xfrm_output_resume+0x4b8/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dcc ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 xfrm_output_resume+0x93/0x50d()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c127ea09>] ? xfrm_output_resume+0x93/0x50d
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c127ea09>] xfrm_output_resume+0x93/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dcd ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 __ip_local_out+0x85/0xc4()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c124cdc9>] ? __ip_local_out+0x85/0xc4
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c124cdc9>] __ip_local_out+0x85/0xc4
 [<c127ea17>] xfrm_output_resume+0xa1/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dce ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 xfrm_output_resume+0xe1/0x50d()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c127ea57>] ? xfrm_output_resume+0xe1/0x50d
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c127ea57>] xfrm_output_resume+0xe1/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dcf ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 xfrm_output_resume+0x122/0x50d()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c127ea98>] ? xfrm_output_resume+0x122/0x50d
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c127ea98>] xfrm_output_resume+0x122/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dd0 ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 ip_output+0x3d/0xee()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c124de83>] ? ip_output+0x3d/0xee
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c124de83>] ip_output+0x3d/0xee
 [<c127eaa3>] xfrm_output_resume+0x12d/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dd1 ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 ip_finish_output+0x40/0x38e()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c124daf8>] ? ip_finish_output+0x40/0x38e
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c124daf8>] ip_finish_output+0x40/0x38e
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c124df2c>] ip_output+0xe6/0xee
 [<c127eaa3>] xfrm_output_resume+0x12d/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dd2 ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 ip_finish_output+0x121/0x38e()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c124dbd9>] ? ip_finish_output+0x121/0x38e
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c124dbd9>] ip_finish_output+0x121/0x38e
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c124df2c>] ip_output+0xe6/0xee
 [<c127eaa3>] xfrm_output_resume+0x12d/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dd3 ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 ip_finish_output+0x181/0x38e()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c124dc39>] ? ip_finish_output+0x181/0x38e
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c124dc39>] ip_finish_output+0x181/0x38e
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c124df2c>] ip_output+0xe6/0xee
 [<c127eaa3>] xfrm_output_resume+0x12d/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dd4 ]---
------------[ cut here ]------------
WARNING: at include/linux/skbuff.h:445 neigh_resolve_output+0x40/0x2d1()
Hardware name:         
Modules linked in: authenc esp4 deflate zlib_deflate ctr aes_generic des_generic cbc sha256_generic sha1_generic md5 crypto_null af_key autofs4 sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 loop parport_pc sg psmouse parport evdev skge rng_core button ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ata_piix libata ehci_hcd uhci_hcd scsi_mod usbcore dm_mod [last unloaded: scsi_wait_scan]
Pid: 2391, comm: ping Tainted: G        W   2.6.35 #3
Call Trace:
 [<c102e21f>] warn_slowpath_common+0x65/0x7a
 [<c1237cba>] ? neigh_resolve_output+0x40/0x2d1
 [<c102e243>] warn_slowpath_null+0xf/0x13
 [<c1237cba>] neigh_resolve_output+0x40/0x2d1
 [<c102e22c>] ? warn_slowpath_common+0x72/0x7a
 [<c124dc39>] ? ip_finish_output+0x181/0x38e
 [<c124de1c>] ip_finish_output+0x364/0x38e
 [<c1020000>] ? ftrace_define_fields_sched_migrate_task+0xa1/0xa5
 [<c124df2c>] ip_output+0xe6/0xee
 [<c127eaa3>] xfrm_output_resume+0x12d/0x50d
 [<c127ee90>] xfrm_output2+0xd/0xf
 [<c127ef57>] xfrm_output+0xc5/0xce
 [<c1277f55>] xfrm4_output_finish+0xa1/0xa4
 [<c1277fe0>] xfrm4_output+0x88/0x8f
 [<c124ce58>] ip_local_out+0x50/0x53
 [<c124d0c4>] ip_push_pending_frames+0x269/0x2b2
 [<c126578f>] raw_sendmsg+0x614/0x691
 [<c1051c01>] ? trace_hardirqs_on_caller+0x1e/0x121
 [<c126d46c>] inet_sendmsg+0xbd/0xc6
 [<c1223f62>] sock_sendmsg+0xa5/0xbb
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c122bd43>] ? verify_iovec+0x3e/0x6b
 [<c1224368>] sys_sendmsg+0x149/0x196
 [<c1023c2b>] ? get_parent_ip+0xb/0x31
 [<c107e377>] ? unlock_page+0x3b/0x3e
 [<c108f99a>] ? handle_mm_fault+0x219/0x49b
 [<c1053d13>] ? lock_release_non_nested+0x86/0x221
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c108deb6>] ? might_fault+0x6e/0x88
 [<c12255ba>] sys_socketcall+0x146/0x18b
 [<c110b4b4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002690>] sysenter_do_call+0x12/0x36
---[ end trace c8ae605bd7809dd5 ]---

--gBBFr7Ir9EOA20Yy--
