Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1GUSo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:44:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41300 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1GUSo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:44:56 -0400
Date: Fri, 22 Jul 2011 00:14:54 +0530
From: Rabin Vincent <rabin@rab.in>
To: cl@linux.com, penberg@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: "slub: Rework allocator fastpaths" and slub debugging
Message-ID: <20110721184436.GA7474@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling slub debugging on linux-next throws up continuous apparently
spurious "Redzone overwritten" reports, right from startup.  The start
of a boot log is below (the rest of the log has more such reports).

Bisecting points to the following commit:

commit 2cfb7455d223ab24b23df44be430faf92e12390f
Author: Christoph Lameter <cl@linux.com>
Date:   Wed Jun 1 12:25:52 2011 -0500

    slub: Rework allocator fastpaths
    
    Rework the allocation paths so that updates of the page freelist, frozen
    state and number of objects use cmpxchg_double_slab().
    
    Signed-off-by: Christoph Lameter <cl@linux.com>
    Signed-off-by: Pekka Enberg <penberg@kernel.org>

Thanks.

Uncompressing Linux... done, booting the kernel.
[    0.000000] Linux version 3.0.0-rc7-next-20110721 (rabin@debian) (gcc version 4.6.0 (crosstool-NG-hg_default@2404_8988576c491a) ) #288 PREEMPT Fri Jul 22 00:07:05 IST 2011
[    0.000000] CPU: ARMv7 Processor [410fc090] revision 0 (ARMv7), cr=10c53c7f
[    0.000000] CPU: VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: ARM-RealView PBX
[    0.000000] Ignoring unrecognised tag 0x00000000
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 32768
[    0.000000]   DMA zone: 256 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 32512 pages, LIFO batch:7
[    0.000000] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: earlyprintk console=ttyAMA0 mem=128M debug  slub_debug
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 128208k/128208k available, 2864k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
[    0.000000]     vmalloc : 0xc8800000 - 0xf8000000   ( 760 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0167000   (1404 kB)
[    0.000000]       .init : 0xc0167000 - 0xc017b000   (  80 kB)
[    0.000000]       .data : 0xc017c000 - 0xc018e5a0   (  74 kB)
[    0.000000]        .bss : 0xc018e5c4 - 0xc01981fc   (  40 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:128
[    0.000000] Console: colour dummy device 80x30
[    0.025412] Calibrating delay loop... 430.08 BogoMIPS (lpj=2150400)
[    0.213437] pid_max: default: 32768 minimum: 301
[    0.214891] Mount-cache hash table entries: 512
[    0.221089] CPU: Testing write buffer coherency: ok
[    0.230143] =============================================================================
[    0.230365] BUG idr_layer_cache: Redzone overwritten
[    0.230478] -----------------------------------------------------------------------------
[    0.230501] 
[    0.230700] INFO: 0xc7820c94-0xc7820c97. First byte 0xbb instead of 0xcc
[    0.230974] INFO: Slab 0xc0289400 objects=21 used=21 fp=0x  (null) flags=0x0080
[    0.231145] INFO: Object 0xc7820c00 @offset=3072 fp=0xc7820cc0
[    0.231162] 
[    0.231370] Bytes b4 0xc7820bf0:  00 00 00 00 00 00 00 00 00 00 00 00 5a 5a 5a 5a ............ZZZZ
[    0.231722]   Object 0xc7820c00:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.232012]   Object 0xc7820c10:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.232301]   Object 0xc7820c20:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.232644]   Object 0xc7820c30:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.232931]   Object 0xc7820c40:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.233218]   Object 0xc7820c50:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.233571]   Object 0xc7820c60:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.233889]   Object 0xc7820c70:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.234186]   Object 0xc7820c80:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.234484]   Object 0xc7820c90:  00 00 00 00                                     ....            
[    0.234802]  Redzone 0xc7820c94:  bb bb bb bb                                     »»»»            
[    0.235101]  Padding 0xc7820cbc:  5a 5a 5a 5a                                     ZZZZ            
[    0.235417] Backtrace: 
[    0.235979] [<c00106dc>] (dump_backtrace+0x0/0x110) from [<c012a88c>] (dump_stack+0x18/0x1c)
[    0.236222]  r6:c7820010 r5:c7820c00 r4:c7803000 r3:00000000
[    0.236429] [<c012a874>] (dump_stack+0x0/0x1c) from [<c007d790>] (print_trailer+0x1a4/0x1c0)
[    0.236633] [<c007d5ec>] (print_trailer+0x0/0x1c0) from [<c007dbb0>] (check_bytes_and_report+0xa4/0xd4)
[    0.236829]  r7:000000cc r6:c7803000 r5:c7820c94 r4:c7820c98
[    0.237007] [<c007db0c>] (check_bytes_and_report+0x0/0xd4) from [<c007dc30>] (check_object+0x50/0x2c0)
[    0.237222] [<c007dbe0>] (check_object+0x0/0x2c0) from [<c012b980>] (free_debug_processing+0x174/0x2ac)
[    0.237418]  r8:c00e43f0 r7:20000013 r6:c7803000 r5:c7820c00 r4:c0289400
[    0.237624] [<c012b80c>] (free_debug_processing+0x0/0x2ac) from [<c012baec>] (__slab_free+0x34/0x28c)
[    0.237816]  r8:c7820c00 r7:00000083 r6:c7803000 r5:80050d00 r4:c0289400
[    0.237992] r3:c00e43f0
[    0.238085] [<c012bab8>] (__slab_free+0x0/0x28c) from [<c007f648>] (kmem_cache_free+0xe8/0xf0)
[    0.238288] [<c007f560>] (kmem_cache_free+0x0/0xf0) from [<c00e43f0>] (ida_get_new_above+0x1c8/0x1e8)
[    0.238480]  r8:00000002 r7:c0196564 r6:c782a000 r5:00000000 r4:c780d240
[    0.238657] r3:c0196a3c
[    0.238751] [<c00e4228>] (ida_get_new_above+0x0/0x1e8) from [<c00caf6c>] (sysfs_new_dirent+0x7c/0x114)
[    0.238966] [<c00caef0>] (sysfs_new_dirent+0x0/0x114) from [<c00cb46c>] (create_dir+0x30/0xb4)
[    0.239167] [<c00cb43c>] (create_dir+0x0/0xb4) from [<c00cb648>] (sysfs_create_dir+0xb0/0xc8)
[    0.239362]  r8:00000000 r7:00000000 r6:c01890d0 r5:00000000 r4:c7821388
[    0.239569] [<c00cb598>] (sysfs_create_dir+0x0/0xc8) from [<c00e4bec>] (kobject_add_internal+0xf4/0x1d0)
[    0.239766]  r6:00000000 r5:c7821388 r4:c013c4d0
[    0.239916] [<c00e4af8>] (kobject_add_internal+0x0/0x1d0) from [<c00e51ac>] (kset_register+0x28/0x44)
[    0.240107]  r8:00000000 r7:00000000 r6:c7821380 r5:c7821388 r4:c013c4d0
[    0.240283] r3:c01898fc
[    0.240377] [<c00e5184>] (kset_register+0x0/0x44) from [<c00e5370>] (kset_create_and_add+0x80/0xa4)
[    0.240565]  r5:00000000 r4:c013c4d0
[    0.240723] [<c00e52f0>] (kset_create_and_add+0x0/0xa4) from [<c0175abc>] (devices_init+0x1c/0xbc)
[    0.240911]  r7:00000013 r6:c0021054 r5:c017a700 r4:c017a55c
[    0.241089] [<c0175aa0>] (devices_init+0x0/0xbc) from [<c01762cc>] (driver_init+0x10/0x2c)
[    0.241264]  r4:c017a55c r3:00000000
[    0.241381] [<c01762bc>] (driver_init+0x0/0x2c) from [<c0167ab4>] (kernel_init+0x6c/0x118)
[    0.241577] [<c0167a48>] (kernel_init+0x0/0x118) from [<c0021054>] (do_exit+0x0/0x6a8)
[    0.241745]  r5:c0167a48 r4:00000000
[    0.241914] FIX idr_layer_cache: Restoring 0xc7820c94-0xc7820c97=0xcc
[    0.241934] 
[    0.242790] =============================================================================
[    0.242989] BUG idr_layer_cache: Redzone overwritten
[    0.243099] -----------------------------------------------------------------------------
[    0.243121] 
[    0.243382] INFO: 0xc7820bd4-0xc7820bd7. First byte 0xbb instead of 0xcc
[    0.243550] INFO: Slab 0xc0289400 objects=21 used=21 fp=0x  (null) flags=0x0080
[    0.243711] INFO: Object 0xc7820b40 @offset=2880 fp=0xc7820c00
[    0.243729] 
[    0.243874] Bytes b4 0xc7820b30:  00 00 00 00 00 00 00 00 00 00 00 00 5a 5a 5a 5a ............ZZZZ
[    0.244177]   Object 0xc7820b40:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.244496]   Object 0xc7820b50:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.244796]   Object 0xc7820b60:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.245096]   Object 0xc7820b70:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.245397]   Object 0xc7820b80:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.245697]   Object 0xc7820b90:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.245998]   Object 0xc7820ba0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.246299]   Object 0xc7820bb0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.246599]   Object 0xc7820bc0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.246899]   Object 0xc7820bd0:  00 00 00 00                                     ....            
[    0.247181]  Redzone 0xc7820bd4:  bb bb bb bb                                     »»»»            
[    0.247470]  Padding 0xc7820bfc:  5a 5a 5a 5a                                     ZZZZ            
[    0.247750] Backtrace: 
[    0.247852] [<c00106dc>] (dump_backtrace+0x0/0x110) from [<c012a88c>] (dump_stack+0x18/0x1c)
[    0.248033]  r6:c7820010 r5:c7820b40 r4:c7803000 r3:00000000
[    0.248211] [<c012a874>] (dump_stack+0x0/0x1c) from [<c007d790>] (print_trailer+0x1a4/0x1c0)
[    0.248411] [<c007d5ec>] (print_trailer+0x0/0x1c0) from [<c007dbb0>] (check_bytes_and_report+0xa4/0xd4)
[    0.248607]  r7:000000cc r6:c7803000 r5:c7820bd4 r4:c7820bd8
[    0.248787] [<c007db0c>] (check_bytes_and_report+0x0/0xd4) from [<c007dc30>] (check_object+0x50/0x2c0)
[    0.249002] [<c007dbe0>] (check_object+0x0/0x2c0) from [<c012b980>] (free_debug_processing+0x174/0x2ac)
[    0.249260]  r8:c00e43f0 r7:20000013 r6:c7803000 r5:c7820b40 r4:c0289400
[    0.249469] [<c012b80c>] (free_debug_processing+0x0/0x2ac) from [<c012baec>] (__slab_free+0x34/0x28c)
[    0.249664]  r8:c7820b40 r7:00000083 r6:c7803000 r5:80050d00 r4:c0289400
[    0.249840] r3:c00e43f0
[    0.249934] [<c012bab8>] (__slab_free+0x0/0x28c) from [<c007f648>] (kmem_cache_free+0xe8/0xf0)
[    0.250139] [<c007f560>] (kmem_cache_free+0x0/0xf0) from [<c00e43f0>] (ida_get_new_above+0x1c8/0x1e8)
[    0.250331]  r8:00000002 r7:c0196564 r6:c782a000 r5:00000000 r4:c780d240
[    0.250508] r3:c0196a3c
[    0.250603] [<c00e4228>] (ida_get_new_above+0x0/0x1e8) from [<c00caf6c>] (sysfs_new_dirent+0x7c/0x114)
[    0.250816] [<c00caef0>] (sysfs_new_dirent+0x0/0x114) from [<c00cb46c>] (create_dir+0x30/0xb4)
[    0.251015] [<c00cb43c>] (create_dir+0x0/0xb4) from [<c00cb648>] (sysfs_create_dir+0xb0/0xc8)
[    0.251193]  r8:00000000 r7:00000013 r6:c01890d0 r5:00000000 r4:c7821400
[    0.251409] [<c00cb598>] (sysfs_create_dir+0x0/0xc8) from [<c00e4bec>] (kobject_add_internal+0xf4/0x1d0)
[    0.251605]  r6:00000000 r5:c7821400 r4:c7821400
[    0.251755] [<c00e4af8>] (kobject_add_internal+0x0/0x1d0) from [<c00e4da4>] (kobject_add+0x74/0x94)
[    0.251942]  r8:00000000 r7:00000013 r6:00000000 r5:00000000 r4:c7821400
[    0.252115] r3:00000000
[    0.252210] [<c00e4d30>] (kobject_add+0x0/0x94) from [<c00e5108>] (kobject_create_and_add+0x30/0x64)
[    0.252401]  r3:c015a4d0 r2:c015d711
[    0.252499]  r6:00000000 r5:c015a4d0 r4:c7821400
[    0.252650] [<c00e50d8>] (kobject_create_and_add+0x0/0x64) from [<c0175ad8>] (devices_init+0x38/0xbc)
[    0.252842]  r6:c0021054 r5:c017a700 r4:c0198174 r3:00000000
[    0.253018] [<c0175aa0>] (devices_init+0x0/0xbc) from [<c01762cc>] (driver_init+0x10/0x2c)
[    0.253191]  r4:c017a55c r3:00000000
[    0.253324] [<c01762bc>] (driver_init+0x0/0x2c) from [<c0167ab4>] (kernel_init+0x6c/0x118)
[    0.253530] [<c0167a48>] (kernel_init+0x0/0x118) from [<c0021054>] (do_exit+0x0/0x6a8)
[    0.253698]  r5:c0167a48 r4:00000000
[    0.253806] FIX idr_layer_cache: Restoring 0xc7820bd4-0xc7820bd7=0xcc
