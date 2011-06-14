Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1FNVOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:14:50 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:34373 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1FNVOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:14:45 -0400
Date: Tue, 14 Jun 2011 23:14:41 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-users] 3.0.0-rc2: Xen: High amount of kernel "reserved"
 memory, about 33% in 256MB DOMU
Message-ID: <20110614211441.GF7417@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613205003.GD20616@yumi.tdiedrich.de>
 <20110613215900.GB19117@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613215900.GB19117@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 13, 2011 at 10:50:03PM +0200, Tobias Diedrich wrote:
> > Hi,
> > 
> > another issue I'm seeing with 3.0-rc2 and Xen is that there is an
> > unexpectedly high amount of kernel reserved memory.
> 
> > 
> > I suspect that Linux allocates page table entries and corresponding
> > data structures for the whole 6GB areas of the provided 'physical
> > RAM map' even though it has rather big unusable holes in it.
> 
> Can you run it with 'memblock=debug debug loglevel=8 initcall_debug'?
> It should tell you where it tries (and for much space) the pagetables.

Here is a diff between verbose domu with and without mem=256M
(with "s@after [0-9]* usecs@after XX usecs@g" to suppress the
timing differences somewhat)
--- noextraopts	2011-06-14 23:02:24.549323941 +0200
+++ mem256	2011-06-14 23:01:46.140538541 +0200
@@ -1,7 +1,7 @@
 Initializing cgroup subsys cpuset
 Initializing cgroup subsys cpu
 Linux version 3.0.0-rc2 (ranma@nukunuku) (gcc version 4.5.2 (Debian 4.5.2-11) ) #53 SMP Tue Jun 14 15:33:45 CEST 2011
-Command line: root=/dev/xvda1 memblock=debug debug loglevel=8 initcall_debug ro ip=192.168.12.1:127.0.255.255:192.168.12.2:255.255.255.0:yumi.uguu.de:eth0:off 4
+Command line: root=/dev/xvda1 memblock=debug debug loglevel=8 initcall_debug ro mem=256M ip=192.168.12.1:127.0.255.255:192.168.12.2:255.255.255.0:yumi.uguu.de:eth0:off 4
 ACPI in unprivileged domain disabled
 released 0 pages of unused memory
 Set 0 page(s) to 1-1 mapping.
@@ -10,22 +10,25 @@
  Xen: 00000000000a0000 - 0000000000100000 (reserved)
  Xen: 0000000000100000 - 0000000010000000 (usable)
  Xen: 0000000100000000 - 0000000100800000 (usable)
+e820 remove range: 0000000010000000 - ffffffffffffffff (usable)
 NX (Execute Disable) protection: active
 MPS support code is not built-in.
 Using acpi=off or acpi=noirq or pci=noacpi may have problem
+user-defined physical RAM map:
+ user: 0000000000000000 - 00000000000a0000 (usable)
+ user: 00000000000a0000 - 0000000000100000 (reserved)
+ user: 0000000000100000 - 0000000010000000 (usable)
 DMI not present or invalid.
 e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
 e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
 No AGP bridge found
-last_pfn = 0x100800 max_arch_pfn = 0x400000000
 last_pfn = 0x10000 max_arch_pfn = 0x400000000
     memblock_x86_reserve_range: [0x01ce8000-0x01cf8fff]              BRK
 MEMBLOCK configuration:
- memory size = 0x10790000
- memory.cnt  = 0x3
+ memory size = 0xff90000
+ memory.cnt  = 0x2
  memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes
  memory[0x1]	[0x00000000100000-0x0000000fffffff], 0xff00000 bytes
- memory[0x2]	[0x00000100000000-0x000001007fffff], 0x800000 bytes
  reserved.cnt  = 0x3
  reserved[0x0]	[0x00000001000000-0x00000001cf8fff], 0xcf9000 bytes
  reserved[0x1]	[0x00000001e1e000-0x00000001eb3fff], 0x96000 bytes
@@ -38,123 +41,109 @@
 kernel direct mapping tables up to 10000000 @ ff7e000-10000000
     memblock_x86_reserve_range: [0x0ff7e000-0x0ffe9fff]          PGTABLE
 xen: setting RW the range ffea000 - 10000000
-init_memory_mapping: 0000000100000000-0000000100800000
- 0100000000 - 0100800000 page 4k
-kernel direct mapping tables up to 100800000 @ f774000-ff7e000
-    memblock_x86_reserve_range: [0x0f774000-0x0f778fff]          PGTABLE
-xen: setting RW the range f779000 - ff7e000
     memblock_x86_reserve_range: [0x0ffff000-0x0fffffff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fb7e000-0x0ff7dfff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffef80-0x0fffefc7]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffefc0-0x0fffefef]          BOOTMEM
     memblock_x86_reserve_range: [0x0f77e000-0x0fb7dfff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0f000000-0x0f5fffff]          BOOTMEM
+    memblock_x86_reserve_range: [0x0f200000-0x0f5fffff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fffd000-0x0fffdfff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fffc000-0x0fffcfff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fffb000-0x0fffbfff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fffa000-0x0fffafff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fff9000-0x0fff9fff]          BOOTMEM
-       memblock_x86_free_range: [0x0f540000-0x0f5fffff]
+       memblock_x86_free_range: [0x0f580000-0x0f5fffff]
        memblock_x86_free_range: [0x0f77e000-0x0fb7dfff]
        memblock_x86_free_range: [0x0fb7e000-0x0ff7dfff]
 Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   DMA32    0x00001000 -> 0x00100000
-  Normal   0x00100000 -> 0x00100800
+  Normal   empty
 Movable zone start PFN for each node
-early_node_map[3] active PFN ranges
+early_node_map[2] active PFN ranges
     0: 0x00000010 -> 0x000000a0
     0: 0x00000100 -> 0x00010000
-    0: 0x00100000 -> 0x00100800
-On node 0 totalpages: 67472
+On node 0 totalpages: 65424
   DMA zone: 56 pages used for memmap
   DMA zone: 2 pages reserved
   DMA zone: 3926 pages, LIFO batch:0
-    memblock_x86_reserve_range: [0x0fffee00-0x0fffef7f]          BOOTMEM
-  DMA32 zone: 14280 pages used for memmap
-  DMA32 zone: 47160 pages, LIFO batch:15
-    memblock_x86_reserve_range: [0x0ff66000-0x0ff7dfff]          BOOTMEM
-  Normal zone: 28 pages used for memmap
-  Normal zone: 2020 pages, LIFO batch:0
-    memblock_x86_reserve_range: [0x0fffed40-0x0fffedff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fff8000-0x0fff8fff]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffee40-0x0fffefbf]          BOOTMEM
+  DMA32 zone: 840 pages used for memmap
+  DMA32 zone: 60600 pages, LIFO batch:15
+    memblock_x86_reserve_range: [0x0fff8800-0x0fff9fff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fff7000-0x0fff7fff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fff6000-0x0fff6fff]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fff5000-0x0fff5fff]          BOOTMEM
 SMP: Allowing 1 CPUs, 0 hotplug CPUs
 No local APIC present
 APIC: disable apic facility
 APIC: switched to apic NOOP
 nr_irqs_gsi: 16
-    memblock_x86_reserve_range: [0x0fffec00-0x0fffed17]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffeb80-0x0fffebe7]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffeb00-0x0fffeb67]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffea80-0x0fffeae7]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffea00-0x0fffea67]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffed40-0x0fffee1f]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffecc0-0x0fffed27]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffec40-0x0fffeca7]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffebc0-0x0fffec27]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffeb40-0x0fffeba7]          BOOTMEM
 Allocating PCI resources starting at 10000000 (gap: 10000000:f0000000)
 Booting paravirtualized kernel on Xen
 Xen version: 4.1.0 (preserve-AD)
-    memblock_x86_reserve_range: [0x0fffe940-0x0fffe9d2]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffe880-0x0fffe912]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffea80-0x0fffeb1b]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffe9c0-0x0fffea5b]          BOOTMEM
 setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:1 nr_node_ids:1
-    memblock_x86_reserve_range: [0x0fff5000-0x0fff5fff]          BOOTMEM
     memblock_x86_reserve_range: [0x0fff4000-0x0fff4fff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0ff4b000-0x0ff65fff]          BOOTMEM
-PERCPU: Embedded 27 pages/cpu @ffff88000ff4b000 s79488 r8192 d22912 u110592
-    memblock_x86_reserve_range: [0x0fffe840-0x0fffe847]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffe800-0x0fffe807]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffe7c0-0x0fffe7c3]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffe780-0x0fffe787]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fff3000-0x0fff3fff]          BOOTMEM
+    memblock_x86_reserve_range: [0x0ff63000-0x0ff7dfff]          BOOTMEM
+PERCPU: Embedded 27 pages/cpu @ffff88000ff63000 s79488 r8192 d22912 u110592
+    memblock_x86_reserve_range: [0x0fffe980-0x0fffe987]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffe940-0x0fffe947]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffe900-0x0fffe903]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffe8c0-0x0fffe8c7]          BOOTMEM
 pcpu-alloc: s79488 r8192 d22912 u110592 alloc=27*4096
 pcpu-alloc: [0] 0 
-    memblock_x86_reserve_range: [0x0fffe680-0x0fffe77f]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffe600-0x0fffe647]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fffe580-0x0fffe5c7]          BOOTMEM
-       memblock_x86_free_range: [0x0fff5000-0x0fff5fff]
+    memblock_x86_reserve_range: [0x0fffe7c0-0x0fffe8bf]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffe740-0x0fffe787]          BOOTMEM
+    memblock_x86_reserve_range: [0x0fffe6c0-0x0fffe707]          BOOTMEM
        memblock_x86_free_range: [0x0fff4000-0x0fff4fff]
-Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 53106
-Kernel command line: root=/dev/xvda1 memblock=debug debug loglevel=8 initcall_debug ro ip=192.168.12.1:127.0.255.255:192.168.12.2:255.255.255.0:yumi.uguu.de:eth0:off 4
-    memblock_x86_reserve_range: [0x0fff4000-0x0fff5fff]          BOOTMEM
+       memblock_x86_free_range: [0x0fff3000-0x0fff3fff]
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64526
+Kernel command line: root=/dev/xvda1 memblock=debug debug loglevel=8 initcall_debug ro mem=256M ip=192.168.12.1:127.0.255.255:192.168.12.2:255.255.255.0:yumi.uguu.de:eth0:off 4
+    memblock_x86_reserve_range: [0x0fff3000-0x0fff4fff]          BOOTMEM
 PID hash table entries: 1024 (order: 1, 8192 bytes)
-    memblock_x86_reserve_range: [0x0ff0b000-0x0ff4afff]          BOOTMEM
+    memblock_x86_reserve_range: [0x0ff23000-0x0ff62fff]          BOOTMEM
 Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
-    memblock_x86_reserve_range: [0x0feeb000-0x0ff0afff]          BOOTMEM
+    memblock_x86_reserve_range: [0x0ff03000-0x0ff22fff]          BOOTMEM
 Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
-    memblock_x86_reserve_range: [0x0b000000-0x0effffff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fecb000-0x0feeafff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0fe8b000-0x0fecafff]          BOOTMEM
-    memblock_x86_reserve_range: [0x0ffec000-0x0fff3fff]          BOOTMEM
 Checking aperture...
 No AGP bridge found
 Subtract (23 early reservations)
   [000009e000-000009ffff]
   [0001000000-0001cf8fff]
   [0001e1e000-0001eb3fff]
-  [000b000000-000f53ffff]
-  [000f774000-000f778fff]
-  [000fe8b000-000ffe9fff]
-  [000ffec000-000fffdfff]
-  [000fffe580-000fffe5c7]
-  [000fffe600-000fffe647]
-  [000fffe680-000fffe787]
-  [000fffe7c0-000fffe7c3]
-  [000fffe800-000fffe807]
-  [000fffe840-000fffe847]
-  [000fffe880-000fffe912]
-  [000fffe940-000fffe9d2]
-  [000fffea00-000fffea67]
-  [000fffea80-000fffeae7]
-  [000fffeb00-000fffeb67]
-  [000fffeb80-000fffebe7]
-  [000fffec00-000fffed17]
-  [000fffed40-000fffefc7]
+  [000f200000-000f57ffff]
+  [000ff03000-000ffe9fff]
+  [000fff3000-000fff7fff]
+  [000fff8800-000fffdfff]
+  [000fffe6c0-000fffe707]
+  [000fffe740-000fffe787]
+  [000fffe7c0-000fffe8c7]
+  [000fffe900-000fffe903]
+  [000fffe940-000fffe947]
+  [000fffe980-000fffe987]
+  [000fffe9c0-000fffea5b]
+  [000fffea80-000fffeb1b]
+  [000fffeb40-000fffeba7]
+  [000fffebc0-000fffec27]
+  [000fffec40-000fffeca7]
+  [000fffecc0-000fffed27]
+  [000fffed40-000fffee1f]
+  [000fffee40-000fffefef]
   [000ffff000-000fffffff]
   [0100000000-01007fffff]
-Memory: 175388k/4202496k available (6122k kernel code, 3932608k absent, 94500k reserved, 4761k data, 576k init)
+Memory: 243244k/262144k available (6122k kernel code, 448k absent, 18452k reserved, 4761k data, 576k init)
 Hierarchical RCU implementation.
 NR_IRQS:320
 Console: colour dummy device 80x25
 console [tty0] enabled
 console [hvc0] enabled
-allocated 3145728 bytes of page_cgroup
+allocated 2097152 bytes of page_cgroup
 please try 'cgroup_disable=memory' option if you don't want memory cgroups
 Xen: using vcpuop timer interface
 installing Xen timer for CPU 0
@@ -244,8 +233,8 @@
 initcall debugfs_init+0x0/0x5c returned 0 after XX usecs
 calling  calibrate_xor_blocks+0x0/0xa0 @ 1
 xor: automatically using best checksumming function: generic_sse
-   generic_sse:  2901.200 MB/sec
-xor: using function: generic_sse (2901.200 MB/sec)
+   generic_sse:  2833.600 MB/sec
+xor: using function: generic_sse (2833.600 MB/sec)
 initcall calibrate_xor_blocks+0x0/0xa0 returned 0 after XX usecs
 calling  random32_init+0x0/0xd8 @ 1
 initcall random32_init+0x0/0xd8 returned 0 after XX usecs
@@ -336,14 +325,14 @@
 calling  genhd_device_init+0x0/0x7c @ 1
 initcall genhd_device_init+0x0/0x7c returned 0 after XX usecs
 calling  raid6_select_algo+0x0/0x1bd @ 1
-raid6: int64x1   2032 MB/s
-raid6: int64x2   2398 MB/s
-raid6: int64x4   1711 MB/s
-raid6: int64x8   1243 MB/s
-raid6: sse2x1    1750 MB/s
-raid6: sse2x2    2362 MB/s
-raid6: sse2x4    1807 MB/s
-raid6: using algorithm sse2x2 (2362 MB/s)
+raid6: int64x1   2027 MB/s
+raid6: int64x2   2392 MB/s
+raid6: int64x4   1703 MB/s
+raid6: int64x8   1241 MB/s
+raid6: sse2x1    1810 MB/s
+raid6: sse2x2    2515 MB/s
+raid6: sse2x4    3221 MB/s
+raid6: using algorithm sse2x4 (3221 MB/s)
 initcall raid6_select_algo+0x0/0x1bd returned 0 after XX usecs
 calling  pci_slot_init+0x0/0x46 @ 1
 initcall pci_slot_init+0x0/0x46 returned 0 after XX usecs
@@ -362,7 +351,7 @@
 initcall xen_setup_shutdown_event+0x0/0x22 returned 0 after XX usecs
 calling  balloon_init+0x0/0x130 @ 1
 xen/balloon: Initialising balloon driver.
-last_pfn = 0x100800 max_arch_pfn = 0x400000000
+last_pfn = 0x10000 max_arch_pfn = 0x400000000
 initcall balloon_init+0x0/0x130 returned 0 after XX usecs
 calling  xenbus_probe_backend_init+0x0/0x2d @ 1
 initcall xenbus_probe_backend_init+0x0/0x2d returned 0 after XX usecs
@@ -499,9 +488,6 @@
 calling  populate_rootfs+0x0/0x9e @ 1
 initcall populate_rootfs+0x0/0x9e returned 0 after XX usecs
 calling  pci_iommu_init+0x0/0x41 @ 1
-PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
-Placing 64MB software IO TLB between ffff88000b000000 - ffff88000f000000
-software IO TLB at phys 0xb000000 - 0xf000000
 initcall pci_iommu_init+0x0/0x41 returned 0 after XX usecs
 calling  irqfd_module_init+0x0/0x31 @ 1
 initcall irqfd_module_init+0x0/0x31 returned 0 after XX usecs
@@ -728,7 +714,7 @@
 SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
 initcall init_xfs_fs+0x0/0xa9 returned 0 after XX usecs
 calling  ipc_init+0x0/0x23 @ 1
-msgmni has been set to 342
+msgmni has been set to 475
 initcall ipc_init+0x0/0x23 returned 0 after XX usecs
 calling  ipc_sysctl_init+0x0/0x14 @ 1
 initcall ipc_sysctl_init+0x0/0x14 returned 0 after XX usecs
@@ -864,7 +850,6 @@
 calling  xen_blkif_init+0x0/0x276 @ 1
 initcall xen_blkif_init+0x0/0x276 returned 0 after XX usecs
 calling  init_sd+0x0/0x112 @ 1
-blkfront: xvda2: flush diskcache: enabled
 initcall init_sd+0x0/0x112 returned 0 after XX usecs
 calling  init_sr+0x0/0x46 @ 1
 initcall init_sr+0x0/0x46 returned 0 after XX usecs
@@ -885,6 +870,7 @@
 calling  pdc2027x_init+0x0/0x1b @ 1
 initcall pdc2027x_init+0x0/0x1b returned 0 after XX usecs
 calling  sil680_init+0x0/0x1b @ 1
+blkfront: xvda2: flush diskcache: enabled
 initcall sil680_init+0x0/0x1b returned 0 after XX usecs
 calling  via_init+0x0/0x1b @ 1
 initcall via_init+0x0/0x1b returned 0 after XX usecs
@@ -1210,7 +1196,7 @@
 calling  nfnetlink_log_init+0x0/0xd7 @ 1
 initcall nfnetlink_log_init+0x0/0xd7 returned 0 after XX usecs
 calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
-nf_conntrack version 0.5.0 (1370 buckets, 5480 max)
+nf_conntrack version 0.5.0 (1900 buckets, 7600 max)
 initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after XX usecs
 calling  ctnetlink_init+0x0/0x76 @ 1
 ctnetlink v0.93: registering with nfnetlink.
@@ -1468,16 +1454,19 @@
 calling  initialize_hashrnd+0x0/0x19 @ 1
 initcall initialize_hashrnd+0x0/0x19 returned 0 after XX usecs
 async_waiting @ 1
-async_continuing @ 1 after 0 usec
+async_continuing @ 1 after 44 usec
 md: Waiting for all devices to be available before autodetect
 md: If you don't use raid, use raid=noautodetect
 async_waiting @ 1
-async_continuing @ 1 after 0 usec
+async_continuing @ 1 after 3 usec
 md: Autodetecting RAID arrays.
 md: Scanned 0 and added 0 devices.
 md: autorun ...
 md: ... autorun DONE.
 EXT3-fs (xvda1): error: couldn't mount because of unsupported optional features (240)
-EXT2-fs (xvda1): error: couldn't mount because of unsupported optional features (240)
+EXT2-fs (xvda1): error: couldn't mount because of unsupported optional features (244)
+EXT4-fs (xvda1): INFO: recovery required on readonly filesystem
+EXT4-fs (xvda1): write access will be enabled during recovery
+EXT4-fs (xvda1): recovery complete
 EXT4-fs (xvda1): mounted filesystem with ordered data mode. Opts: (null)
 VFS: Mounted root (ext4 filesystem) readonly on device 202:1.

> What happens if you have 'maxmem' value equal to 'memory' in your guest config?

No difference:
--- verbose_noextraopts	2011-06-14 23:02:24.549323941 +0200
+++ verbose_maxmem	2011-06-14 23:09:47.135304415 +0200
@@ -244,8 +244,8 @@
 initcall debugfs_init+0x0/0x5c returned 0 after XX usecs
 calling  calibrate_xor_blocks+0x0/0xa0 @ 1
 xor: automatically using best checksumming function: generic_sse
-   generic_sse:  2901.200 MB/sec
-xor: using function: generic_sse (2901.200 MB/sec)
+   generic_sse:  2834.000 MB/sec
+xor: using function: generic_sse (2834.000 MB/sec)
 initcall calibrate_xor_blocks+0x0/0xa0 returned 0 after XX usecs
 calling  random32_init+0x0/0xd8 @ 1
 initcall random32_init+0x0/0xd8 returned 0 after XX usecs
@@ -338,12 +338,12 @@
 calling  raid6_select_algo+0x0/0x1bd @ 1
 raid6: int64x1   2032 MB/s
 raid6: int64x2   2398 MB/s
-raid6: int64x4   1711 MB/s
+raid6: int64x4   1710 MB/s
 raid6: int64x8   1243 MB/s
-raid6: sse2x1    1750 MB/s
-raid6: sse2x2    2362 MB/s
-raid6: sse2x4    1807 MB/s
-raid6: using algorithm sse2x2 (2362 MB/s)
+raid6: sse2x1    1926 MB/s
+raid6: sse2x2    2536 MB/s
+raid6: sse2x4    1539 MB/s
+raid6: using algorithm sse2x2 (2536 MB/s)
 initcall raid6_select_algo+0x0/0x1bd returned 0 after XX usecs
 calling  pci_slot_init+0x0/0x46 @ 1
 initcall pci_slot_init+0x0/0x46 returned 0 after XX usecs
@@ -859,9 +859,9 @@
 calling  init_cryptoloop+0x0/0x2f @ 1
 initcall init_cryptoloop+0x0/0x2f returned 0 after XX usecs
 calling  xlblk_init+0x0/0x81 @ 1
-blkfront: xvda1: flush diskcache: enabled
 initcall xlblk_init+0x0/0x81 returned 0 after XX usecs
 calling  xen_blkif_init+0x0/0x276 @ 1
+blkfront: xvda1: flush diskcache: enabled
 initcall xen_blkif_init+0x0/0x276 returned 0 after XX usecs
 calling  init_sd+0x0/0x112 @ 1
 blkfront: xvda2: flush diskcache: enabled
@@ -1478,6 +1478,9 @@
 md: autorun ...
 md: ... autorun DONE.
 EXT3-fs (xvda1): error: couldn't mount because of unsupported optional features (240)
-EXT2-fs (xvda1): error: couldn't mount because of unsupported optional features (240)
+EXT2-fs (xvda1): error: couldn't mount because of unsupported optional features (244)
+EXT4-fs (xvda1): INFO: recovery required on readonly filesystem
+EXT4-fs (xvda1): write access will be enabled during recovery
+EXT4-fs (xvda1): recovery complete
 EXT4-fs (xvda1): mounted filesystem with ordered data mode. Opts: (null)
 VFS: Mounted root (ext4 filesystem) readonly on device 202:1.


And just the noextraopts base log:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.0.0-rc2 (ranma@nukunuku) (gcc version 4.5.2 (Debian 4.5.2-11) ) #53 SMP Tue Jun 14 15:33:45 CEST 2011
Command line: root=/dev/xvda1 memblock=debug debug loglevel=8 initcall_debug ro ip=192.168.12.1:127.0.255.255:192.168.12.2:255.255.255.0:yumi.uguu.de:eth0:off 4
ACPI in unprivileged domain disabled
released 0 pages of unused memory
Set 0 page(s) to 1-1 mapping.
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000010000000 (usable)
 Xen: 0000000100000000 - 0000000100800000 (usable)
NX (Execute Disable) protection: active
MPS support code is not built-in.
Using acpi=off or acpi=noirq or pci=noacpi may have problem
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x100800 max_arch_pfn = 0x400000000
last_pfn = 0x10000 max_arch_pfn = 0x400000000
    memblock_x86_reserve_range: [0x01ce8000-0x01cf8fff]              BRK
MEMBLOCK configuration:
 memory size = 0x10790000
 memory.cnt  = 0x3
 memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes
 memory[0x1]	[0x00000000100000-0x0000000fffffff], 0xff00000 bytes
 memory[0x2]	[0x00000100000000-0x000001007fffff], 0x800000 bytes
 reserved.cnt  = 0x3
 reserved[0x0]	[0x00000001000000-0x00000001cf8fff], 0xcf9000 bytes
 reserved[0x1]	[0x00000001e1e000-0x00000001eb3fff], 0x96000 bytes
 reserved[0x2]	[0x00000100000000-0x000001007fffff], 0x800000 bytes
initial memory mapped : 0 - 01e1e000
    memblock_x86_reserve_range: [0x0009e000-0x0009ffff]       TRAMPOLINE
Base memory trampoline at [ffff88000009e000] 9e000 size 8192
init_memory_mapping: 0000000000000000-0000000010000000
 0000000000 - 0010000000 page 4k
kernel direct mapping tables up to 10000000 @ ff7e000-10000000
    memblock_x86_reserve_range: [0x0ff7e000-0x0ffe9fff]          PGTABLE
xen: setting RW the range ffea000 - 10000000
init_memory_mapping: 0000000100000000-0000000100800000
 0100000000 - 0100800000 page 4k
kernel direct mapping tables up to 100800000 @ f774000-ff7e000
    memblock_x86_reserve_range: [0x0f774000-0x0f778fff]          PGTABLE
xen: setting RW the range f779000 - ff7e000
    memblock_x86_reserve_range: [0x0ffff000-0x0fffffff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fb7e000-0x0ff7dfff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffef80-0x0fffefc7]          BOOTMEM
    memblock_x86_reserve_range: [0x0f77e000-0x0fb7dfff]          BOOTMEM
    memblock_x86_reserve_range: [0x0f000000-0x0f5fffff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffd000-0x0fffdfff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffc000-0x0fffcfff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffb000-0x0fffbfff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffa000-0x0fffafff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fff9000-0x0fff9fff]          BOOTMEM
       memblock_x86_free_range: [0x0f540000-0x0f5fffff]
       memblock_x86_free_range: [0x0f77e000-0x0fb7dfff]
       memblock_x86_free_range: [0x0fb7e000-0x0ff7dfff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100800
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00000100 -> 0x00010000
    0: 0x00100000 -> 0x00100800
On node 0 totalpages: 67472
  DMA zone: 56 pages used for memmap
  DMA zone: 2 pages reserved
  DMA zone: 3926 pages, LIFO batch:0
    memblock_x86_reserve_range: [0x0fffee00-0x0fffef7f]          BOOTMEM
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 47160 pages, LIFO batch:15
    memblock_x86_reserve_range: [0x0ff66000-0x0ff7dfff]          BOOTMEM
  Normal zone: 28 pages used for memmap
  Normal zone: 2020 pages, LIFO batch:0
    memblock_x86_reserve_range: [0x0fffed40-0x0fffedff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fff8000-0x0fff8fff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fff7000-0x0fff7fff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fff6000-0x0fff6fff]          BOOTMEM
SMP: Allowing 1 CPUs, 0 hotplug CPUs
No local APIC present
APIC: disable apic facility
APIC: switched to apic NOOP
nr_irqs_gsi: 16
    memblock_x86_reserve_range: [0x0fffec00-0x0fffed17]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffeb80-0x0fffebe7]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffeb00-0x0fffeb67]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffea80-0x0fffeae7]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffea00-0x0fffea67]          BOOTMEM
Allocating PCI resources starting at 10000000 (gap: 10000000:f0000000)
Booting paravirtualized kernel on Xen
Xen version: 4.1.0 (preserve-AD)
    memblock_x86_reserve_range: [0x0fffe940-0x0fffe9d2]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffe880-0x0fffe912]          BOOTMEM
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:1 nr_node_ids:1
    memblock_x86_reserve_range: [0x0fff5000-0x0fff5fff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fff4000-0x0fff4fff]          BOOTMEM
    memblock_x86_reserve_range: [0x0ff4b000-0x0ff65fff]          BOOTMEM
PERCPU: Embedded 27 pages/cpu @ffff88000ff4b000 s79488 r8192 d22912 u110592
    memblock_x86_reserve_range: [0x0fffe840-0x0fffe847]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffe800-0x0fffe807]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffe7c0-0x0fffe7c3]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffe780-0x0fffe787]          BOOTMEM
pcpu-alloc: s79488 r8192 d22912 u110592 alloc=27*4096
pcpu-alloc: [0] 0 
    memblock_x86_reserve_range: [0x0fffe680-0x0fffe77f]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffe600-0x0fffe647]          BOOTMEM
    memblock_x86_reserve_range: [0x0fffe580-0x0fffe5c7]          BOOTMEM
       memblock_x86_free_range: [0x0fff5000-0x0fff5fff]
       memblock_x86_free_range: [0x0fff4000-0x0fff4fff]
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 53106
Kernel command line: root=/dev/xvda1 memblock=debug debug loglevel=8 initcall_debug ro ip=192.168.12.1:127.0.255.255:192.168.12.2:255.255.255.0:yumi.uguu.de:eth0:off 4
    memblock_x86_reserve_range: [0x0fff4000-0x0fff5fff]          BOOTMEM
PID hash table entries: 1024 (order: 1, 8192 bytes)
    memblock_x86_reserve_range: [0x0ff0b000-0x0ff4afff]          BOOTMEM
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
    memblock_x86_reserve_range: [0x0feeb000-0x0ff0afff]          BOOTMEM
Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
    memblock_x86_reserve_range: [0x0b000000-0x0effffff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fecb000-0x0feeafff]          BOOTMEM
    memblock_x86_reserve_range: [0x0fe8b000-0x0fecafff]          BOOTMEM
    memblock_x86_reserve_range: [0x0ffec000-0x0fff3fff]          BOOTMEM
Checking aperture...
No AGP bridge found
Subtract (23 early reservations)
  [000009e000-000009ffff]
  [0001000000-0001cf8fff]
  [0001e1e000-0001eb3fff]
  [000b000000-000f53ffff]
  [000f774000-000f778fff]
  [000fe8b000-000ffe9fff]
  [000ffec000-000fffdfff]
  [000fffe580-000fffe5c7]
  [000fffe600-000fffe647]
  [000fffe680-000fffe787]
  [000fffe7c0-000fffe7c3]
  [000fffe800-000fffe807]
  [000fffe840-000fffe847]
  [000fffe880-000fffe912]
  [000fffe940-000fffe9d2]
  [000fffea00-000fffea67]
  [000fffea80-000fffeae7]
  [000fffeb00-000fffeb67]
  [000fffeb80-000fffebe7]
  [000fffec00-000fffed17]
  [000fffed40-000fffefc7]
  [000ffff000-000fffffff]
  [0100000000-01007fffff]
Memory: 175388k/4202496k available (6122k kernel code, 3932608k absent, 94500k reserved, 4761k data, 576k init)
Hierarchical RCU implementation.
NR_IRQS:320
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
allocated 3145728 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Xen: using vcpuop timer interface
installing Xen timer for CPU 0
Detected 2199.838 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.67 BogoMIPS (lpj=21998380)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
tseg: 007ff00000
SMP alternatives: switching to UP code
Freeing SMP alternatives: 28k freed
calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after XX usecs
calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after XX usecs
calling  init_hw_perf_events+0x0/0xf1a @ 1
Performance Events: 
no APIC, boot with the "lapic" boot parameter to force-enable it.
no hardware sampling interrupt available.
Broken PMU hardware detected, using software events only.
initcall init_hw_perf_events+0x0/0xf1a returned 0 after XX usecs
calling  register_trigger_all_cpu_backtrace+0x0/0x14 @ 1
initcall register_trigger_all_cpu_backtrace+0x0/0x14 returned 0 after XX usecs
calling  migration_init+0x0/0x70 @ 1
initcall migration_init+0x0/0x70 returned 0 after XX usecs
calling  spawn_ksoftirqd+0x0/0x55 @ 1
initcall spawn_ksoftirqd+0x0/0x55 returned 0 after XX usecs
calling  init_workqueues+0x0/0x2ff @ 1
initcall init_workqueues+0x0/0x2ff returned 0 after XX usecs
calling  init_call_single_data+0x0/0x8c @ 1
initcall init_call_single_data+0x0/0x8c returned 0 after XX usecs
calling  cpu_stop_init+0x0/0xaa @ 1
initcall cpu_stop_init+0x0/0xaa returned 0 after XX usecs
calling  rcu_spawn_kthreads+0x0/0xc9 @ 1
initcall rcu_spawn_kthreads+0x0/0xc9 returned 0 after XX usecs
calling  relay_init+0x0/0x14 @ 1
initcall relay_init+0x0/0x14 returned 0 after XX usecs
calling  tracer_alloc_buffers+0x0/0x168 @ 1
initcall tracer_alloc_buffers+0x0/0x168 returned 0 after XX usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after XX usecs
NMI watchdog disabled (cpu0): hardware events not enabled
Brought up 1 CPUs
devtmpfs: initialized
calling  init_mmap_min_addr+0x0/0x16 @ 1
initcall init_mmap_min_addr+0x0/0x16 returned 0 after XX usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after XX usecs
calling  net_ns_init+0x0/0x154 @ 1
initcall net_ns_init+0x0/0x154 returned 0 after XX usecs
calling  cpufreq_tsc+0x0/0x30 @ 1
initcall cpufreq_tsc+0x0/0x30 returned 0 after XX usecs
calling  pci_reboot_init+0x0/0x14 @ 1
initcall pci_reboot_init+0x0/0x14 returned 0 after XX usecs
calling  init_lapic_sysfs+0x0/0x20 @ 1
initcall init_lapic_sysfs+0x0/0x20 returned 0 after XX usecs
calling  init_smp_flush+0x0/0x2d @ 1
initcall init_smp_flush+0x0/0x2d returned 0 after XX usecs
calling  alloc_frozen_cpus+0x0/0x8 @ 1
initcall alloc_frozen_cpus+0x0/0x8 returned 0 after XX usecs
calling  sysctl_init+0x0/0x16 @ 1
initcall sysctl_init+0x0/0x16 returned 0 after XX usecs
calling  ksysfs_init+0x0/0x94 @ 1
initcall ksysfs_init+0x0/0x94 returned 0 after XX usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after XX usecs
calling  pm_init+0x0/0x63 @ 1
initcall pm_init+0x0/0x63 returned 0 after XX usecs
calling  init_zero_pfn+0x0/0x35 @ 1
initcall init_zero_pfn+0x0/0x35 returned 0 after XX usecs
calling  fsnotify_init+0x0/0x26 @ 1
initcall fsnotify_init+0x0/0x26 returned 0 after XX usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after XX usecs
calling  init_misc_binfmt+0x0/0x44 @ 1
initcall init_misc_binfmt+0x0/0x44 returned 0 after XX usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after XX usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after XX usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after XX usecs
calling  debugfs_init+0x0/0x5c @ 1
initcall debugfs_init+0x0/0x5c returned 0 after XX usecs
calling  calibrate_xor_blocks+0x0/0xa0 @ 1
xor: automatically using best checksumming function: generic_sse
   generic_sse:  2901.200 MB/sec
xor: using function: generic_sse (2901.200 MB/sec)
initcall calibrate_xor_blocks+0x0/0xa0 returned 0 after XX usecs
calling  random32_init+0x0/0xd8 @ 1
initcall random32_init+0x0/0xd8 returned 0 after XX usecs
calling  __gnttab_init+0x0/0x21 @ 1
Grant table initialized
initcall __gnttab_init+0x0/0x21 returned 0 after XX usecs
calling  cpufreq_core_init+0x0/0xad @ 1
initcall cpufreq_core_init+0x0/0xad returned 0 after XX usecs
calling  cpuidle_init+0x0/0x40 @ 1
initcall cpuidle_init+0x0/0x40 returned 0 after XX usecs
calling  sock_init+0x0/0x83 @ 1
initcall sock_init+0x0/0x83 returned 0 after XX usecs
calling  netpoll_init+0x0/0x31 @ 1
initcall netpoll_init+0x0/0x31 returned 0 after XX usecs
calling  netlink_proto_init+0x0/0x1ad @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x1ad returned 0 after XX usecs
calling  bdi_class_init+0x0/0x49 @ 1
initcall bdi_class_init+0x0/0x49 returned 0 after XX usecs
calling  kobject_uevent_init+0x0/0x21 @ 1
initcall kobject_uevent_init+0x0/0x21 returned 0 after XX usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after XX usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after XX usecs
calling  xenbus_init+0x0/0x371 @ 1
initcall xenbus_init+0x0/0x371 returned 0 after XX usecs
calling  tty_class_init+0x0/0x34 @ 1
initcall tty_class_init+0x0/0x34 returned 0 after XX usecs
calling  vtconsole_class_init+0x0/0xeb @ 1
initcall vtconsole_class_init+0x0/0xeb returned 0 after XX usecs
calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after XX usecs
calling  i2c_init+0x0/0x6f @ 1
initcall i2c_init+0x0/0x6f returned 0 after XX usecs
calling  amd_postcore_init+0x0/0x150 @ 1
initcall amd_postcore_init+0x0/0x150 returned 0 after XX usecs
calling  arch_kdebugfs_init+0x0/0x24 @ 1
initcall arch_kdebugfs_init+0x0/0x24 returned 0 after XX usecs
calling  configure_trampolines+0x0/0x29 @ 1
initcall configure_trampolines+0x0/0x29 returned 0 after XX usecs
calling  mtrr_if_init+0x0/0x64 @ 1
initcall mtrr_if_init+0x0/0x64 returned -19 after XX usecs
calling  ffh_cstate_init+0x0/0x2a @ 1
initcall ffh_cstate_init+0x0/0x2a returned -1 after XX usecs
initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
calling  acpi_pci_init+0x0/0x61 @ 1
initcall acpi_pci_init+0x0/0x61 returned 0 after XX usecs
calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after XX usecs
calling  register_xen_pci_notifier+0x0/0x31 @ 1
initcall register_xen_pci_notifier+0x0/0x31 returned 0 after XX usecs
calling  dmi_id_init+0x0/0x30e @ 1
initcall dmi_id_init+0x0/0x30e returned -19 after XX usecs
calling  pci_arch_init+0x0/0x69 @ 1
PCI: setting up Xen PCI frontend stub
PCI: pci_cache_line_size set to 64 bytes
initcall pci_arch_init+0x0/0x69 returned 0 after XX usecs
calling  topology_init+0x0/0x40 @ 1
initcall topology_init+0x0/0x40 returned 0 after XX usecs
calling  mtrr_init_finialize+0x0/0x36 @ 1
initcall mtrr_init_finialize+0x0/0x36 returned 0 after XX usecs
calling  init_vdso_vars+0x0/0xf8 @ 1
initcall init_vdso_vars+0x0/0xf8 returned 0 after XX usecs
calling  sysenter_setup+0x0/0x2c8 @ 1
initcall sysenter_setup+0x0/0x2c8 returned 0 after XX usecs
calling  param_sysfs_init+0x0/0x1b4 @ 1
initcall param_sysfs_init+0x0/0x1b4 returned 0 after XX usecs
calling  pm_sysrq_init+0x0/0x19 @ 1
initcall pm_sysrq_init+0x0/0x19 returned 0 after XX usecs
calling  default_bdi_init+0x0/0xa9 @ 1
initcall default_bdi_init+0x0/0xa9 returned 0 after XX usecs
calling  init_bio+0x0/0xe5 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xe5 returned 0 after XX usecs
calling  fsnotify_notification_init+0x0/0x8b @ 1
initcall fsnotify_notification_init+0x0/0x8b returned 0 after XX usecs
calling  cryptomgr_init+0x0/0x12 @ 1
initcall cryptomgr_init+0x0/0x12 returned 0 after XX usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after XX usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after XX usecs
calling  blk_softirq_init+0x0/0x6e @ 1
initcall blk_softirq_init+0x0/0x6e returned 0 after XX usecs
calling  blk_iopoll_setup+0x0/0x6e @ 1
initcall blk_iopoll_setup+0x0/0x6e returned 0 after XX usecs
calling  genhd_device_init+0x0/0x7c @ 1
initcall genhd_device_init+0x0/0x7c returned 0 after XX usecs
calling  raid6_select_algo+0x0/0x1bd @ 1
raid6: int64x1   2032 MB/s
raid6: int64x2   2398 MB/s
raid6: int64x4   1711 MB/s
raid6: int64x8   1243 MB/s
raid6: sse2x1    1750 MB/s
raid6: sse2x2    2362 MB/s
raid6: sse2x4    1807 MB/s
raid6: using algorithm sse2x2 (2362 MB/s)
initcall raid6_select_algo+0x0/0x1bd returned 0 after XX usecs
calling  pci_slot_init+0x0/0x46 @ 1
initcall pci_slot_init+0x0/0x46 returned 0 after XX usecs
calling  acpi_init+0x0/0xb6 @ 1
ACPI: Interpreter disabled.
initcall acpi_init+0x0/0xb6 returned -19 after XX usecs
calling  dock_init+0x0/0xa5 @ 1
initcall dock_init+0x0/0xa5 returned 0 after XX usecs
calling  acpi_pci_root_init+0x0/0x28 @ 1
initcall acpi_pci_root_init+0x0/0x28 returned 0 after XX usecs
calling  acpi_pci_link_init+0x0/0x3e @ 1
initcall acpi_pci_link_init+0x0/0x3e returned 0 after XX usecs
calling  pnp_init+0x0/0x12 @ 1
initcall pnp_init+0x0/0x12 returned 0 after XX usecs
calling  xen_setup_shutdown_event+0x0/0x22 @ 1
initcall xen_setup_shutdown_event+0x0/0x22 returned 0 after XX usecs
calling  balloon_init+0x0/0x130 @ 1
xen/balloon: Initialising balloon driver.
last_pfn = 0x100800 max_arch_pfn = 0x400000000
initcall balloon_init+0x0/0x130 returned 0 after XX usecs
calling  xenbus_probe_backend_init+0x0/0x2d @ 1
initcall xenbus_probe_backend_init+0x0/0x2d returned 0 after XX usecs
calling  xenbus_probe_frontend_init+0x0/0x2d @ 1
initcall xenbus_probe_frontend_init+0x0/0x2d returned 0 after XX usecs
calling  balloon_init+0x0/0x100 @ 1
xen-balloon: Initialising balloon driver.
initcall balloon_init+0x0/0x100 returned 0 after XX usecs
calling  misc_init+0x0/0xb7 @ 1
initcall misc_init+0x0/0xb7 returned 0 after XX usecs
calling  vga_arb_device_init+0x0/0xe4 @ 1
vgaarb: loaded
initcall vga_arb_device_init+0x0/0xe4 returned 0 after XX usecs
calling  init_scsi+0x0/0x7c @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x7c returned 0 after XX usecs
calling  ata_init+0x0/0x349 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x349 returned 0 after XX usecs
calling  usb_init+0x0/0x15f @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x15f returned 0 after XX usecs
calling  serio_init+0x0/0x31 @ 1
initcall serio_init+0x0/0x31 returned 0 after XX usecs
calling  input_init+0x0/0x10c @ 1
initcall input_init+0x0/0x10c returned 0 after XX usecs
calling  rtc_init+0x0/0x6a @ 1
initcall rtc_init+0x0/0x6a returned 0 after XX usecs
calling  power_supply_class_init+0x0/0x40 @ 1
initcall power_supply_class_init+0x0/0x40 returned 0 after XX usecs
calling  hwmon_init+0x0/0xee @ 1
initcall hwmon_init+0x0/0xee returned 0 after XX usecs
calling  md_init+0x0/0x144 @ 1
initcall md_init+0x0/0x144 returned 0 after XX usecs
calling  init_soundcore+0x0/0x34 @ 1
initcall init_soundcore+0x0/0x34 returned 0 after XX usecs
calling  alsa_sound_init+0x0/0x90 @ 1
Advanced Linux Sound Architecture Driver Version 1.0.24.
initcall alsa_sound_init+0x0/0x90 returned 0 after XX usecs
calling  pci_subsys_init+0x0/0x4d @ 1
PCI: System does not support PCI
PCI: System does not support PCI
initcall pci_subsys_init+0x0/0x4d returned 0 after XX usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after XX usecs
calling  net_dev_init+0x0/0x1d9 @ 1
initcall net_dev_init+0x0/0x1d9 returned 0 after XX usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after XX usecs
calling  fib_rules_init+0x0/0xa6 @ 1
initcall fib_rules_init+0x0/0xa6 returned 0 after XX usecs
calling  pktsched_init+0x0/0xed @ 1
initcall pktsched_init+0x0/0xed returned 0 after XX usecs
calling  tc_filter_init+0x0/0x4c @ 1
initcall tc_filter_init+0x0/0x4c returned 0 after XX usecs
calling  tc_action_init+0x0/0x4c @ 1
initcall tc_action_init+0x0/0x4c returned 0 after XX usecs
calling  genl_init+0x0/0x93 @ 1
initcall genl_init+0x0/0x93 returned 0 after XX usecs
calling  sysctl_init+0x0/0x48 @ 1
initcall sysctl_init+0x0/0x48 returned 0 after XX usecs
calling  print_ICs+0x0/0x510 @ 1
initcall print_ICs+0x0/0x510 returned 0 after XX usecs
calling  hpet_late_init+0x0/0xf4 @ 1
initcall hpet_late_init+0x0/0xf4 returned -19 after XX usecs
calling  init_amd_nbs+0x0/0xba @ 1
initcall init_amd_nbs+0x0/0xba returned 0 after XX usecs
calling  clocksource_done_booting+0x0/0x5a @ 1
Switching to clocksource xen
initcall clocksource_done_booting+0x0/0x5a returned 0 after XX usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after XX usecs
calling  tracer_init_debugfs+0x0/0x36b @ 1
initcall tracer_init_debugfs+0x0/0x36b returned 0 after XX usecs
calling  init_trace_printk_function_export+0x0/0x2f @ 1
initcall init_trace_printk_function_export+0x0/0x2f returned 0 after XX usecs
calling  event_trace_init+0x0/0x2bd @ 1
initcall event_trace_init+0x0/0x2bd returned 0 after XX usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after XX usecs
calling  eventpoll_init+0x0/0xda @ 1
initcall eventpoll_init+0x0/0xda returned 0 after XX usecs
calling  anon_inode_init+0x0/0x12e @ 1
initcall anon_inode_init+0x0/0x12e returned 0 after XX usecs
calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after XX usecs
calling  acpi_event_init+0x0/0x52 @ 1
initcall acpi_event_init+0x0/0x52 returned 0 after XX usecs
calling  pnp_system_init+0x0/0x12 @ 1
initcall pnp_system_init+0x0/0x12 returned 0 after XX usecs
calling  pnpacpi_init+0x0/0x8c @ 1
pnp: PnP ACPI: disabled
initcall pnpacpi_init+0x0/0x8c returned 0 after XX usecs
calling  chr_dev_init+0x0/0xc1 @ 1
Switched to NOHz mode on CPU #0
initcall chr_dev_init+0x0/0xc1 returned 0 after XX usecs
calling  firmware_class_init+0x0/0x19 @ 1
initcall firmware_class_init+0x0/0x19 returned 0 after XX usecs
calling  thermal_init+0x0/0x75 @ 1
initcall thermal_init+0x0/0x75 returned 0 after XX usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after XX usecs
calling  init_acpi_pm_clocksource+0x0/0xe0 @ 1
initcall init_acpi_pm_clocksource+0x0/0xe0 returned -19 after XX usecs
calling  pcibios_assign_resources+0x0/0x74 @ 1
PCI: max bus depth: 0 pci_try_num: 1
initcall pcibios_assign_resources+0x0/0x74 returned 0 after XX usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after XX usecs
calling  inet_init+0x0/0x286 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
TCP established hash table entries: 8192 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
UDP hash table entries: 128 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
initcall inet_init+0x0/0x286 returned 0 after XX usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after XX usecs
calling  init_sunrpc+0x0/0x73 @ 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x73 returned 0 after XX usecs
calling  pci_apply_final_quirks+0x0/0x106 @ 1
PCI: CLS 0 bytes, default 64
initcall pci_apply_final_quirks+0x0/0x106 returned 0 after XX usecs
calling  populate_rootfs+0x0/0x9e @ 1
initcall populate_rootfs+0x0/0x9e returned 0 after XX usecs
calling  pci_iommu_init+0x0/0x41 @ 1
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88000b000000 - ffff88000f000000
software IO TLB at phys 0xb000000 - 0xf000000
initcall pci_iommu_init+0x0/0x41 returned 0 after XX usecs
calling  irqfd_module_init+0x0/0x31 @ 1
initcall irqfd_module_init+0x0/0x31 returned 0 after XX usecs
calling  svm_init+0x0/0x1e @ 1
has_svm: svm not available
kvm: no hardware support
initcall svm_init+0x0/0x1e returned -95 after XX usecs
initcall svm_init+0x0/0x1e returned with error code -95 
calling  i8259A_init_ops+0x0/0x21 @ 1
initcall i8259A_init_ops+0x0/0x21 returned 0 after XX usecs
calling  vsyscall_init+0x0/0x66 @ 1
initcall vsyscall_init+0x0/0x66 returned 0 after XX usecs
calling  sbf_init+0x0/0xe9 @ 1
initcall sbf_init+0x0/0xe9 returned 0 after XX usecs
calling  init_tsc_clocksource+0x0/0x5f @ 1
initcall init_tsc_clocksource+0x0/0x5f returned 0 after XX usecs
calling  add_rtc_cmos+0x0/0x97 @ 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0x97 returned 0 after XX usecs
calling  i8237A_init_ops+0x0/0x14 @ 1
initcall i8237A_init_ops+0x0/0x14 returned 0 after XX usecs
calling  cache_sysfs_init+0x0/0x64 @ 1
initcall cache_sysfs_init+0x0/0x64 returned 0 after XX usecs
calling  mcheck_init_device+0x0/0x100 @ 1
initcall mcheck_init_device+0x0/0x100 returned -5 after XX usecs
initcall mcheck_init_device+0x0/0x100 returned with error code -5 
calling  threshold_init_device+0x0/0x4f @ 1
initcall threshold_init_device+0x0/0x4f returned 0 after XX usecs
calling  thermal_throttle_init_device+0x0/0x9b @ 1
initcall thermal_throttle_init_device+0x0/0x9b returned 0 after XX usecs
calling  ioapic_init_ops+0x0/0x14 @ 1
initcall ioapic_init_ops+0x0/0x14 returned 0 after XX usecs
calling  add_pcspkr+0x0/0x3a @ 1
initcall add_pcspkr+0x0/0x3a returned 0 after XX usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after XX usecs
calling  init+0x0/0x12 @ 1
initcall init+0x0/0x12 returned 0 after XX usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after XX usecs
calling  init_sched_debug_procfs+0x0/0x2c @ 1
initcall init_sched_debug_procfs+0x0/0x2c returned 0 after XX usecs
calling  proc_schedstat_init+0x0/0x22 @ 1
initcall proc_schedstat_init+0x0/0x22 returned 0 after XX usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after XX usecs
calling  ioresources_init+0x0/0x3c @ 1
initcall ioresources_init+0x0/0x3c returned 0 after XX usecs
calling  uid_cache_init+0x0/0x8d @ 1
initcall uid_cache_init+0x0/0x8d returned 0 after XX usecs
calling  init_posix_timers+0x0/0x1cf @ 1
initcall init_posix_timers+0x0/0x1cf returned 0 after XX usecs
calling  init_posix_cpu_timers+0x0/0xbf @ 1
initcall init_posix_cpu_timers+0x0/0xbf returned 0 after XX usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after XX usecs
calling  timekeeping_init_ops+0x0/0x14 @ 1
initcall timekeeping_init_ops+0x0/0x14 returned 0 after XX usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after XX usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after XX usecs
calling  alarmtimer_init+0x0/0x147 @ 1
initcall alarmtimer_init+0x0/0x147 returned 0 after XX usecs
calling  init_tstats_procfs+0x0/0x2c @ 1
initcall init_tstats_procfs+0x0/0x2c returned 0 after XX usecs
calling  futex_init+0x0/0x5d @ 1
initcall futex_init+0x0/0x5d returned 0 after XX usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after XX usecs
calling  proc_modules_init+0x0/0x22 @ 1
initcall proc_modules_init+0x0/0x22 returned 0 after XX usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after XX usecs
calling  ikconfig_init+0x0/0x3a @ 1
initcall ikconfig_init+0x0/0x3a returned 0 after XX usecs
calling  hung_task_init+0x0/0x56 @ 1
initcall hung_task_init+0x0/0x56 returned 0 after XX usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after XX usecs
calling  init_tracepoints+0x0/0x12 @ 1
initcall init_tracepoints+0x0/0x12 returned 0 after XX usecs
calling  init_lstats_procfs+0x0/0x25 @ 1
initcall init_lstats_procfs+0x0/0x25 returned 0 after XX usecs
calling  init_events+0x0/0x61 @ 1
initcall init_events+0x0/0x61 returned 0 after XX usecs
calling  init_mmio_trace+0x0/0x12 @ 1
initcall init_mmio_trace+0x0/0x12 returned 0 after XX usecs
calling  init_blk_tracer+0x0/0x55 @ 1
initcall init_blk_tracer+0x0/0x55 returned 0 after XX usecs
calling  perf_event_sysfs_init+0x0/0x93 @ 1
initcall perf_event_sysfs_init+0x0/0x93 returned 0 after XX usecs
calling  init_per_zone_wmark_min+0x0/0x88 @ 1
initcall init_per_zone_wmark_min+0x0/0x88 returned 0 after XX usecs
calling  kswapd_init+0x0/0x20 @ 1
initcall kswapd_init+0x0/0x20 returned 0 after XX usecs
calling  extfrag_debug_init+0x0/0x7b @ 1
initcall extfrag_debug_init+0x0/0x7b returned 0 after XX usecs
calling  setup_vmstat+0x0/0xc0 @ 1
initcall setup_vmstat+0x0/0xc0 returned 0 after XX usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after XX usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after XX usecs
calling  procswaps_init+0x0/0x22 @ 1
initcall procswaps_init+0x0/0x22 returned 0 after XX usecs
calling  hugetlb_init+0x0/0x3db @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x3db returned 0 after XX usecs
calling  slab_proc_init+0x0/0x25 @ 1
initcall slab_proc_init+0x0/0x25 returned 0 after XX usecs
calling  cpucache_init+0x0/0x40 @ 1
initcall cpucache_init+0x0/0x40 returned 0 after XX usecs
calling  hugepage_init+0x0/0x12a @ 1
initcall hugepage_init+0x0/0x12a returned -22 after XX usecs
initcall hugepage_init+0x0/0x12a returned with error code -22 
calling  init_cleancache+0x0/0x1b @ 1
initcall init_cleancache+0x0/0x1b returned 0 after XX usecs
calling  fcntl_init+0x0/0x2a @ 1
initcall fcntl_init+0x0/0x2a returned 0 after XX usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after XX usecs
calling  fsnotify_mark_init+0x0/0x40 @ 1
initcall fsnotify_mark_init+0x0/0x40 returned 0 after XX usecs
calling  dnotify_init+0x0/0x7b @ 1
initcall dnotify_init+0x0/0x7b returned 0 after XX usecs
calling  inotify_user_setup+0x0/0x70 @ 1
initcall inotify_user_setup+0x0/0x70 returned 0 after XX usecs
calling  aio_setup+0x0/0x78 @ 1
initcall aio_setup+0x0/0x78 returned 0 after XX usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after XX usecs
calling  init_sys32_ioctl+0x0/0x28 @ 1
initcall init_sys32_ioctl+0x0/0x28 returned 0 after XX usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after XX usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after XX usecs
calling  proc_consoles_init+0x0/0x22 @ 1
initcall proc_consoles_init+0x0/0x22 returned 0 after XX usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after XX usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after XX usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after XX usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after XX usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after XX usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after XX usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after XX usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after XX usecs
calling  proc_softirqs_init+0x0/0x22 @ 1
initcall proc_softirqs_init+0x0/0x22 returned 0 after XX usecs
calling  proc_kcore_init+0x0/0xa9 @ 1
initcall proc_kcore_init+0x0/0xa9 returned 0 after XX usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after XX usecs
calling  proc_page_init+0x0/0x42 @ 1
initcall proc_page_init+0x0/0x42 returned 0 after XX usecs
calling  configfs_init+0x0/0xb3 @ 1
initcall configfs_init+0x0/0xb3 returned 0 after XX usecs
calling  init_devpts_fs+0x0/0x4c @ 1
initcall init_devpts_fs+0x0/0x4c returned 0 after XX usecs
calling  init_ext3_fs+0x0/0x6f @ 1
initcall init_ext3_fs+0x0/0x6f returned 0 after XX usecs
calling  init_ext2_fs+0x0/0x6f @ 1
initcall init_ext2_fs+0x0/0x6f returned 0 after XX usecs
calling  ext4_init_fs+0x0/0x20c @ 1
initcall ext4_init_fs+0x0/0x20c returned 0 after XX usecs
calling  journal_init+0x0/0x97 @ 1
initcall journal_init+0x0/0x97 returned 0 after XX usecs
calling  journal_init+0x0/0x104 @ 1
initcall journal_init+0x0/0x104 returned 0 after XX usecs
calling  init_squashfs_fs+0x0/0x66 @ 1
squashfs: version 4.0 (2009/01/31) Phillip Lougher
initcall init_squashfs_fs+0x0/0x66 returned 0 after XX usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after XX usecs
calling  init_hugetlbfs_fs+0x0/0x98 @ 1
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after XX usecs
calling  init_fat_fs+0x0/0x4f @ 1
initcall init_fat_fs+0x0/0x4f returned 0 after XX usecs
calling  init_vfat_fs+0x0/0x12 @ 1
initcall init_vfat_fs+0x0/0x12 returned 0 after XX usecs
calling  init_iso9660_fs+0x0/0x5c @ 1
initcall init_iso9660_fs+0x0/0x5c returned 0 after XX usecs
calling  init_nfs_fs+0x0/0x10e @ 1
initcall init_nfs_fs+0x0/0x10e returned 0 after XX usecs
calling  init_nfsd+0x0/0xbb @ 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xbb returned 0 after XX usecs
calling  init_nlm+0x0/0x22 @ 1
initcall init_nlm+0x0/0x22 returned 0 after XX usecs
calling  init_nls_cp437+0x0/0x12 @ 1
initcall init_nls_cp437+0x0/0x12 returned 0 after XX usecs
calling  init_nls_cp850+0x0/0x12 @ 1
initcall init_nls_cp850+0x0/0x12 returned 0 after XX usecs
calling  init_nls_cp932+0x0/0x12 @ 1
initcall init_nls_cp932+0x0/0x12 returned 0 after XX usecs
calling  init_nls_euc_jp+0x0/0x48 @ 1
initcall init_nls_euc_jp+0x0/0x48 returned 0 after XX usecs
calling  init_nls_iso8859_1+0x0/0x12 @ 1
initcall init_nls_iso8859_1+0x0/0x12 returned 0 after XX usecs
calling  init_nls_iso8859_15+0x0/0x12 @ 1
initcall init_nls_iso8859_15+0x0/0x12 returned 0 after XX usecs
calling  init_nls_utf8+0x0/0x29 @ 1
initcall init_nls_utf8+0x0/0x29 returned 0 after XX usecs
calling  init_ntfs_fs+0x0/0x1d1 @ 1
NTFS driver 2.1.30 [Flags: R/W].
initcall init_ntfs_fs+0x0/0x1d1 returned 0 after XX usecs
calling  init_autofs4_fs+0x0/0x26 @ 1
initcall init_autofs4_fs+0x0/0x26 returned 0 after XX usecs
calling  fuse_init+0x0/0x141 @ 1
fuse init (API version 7.16)
initcall fuse_init+0x0/0x141 returned 0 after XX usecs
calling  init_udf_fs+0x0/0x5c @ 1
initcall init_udf_fs+0x0/0x5c returned 0 after XX usecs
calling  init_xfs_fs+0x0/0xa9 @ 1
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
initcall init_xfs_fs+0x0/0xa9 returned 0 after XX usecs
calling  ipc_init+0x0/0x23 @ 1
msgmni has been set to 342
initcall ipc_init+0x0/0x23 returned 0 after XX usecs
calling  ipc_sysctl_init+0x0/0x14 @ 1
initcall ipc_sysctl_init+0x0/0x14 returned 0 after XX usecs
calling  key_proc_init+0x0/0x33 @ 1
initcall key_proc_init+0x0/0x33 returned 0 after XX usecs
calling  crypto_wq_init+0x0/0x31 @ 1
initcall crypto_wq_init+0x0/0x31 returned 0 after XX usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after XX usecs
calling  skcipher_module_init+0x0/0x36 @ 1
initcall skcipher_module_init+0x0/0x36 returned 0 after XX usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after XX usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after XX usecs
calling  seqiv_module_init+0x0/0x12 @ 1
initcall seqiv_module_init+0x0/0x12 returned 0 after XX usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after XX usecs
calling  md5_mod_init+0x0/0x12 @ 1
initcall md5_mod_init+0x0/0x12 returned 0 after XX usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after XX usecs
calling  sha256_generic_mod_init+0x0/0x3f @ 1
initcall sha256_generic_mod_init+0x0/0x3f returned 0 after XX usecs
calling  crypto_cbc_module_init+0x0/0x12 @ 1
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after XX usecs
calling  crypto_ctr_module_init+0x0/0x3e @ 1
initcall crypto_ctr_module_init+0x0/0x3e returned 0 after XX usecs
calling  cryptd_init+0x0/0xc5 @ 1
initcall cryptd_init+0x0/0xc5 returned 0 after XX usecs
calling  des_generic_mod_init+0x0/0x3f @ 1
initcall des_generic_mod_init+0x0/0x3f returned 0 after XX usecs
calling  blowfish_mod_init+0x0/0x12 @ 1
initcall blowfish_mod_init+0x0/0x12 returned 0 after XX usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after XX usecs
calling  krng_mod_init+0x0/0x12 @ 1
initcall krng_mod_init+0x0/0x12 returned 0 after XX usecs
calling  async_pq_init+0x0/0x44 @ 1
initcall async_pq_init+0x0/0x44 returned 0 after XX usecs
calling  proc_genhd_init+0x0/0x3c @ 1
initcall proc_genhd_init+0x0/0x3c returned 0 after XX usecs
calling  init_cgroup_blkio+0x0/0x12 @ 1
initcall init_cgroup_blkio+0x0/0x12 returned 0 after XX usecs
calling  throtl_init+0x0/0x44 @ 1
initcall throtl_init+0x0/0x44 returned 0 after XX usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after XX usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after XX usecs
calling  cfq_init+0x0/0xb3 @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0xb3 returned 0 after XX usecs
calling  init_kmp+0x0/0x12 @ 1
initcall init_kmp+0x0/0x12 returned 0 after XX usecs
calling  init_bm+0x0/0x12 @ 1
initcall init_bm+0x0/0x12 returned 0 after XX usecs
calling  init_fsm+0x0/0x12 @ 1
initcall init_fsm+0x0/0x12 returned 0 after XX usecs
calling  percpu_counter_startup+0x0/0x19 @ 1
initcall percpu_counter_startup+0x0/0x19 returned 0 after XX usecs
calling  pci_proc_init+0x0/0x6b @ 1
initcall pci_proc_init+0x0/0x6b returned 0 after XX usecs
calling  pcie_portdrv_init+0x0/0x7a @ 1
initcall pcie_portdrv_init+0x0/0x7a returned 0 after XX usecs
calling  aer_service_init+0x0/0x22 @ 1
initcall aer_service_init+0x0/0x22 returned 0 after XX usecs
calling  pcie_pme_service_init+0x0/0x12 @ 1
initcall pcie_pme_service_init+0x0/0x12 returned 0 after XX usecs
calling  ioapic_init+0x0/0x1b @ 1
initcall ioapic_init+0x0/0x1b returned 0 after XX usecs
calling  pcifront_init+0x0/0x5c @ 1
initcall pcifront_init+0x0/0x5c returned 0 after XX usecs
calling  acpi_reserve_resources+0x0/0xeb @ 1
initcall acpi_reserve_resources+0x0/0xeb returned 0 after XX usecs
calling  irqrouter_init_ops+0x0/0x26 @ 1
initcall irqrouter_init_ops+0x0/0x26 returned 0 after XX usecs
calling  acpi_button_init+0x0/0x12 @ 1
initcall acpi_button_init+0x0/0x12 returned -19 after XX usecs
calling  acpi_fan_init+0x0/0x18 @ 1
initcall acpi_fan_init+0x0/0x18 returned -19 after XX usecs
calling  acpi_pci_slot_init+0x0/0x20 @ 1
initcall acpi_pci_slot_init+0x0/0x20 returned 0 after XX usecs
calling  acpi_processor_init+0x0/0xcd @ 1
initcall acpi_processor_init+0x0/0xcd returned 0 after XX usecs
calling  acpi_container_init+0x0/0x4a @ 1
initcall acpi_container_init+0x0/0x4a returned -19 after XX usecs
calling  acpi_thermal_init+0x0/0x42 @ 1
initcall acpi_thermal_init+0x0/0x42 returned -19 after XX usecs
calling  xenbus_probe_initcall+0x0/0x3b @ 1
initcall xenbus_probe_initcall+0x0/0x3b returned 0 after XX usecs
calling  xen_tmem_init+0x0/0x5c @ 1
initcall xen_tmem_init+0x0/0x5c returned 0 after XX usecs
calling  evtchn_init+0x0/0x6e @ 1
Event-channel device installed.
initcall evtchn_init+0x0/0x6e returned 0 after XX usecs
calling  xenfs_init+0x0/0x2d @ 1
initcall xenfs_init+0x0/0x2d returned 0 after XX usecs
calling  hypervisor_subsys_init+0x0/0x25 @ 1
initcall hypervisor_subsys_init+0x0/0x25 returned 0 after XX usecs
calling  hyper_sysfs_init+0x0/0xbf @ 1
initcall hyper_sysfs_init+0x0/0xbf returned 0 after XX usecs
calling  pty_init+0x0/0x26a @ 1
initcall pty_init+0x0/0x26a returned 0 after XX usecs
calling  sysrq_init+0x0/0x68 @ 1
initcall sysrq_init+0x0/0x68 returned 0 after XX usecs
calling  xen_hvc_init+0x0/0x144 @ 1
initcall xen_hvc_init+0x0/0x144 returned 0 after XX usecs
calling  serial8250_init+0x0/0x18e @ 1
Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
initcall serial8250_init+0x0/0x18e returned 0 after XX usecs
calling  serial8250_pnp_init+0x0/0x12 @ 1
initcall serial8250_pnp_init+0x0/0x12 returned 0 after XX usecs
calling  serial8250_pci_init+0x0/0x1b @ 1
initcall serial8250_pci_init+0x0/0x1b returned 0 after XX usecs
calling  rand_initialize+0x0/0x2c @ 1
initcall rand_initialize+0x0/0x2c returned 0 after XX usecs
calling  hpet_init+0x0/0x6a @ 1
initcall hpet_init+0x0/0x6a returned -19 after XX usecs
calling  topology_sysfs_init+0x0/0x50 @ 1
initcall topology_sysfs_init+0x0/0x50 returned 0 after XX usecs
calling  loop_init+0x0/0x231 @ 1
loop: module loaded
initcall loop_init+0x0/0x231 returned 0 after XX usecs
calling  init_cryptoloop+0x0/0x2f @ 1
initcall init_cryptoloop+0x0/0x2f returned 0 after XX usecs
calling  xlblk_init+0x0/0x81 @ 1
blkfront: xvda1: flush diskcache: enabled
initcall xlblk_init+0x0/0x81 returned 0 after XX usecs
calling  xen_blkif_init+0x0/0x276 @ 1
initcall xen_blkif_init+0x0/0x276 returned 0 after XX usecs
calling  init_sd+0x0/0x112 @ 1
blkfront: xvda2: flush diskcache: enabled
initcall init_sd+0x0/0x112 returned 0 after XX usecs
calling  init_sr+0x0/0x46 @ 1
initcall init_sr+0x0/0x46 returned 0 after XX usecs
calling  init_sg+0x0/0xc7 @ 1
initcall init_sg+0x0/0xc7 returned 0 after XX usecs
calling  ahci_init+0x0/0x1b @ 1
initcall ahci_init+0x0/0x1b returned 0 after XX usecs
calling  piix_init+0x0/0x29 @ 1
initcall piix_init+0x0/0x29 returned 0 after XX usecs
calling  mv_init+0x0/0x45 @ 1
initcall mv_init+0x0/0x45 returned 0 after XX usecs
calling  nv_init+0x0/0x1b @ 1
initcall nv_init+0x0/0x1b returned 0 after XX usecs
calling  svia_init+0x0/0x1b @ 1
initcall svia_init+0x0/0x1b returned 0 after XX usecs
calling  amd_init+0x0/0x1b @ 1
initcall amd_init+0x0/0x1b returned 0 after XX usecs
calling  pdc2027x_init+0x0/0x1b @ 1
initcall pdc2027x_init+0x0/0x1b returned 0 after XX usecs
calling  sil680_init+0x0/0x1b @ 1
initcall sil680_init+0x0/0x1b returned 0 after XX usecs
calling  via_init+0x0/0x1b @ 1
initcall via_init+0x0/0x1b returned 0 after XX usecs
calling  e1000_init_module+0x0/0x87 @ 1
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
initcall e1000_init_module+0x0/0x87 returned 0 after XX usecs
calling  e1000_init_module+0x0/0x3e @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
initcall e1000_init_module+0x0/0x3e returned 0 after XX usecs
calling  e100_init_module+0x0/0x5d @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5d returned 0 after XX usecs
calling  net_olddevs_init+0x0/0x9e @ 1
initcall net_olddevs_init+0x0/0x9e returned 0 after XX usecs
calling  ppp_init+0x0/0xe4 @ 1
PPP generic driver version 2.4.2
initcall ppp_init+0x0/0xe4 returned 0 after XX usecs
calling  ppp_async_init+0x0/0x36 @ 1
initcall ppp_async_init+0x0/0x36 returned 0 after XX usecs
calling  ppp_sync_init+0x0/0x36 @ 1
initcall ppp_sync_init+0x0/0x36 returned 0 after XX usecs
calling  deflate_init+0x0/0x3b @ 1
PPP Deflate Compression module registered
initcall deflate_init+0x0/0x3b returned 0 after XX usecs
calling  bsdcomp_init+0x0/0x2f @ 1
PPP BSD Compression module registered
initcall bsdcomp_init+0x0/0x2f returned 0 after XX usecs
calling  pppox_init+0x0/0x12 @ 1
NET: Registered protocol family 24
initcall pppox_init+0x0/0x12 returned 0 after XX usecs
calling  pppoe_init+0x0/0x87 @ 1
initcall pppoe_init+0x0/0x87 returned 0 after XX usecs
calling  netif_init+0x0/0x66 @ 1
Initialising Xen virtual ethernet driver.
initcall netif_init+0x0/0x66 returned 0 after XX usecs
calling  netback_init+0x0/0x219 @ 1
initcall netback_init+0x0/0x219 returned 0 after XX usecs
calling  dummy_init_module+0x0/0xaa @ 1
initcall dummy_init_module+0x0/0xaa returned 0 after XX usecs
calling  ifb_init_module+0x0/0xad @ 1
initcall ifb_init_module+0x0/0xad returned 0 after XX usecs
calling  cp_init+0x0/0x1b @ 1
initcall cp_init+0x0/0x1b returned 0 after XX usecs
calling  rtl8139_init_module+0x0/0x1b @ 1
initcall rtl8139_init_module+0x0/0x1b returned 0 after XX usecs
calling  tun_init+0x0/0x93 @ 1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0x93 returned 0 after XX usecs
calling  rtl8169_init_module+0x0/0x1b @ 1
initcall rtl8169_init_module+0x0/0x1b returned 0 after XX usecs
calling  cdc_init+0x0/0x1b @ 1
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x1b returned 0 after XX usecs
calling  cdc_subset_init+0x0/0x1b @ 1
usbcore: registered new interface driver cdc_subset
initcall cdc_subset_init+0x0/0x1b returned 0 after XX usecs
calling  zaurus_init+0x0/0x1b @ 1
usbcore: registered new interface driver zaurus
initcall zaurus_init+0x0/0x1b returned 0 after XX usecs
calling  usbnet_init+0x0/0x2b @ 1
initcall usbnet_init+0x0/0x2b returned 0 after XX usecs
calling  cdc_ncm_init+0x0/0x29 @ 1
cdc_ncm: 01-June-2011
usbcore: registered new interface driver cdc_ncm
initcall cdc_ncm_init+0x0/0x29 returned 0 after XX usecs
calling  de_init+0x0/0x1b @ 1
initcall de_init+0x0/0x1b returned 0 after XX usecs
calling  tulip_init+0x0/0x33 @ 1
initcall tulip_init+0x0/0x33 returned 0 after XX usecs
calling  de4x5_module_init+0x0/0x1b @ 1
initcall de4x5_module_init+0x0/0x1b returned 0 after XX usecs
calling  init_netconsole+0x0/0x23e @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x23e returned 0 after XX usecs
calling  cdrom_init+0x0/0xd @ 1
initcall cdrom_init+0x0/0xd returned 0 after XX usecs
calling  mon_init+0x0/0xfc @ 1
initcall mon_init+0x0/0xfc returned 0 after XX usecs
calling  ehci_hcd_init+0x0/0x78 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
initcall ehci_hcd_init+0x0/0x78 returned 0 after XX usecs
calling  ohci_hcd_mod_init+0x0/0x54 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
initcall ohci_hcd_mod_init+0x0/0x54 returned 0 after XX usecs
calling  uhci_hcd_init+0x0/0xc6 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
initcall uhci_hcd_init+0x0/0xc6 returned 0 after XX usecs
calling  acm_init+0x0/0xfd @ 1
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
initcall acm_init+0x0/0xfd returned 0 after XX usecs
calling  usblp_init+0x0/0x1b @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x1b returned 0 after XX usecs
calling  usb_serial_init+0x0/0x1e5 @ 1
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
initcall usb_serial_init+0x0/0x1e5 returned 0 after XX usecs
calling  pl2303_init+0x0/0x58 @ 1
USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
initcall pl2303_init+0x0/0x58 returned 0 after XX usecs
calling  i8042_init+0x0/0x3a2 @ 1
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
initcall i8042_init+0x0/0x3a2 returned -19 after XX usecs
calling  serport_init+0x0/0x34 @ 1
initcall serport_init+0x0/0x34 returned 0 after XX usecs
calling  mousedev_init+0x0/0x8e @ 1
mousedev: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x8e returned 0 after XX usecs
calling  joydev_init+0x0/0x12 @ 1
initcall joydev_init+0x0/0x12 returned 0 after XX usecs
calling  evdev_init+0x0/0x12 @ 1
initcall evdev_init+0x0/0x12 returned 0 after XX usecs
calling  atkbd_init+0x0/0x27 @ 1
initcall atkbd_init+0x0/0x27 returned 0 after XX usecs
calling  cmos_init+0x0/0x6a @ 1
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of rtc_cmos failed with error -38
initcall cmos_init+0x0/0x6a returned -19 after XX usecs
calling  i2c_dev_init+0x0/0xca @ 1
i2c /dev entries driver
initcall i2c_dev_init+0x0/0xca returned 0 after XX usecs
calling  i2c_piix4_init+0x0/0x1b @ 1
initcall i2c_piix4_init+0x0/0x1b returned 0 after XX usecs
calling  sm_it87_init+0x0/0x3f5 @ 1
initcall sm_it87_init+0x0/0x3f5 returned -19 after XX usecs
calling  k8temp_init+0x0/0x1b @ 1
initcall k8temp_init+0x0/0x1b returned 0 after XX usecs
calling  sm_vt8231_init+0x0/0x1b @ 1
initcall sm_vt8231_init+0x0/0x1b returned 0 after XX usecs
calling  raid_init+0x0/0x12 @ 1
md: raid1 personality registered for level 1
initcall raid_init+0x0/0x12 returned 0 after XX usecs
calling  raid5_init+0x0/0x2c @ 1
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
initcall raid5_init+0x0/0x2c returned 0 after XX usecs
calling  dm_init+0x0/0x46 @ 1
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x46 returned 0 after XX usecs
calling  dm_crypt_init+0x0/0x69 @ 1
initcall dm_crypt_init+0x0/0x69 returned 0 after XX usecs
calling  dm_snapshot_init+0x0/0x205 @ 1
initcall dm_snapshot_init+0x0/0x205 returned 0 after XX usecs
calling  dm_mirror_init+0x0/0x79 @ 1
initcall dm_mirror_init+0x0/0x79 returned 0 after XX usecs
calling  dm_dirty_log_init+0x0/0x59 @ 1
initcall dm_dirty_log_init+0x0/0x59 returned 0 after XX usecs
calling  cpufreq_stats_init+0x0/0x9d @ 1
initcall cpufreq_stats_init+0x0/0x9d returned 0 after XX usecs
calling  cpufreq_gov_dbs_init+0x0/0x5e @ 1
initcall cpufreq_gov_dbs_init+0x0/0x5e returned 0 after XX usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after XX usecs
calling  init_menu+0x0/0x12 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x12 returned 0 after XX usecs
calling  hid_init+0x0/0x4d @ 1
initcall hid_init+0x0/0x4d returned 0 after XX usecs
calling  a4_init+0x0/0x1b @ 1
initcall a4_init+0x0/0x1b returned 0 after XX usecs
calling  apple_init+0x0/0x38 @ 1
initcall apple_init+0x0/0x38 returned 0 after XX usecs
calling  belkin_init+0x0/0x1b @ 1
initcall belkin_init+0x0/0x1b returned 0 after XX usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after XX usecs
calling  ch_init+0x0/0x1b @ 1
initcall ch_init+0x0/0x1b returned 0 after XX usecs
calling  cp_init+0x0/0x1b @ 1
initcall cp_init+0x0/0x1b returned 0 after XX usecs
calling  dr_init+0x0/0x1b @ 1
initcall dr_init+0x0/0x1b returned 0 after XX usecs
calling  ez_init+0x0/0x1b @ 1
initcall ez_init+0x0/0x1b returned 0 after XX usecs
calling  gyration_init+0x0/0x1b @ 1
initcall gyration_init+0x0/0x1b returned 0 after XX usecs
calling  ks_init+0x0/0x1b @ 1
initcall ks_init+0x0/0x1b returned 0 after XX usecs
calling  kye_init+0x0/0x1b @ 1
initcall kye_init+0x0/0x1b returned 0 after XX usecs
calling  lg_init+0x0/0x1b @ 1
initcall lg_init+0x0/0x1b returned 0 after XX usecs
calling  ms_init+0x0/0x1b @ 1
initcall ms_init+0x0/0x1b returned 0 after XX usecs
calling  mr_init+0x0/0x1b @ 1
initcall mr_init+0x0/0x1b returned 0 after XX usecs
calling  ntrig_init+0x0/0x1b @ 1
initcall ntrig_init+0x0/0x1b returned 0 after XX usecs
calling  ortek_init+0x0/0x1b @ 1
initcall ortek_init+0x0/0x1b returned 0 after XX usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after XX usecs
calling  pl_init+0x0/0x1b @ 1
initcall pl_init+0x0/0x1b returned 0 after XX usecs
calling  samsung_init+0x0/0x1b @ 1
initcall samsung_init+0x0/0x1b returned 0 after XX usecs
calling  sjoy_init+0x0/0x1b @ 1
initcall sjoy_init+0x0/0x1b returned 0 after XX usecs
calling  sony_init+0x0/0x1b @ 1
initcall sony_init+0x0/0x1b returned 0 after XX usecs
calling  sp_init+0x0/0x1b @ 1
initcall sp_init+0x0/0x1b returned 0 after XX usecs
calling  ga_init+0x0/0x1b @ 1
initcall ga_init+0x0/0x1b returned 0 after XX usecs
calling  tm_init+0x0/0x1b @ 1
initcall tm_init+0x0/0x1b returned 0 after XX usecs
calling  ts_init+0x0/0x1b @ 1
initcall ts_init+0x0/0x1b returned 0 after XX usecs
calling  twinhan_init+0x0/0x1b @ 1
initcall twinhan_init+0x0/0x1b returned 0 after XX usecs
calling  zp_init+0x0/0x1b @ 1
initcall zp_init+0x0/0x1b returned 0 after XX usecs
calling  hid_init+0x0/0x79 @ 1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
initcall hid_init+0x0/0x79 returned 0 after XX usecs
calling  staging_init+0x0/0x8 @ 1
initcall staging_init+0x0/0x8 returned 0 after XX usecs
calling  alsa_hwdep_init+0x0/0x64 @ 1
initcall alsa_hwdep_init+0x0/0x64 returned 0 after XX usecs
calling  alsa_timer_init+0x0/0x146 @ 1
initcall alsa_timer_init+0x0/0x146 returned 0 after XX usecs
calling  alsa_pcm_init+0x0/0x6c @ 1
initcall alsa_pcm_init+0x0/0x6c returned 0 after XX usecs
calling  snd_mem_init+0x0/0x2c @ 1
initcall snd_mem_init+0x0/0x2c returned 0 after XX usecs
calling  patch_realtek_init+0x0/0x12 @ 1
initcall patch_realtek_init+0x0/0x12 returned 0 after XX usecs
calling  patch_cmedia_init+0x0/0x12 @ 1
initcall patch_cmedia_init+0x0/0x12 returned 0 after XX usecs
calling  patch_analog_init+0x0/0x12 @ 1
initcall patch_analog_init+0x0/0x12 returned 0 after XX usecs
calling  patch_sigmatel_init+0x0/0x12 @ 1
initcall patch_sigmatel_init+0x0/0x12 returned 0 after XX usecs
calling  patch_si3054_init+0x0/0x12 @ 1
initcall patch_si3054_init+0x0/0x12 returned 0 after XX usecs
calling  patch_cirrus_init+0x0/0x12 @ 1
initcall patch_cirrus_init+0x0/0x12 returned 0 after XX usecs
calling  patch_ca0110_init+0x0/0x12 @ 1
initcall patch_ca0110_init+0x0/0x12 returned 0 after XX usecs
calling  patch_conexant_init+0x0/0x12 @ 1
initcall patch_conexant_init+0x0/0x12 returned 0 after XX usecs
calling  patch_via_init+0x0/0x12 @ 1
initcall patch_via_init+0x0/0x12 returned 0 after XX usecs
calling  patch_hdmi_init+0x0/0x12 @ 1
initcall patch_hdmi_init+0x0/0x12 returned 0 after XX usecs
calling  alsa_card_azx_init+0x0/0x1b @ 1
initcall alsa_card_azx_init+0x0/0x1b returned 0 after XX usecs
calling  alsa_sound_last_init+0x0/0x6f @ 1
ALSA device list:
  No soundcards found.
initcall alsa_sound_last_init+0x0/0x6f returned 0 after XX usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after XX usecs
calling  snap_init+0x0/0x39 @ 1
initcall snap_init+0x0/0x39 returned 0 after XX usecs
calling  blackhole_module_init+0x0/0x12 @ 1
initcall blackhole_module_init+0x0/0x12 returned 0 after XX usecs
calling  police_init_module+0x0/0x12 @ 1
initcall police_init_module+0x0/0x12 returned 0 after XX usecs
calling  cbq_module_init+0x0/0x12 @ 1
initcall cbq_module_init+0x0/0x12 returned 0 after XX usecs
calling  htb_module_init+0x0/0x12 @ 1
initcall htb_module_init+0x0/0x12 returned 0 after XX usecs
calling  red_module_init+0x0/0x12 @ 1
initcall red_module_init+0x0/0x12 returned 0 after XX usecs
calling  gred_module_init+0x0/0x12 @ 1
initcall gred_module_init+0x0/0x12 returned 0 after XX usecs
calling  ingress_module_init+0x0/0x12 @ 1
initcall ingress_module_init+0x0/0x12 returned 0 after XX usecs
calling  dsmark_module_init+0x0/0x12 @ 1
initcall dsmark_module_init+0x0/0x12 returned 0 after XX usecs
calling  sfb_module_init+0x0/0x12 @ 1
initcall sfb_module_init+0x0/0x12 returned 0 after XX usecs
calling  sfq_module_init+0x0/0x12 @ 1
initcall sfq_module_init+0x0/0x12 returned 0 after XX usecs
calling  tbf_module_init+0x0/0x12 @ 1
initcall tbf_module_init+0x0/0x12 returned 0 after XX usecs
calling  teql_init+0x0/0xf1 @ 1
initcall teql_init+0x0/0xf1 returned 0 after XX usecs
calling  prio_module_init+0x0/0x12 @ 1
initcall prio_module_init+0x0/0x12 returned 0 after XX usecs
calling  mqprio_module_init+0x0/0x12 @ 1
initcall mqprio_module_init+0x0/0x12 returned 0 after XX usecs
calling  choke_module_init+0x0/0x12 @ 1
initcall choke_module_init+0x0/0x12 returned 0 after XX usecs
calling  init_u32+0x0/0x2e @ 1
u32 classifier
    Actions configured
initcall init_u32+0x0/0x2e returned 0 after XX usecs
calling  init_route4+0x0/0x12 @ 1
initcall init_route4+0x0/0x12 returned 0 after XX usecs
calling  init_fw+0x0/0x12 @ 1
initcall init_fw+0x0/0x12 returned 0 after XX usecs
calling  init_rsvp+0x0/0x12 @ 1
initcall init_rsvp+0x0/0x12 returned 0 after XX usecs
calling  init_tcindex+0x0/0x12 @ 1
initcall init_tcindex+0x0/0x12 returned 0 after XX usecs
calling  init_rsvp+0x0/0x12 @ 1
initcall init_rsvp+0x0/0x12 returned 0 after XX usecs
calling  init_basic+0x0/0x12 @ 1
initcall init_basic+0x0/0x12 returned 0 after XX usecs
calling  init_cgroup_cls+0x0/0x3c @ 1
initcall init_cgroup_cls+0x0/0x3c returned 0 after XX usecs
calling  nfnetlink_init+0x0/0x27 @ 1
Netfilter messages via NETLINK v0.30.
initcall nfnetlink_init+0x0/0x27 returned 0 after XX usecs
calling  nfnetlink_queue_init+0x0/0xa4 @ 1
initcall nfnetlink_queue_init+0x0/0xa4 returned 0 after XX usecs
calling  nfnetlink_log_init+0x0/0xd7 @ 1
initcall nfnetlink_log_init+0x0/0xd7 returned 0 after XX usecs
calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
nf_conntrack version 0.5.0 (1370 buckets, 5480 max)
initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after XX usecs
calling  ctnetlink_init+0x0/0x76 @ 1
ctnetlink v0.93: registering with nfnetlink.
initcall ctnetlink_init+0x0/0x76 returned 0 after XX usecs
calling  nf_conntrack_ftp_init+0x0/0x1a4 @ 1
initcall nf_conntrack_ftp_init+0x0/0x1a4 returned 0 after XX usecs
calling  nf_conntrack_h323_init+0x0/0xd4 @ 1
initcall nf_conntrack_h323_init+0x0/0xd4 returned 0 after XX usecs
calling  nf_conntrack_irc_init+0x0/0x181 @ 1
initcall nf_conntrack_irc_init+0x0/0x181 returned 0 after XX usecs
calling  nf_conntrack_sip_init+0x0/0x1ca @ 1
initcall nf_conntrack_sip_init+0x0/0x1ca returned 0 after XX usecs
calling  xt_init+0x0/0x117 @ 1
initcall xt_init+0x0/0x117 returned 0 after XX usecs
calling  tcpudp_mt_init+0x0/0x17 @ 1
initcall tcpudp_mt_init+0x0/0x17 returned 0 after XX usecs
calling  mark_mt_init+0x0/0x40 @ 1
initcall mark_mt_init+0x0/0x40 returned 0 after XX usecs
calling  connmark_mt_init+0x0/0x40 @ 1
initcall connmark_mt_init+0x0/0x40 returned 0 after XX usecs
calling  classify_tg_init+0x0/0x17 @ 1
initcall classify_tg_init+0x0/0x17 returned 0 after XX usecs
calling  dscp_tg_init+0x0/0x17 @ 1
initcall dscp_tg_init+0x0/0x17 returned 0 after XX usecs
calling  hl_tg_init+0x0/0x17 @ 1
initcall hl_tg_init+0x0/0x17 returned 0 after XX usecs
calling  nflog_tg_init+0x0/0x12 @ 1
initcall nflog_tg_init+0x0/0x12 returned 0 after XX usecs
calling  nfqueue_tg_init+0x0/0x17 @ 1
initcall nfqueue_tg_init+0x0/0x17 returned 0 after XX usecs
calling  tcpmss_tg_init+0x0/0x17 @ 1
initcall tcpmss_tg_init+0x0/0x17 returned 0 after XX usecs
calling  comment_mt_init+0x0/0x12 @ 1
initcall comment_mt_init+0x0/0x12 returned 0 after XX usecs
calling  connbytes_mt_init+0x0/0x12 @ 1
initcall connbytes_mt_init+0x0/0x12 returned 0 after XX usecs
calling  connlimit_mt_init+0x0/0x17 @ 1
initcall connlimit_mt_init+0x0/0x17 returned 0 after XX usecs
calling  conntrack_mt_init+0x0/0x17 @ 1
initcall conntrack_mt_init+0x0/0x17 returned 0 after XX usecs
calling  dscp_mt_init+0x0/0x17 @ 1
initcall dscp_mt_init+0x0/0x17 returned 0 after XX usecs
calling  hashlimit_mt_init+0x0/0x8c @ 1
initcall hashlimit_mt_init+0x0/0x8c returned 0 after XX usecs
calling  helper_mt_init+0x0/0x12 @ 1
initcall helper_mt_init+0x0/0x12 returned 0 after XX usecs
calling  hl_mt_init+0x0/0x17 @ 1
initcall hl_mt_init+0x0/0x17 returned 0 after XX usecs
calling  length_mt_init+0x0/0x17 @ 1
initcall length_mt_init+0x0/0x17 returned 0 after XX usecs
calling  limit_mt_init+0x0/0x12 @ 1
initcall limit_mt_init+0x0/0x12 returned 0 after XX usecs
calling  mac_mt_init+0x0/0x12 @ 1
initcall mac_mt_init+0x0/0x12 returned 0 after XX usecs
calling  multiport_mt_init+0x0/0x17 @ 1
initcall multiport_mt_init+0x0/0x17 returned 0 after XX usecs
calling  xt_osf_init+0x0/0x8d @ 1
initcall xt_osf_init+0x0/0x8d returned 0 after XX usecs
calling  owner_mt_init+0x0/0x12 @ 1
initcall owner_mt_init+0x0/0x12 returned 0 after XX usecs
calling  pkttype_mt_init+0x0/0x12 @ 1
initcall pkttype_mt_init+0x0/0x12 returned 0 after XX usecs
calling  quota_mt_init+0x0/0x12 @ 1
initcall quota_mt_init+0x0/0x12 returned 0 after XX usecs
calling  realm_mt_init+0x0/0x12 @ 1
initcall realm_mt_init+0x0/0x12 returned 0 after XX usecs
calling  recent_mt_init+0x0/0x7a @ 1
initcall recent_mt_init+0x0/0x7a returned 0 after XX usecs
calling  state_mt_init+0x0/0x12 @ 1
initcall state_mt_init+0x0/0x12 returned 0 after XX usecs
calling  statistic_mt_init+0x0/0x12 @ 1
initcall statistic_mt_init+0x0/0x12 returned 0 after XX usecs
calling  string_mt_init+0x0/0x12 @ 1
initcall string_mt_init+0x0/0x12 returned 0 after XX usecs
calling  tcpmss_mt_init+0x0/0x17 @ 1
initcall tcpmss_mt_init+0x0/0x17 returned 0 after XX usecs
calling  u32_mt_init+0x0/0x12 @ 1
initcall u32_mt_init+0x0/0x12 returned 0 after XX usecs
calling  sysctl_ipv4_init+0x0/0x87 @ 1
initcall sysctl_ipv4_init+0x0/0x87 returned 0 after XX usecs
calling  ipip_init+0x0/0x60 @ 1
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x60 returned 0 after XX usecs
calling  init_syncookies+0x0/0x19 @ 1
initcall init_syncookies+0x0/0x19 returned 0 after XX usecs
calling  tunnel4_init+0x0/0x66 @ 1
initcall tunnel4_init+0x0/0x66 returned 0 after XX usecs
calling  ipv4_netfilter_init+0x0/0x12 @ 1
initcall ipv4_netfilter_init+0x0/0x12 returned 0 after XX usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x14b @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x14b returned 0 after XX usecs
calling  nf_nat_init+0x0/0x111 @ 1
initcall nf_nat_init+0x0/0x111 returned 0 after XX usecs
calling  nf_defrag_init+0x0/0x17 @ 1
initcall nf_defrag_init+0x0/0x17 returned 0 after XX usecs
calling  nf_nat_ftp_init+0x0/0x1f @ 1
initcall nf_nat_ftp_init+0x0/0x1f returned 0 after XX usecs
calling  init+0x0/0xd7 @ 1
initcall init+0x0/0xd7 returned 0 after XX usecs
calling  nf_nat_irc_init+0x0/0x1f @ 1
initcall nf_nat_irc_init+0x0/0x1f returned 0 after XX usecs
calling  nf_nat_sip_init+0x0/0xa9 @ 1
initcall nf_nat_sip_init+0x0/0xa9 returned 0 after XX usecs
calling  ip_tables_init+0x0/0xaa @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xaa returned 0 after XX usecs
calling  iptable_filter_init+0x0/0x6f @ 1
initcall iptable_filter_init+0x0/0x6f returned 0 after XX usecs
calling  iptable_mangle_init+0x0/0x51 @ 1
initcall iptable_mangle_init+0x0/0x51 returned 0 after XX usecs
calling  nf_nat_standalone_init+0x0/0x59 @ 1
initcall nf_nat_standalone_init+0x0/0x59 returned 0 after XX usecs
calling  ecn_mt_init+0x0/0x12 @ 1
initcall ecn_mt_init+0x0/0x12 returned 0 after XX usecs
calling  ecn_tg_init+0x0/0x12 @ 1
initcall ecn_tg_init+0x0/0x12 returned 0 after XX usecs
calling  log_tg_init+0x0/0x29 @ 1
initcall log_tg_init+0x0/0x29 returned 0 after XX usecs
calling  masquerade_tg_init+0x0/0x39 @ 1
initcall masquerade_tg_init+0x0/0x39 returned 0 after XX usecs
calling  netmap_tg_init+0x0/0x12 @ 1
initcall netmap_tg_init+0x0/0x12 returned 0 after XX usecs
calling  redirect_tg_init+0x0/0x12 @ 1
initcall redirect_tg_init+0x0/0x12 returned 0 after XX usecs
calling  reject_tg_init+0x0/0x12 @ 1
initcall reject_tg_init+0x0/0x12 returned 0 after XX usecs
calling  ip_queue_init+0x0/0x13a @ 1
initcall ip_queue_init+0x0/0x13a returned 0 after XX usecs
calling  inet_diag_init+0x0/0x72 @ 1
initcall inet_diag_init+0x0/0x72 returned 0 after XX usecs
calling  tcp_diag_init+0x0/0x12 @ 1
initcall tcp_diag_init+0x0/0x12 returned 0 after XX usecs
calling  bictcp_register+0x0/0x12 @ 1
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after XX usecs
calling  cubictcp_register+0x0/0x6c @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x6c returned 0 after XX usecs
calling  tcp_westwood_register+0x0/0x12 @ 1
TCP westwood registered
initcall tcp_westwood_register+0x0/0x12 returned 0 after XX usecs
calling  hybla_register+0x0/0x12 @ 1
TCP hybla registered
initcall hybla_register+0x0/0x12 returned 0 after XX usecs
calling  tcp_vegas_register+0x0/0x14 @ 1
TCP vegas registered
initcall tcp_vegas_register+0x0/0x14 returned 0 after XX usecs
calling  inet6_init+0x0/0x2ba @ 1
NET: Registered protocol family 10
initcall inet6_init+0x0/0x2ba returned 0 after XX usecs
calling  tunnel6_init+0x0/0x66 @ 1
initcall tunnel6_init+0x0/0x66 returned 0 after XX usecs
calling  ip6_tables_init+0x0/0xaa @ 1
ip6_tables: (C) 2000-2006 Netfilter Core Team
initcall ip6_tables_init+0x0/0xaa returned 0 after XX usecs
calling  ip6table_filter_init+0x0/0x6f @ 1
initcall ip6table_filter_init+0x0/0x6f returned 0 after XX usecs
calling  ip6table_mangle_init+0x0/0x51 @ 1
initcall ip6table_mangle_init+0x0/0x51 returned 0 after XX usecs
calling  nf_conntrack_l3proto_ipv6_init+0x0/0xfc @ 1
initcall nf_conntrack_l3proto_ipv6_init+0x0/0xfc returned 0 after XX usecs
calling  nf_defrag_init+0x0/0x54 @ 1
initcall nf_defrag_init+0x0/0x54 returned 0 after XX usecs
calling  log_tg6_init+0x0/0x29 @ 1
initcall log_tg6_init+0x0/0x29 returned 0 after XX usecs
calling  reject_tg6_init+0x0/0x12 @ 1
initcall reject_tg6_init+0x0/0x12 returned 0 after XX usecs
calling  sit_init+0x0/0x60 @ 1
IPv6 over IPv4 tunneling driver
initcall sit_init+0x0/0x60 returned 0 after XX usecs
calling  ip6_tunnel_init+0x0/0x8e @ 1
initcall ip6_tunnel_init+0x0/0x8e returned 0 after XX usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after XX usecs
calling  br_init+0x0/0xa2 @ 1
initcall br_init+0x0/0xa2 returned 0 after XX usecs
calling  init_rpcsec_gss+0x0/0x4d @ 1
initcall init_rpcsec_gss+0x0/0x4d returned 0 after XX usecs
calling  vlan_proto_init+0x0/0x82 @ 1
802.1Q VLAN Support v1.8
initcall vlan_proto_init+0x0/0x82 returned 0 after XX usecs
calling  init_dns_resolver+0x0/0x108 @ 1
Registering the dns_resolver key type
initcall init_dns_resolver+0x0/0x108 returned 0 after XX usecs
calling  mcheck_debugfs_init+0x0/0x3b @ 1
initcall mcheck_debugfs_init+0x0/0x3b returned 0 after XX usecs
calling  severities_debugfs_init+0x0/0x3b @ 1
initcall severities_debugfs_init+0x0/0x3b returned 0 after XX usecs
calling  hpet_insert_resource+0x0/0x23 @ 1
initcall hpet_insert_resource+0x0/0x23 returned 1 after XX usecs
initcall hpet_insert_resource+0x0/0x23 returned with error code 1 
calling  lapic_insert_resource+0x0/0x3f @ 1
initcall lapic_insert_resource+0x0/0x3f returned -1 after XX usecs
initcall lapic_insert_resource+0x0/0x3f returned with error code -1 
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after XX usecs
calling  check_early_ioremap_leak+0x0/0x50 @ 1
initcall check_early_ioremap_leak+0x0/0x50 returned 0 after XX usecs
calling  pat_memtype_list_init+0x0/0x32 @ 1
initcall pat_memtype_list_init+0x0/0x32 returned 0 after XX usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after XX usecs
calling  init_oops_id+0x0/0x31 @ 1
initcall init_oops_id+0x0/0x31 returned 0 after XX usecs
calling  printk_late_init+0x0/0x50 @ 1
initcall printk_late_init+0x0/0x50 returned 0 after XX usecs
calling  pm_qos_power_init+0x0/0xca @ 1
initcall pm_qos_power_init+0x0/0xca returned 0 after XX usecs
calling  alarmtimer_init_late+0x0/0x73 @ 1
No RTC device found, ALARM timers will not wake from suspend
initcall alarmtimer_init_late+0x0/0x73 returned 0 after XX usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after XX usecs
calling  max_swapfiles_check+0x0/0x8 @ 1
initcall max_swapfiles_check+0x0/0x8 returned 0 after XX usecs
calling  set_recommended_min_free_kbytes+0x0/0x82 @ 1
initcall set_recommended_min_free_kbytes+0x0/0x82 returned 0 after XX usecs
calling  random32_reseed+0x0/0xb3 @ 1
initcall random32_reseed+0x0/0xb3 returned 0 after XX usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after XX usecs
calling  pci_sysfs_init+0x0/0x51 @ 1
initcall pci_sysfs_init+0x0/0x51 returned 0 after XX usecs
calling  boot_wait_for_devices+0x0/0x30 @ 1
XENBUS: Device with no driver: device/console/0
initcall boot_wait_for_devices+0x0/0x30 returned 0 after XX usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after XX usecs
calling  scsi_complete_async_scans+0x0/0x11b @ 1
initcall scsi_complete_async_scans+0x0/0x11b returned 0 after XX usecs
calling  rtc_hctosys+0x0/0x10d @ 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
initcall rtc_hctosys+0x0/0x10d returned -19 after XX usecs
calling  powernowk8_init+0x0/0x1bf @ 1
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
[Firmware Bug]: powernow-k8: No PSB or ACPI _PSS objects
powernow-k8: Make sure that your BIOS is up to date and Cool'N'Quiet support is enabled in BIOS setup
initcall powernowk8_init+0x0/0x1bf returned -19 after XX usecs
calling  acpi_cpufreq_init+0x0/0xc1 @ 1
initcall acpi_cpufreq_init+0x0/0xc1 returned 0 after XX usecs
calling  memmap_init+0x0/0x34 @ 1
initcall memmap_init+0x0/0x34 returned 0 after XX usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x5e @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x5e returned 1 after XX usecs
initcall pci_mmcfg_late_insert_resources+0x0/0x5e returned with error code 1 
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after XX usecs
calling  ip_auto_config+0x0/0xd7b @ 1
IP-Config: Complete:
     device=eth0, addr=192.168.12.1, mask=255.255.255.0, gw=192.168.12.2,
     host=yumi, domain=, nis-domain=uguu.de,
     bootserver=127.0.255.255, rootserver=127.0.255.255, rootpath=
initcall ip_auto_config+0x0/0xd7b returned 0 after XX usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after XX usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
async_waiting @ 1
async_continuing @ 1 after 0 usec
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs (xvda1): error: couldn't mount because of unsupported optional features (240)
EXT2-fs (xvda1): error: couldn't mount because of unsupported optional features (240)
EXT4-fs (xvda1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 202:1.

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
