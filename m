Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1CQCY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:24:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30211 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1CQCYM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Mar 2011 22:24:12 -0400
Date: Wed, 16 Mar 2011 22:23:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Waychison <mikew@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-watchdog@vger.kernel.org, Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH] watchdog, SP5100: Check if firmware has set correct
 value in tcobase.
Message-ID: <20110317022331.GA3528@dumpdata.com>
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop>
 <20110311222129.GA3168@dumpdata.com>
 <alpine.DEB.2.00.1103161150010.3382@kaball-desktop>
 <alpine.DEB.2.00.1103161442210.3382@kaball-desktop>
 <4D80F992.10603@kernel.org>
 <alpine.DEB.2.00.1103161757040.3382@kaball-desktop>
 <4D812180.5030102@kernel.org>
 <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com>
 <4D812919.30706@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <4D812919.30706@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D8170A9.010F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 16, 2011 at 02:18:17PM -0700, Yinghai Lu wrote:
> 
> 
> Stefano found SP5100 TCO watchdog driver using wrong address.
> 
> [    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
> [    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1
> 
> and e820 said that range is RAM.
> 
> We should check if we can use that reading out. BIOS could just program wrong address there.
> 
> -v2: Mike pointed out one path need one release.
> 
> Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by:Yinghai Lu <yinghai@kernel.org>
> Acked-by: Mike Waychison <mikew@google.com>

I have no idea why it worked the first time b/c this:


> +	if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE, "SP5100 TCO")) {

is wrong. It should have been "if (!request...")..

With that, and with Stefano's patches (stefano/2.6.38-rc6-mm-fix) on top of 2.6.39-rc0 it boots up fine.

Excerpt from the log:

[    0.000000] DEBUG find_early_table_space: _text=1000000 _end=1e33000 pgtable_start=9fc000 pgtable_end=9fc000
[    0.000000] DEBUG find_early_table_space: _text=1000000 _end=1e33000 pgtable_start=beba5000 pgtable_end=beba5000
[    9.064064] calling  sp5100_tco_init_module+0x0/0x1000 [sp5100_tco] @ 507
[    9.064067] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    9.064180] SP5100 TCO timer: mmio address 0xb8fe00 already in use
[    9.064201] initcall sp5100_tco_init_module+0x0/0x1000 [sp5100_tco] returned 0 after 126 usecs

Attached is the full log if folks are curious.

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=d

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-master-00348-g129db9c-dirty (root@phenom) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #50 SMP Wed Mar 16 21:56:54 EDT 2011
[    0.000000] Command line: placeholder root=UUID=5bd8a5d7-b434-4227-97a0-ae2c470212e9 ro loglevel=10 debug initcall_debug xen-pciback.hide=(03:00.0)(03:00.1)(02:00.0) earlyprintk=xenboot memblock=debug log_buf_len=2M
[    0.000000] xen_release_chunk: looking at area pfn c0000-fec00: 257024 pages freed
[    0.000000] xen_release_chunk: looking at area pfn fec01-fee00: 511 pages freed
[    0.000000] xen_release_chunk: looking at area pfn fee01-fff00: 4351 pages freed
[    0.000000] released 261886 pages of unused memory
[    0.000000] 1-1 mapping on 9c->100
[    0.000000] 1-1 mapping on bffb0->100000
[    0.000000] Set 262324 page(s) to 1-1 mapping.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 000000000009b000 (usable)
[    0.000000]  Xen: 000000000009b400 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  Xen: 00000000bffb0000 - 00000000bffbe000 (ACPI data)
[    0.000000]  Xen: 00000000bffbe000 - 00000000bffe0000 (ACPI NVS)
[    0.000000]  Xen: 00000000bffe0000 - 00000000c0000000 (reserved)
[    0.000000]  Xen: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  Xen: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  Xen: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  Xen: 0000000100000000 - 000000027fefe000 (usable)
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: BIOSTAR Group TA890FXE/TA890FXE, BIOS 080015  07/16/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x27fefe max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]     memblock_x86_reserve_range: [0x000ff780-0x000ff78f]   * MP-table mpf
[    0.000000]     memblock_x86_reserve_range: [0x000fd240-0x000fd423]   * MP-table mpc
[    0.000000]     memblock_x86_reserve_range: [0x01cfd000-0x01d1c0e4]              BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x23fe39000
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]	[0x00000000010000-0x0000000009afff], 0x8b000 bytes
[    0.000000]  memory[0x1]	[0x00000000100000-0x000000bffaffff], 0xbfeb0000 bytes
[    0.000000]  memory[0x2]	[0x00000100000000-0x0000027fefdfff], 0x17fefe000 bytes
[    0.000000]  reserved.cnt  = 0x5
[    0.000000]  reserved[0x0]	[0x000000000fd240-0x000000000fd423], 0x1e4 bytes
[    0.000000]  reserved[0x1]	[0x000000000ff780-0x000000000ff78f], 0x10 bytes
[    0.000000]  reserved[0x2]	[0x00000001000000-0x00000001d1c0e4], 0xd1c0e5 bytes
[    0.000000]  reserved[0x3]	[0x00000001e33000-0x00000016a4afff], 0x14c18000 bytes
[    0.000000]  reserved[0x4]	[0x000001f0f7d000-0x0000027fefdfff], 0x8ef81000 bytes
[    0.000000] initial memory mapped : 0 - 15a09000
[    0.000000]     memblock_x86_reserve_range: [0x00099000-0x0009afff]       TRAMPOLINE
[    0.000000]     memblock_x86_reserve_range: [0x00095000-0x00098fff]      ACPI WAKEUP
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffb0000
[    0.000000]  0000000000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 9fc000-1000000
[    0.000000] DEBUG find_early_table_space: _text=1000000 _end=1e33000 pgtable_start=9fc000 pgtable_end=9fc000
[    0.000000]     memblock_x86_reserve_range: [0x009fc000-0x00f43fff]          PGTABLE
[    0.000000] init_memory_mapping: 0000000100000000-000000027fefe000
[    0.000000]  0100000000 - 027fefe000 page 4k
[    0.000000] kernel direct mapping tables up to 27fefe000 @ beba5000-bffb0000
[    0.000000] DEBUG find_early_table_space: _text=1000000 _end=1e33000 pgtable_start=beba5000 pgtable_end=beba5000
[    0.000000]     memblock_x86_reserve_range: [0xbeba5000-0xbf7aafff]          PGTABLE
[    0.000000] RAMDISK: 01e33000 - 15a09000
[    0.000000] ACPI: RSDP 00000000000fb380 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bffb0100 00064 (v01 071610 XSDT1756 20100716 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bffb0290 000F4 (v04 071610 FACP1756 20100716 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bffb0450 04D0D (v02  89FAD 89FAD716 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bffbe000 00040
[    0.000000] ACPI: APIC 00000000bffb0390 0007C (v02 071610 APIC1756 20100716 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bffb0410 0003C (v01 071610 OEMMCFG  20100716 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bffbe040 00072 (v01 071610 OEMB1756 20100716 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bffba450 00108 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000bffba560 00038 (v01 071610 OEMHPET  20100716 MSFT 00000097)
[    0.000000] ACPI: IVRS 00000000bffba5a0 000C8 (v01  AMD     RD890S 00202031 AMD  00000000)
[    0.000000] ACPI: SSDT 00000000bffba670 00DA4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000027fefe000
[    0.000000] Initmem setup node 0 0000000000000000-000000027fefe000
[    0.000000]     memblock_x86_reserve_range: [0x1f0f78000-0x1f0f7cfff]        NODE_DATA
[    0.000000]   NODE_DATA [00000001f0f78000 - 00000001f0f7cfff]
[    0.000000]     memblock_x86_reserve_range: [0xbffaf000-0xbffaffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbfbaf000-0xbffaefff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbfbae940-0xbfbaefff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbf7ae940-0xbfbae93f]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1e7e00000-0x1f0dfffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f77000-0x1f0f77fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f76000-0x1f0f76fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f75000-0x1f0f75fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f74000-0x1f0f74fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f73000-0x1f0f73fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f72000-0x1f0f72fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f71000-0x1f0f71fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f70000-0x1f0f70fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f6f000-0x1f0f6ffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f6e000-0x1f0f6efff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f6d000-0x1f0f6dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f6c000-0x1f0f6cfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f6b000-0x1f0f6bfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f6a000-0x1f0f6afff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f69000-0x1f0f69fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f68000-0x1f0f68fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f67000-0x1f0f67fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f66000-0x1f0f66fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f65000-0x1f0f65fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f64000-0x1f0f64fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f63000-0x1f0f63fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f62000-0x1f0f62fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f61000-0x1f0f61fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f60000-0x1f0f60fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f5f000-0x1f0f5ffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f5e000-0x1f0f5efff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f5d000-0x1f0f5dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f5c000-0x1f0f5cfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f5b000-0x1f0f5bfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f5a000-0x1f0f5afff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f59000-0x1f0f59fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f58000-0x1f0f58fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f57000-0x1f0f57fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f56000-0x1f0f56fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f55000-0x1f0f55fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f54000-0x1f0f54fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f53000-0x1f0f53fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f52000-0x1f0f52fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f51000-0x1f0f51fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f50000-0x1f0f50fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f4f000-0x1f0f4ffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f4e000-0x1f0f4efff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f4d000-0x1f0f4dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f4c000-0x1f0f4cfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f4b000-0x1f0f4bfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f4a000-0x1f0f4afff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f49000-0x1f0f49fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f48000-0x1f0f48fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f47000-0x1f0f47fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f46000-0x1f0f46fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f45000-0x1f0f45fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f44000-0x1f0f44fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f43000-0x1f0f43fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f42000-0x1f0f42fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f41000-0x1f0f41fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f40000-0x1f0f40fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f3f000-0x1f0f3ffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f3e000-0x1f0f3efff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f3d000-0x1f0f3dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f3c000-0x1f0f3cfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f3b000-0x1f0f3bfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f3a000-0x1f0f3afff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f39000-0x1f0f39fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f38000-0x1f0f38fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x1f0f37000-0x1f0f37fff]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x1efc00000-0x1f0dfffff]
[    0.000000]        memblock_x86_free_range: [0xbf7ae940-0xbfbae93f]
[    0.000000]        memblock_x86_free_range: [0xbfbaf000-0xbffaefff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0027fefe
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000bffb0
[    0.000000]     0: 0x00100000 -> 0x0027fefe
[    0.000000] On node 0 totalpages: 2358841
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1358 pages reserved
[    0.000000]   DMA zone: 2565 pages, LIFO batch:0
[    0.000000]     memblock_x86_reserve_range: [0xbffaee80-0xbffaefff]          BOOTMEM
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767976 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0xbff96e80-0xbffaee7f]          BOOTMEM
[    0.000000]   Normal zone: 21501 pages used for memmap
[    0.000000]   Normal zone: 1551105 pages, LIFO batch:31
[    0.000000]     memblock_x86_reserve_range: [0xbff7ee80-0xbff96e7f]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7d000-0xbff7dfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7c000-0xbff7cfff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7b000-0xbff7bfff]          BOOTMEM
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 255, address 0xfec00000, GSI 0-255
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000]     memblock_x86_reserve_range: [0xbff7ee00-0xbff7ee40]          BOOTMEM
[    0.000000] SMP: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000]     memblock_x86_reserve_range: [0xbff7ed80-0xbff7edc2]          BOOTMEM
[    0.000000] nr_irqs_gsi: 272
[    0.000000]     memblock_x86_reserve_range: [0xbff7eb00-0xbff7ed67]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7ea80-0xbff7eae7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7ea00-0xbff7ea67]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e980-0xbff7e9e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e900-0xbff7e967]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e880-0xbff7e8e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e800-0xbff7e867]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e780-0xbff7e7e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e700-0xbff7e767]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e680-0xbff7e6e7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e600-0xbff7e667]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e5c0-0xbff7e5df]          BOOTMEM
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 0000000000100000
[    0.000000]     memblock_x86_reserve_range: [0xbff7e580-0xbff7e59f]          BOOTMEM
[    0.000000] PM: Registered nosave memory: 00000000bffb0000 - 00000000bffbe000
[    0.000000] PM: Registered nosave memory: 00000000bffbe000 - 00000000bffe0000
[    0.000000] PM: Registered nosave memory: 00000000bffe0000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ec00000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.1-110315 (preserve-AD)
[    0.000000]     memblock_x86_reserve_range: [0xbff7e4c0-0xbff7e57d]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e400-0xbff7e4bd]          BOOTMEM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:6 nr_node_ids:1
[    0.000000]     memblock_x86_reserve_range: [0xbff7a000-0xbff7afff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff79000-0xbff79fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbfed1000-0xbff78fff]          BOOTMEM
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800bfed1000 s84288 r8192 d22208 u114688
[    0.000000]     memblock_x86_reserve_range: [0xbff7e3c0-0xbff7e3c7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e380-0xbff7e387]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e340-0xbff7e357]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e300-0xbff7e32f]          BOOTMEM
[    0.000000] pcpu-alloc: s84288 r8192 d22208 u114688 alloc=28*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 
[    0.000000]     memblock_x86_reserve_range: [0xbff7e200-0xbff7e2ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e180-0xbff7e1c7]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbff7e100-0xbff7e147]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0xbff7a000-0xbff7afff]
[    0.000000]        memblock_x86_free_range: [0xbff79000-0xbff79fff]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2321646
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: placeholder root=UUID=5bd8a5d7-b434-4227-97a0-ae2c470212e9 ro loglevel=10 debug initcall_debug xen-pciback.hide=(03:00.0)(03:00.1)(02:00.0) earlyprintk=xenboot memblock=debug log_buf_len=2M
[    0.000000]     memblock_x86_reserve_range: [0xbfcd1000-0xbfed0fff]          BOOTMEM
[    0.000000] log_buf_len: 2097152
[    0.000000]     memblock_x86_reserve_range: [0xbfcc9000-0xbfcd0fff]          BOOTMEM
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000]     memblock_x86_reserve_range: [0xbaba5000-0xbeba4fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbfca9000-0xbfcc8fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0xbfc69000-0xbfca8fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x0008d000-0x00094fff]          BOOTMEM
[    0.000000] Placing 64MB software IO TLB between ffff8800baba5000 - ffff8800beba5000
[    0.000000] software IO TLB at phys 0xbaba5000 - 0xbeba5000
[    0.000000] Subtract (36 early reservations)
[    0.000000]   [000008d000-000009afff]
[    0.000000]   [00000fd240-00000fd423]
[    0.000000]   [00000ff780-00000ff78f]
[    0.000000]   [00009fc000-0000f43fff]
[    0.000000]   [0001000000-0001d1c0e4]
[    0.000000]   [0001e33000-0016a4afff]
[    0.000000]   [00baba5000-00bf7aafff]
[    0.000000]   [00bfbae940-00bfbaefff]
[    0.000000]   [00bfc69000-00bff78fff]
[    0.000000]   [00bff7b000-00bff7dfff]
[    0.000000]   [00bff7e100-00bff7e147]
[    0.000000]   [00bff7e180-00bff7e1c7]
[    0.000000]   [00bff7e200-00bff7e32f]
[    0.000000]   [00bff7e340-00bff7e357]
[    0.000000]   [00bff7e380-00bff7e387]
[    0.000000]   [00bff7e3c0-00bff7e3c7]
[    0.000000]   [00bff7e400-00bff7e4bd]
[    0.000000]   [00bff7e4c0-00bff7e57d]
[    0.000000]   [00bff7e580-00bff7e59f]
[    0.000000]   [00bff7e5c0-00bff7e5df]
[    0.000000]   [00bff7e600-00bff7e667]
[    0.000000]   [00bff7e680-00bff7e6e7]
[    0.000000]   [00bff7e700-00bff7e767]
[    0.000000]   [00bff7e780-00bff7e7e7]
[    0.000000]   [00bff7e800-00bff7e867]
[    0.000000]   [00bff7e880-00bff7e8e7]
[    0.000000]   [00bff7e900-00bff7e967]
[    0.000000]   [00bff7e980-00bff7e9e7]
[    0.000000]   [00bff7ea00-00bff7ea67]
[    0.000000]   [00bff7ea80-00bff7eae7]
[    0.000000]   [00bff7eb00-00bff7ed67]
[    0.000000]   [00bff7ed80-00bff7edc2]
[    0.000000]   [00bff7ee00-00bff7ee40]
[    0.000000]   [00bff7ee80-00bffaffff]
[    0.000000]   [01e7e00000-01efbfffff]
[    0.000000]   [01f0f37000-027fefdfff]
[    0.000000] Memory: 6523500k/10484728k available (5931k kernel code, 1049364k absent, 2911864k reserved, 5020k data, 968k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1536 16
[    0.000000] xen: sci override: global_irq=9 trigger=0 polarity=1
[    0.000000] xen: registering gsi 9 triggering 0 polarity 1
[    0.000000] xen: --> pirq=9 -> irq=9
[    0.000000] xen: acpi sci 9
[    0.000000] xen: --> pirq=1 -> irq=1
[    0.000000] xen: --> pirq=2 -> irq=2
[    0.000000] xen: --> pirq=3 -> irq=3
[    0.000000] xen: --> pirq=4 -> irq=4
[    0.000000] xen: --> pirq=5 -> irq=5
[    0.000000] xen: --> pirq=6 -> irq=6
[    0.000000] xen: --> pirq=7 -> irq=7
[    0.000000] xen: --> pirq=8 -> irq=8
[    0.000000] xen_map_pirq_gsi: returning irq 9 for gsi 9
[    0.000000] xen: --> pirq=9 -> irq=9
[    0.000000] xen: --> pirq=10 -> irq=10
[    0.000000] xen: --> pirq=11 -> irq=11
[    0.000000] xen: --> pirq=12 -> irq=12
[    0.000000] xen: --> pirq=13 -> irq=13
[    0.000000] xen: --> pirq=14 -> irq=14
[    0.000000] xen: --> pirq=15 -> irq=15
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] allocated 94371840 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 3000.216 MHz processor.
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.43 BogoMIPS (lpj=30002160)
[    0.010000] pid_max: default: 32768 minimum: 301
[    0.010000] Security Framework initialized
[    0.010000] AppArmor: AppArmor initialized
[    0.010000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.010000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Initializing cgroup subsys ns
[    0.010000] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.010000] Initializing cgroup subsys cpuacct
[    0.010000] Initializing cgroup subsys memory
[    0.010000] Initializing cgroup subsys devices
[    0.010000] Initializing cgroup subsys freezer
[    0.010000] Initializing cgroup subsys net_cls
[    0.010000] Initializing cgroup subsys blkio
[    0.010000] tseg: 0000000000
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010906] ACPI: Core revision 20110112
[    0.019526] ftrace: allocating 22587 entries in 89 pages
[    0.020079] cpu 0 spinlock event irq 273
[    0.020136] calling  trace_init_flags_exit__mmap+0x0/0x12 @ 1
[    0.020141] initcall trace_init_flags_exit__mmap+0x0/0x12 returned 0 after 0 usecs
[    0.020145] calling  trace_init_flags_enter__mmap+0x0/0x12 @ 1
[    0.020149] initcall trace_init_flags_enter__mmap+0x0/0x12 returned 0 after 0 usecs
[    0.020154] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.020157] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.020161] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.020165] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.020169] calling  init_hw_perf_events+0x0/0xc9a @ 1
[    0.020172] Performance Events: Broken PMU hardware detected, using software events only.
[    0.020199] initcall init_hw_perf_events+0x0/0xc9a returned 0 after 0 usecs
[    0.020204] calling  migration_init+0x0/0x72 @ 1
[    0.020209] initcall migration_init+0x0/0x72 returned 0 after 0 usecs
[    0.020213] calling  trace_init_flags_exit__sched_rr_get_interval+0x0/0x12 @ 1
[    0.020217] initcall trace_init_flags_exit__sched_rr_get_interval+0x0/0x12 returned 0 after 0 usecs
[    0.020222] calling  trace_init_flags_enter__sched_rr_get_interval+0x0/0x12 @ 1
[    0.020226] initcall trace_init_flags_enter__sched_rr_get_interval+0x0/0x12 returned 0 after 0 usecs
[    0.020231] calling  trace_init_flags_exit__sched_get_priority_min+0x0/0x12 @ 1
[    0.020235] initcall trace_init_flags_exit__sched_get_priority_min+0x0/0x12 returned 0 after 0 usecs
[    0.020240] calling  trace_init_flags_enter__sched_get_priority_min+0x0/0x12 @ 1
[    0.020245] initcall trace_init_flags_enter__sched_get_priority_min+0x0/0x12 returned 0 after 0 usecs
[    0.020249] calling  trace_init_flags_exit__sched_get_priority_max+0x0/0x12 @ 1
[    0.020254] initcall trace_init_flags_exit__sched_get_priority_max+0x0/0x12 returned 0 after 0 usecs
[    0.020259] calling  trace_init_flags_enter__sched_get_priority_max+0x0/0x12 @ 1
[    0.020263] initcall trace_init_flags_enter__sched_get_priority_max+0x0/0x12 returned 0 after 0 usecs
[    0.020268] calling  trace_init_flags_exit__sched_yield+0x0/0x12 @ 1
[    0.020271] initcall trace_init_flags_exit__sched_yield+0x0/0x12 returned 0 after 0 usecs
[    0.020276] calling  trace_init_flags_enter__sched_yield+0x0/0x12 @ 1
[    0.020280] initcall trace_init_flags_enter__sched_yield+0x0/0x12 returned 0 after 0 usecs
[    0.020284] calling  trace_init_flags_exit__sched_getaffinity+0x0/0x12 @ 1
[    0.020288] initcall trace_init_flags_exit__sched_getaffinity+0x0/0x12 returned 0 after 0 usecs
[    0.020293] calling  trace_init_flags_enter__sched_getaffinity+0x0/0x12 @ 1
[    0.020297] initcall trace_init_flags_enter__sched_getaffinity+0x0/0x12 returned 0 after 0 usecs
[    0.020301] calling  trace_init_flags_exit__sched_setaffinity+0x0/0x12 @ 1
[    0.020305] initcall trace_init_flags_exit__sched_setaffinity+0x0/0x12 returned 0 after 0 usecs
[    0.020310] calling  trace_init_flags_enter__sched_setaffinity+0x0/0x12 @ 1
[    0.020314] initcall trace_init_flags_enter__sched_setaffinity+0x0/0x12 returned 0 after 0 usecs
[    0.020319] calling  trace_init_flags_exit__sched_getparam+0x0/0x12 @ 1
[    0.020323] initcall trace_init_flags_exit__sched_getparam+0x0/0x12 returned 0 after 0 usecs
[    0.020327] calling  trace_init_flags_enter__sched_getparam+0x0/0x12 @ 1
[    0.020331] initcall trace_init_flags_enter__sched_getparam+0x0/0x12 returned 0 after 0 usecs
[    0.020336] calling  trace_init_flags_exit__sched_getscheduler+0x0/0x12 @ 1
[    0.020340] initcall trace_init_flags_exit__sched_getscheduler+0x0/0x12 returned 0 after 0 usecs
[    0.020344] calling  trace_init_flags_enter__sched_getscheduler+0x0/0x12 @ 1
[    0.020348] initcall trace_init_flags_enter__sched_getscheduler+0x0/0x12 returned 0 after 0 usecs
[    0.020353] calling  trace_init_flags_exit__sched_setparam+0x0/0x12 @ 1
[    0.020357] initcall trace_init_flags_exit__sched_setparam+0x0/0x12 returned 0 after 0 usecs
[    0.020361] calling  trace_init_flags_enter__sched_setparam+0x0/0x12 @ 1
[    0.020365] initcall trace_init_flags_enter__sched_setparam+0x0/0x12 returned 0 after 0 usecs
[    0.020369] calling  trace_init_flags_exit__sched_setscheduler+0x0/0x12 @ 1
[    0.020373] initcall trace_init_flags_exit__sched_setscheduler+0x0/0x12 returned 0 after 0 usecs
[    0.020378] calling  trace_init_flags_enter__sched_setscheduler+0x0/0x12 @ 1
[    0.020382] initcall trace_init_flags_enter__sched_setscheduler+0x0/0x12 returned 0 after 0 usecs
[    0.020386] calling  trace_init_flags_exit__nice+0x0/0x12 @ 1
[    0.020390] initcall trace_init_flags_exit__nice+0x0/0x12 returned 0 after 0 usecs
[    0.020394] calling  trace_init_flags_enter__nice+0x0/0x12 @ 1
[    0.020398] initcall trace_init_flags_enter__nice+0x0/0x12 returned 0 after 0 usecs
[    0.020402] calling  trace_init_flags_exit__unshare+0x0/0x12 @ 1
[    0.020406] initcall trace_init_flags_exit__unshare+0x0/0x12 returned 0 after 0 usecs
[    0.020410] calling  trace_init_flags_enter__unshare+0x0/0x12 @ 1
[    0.020414] initcall trace_init_flags_enter__unshare+0x0/0x12 returned 0 after 0 usecs
[    0.020419] calling  trace_init_flags_exit__set_tid_address+0x0/0x12 @ 1
[    0.020423] initcall trace_init_flags_exit__set_tid_address+0x0/0x12 returned 0 after 0 usecs
[    0.020427] calling  trace_init_flags_enter__set_tid_address+0x0/0x12 @ 1
[    0.020431] initcall trace_init_flags_enter__set_tid_address+0x0/0x12 returned 0 after 0 usecs
[    0.020436] calling  trace_init_flags_exit__personality+0x0/0x12 @ 1
[    0.020440] initcall trace_init_flags_exit__personality+0x0/0x12 returned 0 after 0 usecs
[    0.020444] calling  trace_init_flags_enter__personality+0x0/0x12 @ 1
[    0.020448] initcall trace_init_flags_enter__personality+0x0/0x12 returned 0 after 0 usecs
[    0.020452] calling  trace_init_flags_exit__syslog+0x0/0x12 @ 1
[    0.020456] initcall trace_init_flags_exit__syslog+0x0/0x12 returned 0 after 0 usecs
[    0.020461] calling  trace_init_flags_enter__syslog+0x0/0x12 @ 1
[    0.020464] initcall trace_init_flags_enter__syslog+0x0/0x12 returned 0 after 0 usecs
[    0.020469] calling  trace_init_flags_exit__waitpid+0x0/0x12 @ 1
[    0.020473] initcall trace_init_flags_exit__waitpid+0x0/0x12 returned 0 after 0 usecs
[    0.020477] calling  trace_init_flags_enter__waitpid+0x0/0x12 @ 1
[    0.020481] initcall trace_init_flags_enter__waitpid+0x0/0x12 returned 0 after 0 usecs
[    0.020485] calling  trace_init_flags_exit__wait4+0x0/0x12 @ 1
[    0.020489] initcall trace_init_flags_exit__wait4+0x0/0x12 returned 0 after 0 usecs
[    0.020493] calling  trace_init_flags_enter__wait4+0x0/0x12 @ 1
[    0.020497] initcall trace_init_flags_enter__wait4+0x0/0x12 returned 0 after 0 usecs
[    0.020501] calling  trace_init_flags_exit__waitid+0x0/0x12 @ 1
[    0.020505] initcall trace_init_flags_exit__waitid+0x0/0x12 returned 0 after 0 usecs
[    0.020509] calling  trace_init_flags_enter__waitid+0x0/0x12 @ 1
[    0.020513] initcall trace_init_flags_enter__waitid+0x0/0x12 returned 0 after 0 usecs
[    0.020518] calling  trace_init_flags_exit__exit_group+0x0/0x12 @ 1
[    0.020522] initcall trace_init_flags_exit__exit_group+0x0/0x12 returned 0 after 0 usecs
[    0.020526] calling  trace_init_flags_enter__exit_group+0x0/0x12 @ 1
[    0.020530] initcall trace_init_flags_enter__exit_group+0x0/0x12 returned 0 after 0 usecs
[    0.020534] calling  trace_init_flags_exit__exit+0x0/0x12 @ 1
[    0.020538] initcall trace_init_flags_exit__exit+0x0/0x12 returned 0 after 0 usecs
[    0.020542] calling  trace_init_flags_enter__exit+0x0/0x12 @ 1
[    0.020546] initcall trace_init_flags_enter__exit+0x0/0x12 returned 0 after 0 usecs
[    0.020550] calling  trace_init_flags_exit__setitimer+0x0/0x12 @ 1
[    0.020554] initcall trace_init_flags_exit__setitimer+0x0/0x12 returned 0 after 0 usecs
[    0.020559] calling  trace_init_flags_enter__setitimer+0x0/0x12 @ 1
[    0.020562] initcall trace_init_flags_enter__setitimer+0x0/0x12 returned 0 after 0 usecs
[    0.020567] calling  trace_init_flags_exit__getitimer+0x0/0x12 @ 1
[    0.020571] initcall trace_init_flags_exit__getitimer+0x0/0x12 returned 0 after 0 usecs
[    0.020575] calling  trace_init_flags_enter__getitimer+0x0/0x12 @ 1
[    0.020579] initcall trace_init_flags_enter__getitimer+0x0/0x12 returned 0 after 0 usecs
[    0.020584] calling  trace_init_flags_exit__adjtimex+0x0/0x2d @ 1
[    0.020587] initcall trace_init_flags_exit__adjtimex+0x0/0x2d returned 0 after 0 usecs
[    0.020592] calling  trace_init_flags_enter__adjtimex+0x0/0x12 @ 1
[    0.020596] initcall trace_init_flags_enter__adjtimex+0x0/0x12 returned 0 after 0 usecs
[    0.020600] calling  trace_init_flags_exit__settimeofday+0x0/0x12 @ 1
[    0.020604] initcall trace_init_flags_exit__settimeofday+0x0/0x12 returned 0 after 0 usecs
[    0.020609] calling  trace_init_flags_enter__settimeofday+0x0/0x12 @ 1
[    0.020613] initcall trace_init_flags_enter__settimeofday+0x0/0x12 returned 0 after 0 usecs
[    0.020617] calling  trace_init_flags_exit__gettimeofday+0x0/0x12 @ 1
[    0.020621] initcall trace_init_flags_exit__gettimeofday+0x0/0x12 returned 0 after 0 usecs
[    0.020626] calling  trace_init_flags_enter__gettimeofday+0x0/0x12 @ 1
[    0.020630] initcall trace_init_flags_enter__gettimeofday+0x0/0x12 returned 0 after 0 usecs
[    0.020634] calling  trace_init_flags_exit__stime+0x0/0x12 @ 1
[    0.020638] initcall trace_init_flags_exit__stime+0x0/0x12 returned 0 after 0 usecs
[    0.020642] calling  trace_init_flags_enter__stime+0x0/0x12 @ 1
[    0.020646] initcall trace_init_flags_enter__stime+0x0/0x12 returned 0 after 0 usecs
[    0.020650] calling  trace_init_flags_exit__time+0x0/0x12 @ 1
[    0.020654] initcall trace_init_flags_exit__time+0x0/0x12 returned 0 after 0 usecs
[    0.020658] calling  trace_init_flags_enter__time+0x0/0x12 @ 1
[    0.020662] initcall trace_init_flags_enter__time+0x0/0x12 returned 0 after 0 usecs
[    0.020666] calling  spawn_ksoftirqd+0x0/0x57 @ 1
[    0.020693] initcall spawn_ksoftirqd+0x0/0x57 returned 0 after 0 usecs
[    0.020697] calling  trace_init_flags_exit__sysctl+0x0/0x12 @ 1
[    0.020701] initcall trace_init_flags_exit__sysctl+0x0/0x12 returned 0 after 0 usecs
[    0.020705] calling  trace_init_flags_enter__sysctl+0x0/0x12 @ 1
[    0.020709] initcall trace_init_flags_enter__sysctl+0x0/0x12 returned 0 after 0 usecs
[    0.020714] calling  trace_init_flags_exit__capset+0x0/0x12 @ 1
[    0.020717] initcall trace_init_flags_exit__capset+0x0/0x12 returned 0 after 0 usecs
[    0.020722] calling  trace_init_flags_enter__capset+0x0/0x12 @ 1
[    0.020726] initcall trace_init_flags_enter__capset+0x0/0x12 returned 0 after 0 usecs
[    0.020730] calling  trace_init_flags_exit__capget+0x0/0x12 @ 1
[    0.020734] initcall trace_init_flags_exit__capget+0x0/0x12 returned 0 after 0 usecs
[    0.020738] calling  trace_init_flags_enter__capget+0x0/0x12 @ 1
[    0.020742] initcall trace_init_flags_enter__capget+0x0/0x12 returned 0 after 0 usecs
[    0.020747] calling  trace_init_flags_exit__ptrace+0x0/0x12 @ 1
[    0.020750] initcall trace_init_flags_exit__ptrace+0x0/0x12 returned 0 after 0 usecs
[    0.020755] calling  trace_init_flags_enter__ptrace+0x0/0x12 @ 1
[    0.020759] initcall trace_init_flags_enter__ptrace+0x0/0x12 returned 0 after 0 usecs
[    0.020763] calling  trace_init_flags_exit__sysinfo+0x0/0x12 @ 1
[    0.020767] initcall trace_init_flags_exit__sysinfo+0x0/0x12 returned 0 after 0 usecs
[    0.020772] calling  trace_init_flags_enter__sysinfo+0x0/0x12 @ 1
[    0.020775] initcall trace_init_flags_enter__sysinfo+0x0/0x12 returned 0 after 0 usecs
[    0.020780] calling  trace_init_flags_exit__gettid+0x0/0x12 @ 1
[    0.020784] initcall trace_init_flags_exit__gettid+0x0/0x12 returned 0 after 0 usecs
[    0.020788] calling  trace_init_flags_enter__gettid+0x0/0x12 @ 1
[    0.020792] initcall trace_init_flags_enter__gettid+0x0/0x12 returned 0 after 0 usecs
[    0.020797] calling  trace_init_flags_exit__getegid+0x0/0x12 @ 1
[    0.020800] initcall trace_init_flags_exit__getegid+0x0/0x12 returned 0 after 0 usecs
[    0.020805] calling  trace_init_flags_enter__getegid+0x0/0x12 @ 1
[    0.020809] initcall trace_init_flags_enter__getegid+0x0/0x12 returned 0 after 0 usecs
[    0.020813] calling  trace_init_flags_exit__getgid+0x0/0x12 @ 1
[    0.020817] initcall trace_init_flags_exit__getgid+0x0/0x12 returned 0 after 0 usecs
[    0.020821] calling  trace_init_flags_enter__getgid+0x0/0x12 @ 1
[    0.020825] initcall trace_init_flags_enter__getgid+0x0/0x12 returned 0 after 0 usecs
[    0.020830] calling  trace_init_flags_exit__geteuid+0x0/0x12 @ 1
[    0.020834] initcall trace_init_flags_exit__geteuid+0x0/0x12 returned 0 after 0 usecs
[    0.020838] calling  trace_init_flags_enter__geteuid+0x0/0x12 @ 1
[    0.020842] initcall trace_init_flags_enter__geteuid+0x0/0x12 returned 0 after 0 usecs
[    0.020846] calling  trace_init_flags_exit__getuid+0x0/0x12 @ 1
[    0.020850] initcall trace_init_flags_exit__getuid+0x0/0x12 returned 0 after 0 usecs
[    0.020855] calling  trace_init_flags_enter__getuid+0x0/0x12 @ 1
[    0.020858] initcall trace_init_flags_enter__getuid+0x0/0x12 returned 0 after 0 usecs
[    0.020863] calling  trace_init_flags_exit__getppid+0x0/0x12 @ 1
[    0.020867] initcall trace_init_flags_exit__getppid+0x0/0x12 returned 0 after 0 usecs
[    0.020871] calling  trace_init_flags_enter__getppid+0x0/0x12 @ 1
[    0.020875] initcall trace_init_flags_enter__getppid+0x0/0x12 returned 0 after 0 usecs
[    0.020879] calling  trace_init_flags_exit__getpid+0x0/0x12 @ 1
[    0.020883] initcall trace_init_flags_exit__getpid+0x0/0x12 returned 0 after 0 usecs
[    0.020888] calling  trace_init_flags_enter__getpid+0x0/0x12 @ 1
[    0.020891] initcall trace_init_flags_enter__getpid+0x0/0x12 returned 0 after 0 usecs
[    0.020896] calling  trace_init_flags_exit__alarm+0x0/0x12 @ 1
[    0.020900] initcall trace_init_flags_exit__alarm+0x0/0x12 returned 0 after 0 usecs
[    0.020904] calling  trace_init_flags_enter__alarm+0x0/0x12 @ 1
[    0.020908] initcall trace_init_flags_enter__alarm+0x0/0x12 returned 0 after 0 usecs
[    0.020912] calling  trace_init_flags_exit__rt_sigsuspend+0x0/0x12 @ 1
[    0.020917] initcall trace_init_flags_exit__rt_sigsuspend+0x0/0x12 returned 0 after 0 usecs
[    0.020921] calling  trace_init_flags_enter__rt_sigsuspend+0x0/0x12 @ 1
[    0.020925] initcall trace_init_flags_enter__rt_sigsuspend+0x0/0x12 returned 0 after 0 usecs
[    0.020930] calling  trace_init_flags_exit__pause+0x0/0x12 @ 1
[    0.020934] initcall trace_init_flags_exit__pause+0x0/0x12 returned 0 after 0 usecs
[    0.020938] calling  trace_init_flags_enter__pause+0x0/0x12 @ 1
[    0.020942] initcall trace_init_flags_enter__pause+0x0/0x12 returned 0 after 0 usecs
[    0.020947] calling  trace_init_flags_exit__signal+0x0/0x12 @ 1
[    0.020951] initcall trace_init_flags_exit__signal+0x0/0x12 returned 0 after 0 usecs
[    0.020955] calling  trace_init_flags_enter__signal+0x0/0x12 @ 1
[    0.020959] initcall trace_init_flags_enter__signal+0x0/0x12 returned 0 after 0 usecs
[    0.020964] calling  trace_init_flags_exit__ssetmask+0x0/0x12 @ 1
[    0.020968] initcall trace_init_flags_exit__ssetmask+0x0/0x12 returned 0 after 0 usecs
[    0.020972] calling  trace_init_flags_enter__ssetmask+0x0/0x12 @ 1
[    0.020976] initcall trace_init_flags_enter__ssetmask+0x0/0x12 returned 0 after 0 usecs
[    0.020981] calling  trace_init_flags_exit__sgetmask+0x0/0x12 @ 1
[    0.020985] initcall trace_init_flags_exit__sgetmask+0x0/0x12 returned 0 after 0 usecs
[    0.020989] calling  trace_init_flags_enter__sgetmask+0x0/0x12 @ 1
[    0.020993] initcall trace_init_flags_enter__sgetmask+0x0/0x12 returned 0 after 0 usecs
[    0.020998] calling  trace_init_flags_exit__rt_sigaction+0x0/0x12 @ 1
[    0.021002] initcall trace_init_flags_exit__rt_sigaction+0x0/0x12 returned 0 after 0 usecs
[    0.021007] calling  trace_init_flags_enter__rt_sigaction+0x0/0x12 @ 1
[    0.021011] initcall trace_init_flags_enter__rt_sigaction+0x0/0x12 returned 0 after 0 usecs
[    0.021015] calling  trace_init_flags_exit__sigprocmask+0x0/0x12 @ 1
[    0.021019] initcall trace_init_flags_exit__sigprocmask+0x0/0x12 returned 0 after 0 usecs
[    0.021024] calling  trace_init_flags_enter__sigprocmask+0x0/0x12 @ 1
[    0.021028] initcall trace_init_flags_enter__sigprocmask+0x0/0x12 returned 0 after 0 usecs
[    0.021033] calling  trace_init_flags_exit__sigpending+0x0/0x12 @ 1
[    0.021037] initcall trace_init_flags_exit__sigpending+0x0/0x12 returned 0 after 0 usecs
[    0.021041] calling  trace_init_flags_enter__sigpending+0x0/0x12 @ 1
[    0.021045] initcall trace_init_flags_enter__sigpending+0x0/0x12 returned 0 after 0 usecs
[    0.021050] calling  trace_init_flags_exit__rt_tgsigqueueinfo+0x0/0x12 @ 1
[    0.021054] initcall trace_init_flags_exit__rt_tgsigqueueinfo+0x0/0x12 returned 0 after 0 usecs
[    0.021059] calling  trace_init_flags_enter__rt_tgsigqueueinfo+0x0/0x12 @ 1
[    0.021063] initcall trace_init_flags_enter__rt_tgsigqueueinfo+0x0/0x12 returned 0 after 0 usecs
[    0.021068] calling  trace_init_flags_exit__rt_sigqueueinfo+0x0/0x12 @ 1
[    0.021072] initcall trace_init_flags_exit__rt_sigqueueinfo+0x0/0x12 returned 0 after 0 usecs
[    0.021077] calling  trace_init_flags_enter__rt_sigqueueinfo+0x0/0x12 @ 1
[    0.021081] initcall trace_init_flags_enter__rt_sigqueueinfo+0x0/0x12 returned 0 after 0 usecs
[    0.021085] calling  trace_init_flags_exit__tkill+0x0/0x12 @ 1
[    0.021089] initcall trace_init_flags_exit__tkill+0x0/0x12 returned 0 after 0 usecs
[    0.021094] calling  trace_init_flags_enter__tkill+0x0/0x12 @ 1
[    0.021098] initcall trace_init_flags_enter__tkill+0x0/0x12 returned 0 after 0 usecs
[    0.021102] calling  trace_init_flags_exit__tgkill+0x0/0x12 @ 1
[    0.021106] initcall trace_init_flags_exit__tgkill+0x0/0x12 returned 0 after 0 usecs
[    0.021110] calling  trace_init_flags_enter__tgkill+0x0/0x12 @ 1
[    0.021114] initcall trace_init_flags_enter__tgkill+0x0/0x12 returned 0 after 0 usecs
[    0.021119] calling  trace_init_flags_exit__kill+0x0/0x12 @ 1
[    0.021123] initcall trace_init_flags_exit__kill+0x0/0x12 returned 0 after 0 usecs
[    0.021127] calling  trace_init_flags_enter__kill+0x0/0x12 @ 1
[    0.021131] initcall trace_init_flags_enter__kill+0x0/0x12 returned 0 after 0 usecs
[    0.021135] calling  trace_init_flags_exit__rt_sigtimedwait+0x0/0x12 @ 1
[    0.021139] initcall trace_init_flags_exit__rt_sigtimedwait+0x0/0x12 returned 0 after 0 usecs
[    0.021144] calling  trace_init_flags_enter__rt_sigtimedwait+0x0/0x12 @ 1
[    0.021148] initcall trace_init_flags_enter__rt_sigtimedwait+0x0/0x12 returned 0 after 0 usecs
[    0.021153] calling  trace_init_flags_exit__rt_sigpending+0x0/0x12 @ 1
[    0.021157] initcall trace_init_flags_exit__rt_sigpending+0x0/0x12 returned 0 after 0 usecs
[    0.021162] calling  trace_init_flags_enter__rt_sigpending+0x0/0x12 @ 1
[    0.021166] initcall trace_init_flags_enter__rt_sigpending+0x0/0x12 returned 0 after 0 usecs
[    0.021170] calling  trace_init_flags_exit__rt_sigprocmask+0x0/0x12 @ 1
[    0.021174] initcall trace_init_flags_exit__rt_sigprocmask+0x0/0x12 returned 0 after 0 usecs
[    0.021179] calling  trace_init_flags_enter__rt_sigprocmask+0x0/0x12 @ 1
[    0.021183] initcall trace_init_flags_enter__rt_sigprocmask+0x0/0x12 returned 0 after 0 usecs
[    0.021188] calling  trace_init_flags_exit__restart_syscall+0x0/0x12 @ 1
[    0.021192] initcall trace_init_flags_exit__restart_syscall+0x0/0x12 returned 0 after 0 usecs
[    0.021197] calling  trace_init_flags_enter__restart_syscall+0x0/0x12 @ 1
[    0.021201] initcall trace_init_flags_enter__restart_syscall+0x0/0x12 returned 0 after 0 usecs
[    0.021205] calling  trace_init_flags_exit__getcpu+0x0/0x12 @ 1
[    0.021209] initcall trace_init_flags_exit__getcpu+0x0/0x12 returned 0 after 0 usecs
[    0.021213] calling  trace_init_flags_enter__getcpu+0x0/0x12 @ 1
[    0.021217] initcall trace_init_flags_enter__getcpu+0x0/0x12 returned 0 after 0 usecs
[    0.021221] calling  trace_init_flags_exit__prctl+0x0/0x12 @ 1
[    0.021224] initcall trace_init_flags_exit__prctl+0x0/0x12 returned 0 after 0 usecs
[    0.021229] calling  trace_init_flags_enter__prctl+0x0/0x12 @ 1
[    0.021232] initcall trace_init_flags_enter__prctl+0x0/0x12 returned 0 after 0 usecs
[    0.021236] calling  trace_init_flags_exit__umask+0x0/0x12 @ 1
[    0.021240] initcall trace_init_flags_exit__umask+0x0/0x12 returned 0 after 0 usecs
[    0.021244] calling  trace_init_flags_enter__umask+0x0/0x12 @ 1
[    0.021247] initcall trace_init_flags_enter__umask+0x0/0x12 returned 0 after 0 usecs
[    0.021252] calling  trace_init_flags_exit__getrusage+0x0/0x12 @ 1
[    0.021255] initcall trace_init_flags_exit__getrusage+0x0/0x12 returned 0 after 0 usecs
[    0.021259] calling  trace_init_flags_enter__getrusage+0x0/0x12 @ 1
[    0.021263] initcall trace_init_flags_enter__getrusage+0x0/0x12 returned 0 after 0 usecs
[    0.021267] calling  trace_init_flags_exit__setrlimit+0x0/0x12 @ 1
[    0.021271] initcall trace_init_flags_exit__setrlimit+0x0/0x12 returned 0 after 0 usecs
[    0.021275] calling  trace_init_flags_enter__setrlimit+0x0/0x12 @ 1
[    0.021279] initcall trace_init_flags_enter__setrlimit+0x0/0x12 returned 0 after 0 usecs
[    0.021283] calling  trace_init_flags_exit__prlimit64+0x0/0x12 @ 1
[    0.021287] initcall trace_init_flags_exit__prlimit64+0x0/0x12 returned 0 after 0 usecs
[    0.021291] calling  trace_init_flags_enter__prlimit64+0x0/0x12 @ 1
[    0.021294] initcall trace_init_flags_enter__prlimit64+0x0/0x12 returned 0 after 0 usecs
[    0.021299] calling  trace_init_flags_exit__old_getrlimit+0x0/0x12 @ 1
[    0.021302] initcall trace_init_flags_exit__old_getrlimit+0x0/0x12 returned 0 after 0 usecs
[    0.021307] calling  trace_init_flags_enter__old_getrlimit+0x0/0x12 @ 1
[    0.021310] initcall trace_init_flags_enter__old_getrlimit+0x0/0x12 returned 0 after 0 usecs
[    0.021315] calling  trace_init_flags_exit__getrlimit+0x0/0x12 @ 1
[    0.021318] initcall trace_init_flags_exit__getrlimit+0x0/0x12 returned 0 after 0 usecs
[    0.021323] calling  trace_init_flags_enter__getrlimit+0x0/0x12 @ 1
[    0.021326] initcall trace_init_flags_enter__getrlimit+0x0/0x12 returned 0 after 0 usecs
[    0.021330] calling  trace_init_flags_exit__setdomainname+0x0/0x12 @ 1
[    0.021334] initcall trace_init_flags_exit__setdomainname+0x0/0x12 returned 0 after 0 usecs
[    0.021338] calling  trace_init_flags_enter__setdomainname+0x0/0x12 @ 1
[    0.021342] initcall trace_init_flags_enter__setdomainname+0x0/0x12 returned 0 after 0 usecs
[    0.021346] calling  trace_init_flags_exit__gethostname+0x0/0x12 @ 1
[    0.021350] initcall trace_init_flags_exit__gethostname+0x0/0x12 returned 0 after 0 usecs
[    0.021355] calling  trace_init_flags_enter__gethostname+0x0/0x12 @ 1
[    0.021359] initcall trace_init_flags_enter__gethostname+0x0/0x12 returned 0 after 0 usecs
[    0.021364] calling  trace_init_flags_exit__sethostname+0x0/0x12 @ 1
[    0.021368] initcall trace_init_flags_exit__sethostname+0x0/0x12 returned 0 after 0 usecs
[    0.021373] calling  trace_init_flags_enter__sethostname+0x0/0x12 @ 1
[    0.021377] initcall trace_init_flags_enter__sethostname+0x0/0x12 returned 0 after 0 usecs
[    0.021381] calling  trace_init_flags_exit__olduname+0x0/0x12 @ 1
[    0.021386] initcall trace_init_flags_exit__olduname+0x0/0x12 returned 0 after 0 usecs
[    0.021390] calling  trace_init_flags_enter__olduname+0x0/0x12 @ 1
[    0.021394] initcall trace_init_flags_enter__olduname+0x0/0x12 returned 0 after 0 usecs
[    0.021399] calling  trace_init_flags_exit__uname+0x0/0x12 @ 1
[    0.021403] initcall trace_init_flags_exit__uname+0x0/0x12 returned 0 after 0 usecs
[    0.021407] calling  trace_init_flags_enter__uname+0x0/0x12 @ 1
[    0.021411] initcall trace_init_flags_enter__uname+0x0/0x12 returned 0 after 0 usecs
[    0.021416] calling  trace_init_flags_exit__newuname+0x0/0x12 @ 1
[    0.021420] initcall trace_init_flags_exit__newuname+0x0/0x12 returned 0 after 0 usecs
[    0.021425] calling  trace_init_flags_enter__newuname+0x0/0x12 @ 1
[    0.021429] initcall trace_init_flags_enter__newuname+0x0/0x12 returned 0 after 0 usecs
[    0.021433] calling  trace_init_flags_exit__setsid+0x0/0x12 @ 1
[    0.021437] initcall trace_init_flags_exit__setsid+0x0/0x12 returned 0 after 0 usecs
[    0.021442] calling  trace_init_flags_enter__setsid+0x0/0x12 @ 1
[    0.021446] initcall trace_init_flags_enter__setsid+0x0/0x12 returned 0 after 0 usecs
[    0.021450] calling  trace_init_flags_exit__getsid+0x0/0x12 @ 1
[    0.021454] initcall trace_init_flags_exit__getsid+0x0/0x12 returned 0 after 0 usecs
[    0.021459] calling  trace_init_flags_enter__getsid+0x0/0x12 @ 1
[    0.021463] initcall trace_init_flags_enter__getsid+0x0/0x12 returned 0 after 0 usecs
[    0.021467] calling  trace_init_flags_exit__getpgrp+0x0/0x12 @ 1
[    0.021471] initcall trace_init_flags_exit__getpgrp+0x0/0x12 returned 0 after 0 usecs
[    0.021476] calling  trace_init_flags_enter__getpgrp+0x0/0x12 @ 1
[    0.021480] initcall trace_init_flags_enter__getpgrp+0x0/0x12 returned 0 after 0 usecs
[    0.021484] calling  trace_init_flags_exit__getpgid+0x0/0x12 @ 1
[    0.021488] initcall trace_init_flags_exit__getpgid+0x0/0x12 returned 0 after 0 usecs
[    0.021493] calling  trace_init_flags_enter__getpgid+0x0/0x12 @ 1
[    0.021497] initcall trace_init_flags_enter__getpgid+0x0/0x12 returned 0 after 0 usecs
[    0.021502] calling  trace_init_flags_exit__setpgid+0x0/0x12 @ 1
[    0.021506] initcall trace_init_flags_exit__setpgid+0x0/0x12 returned 0 after 0 usecs
[    0.021510] calling  trace_init_flags_enter__setpgid+0x0/0x12 @ 1
[    0.021514] initcall trace_init_flags_enter__setpgid+0x0/0x12 returned 0 after 0 usecs
[    0.021519] calling  trace_init_flags_exit__times+0x0/0x12 @ 1
[    0.021523] initcall trace_init_flags_exit__times+0x0/0x12 returned 0 after 0 usecs
[    0.021527] calling  trace_init_flags_enter__times+0x0/0x12 @ 1
[    0.021531] initcall trace_init_flags_enter__times+0x0/0x12 returned 0 after 0 usecs
[    0.021536] calling  trace_init_flags_exit__setfsgid+0x0/0x12 @ 1
[    0.021540] initcall trace_init_flags_exit__setfsgid+0x0/0x12 returned 0 after 0 usecs
[    0.021545] calling  trace_init_flags_enter__setfsgid+0x0/0x12 @ 1
[    0.021549] initcall trace_init_flags_enter__setfsgid+0x0/0x12 returned 0 after 0 usecs
[    0.021553] calling  trace_init_flags_exit__setfsuid+0x0/0x12 @ 1
[    0.021557] initcall trace_init_flags_exit__setfsuid+0x0/0x12 returned 0 after 0 usecs
[    0.021562] calling  trace_init_flags_enter__setfsuid+0x0/0x12 @ 1
[    0.021566] initcall trace_init_flags_enter__setfsuid+0x0/0x12 returned 0 after 0 usecs
[    0.021570] calling  trace_init_flags_exit__getresgid+0x0/0x12 @ 1
[    0.021575] initcall trace_init_flags_exit__getresgid+0x0/0x12 returned 0 after 0 usecs
[    0.021579] calling  trace_init_flags_enter__getresgid+0x0/0x12 @ 1
[    0.021583] initcall trace_init_flags_enter__getresgid+0x0/0x12 returned 0 after 0 usecs
[    0.021588] calling  trace_init_flags_exit__setresgid+0x0/0x12 @ 1
[    0.021592] initcall trace_init_flags_exit__setresgid+0x0/0x12 returned 0 after 0 usecs
[    0.021597] calling  trace_init_flags_enter__setresgid+0x0/0x12 @ 1
[    0.021601] initcall trace_init_flags_enter__setresgid+0x0/0x12 returned 0 after 0 usecs
[    0.021605] calling  trace_init_flags_exit__getresuid+0x0/0x12 @ 1
[    0.021609] initcall trace_init_flags_exit__getresuid+0x0/0x12 returned 0 after 0 usecs
[    0.021614] calling  trace_init_flags_enter__getresuid+0x0/0x12 @ 1
[    0.021618] initcall trace_init_flags_enter__getresuid+0x0/0x12 returned 0 after 0 usecs
[    0.021623] calling  trace_init_flags_exit__setresuid+0x0/0x12 @ 1
[    0.021627] initcall trace_init_flags_exit__setresuid+0x0/0x12 returned 0 after 0 usecs
[    0.021631] calling  trace_init_flags_enter__setresuid+0x0/0x12 @ 1
[    0.021635] initcall trace_init_flags_enter__setresuid+0x0/0x12 returned 0 after 0 usecs
[    0.021640] calling  trace_init_flags_exit__setuid+0x0/0x12 @ 1
[    0.021644] initcall trace_init_flags_exit__setuid+0x0/0x12 returned 0 after 0 usecs
[    0.021648] calling  trace_init_flags_enter__setuid+0x0/0x12 @ 1
[    0.021652] initcall trace_init_flags_enter__setuid+0x0/0x12 returned 0 after 0 usecs
[    0.021657] calling  trace_init_flags_exit__setreuid+0x0/0x12 @ 1
[    0.021661] initcall trace_init_flags_exit__setreuid+0x0/0x12 returned 0 after 0 usecs
[    0.021665] calling  trace_init_flags_enter__setreuid+0x0/0x12 @ 1
[    0.021669] initcall trace_init_flags_enter__setreuid+0x0/0x12 returned 0 after 0 usecs
[    0.021674] calling  trace_init_flags_exit__setgid+0x0/0x12 @ 1
[    0.021678] initcall trace_init_flags_exit__setgid+0x0/0x12 returned 0 after 0 usecs
[    0.021682] calling  trace_init_flags_enter__setgid+0x0/0x12 @ 1
[    0.021686] initcall trace_init_flags_enter__setgid+0x0/0x12 returned 0 after 0 usecs
[    0.021691] calling  trace_init_flags_exit__setregid+0x0/0x12 @ 1
[    0.021695] initcall trace_init_flags_exit__setregid+0x0/0x12 returned 0 after 0 usecs
[    0.021700] calling  trace_init_flags_enter__setregid+0x0/0x12 @ 1
[    0.021703] initcall trace_init_flags_enter__setregid+0x0/0x12 returned 0 after 0 usecs
[    0.021708] calling  trace_init_flags_exit__reboot+0x0/0x12 @ 1
[    0.021712] initcall trace_init_flags_exit__reboot+0x0/0x12 returned 0 after 0 usecs
[    0.021717] calling  trace_init_flags_enter__reboot+0x0/0x12 @ 1
[    0.021720] initcall trace_init_flags_enter__reboot+0x0/0x12 returned 0 after 0 usecs
[    0.021725] calling  trace_init_flags_exit__getpriority+0x0/0x12 @ 1
[    0.021729] initcall trace_init_flags_exit__getpriority+0x0/0x12 returned 0 after 0 usecs
[    0.021734] calling  trace_init_flags_enter__getpriority+0x0/0x12 @ 1
[    0.021738] initcall trace_init_flags_enter__getpriority+0x0/0x12 returned 0 after 0 usecs
[    0.021742] calling  trace_init_flags_exit__setpriority+0x0/0x12 @ 1
[    0.021746] initcall trace_init_flags_exit__setpriority+0x0/0x12 returned 0 after 0 usecs
[    0.021751] calling  trace_init_flags_enter__setpriority+0x0/0x12 @ 1
[    0.021755] initcall trace_init_flags_enter__setpriority+0x0/0x12 returned 0 after 0 usecs
[    0.021759] calling  init_workqueues+0x0/0x28d @ 1
[    0.021821] initcall init_workqueues+0x0/0x28d returned 0 after 0 usecs
[    0.021825] calling  trace_init_flags_exit__clock_nanosleep+0x0/0x12 @ 1
[    0.021829] initcall trace_init_flags_exit__clock_nanosleep+0x0/0x12 returned 0 after 0 usecs
[    0.021833] calling  trace_init_flags_enter__clock_nanosleep+0x0/0x12 @ 1
[    0.021837] initcall trace_init_flags_enter__clock_nanosleep+0x0/0x12 returned 0 after 0 usecs
[    0.021842] calling  trace_init_flags_exit__clock_getres+0x0/0x12 @ 1
[    0.021846] initcall trace_init_flags_exit__clock_getres+0x0/0x12 returned 0 after 0 usecs
[    0.021850] calling  trace_init_flags_enter__clock_getres+0x0/0x12 @ 1
[    0.021854] initcall trace_init_flags_enter__clock_getres+0x0/0x12 returned 0 after 0 usecs
[    0.021858] calling  trace_init_flags_exit__clock_gettime+0x0/0x12 @ 1
[    0.021862] initcall trace_init_flags_exit__clock_gettime+0x0/0x12 returned 0 after 0 usecs
[    0.021866] calling  trace_init_flags_enter__clock_gettime+0x0/0x12 @ 1
[    0.021870] initcall trace_init_flags_enter__clock_gettime+0x0/0x12 returned 0 after 0 usecs
[    0.021874] calling  trace_init_flags_exit__clock_settime+0x0/0x12 @ 1
[    0.021878] initcall trace_init_flags_exit__clock_settime+0x0/0x12 returned 0 after 0 usecs
[    0.021882] calling  trace_init_flags_enter__clock_settime+0x0/0x12 @ 1
[    0.021886] initcall trace_init_flags_enter__clock_settime+0x0/0x12 returned 0 after 0 usecs
[    0.021891] calling  trace_init_flags_exit__timer_delete+0x0/0x12 @ 1
[    0.021894] initcall trace_init_flags_exit__timer_delete+0x0/0x12 returned 0 after 0 usecs
[    0.021899] calling  trace_init_flags_enter__timer_delete+0x0/0x12 @ 1
[    0.021902] initcall trace_init_flags_enter__timer_delete+0x0/0x12 returned 0 after 0 usecs
[    0.021907] calling  trace_init_flags_exit__timer_settime+0x0/0x12 @ 1
[    0.021911] initcall trace_init_flags_exit__timer_settime+0x0/0x12 returned 0 after 0 usecs
[    0.021915] calling  trace_init_flags_enter__timer_settime+0x0/0x12 @ 1
[    0.021919] initcall trace_init_flags_enter__timer_settime+0x0/0x12 returned 0 after 0 usecs
[    0.021923] calling  trace_init_flags_exit__timer_getoverrun+0x0/0x12 @ 1
[    0.021927] initcall trace_init_flags_exit__timer_getoverrun+0x0/0x12 returned 0 after 0 usecs
[    0.021931] calling  trace_init_flags_enter__timer_getoverrun+0x0/0x12 @ 1
[    0.021935] initcall trace_init_flags_enter__timer_getoverrun+0x0/0x12 returned 0 after 0 usecs
[    0.021939] calling  trace_init_flags_exit__timer_gettime+0x0/0x12 @ 1
[    0.021943] initcall trace_init_flags_exit__timer_gettime+0x0/0x12 returned 0 after 0 usecs
[    0.021947] calling  trace_init_flags_enter__timer_gettime+0x0/0x12 @ 1
[    0.021951] initcall trace_init_flags_enter__timer_gettime+0x0/0x12 returned 0 after 0 usecs
[    0.021956] calling  trace_init_flags_exit__timer_create+0x0/0x12 @ 1
[    0.021959] initcall trace_init_flags_exit__timer_create+0x0/0x12 returned 0 after 0 usecs
[    0.021963] calling  trace_init_flags_enter__timer_create+0x0/0x12 @ 1
[    0.021967] initcall trace_init_flags_enter__timer_create+0x0/0x12 returned 0 after 0 usecs
[    0.021972] calling  trace_init_flags_exit__nanosleep+0x0/0x12 @ 1
[    0.021975] initcall trace_init_flags_exit__nanosleep+0x0/0x12 returned 0 after 0 usecs
[    0.021980] calling  trace_init_flags_enter__nanosleep+0x0/0x12 @ 1
[    0.021983] initcall trace_init_flags_enter__nanosleep+0x0/0x12 returned 0 after 0 usecs
[    0.021988] calling  trace_init_flags_exit__setgroups+0x0/0x12 @ 1
[    0.021992] initcall trace_init_flags_exit__setgroups+0x0/0x12 returned 0 after 0 usecs
[    0.021996] calling  trace_init_flags_enter__setgroups+0x0/0x12 @ 1
[    0.022000] initcall trace_init_flags_enter__setgroups+0x0/0x12 returned 0 after 0 usecs
[    0.022004] calling  trace_init_flags_exit__getgroups+0x0/0x12 @ 1
[    0.022008] initcall trace_init_flags_exit__getgroups+0x0/0x12 returned 0 after 0 usecs
[    0.022012] calling  trace_init_flags_enter__getgroups+0x0/0x12 @ 1
[    0.022015] initcall trace_init_flags_enter__getgroups+0x0/0x12 returned 0 after 0 usecs
[    0.022020] calling  trace_init_flags_exit__futex+0x0/0x12 @ 1
[    0.022024] initcall trace_init_flags_exit__futex+0x0/0x12 returned 0 after 0 usecs
[    0.022028] calling  trace_init_flags_enter__futex+0x0/0x12 @ 1
[    0.022032] initcall trace_init_flags_enter__futex+0x0/0x12 returned 0 after 0 usecs
[    0.022036] calling  trace_init_flags_exit__get_robust_list+0x0/0x12 @ 1
[    0.022040] initcall trace_init_flags_exit__get_robust_list+0x0/0x12 returned 0 after 0 usecs
[    0.022044] calling  trace_init_flags_enter__get_robust_list+0x0/0x12 @ 1
[    0.022048] initcall trace_init_flags_enter__get_robust_list+0x0/0x12 returned 0 after 0 usecs
[    0.022053] calling  trace_init_flags_exit__set_robust_list+0x0/0x12 @ 1
[    0.022057] initcall trace_init_flags_exit__set_robust_list+0x0/0x12 returned 0 after 0 usecs
[    0.022061] calling  trace_init_flags_enter__set_robust_list+0x0/0x12 @ 1
[    0.022065] initcall trace_init_flags_enter__set_robust_list+0x0/0x12 returned 0 after 0 usecs
[    0.022071] calling  init_call_single_data+0x0/0x8f @ 1
[    0.022076] initcall init_call_single_data+0x0/0x8f returned 0 after 0 usecs
[    0.022080] calling  trace_init_flags_exit__getegid16+0x0/0x12 @ 1
[    0.022084] initcall trace_init_flags_exit__getegid16+0x0/0x12 returned 0 after 0 usecs
[    0.022088] calling  trace_init_flags_enter__getegid16+0x0/0x12 @ 1
[    0.022092] initcall trace_init_flags_enter__getegid16+0x0/0x12 returned 0 after 0 usecs
[    0.022097] calling  trace_init_flags_exit__getgid16+0x0/0x12 @ 1
[    0.022100] initcall trace_init_flags_exit__getgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022105] calling  trace_init_flags_enter__getgid16+0x0/0x12 @ 1
[    0.022109] initcall trace_init_flags_enter__getgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022113] calling  trace_init_flags_exit__geteuid16+0x0/0x12 @ 1
[    0.022117] initcall trace_init_flags_exit__geteuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022121] calling  trace_init_flags_enter__geteuid16+0x0/0x12 @ 1
[    0.022125] initcall trace_init_flags_enter__geteuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022130] calling  trace_init_flags_exit__getuid16+0x0/0x12 @ 1
[    0.022133] initcall trace_init_flags_exit__getuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022138] calling  trace_init_flags_enter__getuid16+0x0/0x12 @ 1
[    0.022142] initcall trace_init_flags_enter__getuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022146] calling  trace_init_flags_exit__setgroups16+0x0/0x12 @ 1
[    0.022150] initcall trace_init_flags_exit__setgroups16+0x0/0x12 returned 0 after 0 usecs
[    0.022154] calling  trace_init_flags_enter__setgroups16+0x0/0x12 @ 1
[    0.022158] initcall trace_init_flags_enter__setgroups16+0x0/0x12 returned 0 after 0 usecs
[    0.022163] calling  trace_init_flags_exit__getgroups16+0x0/0x12 @ 1
[    0.022167] initcall trace_init_flags_exit__getgroups16+0x0/0x12 returned 0 after 0 usecs
[    0.022171] calling  trace_init_flags_enter__getgroups16+0x0/0x12 @ 1
[    0.022175] initcall trace_init_flags_enter__getgroups16+0x0/0x12 returned 0 after 0 usecs
[    0.022179] calling  trace_init_flags_exit__setfsgid16+0x0/0x12 @ 1
[    0.022183] initcall trace_init_flags_exit__setfsgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022188] calling  trace_init_flags_enter__setfsgid16+0x0/0x12 @ 1
[    0.022191] initcall trace_init_flags_enter__setfsgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022196] calling  trace_init_flags_exit__setfsuid16+0x0/0x12 @ 1
[    0.022200] initcall trace_init_flags_exit__setfsuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022204] calling  trace_init_flags_enter__setfsuid16+0x0/0x12 @ 1
[    0.022208] initcall trace_init_flags_enter__setfsuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022212] calling  trace_init_flags_exit__getresgid16+0x0/0x12 @ 1
[    0.022216] initcall trace_init_flags_exit__getresgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022221] calling  trace_init_flags_enter__getresgid16+0x0/0x12 @ 1
[    0.022225] initcall trace_init_flags_enter__getresgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022229] calling  trace_init_flags_exit__setresgid16+0x0/0x12 @ 1
[    0.022233] initcall trace_init_flags_exit__setresgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022238] calling  trace_init_flags_enter__setresgid16+0x0/0x12 @ 1
[    0.022241] initcall trace_init_flags_enter__setresgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022246] calling  trace_init_flags_exit__getresuid16+0x0/0x12 @ 1
[    0.022250] initcall trace_init_flags_exit__getresuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022254] calling  trace_init_flags_enter__getresuid16+0x0/0x12 @ 1
[    0.022258] initcall trace_init_flags_enter__getresuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022263] calling  trace_init_flags_exit__setresuid16+0x0/0x12 @ 1
[    0.022266] initcall trace_init_flags_exit__setresuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022271] calling  trace_init_flags_enter__setresuid16+0x0/0x12 @ 1
[    0.022275] initcall trace_init_flags_enter__setresuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022279] calling  trace_init_flags_exit__setuid16+0x0/0x12 @ 1
[    0.022283] initcall trace_init_flags_exit__setuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022287] calling  trace_init_flags_enter__setuid16+0x0/0x12 @ 1
[    0.022291] initcall trace_init_flags_enter__setuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022295] calling  trace_init_flags_exit__setreuid16+0x0/0x12 @ 1
[    0.022299] initcall trace_init_flags_exit__setreuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022304] calling  trace_init_flags_enter__setreuid16+0x0/0x12 @ 1
[    0.022307] initcall trace_init_flags_enter__setreuid16+0x0/0x12 returned 0 after 0 usecs
[    0.022312] calling  trace_init_flags_exit__setgid16+0x0/0x12 @ 1
[    0.022316] initcall trace_init_flags_exit__setgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022320] calling  trace_init_flags_enter__setgid16+0x0/0x12 @ 1
[    0.022324] initcall trace_init_flags_enter__setgid16+0x0/0x12 returned 0 after 0 usecs
[    0.022328] calling  trace_init_flags_exit__setregid16+0x0/0x12 @ 1
[    0.022332] initcall trace_init_flags_exit__setregid16+0x0/0x12 returned 0 after 0 usecs
[    0.022336] calling  trace_init_flags_enter__setregid16+0x0/0x12 @ 1
[    0.022340] initcall trace_init_flags_enter__setregid16+0x0/0x12 returned 0 after 0 usecs
[    0.022344] calling  trace_init_flags_exit__fchown16+0x0/0x12 @ 1
[    0.022348] initcall trace_init_flags_exit__fchown16+0x0/0x12 returned 0 after 0 usecs
[    0.022352] calling  trace_init_flags_enter__fchown16+0x0/0x12 @ 1
[    0.022356] initcall trace_init_flags_enter__fchown16+0x0/0x12 returned 0 after 0 usecs
[    0.022360] calling  trace_init_flags_exit__lchown16+0x0/0x12 @ 1
[    0.022364] initcall trace_init_flags_exit__lchown16+0x0/0x12 returned 0 after 0 usecs
[    0.022368] calling  trace_init_flags_enter__lchown16+0x0/0x12 @ 1
[    0.022372] initcall trace_init_flags_enter__lchown16+0x0/0x12 returned 0 after 0 usecs
[    0.022376] calling  trace_init_flags_exit__chown16+0x0/0x12 @ 1
[    0.022380] initcall trace_init_flags_exit__chown16+0x0/0x12 returned 0 after 0 usecs
[    0.022384] calling  trace_init_flags_enter__chown16+0x0/0x12 @ 1
[    0.022388] initcall trace_init_flags_enter__chown16+0x0/0x12 returned 0 after 0 usecs
[    0.022393] calling  trace_init_flags_exit__init_module+0x0/0x12 @ 1
[    0.022396] initcall trace_init_flags_exit__init_module+0x0/0x12 returned 0 after 0 usecs
[    0.022401] calling  trace_init_flags_enter__init_module+0x0/0x12 @ 1
[    0.022405] initcall trace_init_flags_enter__init_module+0x0/0x12 returned 0 after 0 usecs
[    0.022409] calling  trace_init_flags_exit__delete_module+0x0/0x12 @ 1
[    0.022413] initcall trace_init_flags_exit__delete_module+0x0/0x12 returned 0 after 0 usecs
[    0.022418] calling  trace_init_flags_enter__delete_module+0x0/0x12 @ 1
[    0.022422] initcall trace_init_flags_enter__delete_module+0x0/0x12 returned 0 after 0 usecs
[    0.022426] calling  trace_init_flags_exit__acct+0x0/0x12 @ 1
[    0.022430] initcall trace_init_flags_exit__acct+0x0/0x12 returned 0 after 0 usecs
[    0.022435] calling  trace_init_flags_enter__acct+0x0/0x12 @ 1
[    0.022438] initcall trace_init_flags_enter__acct+0x0/0x12 returned 0 after 0 usecs
[    0.022443] calling  trace_init_flags_exit__kexec_load+0x0/0x12 @ 1
[    0.022447] initcall trace_init_flags_exit__kexec_load+0x0/0x12 returned 0 after 0 usecs
[    0.022451] calling  trace_init_flags_enter__kexec_load+0x0/0x12 @ 1
[    0.022455] initcall trace_init_flags_enter__kexec_load+0x0/0x12 returned 0 after 0 usecs
[    0.022460] calling  cpu_stop_init+0x0/0xad @ 1
[    0.022483] initcall cpu_stop_init+0x0/0xad returned 0 after 0 usecs
[    0.022487] calling  relay_init+0x0/0x14 @ 1
[    0.022490] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.022494] calling  tracer_alloc_buffers+0x0/0x1c8 @ 1
[    0.022532] initcall tracer_alloc_buffers+0x0/0x1c8 returned 0 after 0 usecs
[    0.022536] calling  init_trace_printk+0x0/0x12 @ 1
[    0.022540] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.022544] calling  trace_init_flags_exit__perf_event_open+0x0/0x12 @ 1
[    0.022548] initcall trace_init_flags_exit__perf_event_open+0x0/0x12 returned 0 after 0 usecs
[    0.022553] calling  trace_init_flags_enter__perf_event_open+0x0/0x12 @ 1
[    0.022557] initcall trace_init_flags_enter__perf_event_open+0x0/0x12 returned 0 after 0 usecs
[    0.022562] calling  trace_init_flags_exit__remap_file_pages+0x0/0x12 @ 1
[    0.022566] initcall trace_init_flags_exit__remap_file_pages+0x0/0x12 returned 0 after 0 usecs
[    0.022570] calling  trace_init_flags_enter__remap_file_pages+0x0/0x12 @ 1
[    0.022574] initcall trace_init_flags_enter__remap_file_pages+0x0/0x12 returned 0 after 0 usecs
[    0.022578] calling  trace_init_flags_exit__madvise+0x0/0x12 @ 1
[    0.022582] initcall trace_init_flags_exit__madvise+0x0/0x12 returned 0 after 0 usecs
[    0.022586] calling  trace_init_flags_enter__madvise+0x0/0x12 @ 1
[    0.022590] initcall trace_init_flags_enter__madvise+0x0/0x12 returned 0 after 0 usecs
[    0.022594] calling  trace_init_flags_exit__mincore+0x0/0x12 @ 1
[    0.022597] initcall trace_init_flags_exit__mincore+0x0/0x12 returned 0 after 0 usecs
[    0.022601] calling  trace_init_flags_enter__mincore+0x0/0x12 @ 1
[    0.022605] initcall trace_init_flags_enter__mincore+0x0/0x12 returned 0 after 0 usecs
[    0.022609] calling  trace_init_flags_exit__munlockall+0x0/0x12 @ 1
[    0.022613] initcall trace_init_flags_exit__munlockall+0x0/0x12 returned 0 after 0 usecs
[    0.022617] calling  trace_init_flags_enter__munlockall+0x0/0x12 @ 1
[    0.022621] initcall trace_init_flags_enter__munlockall+0x0/0x12 returned 0 after 0 usecs
[    0.022625] calling  trace_init_flags_exit__mlockall+0x0/0x12 @ 1
[    0.022629] initcall trace_init_flags_exit__mlockall+0x0/0x12 returned 0 after 0 usecs
[    0.022633] calling  trace_init_flags_enter__mlockall+0x0/0x12 @ 1
[    0.022636] initcall trace_init_flags_enter__mlockall+0x0/0x12 returned 0 after 0 usecs
[    0.022641] calling  trace_init_flags_exit__munlock+0x0/0x12 @ 1
[    0.022644] initcall trace_init_flags_exit__munlock+0x0/0x12 returned 0 after 0 usecs
[    0.022648] calling  trace_init_flags_enter__munlock+0x0/0x12 @ 1
[    0.022652] initcall trace_init_flags_enter__munlock+0x0/0x12 returned 0 after 0 usecs
[    0.022656] calling  trace_init_flags_exit__mlock+0x0/0x12 @ 1
[    0.022659] initcall trace_init_flags_exit__mlock+0x0/0x12 returned 0 after 0 usecs
[    0.022664] calling  trace_init_flags_enter__mlock+0x0/0x12 @ 1
[    0.022667] initcall trace_init_flags_enter__mlock+0x0/0x12 returned 0 after 0 usecs
[    0.022671] calling  trace_init_flags_exit__munmap+0x0/0x12 @ 1
[    0.022675] initcall trace_init_flags_exit__munmap+0x0/0x12 returned 0 after 0 usecs
[    0.022679] calling  trace_init_flags_enter__munmap+0x0/0x12 @ 1
[    0.022682] initcall trace_init_flags_enter__munmap+0x0/0x12 returned 0 after 0 usecs
[    0.022687] calling  trace_init_flags_exit__mmap_pgoff+0x0/0x12 @ 1
[    0.022691] initcall trace_init_flags_exit__mmap_pgoff+0x0/0x12 returned 0 after 0 usecs
[    0.022695] calling  trace_init_flags_enter__mmap_pgoff+0x0/0x12 @ 1
[    0.022699] initcall trace_init_flags_enter__mmap_pgoff+0x0/0x12 returned 0 after 0 usecs
[    0.022703] calling  trace_init_flags_exit__brk+0x0/0x12 @ 1
[    0.022706] initcall trace_init_flags_exit__brk+0x0/0x12 returned 0 after 0 usecs
[    0.022710] calling  trace_init_flags_enter__brk+0x0/0x12 @ 1
[    0.022714] initcall trace_init_flags_enter__brk+0x0/0x12 returned 0 after 0 usecs
[    0.022718] calling  trace_init_flags_exit__mprotect+0x0/0x12 @ 1
[    0.022721] initcall trace_init_flags_exit__mprotect+0x0/0x12 returned 0 after 0 usecs
[    0.022726] calling  trace_init_flags_enter__mprotect+0x0/0x12 @ 1
[    0.022729] initcall trace_init_flags_enter__mprotect+0x0/0x12 returned 0 after 0 usecs
[    0.022734] calling  trace_init_flags_exit__mremap+0x0/0x12 @ 1
[    0.022737] initcall trace_init_flags_exit__mremap+0x0/0x12 returned 0 after 0 usecs
[    0.022741] calling  trace_init_flags_enter__mremap+0x0/0x12 @ 1
[    0.022745] initcall trace_init_flags_enter__mremap+0x0/0x12 returned 0 after 0 usecs
[    0.022749] calling  trace_init_flags_exit__msync+0x0/0x12 @ 1
[    0.022753] initcall trace_init_flags_exit__msync+0x0/0x12 returned 0 after 0 usecs
[    0.022757] calling  trace_init_flags_enter__msync+0x0/0x12 @ 1
[    0.022760] initcall trace_init_flags_enter__msync+0x0/0x12 returned 0 after 0 usecs
[    0.022765] calling  trace_init_flags_exit__swapon+0x0/0x12 @ 1
[    0.022769] initcall trace_init_flags_exit__swapon+0x0/0x12 returned 0 after 0 usecs
[    0.022773] calling  trace_init_flags_enter__swapon+0x0/0x12 @ 1
[    0.022777] initcall trace_init_flags_enter__swapon+0x0/0x12 returned 0 after 0 usecs
[    0.022781] calling  trace_init_flags_exit__swapoff+0x0/0x12 @ 1
[    0.022785] initcall trace_init_flags_exit__swapoff+0x0/0x12 returned 0 after 0 usecs
[    0.022789] calling  trace_init_flags_enter__swapoff+0x0/0x12 @ 1
[    0.022793] initcall trace_init_flags_enter__swapoff+0x0/0x12 returned 0 after 0 usecs
[    0.022797] calling  trace_init_flags_exit__get_mempolicy+0x0/0x12 @ 1
[    0.022801] initcall trace_init_flags_exit__get_mempolicy+0x0/0x12 returned 0 after 0 usecs
[    0.022805] calling  trace_init_flags_enter__get_mempolicy+0x0/0x12 @ 1
[    0.022809] initcall trace_init_flags_enter__get_mempolicy+0x0/0x12 returned 0 after 0 usecs
[    0.022814] calling  trace_init_flags_exit__migrate_pages+0x0/0x12 @ 1
[    0.022818] initcall trace_init_flags_exit__migrate_pages+0x0/0x12 returned 0 after 0 usecs
[    0.022822] calling  trace_init_flags_enter__migrate_pages+0x0/0x12 @ 1
[    0.022826] initcall trace_init_flags_enter__migrate_pages+0x0/0x12 returned 0 after 0 usecs
[    0.022830] calling  trace_init_flags_exit__set_mempolicy+0x0/0x12 @ 1
[    0.022834] initcall trace_init_flags_exit__set_mempolicy+0x0/0x12 returned 0 after 0 usecs
[    0.022838] calling  trace_init_flags_enter__set_mempolicy+0x0/0x12 @ 1
[    0.022842] initcall trace_init_flags_enter__set_mempolicy+0x0/0x12 returned 0 after 0 usecs
[    0.022847] calling  trace_init_flags_exit__mbind+0x0/0x12 @ 1
[    0.022850] initcall trace_init_flags_exit__mbind+0x0/0x12 returned 0 after 0 usecs
[    0.022855] calling  trace_init_flags_enter__mbind+0x0/0x12 @ 1
[    0.022858] initcall trace_init_flags_enter__mbind+0x0/0x12 returned 0 after 0 usecs
[    0.022863] calling  trace_init_flags_exit__move_pages+0x0/0x12 @ 1
[    0.022867] initcall trace_init_flags_exit__move_pages+0x0/0x12 returned 0 after 0 usecs
[    0.022871] calling  trace_init_flags_enter__move_pages+0x0/0x12 @ 1
[    0.022875] initcall trace_init_flags_enter__move_pages+0x0/0x12 returned 0 after 0 usecs
[    0.022879] calling  trace_init_flags_exit__vhangup+0x0/0x12 @ 1
[    0.022883] initcall trace_init_flags_exit__vhangup+0x0/0x12 returned 0 after 0 usecs
[    0.022888] calling  trace_init_flags_enter__vhangup+0x0/0x12 @ 1
[    0.022892] initcall trace_init_flags_enter__vhangup+0x0/0x12 returned 0 after 0 usecs
[    0.022896] calling  trace_init_flags_exit__close+0x0/0x12 @ 1
[    0.022900] initcall trace_init_flags_exit__close+0x0/0x12 returned 0 after 0 usecs
[    0.022904] calling  trace_init_flags_enter__close+0x0/0x12 @ 1
[    0.022908] initcall trace_init_flags_enter__close+0x0/0x12 returned 0 after 0 usecs
[    0.022912] calling  trace_init_flags_exit__creat+0x0/0x12 @ 1
[    0.022916] initcall trace_init_flags_exit__creat+0x0/0x12 returned 0 after 0 usecs
[    0.022920] calling  trace_init_flags_enter__creat+0x0/0x12 @ 1
[    0.022924] initcall trace_init_flags_enter__creat+0x0/0x12 returned 0 after 0 usecs
[    0.022928] calling  trace_init_flags_exit__openat+0x0/0x12 @ 1
[    0.022932] initcall trace_init_flags_exit__openat+0x0/0x12 returned 0 after 0 usecs
[    0.022937] calling  trace_init_flags_enter__openat+0x0/0x12 @ 1
[    0.022940] initcall trace_init_flags_enter__openat+0x0/0x12 returned 0 after 0 usecs
[    0.022945] calling  trace_init_flags_exit__open+0x0/0x12 @ 1
[    0.022948] initcall trace_init_flags_exit__open+0x0/0x12 returned 0 after 0 usecs
[    0.022953] calling  trace_init_flags_enter__open+0x0/0x12 @ 1
[    0.022956] initcall trace_init_flags_enter__open+0x0/0x12 returned 0 after 0 usecs
[    0.022961] calling  trace_init_flags_exit__fchown+0x0/0x12 @ 1
[    0.022964] initcall trace_init_flags_exit__fchown+0x0/0x12 returned 0 after 0 usecs
[    0.022969] calling  trace_init_flags_enter__fchown+0x0/0x12 @ 1
[    0.022972] initcall trace_init_flags_enter__fchown+0x0/0x12 returned 0 after 0 usecs
[    0.022977] calling  trace_init_flags_exit__lchown+0x0/0x12 @ 1
[    0.022981] initcall trace_init_flags_exit__lchown+0x0/0x12 returned 0 after 0 usecs
[    0.022985] calling  trace_init_flags_enter__lchown+0x0/0x12 @ 1
[    0.022989] initcall trace_init_flags_enter__lchown+0x0/0x12 returned 0 after 0 usecs
[    0.022993] calling  trace_init_flags_exit__fchownat+0x0/0x12 @ 1
[    0.022997] initcall trace_init_flags_exit__fchownat+0x0/0x12 returned 0 after 0 usecs
[    0.023001] calling  trace_init_flags_enter__fchownat+0x0/0x12 @ 1
[    0.023005] initcall trace_init_flags_enter__fchownat+0x0/0x12 returned 0 after 0 usecs
[    0.023009] calling  trace_init_flags_exit__chown+0x0/0x12 @ 1
[    0.023013] initcall trace_init_flags_exit__chown+0x0/0x12 returned 0 after 0 usecs
[    0.023017] calling  trace_init_flags_enter__chown+0x0/0x12 @ 1
[    0.023021] initcall trace_init_flags_enter__chown+0x0/0x12 returned 0 after 0 usecs
[    0.023025] calling  trace_init_flags_exit__chmod+0x0/0x12 @ 1
[    0.023029] initcall trace_init_flags_exit__chmod+0x0/0x12 returned 0 after 0 usecs
[    0.023033] calling  trace_init_flags_enter__chmod+0x0/0x12 @ 1
[    0.023037] initcall trace_init_flags_enter__chmod+0x0/0x12 returned 0 after 0 usecs
[    0.023041] calling  trace_init_flags_exit__fchmodat+0x0/0x12 @ 1
[    0.023045] initcall trace_init_flags_exit__fchmodat+0x0/0x12 returned 0 after 0 usecs
[    0.023050] calling  trace_init_flags_enter__fchmodat+0x0/0x12 @ 1
[    0.023053] initcall trace_init_flags_enter__fchmodat+0x0/0x12 returned 0 after 0 usecs
[    0.023058] calling  trace_init_flags_exit__fchmod+0x0/0x12 @ 1
[    0.023061] initcall trace_init_flags_exit__fchmod+0x0/0x12 returned 0 after 0 usecs
[    0.023066] calling  trace_init_flags_enter__fchmod+0x0/0x12 @ 1
[    0.023069] initcall trace_init_flags_enter__fchmod+0x0/0x12 returned 0 after 0 usecs
[    0.023074] calling  trace_init_flags_exit__chroot+0x0/0x12 @ 1
[    0.023077] initcall trace_init_flags_exit__chroot+0x0/0x12 returned 0 after 0 usecs
[    0.023082] calling  trace_init_flags_enter__chroot+0x0/0x12 @ 1
[    0.023085] initcall trace_init_flags_enter__chroot+0x0/0x12 returned 0 after 0 usecs
[    0.023090] calling  trace_init_flags_exit__fchdir+0x0/0x12 @ 1
[    0.023094] initcall trace_init_flags_exit__fchdir+0x0/0x12 returned 0 after 0 usecs
[    0.023098] calling  trace_init_flags_enter__fchdir+0x0/0x12 @ 1
[    0.023102] initcall trace_init_flags_enter__fchdir+0x0/0x12 returned 0 after 0 usecs
[    0.023106] calling  trace_init_flags_exit__chdir+0x0/0x12 @ 1
[    0.023110] initcall trace_init_flags_exit__chdir+0x0/0x12 returned 0 after 0 usecs
[    0.023114] calling  trace_init_flags_enter__chdir+0x0/0x12 @ 1
[    0.023118] initcall trace_init_flags_enter__chdir+0x0/0x12 returned 0 after 0 usecs
[    0.023122] calling  trace_init_flags_exit__access+0x0/0x12 @ 1
[    0.023126] initcall trace_init_flags_exit__access+0x0/0x12 returned 0 after 0 usecs
[    0.023130] calling  trace_init_flags_enter__access+0x0/0x12 @ 1
[    0.023134] initcall trace_init_flags_enter__access+0x0/0x12 returned 0 after 0 usecs
[    0.023138] calling  trace_init_flags_exit__faccessat+0x0/0x12 @ 1
[    0.023142] initcall trace_init_flags_exit__faccessat+0x0/0x12 returned 0 after 0 usecs
[    0.023146] calling  trace_init_flags_enter__faccessat+0x0/0x12 @ 1
[    0.023150] initcall trace_init_flags_enter__faccessat+0x0/0x12 returned 0 after 0 usecs
[    0.023154] calling  trace_init_flags_exit__ftruncate+0x0/0x12 @ 1
[    0.023158] initcall trace_init_flags_exit__ftruncate+0x0/0x12 returned 0 after 0 usecs
[    0.023163] calling  trace_init_flags_enter__ftruncate+0x0/0x12 @ 1
[    0.023166] initcall trace_init_flags_enter__ftruncate+0x0/0x12 returned 0 after 0 usecs
[    0.023171] calling  trace_init_flags_exit__truncate+0x0/0x12 @ 1
[    0.023174] initcall trace_init_flags_exit__truncate+0x0/0x12 returned 0 after 0 usecs
[    0.023179] calling  trace_init_flags_enter__truncate+0x0/0x12 @ 1
[    0.023182] initcall trace_init_flags_enter__truncate+0x0/0x12 returned 0 after 0 usecs
[    0.023187] calling  trace_init_flags_exit__sendfile64+0x0/0x12 @ 1
[    0.023191] initcall trace_init_flags_exit__sendfile64+0x0/0x12 returned 0 after 0 usecs
[    0.023195] calling  trace_init_flags_enter__sendfile64+0x0/0x12 @ 1
[    0.023199] initcall trace_init_flags_enter__sendfile64+0x0/0x12 returned 0 after 0 usecs
[    0.023204] calling  trace_init_flags_exit__sendfile+0x0/0x12 @ 1
[    0.023208] initcall trace_init_flags_exit__sendfile+0x0/0x12 returned 0 after 0 usecs
[    0.023212] calling  trace_init_flags_enter__sendfile+0x0/0x12 @ 1
[    0.023216] initcall trace_init_flags_enter__sendfile+0x0/0x12 returned 0 after 0 usecs
[    0.023220] calling  trace_init_flags_exit__pwritev+0x0/0x12 @ 1
[    0.023224] initcall trace_init_flags_exit__pwritev+0x0/0x12 returned 0 after 0 usecs
[    0.023229] calling  trace_init_flags_enter__pwritev+0x0/0x12 @ 1
[    0.023233] initcall trace_init_flags_enter__pwritev+0x0/0x12 returned 0 after 0 usecs
[    0.023237] calling  trace_init_flags_exit__preadv+0x0/0x12 @ 1
[    0.023241] initcall trace_init_flags_exit__preadv+0x0/0x12 returned 0 after 0 usecs
[    0.023245] calling  trace_init_flags_enter__preadv+0x0/0x12 @ 1
[    0.023249] initcall trace_init_flags_enter__preadv+0x0/0x12 returned 0 after 0 usecs
[    0.023253] calling  trace_init_flags_exit__writev+0x0/0x12 @ 1
[    0.023257] initcall trace_init_flags_exit__writev+0x0/0x12 returned 0 after 0 usecs
[    0.023262] calling  trace_init_flags_enter__writev+0x0/0x12 @ 1
[    0.023265] initcall trace_init_flags_enter__writev+0x0/0x12 returned 0 after 0 usecs
[    0.023270] calling  trace_init_flags_exit__readv+0x0/0x12 @ 1
[    0.023273] initcall trace_init_flags_exit__readv+0x0/0x12 returned 0 after 0 usecs
[    0.023278] calling  trace_init_flags_enter__readv+0x0/0x12 @ 1
[    0.023282] initcall trace_init_flags_enter__readv+0x0/0x12 returned 0 after 0 usecs
[    0.023286] calling  trace_init_flags_exit__write+0x0/0x12 @ 1
[    0.023290] initcall trace_init_flags_exit__write+0x0/0x12 returned 0 after 0 usecs
[    0.023294] calling  trace_init_flags_enter__write+0x0/0x12 @ 1
[    0.023298] initcall trace_init_flags_enter__write+0x0/0x12 returned 0 after 0 usecs
[    0.023302] calling  trace_init_flags_exit__read+0x0/0x12 @ 1
[    0.023306] initcall trace_init_flags_exit__read+0x0/0x12 returned 0 after 0 usecs
[    0.023310] calling  trace_init_flags_enter__read+0x0/0x12 @ 1
[    0.023314] initcall trace_init_flags_enter__read+0x0/0x12 returned 0 after 0 usecs
[    0.023318] calling  trace_init_flags_exit__llseek+0x0/0x12 @ 1
[    0.023322] initcall trace_init_flags_exit__llseek+0x0/0x12 returned 0 after 0 usecs
[    0.023326] calling  trace_init_flags_enter__llseek+0x0/0x12 @ 1
[    0.023330] initcall trace_init_flags_enter__llseek+0x0/0x12 returned 0 after 0 usecs
[    0.023335] calling  trace_init_flags_exit__lseek+0x0/0x12 @ 1
[    0.023338] initcall trace_init_flags_exit__lseek+0x0/0x12 returned 0 after 0 usecs
[    0.023343] calling  trace_init_flags_enter__lseek+0x0/0x12 @ 1
[    0.023346] initcall trace_init_flags_enter__lseek+0x0/0x12 returned 0 after 0 usecs
[    0.023351] calling  trace_init_flags_exit__readlink+0x0/0x12 @ 1
[    0.023355] initcall trace_init_flags_exit__readlink+0x0/0x12 returned 0 after 0 usecs
[    0.023360] calling  trace_init_flags_enter__readlink+0x0/0x12 @ 1
[    0.023364] initcall trace_init_flags_enter__readlink+0x0/0x12 returned 0 after 0 usecs
[    0.023368] calling  trace_init_flags_exit__readlinkat+0x0/0x12 @ 1
[    0.023372] initcall trace_init_flags_exit__readlinkat+0x0/0x12 returned 0 after 0 usecs
[    0.023376] calling  trace_init_flags_enter__readlinkat+0x0/0x12 @ 1
[    0.023380] initcall trace_init_flags_enter__readlinkat+0x0/0x12 returned 0 after 0 usecs
[    0.023385] calling  trace_init_flags_exit__newfstat+0x0/0x12 @ 1
[    0.023389] initcall trace_init_flags_exit__newfstat+0x0/0x12 returned 0 after 0 usecs
[    0.023393] calling  trace_init_flags_enter__newfstat+0x0/0x12 @ 1
[    0.023397] initcall trace_init_flags_enter__newfstat+0x0/0x12 returned 0 after 0 usecs
[    0.023402] calling  trace_init_flags_exit__newfstatat+0x0/0x12 @ 1
[    0.023406] initcall trace_init_flags_exit__newfstatat+0x0/0x12 returned 0 after 0 usecs
[    0.023410] calling  trace_init_flags_enter__newfstatat+0x0/0x12 @ 1
[    0.023414] initcall trace_init_flags_enter__newfstatat+0x0/0x12 returned 0 after 0 usecs
[    0.023419] calling  trace_init_flags_exit__newlstat+0x0/0x12 @ 1
[    0.023422] initcall trace_init_flags_exit__newlstat+0x0/0x12 returned 0 after 0 usecs
[    0.023427] calling  trace_init_flags_enter__newlstat+0x0/0x12 @ 1
[    0.023431] initcall trace_init_flags_enter__newlstat+0x0/0x12 returned 0 after 0 usecs
[    0.023435] calling  trace_init_flags_exit__newstat+0x0/0x12 @ 1
[    0.023439] initcall trace_init_flags_exit__newstat+0x0/0x12 returned 0 after 0 usecs
[    0.023443] calling  trace_init_flags_enter__newstat+0x0/0x12 @ 1
[    0.023447] initcall trace_init_flags_enter__newstat+0x0/0x12 returned 0 after 0 usecs
[    0.023452] calling  trace_init_flags_exit__fstat+0x0/0x12 @ 1
[    0.023455] initcall trace_init_flags_exit__fstat+0x0/0x12 returned 0 after 0 usecs
[    0.023460] calling  trace_init_flags_enter__fstat+0x0/0x12 @ 1
[    0.023464] initcall trace_init_flags_enter__fstat+0x0/0x12 returned 0 after 0 usecs
[    0.023468] calling  trace_init_flags_exit__lstat+0x0/0x12 @ 1
[    0.023472] initcall trace_init_flags_exit__lstat+0x0/0x12 returned 0 after 0 usecs
[    0.023476] calling  trace_init_flags_enter__lstat+0x0/0x12 @ 1
[    0.023480] initcall trace_init_flags_enter__lstat+0x0/0x12 returned 0 after 0 usecs
[    0.023484] calling  trace_init_flags_exit__stat+0x0/0x12 @ 1
[    0.023488] initcall trace_init_flags_exit__stat+0x0/0x12 returned 0 after 0 usecs
[    0.023492] calling  trace_init_flags_enter__stat+0x0/0x12 @ 1
[    0.023496] initcall trace_init_flags_enter__stat+0x0/0x12 returned 0 after 0 usecs
[    0.023501] calling  trace_init_flags_exit__uselib+0x0/0x12 @ 1
[    0.023504] initcall trace_init_flags_exit__uselib+0x0/0x12 returned 0 after 0 usecs
[    0.023509] calling  trace_init_flags_enter__uselib+0x0/0x12 @ 1
[    0.023513] initcall trace_init_flags_enter__uselib+0x0/0x12 returned 0 after 0 usecs
[    0.023517] calling  trace_init_flags_exit__pipe+0x0/0x12 @ 1
[    0.023521] initcall trace_init_flags_exit__pipe+0x0/0x12 returned 0 after 0 usecs
[    0.023526] calling  trace_init_flags_enter__pipe+0x0/0x12 @ 1
[    0.023529] initcall trace_init_flags_enter__pipe+0x0/0x12 returned 0 after 0 usecs
[    0.023534] calling  trace_init_flags_exit__pipe2+0x0/0x12 @ 1
[    0.023538] initcall trace_init_flags_exit__pipe2+0x0/0x12 returned 0 after 0 usecs
[    0.023542] calling  trace_init_flags_enter__pipe2+0x0/0x12 @ 1
[    0.023546] initcall trace_init_flags_enter__pipe2+0x0/0x12 returned 0 after 0 usecs
[    0.023550] calling  trace_init_flags_exit__rename+0x0/0x12 @ 1
[    0.023554] initcall trace_init_flags_exit__rename+0x0/0x12 returned 0 after 0 usecs
[    0.023559] calling  trace_init_flags_enter__rename+0x0/0x12 @ 1
[    0.023563] initcall trace_init_flags_enter__rename+0x0/0x12 returned 0 after 0 usecs
[    0.023567] calling  trace_init_flags_exit__renameat+0x0/0x12 @ 1
[    0.023571] initcall trace_init_flags_exit__renameat+0x0/0x12 returned 0 after 0 usecs
[    0.023576] calling  trace_init_flags_enter__renameat+0x0/0x12 @ 1
[    0.023580] initcall trace_init_flags_enter__renameat+0x0/0x12 returned 0 after 0 usecs
[    0.023584] calling  trace_init_flags_exit__link+0x0/0x12 @ 1
[    0.023588] initcall trace_init_flags_exit__link+0x0/0x12 returned 0 after 0 usecs
[    0.023592] calling  trace_init_flags_enter__link+0x0/0x12 @ 1
[    0.023596] initcall trace_init_flags_enter__link+0x0/0x12 returned 0 after 0 usecs
[    0.023601] calling  trace_init_flags_exit__linkat+0x0/0x12 @ 1
[    0.023605] initcall trace_init_flags_exit__linkat+0x0/0x12 returned 0 after 0 usecs
[    0.023609] calling  trace_init_flags_enter__linkat+0x0/0x12 @ 1
[    0.023613] initcall trace_init_flags_enter__linkat+0x0/0x12 returned 0 after 0 usecs
[    0.023617] calling  trace_init_flags_exit__symlink+0x0/0x12 @ 1
[    0.023621] initcall trace_init_flags_exit__symlink+0x0/0x12 returned 0 after 0 usecs
[    0.023626] calling  trace_init_flags_enter__symlink+0x0/0x12 @ 1
[    0.023630] initcall trace_init_flags_enter__symlink+0x0/0x12 returned 0 after 0 usecs
[    0.023634] calling  trace_init_flags_exit__symlinkat+0x0/0x12 @ 1
[    0.023638] initcall trace_init_flags_exit__symlinkat+0x0/0x12 returned 0 after 0 usecs
[    0.023643] calling  trace_init_flags_enter__symlinkat+0x0/0x12 @ 1
[    0.023647] initcall trace_init_flags_enter__symlinkat+0x0/0x12 returned 0 after 0 usecs
[    0.023651] calling  trace_init_flags_exit__unlink+0x0/0x12 @ 1
[    0.023655] initcall trace_init_flags_exit__unlink+0x0/0x12 returned 0 after 0 usecs
[    0.023659] calling  trace_init_flags_enter__unlink+0x0/0x12 @ 1
[    0.023663] initcall trace_init_flags_enter__unlink+0x0/0x12 returned 0 after 0 usecs
[    0.023668] calling  trace_init_flags_exit__unlinkat+0x0/0x12 @ 1
[    0.023672] initcall trace_init_flags_exit__unlinkat+0x0/0x12 returned 0 after 0 usecs
[    0.023676] calling  trace_init_flags_enter__unlinkat+0x0/0x12 @ 1
[    0.023680] initcall trace_init_flags_enter__unlinkat+0x0/0x12 returned 0 after 0 usecs
[    0.023685] calling  trace_init_flags_exit__rmdir+0x0/0x12 @ 1
[    0.023689] initcall trace_init_flags_exit__rmdir+0x0/0x12 returned 0 after 0 usecs
[    0.023693] calling  trace_init_flags_enter__rmdir+0x0/0x12 @ 1
[    0.023697] initcall trace_init_flags_enter__rmdir+0x0/0x12 returned 0 after 0 usecs
[    0.023701] calling  trace_init_flags_exit__mkdir+0x0/0x12 @ 1
[    0.023705] initcall trace_init_flags_exit__mkdir+0x0/0x12 returned 0 after 0 usecs
[    0.023710] calling  trace_init_flags_enter__mkdir+0x0/0x12 @ 1
[    0.023714] initcall trace_init_flags_enter__mkdir+0x0/0x12 returned 0 after 0 usecs
[    0.023718] calling  trace_init_flags_exit__mkdirat+0x0/0x12 @ 1
[    0.023722] initcall trace_init_flags_exit__mkdirat+0x0/0x12 returned 0 after 0 usecs
[    0.023726] calling  trace_init_flags_enter__mkdirat+0x0/0x12 @ 1
[    0.023730] initcall trace_init_flags_enter__mkdirat+0x0/0x12 returned 0 after 0 usecs
[    0.023735] calling  trace_init_flags_exit__mknod+0x0/0x12 @ 1
[    0.023739] initcall trace_init_flags_exit__mknod+0x0/0x12 returned 0 after 0 usecs
[    0.023743] calling  trace_init_flags_enter__mknod+0x0/0x12 @ 1
[    0.023747] initcall trace_init_flags_enter__mknod+0x0/0x12 returned 0 after 0 usecs
[    0.023751] calling  trace_init_flags_exit__mknodat+0x0/0x12 @ 1
[    0.023755] initcall trace_init_flags_exit__mknodat+0x0/0x12 returned 0 after 0 usecs
[    0.023760] calling  trace_init_flags_enter__mknodat+0x0/0x12 @ 1
[    0.023763] initcall trace_init_flags_enter__mknodat+0x0/0x12 returned 0 after 0 usecs
[    0.023768] calling  trace_init_flags_exit__fcntl+0x0/0x12 @ 1
[    0.023772] initcall trace_init_flags_exit__fcntl+0x0/0x12 returned 0 after 0 usecs
[    0.023777] calling  trace_init_flags_enter__fcntl+0x0/0x12 @ 1
[    0.023781] initcall trace_init_flags_enter__fcntl+0x0/0x12 returned 0 after 0 usecs
[    0.023785] calling  trace_init_flags_exit__dup+0x0/0x12 @ 1
[    0.023789] initcall trace_init_flags_exit__dup+0x0/0x12 returned 0 after 0 usecs
[    0.023793] calling  trace_init_flags_enter__dup+0x0/0x12 @ 1
[    0.023797] initcall trace_init_flags_enter__dup+0x0/0x12 returned 0 after 0 usecs
[    0.023801] calling  trace_init_flags_exit__dup2+0x0/0x12 @ 1
[    0.023805] initcall trace_init_flags_exit__dup2+0x0/0x12 returned 0 after 0 usecs
[    0.023810] calling  trace_init_flags_enter__dup2+0x0/0x12 @ 1
[    0.023814] initcall trace_init_flags_enter__dup2+0x0/0x12 returned 0 after 0 usecs
[    0.023818] calling  trace_init_flags_exit__dup3+0x0/0x12 @ 1
[    0.023822] initcall trace_init_flags_exit__dup3+0x0/0x12 returned 0 after 0 usecs
[    0.023826] calling  trace_init_flags_enter__dup3+0x0/0x12 @ 1
[    0.023830] initcall trace_init_flags_enter__dup3+0x0/0x12 returned 0 after 0 usecs
[    0.023835] calling  trace_init_flags_exit__ioctl+0x0/0x12 @ 1
[    0.023839] initcall trace_init_flags_exit__ioctl+0x0/0x12 returned 0 after 0 usecs
[    0.023843] calling  trace_init_flags_enter__ioctl+0x0/0x12 @ 1
[    0.023847] initcall trace_init_flags_enter__ioctl+0x0/0x12 returned 0 after 0 usecs
[    0.023851] calling  trace_init_flags_exit__getdents64+0x0/0x12 @ 1
[    0.023855] initcall trace_init_flags_exit__getdents64+0x0/0x12 returned 0 after 0 usecs
[    0.023859] calling  trace_init_flags_enter__getdents64+0x0/0x12 @ 1
[    0.023862] initcall trace_init_flags_enter__getdents64+0x0/0x12 returned 0 after 0 usecs
[    0.023867] calling  trace_init_flags_exit__getdents+0x0/0x12 @ 1
[    0.023870] initcall trace_init_flags_exit__getdents+0x0/0x12 returned 0 after 0 usecs
[    0.023875] calling  trace_init_flags_enter__getdents+0x0/0x12 @ 1
[    0.023879] initcall trace_init_flags_enter__getdents+0x0/0x12 returned 0 after 0 usecs
[    0.023883] calling  trace_init_flags_exit__old_readdir+0x0/0x12 @ 1
[    0.023887] initcall trace_init_flags_exit__old_readdir+0x0/0x12 returned 0 after 0 usecs
[    0.023892] calling  trace_init_flags_enter__old_readdir+0x0/0x12 @ 1
[    0.023896] initcall trace_init_flags_enter__old_readdir+0x0/0x12 returned 0 after 0 usecs
[    0.023900] calling  trace_init_flags_exit__ppoll+0x0/0x12 @ 1
[    0.023904] initcall trace_init_flags_exit__ppoll+0x0/0x12 returned 0 after 0 usecs
[    0.023908] calling  trace_init_flags_enter__ppoll+0x0/0x12 @ 1
[    0.023911] initcall trace_init_flags_enter__ppoll+0x0/0x12 returned 0 after 0 usecs
[    0.023915] calling  trace_init_flags_exit__poll+0x0/0x12 @ 1
[    0.023919] initcall trace_init_flags_exit__poll+0x0/0x12 returned 0 after 0 usecs
[    0.023923] calling  trace_init_flags_enter__poll+0x0/0x12 @ 1
[    0.023926] initcall trace_init_flags_enter__poll+0x0/0x12 returned 0 after 0 usecs
[    0.023930] calling  trace_init_flags_exit__pselect6+0x0/0x12 @ 1
[    0.023934] initcall trace_init_flags_exit__pselect6+0x0/0x12 returned 0 after 0 usecs
[    0.023938] calling  trace_init_flags_enter__pselect6+0x0/0x12 @ 1
[    0.023942] initcall trace_init_flags_enter__pselect6+0x0/0x12 returned 0 after 0 usecs
[    0.023946] calling  trace_init_flags_exit__select+0x0/0x12 @ 1
[    0.023949] initcall trace_init_flags_exit__select+0x0/0x12 returned 0 after 0 usecs
[    0.023953] calling  trace_init_flags_enter__select+0x0/0x12 @ 1
[    0.023957] initcall trace_init_flags_enter__select+0x0/0x12 returned 0 after 0 usecs
[    0.023961] calling  trace_init_flags_exit__getcwd+0x0/0x12 @ 1
[    0.023964] initcall trace_init_flags_exit__getcwd+0x0/0x12 returned 0 after 0 usecs
[    0.023968] calling  trace_init_flags_enter__getcwd+0x0/0x12 @ 1
[    0.023972] initcall trace_init_flags_enter__getcwd+0x0/0x12 returned 0 after 0 usecs
[    0.023976] calling  trace_init_flags_exit__sysfs+0x0/0x12 @ 1
[    0.023980] initcall trace_init_flags_exit__sysfs+0x0/0x12 returned 0 after 0 usecs
[    0.023984] calling  trace_init_flags_enter__sysfs+0x0/0x12 @ 1
[    0.023987] initcall trace_init_flags_enter__sysfs+0x0/0x12 returned 0 after 0 usecs
[    0.023991] calling  trace_init_flags_exit__pivot_root+0x0/0x12 @ 1
[    0.023995] initcall trace_init_flags_exit__pivot_root+0x0/0x12 returned 0 after 0 usecs
[    0.023999] calling  trace_init_flags_enter__pivot_root+0x0/0x12 @ 1
[    0.024003] initcall trace_init_flags_enter__pivot_root+0x0/0x12 returned 0 after 0 usecs
[    0.024007] calling  trace_init_flags_exit__mount+0x0/0x12 @ 1
[    0.024011] initcall trace_init_flags_exit__mount+0x0/0x12 returned 0 after 0 usecs
[    0.024015] calling  trace_init_flags_enter__mount+0x0/0x12 @ 1
[    0.024018] initcall trace_init_flags_enter__mount+0x0/0x12 returned 0 after 0 usecs
[    0.024023] calling  trace_init_flags_exit__oldumount+0x0/0x12 @ 1
[    0.024026] initcall trace_init_flags_exit__oldumount+0x0/0x12 returned 0 after 0 usecs
[    0.024030] calling  trace_init_flags_enter__oldumount+0x0/0x12 @ 1
[    0.024034] initcall trace_init_flags_enter__oldumount+0x0/0x12 returned 0 after 0 usecs
[    0.024038] calling  trace_init_flags_exit__umount+0x0/0x12 @ 1
[    0.024042] initcall trace_init_flags_exit__umount+0x0/0x12 returned 0 after 0 usecs
[    0.024046] calling  trace_init_flags_enter__umount+0x0/0x12 @ 1
[    0.024049] initcall trace_init_flags_enter__umount+0x0/0x12 returned 0 after 0 usecs
[    0.024054] calling  trace_init_flags_exit__fremovexattr+0x0/0x12 @ 1
[    0.024057] initcall trace_init_flags_exit__fremovexattr+0x0/0x12 returned 0 after 0 usecs
[    0.024062] calling  trace_init_flags_enter__fremovexattr+0x0/0x12 @ 1
[    0.024066] initcall trace_init_flags_enter__fremovexattr+0x0/0x12 returned 0 after 0 usecs
[    0.024070] calling  trace_init_flags_exit__lremovexattr+0x0/0x12 @ 1
[    0.024074] initcall trace_init_flags_exit__lremovexattr+0x0/0x12 returned 0 after 0 usecs
[    0.024078] calling  trace_init_flags_enter__lremovexattr+0x0/0x12 @ 1
[    0.024082] initcall trace_init_flags_enter__lremovexattr+0x0/0x12 returned 0 after 0 usecs
[    0.024086] calling  trace_init_flags_exit__removexattr+0x0/0x12 @ 1
[    0.024090] initcall trace_init_flags_exit__removexattr+0x0/0x12 returned 0 after 0 usecs
[    0.024094] calling  trace_init_flags_enter__removexattr+0x0/0x12 @ 1
[    0.024097] initcall trace_init_flags_enter__removexattr+0x0/0x12 returned 0 after 0 usecs
[    0.024102] calling  trace_init_flags_exit__flistxattr+0x0/0x12 @ 1
[    0.024105] initcall trace_init_flags_exit__flistxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024110] calling  trace_init_flags_enter__flistxattr+0x0/0x12 @ 1
[    0.024113] initcall trace_init_flags_enter__flistxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024118] calling  trace_init_flags_exit__llistxattr+0x0/0x12 @ 1
[    0.024122] initcall trace_init_flags_exit__llistxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024126] calling  trace_init_flags_enter__llistxattr+0x0/0x12 @ 1
[    0.024129] initcall trace_init_flags_enter__llistxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024134] calling  trace_init_flags_exit__listxattr+0x0/0x12 @ 1
[    0.024137] initcall trace_init_flags_exit__listxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024142] calling  trace_init_flags_enter__listxattr+0x0/0x12 @ 1
[    0.024145] initcall trace_init_flags_enter__listxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024149] calling  trace_init_flags_exit__fgetxattr+0x0/0x12 @ 1
[    0.024153] initcall trace_init_flags_exit__fgetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024157] calling  trace_init_flags_enter__fgetxattr+0x0/0x12 @ 1
[    0.024161] initcall trace_init_flags_enter__fgetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024165] calling  trace_init_flags_exit__lgetxattr+0x0/0x12 @ 1
[    0.024169] initcall trace_init_flags_exit__lgetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024173] calling  trace_init_flags_enter__lgetxattr+0x0/0x12 @ 1
[    0.024176] initcall trace_init_flags_enter__lgetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024181] calling  trace_init_flags_exit__getxattr+0x0/0x12 @ 1
[    0.024184] initcall trace_init_flags_exit__getxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024188] calling  trace_init_flags_enter__getxattr+0x0/0x12 @ 1
[    0.024192] initcall trace_init_flags_enter__getxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024196] calling  trace_init_flags_exit__fsetxattr+0x0/0x12 @ 1
[    0.024200] initcall trace_init_flags_exit__fsetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024204] calling  trace_init_flags_enter__fsetxattr+0x0/0x12 @ 1
[    0.024208] initcall trace_init_flags_enter__fsetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024212] calling  trace_init_flags_exit__lsetxattr+0x0/0x12 @ 1
[    0.024215] initcall trace_init_flags_exit__lsetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024220] calling  trace_init_flags_enter__lsetxattr+0x0/0x12 @ 1
[    0.024223] initcall trace_init_flags_enter__lsetxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024227] calling  trace_init_flags_exit__setxattr+0x0/0x12 @ 1
[    0.024231] initcall trace_init_flags_exit__setxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024235] calling  trace_init_flags_enter__setxattr+0x0/0x12 @ 1
[    0.024239] initcall trace_init_flags_enter__setxattr+0x0/0x12 returned 0 after 0 usecs
[    0.024243] calling  trace_init_flags_exit__tee+0x0/0x12 @ 1
[    0.024246] initcall trace_init_flags_exit__tee+0x0/0x12 returned 0 after 0 usecs
[    0.024251] calling  trace_init_flags_enter__tee+0x0/0x12 @ 1
[    0.024254] initcall trace_init_flags_enter__tee+0x0/0x12 returned 0 after 0 usecs
[    0.024258] calling  trace_init_flags_exit__splice+0x0/0x12 @ 1
[    0.024262] initcall trace_init_flags_exit__splice+0x0/0x12 returned 0 after 0 usecs
[    0.024266] calling  trace_init_flags_enter__splice+0x0/0x12 @ 1
[    0.024270] initcall trace_init_flags_enter__splice+0x0/0x12 returned 0 after 0 usecs
[    0.024274] calling  trace_init_flags_exit__vmsplice+0x0/0x12 @ 1
[    0.024277] initcall trace_init_flags_exit__vmsplice+0x0/0x12 returned 0 after 0 usecs
[    0.024282] calling  trace_init_flags_enter__vmsplice+0x0/0x12 @ 1
[    0.024285] initcall trace_init_flags_enter__vmsplice+0x0/0x12 returned 0 after 0 usecs
[    0.024290] calling  trace_init_flags_exit__fdatasync+0x0/0x12 @ 1
[    0.024293] initcall trace_init_flags_exit__fdatasync+0x0/0x12 returned 0 after 0 usecs
[    0.024298] calling  trace_init_flags_enter__fdatasync+0x0/0x12 @ 1
[    0.024301] initcall trace_init_flags_enter__fdatasync+0x0/0x12 returned 0 after 0 usecs
[    0.024306] calling  trace_init_flags_exit__fsync+0x0/0x12 @ 1
[    0.024309] initcall trace_init_flags_exit__fsync+0x0/0x12 returned 0 after 0 usecs
[    0.024313] calling  trace_init_flags_enter__fsync+0x0/0x12 @ 1
[    0.024317] initcall trace_init_flags_enter__fsync+0x0/0x12 returned 0 after 0 usecs
[    0.024321] calling  trace_init_flags_exit__sync+0x0/0x12 @ 1
[    0.024325] initcall trace_init_flags_exit__sync+0x0/0x12 returned 0 after 0 usecs
[    0.024329] calling  trace_init_flags_enter__sync+0x0/0x12 @ 1
[    0.024332] initcall trace_init_flags_enter__sync+0x0/0x12 returned 0 after 0 usecs
[    0.024336] calling  trace_init_flags_exit__utimes+0x0/0x12 @ 1
[    0.024340] initcall trace_init_flags_exit__utimes+0x0/0x12 returned 0 after 0 usecs
[    0.024344] calling  trace_init_flags_enter__utimes+0x0/0x12 @ 1
[    0.024348] initcall trace_init_flags_enter__utimes+0x0/0x12 returned 0 after 0 usecs
[    0.024352] calling  trace_init_flags_exit__futimesat+0x0/0x12 @ 1
[    0.024356] initcall trace_init_flags_exit__futimesat+0x0/0x12 returned 0 after 0 usecs
[    0.024360] calling  trace_init_flags_enter__futimesat+0x0/0x12 @ 1
[    0.024364] initcall trace_init_flags_enter__futimesat+0x0/0x12 returned 0 after 0 usecs
[    0.024368] calling  trace_init_flags_exit__utimensat+0x0/0x12 @ 1
[    0.024372] initcall trace_init_flags_exit__utimensat+0x0/0x12 returned 0 after 0 usecs
[    0.024376] calling  trace_init_flags_enter__utimensat+0x0/0x12 @ 1
[    0.024380] initcall trace_init_flags_enter__utimensat+0x0/0x12 returned 0 after 0 usecs
[    0.024384] calling  trace_init_flags_exit__utime+0x0/0x12 @ 1
[    0.024387] initcall trace_init_flags_exit__utime+0x0/0x12 returned 0 after 0 usecs
[    0.024392] calling  trace_init_flags_enter__utime+0x0/0x12 @ 1
[    0.024395] initcall trace_init_flags_enter__utime+0x0/0x12 returned 0 after 0 usecs
[    0.024399] calling  trace_init_flags_exit__ustat+0x0/0x12 @ 1
[    0.024403] initcall trace_init_flags_exit__ustat+0x0/0x12 returned 0 after 0 usecs
[    0.024407] calling  trace_init_flags_enter__ustat+0x0/0x12 @ 1
[    0.024411] initcall trace_init_flags_enter__ustat+0x0/0x12 returned 0 after 0 usecs
[    0.024415] calling  trace_init_flags_exit__fstatfs64+0x0/0x12 @ 1
[    0.024419] initcall trace_init_flags_exit__fstatfs64+0x0/0x12 returned 0 after 0 usecs
[    0.024423] calling  trace_init_flags_enter__fstatfs64+0x0/0x12 @ 1
[    0.024427] initcall trace_init_flags_enter__fstatfs64+0x0/0x12 returned 0 after 0 usecs
[    0.024431] calling  trace_init_flags_exit__fstatfs+0x0/0x12 @ 1
[    0.024435] initcall trace_init_flags_exit__fstatfs+0x0/0x12 returned 0 after 0 usecs
[    0.024439] calling  trace_init_flags_enter__fstatfs+0x0/0x12 @ 1
[    0.024442] initcall trace_init_flags_enter__fstatfs+0x0/0x12 returned 0 after 0 usecs
[    0.024447] calling  trace_init_flags_exit__statfs64+0x0/0x12 @ 1
[    0.024450] initcall trace_init_flags_exit__statfs64+0x0/0x12 returned 0 after 0 usecs
[    0.024455] calling  trace_init_flags_enter__statfs64+0x0/0x12 @ 1
[    0.024458] initcall trace_init_flags_enter__statfs64+0x0/0x12 returned 0 after 0 usecs
[    0.024463] calling  trace_init_flags_exit__statfs+0x0/0x12 @ 1
[    0.024466] initcall trace_init_flags_exit__statfs+0x0/0x12 returned 0 after 0 usecs
[    0.024470] calling  trace_init_flags_enter__statfs+0x0/0x12 @ 1
[    0.024474] initcall trace_init_flags_enter__statfs+0x0/0x12 returned 0 after 0 usecs
[    0.024478] calling  trace_init_flags_exit__bdflush+0x0/0x12 @ 1
[    0.024482] initcall trace_init_flags_exit__bdflush+0x0/0x12 returned 0 after 0 usecs
[    0.024486] calling  trace_init_flags_enter__bdflush+0x0/0x12 @ 1
[    0.024490] initcall trace_init_flags_enter__bdflush+0x0/0x12 returned 0 after 0 usecs
[    0.024494] calling  trace_init_flags_exit__ioprio_get+0x0/0x12 @ 1
[    0.024498] initcall trace_init_flags_exit__ioprio_get+0x0/0x12 returned 0 after 0 usecs
[    0.024502] calling  trace_init_flags_enter__ioprio_get+0x0/0x12 @ 1
[    0.024506] initcall trace_init_flags_enter__ioprio_get+0x0/0x12 returned 0 after 0 usecs
[    0.024510] calling  trace_init_flags_exit__ioprio_set+0x0/0x12 @ 1
[    0.024514] initcall trace_init_flags_exit__ioprio_set+0x0/0x12 returned 0 after 0 usecs
[    0.024519] calling  trace_init_flags_enter__ioprio_set+0x0/0x12 @ 1
[    0.024522] initcall trace_init_flags_enter__ioprio_set+0x0/0x12 returned 0 after 0 usecs
[    0.024527] calling  trace_init_flags_exit__inotify_rm_watch+0x0/0x12 @ 1
[    0.024531] initcall trace_init_flags_exit__inotify_rm_watch+0x0/0x12 returned 0 after 0 usecs
[    0.024535] calling  trace_init_flags_enter__inotify_rm_watch+0x0/0x12 @ 1
[    0.024539] initcall trace_init_flags_enter__inotify_rm_watch+0x0/0x12 returned 0 after 0 usecs
[    0.024544] calling  trace_init_flags_exit__inotify_add_watch+0x0/0x12 @ 1
[    0.024548] initcall trace_init_flags_exit__inotify_add_watch+0x0/0x12 returned 0 after 0 usecs
[    0.024552] calling  trace_init_flags_enter__inotify_add_watch+0x0/0x12 @ 1
[    0.024556] initcall trace_init_flags_enter__inotify_add_watch+0x0/0x12 returned 0 after 0 usecs
[    0.024561] calling  trace_init_flags_exit__inotify_init+0x0/0x12 @ 1
[    0.024564] initcall trace_init_flags_exit__inotify_init+0x0/0x12 returned 0 after 0 usecs
[    0.024569] calling  trace_init_flags_enter__inotify_init+0x0/0x12 @ 1
[    0.024573] initcall trace_init_flags_enter__inotify_init+0x0/0x12 returned 0 after 0 usecs
[    0.024577] calling  trace_init_flags_exit__inotify_init1+0x0/0x12 @ 1
[    0.024581] initcall trace_init_flags_exit__inotify_init1+0x0/0x12 returned 0 after 0 usecs
[    0.024585] calling  trace_init_flags_enter__inotify_init1+0x0/0x12 @ 1
[    0.024589] initcall trace_init_flags_enter__inotify_init1+0x0/0x12 returned 0 after 0 usecs
[    0.024594] calling  trace_init_flags_exit__fanotify_init+0x0/0x12 @ 1
[    0.024598] initcall trace_init_flags_exit__fanotify_init+0x0/0x12 returned 0 after 0 usecs
[    0.024602] calling  trace_init_flags_enter__fanotify_init+0x0/0x12 @ 1
[    0.024606] initcall trace_init_flags_enter__fanotify_init+0x0/0x12 returned 0 after 0 usecs
[    0.024610] calling  trace_init_flags_exit__epoll_pwait+0x0/0x12 @ 1
[    0.024614] initcall trace_init_flags_exit__epoll_pwait+0x0/0x12 returned 0 after 0 usecs
[    0.024618] calling  trace_init_flags_enter__epoll_pwait+0x0/0x12 @ 1
[    0.024622] initcall trace_init_flags_enter__epoll_pwait+0x0/0x12 returned 0 after 0 usecs
[    0.024627] calling  trace_init_flags_exit__epoll_wait+0x0/0x12 @ 1
[    0.024631] initcall trace_init_flags_exit__epoll_wait+0x0/0x12 returned 0 after 0 usecs
[    0.024635] calling  trace_init_flags_enter__epoll_wait+0x0/0x12 @ 1
[    0.024639] initcall trace_init_flags_enter__epoll_wait+0x0/0x12 returned 0 after 0 usecs
[    0.024643] calling  trace_init_flags_exit__epoll_ctl+0x0/0x12 @ 1
[    0.024647] initcall trace_init_flags_exit__epoll_ctl+0x0/0x12 returned 0 after 0 usecs
[    0.024651] calling  trace_init_flags_enter__epoll_ctl+0x0/0x12 @ 1
[    0.024655] initcall trace_init_flags_enter__epoll_ctl+0x0/0x12 returned 0 after 0 usecs
[    0.024659] calling  trace_init_flags_exit__epoll_create+0x0/0x12 @ 1
[    0.024663] initcall trace_init_flags_exit__epoll_create+0x0/0x12 returned 0 after 0 usecs
[    0.024668] calling  trace_init_flags_enter__epoll_create+0x0/0x12 @ 1
[    0.024672] initcall trace_init_flags_enter__epoll_create+0x0/0x12 returned 0 after 0 usecs
[    0.024676] calling  trace_init_flags_exit__epoll_create1+0x0/0x12 @ 1
[    0.024680] initcall trace_init_flags_exit__epoll_create1+0x0/0x12 returned 0 after 0 usecs
[    0.024684] calling  trace_init_flags_enter__epoll_create1+0x0/0x12 @ 1
[    0.024688] initcall trace_init_flags_enter__epoll_create1+0x0/0x12 returned 0 after 0 usecs
[    0.024693] calling  trace_init_flags_exit__signalfd+0x0/0x12 @ 1
[    0.024697] initcall trace_init_flags_exit__signalfd+0x0/0x12 returned 0 after 0 usecs
[    0.024701] calling  trace_init_flags_enter__signalfd+0x0/0x12 @ 1
[    0.024705] initcall trace_init_flags_enter__signalfd+0x0/0x12 returned 0 after 0 usecs
[    0.024709] calling  trace_init_flags_exit__signalfd4+0x0/0x12 @ 1
[    0.024713] initcall trace_init_flags_exit__signalfd4+0x0/0x12 returned 0 after 0 usecs
[    0.024717] calling  trace_init_flags_enter__signalfd4+0x0/0x12 @ 1
[    0.024721] initcall trace_init_flags_enter__signalfd4+0x0/0x12 returned 0 after 0 usecs
[    0.024726] calling  trace_init_flags_exit__timerfd_gettime+0x0/0x12 @ 1
[    0.024730] initcall trace_init_flags_exit__timerfd_gettime+0x0/0x12 returned 0 after 0 usecs
[    0.024734] calling  trace_init_flags_enter__timerfd_gettime+0x0/0x12 @ 1
[    0.024738] initcall trace_init_flags_enter__timerfd_gettime+0x0/0x12 returned 0 after 0 usecs
[    0.024743] calling  trace_init_flags_exit__timerfd_settime+0x0/0x12 @ 1
[    0.024747] initcall trace_init_flags_exit__timerfd_settime+0x0/0x12 returned 0 after 0 usecs
[    0.024751] calling  trace_init_flags_enter__timerfd_settime+0x0/0x12 @ 1
[    0.024755] initcall trace_init_flags_enter__timerfd_settime+0x0/0x12 returned 0 after 0 usecs
[    0.024760] calling  trace_init_flags_exit__timerfd_create+0x0/0x12 @ 1
[    0.024763] initcall trace_init_flags_exit__timerfd_create+0x0/0x12 returned 0 after 0 usecs
[    0.024768] calling  trace_init_flags_enter__timerfd_create+0x0/0x12 @ 1
[    0.024772] initcall trace_init_flags_enter__timerfd_create+0x0/0x12 returned 0 after 0 usecs
[    0.024776] calling  trace_init_flags_exit__eventfd+0x0/0x12 @ 1
[    0.024780] initcall trace_init_flags_exit__eventfd+0x0/0x12 returned 0 after 0 usecs
[    0.024784] calling  trace_init_flags_enter__eventfd+0x0/0x12 @ 1
[    0.024788] initcall trace_init_flags_enter__eventfd+0x0/0x12 returned 0 after 0 usecs
[    0.024793] calling  trace_init_flags_exit__eventfd2+0x0/0x12 @ 1
[    0.024796] initcall trace_init_flags_exit__eventfd2+0x0/0x12 returned 0 after 0 usecs
[    0.024801] calling  trace_init_flags_enter__eventfd2+0x0/0x12 @ 1
[    0.024804] initcall trace_init_flags_enter__eventfd2+0x0/0x12 returned 0 after 0 usecs
[    0.024809] calling  trace_init_flags_exit__io_getevents+0x0/0x12 @ 1
[    0.024813] initcall trace_init_flags_exit__io_getevents+0x0/0x12 returned 0 after 0 usecs
[    0.024817] calling  trace_init_flags_enter__io_getevents+0x0/0x12 @ 1
[    0.024821] initcall trace_init_flags_enter__io_getevents+0x0/0x12 returned 0 after 0 usecs
[    0.024826] calling  trace_init_flags_exit__io_cancel+0x0/0x12 @ 1
[    0.024830] initcall trace_init_flags_exit__io_cancel+0x0/0x12 returned 0 after 0 usecs
[    0.024834] calling  trace_init_flags_enter__io_cancel+0x0/0x12 @ 1
[    0.024838] initcall trace_init_flags_enter__io_cancel+0x0/0x12 returned 0 after 0 usecs
[    0.024842] calling  trace_init_flags_exit__io_submit+0x0/0x12 @ 1
[    0.024846] initcall trace_init_flags_exit__io_submit+0x0/0x12 returned 0 after 0 usecs
[    0.024850] calling  trace_init_flags_enter__io_submit+0x0/0x12 @ 1
[    0.024854] initcall trace_init_flags_enter__io_submit+0x0/0x12 returned 0 after 0 usecs
[    0.024859] calling  trace_init_flags_exit__io_destroy+0x0/0x12 @ 1
[    0.024862] initcall trace_init_flags_exit__io_destroy+0x0/0x12 returned 0 after 0 usecs
[    0.024867] calling  trace_init_flags_enter__io_destroy+0x0/0x12 @ 1
[    0.024871] initcall trace_init_flags_enter__io_destroy+0x0/0x12 returned 0 after 0 usecs
[    0.024875] calling  trace_init_flags_exit__io_setup+0x0/0x12 @ 1
[    0.024879] initcall trace_init_flags_exit__io_setup+0x0/0x12 returned 0 after 0 usecs
[    0.024883] calling  trace_init_flags_enter__io_setup+0x0/0x12 @ 1
[    0.024887] initcall trace_init_flags_enter__io_setup+0x0/0x12 returned 0 after 0 usecs
[    0.024891] calling  trace_init_flags_exit__flock+0x0/0x12 @ 1
[    0.024895] initcall trace_init_flags_exit__flock+0x0/0x12 returned 0 after 0 usecs
[    0.024899] calling  trace_init_flags_enter__flock+0x0/0x12 @ 1
[    0.024903] initcall trace_init_flags_enter__flock+0x0/0x12 returned 0 after 0 usecs
[    0.024908] calling  trace_init_flags_exit__nfsservctl+0x0/0x12 @ 1
[    0.024912] initcall trace_init_flags_exit__nfsservctl+0x0/0x12 returned 0 after 0 usecs
[    0.024916] calling  trace_init_flags_enter__nfsservctl+0x0/0x12 @ 1
[    0.024920] initcall trace_init_flags_enter__nfsservctl+0x0/0x12 returned 0 after 0 usecs
[    0.024925] calling  trace_init_flags_exit__quotactl+0x0/0x12 @ 1
[    0.024928] initcall trace_init_flags_exit__quotactl+0x0/0x12 returned 0 after 0 usecs
[    0.024933] calling  trace_init_flags_enter__quotactl+0x0/0x12 @ 1
[    0.024937] initcall trace_init_flags_enter__quotactl+0x0/0x12 returned 0 after 0 usecs
[    0.024942] calling  trace_init_flags_exit__msgrcv+0x0/0x12 @ 1
[    0.024946] initcall trace_init_flags_exit__msgrcv+0x0/0x12 returned 0 after 0 usecs
[    0.024950] calling  trace_init_flags_enter__msgrcv+0x0/0x12 @ 1
[    0.024954] initcall trace_init_flags_enter__msgrcv+0x0/0x12 returned 0 after 0 usecs
[    0.024958] calling  trace_init_flags_exit__msgsnd+0x0/0x12 @ 1
[    0.024962] initcall trace_init_flags_exit__msgsnd+0x0/0x12 returned 0 after 0 usecs
[    0.024967] calling  trace_init_flags_enter__msgsnd+0x0/0x12 @ 1
[    0.024971] initcall trace_init_flags_enter__msgsnd+0x0/0x12 returned 0 after 0 usecs
[    0.024975] calling  trace_init_flags_exit__msgctl+0x0/0x12 @ 1
[    0.024979] initcall trace_init_flags_exit__msgctl+0x0/0x12 returned 0 after 0 usecs
[    0.024983] calling  trace_init_flags_enter__msgctl+0x0/0x12 @ 1
[    0.024987] initcall trace_init_flags_enter__msgctl+0x0/0x12 returned 0 after 0 usecs
[    0.024992] calling  trace_init_flags_exit__msgget+0x0/0x12 @ 1
[    0.024995] initcall trace_init_flags_exit__msgget+0x0/0x12 returned 0 after 0 usecs
[    0.025000] calling  trace_init_flags_enter__msgget+0x0/0x12 @ 1
[    0.025004] initcall trace_init_flags_enter__msgget+0x0/0x12 returned 0 after 0 usecs
[    0.025008] calling  trace_init_flags_exit__semop+0x0/0x12 @ 1
[    0.025012] initcall trace_init_flags_exit__semop+0x0/0x12 returned 0 after 0 usecs
[    0.025017] calling  trace_init_flags_enter__semop+0x0/0x12 @ 1
[    0.025020] initcall trace_init_flags_enter__semop+0x0/0x12 returned 0 after 0 usecs
[    0.025025] calling  trace_init_flags_exit__semtimedop+0x0/0x12 @ 1
[    0.025029] initcall trace_init_flags_exit__semtimedop+0x0/0x12 returned 0 after 0 usecs
[    0.025034] calling  trace_init_flags_enter__semtimedop+0x0/0x12 @ 1
[    0.025038] initcall trace_init_flags_enter__semtimedop+0x0/0x12 returned 0 after 0 usecs
[    0.025042] calling  trace_init_flags_exit__semget+0x0/0x12 @ 1
[    0.025046] initcall trace_init_flags_exit__semget+0x0/0x12 returned 0 after 0 usecs
[    0.025050] calling  trace_init_flags_enter__semget+0x0/0x12 @ 1
[    0.025054] initcall trace_init_flags_enter__semget+0x0/0x12 returned 0 after 0 usecs
[    0.025059] calling  trace_init_flags_exit__shmdt+0x0/0x12 @ 1
[    0.025063] initcall trace_init_flags_exit__shmdt+0x0/0x12 returned 0 after 0 usecs
[    0.025067] calling  trace_init_flags_enter__shmdt+0x0/0x12 @ 1
[    0.025071] initcall trace_init_flags_enter__shmdt+0x0/0x12 returned 0 after 0 usecs
[    0.025075] calling  trace_init_flags_exit__shmat+0x0/0x12 @ 1
[    0.025079] initcall trace_init_flags_exit__shmat+0x0/0x12 returned 0 after 0 usecs
[    0.025084] calling  trace_init_flags_enter__shmat+0x0/0x12 @ 1
[    0.025088] initcall trace_init_flags_enter__shmat+0x0/0x12 returned 0 after 0 usecs
[    0.025092] calling  trace_init_flags_exit__shmctl+0x0/0x12 @ 1
[    0.025096] initcall trace_init_flags_exit__shmctl+0x0/0x12 returned 0 after 0 usecs
[    0.025100] calling  trace_init_flags_enter__shmctl+0x0/0x12 @ 1
[    0.025104] initcall trace_init_flags_enter__shmctl+0x0/0x12 returned 0 after 0 usecs
[    0.025109] calling  trace_init_flags_exit__shmget+0x0/0x12 @ 1
[    0.025113] initcall trace_init_flags_exit__shmget+0x0/0x12 returned 0 after 0 usecs
[    0.025117] calling  trace_init_flags_enter__shmget+0x0/0x12 @ 1
[    0.025121] initcall trace_init_flags_enter__shmget+0x0/0x12 returned 0 after 0 usecs
[    0.025126] calling  trace_init_flags_exit__mq_getsetattr+0x0/0x12 @ 1
[    0.025129] initcall trace_init_flags_exit__mq_getsetattr+0x0/0x12 returned 0 after 0 usecs
[    0.025133] calling  trace_init_flags_enter__mq_getsetattr+0x0/0x12 @ 1
[    0.025137] initcall trace_init_flags_enter__mq_getsetattr+0x0/0x12 returned 0 after 0 usecs
[    0.025142] calling  trace_init_flags_exit__mq_notify+0x0/0x12 @ 1
[    0.025146] initcall trace_init_flags_exit__mq_notify+0x0/0x12 returned 0 after 0 usecs
[    0.025150] calling  trace_init_flags_enter__mq_notify+0x0/0x12 @ 1
[    0.025155] initcall trace_init_flags_enter__mq_notify+0x0/0x12 returned 0 after 0 usecs
[    0.025159] calling  trace_init_flags_exit__mq_timedreceive+0x0/0x12 @ 1
[    0.025163] initcall trace_init_flags_exit__mq_timedreceive+0x0/0x12 returned 0 after 0 usecs
[    0.025168] calling  trace_init_flags_enter__mq_timedreceive+0x0/0x12 @ 1
[    0.025172] initcall trace_init_flags_enter__mq_timedreceive+0x0/0x12 returned 0 after 0 usecs
[    0.025177] calling  trace_init_flags_exit__mq_timedsend+0x0/0x12 @ 1
[    0.025181] initcall trace_init_flags_exit__mq_timedsend+0x0/0x12 returned 0 after 0 usecs
[    0.025186] calling  trace_init_flags_enter__mq_timedsend+0x0/0x12 @ 1
[    0.025190] initcall trace_init_flags_enter__mq_timedsend+0x0/0x12 returned 0 after 0 usecs
[    0.025195] calling  trace_init_flags_exit__mq_unlink+0x0/0x12 @ 1
[    0.025199] initcall trace_init_flags_exit__mq_unlink+0x0/0x12 returned 0 after 0 usecs
[    0.025203] calling  trace_init_flags_enter__mq_unlink+0x0/0x12 @ 1
[    0.025207] initcall trace_init_flags_enter__mq_unlink+0x0/0x12 returned 0 after 0 usecs
[    0.025212] calling  trace_init_flags_exit__mq_open+0x0/0x12 @ 1
[    0.025216] initcall trace_init_flags_exit__mq_open+0x0/0x12 returned 0 after 0 usecs
[    0.025220] calling  trace_init_flags_enter__mq_open+0x0/0x12 @ 1
[    0.025224] initcall trace_init_flags_enter__mq_open+0x0/0x12 returned 0 after 0 usecs
[    0.025228] calling  trace_init_flags_exit__keyctl+0x0/0x12 @ 1
[    0.025232] initcall trace_init_flags_exit__keyctl+0x0/0x12 returned 0 after 0 usecs
[    0.025236] calling  trace_init_flags_enter__keyctl+0x0/0x12 @ 1
[    0.025239] initcall trace_init_flags_enter__keyctl+0x0/0x12 returned 0 after 0 usecs
[    0.025244] calling  trace_init_flags_exit__request_key+0x0/0x12 @ 1
[    0.025247] initcall trace_init_flags_exit__request_key+0x0/0x12 returned 0 after 0 usecs
[    0.025251] calling  trace_init_flags_enter__request_key+0x0/0x12 @ 1
[    0.025255] initcall trace_init_flags_enter__request_key+0x0/0x12 returned 0 after 0 usecs
[    0.025259] calling  trace_init_flags_exit__add_key+0x0/0x12 @ 1
[    0.025263] initcall trace_init_flags_exit__add_key+0x0/0x12 returned 0 after 0 usecs
[    0.025267] calling  trace_init_flags_enter__add_key+0x0/0x12 @ 1
[    0.025270] initcall trace_init_flags_enter__add_key+0x0/0x12 returned 0 after 0 usecs
[    0.025276] calling  trace_init_flags_exit__socketcall+0x0/0x12 @ 1
[    0.025280] initcall trace_init_flags_exit__socketcall+0x0/0x12 returned 0 after 0 usecs
[    0.025284] calling  trace_init_flags_enter__socketcall+0x0/0x12 @ 1
[    0.025288] initcall trace_init_flags_enter__socketcall+0x0/0x12 returned 0 after 0 usecs
[    0.025292] calling  trace_init_flags_exit__recvmmsg+0x0/0x12 @ 1
[    0.025296] initcall trace_init_flags_exit__recvmmsg+0x0/0x12 returned 0 after 0 usecs
[    0.025300] calling  trace_init_flags_enter__recvmmsg+0x0/0x12 @ 1
[    0.025304] initcall trace_init_flags_enter__recvmmsg+0x0/0x12 returned 0 after 0 usecs
[    0.025308] calling  trace_init_flags_exit__recvmsg+0x0/0x12 @ 1
[    0.025312] initcall trace_init_flags_exit__recvmsg+0x0/0x12 returned 0 after 0 usecs
[    0.025316] calling  trace_init_flags_enter__recvmsg+0x0/0x12 @ 1
[    0.025320] initcall trace_init_flags_enter__recvmsg+0x0/0x12 returned 0 after 0 usecs
[    0.025324] calling  trace_init_flags_exit__sendmsg+0x0/0x12 @ 1
[    0.025328] initcall trace_init_flags_exit__sendmsg+0x0/0x12 returned 0 after 0 usecs
[    0.025332] calling  trace_init_flags_enter__sendmsg+0x0/0x12 @ 1
[    0.025336] initcall trace_init_flags_enter__sendmsg+0x0/0x12 returned 0 after 0 usecs
[    0.025340] calling  trace_init_flags_exit__shutdown+0x0/0x12 @ 1
[    0.025344] initcall trace_init_flags_exit__shutdown+0x0/0x12 returned 0 after 0 usecs
[    0.025348] calling  trace_init_flags_enter__shutdown+0x0/0x12 @ 1
[    0.025352] initcall trace_init_flags_enter__shutdown+0x0/0x12 returned 0 after 0 usecs
[    0.025356] calling  trace_init_flags_exit__getsockopt+0x0/0x12 @ 1
[    0.025360] initcall trace_init_flags_exit__getsockopt+0x0/0x12 returned 0 after 0 usecs
[    0.025364] calling  trace_init_flags_enter__getsockopt+0x0/0x12 @ 1
[    0.025368] initcall trace_init_flags_enter__getsockopt+0x0/0x12 returned 0 after 0 usecs
[    0.025372] calling  trace_init_flags_exit__setsockopt+0x0/0x12 @ 1
[    0.025376] initcall trace_init_flags_exit__setsockopt+0x0/0x12 returned 0 after 0 usecs
[    0.025380] calling  trace_init_flags_enter__setsockopt+0x0/0x12 @ 1
[    0.025384] initcall trace_init_flags_enter__setsockopt+0x0/0x12 returned 0 after 0 usecs
[    0.025388] calling  trace_init_flags_exit__recvfrom+0x0/0x12 @ 1
[    0.025392] initcall trace_init_flags_exit__recvfrom+0x0/0x12 returned 0 after 0 usecs
[    0.025396] calling  trace_init_flags_enter__recvfrom+0x0/0x12 @ 1
[    0.025400] initcall trace_init_flags_enter__recvfrom+0x0/0x12 returned 0 after 0 usecs
[    0.025404] calling  trace_init_flags_exit__send+0x0/0x12 @ 1
[    0.025408] initcall trace_init_flags_exit__send+0x0/0x12 returned 0 after 0 usecs
[    0.025412] calling  trace_init_flags_enter__send+0x0/0x12 @ 1
[    0.025416] initcall trace_init_flags_enter__send+0x0/0x12 returned 0 after 0 usecs
[    0.025420] calling  trace_init_flags_exit__sendto+0x0/0x12 @ 1
[    0.025424] initcall trace_init_flags_exit__sendto+0x0/0x12 returned 0 after 0 usecs
[    0.025428] calling  trace_init_flags_enter__sendto+0x0/0x12 @ 1
[    0.025431] initcall trace_init_flags_enter__sendto+0x0/0x12 returned 0 after 0 usecs
[    0.025436] calling  trace_init_flags_exit__getpeername+0x0/0x12 @ 1
[    0.025439] initcall trace_init_flags_exit__getpeername+0x0/0x12 returned 0 after 0 usecs
[    0.025444] calling  trace_init_flags_enter__getpeername+0x0/0x12 @ 1
[    0.025447] initcall trace_init_flags_enter__getpeername+0x0/0x12 returned 0 after 0 usecs
[    0.025452] calling  trace_init_flags_exit__getsockname+0x0/0x12 @ 1
[    0.025455] initcall trace_init_flags_exit__getsockname+0x0/0x12 returned 0 after 0 usecs
[    0.025460] calling  trace_init_flags_enter__getsockname+0x0/0x12 @ 1
[    0.025463] initcall trace_init_flags_enter__getsockname+0x0/0x12 returned 0 after 0 usecs
[    0.025468] calling  trace_init_flags_exit__connect+0x0/0x12 @ 1
[    0.025471] initcall trace_init_flags_exit__connect+0x0/0x12 returned 0 after 0 usecs
[    0.025476] calling  trace_init_flags_enter__connect+0x0/0x12 @ 1
[    0.025479] initcall trace_init_flags_enter__connect+0x0/0x12 returned 0 after 0 usecs
[    0.025483] calling  trace_init_flags_exit__accept+0x0/0x12 @ 1
[    0.025487] initcall trace_init_flags_exit__accept+0x0/0x12 returned 0 after 0 usecs
[    0.025491] calling  trace_init_flags_enter__accept+0x0/0x12 @ 1
[    0.025495] initcall trace_init_flags_enter__accept+0x0/0x12 returned 0 after 0 usecs
[    0.025499] calling  trace_init_flags_exit__accept4+0x0/0x12 @ 1
[    0.025503] initcall trace_init_flags_exit__accept4+0x0/0x12 returned 0 after 0 usecs
[    0.025507] calling  trace_init_flags_enter__accept4+0x0/0x12 @ 1
[    0.025511] initcall trace_init_flags_enter__accept4+0x0/0x12 returned 0 after 0 usecs
[    0.025515] calling  trace_init_flags_exit__listen+0x0/0x12 @ 1
[    0.025518] initcall trace_init_flags_exit__listen+0x0/0x12 returned 0 after 0 usecs
[    0.025523] calling  trace_init_flags_enter__listen+0x0/0x12 @ 1
[    0.025526] initcall trace_init_flags_enter__listen+0x0/0x12 returned 0 after 0 usecs
[    0.025530] calling  trace_init_flags_exit__bind+0x0/0x12 @ 1
[    0.025534] initcall trace_init_flags_exit__bind+0x0/0x12 returned 0 after 0 usecs
[    0.025538] calling  trace_init_flags_enter__bind+0x0/0x12 @ 1
[    0.025542] initcall trace_init_flags_enter__bind+0x0/0x12 returned 0 after 0 usecs
[    0.025546] calling  trace_init_flags_exit__socketpair+0x0/0x12 @ 1
[    0.025549] initcall trace_init_flags_exit__socketpair+0x0/0x12 returned 0 after 0 usecs
[    0.025554] calling  trace_init_flags_enter__socketpair+0x0/0x12 @ 1
[    0.025557] initcall trace_init_flags_enter__socketpair+0x0/0x12 returned 0 after 0 usecs
[    0.025562] calling  trace_init_flags_exit__socket+0x0/0x12 @ 1
[    0.025565] initcall trace_init_flags_exit__socket+0x0/0x12 returned 0 after 0 usecs
[    0.025569] calling  trace_init_flags_enter__socket+0x0/0x12 @ 1
[    0.025573] initcall trace_init_flags_enter__socket+0x0/0x12 returned 0 after 0 usecs
[    0.025637] installing Xen timer for CPU 1
[    0.025651] cpu 1 spinlock event irq 279
[    0.025839] installing Xen timer for CPU 2
[    0.025852] cpu 2 spinlock event irq 285
[    0.026024] installing Xen timer for CPU 3
[    0.026036] cpu 3 spinlock event irq 291
[    0.026208] installing Xen timer for CPU 4
[    0.026219] cpu 4 spinlock event irq 297
[    0.026387] installing Xen timer for CPU 5
[    0.026398] cpu 5 spinlock event irq 303
[    0.026502] Brought up 6 CPUs
[    0.026586] devtmpfs: initialized
[    0.026586] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.026586] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.026586] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.026586] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.026586] calling  net_ns_init+0x0/0xf7 @ 1
[    0.026586] initcall net_ns_init+0x0/0xf7 returned 0 after 0 usecs
[    0.026586] calling  e820_mark_nvs_memory+0x0/0x49 @ 1
[    0.026586] initcall e820_mark_nvs_memory+0x0/0x49 returned 0 after 0 usecs
[    0.026586] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.026586] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.026586] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.026586] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.026586] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.026586] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 0 usecs
[    0.026586] calling  init_smp_flush+0x0/0x3d @ 1
[    0.026586] initcall init_smp_flush+0x0/0x3d returned 0 after 0 usecs
[    0.026586] calling  alloc_frozen_cpus+0x0/0x10 @ 1
[    0.026586] initcall alloc_frozen_cpus+0x0/0x10 returned 0 after 0 usecs
[    0.026586] calling  sysctl_init+0x0/0x32 @ 1
[    0.026586] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.026586] calling  ksysfs_init+0x0/0x94 @ 1
[    0.026586] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.026586] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.026586] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.026586] calling  pm_init+0x0/0x5f @ 1
[    0.026586] initcall pm_init+0x0/0x5f returned 0 after 0 usecs
[    0.026586] calling  pm_disk_init+0x0/0x19 @ 1
[    0.026586] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.026586] calling  swsusp_header_init+0x0/0x40 @ 1
[    0.026586] initcall swsusp_header_init+0x0/0x40 returned 0 after 0 usecs
[    0.026586] calling  init_ftrace_syscalls+0x0/0x86 @ 1
[    0.026586] initcall init_ftrace_syscalls+0x0/0x86 returned 0 after 0 usecs
[    0.026586] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.026586] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.026586] calling  fsnotify_init+0x0/0x26 @ 1
[    0.026586] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.026586] calling  filelock_init+0x0/0x2e @ 1
[    0.026586] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.026586] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.026586] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.026586] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.026586] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.026586] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.026586] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.026586] calling  debugfs_init+0x0/0x5c @ 1
[    0.026586] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.026586] calling  securityfs_init+0x0/0x53 @ 1
[    0.026586] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.026586] calling  random32_init+0x0/0xd9 @ 1
[    0.026586] initcall random32_init+0x0/0xd9 returned 0 after 0 usecs
[    0.026586] calling  sfi_sysfs_init+0x0/0xdb @ 1
[    0.026586] initcall sfi_sysfs_init+0x0/0xdb returned 0 after 0 usecs
[    0.026586] calling  __gnttab_init+0x0/0x27 @ 1
[    0.026586] Grant table initialized
[    0.026586] initcall __gnttab_init+0x0/0x27 returned 0 after 0 usecs
[    0.026586] calling  regulator_init+0x0/0x6c @ 1
[    0.026586] print_constraints: dummy: 
[    0.026586] initcall regulator_init+0x0/0x6c returned 0 after 0 usecs
[    0.026586] calling  early_resume_init+0x0/0x1d0 @ 1
[    0.026586] Time:  2:14:32  Date: 03/17/11
[    0.026586] initcall early_resume_init+0x0/0x1d0 returned 0 after 0 usecs
[    0.026586] calling  cpufreq_core_init+0x0/0xa4 @ 1
[    0.026586] initcall cpufreq_core_init+0x0/0xa4 returned 0 after 0 usecs
[    0.026586] calling  cpuidle_init+0x0/0x40 @ 1
[    0.026586] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.026586] calling  sock_init+0x0/0x83 @ 1
[    0.026586] initcall sock_init+0x0/0x83 returned 0 after 0 usecs
[    0.026586] calling  net_inuse_init+0x0/0x26 @ 1
[    0.026586] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.026586] calling  netpoll_init+0x0/0x31 @ 1
[    0.026586] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.026586] calling  netlink_proto_init+0x0/0x1c6 @ 1
[    0.026586] NET: Registered protocol family 16
[    0.026586] initcall netlink_proto_init+0x0/0x1c6 returned 0 after 0 usecs
[    0.026586] calling  bdi_class_init+0x0/0x4d @ 1
[    0.026586] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.026586] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.026586] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.026586] calling  gpiolib_sysfs_init+0x0/0x95 @ 1
[    0.026586] initcall gpiolib_sysfs_init+0x0/0x95 returned 0 after 0 usecs
[    0.026586] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.026586] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.026586] calling  pci_driver_init+0x0/0x12 @ 1
[    0.026586] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.026586] calling  backlight_class_init+0x0/0x5d @ 1
[    0.026586] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.026586] calling  xenbus_init+0x0/0x27d @ 1
[    0.026586] initcall xenbus_init+0x0/0x27d returned 0 after 0 usecs
[    0.026586] calling  tty_class_init+0x0/0x38 @ 1
[    0.026586] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.026586] calling  vtconsole_class_init+0x0/0xc3 @ 1
[    0.026586] initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 usecs
[    0.026586] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.026586] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.026586] calling  register_node_type+0x0/0x12 @ 1
[    0.026586] initcall register_node_type+0x0/0x12 returned 0 after 0 usecs
[    0.026586] calling  spi_init+0x0/0x95 @ 1
[    0.026586] initcall spi_init+0x0/0x95 returned 0 after 0 usecs
[    0.026586] calling  i2c_init+0x0/0x70 @ 1
[    0.026586] initcall i2c_init+0x0/0x70 returned 0 after 0 usecs
[    0.026586] calling  amd_postcore_init+0x0/0x155 @ 1
[    0.026586] node 0 link 0: io port [1000, ffffff]
[    0.026586] TOM: 00000000c0000000 aka 3072M
[    0.026586] Fam 10h mmconf [e0000000, efffffff]
[    0.026586] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.026586] node 0 link 0: mmio [f0000000, ffffffff]
[    0.026586] node 0 link 0: mmio [a0000, bffff]
[    0.026586] node 0 link 0: mmio [c0000000, dfffffff]
[    0.026586] TOM2: 0000000240000000 aka 9216M
[    0.026586] bus: [00, 07] on node 0 link 0
[    0.026586] bus: 00 index 0 [io  0x0000-0xffff]
[    0.026586] bus: 00 index 1 [mem 0xf0000000-0xffffffff]
[    0.026586] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.026586] bus: 00 index 3 [mem 0xc0000000-0xdfffffff]
[    0.026586] bus: 00 index 4 [mem 0x240000000-0xfcffffffff]
[    0.026586] Extended Config Space enabled on 1 nodes
[    0.026586] initcall amd_postcore_init+0x0/0x155 returned 0 after 0 usecs
[    0.026586] calling  arch_kdebugfs_init+0x0/0x24 @ 1
[    0.026586] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.026586] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.026586] initcall mtrr_if_init+0x0/0x78 returned -19 after 0 usecs
[    0.026586] calling  acpi_configure_wakeup_memory+0x0/0x1e @ 1
[    0.026586] initcall acpi_configure_wakeup_memory+0x0/0x1e returned 0 after 0 usecs
[    0.026586] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.026586] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.026586] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.026586] calling  acpi_pci_init+0x0/0x65 @ 1
[    0.026586] ACPI: bus type pci registered
[    0.026586] initcall acpi_pci_init+0x0/0x65 returned 0 after 0 usecs
[    0.026586] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    0.026586] initcall setup_vcpu_hotplug_event+0x0/0x22 returned 0 after 0 usecs
[    0.026586] calling  register_xen_pci_notifier+0x0/0x33 @ 1
[    0.026586] initcall register_xen_pci_notifier+0x0/0x33 returned 0 after 0 usecs
[    0.026586] calling  dma_bus_init+0x0/0x3f @ 1
[    0.026586] initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
[    0.026586] calling  dma_channel_table_init+0x0/0x119 @ 1
[    0.026586] initcall dma_channel_table_init+0x0/0x119 returned 0 after 0 usecs
[    0.026586] calling  dmi_id_init+0x0/0x329 @ 1
[    0.026586] initcall dmi_id_init+0x0/0x329 returned 0 after 0 usecs
[    0.026586] calling  pci_arch_init+0x0/0x69 @ 1
[    0.026586] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.026586] PCI: not using MMCONFIG
[    0.026586] PCI: Using configuration type 1 for base access
[    0.026586] PCI: Using configuration type 1 for extended access
[    0.026586] initcall pci_arch_init+0x0/0x69 returned 0 after 0 usecs
[    0.026586] calling  topology_init+0x0/0x98 @ 1
[    0.026586] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
[    0.026586] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.026586] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.026586] calling  init_vdso_vars+0x0/0x219 @ 1
[    0.026586] initcall init_vdso_vars+0x0/0x219 returned 0 after 0 usecs
[    0.026586] calling  sysenter_setup+0x0/0x2e4 @ 1
[    0.026586] initcall sysenter_setup+0x0/0x2e4 returned 0 after 0 usecs
[    0.026586] calling  param_sysfs_init+0x0/0x1b2 @ 1
[    0.026586] initcall param_sysfs_init+0x0/0x1b2 returned 0 after 0 usecs
[    0.026586] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.026586] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.026586] calling  default_bdi_init+0x0/0xa7 @ 1
[    0.026586] initcall default_bdi_init+0x0/0xa7 returned 0 after 0 usecs
[    0.026586] calling  init_bio+0x0/0xe6 @ 1
[    0.026586] bio: create slab <bio-0> at 0
[    0.026586] initcall init_bio+0x0/0xe6 returned 0 after 0 usecs
[    0.026586] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.026586] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.026586] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.026586] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.026586] calling  blk_settings_init+0x0/0x2c @ 1
[    0.026586] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.026586] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.026586] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.026586] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.026586] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.026586] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.026586] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.026586] calling  genhd_device_init+0x0/0x7c @ 1
[    0.026586] initcall genhd_device_init+0x0/0x7c returned 0 after 0 usecs
[    0.026586] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    0.026586] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    0.026586] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    0.026586] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.026586] calling  stmpe_gpio_init+0x0/0x12 @ 1
[    0.026586] initcall stmpe_gpio_init+0x0/0x12 returned 0 after 0 usecs
[    0.026586] calling  tc3589x_gpio_init+0x0/0x12 @ 1
[    0.026586] initcall tc3589x_gpio_init+0x0/0x12 returned 0 after 0 usecs
[    0.026586] calling  sx150x_init+0x0/0x14 @ 1
[    0.026586] initcall sx150x_init+0x0/0x14 returned 0 after 0 usecs
[    0.026586] calling  pci_slot_init+0x0/0x50 @ 1
[    0.026586] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    0.026586] calling  fbmem_init+0x0/0x98 @ 1
[    0.026586] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.026586] calling  acpi_init+0x0/0x10b @ 1
[    0.032000] ACPI: EC: Look up EC in DSDT
[    0.034845] ACPI: Executed 3 blocks of module-level executable AML code
[    0.081251] ACPI: Interpreter enabled
[    0.081256] ACPI: (supports S0 S3 S4 S5)
[    0.081283] ACPI: Using IOAPIC for interrupt routing
[    0.081319] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.084015] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.170058] initcall acpi_init+0x0/0x10b returned 0 after 146484 usecs
[    0.170082] calling  dock_init+0x0/0xa5 @ 1
[    0.170287] ACPI: No dock devices found.
[    0.170291] initcall dock_init+0x0/0xa5 returned 0 after 0 usecs
[    0.170294] calling  acpi_pci_root_init+0x0/0x32 @ 1
[    0.170297] HEST: Table not found.
[    0.170301] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.170615] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.170878] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.170882] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.170886] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.170890] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.170894] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.170897] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.170924] pci 0000:00:00.0: [1002:5a11] type 0 class 0x000600
[    0.171027] pci 0000:00:00.2: [1002:5a23] type 0 class 0x000806
[    0.171140] pci 0000:00:02.0: [1002:5a16] type 1 class 0x000604
[    0.171201] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.171206] pci 0000:00:02.0: PME# disabled
[    0.171235] pci 0000:00:04.0: [1002:5a18] type 1 class 0x000604
[    0.171295] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.171301] pci 0000:00:04.0: PME# disabled
[    0.171337] pci 0000:00:0b.0: [1002:5a1f] type 1 class 0x000604
[    0.171396] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.171402] pci 0000:00:0b.0: PME# disabled
[    0.171443] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.171471] pci 0000:00:11.0: reg 10: [io  0xa000-0xa007]
[    0.171485] pci 0000:00:11.0: reg 14: [io  0x9000-0x9003]
[    0.171498] pci 0000:00:11.0: reg 18: [io  0x8000-0x8007]
[    0.171511] pci 0000:00:11.0: reg 1c: [io  0x7000-0x7003]
[    0.171524] pci 0000:00:11.0: reg 20: [io  0x6000-0x600f]
[    0.171537] pci 0000:00:11.0: reg 24: [mem 0xf9fffc00-0xf9ffffff]
[    0.171608] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.171626] pci 0000:00:12.0: reg 10: [mem 0xf9ffe000-0xf9ffefff]
[    0.171715] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.171740] pci 0000:00:12.2: reg 10: [mem 0xf9fff800-0xf9fff8ff]
[    0.171830] pci 0000:00:12.2: supports D1 D2
[    0.171832] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.171838] pci 0000:00:12.2: PME# disabled
[    0.171865] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.171883] pci 0000:00:13.0: reg 10: [mem 0xf9ffd000-0xf9ffdfff]
[    0.171972] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.171997] pci 0000:00:13.2: reg 10: [mem 0xf9fff400-0xf9fff4ff]
[    0.172086] pci 0000:00:13.2: supports D1 D2
[    0.172089] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.172095] pci 0000:00:13.2: PME# disabled
[    0.172123] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.172222] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.172250] pci 0000:00:14.2: reg 10: [mem 0xf9ff4000-0xf9ff7fff 64bit]
[    0.172324] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.172330] pci 0000:00:14.2: PME# disabled
[    0.172346] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.172441] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.172493] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.172511] pci 0000:00:14.5: reg 10: [mem 0xf9ffc000-0xf9ffcfff]
[    0.172600] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.172678] pci 0000:00:15.0: supports D1 D2
[    0.172711] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.172789] pci 0000:00:15.1: supports D1 D2
[    0.172825] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.172843] pci 0000:00:16.0: reg 10: [mem 0xf9ff3000-0xf9ff3fff]
[    0.172933] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.172958] pci 0000:00:16.2: reg 10: [mem 0xf9fff000-0xf9fff0ff]
[    0.173048] pci 0000:00:16.2: supports D1 D2
[    0.173051] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.173057] pci 0000:00:16.2: PME# disabled
[    0.173085] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.173132] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.173169] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.173209] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.173256] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.173365] pci 0000:01:00.0: [10de:0402] type 0 class 0x000300
[    0.173381] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.173399] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.173417] pci 0000:01:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.173430] pci 0000:01:00.0: reg 24: [io  0xb800-0xb87f]
[    0.173442] pci 0000:01:00.0: reg 30: [mem 0xfe6e0000-0xfe6fffff pref]
[    0.190089] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.190117] pci 0000:00:02.0:   bridge window [io  0xb000-0xbfff]
[    0.190123] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfe6fffff]
[    0.190131] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.190212] pci 0000:02:00.0: [8086:10d3] type 0 class 0x000200
[    0.190240] pci 0000:02:00.0: reg 10: [mem 0xfe7e0000-0xfe7fffff]
[    0.190260] pci 0000:02:00.0: reg 14: [mem 0xfe700000-0xfe77ffff]
[    0.190280] pci 0000:02:00.0: reg 18: [io  0xc800-0xc81f]
[    0.190300] pci 0000:02:00.0: reg 1c: [mem 0xfe7dc000-0xfe7dffff]
[    0.190353] pci 0000:02:00.0: reg 30: [mem 0xfe780000-0xfe7bffff pref]
[    0.190414] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.190422] pci 0000:02:00.0: PME# disabled
[    0.210092] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.210118] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    0.210123] pci 0000:00:04.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.210131] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.210204] pci 0000:03:00.0: [1002:9540] type 0 class 0x000300
[    0.210229] pci 0000:03:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.210248] pci 0000:03:00.0: reg 18: [mem 0xfe8e0000-0xfe8effff 64bit]
[    0.210262] pci 0000:03:00.0: reg 20: [io  0xd000-0xd0ff]
[    0.210285] pci 0000:03:00.0: reg 30: [mem 0xfe8c0000-0xfe8dffff pref]
[    0.210319] pci 0000:03:00.0: supports D1 D2
[    0.210352] pci 0000:03:00.1: [1002:aa38] type 0 class 0x000403
[    0.210375] pci 0000:03:00.1: reg 10: [mem 0xfe8fc000-0xfe8fffff 64bit]
[    0.210458] pci 0000:03:00.1: supports D1 D2
[    0.230092] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.230118] pci 0000:00:0b.0:   bridge window [io  0xd000-0xdfff]
[    0.230123] pci 0000:00:0b.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.230131] pci 0000:00:0b.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.230207] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.230213] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.230220] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.230227] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.230231] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.230236] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.230240] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.230244] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.230248] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.230253] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.230320] pci 0000:00:15.0: PCI bridge to [bus 06-06]
[    0.230328] pci 0000:00:15.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.230335] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.230344] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.230432] pci 0000:05:00.0: [10ec:8168] type 0 class 0x000200
[    0.230456] pci 0000:05:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.230494] pci 0000:05:00.0: reg 18: [mem 0xf8fff000-0xf8ffffff 64bit pref]
[    0.230519] pci 0000:05:00.0: reg 20: [mem 0xf8ff8000-0xf8ffbfff 64bit pref]
[    0.230536] pci 0000:05:00.0: reg 30: [mem 0xfe9e0000-0xfe9fffff pref]
[    0.230590] pci 0000:05:00.0: supports D1 D2
[    0.230593] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.230601] pci 0000:05:00.0: PME# disabled
[    0.250095] pci 0000:00:15.1: PCI bridge to [bus 05-05]
[    0.250120] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.250126] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.250135] pci 0000:00:15.1:   bridge window [mem 0xf8f00000-0xf8ffffff 64bit pref]
[    0.250173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.250610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.250721] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.250783] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC02._PRT]
[    0.250831] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC04._PRT]
[    0.250882] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC0B._PRT]
[    0.250929] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.251126]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.251406]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.262910] initcall acpi_pci_root_init+0x0/0x32 returned 0 after 87890 usecs
[    0.262916] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.262973] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 14 15)
[    0.263078] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 12 14 15)
[    0.263190] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 14 15)
[    0.263300] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 12 14 15)
[    0.263388] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.263455] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.263522] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.263589] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.263620] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 0 usecs
[    0.263624] calling  pnp_init+0x0/0x12 @ 1
[    0.263635] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.263640] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    0.263644] initcall xen_setup_shutdown_event+0x0/0x30 returned 0 after 0 usecs
[    0.263648] calling  balloon_init+0x0/0x124 @ 1
[    0.263651] xen/balloon: Initialising balloon driver.
[    0.263655] last_pfn = 0x27fefe max_arch_pfn = 0x400000000
[    0.270016] initcall balloon_init+0x0/0x124 returned 0 after 9765 usecs
[    0.270022] calling  xenbus_probe_backend_init+0x0/0x2d @ 1
[    0.270049] initcall xenbus_probe_backend_init+0x0/0x2d returned 0 after 0 usecs
[    0.270053] calling  xenbus_probe_frontend_init+0x0/0x2d @ 1
[    0.270064] initcall xenbus_probe_frontend_init+0x0/0x2d returned 0 after 0 usecs
[    0.270068] calling  balloon_init+0x0/0x102 @ 1
[    0.270071] xen-balloon: Initialising balloon driver.
[    0.270088] initcall balloon_init+0x0/0x102 returned 0 after 0 usecs
[    0.270092] calling  pm8607_regulator_init+0x0/0x12 @ 1
[    0.270104] initcall pm8607_regulator_init+0x0/0x12 returned 0 after 0 usecs
[    0.270108] calling  ab8500_regulator_init+0x0/0x31 @ 1
[    0.270117] initcall ab8500_regulator_init+0x0/0x31 returned 0 after 0 usecs
[    0.270121] calling  misc_init+0x0/0xba @ 1
[    0.270138] initcall misc_init+0x0/0xba returned 0 after 0 usecs
[    0.270142] calling  vga_arb_device_init+0x0/0x77 @ 1
[    0.270213] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.270222] vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=none,locks=none
[    0.270227] vgaarb: loaded
[    0.270230] initcall vga_arb_device_init+0x0/0x77 returned 0 after 0 usecs
[    0.270235] calling  cn_init+0x0/0xa3 @ 1
[    0.270249] initcall cn_init+0x0/0xa3 returned 0 after 0 usecs
[    0.270252] calling  pm860x_i2c_init+0x0/0x33 @ 1
[    0.270262] initcall pm860x_i2c_init+0x0/0x33 returned 0 after 0 usecs
[    0.270266] calling  stmpe_init+0x0/0x14 @ 1
[    0.270274] initcall stmpe_init+0x0/0x14 returned 0 after 0 usecs
[    0.270278] calling  tc3589x_init+0x0/0x14 @ 1
[    0.270286] initcall tc3589x_init+0x0/0x14 returned 0 after 0 usecs
[    0.270290] calling  wm831x_i2c_init+0x0/0x33 @ 1
[    0.270298] initcall wm831x_i2c_init+0x0/0x33 returned 0 after 0 usecs
[    0.270302] calling  wm831x_spi_init+0x0/0xe8 @ 1
[    0.270337] initcall wm831x_spi_init+0x0/0xe8 returned 0 after 0 usecs
[    0.270341] calling  wm8350_i2c_init+0x0/0x14 @ 1
[    0.270349] initcall wm8350_i2c_init+0x0/0x14 returned 0 after 0 usecs
[    0.270353] calling  da903x_init+0x0/0x14 @ 1
[    0.270363] initcall da903x_init+0x0/0x14 returned 0 after 0 usecs
[    0.270366] calling  max8925_i2c_init+0x0/0x33 @ 1
[    0.270375] initcall max8925_i2c_init+0x0/0x33 returned 0 after 0 usecs
[    0.270378] calling  max8998_i2c_init+0x0/0x14 @ 1
[    0.270386] initcall max8998_i2c_init+0x0/0x14 returned 0 after 0 usecs
[    0.270390] calling  ab3100_i2c_init+0x0/0x14 @ 1
[    0.270398] initcall ab3100_i2c_init+0x0/0x14 returned 0 after 0 usecs
[    0.270402] calling  ab3550_i2c_init+0x0/0x14 @ 1
[    0.270410] initcall ab3550_i2c_init+0x0/0x14 returned 0 after 0 usecs
[    0.270414] calling  ab8500_debug_init+0x0/0x12 @ 1
[    0.270423] initcall ab8500_debug_init+0x0/0x12 returned 0 after 0 usecs
[    0.270426] calling  tps6586x_init+0x0/0x14 @ 1
[    0.270435] initcall tps6586x_init+0x0/0x14 returned 0 after 0 usecs
[    0.270438] calling  init_scsi+0x0/0x91 @ 1
[    0.270519] SCSI subsystem initialized
[    0.270523] initcall init_scsi+0x0/0x91 returned 0 after 0 usecs
[    0.270526] calling  ata_init+0x0/0x4c8 @ 1
[    0.270595] libata version 3.00 loaded.
[    0.270595] initcall ata_init+0x0/0x4c8 returned 0 after 0 usecs
[    0.270595] calling  phy_init+0x0/0x2e @ 1
[    0.270595] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.270595] calling  usb_init+0x0/0x15f @ 1
[    0.270595] usbcore: registered new interface driver usbfs
[    0.270595] usbcore: registered new interface driver hub
[    0.270595] usbcore: registered new device driver usb
[    0.270595] initcall usb_init+0x0/0x15f returned 0 after 0 usecs
[    0.270595] calling  serio_init+0x0/0x31 @ 1
[    0.270595] initcall serio_init+0x0/0x31 returned 0 after 0 usecs
[    0.270595] calling  input_init+0x0/0x10c @ 1
[    0.270595] initcall input_init+0x0/0x10c returned 0 after 0 usecs
[    0.270595] calling  rtc_init+0x0/0x71 @ 1
[    0.270595] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.270595] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.270595] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.270595] calling  hwmon_init+0x0/0xee @ 1
[    0.270595] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    0.270595] calling  md_init+0x0/0x143 @ 1
[    0.270595] initcall md_init+0x0/0x143 returned 0 after 0 usecs
[    0.270595] calling  mmc_init+0x0/0x72 @ 1
[    0.270595] initcall mmc_init+0x0/0x72 returned 0 after 0 usecs
[    0.270595] calling  leds_init+0x0/0x48 @ 1
[    0.270595] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.270595] calling  acpi_wmi_init+0x0/0x72 @ 1
[    0.270595] wmi: Mapper loaded
[    0.270595] initcall acpi_wmi_init+0x0/0x72 returned 0 after 0 usecs
[    0.270595] calling  pci_subsys_init+0x0/0x4d @ 1
[    0.270595] PCI: Using ACPI for IRQ routing
[    0.270595] PCI: pci_cache_line_size set to 64 bytes
[    0.270595] reserve RAM buffer: 000000000009b000 - 000000000009ffff 
[    0.270595] reserve RAM buffer: 00000000bffb0000 - 00000000bfffffff 
[    0.270595] reserve RAM buffer: 000000027fefe000 - 000000027fffffff 
[    0.270595] initcall pci_subsys_init+0x0/0x4d returned 0 after 0 usecs
[    0.270595] calling  proto_init+0x0/0x12 @ 1
[    0.270595] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.270595] calling  net_dev_init+0x0/0x1b1 @ 1
[    0.270595] initcall net_dev_init+0x0/0x1b1 returned 0 after 0 usecs
[    0.270595] calling  neigh_init+0x0/0x71 @ 1
[    0.270595] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.270595] calling  fib_rules_init+0x0/0xa6 @ 1
[    0.270595] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
[    0.270595] calling  pktsched_init+0x0/0xec @ 1
[    0.270595] initcall pktsched_init+0x0/0xec returned 0 after 0 usecs
[    0.270595] calling  tc_filter_init+0x0/0x4c @ 1
[    0.270595] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    0.270595] calling  tc_action_init+0x0/0x4c @ 1
[    0.270595] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    0.270595] calling  genl_init+0x0/0x84 @ 1
[    0.270595] initcall genl_init+0x0/0x84 returned 0 after 0 usecs
[    0.270595] calling  cipso_v4_init+0x0/0x61 @ 1
[    0.270595] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    0.270595] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    0.270595] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.270595] calling  netlbl_init+0x0/0x81 @ 1
[    0.270595] NetLabel: Initializing
[    0.270595] NetLabel:  domain hash size = 128
[    0.270595] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.270595] NetLabel:  unlabeled traffic allowed by default
[    0.270595] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.270595] calling  rfkill_init+0x0/0x79 @ 1
[    0.270595] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    0.270595] calling  sysctl_init+0x0/0x48 @ 1
[    0.270595] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    0.270595] calling  print_ICs+0x0/0x526 @ 1
[    0.270595] initcall print_ICs+0x0/0x526 returned 0 after 0 usecs
[    0.270595] calling  hpet_late_init+0x0/0x101 @ 1
[    0.270595] initcall hpet_late_init+0x0/0x101 returned -19 after 0 usecs
[    0.270595] calling  init_amd_nbs+0x0/0x3f @ 1
[    0.270595] initcall init_amd_nbs+0x0/0x3f returned 0 after 0 usecs
[    0.270595] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.270595] Switching to clocksource xen
[    0.270672] initcall clocksource_done_booting+0x0/0x5a returned 0 after 4 usecs
[    0.270678] calling  ftrace_init_debugfs+0x0/0x20f @ 1
[    0.270714] initcall ftrace_init_debugfs+0x0/0x20f returned 0 after 29 usecs
[    0.270718] calling  rb_init_debugfs+0x0/0x2f @ 1
[    0.270724] initcall rb_init_debugfs+0x0/0x2f returned 0 after 1 usecs
[    0.270728] calling  tracer_init_debugfs+0x0/0x3a0 @ 1
[    0.270825] initcall tracer_init_debugfs+0x0/0x3a0 returned 0 after 89 usecs
[    0.270830] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.270836] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 1 usecs
[    0.270842] calling  event_trace_init+0x0/0x2bd @ 1
[    0.273948] Switched to NOHz mode on CPU #1
[    0.274070] Switched to NOHz mode on CPU #2
[    0.274341] Switched to NOHz mode on CPU #3
[    0.274577] Switched to NOHz mode on CPU #4
[    0.274586] Switched to NOHz mode on CPU #5
[    0.277223] initcall event_trace_init+0x0/0x2bd returned 0 after 6225 usecs
[    0.277230] calling  init_kprobe_trace+0x0/0x78 @ 1
[    0.277236] initcall init_kprobe_trace+0x0/0x78 returned 0 after 2 usecs
[    0.277241] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.277256] initcall init_pipe_fs+0x0/0x4c returned 0 after 11 usecs
[    0.277260] calling  eventpoll_init+0x0/0xda @ 1
[    0.277267] initcall eventpoll_init+0x0/0xda returned 0 after 3 usecs
[    0.277270] calling  anon_inode_init+0x0/0x12b @ 1
[    0.277280] initcall anon_inode_init+0x0/0x12b returned 0 after 5 usecs
[    0.277284] calling  tomoyo_initerface_init+0x0/0x17b @ 1
[    0.277288] initcall tomoyo_initerface_init+0x0/0x17b returned 0 after 0 usecs
[    0.277292] calling  aa_create_aafs+0x0/0x103 @ 1
[    0.277306] AppArmor: AppArmor Filesystem Enabled
[    0.277310] initcall aa_create_aafs+0x0/0x103 returned 0 after 14 usecs
[    0.277314] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.277317] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.277322] calling  acpi_event_init+0x0/0x81 @ 1
[    0.277332] initcall acpi_event_init+0x0/0x81 returned 0 after 6 usecs
[    0.277336] calling  pnp_system_init+0x0/0x12 @ 1
[    0.277350] initcall pnp_system_init+0x0/0x12 returned 0 after 10 usecs
[    0.277354] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.277357] pnp: PnP ACPI init
[    0.277373] ACPI: bus type pnp registered
[    0.277530] pnp 00:00: [bus 00-ff]
[    0.277534] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.277537] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.277540] pnp 00:00: [io  0x0d00-0xffff window]
[    0.277544] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.277547] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.277551] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.277554] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.277617] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.277727] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.277732] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.277786] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.277855] pnp 00:02: [mem 0xf6000000-0xf6003fff]
[    0.277900] system 00:02: [mem 0xf6000000-0xf6003fff] has been reserved
[    0.277904] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.278011] pnp 00:03: [dma 4]
[    0.278014] pnp 00:03: [io  0x0000-0x000f]
[    0.278017] pnp 00:03: [io  0x0081-0x0083]
[    0.278020] pnp 00:03: [io  0x0087]
[    0.278023] pnp 00:03: [io  0x0089-0x008b]
[    0.278026] pnp 00:03: [io  0x008f]
[    0.278028] pnp 00:03: [io  0x00c0-0x00df]
[    0.278065] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.278080] pnp 00:04: [io  0x0070-0x0071]
[    0.278084] xen: registering gsi 8 triggering 1 polarity 0
[    0.278088] xen_map_pirq_gsi: returning irq 8 for gsi 8
[    0.278091] xen: --> pirq=8 -> irq=8
[    0.278106] pnp 00:04: [irq 8]
[    0.278141] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.278153] pnp 00:05: [io  0x0061]
[    0.278187] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.278199] pnp 00:06: [io  0x00f0-0x00ff]
[    0.278202] xen: registering gsi 13 triggering 1 polarity 0
[    0.278205] xen_map_pirq_gsi: returning irq 13 for gsi 13
[    0.278208] xen: --> pirq=13 -> irq=13
[    0.278217] pnp 00:06: [irq 13]
[    0.278254] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.278294] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.278330] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.278468] pnp 00:08: [mem 0xfec00000-0xfec00fff]
[    0.278471] pnp 00:08: [mem 0xfee00000-0xfee00fff]
[    0.278531] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.278535] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.278539] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.278759] pnp 00:09: [io  0x0010-0x001f]
[    0.278762] pnp 00:09: [io  0x0022-0x003f]
[    0.278765] pnp 00:09: [io  0x0062-0x0063]
[    0.278768] pnp 00:09: [io  0x0065-0x006f]
[    0.278771] pnp 00:09: [io  0x0072-0x007f]
[    0.278773] pnp 00:09: [io  0x0080]
[    0.278776] pnp 00:09: [io  0x0084-0x0086]
[    0.278779] pnp 00:09: [io  0x0088]
[    0.278782] pnp 00:09: [io  0x008c-0x008e]
[    0.278785] pnp 00:09: [io  0x0090-0x009f]
[    0.278787] pnp 00:09: [io  0x00a2-0x00bf]
[    0.278790] pnp 00:09: [io  0x00b1]
[    0.278793] pnp 00:09: [io  0x00e0-0x00ef]
[    0.278796] pnp 00:09: [io  0x04d0-0x04d1]
[    0.278799] pnp 00:09: [io  0x040b]
[    0.278801] pnp 00:09: [io  0x04d6]
[    0.278804] pnp 00:09: [io  0x0c00-0x0c01]
[    0.278807] pnp 00:09: [io  0x0c14]
[    0.278810] pnp 00:09: [io  0x0c50-0x0c51]
[    0.278812] pnp 00:09: [io  0x0c52]
[    0.278815] pnp 00:09: [io  0x0c6c]
[    0.278818] pnp 00:09: [io  0x0c6f]
[    0.278820] pnp 00:09: [io  0x0cd0-0x0cd1]
[    0.278823] pnp 00:09: [io  0x0cd2-0x0cd3]
[    0.278826] pnp 00:09: [io  0x0cd4-0x0cd5]
[    0.278830] pnp 00:09: [io  0x0cd6-0x0cd7]
[    0.278833] pnp 00:09: [io  0x0cd8-0x0cdf]
[    0.278836] pnp 00:09: [io  0x0800-0x089f]
[    0.278839] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.278842] pnp 00:09: [io  0x0b00-0x0b1f]
[    0.278845] pnp 00:09: [io  0x0b20-0x0b3f]
[    0.278848] pnp 00:09: [io  0x0900-0x090f]
[    0.278851] pnp 00:09: [io  0x0910-0x091f]
[    0.278854] pnp 00:09: [io  0xfe00-0xfefe]
[    0.278857] pnp 00:09: [io  0x0060-0x005f disabled]
[    0.278860] pnp 00:09: [io  0x0064-0x0063 disabled]
[    0.278863] pnp 00:09: [mem 0xffb80000-0xffbfffff]
[    0.278866] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.278869] pnp 00:09: [mem 0xfed80000-0xfed80fff]
[    0.278872] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.278962] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.278966] system 00:09: [io  0x040b] has been reserved
[    0.278969] system 00:09: [io  0x04d6] has been reserved
[    0.278973] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    0.278976] system 00:09: [io  0x0c14] has been reserved
[    0.278980] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    0.278983] system 00:09: [io  0x0c52] has been reserved
[    0.278987] system 00:09: [io  0x0c6c] has been reserved
[    0.278990] system 00:09: [io  0x0c6f] has been reserved
[    0.278994] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    0.278997] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    0.279001] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    0.279005] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    0.279008] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    0.279012] system 00:09: [io  0x0800-0x089f] has been reserved
[    0.279016] system 00:09: [io  0x0b00-0x0b1f] has been reserved
[    0.279019] system 00:09: [io  0x0b20-0x0b3f] has been reserved
[    0.279023] system 00:09: [io  0x0900-0x090f] has been reserved
[    0.279027] system 00:09: [io  0x0910-0x091f] has been reserved
[    0.279030] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    0.279034] system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.279038] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.279042] system 00:09: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.279046] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.279083] pnp 00:0a: [io  0x0060]
[    0.279086] pnp 00:0a: [io  0x0064]
[    0.279089] xen: registering gsi 1 triggering 1 polarity 0
[    0.279091] xen_map_pirq_gsi: returning irq 1 for gsi 1
[    0.279094] xen: --> pirq=1 -> irq=1
[    0.279103] pnp 00:0a: [irq 1]
[    0.279149] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.279149] Switched to NOHz mode on CPU #0
[    0.279149] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.279149] pnp 00:0b: [io  0x0a00-0x0a0f]
[    0.279149] pnp 00:0b: [io  0x0a10-0x0a1f]
[    0.279149] pnp 00:0b: [io  0x0a20-0x0a2f]
[    0.279149] pnp 00:0b: [io  0x0a30-0x0a3f]
[    0.279149] system 00:0b: [io  0x0a00-0x0a0f] has been reserved
[    0.279149] system 00:0b: [io  0x0a10-0x0a1f] has been reserved
[    0.279149] system 00:0b: [io  0x0a20-0x0a2f] has been reserved
[    0.279149] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
[    0.279149] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.279758] pnp 00:0c: [io  0x03f8-0x03ff]
[    0.279761] xen: registering gsi 4 triggering 1 polarity 0
[    0.279764] xen_map_pirq_gsi: returning irq 4 for gsi 4
[    0.279767] xen: --> pirq=4 -> irq=4
[    0.279776] pnp 00:0c: [irq 4]
[    0.279778] pnp 00:0c: [dma 0 disabled]
[    0.279862] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.280392] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.280463] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.280468] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.280684] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.280687] pnp 00:0e: [mem 0x000c0000-0x000cffff]
[    0.280691] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    0.280694] pnp 00:0e: [mem 0x00100000-0xbfffffff]
[    0.280697] pnp 00:0e: [mem 0xfec00000-0xffffffff]
[    0.280763] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.280767] system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.280771] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.280775] system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.280779] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.280784] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.280941] pnp: PnP ACPI: found 15 devices
[    0.280944] ACPI: ACPI bus type pnp unregistered
[    0.280948] initcall pnpacpi_init+0x0/0x8c returned 0 after 4156 usecs
[    0.280952] calling  pcistub_init+0x0/0x1d7 @ 1
[    0.280957] pciback: wants to seize 0000:03:00.0
[    0.280960] pciback: wants to seize 0000:03:00.1
[    0.280964] pciback: wants to seize 0000:02:00.0
[    0.281054] pciback 0000:00:00.0: probing...
[    0.281109] pciback 0000:00:00.2: probing...
[    0.281149] pciback 0000:00:02.0: probing...
[    0.281196] pciback 0000:00:04.0: probing...
[    0.281246] pciback 0000:00:0b.0: probing...
[    0.281293] pciback 0000:00:11.0: probing...
[    0.281339] pciback 0000:00:12.0: probing...
[    0.281386] pciback 0000:00:12.2: probing...
[    0.281433] pciback 0000:00:13.0: probing...
[    0.281482] pciback 0000:00:13.2: probing...
[    0.281529] pciback 0000:00:14.0: probing...
[    0.281576] pciback 0000:00:14.2: probing...
[    0.281622] pciback 0000:00:14.3: probing...
[    0.281669] pciback 0000:00:14.4: probing...
[    0.281717] pciback 0000:00:14.5: probing...
[    0.281765] pciback 0000:00:15.0: probing...
[    0.281812] pciback 0000:00:15.1: probing...
[    0.281858] pciback 0000:00:16.0: probing...
[    0.281904] pciback 0000:00:16.2: probing...
[    0.281955] pciback 0000:00:18.0: probing...
[    0.282003] pciback 0000:00:18.1: probing...
[    0.282050] pciback 0000:00:18.2: probing...
[    0.282096] pciback 0000:00:18.3: probing...
[    0.282142] pciback 0000:00:18.4: probing...
[    0.282192] pciback 0000:01:00.0: probing...
[    0.282238] pciback 0000:02:00.0: probing...
[    0.282242] pciback 0000:02:00.0: seizing device
[    0.282244] pciback 0000:02:00.0: pcistub_device_alloc
[    0.282248] pciback 0000:02:00.0: deferring initialization
[    0.282293] pciback 0000:03:00.0: probing...
[    0.282296] pciback 0000:03:00.0: seizing device
[    0.282299] pciback 0000:03:00.0: pcistub_device_alloc
[    0.282302] pciback 0000:03:00.0: deferring initialization
[    0.282347] pciback 0000:03:00.1: probing...
[    0.282350] pciback 0000:03:00.1: seizing device
[    0.282353] pciback 0000:03:00.1: pcistub_device_alloc
[    0.282356] pciback 0000:03:00.1: deferring initialization
[    0.282400] pciback 0000:05:00.0: probing...
[    0.282429] initcall pcistub_init+0x0/0x1d7 returned 0 after 1437 usecs
[    0.282433] calling  chr_dev_init+0x0/0xc6 @ 1
[    0.283822] initcall chr_dev_init+0x0/0xc6 returned 0 after 1352 usecs
[    0.283827] calling  firmware_class_init+0x0/0x19 @ 1
[    0.283836] initcall firmware_class_init+0x0/0x19 returned 0 after 5 usecs
[    0.283840] calling  thermal_init+0x0/0x75 @ 1
[    0.283852] initcall thermal_init+0x0/0x75 returned 0 after 7 usecs
[    0.283856] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.283861] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    0.283865] calling  init_acpi_pm_clocksource+0x0/0xe3 @ 1
[    0.286010] PM-Timer failed consistency check  (0x0xffffff) - aborting.
[    0.286013] initcall init_acpi_pm_clocksource+0x0/0xe3 returned -19 after 2094 usecs
[    0.286018] calling  pcibios_assign_resources+0x0/0x76 @ 1
[    0.286087] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.286094] pci 0000:00:02.0:   bridge window [io  0xb000-0xbfff]
[    0.286101] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfe6fffff]
[    0.286106] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.286114] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.286118] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    0.286124] pci 0000:00:04.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.286129] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.286137] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.286141] pci 0000:00:0b.0:   bridge window [io  0xd000-0xdfff]
[    0.286147] pci 0000:00:0b.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.286152] pci 0000:00:0b.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.286160] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.286163] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.286170] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.286176] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.286185] pci 0000:00:15.0: PCI bridge to [bus 06-06]
[    0.286187] pci 0000:00:15.0:   bridge window [io  disabled]
[    0.286194] pci 0000:00:15.0:   bridge window [mem disabled]
[    0.286200] pci 0000:00:15.0:   bridge window [mem pref disabled]
[    0.286208] pci 0000:00:15.1: PCI bridge to [bus 05-05]
[    0.286212] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.286219] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.286225] pci 0000:00:15.1:   bridge window [mem 0xf8f00000-0xf8ffffff 64bit pref]
[    0.286240] xen: registering gsi 18 triggering 0 polarity 1
[    0.286251] xen: --> pirq=18 -> irq=18
[    0.286263] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.286269] pci 0000:00:02.0: setting latency timer to 64
[    0.286277] xen: registering gsi 16 triggering 0 polarity 1
[    0.286282] xen: --> pirq=16 -> irq=16
[    0.286290] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.286296] pci 0000:00:04.0: setting latency timer to 64
[    0.286307] xen: registering gsi 19 triggering 0 polarity 1
[    0.286312] xen: --> pirq=19 -> irq=19
[    0.286320] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.286325] pci 0000:00:0b.0: setting latency timer to 64
[    0.286339] xen: registering gsi 16 triggering 0 polarity 1
[    0.286342] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    0.286345] xen: --> pirq=16 -> irq=16
[    0.286348] Already setup the GSI :16
[    0.286351] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.286357] pci 0000:00:15.0: setting latency timer to 64
[    0.286365] xen: registering gsi 16 triggering 0 polarity 1
[    0.286368] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    0.286371] xen: --> pirq=16 -> irq=16
[    0.286374] Already setup the GSI :16
[    0.286377] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.286383] pci 0000:00:15.1: setting latency timer to 64
[    0.286389] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.286392] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.286396] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.286399] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.286403] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.286406] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.286410] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.286413] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfe6fffff]
[    0.286417] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.286421] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.286424] pci_bus 0000:02: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.286428] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.286431] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.286435] pci_bus 0000:03: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.286439] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.286442] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.286446] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.286449] pci_bus 0000:04: resource 7 [mem 0x000d0000-0x000dffff]
[    0.286456] pci_bus 0000:04: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.286459] pci_bus 0000:04: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.286463] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    0.286466] pci_bus 0000:05: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.286470] pci_bus 0000:05: resource 2 [mem 0xf8f00000-0xf8ffffff 64bit pref]
[    0.286474] initcall pcibios_assign_resources+0x0/0x76 returned 0 after 442 usecs
[    0.286479] calling  sysctl_core_init+0x0/0x38 @ 1
[    0.286494] initcall sysctl_core_init+0x0/0x38 returned 0 after 10 usecs
[    0.286498] calling  inet_init+0x0/0x243 @ 1
[    0.286517] NET: Registered protocol family 2
[    0.287251] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.289421] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.291353] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.291579] TCP: Hash tables configured (established 524288 bind 65536)
[    0.291583] TCP reno registered
[    0.291625] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.291761] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.291927] initcall inet_init+0x0/0x243 returned 0 after 5294 usecs
[    0.291932] calling  af_unix_init+0x0/0x55 @ 1
[    0.291936] NET: Registered protocol family 1
[    0.291943] initcall af_unix_init+0x0/0x55 returned 0 after 7 usecs
[    0.291948] calling  pci_apply_final_quirks+0x0/0x10a @ 1
[    1.170368] pci 0000:01:00.0: Boot video device
[    1.170392] PCI: CLS 64 bytes, default 64
[    1.170397] initcall pci_apply_final_quirks+0x0/0x10a returned 0 after 857855 usecs
[    1.170404] calling  populate_rootfs+0x0/0xd3 @ 1
[    1.170480] Trying to unpack rootfs image as initramfs...
[    1.417637] Freeing initrd memory: 323416k freed
[    1.502360] initcall populate_rootfs+0x0/0xd3 returned 0 after 324164 usecs
[    1.502368] calling  pci_iommu_init+0x0/0x41 @ 1
[    1.502373] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    1.502377] calling  calgary_fixup_tce_spaces+0x0/0x101 @ 1
[    1.502382] initcall calgary_fixup_tce_spaces+0x0/0x101 returned -19 after 0 usecs
[    1.502386] calling  i8259A_init_sysfs+0x0/0x31 @ 1
[    1.502505] initcall i8259A_init_sysfs+0x0/0x31 returned 0 after 107 usecs
[    1.502514] calling  vsyscall_init+0x0/0x6c @ 1
[    1.502637] initcall vsyscall_init+0x0/0x6c returned 0 after 115 usecs
[    1.502641] calling  sbf_init+0x0/0xf6 @ 1
[    1.502646] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
[    1.502651] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    1.502664] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 8 usecs
[    1.502669] calling  init_tsc_clocksource+0x0/0x5f @ 1
[    1.502680] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 6 usecs
[    1.502685] calling  add_rtc_cmos+0x0/0x96 @ 1
[    1.502691] initcall add_rtc_cmos+0x0/0x96 returned 0 after 2 usecs
[    1.502697] calling  cache_sysfs_init+0x0/0x71 @ 1
[    1.503096] initcall cache_sysfs_init+0x0/0x71 returned 0 after 385 usecs
[    1.503101] calling  mcheck_init_device+0x0/0x10b @ 1
[    1.503105] initcall mcheck_init_device+0x0/0x10b returned -5 after 0 usecs
[    1.503110] initcall mcheck_init_device+0x0/0x10b returned with error code -5 
[    1.503115] calling  threshold_init_device+0x0/0x8f @ 1
[    1.503120] initcall threshold_init_device+0x0/0x8f returned 0 after 0 usecs
[    1.503124] calling  thermal_throttle_init_device+0x0/0x9d @ 1
[    1.503128] initcall thermal_throttle_init_device+0x0/0x9d returned 0 after 0 usecs
[    1.503134] calling  ioapic_init_sysfs+0x0/0xbb @ 1
[    1.503148] initcall ioapic_init_sysfs+0x0/0xbb returned 0 after 9 usecs
[    1.503152] calling  add_pcspkr+0x0/0x3a @ 1
[    1.503203] initcall add_pcspkr+0x0/0x3a returned 0 after 44 usecs
[    1.503208] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    1.503213] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
[    1.503218] calling  audit_classes_init+0x0/0xaf @ 1
[    1.503225] initcall audit_classes_init+0x0/0xaf returned 0 after 2 usecs
[    1.503230] calling  crc32c_intel_mod_init+0x0/0x26 @ 1
[    1.503234] initcall crc32c_intel_mod_init+0x0/0x26 returned -19 after 0 usecs
[    1.503239] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    1.503246] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 2 usecs
[    1.503251] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    1.503259] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 4 usecs
[    1.503264] calling  proc_schedstat_init+0x0/0x22 @ 1
[    1.503270] initcall proc_schedstat_init+0x0/0x22 returned 0 after 1 usecs
[    1.503274] calling  proc_execdomains_init+0x0/0x22 @ 1
[    1.503280] initcall proc_execdomains_init+0x0/0x22 returned 0 after 1 usecs
[    1.503285] calling  ioresources_init+0x0/0x3c @ 1
[    1.503292] initcall ioresources_init+0x0/0x3c returned 0 after 2 usecs
[    1.503299] calling  uid_cache_init+0x0/0x95 @ 1
[    1.503307] initcall uid_cache_init+0x0/0x95 returned 0 after 3 usecs
[    1.503311] calling  init_posix_timers+0x0/0x17a @ 1
[    1.503322] initcall init_posix_timers+0x0/0x17a returned 0 after 7 usecs
[    1.503327] calling  init_posix_cpu_timers+0x0/0xe5 @ 1
[    1.503331] initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 0 usecs
[    1.503335] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    1.503340] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
[    1.503345] calling  create_proc_profile+0x0/0x2c0 @ 1
[    1.503349] initcall create_proc_profile+0x0/0x2c0 returned 0 after 0 usecs
[    1.503357] calling  timekeeping_init_device+0x0/0x22 @ 1
[    1.503375] initcall timekeeping_init_device+0x0/0x22 returned 0 after 13 usecs
[    1.503379] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    1.503391] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 7 usecs
[    1.503394] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    1.503399] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 1 usecs
[    1.503403] calling  init_tstats_procfs+0x0/0x2c @ 1
[    1.503408] initcall init_tstats_procfs+0x0/0x2c returned 0 after 1 usecs
[    1.503412] calling  futex_init+0x0/0x69 @ 1
[    1.503420] initcall futex_init+0x0/0x69 returned 0 after 5 usecs
[    1.503424] calling  proc_dma_init+0x0/0x22 @ 1
[    1.503428] initcall proc_dma_init+0x0/0x22 returned 0 after 1 usecs
[    1.503433] calling  proc_modules_init+0x0/0x22 @ 1
[    1.503438] initcall proc_modules_init+0x0/0x22 returned 0 after 1 usecs
[    1.503441] calling  kallsyms_init+0x0/0x25 @ 1
[    1.503446] initcall kallsyms_init+0x0/0x25 returned 0 after 1 usecs
[    1.503450] calling  snapshot_device_init+0x0/0x12 @ 1
[    1.503499] initcall snapshot_device_init+0x0/0x12 returned 0 after 43 usecs
[    1.503503] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    1.503522] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 14 usecs
[    1.503526] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    1.503532] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 1 usecs
[    1.503536] calling  user_namespaces_init+0x0/0x2d @ 1
[    1.503543] initcall user_namespaces_init+0x0/0x2d returned 0 after 3 usecs
[    1.503547] calling  pid_namespaces_init+0x0/0x2d @ 1
[    1.503553] initcall pid_namespaces_init+0x0/0x2d returned 0 after 2 usecs
[    1.503556] calling  audit_init+0x0/0x133 @ 1
[    1.503559] audit: initializing netlink socket (disabled)
[    1.503576] type=2000 audit(1300328074.224:1): initialized
[    1.503581] initcall audit_init+0x0/0x133 returned 0 after 20 usecs
[    1.503585] calling  audit_watch_init+0x0/0x3a @ 1
[    1.503589] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    1.503592] calling  audit_tree_init+0x0/0x49 @ 1
[    1.503596] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    1.503600] calling  init_kprobes+0x0/0x197 @ 1
[    1.511766] initcall init_kprobes+0x0/0x197 returned 0 after 7969 usecs
[    1.511770] calling  hung_task_init+0x0/0x53 @ 1
[    1.511843] initcall hung_task_init+0x0/0x53 returned 0 after 67 usecs
[    1.511848] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    1.511862] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 10 usecs
[    1.511867] calling  init_tracepoints+0x0/0x20 @ 1
[    1.511871] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    1.511875] calling  init_lstats_procfs+0x0/0x25 @ 1
[    1.511882] initcall init_lstats_procfs+0x0/0x25 returned 0 after 3 usecs
[    1.511887] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
[    1.511891] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 0 usecs
[    1.511895] calling  init_events+0x0/0x61 @ 1
[    1.511903] initcall init_events+0x0/0x61 returned 0 after 4 usecs
[    1.511907] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    1.511911] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 0 usecs
[    1.511915] calling  init_function_trace+0x0/0x3e @ 1
[    1.511920] initcall init_function_trace+0x0/0x3e returned 0 after 0 usecs
[    1.511924] calling  init_wakeup_tracer+0x0/0x22 @ 1
[    1.511928] initcall init_wakeup_tracer+0x0/0x22 returned 0 after 0 usecs
[    1.511932] calling  stack_trace_init+0x0/0x6b @ 1
[    1.511948] initcall stack_trace_init+0x0/0x6b returned 0 after 12 usecs
[    1.511952] calling  init_mmio_trace+0x0/0x12 @ 1
[    1.511956] initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
[    1.511960] calling  init_graph_trace+0x0/0x66 @ 1
[    1.511965] initcall init_graph_trace+0x0/0x66 returned 0 after 1 usecs
[    1.511969] calling  init_blk_tracer+0x0/0x5a @ 1
[    1.511974] initcall init_blk_tracer+0x0/0x5a returned 0 after 0 usecs
[    1.511978] calling  perf_event_sysfs_init+0x0/0x99 @ 1
[    1.512037] initcall perf_event_sysfs_init+0x0/0x99 returned 0 after 53 usecs
[    1.512041] calling  init_per_zone_wmark_min+0x0/0x74 @ 1
[    1.512492] initcall init_per_zone_wmark_min+0x0/0x74 returned 0 after 436 usecs
[    1.512496] calling  kswapd_init+0x0/0x76 @ 1
[    1.512579] initcall kswapd_init+0x0/0x76 returned 0 after 77 usecs
[    1.512583] calling  extfrag_debug_init+0x0/0x72 @ 1
[    1.512592] initcall extfrag_debug_init+0x0/0x72 returned 0 after 5 usecs
[    1.512596] calling  setup_vmstat+0x0/0xcd @ 1
[    1.512652] initcall setup_vmstat+0x0/0xcd returned 0 after 51 usecs
[    1.512657] calling  mm_sysfs_init+0x0/0x29 @ 1
[    1.512665] initcall mm_sysfs_init+0x0/0x29 returned 0 after 3 usecs
[    1.512670] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    1.512676] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 1 usecs
[    1.512681] calling  procswaps_init+0x0/0x22 @ 1
[    1.512689] initcall procswaps_init+0x0/0x22 returned 0 after 1 usecs
[    1.512693] calling  hugetlb_init+0x0/0x442 @ 1
[    1.512698] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.512713] initcall hugetlb_init+0x0/0x442 returned 0 after 15 usecs
[    1.512717] calling  ksm_init+0x0/0x159 @ 1
[    1.512769] initcall ksm_init+0x0/0x159 returned 0 after 45 usecs
[    1.512773] calling  slab_proc_init+0x0/0x25 @ 1
[    1.512780] initcall slab_proc_init+0x0/0x25 returned 0 after 2 usecs
[    1.512784] calling  slab_sysfs_init+0x0/0x108 @ 1
[    1.514141] initcall slab_sysfs_init+0x0/0x108 returned 0 after 1320 usecs
[    1.514146] calling  fcntl_init+0x0/0x2a @ 1
[    1.514154] initcall fcntl_init+0x0/0x2a returned 0 after 3 usecs
[    1.514159] calling  proc_filesystems_init+0x0/0x22 @ 1
[    1.514165] initcall proc_filesystems_init+0x0/0x22 returned 0 after 1 usecs
[    1.514170] calling  fsnotify_mark_init+0x0/0x3d @ 1
[    1.514312] initcall fsnotify_mark_init+0x0/0x3d returned 0 after 134 usecs
[    1.514317] calling  dnotify_init+0x0/0x7b @ 1
[    1.514355] initcall dnotify_init+0x0/0x7b returned 0 after 32 usecs
[    1.514359] calling  inotify_user_setup+0x0/0x70 @ 1
[    1.514371] initcall inotify_user_setup+0x0/0x70 returned 0 after 7 usecs
[    1.514375] calling  fanotify_user_setup+0x0/0x52 @ 1
[    1.514387] initcall fanotify_user_setup+0x0/0x52 returned 0 after 7 usecs
[    1.514392] calling  aio_setup+0x0/0xab @ 1
[    1.514455] initcall aio_setup+0x0/0xab returned 0 after 57 usecs
[    1.514460] calling  proc_locks_init+0x0/0x22 @ 1
[    1.514467] initcall proc_locks_init+0x0/0x22 returned 0 after 2 usecs
[    1.514472] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    1.514546] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 68 usecs
[    1.514550] calling  init_mbcache+0x0/0x14 @ 1
[    1.514555] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[    1.514559] calling  dquot_init+0x0/0x116 @ 1
[    1.514562] VFS: Disk quotas dquot_6.5.2
[    1.514627] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.514631] initcall dquot_init+0x0/0x116 returned 0 after 66 usecs
[    1.514635] calling  quota_init+0x0/0x26 @ 1
[    1.514642] initcall quota_init+0x0/0x26 returned 0 after 3 usecs
[    1.514646] calling  proc_cmdline_init+0x0/0x22 @ 1
[    1.514651] initcall proc_cmdline_init+0x0/0x22 returned 0 after 1 usecs
[    1.514655] calling  proc_consoles_init+0x0/0x22 @ 1
[    1.514660] initcall proc_consoles_init+0x0/0x22 returned 0 after 1 usecs
[    1.514664] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    1.514669] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 1 usecs
[    1.514673] calling  proc_devices_init+0x0/0x22 @ 1
[    1.514679] initcall proc_devices_init+0x0/0x22 returned 0 after 2 usecs
[    1.514683] calling  proc_interrupts_init+0x0/0x22 @ 1
[    1.514688] initcall proc_interrupts_init+0x0/0x22 returned 0 after 1 usecs
[    1.514692] calling  proc_loadavg_init+0x0/0x22 @ 1
[    1.514697] initcall proc_loadavg_init+0x0/0x22 returned 0 after 1 usecs
[    1.514701] calling  proc_meminfo_init+0x0/0x22 @ 1
[    1.514706] initcall proc_meminfo_init+0x0/0x22 returned 0 after 1 usecs
[    1.514709] calling  proc_stat_init+0x0/0x22 @ 1
[    1.514714] initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
[    1.514718] calling  proc_uptime_init+0x0/0x22 @ 1
[    1.514723] initcall proc_uptime_init+0x0/0x22 returned 0 after 1 usecs
[    1.514727] calling  proc_version_init+0x0/0x22 @ 1
[    1.514732] initcall proc_version_init+0x0/0x22 returned 0 after 1 usecs
[    1.514736] calling  proc_softirqs_init+0x0/0x22 @ 1
[    1.514741] initcall proc_softirqs_init+0x0/0x22 returned 0 after 1 usecs
[    1.514746] calling  proc_kcore_init+0x0/0xa9 @ 1
[    1.514755] initcall proc_kcore_init+0x0/0xa9 returned 0 after 5 usecs
[    1.514759] calling  vmcore_init+0x0/0x39d @ 1
[    1.514763] initcall vmcore_init+0x0/0x39d returned 0 after 0 usecs
[    1.514767] calling  proc_kmsg_init+0x0/0x25 @ 1
[    1.514772] initcall proc_kmsg_init+0x0/0x25 returned 0 after 1 usecs
[    1.514776] calling  proc_page_init+0x0/0x42 @ 1
[    1.514782] initcall proc_page_init+0x0/0x42 returned 0 after 2 usecs
[    1.514786] calling  init_devpts_fs+0x0/0x4c @ 1
[    1.514803] initcall init_devpts_fs+0x0/0x4c returned 0 after 13 usecs
[    1.514807] calling  init_ext3_fs+0x0/0x77 @ 1
[    1.514858] initcall init_ext3_fs+0x0/0x77 returned 0 after 46 usecs
[    1.514862] calling  init_ext2_fs+0x0/0x77 @ 1
[    1.514888] initcall init_ext2_fs+0x0/0x77 returned 0 after 21 usecs
[    1.514892] calling  ext4_init_fs+0x0/0x1f9 @ 1
[    1.515018] initcall ext4_init_fs+0x0/0x1f9 returned 0 after 118 usecs
[    1.515022] calling  journal_init+0x0/0xa3 @ 1
[    1.515095] initcall journal_init+0x0/0xa3 returned 0 after 68 usecs
[    1.515099] calling  journal_init+0x0/0x114 @ 1
[    1.515120] initcall journal_init+0x0/0x114 returned 0 after 16 usecs
[    1.515124] calling  init_ramfs_fs+0x0/0x12 @ 1
[    1.515129] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    1.515133] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    1.515171] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 33 usecs
[    1.515175] calling  ecryptfs_init+0x0/0x1d6 @ 1
[    1.515391] initcall ecryptfs_init+0x0/0x1d6 returned 0 after 207 usecs
[    1.515396] calling  fuse_init+0x0/0x140 @ 1
[    1.515399] fuse init (API version 7.16)
[    1.515469] initcall fuse_init+0x0/0x140 returned 0 after 67 usecs
[    1.515473] calling  ipc_init+0x0/0x23 @ 1
[    1.515479] msgmni has been set to 13372
[    1.515486] initcall ipc_init+0x0/0x23 returned 0 after 9 usecs
[    1.515490] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    1.515509] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 15 usecs
[    1.515513] calling  init_mqueue_fs+0x0/0xb4 @ 1
[    1.515554] initcall init_mqueue_fs+0x0/0xb4 returned 0 after 36 usecs
[    1.515558] calling  key_proc_init+0x0/0x33 @ 1
[    1.515563] initcall key_proc_init+0x0/0x33 returned 0 after 2 usecs
[    1.515567] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    1.515571] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 0 usecs
[    1.515574] calling  init_sel_fs+0x0/0x68 @ 1
[    1.515577] initcall init_sel_fs+0x0/0x68 returned 0 after 0 usecs
[    1.515581] calling  selnl_init+0x0/0x4d @ 1
[    1.515588] initcall selnl_init+0x0/0x4d returned 0 after 4 usecs
[    1.515592] calling  sel_netif_init+0x0/0x66 @ 1
[    1.515595] initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
[    1.515599] calling  sel_netnode_init+0x0/0x75 @ 1
[    1.515602] initcall sel_netnode_init+0x0/0x75 returned 0 after 0 usecs
[    1.515605] calling  sel_netport_init+0x0/0x75 @ 1
[    1.515609] initcall sel_netport_init+0x0/0x75 returned 0 after 0 usecs
[    1.515612] calling  aurule_init+0x0/0x37 @ 1
[    1.515616] initcall aurule_init+0x0/0x37 returned 0 after 0 usecs
[    1.515619] calling  init_smk_fs+0x0/0x7b @ 1
[    1.515623] initcall init_smk_fs+0x0/0x7b returned 0 after 0 usecs
[    1.515626] calling  crypto_wq_init+0x0/0x31 @ 1
[    1.515698] initcall crypto_wq_init+0x0/0x31 returned 0 after 66 usecs
[    1.515702] calling  crypto_algapi_init+0x0/0xd @ 1
[    1.515707] initcall crypto_algapi_init+0x0/0xd returned 0 after 2 usecs
[    1.515711] calling  skcipher_module_init+0x0/0x33 @ 1
[    1.515715] initcall skcipher_module_init+0x0/0x33 returned 0 after 0 usecs
[    1.515718] calling  chainiv_module_init+0x0/0x12 @ 1
[    1.515722] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.515726] calling  eseqiv_module_init+0x0/0x12 @ 1
[    1.515730] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.515734] calling  hmac_module_init+0x0/0x12 @ 1
[    1.515738] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.515742] calling  md5_mod_init+0x0/0x12 @ 1
[    1.515788] initcall md5_mod_init+0x0/0x12 returned 0 after 41 usecs
[    1.515792] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    1.515795] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.515799] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    1.515803] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    1.515806] calling  crc32c_mod_init+0x0/0x12 @ 1
[    1.515851] initcall crc32c_mod_init+0x0/0x12 returned 0 after 40 usecs
[    1.515855] calling  krng_mod_init+0x0/0x12 @ 1
[    1.515897] initcall krng_mod_init+0x0/0x12 returned 0 after 37 usecs
[    1.515902] calling  proc_genhd_init+0x0/0x3c @ 1
[    1.515908] initcall proc_genhd_init+0x0/0x3c returned 0 after 3 usecs
[    1.515912] calling  bsg_init+0x0/0x12e @ 1
[    1.515952] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.515957] initcall bsg_init+0x0/0x12e returned 0 after 40 usecs
[    1.515960] calling  init_cgroup_blkio+0x0/0x12 @ 1
[    1.515964] initcall init_cgroup_blkio+0x0/0x12 returned 0 after 0 usecs
[    1.515968] calling  throtl_init+0x0/0x44 @ 1
[    1.516006] initcall throtl_init+0x0/0x44 returned 0 after 33 usecs
[    1.516010] calling  noop_init+0x0/0x14 @ 1
[    1.516013] io scheduler noop registered
[    1.516016] initcall noop_init+0x0/0x14 returned 0 after 3 usecs
[    1.516020] calling  deadline_init+0x0/0x14 @ 1
[    1.516023] io scheduler deadline registered
[    1.516026] initcall deadline_init+0x0/0x14 returned 0 after 2 usecs
[    1.516030] calling  cfq_init+0x0/0xb3 @ 1
[    1.516063] io scheduler cfq registered (default)
[    1.516067] initcall cfq_init+0x0/0xb3 returned 0 after 33 usecs
[    1.516070] calling  percpu_counter_startup+0x0/0x33 @ 1
[    1.516075] initcall percpu_counter_startup+0x0/0x33 returned 0 after 0 usecs
[    1.516079] calling  lnw_gpio_init+0x0/0x45 @ 1
[    1.516106] initcall lnw_gpio_init+0x0/0x45 returned 0 after 23 usecs
[    1.516110] calling  timbgpio_init+0x0/0x12 @ 1
[    1.516119] initcall timbgpio_init+0x0/0x12 returned 0 after 4 usecs
[    1.516122] calling  ucb1400_gpio_init+0x0/0x12 @ 1
[    1.516131] initcall ucb1400_gpio_init+0x0/0x12 returned 0 after 4 usecs
[    1.516135] calling  pci_proc_init+0x0/0x6a @ 1
[    1.516205] initcall pci_proc_init+0x0/0x6a returned 0 after 64 usecs
[    1.516209] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    1.516323] pcieport 0000:00:02.0: setting latency timer to 64
[    1.516548] pcieport 0000:00:04.0: setting latency timer to 64
[    1.516732] pcieport 0000:00:0b.0: setting latency timer to 64
[    1.516928] pcieport 0000:00:15.0: setting latency timer to 64
[    1.517165] pcieport 0000:00:15.1: setting latency timer to 64
[    1.517354] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 1112 usecs
[    1.517362] calling  aer_service_init+0x0/0x2b @ 1
[    1.517374] initcall aer_service_init+0x0/0x2b returned 0 after 8 usecs
[    1.517378] calling  pcie_pme_service_init+0x0/0x12 @ 1
[    1.517421] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    1.517424] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.517430] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    1.517456] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    1.517460] pciback 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    1.517465] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    1.517491] pcieport 0000:00:0b.0: Signaling PME through PCIe PME interrupt
[    1.517494] pciback 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    1.517498] pciback 0000:03:00.1: Signaling PME through PCIe PME interrupt
[    1.517503] pcie_pme 0000:00:0b.0:pcie01: service driver pcie_pme loaded
[    1.517528] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.517534] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.517558] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.517562] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    1.517568] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.517577] initcall pcie_pme_service_init+0x0/0x12 returned 0 after 190 usecs
[    1.517581] calling  ioapic_init+0x0/0x1b @ 1
[    1.517594] initcall ioapic_init+0x0/0x1b returned 0 after 9 usecs
[    1.517598] calling  pci_hotplug_init+0x0/0x4e @ 1
[    1.517601] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.517605] initcall pci_hotplug_init+0x0/0x4e returned 0 after 3 usecs
[    1.517608] calling  pcied_init+0x0/0xf3 @ 1
[    1.517631] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.517636] initcall pcied_init+0x0/0xf3 returned 0 after 23 usecs
[    1.517639] calling  pcifront_init+0x0/0x5e @ 1
[    1.517643] initcall pcifront_init+0x0/0x5e returned -19 after 0 usecs
[    1.517647] calling  fb_console_init+0x0/0x121 @ 1
[    1.517669] initcall fb_console_init+0x0/0x121 returned 0 after 17 usecs
[    1.517673] calling  imsttfb_init+0x0/0xfc @ 1
[    1.517686] initcall imsttfb_init+0x0/0xfc returned 0 after 9 usecs
[    1.517690] calling  asiliantfb_init+0x0/0x34 @ 1
[    1.517704] initcall asiliantfb_init+0x0/0x34 returned 0 after 9 usecs
[    1.517708] calling  vesafb_init+0x0/0x24c @ 1
[    1.517750] initcall vesafb_init+0x0/0x24c returned -19 after 37 usecs
[    1.517754] calling  efifb_init+0x0/0x1f5 @ 1
[    1.517762] initcall efifb_init+0x0/0x1f5 returned -19 after 4 usecs
[    1.517766] calling  intel_idle_init+0x0/0x3a1 @ 1
[    1.517770] initcall intel_idle_init+0x0/0x3a1 returned -19 after 0 usecs
[    1.517774] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    1.517780] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 2 usecs
[    1.517784] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    1.517796] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 7 usecs
[    1.517800] calling  acpi_ac_init+0x0/0x45 @ 1
[    1.517824] initcall acpi_ac_init+0x0/0x45 returned 0 after 20 usecs
[    1.517828] calling  acpi_button_init+0x0/0x56 @ 1
[    1.517876] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.670169] ACPI: Power Button [PWRB]
[    1.670257] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.670266] ACPI: Power Button [PWRF]
[    1.670287] initcall acpi_button_init+0x0/0x56 returned 0 after 148880 usecs
[    1.670291] calling  acpi_fan_init+0x0/0x18 @ 1
[    1.670308] initcall acpi_fan_init+0x0/0x18 returned 0 after 12 usecs
[    1.670312] calling  acpi_pci_slot_init+0x0/0x20 @ 1
[    1.670596] initcall acpi_pci_slot_init+0x0/0x20 returned 0 after 273 usecs
[    1.670600] calling  acpi_processor_init+0x0/0xcd @ 1
[    1.670604] ACPI: acpi_idle registered with cpuidle
[    1.670886] initcall acpi_processor_init+0x0/0xcd returned 0 after 273 usecs
[    1.670893] calling  acpi_container_init+0x0/0x4a @ 1
[    1.673324] initcall acpi_container_init+0x0/0x4a returned 0 after 2369 usecs
[    1.673328] calling  acpi_thermal_init+0x0/0x42 @ 1
[    1.673620] thermal LNXTHERM:00: registered as thermal_zone0
[    1.673624] ACPI: Thermal Zone [THRM] (50 C)
[    1.673633] initcall acpi_thermal_init+0x0/0x42 returned 0 after 293 usecs
[    1.673637] calling  acpi_battery_init+0x0/0x16 @ 1
[    1.673646] initcall acpi_battery_init+0x0/0x16 returned 0 after 4 usecs
[    1.673650] calling  acpi_smb_hc_init+0x0/0x18 @ 1
[    1.673695] initcall acpi_smb_hc_init+0x0/0x18 returned 0 after 40 usecs
[    1.673699] calling  acpi_sbs_init+0x0/0x4f @ 1
[    1.673722] calling  1_acpi_battery_init_async+0x0/0x3c @ 5
[    1.673738] initcall 1_acpi_battery_init_async+0x0/0x3c returned 0 after 10 usecs
[    1.673750] initcall acpi_sbs_init+0x0/0x4f returned 0 after 45 usecs
[    1.673754] calling  erst_init+0x0/0x25a @ 1
[    1.673757] ERST: Table is not found!
[    1.673760] initcall erst_init+0x0/0x25a returned 0 after 3 usecs
[    1.673764] calling  xenbus_probe_initcall+0x0/0x3b @ 1
[    1.673767] initcall xenbus_probe_initcall+0x0/0x3b returned 0 after 0 usecs
[    1.673771] calling  evtchn_init+0x0/0x77 @ 1
[    1.673816] Event-channel device installed.
[    1.673820] initcall evtchn_init+0x0/0x77 returned 0 after 44 usecs
[    1.673823] calling  pciback_init+0x0/0x142 @ 1
[    1.673827] pciback: pcistub_init_devices_late
[    1.673830] pciback 0000:03:00.1: initializing...
[    1.673834] pciback 0000:03:00.1: initializing config
[    1.673837] pciback 0000:03:00.1: initializing virtual configuration space
[    1.673841] pciback 0000:03:00.1: added config field at offset 0x00
[    1.673845] pciback 0000:03:00.1: added config field at offset 0x02
[    1.673848] pciback 0000:03:00.1: added config field at offset 0x04
[    1.673851] pciback 0000:03:00.1: added config field at offset 0x3c
[    1.673855] pciback 0000:03:00.1: added config field at offset 0x3d
[    1.673860] pciback 0000:03:00.1: added config field at offset 0x0c
[    1.673864] pciback 0000:03:00.1: added config field at offset 0x0d
[    1.673867] pciback 0000:03:00.1: added config field at offset 0x0f
[    1.673871] pciback 0000:03:00.1: added config field at offset 0x10
[    1.673875] pciback 0000:03:00.1: added config field at offset 0x14
[    1.673878] pciback 0000:03:00.1: added config field at offset 0x18
[    1.673882] pciback 0000:03:00.1: added config field at offset 0x1c
[    1.673885] pciback 0000:03:00.1: added config field at offset 0x20
[    1.673889] pciback 0000:03:00.1: added config field at offset 0x24
[    1.673893] pciback 0000:03:00.1: added config field at offset 0x30
[    1.673914] pciback 0000:03:00.1: Found capability 0x1 at 0x50
[    1.673917] pciback 0000:03:00.1: added config field at offset 0x50
[    1.673921] pciback 0000:03:00.1: added config field at offset 0x52
[    1.673926] pciback 0000:03:00.1: added config field at offset 0x54
[    1.673930] pciback 0000:03:00.1: added config field at offset 0x56
[    1.673933] pciback 0000:03:00.1: added config field at offset 0x57
[    1.673936] pciback 0000:03:00.1: enabling device
[    1.673946] xen: registering gsi 16 triggering 0 polarity 1
[    1.673951] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    1.673954] xen: --> pirq=16 -> irq=16
[    1.673959] Already setup the GSI :16
[    1.673962] pciback 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.673966] pciback 0000:03:00.1: reset device
[    1.673974] pciback 0000:03:00.1: PCI INT B disabled
[    1.673978] pciback 0000:03:00.0: initializing...
[    1.673982] pciback 0000:03:00.0: initializing config
[    1.673985] pciback 0000:03:00.0: initializing virtual configuration space
[    1.673988] pciback 0000:03:00.0: added config field at offset 0x00
[    1.673992] pciback 0000:03:00.0: added config field at offset 0x02
[    1.673995] pciback 0000:03:00.0: added config field at offset 0x04
[    1.673999] pciback 0000:03:00.0: added config field at offset 0x3c
[    1.674002] pciback 0000:03:00.0: added config field at offset 0x3d
[    1.674005] pciback 0000:03:00.0: added config field at offset 0x0c
[    1.674009] pciback 0000:03:00.0: added config field at offset 0x0d
[    1.674012] pciback 0000:03:00.0: added config field at offset 0x0f
[    1.674016] pciback 0000:03:00.0: added config field at offset 0x10
[    1.674020] pciback 0000:03:00.0: added config field at offset 0x14
[    1.674024] pciback 0000:03:00.0: added config field at offset 0x18
[    1.674027] pciback 0000:03:00.0: added config field at offset 0x1c
[    1.674031] pciback 0000:03:00.0: added config field at offset 0x20
[    1.674034] pciback 0000:03:00.0: added config field at offset 0x24
[    1.674038] pciback 0000:03:00.0: added config field at offset 0x30
[    1.674058] pciback 0000:03:00.0: Found capability 0x1 at 0x50
[    1.674061] pciback 0000:03:00.0: added config field at offset 0x50
[    1.674065] pciback 0000:03:00.0: added config field at offset 0x52
[    1.674070] pciback 0000:03:00.0: added config field at offset 0x54
[    1.674073] pciback 0000:03:00.0: added config field at offset 0x56
[    1.674077] pciback 0000:03:00.0: added config field at offset 0x57
[    1.674080] pciback 0000:03:00.0: enabling device
[    1.674087] pciback 0000:03:00.0: enabling device (0000 -> 0003)
[    1.674092] xen: registering gsi 19 triggering 0 polarity 1
[    1.674095] xen_map_pirq_gsi: returning irq 19 for gsi 19
[    1.674098] xen: --> pirq=19 -> irq=19
[    1.674101] Already setup the GSI :19
[    1.674104] pciback 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.674108] pciback 0000:03:00.0: reset device
[    1.674112] pciback 0000:03:00.0: PCI INT A disabled
[    1.674117] pciback 0000:02:00.0: initializing...
[    1.674120] pciback 0000:02:00.0: initializing config
[    1.674123] pciback 0000:02:00.0: initializing virtual configuration space
[    1.674127] pciback 0000:02:00.0: added config field at offset 0x00
[    1.674130] pciback 0000:02:00.0: added config field at offset 0x02
[    1.674133] pciback 0000:02:00.0: added config field at offset 0x04
[    1.674137] pciback 0000:02:00.0: added config field at offset 0x3c
[    1.674140] pciback 0000:02:00.0: added config field at offset 0x3d
[    1.674144] pciback 0000:02:00.0: added config field at offset 0x0c
[    1.674147] pciback 0000:02:00.0: added config field at offset 0x0d
[    1.674151] pciback 0000:02:00.0: added config field at offset 0x0f
[    1.674154] pciback 0000:02:00.0: added config field at offset 0x10
[    1.674158] pciback 0000:02:00.0: added config field at offset 0x14
[    1.674161] pciback 0000:02:00.0: added config field at offset 0x18
[    1.674166] pciback 0000:02:00.0: added config field at offset 0x1c
[    1.674169] pciback 0000:02:00.0: added config field at offset 0x20
[    1.674173] pciback 0000:02:00.0: added config field at offset 0x24
[    1.674178] pciback 0000:02:00.0: added config field at offset 0x30
[    1.674212] pciback 0000:02:00.0: Found capability 0x1 at 0xc8
[    1.674216] pciback 0000:02:00.0: added config field at offset 0xc8
[    1.674219] pciback 0000:02:00.0: added config field at offset 0xca
[    1.674225] pciback 0000:02:00.0: added config field at offset 0xcc
[    1.674228] pciback 0000:02:00.0: added config field at offset 0xce
[    1.674232] pciback 0000:02:00.0: added config field at offset 0xcf
[    1.674235] pciback 0000:02:00.0: enabling device
[    1.674244] xen: registering gsi 16 triggering 0 polarity 1
[    1.674247] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    1.674250] xen: --> pirq=16 -> irq=16
[    1.674253] Already setup the GSI :16
[    1.674256] pciback 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.674259] pciback 0000:02:00.0: reset device
[    1.674267] pciback 0000:02:00.0: PCI INT A disabled
[    1.674348] initcall pciback_init+0x0/0x142 returned 0 after 508 usecs
[    1.674353] calling  gntdev_init+0x0/0x4d @ 1
[    1.674378] initcall gntdev_init+0x0/0x4d returned 0 after 20 usecs
[    1.674381] calling  gntalloc_init+0x0/0x3d @ 1
[    1.674405] initcall gntalloc_init+0x0/0x3d returned 0 after 19 usecs
[    1.674408] calling  blkif_init+0x0/0x264 @ 1
[    1.674653] initcall blkif_init+0x0/0x264 returned 0 after 235 usecs
[    1.674657] calling  xenfs_init+0x0/0x2d @ 1
[    1.674662] initcall xenfs_init+0x0/0x2d returned 0 after 1 usecs
[    1.674666] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    1.674669] initcall hypervisor_subsys_init+0x0/0x25 returned 0 after 0 usecs
[    1.674673] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    1.674689] initcall hyper_sysfs_init+0x0/0xfb returned 0 after 12 usecs
[    1.674693] calling  pty_init+0x0/0x524 @ 1
[    1.674738] initcall pty_init+0x0/0x524 returned 0 after 40 usecs
[    1.674742] calling  sysrq_init+0x0/0x78 @ 1
[    1.674749] initcall sysrq_init+0x0/0x78 returned 0 after 4 usecs
[    1.674753] calling  xen_hvc_init+0x0/0x143 @ 1
[    1.674990] initcall xen_hvc_init+0x0/0x143 returned 0 after 228 usecs
[    1.674995] calling  serial8250_init+0x0/0x195 @ 1
[    1.674998] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.684814] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.000242] initcall serial8250_init+0x0/0x195 returned 0 after 317619 usecs
[    2.000248] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    2.010212] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.021167] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 20425 usecs
[    2.021172] calling  serial8250_pci_init+0x0/0x1b @ 1
[    2.021201] initcall serial8250_pci_init+0x0/0x1b returned 0 after 24 usecs
[    2.021205] calling  init_kgdboc+0x0/0x16 @ 1
[    2.021210] initcall init_kgdboc+0x0/0x16 returned 0 after 1 usecs
[    2.021215] calling  rand_initialize+0x0/0x40 @ 1
[    2.021227] initcall rand_initialize+0x0/0x40 returned 0 after 8 usecs
[    2.021231] calling  ttyprintk_init+0x0/0x156 @ 1
[    2.021261] initcall ttyprintk_init+0x0/0x156 returned 0 after 26 usecs
[    2.021265] calling  hpet_init+0x0/0x6a @ 1
[    2.021359] hpet_acpi_add: no address or irqs in _CRS
[    2.021372] initcall hpet_init+0x0/0x6a returned 0 after 100 usecs
[    2.021376] calling  agp_init+0x0/0x26 @ 1
[    2.021378] Linux agpgart interface v0.103
[    2.021382] initcall agp_init+0x0/0x26 returned 0 after 2 usecs
[    2.021385] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    2.022508] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 1091 usecs
[    2.022513] calling  agp_intel_init+0x0/0x29 @ 1
[    2.022531] initcall agp_intel_init+0x0/0x29 returned 0 after 13 usecs
[    2.022534] calling  agp_via_init+0x0/0x29 @ 1
[    2.022548] initcall agp_via_init+0x0/0x29 returned 0 after 9 usecs
[    2.022552] calling  cn_proc_init+0x0/0x3d @ 1
[    2.022556] initcall cn_proc_init+0x0/0x3d returned 0 after 1 usecs
[    2.022561] calling  topology_sysfs_init+0x0/0x5d @ 1
[    2.022584] initcall topology_sysfs_init+0x0/0x5d returned 0 after 18 usecs
[    2.022588] calling  brd_init+0x0/0x1a8 @ 1
[    2.023703] brd: module loaded
[    2.023708] initcall brd_init+0x0/0x1a8 returned 0 after 1090 usecs
[    2.023712] calling  loop_init+0x0/0x1b9 @ 1
[    2.024156] loop: module loaded
[    2.024160] initcall loop_init+0x0/0x1b9 returned 0 after 433 usecs
[    2.024164] calling  pkt_init+0x0/0x1e6 @ 1
[    2.024219] initcall pkt_init+0x0/0x1e6 returned 0 after 50 usecs
[    2.024223] calling  htcpld_core_init+0x0/0x2b @ 1
[    2.024245] initcall htcpld_core_init+0x0/0x2b returned -19 after 18 usecs
[    2.024249] calling  wm8994_i2c_init+0x0/0x33 @ 1
[    2.024258] initcall wm8994_i2c_init+0x0/0x33 returned 0 after 5 usecs
[    2.024262] calling  adp5520_init+0x0/0x14 @ 1
[    2.024269] i2c-core: driver [adp5520] using legacy suspend method
[    2.024272] i2c-core: driver [adp5520] using legacy resume method
[    2.024276] initcall adp5520_init+0x0/0x14 returned 0 after 10 usecs
[    2.024280] calling  mac_hid_init+0x0/0x22 @ 1
[    2.024291] initcall mac_hid_init+0x0/0x22 returned 0 after 7 usecs
[    2.024295] calling  scsi_dh_init+0x0/0x3f @ 1
[    2.024299] initcall scsi_dh_init+0x0/0x3f returned 0 after 0 usecs
[    2.024302] calling  init_sd+0x0/0x169 @ 1
[    2.024329] initcall init_sd+0x0/0x169 returned 0 after 22 usecs
[    2.024333] calling  init_sr+0x0/0x46 @ 1
[    2.024341] initcall init_sr+0x0/0x46 returned 0 after 5 usecs
[    2.024345] calling  init_sg+0x0/0x129 @ 1
[    2.024364] initcall init_sg+0x0/0x129 returned 0 after 15 usecs
[    2.024368] calling  adma_ata_init+0x0/0x1b @ 1
[    2.024385] initcall adma_ata_init+0x0/0x1b returned 0 after 13 usecs
[    2.024389] calling  piix_init+0x0/0x29 @ 1
[    2.024408] initcall piix_init+0x0/0x29 returned 0 after 15 usecs
[    2.024412] calling  sis_init+0x0/0x1b @ 1
[    2.024426] initcall sis_init+0x0/0x1b returned 0 after 10 usecs
[    2.024430] calling  pacpi_init+0x0/0x1b @ 1
[    2.024444] initcall pacpi_init+0x0/0x1b returned 0 after 10 usecs
[    2.024448] calling  ata_generic_init+0x0/0x1b @ 1
[    2.024464] initcall ata_generic_init+0x0/0x1b returned 0 after 11 usecs
[    2.024468] calling  marvell_init+0x0/0x60 @ 1
[    2.024516] initcall marvell_init+0x0/0x60 returned 0 after 43 usecs
[    2.024520] calling  davicom_init+0x0/0x5e @ 1
[    2.024538] initcall davicom_init+0x0/0x5e returned 0 after 14 usecs
[    2.024542] calling  cicada_init+0x0/0x3c @ 1
[    2.024555] initcall cicada_init+0x0/0x3c returned 0 after 9 usecs
[    2.024559] calling  lxt_init+0x0/0x5e @ 1
[    2.024576] initcall lxt_init+0x0/0x5e returned 0 after 13 usecs
[    2.024580] calling  qs6612_init+0x0/0x12 @ 1
[    2.024589] initcall qs6612_init+0x0/0x12 returned 0 after 6 usecs
[    2.024593] calling  smsc_init+0x0/0xa6 @ 1
[    2.024621] initcall smsc_init+0x0/0xa6 returned 0 after 23 usecs
[    2.024625] calling  vsc82xx_init+0x0/0x3c @ 1
[    2.024638] initcall vsc82xx_init+0x0/0x3c returned 0 after 9 usecs
[    2.024641] calling  broadcom_init+0x0/0x18e @ 1
[    2.024703] initcall broadcom_init+0x0/0x18e returned 0 after 56 usecs
[    2.024707] calling  icplus_init+0x0/0x29 @ 1
[    2.024720] initcall icplus_init+0x0/0x29 returned 0 after 9 usecs
[    2.024724] calling  realtek_init+0x0/0x12 @ 1
[    2.024733] initcall realtek_init+0x0/0x12 returned 0 after 5 usecs
[    2.024737] calling  et1011c_init+0x0/0x12 @ 1
[    2.024745] initcall et1011c_init+0x0/0x12 returned 0 after 4 usecs
[    2.024749] calling  fixed_mdio_bus_init+0x0/0x105 @ 1
[    2.024784] Fixed MDIO Bus: probed
[    2.024787] initcall fixed_mdio_bus_init+0x0/0x105 returned 0 after 33 usecs
[    2.024791] calling  mdio_gpio_init+0x0/0x12 @ 1
[    2.024800] initcall mdio_gpio_init+0x0/0x12 returned 0 after 5 usecs
[    2.024804] calling  ns_init+0x0/0x12 @ 1
[    2.024813] initcall ns_init+0x0/0x12 returned 0 after 5 usecs
[    2.024817] calling  ste10Xp_init+0x0/0x22 @ 1
[    2.024830] initcall ste10Xp_init+0x0/0x22 returned 0 after 9 usecs
[    2.024834] calling  net_olddevs_init+0x0/0x9f @ 1
[    2.024840] initcall net_olddevs_init+0x0/0x9f returned 0 after 2 usecs
[    2.024844] calling  ppp_init+0x0/0xe3 @ 1
[    2.024847] PPP generic driver version 2.4.2
[    2.024883] initcall ppp_init+0x0/0xe3 returned 0 after 34 usecs
[    2.024887] calling  netback_init+0x0/0x21a @ 1
[    2.025278] initcall netback_init+0x0/0x21a returned 0 after 377 usecs
[    2.025284] calling  tun_init+0x0/0x93 @ 1
[    2.025288] tun: Universal TUN/TAP device driver, 1.6
[    2.025291] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.025339] initcall tun_init+0x0/0x93 returned 0 after 45 usecs
[    2.025345] calling  cdrom_init+0x0/0x6a @ 1
[    2.025363] initcall cdrom_init+0x0/0x6a returned 0 after 13 usecs
[    2.025367] calling  mon_init+0x0/0x108 @ 1
[    2.025410] initcall mon_init+0x0/0x108 returned 0 after 37 usecs
[    2.025415] calling  ehci_hcd_init+0x0/0x78 @ 1
[    2.025418] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.025479] xen: registering gsi 17 triggering 0 polarity 1
[    2.025489] xen: --> pirq=17 -> irq=17
[    2.025509] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.025607] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.025655] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.030401] ehci_hcd 0000:00:12.2: QUIRK: Enable exception for AMD Hudson ASPM
[    2.030409] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.030461] ehci_hcd 0000:00:12.2: debug port 1
[    2.030502] ehci_hcd 0000:00:12.2: irq 17, io mem 0xf9fff800
[    2.050154] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.050312] hub 1-0:1.0: USB hub found
[    2.050318] hub 1-0:1.0: 5 ports detected
[    2.050474] xen: registering gsi 17 triggering 0 polarity 1
[    2.050479] xen_map_pirq_gsi: returning irq 17 for gsi 17
[    2.050482] xen: --> pirq=17 -> irq=17
[    2.050486] Already setup the GSI :17
[    2.050490] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.050509] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.050544] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.050578] ehci_hcd 0000:00:13.2: QUIRK: Enable exception for AMD Hudson ASPM
[    2.050583] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.050624] ehci_hcd 0000:00:13.2: debug port 1
[    2.050639] ehci_hcd 0000:00:13.2: irq 17, io mem 0xf9fff400
[    2.070159] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.070333] hub 2-0:1.0: USB hub found
[    2.070339] hub 2-0:1.0: 5 ports detected
[    2.070487] xen: registering gsi 17 triggering 0 polarity 1
[    2.070492] xen_map_pirq_gsi: returning irq 17 for gsi 17
[    2.070495] xen: --> pirq=17 -> irq=17
[    2.070499] Already setup the GSI :17
[    2.070502] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.070522] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    2.070561] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[    2.070594] ehci_hcd 0000:00:16.2: QUIRK: Enable exception for AMD Hudson ASPM
[    2.070599] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.070639] ehci_hcd 0000:00:16.2: debug port 1
[    2.070655] ehci_hcd 0000:00:16.2: irq 17, io mem 0xf9fff000
[    2.090159] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.090305] hub 3-0:1.0: USB hub found
[    2.090310] hub 3-0:1.0: 4 ports detected
[    2.090394] initcall ehci_hcd_init+0x0/0x78 returned 0 after 63451 usecs
[    2.090399] calling  ohci_hcd_mod_init+0x0/0x54 @ 1
[    2.090402] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.090481] xen: registering gsi 18 triggering 0 polarity 1
[    2.090485] xen_map_pirq_gsi: returning irq 18 for gsi 18
[    2.090488] xen: --> pirq=18 -> irq=18
[    2.090492] Already setup the GSI :18
[    2.090496] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.090514] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.090549] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    2.090621] ohci_hcd 0000:00:12.0: irq 18, io mem 0xf9ffe000
[    2.154405] hub 4-0:1.0: USB hub found
[    2.154413] hub 4-0:1.0: 5 ports detected
[    2.154562] xen: registering gsi 18 triggering 0 polarity 1
[    2.154566] xen_map_pirq_gsi: returning irq 18 for gsi 18
[    2.154569] xen: --> pirq=18 -> irq=18
[    2.154573] Already setup the GSI :18
[    2.154576] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.154594] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.154631] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.154681] ohci_hcd 0000:00:13.0: irq 18, io mem 0xf9ffd000
[    2.214327] hub 5-0:1.0: USB hub found
[    2.214335] hub 5-0:1.0: 5 ports detected
[    2.214479] xen: registering gsi 18 triggering 0 polarity 1
[    2.214484] xen_map_pirq_gsi: returning irq 18 for gsi 18
[    2.214487] xen: --> pirq=18 -> irq=18
[    2.214490] Already setup the GSI :18
[    2.214494] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.214512] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.214546] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    2.220256] ohci_hcd 0000:00:14.5: irq 18, io mem 0xf9ffc000
[    2.284358] hub 6-0:1.0: USB hub found
[    2.284367] hub 6-0:1.0: 2 ports detected
[    2.284503] xen: registering gsi 18 triggering 0 polarity 1
[    2.284507] xen_map_pirq_gsi: returning irq 18 for gsi 18
[    2.284510] xen: --> pirq=18 -> irq=18
[    2.284514] Already setup the GSI :18
[    2.284517] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.284535] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.284574] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.284631] ohci_hcd 0000:00:16.0: irq 18, io mem 0xf9ff3000
[    2.344351] hub 7-0:1.0: USB hub found
[    2.344359] hub 7-0:1.0: 4 ports detected
[    2.344435] initcall ohci_hcd_mod_init+0x0/0x54 returned 0 after 248077 usecs
[    2.344440] calling  uhci_hcd_init+0x0/0xca @ 1
[    2.344443] uhci_hcd: USB Universal Host Controller Interface driver
[    2.344493] initcall uhci_hcd_init+0x0/0xca returned 0 after 47 usecs
[    2.344497] calling  i8042_init+0x0/0x3ab @ 1
[    2.344555] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.344559] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.344701] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.344712] initcall i8042_init+0x0/0x3ab returned 0 after 206 usecs
[    2.344716] calling  mousedev_init+0x0/0x8d @ 1
[    2.344771] mousedev: PS/2 mouse device common for all mice
[    2.344775] initcall mousedev_init+0x0/0x8d returned 0 after 54 usecs
[    2.344779] calling  evdev_init+0x0/0x12 @ 1
[    2.344827] initcall evdev_init+0x0/0x12 returned 0 after 43 usecs
[    2.344831] calling  atkbd_init+0x0/0x27 @ 1
[    2.344843] initcall atkbd_init+0x0/0x27 returned 0 after 8 usecs
[    2.344847] calling  uinput_init+0x0/0x12 @ 1
[    2.344869] initcall uinput_init+0x0/0x12 returned 0 after 17 usecs
[    2.344873] calling  cmos_init+0x0/0x6a @ 1
[    2.344895] rtc_cmos 00:04: RTC can wake from S4
[    2.350335] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    2.350379] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    2.350394] initcall cmos_init+0x0/0x6a returned 0 after 5387 usecs
[    2.350399] calling  dm_init+0x0/0x48 @ 1
[    2.350479] device-mapper: uevent: version 1.0.3
[    2.350552] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    2.350558] initcall dm_init+0x0/0x48 returned 0 after 150 usecs
[    2.350563] calling  dm_multipath_init+0x0/0x127 @ 1
[    2.350753] device-mapper: multipath: version 1.2.0 loaded
[    2.350762] initcall dm_multipath_init+0x0/0x127 returned 0 after 189 usecs
[    2.350767] calling  dm_rr_init+0x0/0x3f @ 1
[    2.350771] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.350776] initcall dm_rr_init+0x0/0x3f returned 0 after 4 usecs
[    2.350780] calling  dm_snapshot_init+0x0/0x216 @ 1
[    2.350807] initcall dm_snapshot_init+0x0/0x216 returned 0 after 21 usecs
[    2.350812] calling  dm_mirror_init+0x0/0x79 @ 1
[    2.350846] initcall dm_mirror_init+0x0/0x79 returned 0 after 28 usecs
[    2.350851] calling  dm_dirty_log_init+0x0/0x5a @ 1
[    2.350856] initcall dm_dirty_log_init+0x0/0x5a returned 0 after 0 usecs
[    2.350861] calling  cpufreq_stats_init+0x0/0x9e @ 1
[    2.350868] initcall cpufreq_stats_init+0x0/0x9e returned 0 after 2 usecs
[    2.350872] calling  cpufreq_gov_powersave_init+0x0/0x12 @ 1
[    2.350878] initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 usecs
[    2.350883] calling  cpufreq_gov_userspace_init+0x0/0x12 @ 1
[    2.350888] initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 usecs
[    2.350893] calling  cpufreq_gov_dbs_init+0x0/0xaf @ 1
[    2.350946] initcall cpufreq_gov_dbs_init+0x0/0xaf returned 0 after 47 usecs
[    2.350954] calling  cpufreq_gov_dbs_init+0x0/0x66 @ 1
[    2.350994] initcall cpufreq_gov_dbs_init+0x0/0x66 returned 0 after 35 usecs
[    2.350998] calling  init_ladder+0x0/0x12 @ 1
[    2.351002] cpuidle: using governor ladder
[    2.351006] initcall init_ladder+0x0/0x12 returned 0 after 3 usecs
[    2.351010] calling  init_menu+0x0/0x12 @ 1
[    2.351012] cpuidle: using governor menu
[    2.351016] initcall init_menu+0x0/0x12 returned 0 after 2 usecs
[    2.351020] calling  efivars_init+0x0/0x225 @ 1
[    2.351024] initcall efivars_init+0x0/0x225 returned -19 after 0 usecs
[    2.351027] calling  staging_init+0x0/0x8 @ 1
[    2.351031] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    2.351035] calling  flow_cache_init_global+0x0/0x129 @ 1
[    2.351059] initcall flow_cache_init_global+0x0/0x129 returned 0 after 19 usecs
[    2.351063] calling  llc_init+0x0/0x20 @ 1
[    2.351067] initcall llc_init+0x0/0x20 returned 0 after 0 usecs
[    2.351070] calling  snap_init+0x0/0x38 @ 1
[    2.351075] initcall snap_init+0x0/0x38 returned 0 after 1 usecs
[    2.351078] calling  rif_init+0x0/0x85 @ 1
[    2.351093] initcall rif_init+0x0/0x85 returned 0 after 11 usecs
[    2.351097] calling  blackhole_module_init+0x0/0x12 @ 1
[    2.351102] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.351106] calling  init_cgroup_cls+0x0/0x3c @ 1
[    2.351110] initcall init_cgroup_cls+0x0/0x3c returned 0 after 0 usecs
[    2.351114] calling  sysctl_ipv4_init+0x0/0x8f @ 1
[    2.351256] initcall sysctl_ipv4_init+0x0/0x8f returned 0 after 135 usecs
[    2.351260] calling  init_syncookies+0x0/0x19 @ 1
[    2.351282] initcall init_syncookies+0x0/0x19 returned 0 after 17 usecs
[    2.351287] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    2.351291] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 usecs
[    2.351295] calling  inet_diag_init+0x0/0x7a @ 1
[    2.351302] initcall inet_diag_init+0x0/0x7a returned 0 after 3 usecs
[    2.351306] calling  tcp_diag_init+0x0/0x12 @ 1
[    2.351310] initcall tcp_diag_init+0x0/0x12 returned 0 after 0 usecs
[    2.351314] calling  cubictcp_register+0x0/0x5c @ 1
[    2.351317] TCP cubic registered
[    2.351320] initcall cubictcp_register+0x0/0x5c returned 0 after 3 usecs
[    2.351324] calling  inet6_init+0x0/0x322 @ 1
[    2.351440] NET: Registered protocol family 10
[    2.351857] initcall inet6_init+0x0/0x322 returned 0 after 516 usecs
[    2.351862] calling  packet_init+0x0/0x47 @ 1
[    2.351865] NET: Registered protocol family 17
[    2.351871] initcall packet_init+0x0/0x47 returned 0 after 5 usecs
[    2.351875] calling  dsa_init_module+0x0/0x14 @ 1
[    2.351879] initcall dsa_init_module+0x0/0x14 returned 0 after 0 usecs
[    2.351883] calling  edsa_init_module+0x0/0x14 @ 1
[    2.351886] initcall edsa_init_module+0x0/0x14 returned 0 after 0 usecs
[    2.351890] calling  trailer_init_module+0x0/0x14 @ 1
[    2.351894] initcall trailer_init_module+0x0/0x14 returned 0 after 0 usecs
[    2.351898] calling  mv88e6060_init+0x0/0x14 @ 1
[    2.351902] initcall mv88e6060_init+0x0/0x14 returned 0 after 0 usecs
[    2.351906] calling  mv88e6123_61_65_init+0x0/0x14 @ 1
[    2.351910] initcall mv88e6123_61_65_init+0x0/0x14 returned 0 after 0 usecs
[    2.351913] calling  mv88e6131_init+0x0/0x14 @ 1
[    2.351917] initcall mv88e6131_init+0x0/0x14 returned 0 after 0 usecs
[    2.351921] calling  dsa_init_module+0x0/0x12 @ 1
[    2.351933] initcall dsa_init_module+0x0/0x12 returned 0 after 8 usecs
[    2.351937] calling  dcbnl_init+0x0/0x47 @ 1
[    2.351941] initcall dcbnl_init+0x0/0x47 returned 0 after 0 usecs
[    2.351945] calling  init_dns_resolver+0x0/0x108 @ 1
[    2.351948] Registering the dns_resolver key type
[    2.351963] initcall init_dns_resolver+0x0/0x108 returned 0 after 14 usecs
[    2.351967] calling  tboot_late_init+0x0/0x210 @ 1
[    2.351971] initcall tboot_late_init+0x0/0x210 returned 0 after 0 usecs
[    2.351975] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    2.351983] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 4 usecs
[    2.351987] calling  severities_debugfs_init+0x0/0x3c @ 1
[    2.351992] initcall severities_debugfs_init+0x0/0x3c returned 0 after 1 usecs
[    2.351997] calling  powernowk8_init+0x0/0x1d9 @ 1
[    2.352217] powernow-k8: Found 1 AMD Phenom(tm) II X6 1075T Processor (6 cpu cores) (version 2.20.00)
[    2.352254] powernow-k8: Core Performance Boosting: on.
[    2.352305] powernow-k8: invalid pstate 1 - bad value 1.
[    2.352308] powernow-k8: Please report to BIOS manufacturer
[    2.352312] powernow-k8: invalid pstate 2 - bad value 2.
[    2.352315] powernow-k8: Please report to BIOS manufacturer
[    2.352318] powernow-k8: invalid pstate 3 - bad value 3.
[    2.352321] powernow-k8: Please report to BIOS manufacturer
[    2.352546] [Firmware Bug]: powernow-k8: invalid powernow_table
[    2.352600] powernow-k8: invalid pstate 1 - bad value 1.
[    2.352604] powernow-k8: Please report to BIOS manufacturer
[    2.352608] powernow-k8: invalid pstate 2 - bad value 2.
[    2.352611] powernow-k8: Please report to BIOS manufacturer
[    2.352614] powernow-k8: invalid pstate 3 - bad value 3.
[    2.352617] powernow-k8: Please report to BIOS manufacturer
[    2.352627] [Firmware Bug]: powernow-k8: invalid powernow_table
[    2.352679] powernow-k8: invalid pstate 1 - bad value 1.
[    2.352682] powernow-k8: Please report to BIOS manufacturer
[    2.352686] powernow-k8: invalid pstate 2 - bad value 2.
[    2.352689] powernow-k8: Please report to BIOS manufacturer
[    2.352692] powernow-k8: invalid pstate 3 - bad value 3.
[    2.352695] powernow-k8: Please report to BIOS manufacturer
[    2.352721] [Firmware Bug]: powernow-k8: invalid powernow_table
[    2.352809] powernow-k8: invalid pstate 1 - bad value 1.
[    2.352812] powernow-k8: Please report to BIOS manufacturer
[    2.352816] powernow-k8: invalid pstate 2 - bad value 2.
[    2.352819] powernow-k8: Please report to BIOS manufacturer
[    2.352822] powernow-k8: invalid pstate 3 - bad value 3.
[    2.352826] powernow-k8: Please report to BIOS manufacturer
[    2.352849] [Firmware Bug]: powernow-k8: invalid powernow_table
[    2.352937] powernow-k8: invalid pstate 1 - bad value 1.
[    2.352941] powernow-k8: Please report to BIOS manufacturer
[    2.352944] powernow-k8: invalid pstate 2 - bad value 2.
[    2.352947] powernow-k8: Please report to BIOS manufacturer
[    2.352951] powernow-k8: invalid pstate 3 - bad value 3.
[    2.352954] powernow-k8: Please report to BIOS manufacturer
[    2.352977] [Firmware Bug]: powernow-k8: invalid powernow_table
[    2.353074] powernow-k8: invalid pstate 1 - bad value 1.
[    2.353078] powernow-k8: Please report to BIOS manufacturer
[    2.353081] powernow-k8: invalid pstate 2 - bad value 2.
[    2.353084] powernow-k8: Please report to BIOS manufacturer
[    2.353088] powernow-k8: invalid pstate 3 - bad value 3.
[    2.353091] powernow-k8: Please report to BIOS manufacturer
[    2.353102] [Firmware Bug]: powernow-k8: invalid powernow_table
[    2.353113] initcall powernowk8_init+0x0/0x1d9 returned -19 after 1085 usecs
[    2.353117] calling  acpi_cpufreq_init+0x0/0xc9 @ 1
[    2.353403] initcall acpi_cpufreq_init+0x0/0xc9 returned -19 after 274 usecs
[    2.353407] calling  centrino_init+0x0/0x2d @ 1
[    2.353410] initcall centrino_init+0x0/0x2d returned -19 after 0 usecs
[    2.353414] calling  hpet_insert_resource+0x0/0x23 @ 1
[    2.353418] initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 usecs
[    2.353422] calling  update_mp_table+0x0/0x599 @ 1
[    2.353426] initcall update_mp_table+0x0/0x599 returned 0 after 0 usecs
[    2.353430] calling  lapic_insert_resource+0x0/0x3f @ 1
[    2.353435] initcall lapic_insert_resource+0x0/0x3f returned 0 after 0 usecs
[    2.353439] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    2.353442] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    2.353447] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    2.353452] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    2.353456] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    2.353462] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 2 usecs
[    2.353466] calling  sched_init_debug+0x0/0x24 @ 1
[    2.353471] initcall sched_init_debug+0x0/0x24 returned 0 after 1 usecs
[    2.353476] calling  init_oops_id+0x0/0x40 @ 1
[    2.353481] initcall init_oops_id+0x0/0x40 returned 0 after 2 usecs
[    2.353485] calling  printk_late_init+0x0/0x50 @ 1
[    2.353489] initcall printk_late_init+0x0/0x50 returned 0 after 0 usecs
[    2.353493] calling  pm_qos_power_init+0x0/0xdf @ 1
[    2.353565] initcall pm_qos_power_init+0x0/0xdf returned 0 after 67 usecs
[    2.353570] calling  test_suspend+0x0/0x1b9 @ 1
[    2.353574] initcall test_suspend+0x0/0x1b9 returned 0 after 0 usecs
[    2.353578] calling  software_resume+0x0/0x1f0 @ 1
[    2.353581] PM: Hibernation image not present or could not be loaded.
[    2.353585] initcall software_resume+0x0/0x1f0 returned -2 after 3 usecs
[    2.353589] initcall software_resume+0x0/0x1f0 returned with error code -2 
[    2.353594] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[    2.353601] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 3 usecs
[    2.353606] calling  taskstats_init+0x0/0x95 @ 1
[    2.353612] registered taskstats version 1
[    2.353616] initcall taskstats_init+0x0/0x95 returned 0 after 6 usecs
[    2.353620] calling  clear_boot_tracer+0x0/0x2d @ 1
[    2.353624] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    2.353628] calling  kdb_ftrace_register+0x0/0x2f @ 1
[    2.353633] initcall kdb_ftrace_register+0x0/0x2f returned 0 after 1 usecs
[    2.353638] calling  max_swapfiles_check+0x0/0x8 @ 1
[    2.353641] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    2.353645] calling  random32_reseed+0x0/0xb4 @ 1
[    2.353666] initcall random32_reseed+0x0/0xb4 returned 0 after 17 usecs
[    2.353670] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    2.353675] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 1 usecs
[    2.353679] calling  pci_sysfs_init+0x0/0x51 @ 1
[    2.354046] initcall pci_sysfs_init+0x0/0x51 returned 0 after 354 usecs
[    2.354050] calling  boot_wait_for_devices+0x0/0x30 @ 1
[    2.354055] initcall boot_wait_for_devices+0x0/0x30 returned 0 after 0 usecs
[    2.354058] calling  regulator_init_complete+0x0/0x176 @ 1
[    2.354062] initcall regulator_init_complete+0x0/0x176 returned 0 after 0 usecs
[    2.354067] calling  seqgen_init+0x0/0xf @ 1
[    2.354077] initcall seqgen_init+0x0/0xf returned 0 after 7 usecs
[    2.354082] calling  late_resume_init+0x0/0x1d0 @ 1
[    2.354085]   Magic number: 3:634:207
[    2.354120] initcall late_resume_init+0x0/0x1d0 returned 0 after 34 usecs
[    2.354125] calling  scsi_complete_async_scans+0x0/0x160 @ 1
[    2.354129] initcall scsi_complete_async_scans+0x0/0x160 returned 0 after 0 usecs
[    2.354134] calling  rtc_hctosys+0x0/0x11b @ 1
[    2.354255] rtc_cmos 00:04: setting system clock to 2011-03-17 02:14:34 UTC (1300328074)
[    2.354261] initcall rtc_hctosys+0x0/0x11b returned 0 after 120 usecs
[    2.354266] calling  edd_init+0x0/0x354 @ 1
[    2.354269] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.354273] EDD information not available.
[    2.354277] initcall edd_init+0x0/0x354 returned -19 after 6 usecs
[    2.354282] calling  memmap_init+0x0/0x3f @ 1
[    2.354310] initcall memmap_init+0x0/0x3f returned 0 after 23 usecs
[    2.354315] calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
[    2.354320] initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 0 usecs
[    2.354326] calling  tcp_congestion_default+0x0/0x12 @ 1
[    2.354331] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    2.354335] calling  initialize_hashrnd+0x0/0x19 @ 1
[    2.354342] initcall initialize_hashrnd+0x0/0x19 returned 0 after 2 usecs
[    2.354381] async_waiting @ 1
[    2.354384] async_continuing @ 1 after 0 usec
[    2.354780] Freeing unused kernel memory: 968k freed
[    2.355058] Write protecting the kernel read-only data: 10240k
[    2.358513] Freeing unused kernel memory: 192k freed
[    2.359119] Freeing unused kernel memory: 1480k freed
[    2.369661] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    2.401067] udev[146]: starting version 163
[    2.418365] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 174
[    2.418377] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned 0 after 2 usecs
[    2.450104] usb 2-3: new high speed USB device using ehci_hcd and address 3
[    2.456613] calling  init_btrfs_fs+0x0/0xa4 [btrfs] @ 208
[    2.456878] Btrfs loaded
[    2.456890] initcall init_btrfs_fs+0x0/0xa4 [btrfs] returned 0 after 254 usecs
[    2.464186] calling  ahci_init+0x0/0x1000 [ahci] @ 244
[    2.466663] ahci 0000:00:11.0: version 3.0
[    2.466685] xen: registering gsi 19 triggering 0 polarity 1
[    2.466691] xen_map_pirq_gsi: returning irq 19 for gsi 19
[    2.466695] xen: --> pirq=19 -> irq=19
[    2.466703] Already setup the GSI :19
[    2.466708] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.466894] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    2.466901] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    2.468166] calling  rtl8169_init_module+0x0/0x1000 [r8169] @ 256
[    2.468358] scsi0 : ahci
[    2.468545] scsi1 : ahci
[    2.468664] scsi2 : ahci
[    2.468755] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.468782] xen: registering gsi 17 triggering 0 polarity 1
[    2.468788] xen_map_pirq_gsi: returning irq 17 for gsi 17
[    2.468791] xen: --> pirq=17 -> irq=17
[    2.468798] Already setup the GSI :17
[    2.468802] r8169 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.468823] scsi3 : ahci
[    2.468939] r8169 0000:05:00.0: setting latency timer to 64
[    2.469026] scsi4 : ahci
[    2.469138] scsi5 : ahci
[    2.469235] ata1: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffd00 irq 315
[    2.469243] ata2: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffd80 irq 315
[    2.469249] ata3: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffe00 irq 315
[    2.469254] ata4: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9fffe80 irq 315
[    2.469259] ata5: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9ffff00 irq 315
[    2.469265] ata6: SATA max UDMA/133 abar m1024@0xf9fffc00 port 0xf9ffff80 irq 315
[    2.469388] initcall ahci_init+0x0/0x1000 [ahci] returned 0 after 5067 usecs
[    2.470009] r8169 0000:05:00.0: eth0: RTL8168d/8111d at 0xffffc90001876000, 00:30:67:83:b2:f6, XID 081000c0 IRQ 316
[    2.500462] initcall rtl8169_init_module+0x0/0x1000 [r8169] returned 0 after 31526 usecs
[    2.820191] ata5: SATA link down (SStatus 0 SControl 300)
[    3.020196] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.020255] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.020311] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.020382] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.020929] ata2.00: ATA-8: WDC SSC-D0064SC-2100, 5.12, max UDMA/133
[    3.020936] ata2.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.020954] ata6.00: ATA-7: ST3250410AS, 3.AAC, max UDMA/133
[    3.020958] ata6.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.021589] ata2.00: configured for UDMA/133
[    3.021643] ata6.00: configured for UDMA/133
[    3.022093] ata4.00: ATAPI: ASUS    DRW-24B1ST, 1.01, max UDMA/100
[    3.022819] ata4.00: configured for UDMA/100
[    3.067362] ata3.00: HPA detected: current 625140335, native 625142448
[    3.067388] ata3.00: ATA-7: MAXTOR STM3320620AS, 3.AAE, max UDMA/133
[    3.067403] ata3.00: 625140335 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.125667] ata3.00: configured for UDMA/133
[    3.150631] calling  uas_init+0x0/0x30 [uas] @ 295
[    3.150672] usbcore: registered new interface driver uas
[    3.150678] initcall uas_init+0x0/0x30 [uas] returned 0 after 37 usecs
[    3.290184] usb 5-1: new low speed USB device using ohci_hcd and address 2
[    3.496662] calling  hid_init+0x0/0x66 [hid] @ 298
[    3.496983] initcall hid_init+0x0/0x66 [hid] returned 0 after 303 usecs
[    8.240180] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.240574] ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
[    8.240597] ata1.00: 156301488 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    8.241025] ata1.00: configured for UDMA/133
[    8.241238] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[    8.241379] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.241541] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    8.241601] scsi 1:0:0:0: Direct-Access     ATA      WDC SSC-D0064SC- 5.12 PQ: 0 ANSI: 5
[    8.241661] sd 0:0:0:0: [sda] Write Protect is off
[    8.241668] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.241700] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.241786] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    8.241933] scsi 2:0:0:0: Direct-Access     ATA      MAXTOR STM332062 3.AA PQ: 0 ANSI: 5
[    8.242091] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    8.242100] sd 2:0:0:0: [sdc] 625140335 512-byte logical blocks: (320 GB/298 GiB)
[    8.242204] sd 2:0:0:0: [sdc] Write Protect is off
[    8.242208] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.242216] sd 1:0:0:0: [sdb] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    8.242241] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.242533] sd 1:0:0:0: [sdb] Write Protect is off
[    8.242540] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    8.242578] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.242763]  sda: sda1 sda2
[    8.243108]  sdb: sdb1
[    8.243127] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.243366] sd 1:0:0:0: [sdb] Attached SCSI disk
[    8.244788] scsi 3:0:0:0: CD-ROM            ASUS     DRW-24B1ST       1.01 PQ: 0 ANSI: 5
[    8.248377] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    8.248384] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.248477] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    8.248528] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    8.248694] scsi 5:0:0:0: Direct-Access     ATA      ST3250410AS      3.AA PQ: 0 ANSI: 5
[    8.248832] sd 5:0:0:0: Attached scsi generic sg4 type 0
[    8.248912] sd 5:0:0:0: [sdd] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    8.248976] sd 5:0:0:0: [sdd] Write Protect is off
[    8.248979] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    8.249007] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.263579]  sdc: unknown partition table
[    8.263876] sd 2:0:0:0: [sdc] Attached SCSI disk
[    8.283490]  sdd: sdd1
[    8.283787] sd 5:0:0:0: [sdd] Attached SCSI disk
[    8.290880] calling  usb_stor_init+0x0/0x1000 [usb_storage] @ 295
[    8.290887] Initializing USB Mass Storage driver...
[    8.294567] calling  hid_init+0x0/0x1000 [usbhid] @ 298
[    8.294791] scsi6 : usb-storage 2-3:1.0
[    8.295167] usbcore: registered new interface driver usb-storage
[    8.295175] USB Mass Storage support registered.
[    8.295188] initcall usb_stor_init+0x0/0x1000 [usb_storage] returned 0 after 4192 usecs
[    8.299255] input: Kingsis Peripherals  Evoluent VerticalMouse 3  as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.0/input/input3
[    8.299388] generic-usb 0003:1A7C:0068.0001: input,hidraw0: USB HID v1.10 Mouse [Kingsis Peripherals  Evoluent VerticalMouse 3 ] on usb-0000:00:13.0-1/input0
[    8.299410] usbcore: registered new interface driver usbhid
[    8.299414] usbhid: USB HID core driver
[    8.299421] initcall hid_init+0x0/0x1000 [usbhid] returned 0 after 4728 usecs
[    8.480952] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[    8.526717] device-mapper: table: 252:1: linear: Invalid argument count
[    8.526725] device-mapper: ioctl: error adding target to table
[    8.541344] device-mapper: table: 252:2: linear: Invalid argument count
[    8.541352] device-mapper: ioctl: error adding target to table
[    8.556146] device-mapper: table: 252:3: linear: Invalid argument count
[    8.556154] device-mapper: ioctl: error adding target to table
[    8.570755] device-mapper: table: 252:4: linear: Invalid argument count
[    8.570765] device-mapper: ioctl: error adding target to table
[    8.585307] device-mapper: table: 252:5: linear: Invalid argument count
[    8.585316] device-mapper: ioctl: error adding target to table
[    8.873443] Adding 11722336k swap on /dev/sda1.  Priority:-1 extents:1 across:11722336k SS
[    8.909415] udev[408]: starting version 163
[    8.954771] calling  parport_default_proc_register+0x0/0x1000 [parport] @ 414
[    8.954833] initcall parport_default_proc_register+0x0/0x1000 [parport] returned 0 after 53 usecs
[    8.963255] calling  lp_init_module+0x0/0x1000 [lp] @ 414
[    8.969770] calling  acpi_video_init+0x0/0xfee [video] @ 425
[    8.969838] initcall acpi_video_init+0x0/0xfee [video] returned 0 after 60 usecs
[    8.970355] lp: driver loaded but no devices found
[    8.970361] initcall lp_init_module+0x0/0x1000 [lp] returned 0 after 6933 usecs
[    8.978152] EXT4-fs (sdb1): re-mounted. Opts: errors=remount-ro
[    9.025674] calling  i2c_piix4_init+0x0/0x1000 [i2c_piix4] @ 507
[    9.028793] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    9.028993] initcall i2c_piix4_init+0x0/0x1000 [i2c_piix4] returned 0 after 3232 usecs
[    9.035706] calling  snd_mem_init+0x0/0x1000 [snd_page_alloc] @ 508
[    9.035720] initcall snd_mem_init+0x0/0x1000 [snd_page_alloc] returned 0 after 8 usecs
[    9.047577] calling  k10temp_init+0x0/0x1000 [k10temp] @ 526
[    9.047881] initcall k10temp_init+0x0/0x1000 [k10temp] returned 0 after 291 usecs
[    9.063606] calling  init_soundcore+0x0/0x1000 [soundcore] @ 508
[    9.063624] initcall init_soundcore+0x0/0x1000 [soundcore] returned 0 after 13 usecs
[    9.064064] calling  sp5100_tco_init_module+0x0/0x1000 [sp5100_tco] @ 507
[    9.064067] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    9.064180] SP5100 TCO timer: mmio address 0xb8fe00 already in use
[    9.064196] calling  mce_amd_init+0x0/0x1000 [edac_mce_amd] @ 525
[    9.064201] initcall sp5100_tco_init_module+0x0/0x1000 [sp5100_tco] returned 0 after 126 usecs
[    9.064211] MCE: In-kernel MCE decoding enabled.
[    9.064216] initcall mce_amd_init+0x0/0x1000 [edac_mce_amd] returned 0 after 3 usecs
[    9.068150] calling  drm_core_init+0x0/0x1000 [drm] @ 425
[    9.068200] [drm] Initialized drm 1.1.0 20060810
[    9.068210] initcall drm_core_init+0x0/0x1000 [drm] returned 0 after 47 usecs
[    9.073931] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[    9.082683] calling  edac_init+0x0/0x1000 [edac_core] @ 525
[    9.082686] EDAC MC: Ver: 2.1.0 Mar 16 2011
[    9.082950] initcall edac_init+0x0/0x1000 [edac_core] returned 0 after 251 usecs
[    9.090584] udev[430]: renamed network interface eth0 to eth2
[    9.100207] calling  amd64_edac_init+0x0/0x1000 [amd64_edac_mod] @ 525
[    9.100210] EDAC amd64_edac: v3.3.0
[    9.100735] EDAC amd64: DRAM ECC disabled.
[    9.100753] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    9.100754]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    9.100755]  (Note that use of the override may cause unknown side effects.)
[    9.101667] initcall amd64_edac_init+0x0/0x1000 [amd64_edac_mod] returned -19 after 1418 usecs
[    9.109298] calling  alsa_sound_init+0x0/0x82 [snd] @ 552
[    9.109380] initcall alsa_sound_init+0x0/0x82 [snd] returned 0 after 71 usecs
[    9.135316] calling  ttm_init+0x0/0x1000 [ttm] @ 425
[    9.135353] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 29 usecs
[    9.176309] calling  alsa_seq_device_init+0x0/0x1000 [snd_seq_device] @ 637
[    9.176320] initcall alsa_seq_device_init+0x0/0x1000 [snd_seq_device] returned 0 after 4 usecs
[    9.191112] calling  alsa_timer_init+0x0/0x1000 [snd_timer] @ 637
[    9.191234] initcall alsa_timer_init+0x0/0x1000 [snd_timer] returned 0 after 113 usecs
[    9.234513] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[    9.245725] calling  br_init+0x0/0xc0 [bridge] @ 657
[    9.245827] Bridge firewalling registered
[    9.245837] initcall br_init+0x0/0xc0 [bridge] returned 0 after 100 usecs
[    9.256556] device eth2 entered promiscuous mode
[    9.267219] calling  alsa_seq_init+0x0/0x4c [snd_seq] @ 697
[    9.267301] initcall alsa_seq_init+0x0/0x4c [snd_seq] returned 0 after 73 usecs
[    9.284002] calling  alsa_seq_midi_event_init+0x0/0x1000 [snd_seq_midi_event] @ 792
[    9.284008] initcall alsa_seq_midi_event_init+0x0/0x1000 [snd_seq_midi_event] returned 0 after 0 usecs
[    9.299517] scsi 6:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 CCS
[    9.305766] scsi 6:0:0:1: Direct-Access     Generic- SM/xD-Picture    1.00 PQ: 0 ANSI: 0 CCS
[    9.309836] r8169 0000:05:00.0: eth2: unable to apply firmware patch
[    9.311666] r8169 0000:05:00.0: eth2: link down
[    9.311679] r8169 0000:05:00.0: eth2: link down
[    9.312031] scsi 6:0:0:2: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0 CCS
[    9.313134] ADDRCONF(NETDEV_UP): eth2: link is not ready
[    9.314974] calling  alsa_rawmidi_init+0x0/0x1000 [snd_rawmidi] @ 825
[    9.315269] initcall alsa_rawmidi_init+0x0/0x1000 [snd_rawmidi] returned 0 after 281 usecs
[    9.320247] scsi 6:0:0:3: Direct-Access     Generic- MS/MS-Pro        1.00 PQ: 0 ANSI: 0 CCS
[    9.321030] sd 6:0:0:0: Attached scsi generic sg5 type 0
[    9.321252] sd 6:0:0:1: Attached scsi generic sg6 type 0
[    9.321451] sd 6:0:0:2: Attached scsi generic sg7 type 0
[    9.321620] sd 6:0:0:3: Attached scsi generic sg8 type 0
[    9.328547] sd 6:0:0:1: [sdf] Attached SCSI removable disk
[    9.337909] sd 6:0:0:0: [sde] Attached SCSI removable disk
[    9.339185] sd 6:0:0:2: [sdg] Attached SCSI removable disk
[    9.339629] sd 6:0:0:3: [sdh] Attached SCSI removable disk
[    9.344155] calling  alsa_seq_midi_init+0x0/0x1000 [snd_seq_midi] @ 861
[    9.344162] initcall alsa_seq_midi_init+0x0/0x1000 [snd_seq_midi] returned 0 after 1 usecs
[    9.395483] calling  alsa_pcm_init+0x0/0x1000 [snd_pcm] @ 916
[    9.395501] initcall alsa_pcm_init+0x0/0x1000 [snd_pcm] returned 0 after 9 usecs
[    9.414809] calling  alsa_hwdep_init+0x0/0x1000 [snd_hwdep] @ 508
[    9.414824] initcall alsa_hwdep_init+0x0/0x1000 [snd_hwdep] returned 0 after 8 usecs
[    9.456003] calling  nouveau_init+0x0/0x1000 [nouveau] @ 425
[    9.456336] calling  alsa_card_azx_init+0x0/0x1000 [snd_hda_intel] @ 508
[    9.457809] xen: registering gsi 18 triggering 0 polarity 1
[    9.457814] xen_map_pirq_gsi: returning irq 18 for gsi 18
[    9.457817] xen: --> pirq=18 -> irq=18
[    9.457822] Already setup the GSI :18
[    9.457826] nouveau 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.457838] nouveau 0000:01:00.0: setting latency timer to 64
[    9.459949] xen: registering gsi 16 triggering 0 polarity 1
[    9.459955] xen_map_pirq_gsi: returning irq 16 for gsi 16
[    9.459958] xen: --> pirq=16 -> irq=16
[    9.459963] Already setup the GSI :16
[    9.459966] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.461868] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084200a2)
[    9.469574] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    9.526029] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    9.526034] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    9.526037] [drm] nouveau 0000:01:00.0: Bios version 60.84.52.00
[    9.526040] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    9.526042] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    9.526045] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    9.526048] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 00000028
[    9.526055] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000302 00020030
[    9.526057] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04011310 00000028
[    9.526059] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02011312 00020030
[    9.526062] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 010223f1 00c0c083
[    9.526065] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2
[    9.526068] [drm] nouveau 0000:01:00.0:   0: 0x00002030: type 0x30 idx 0 tag 0x08
[    9.526071] [drm] nouveau 0000:01:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[    9.526074] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[    9.526076] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[    9.526079] [drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[    9.526083] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC1D1
[    9.600383] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC51E
[    9.608875] sshd (1070): /proc/1070/oom_adj is deprecated, please use /proc/1070/oom_score_adj instead.
[    9.629093] calling  patch_realtek_init+0x0/0x1000 [snd_hda_codec_realtek] @ 1093
[    9.629141] initcall patch_realtek_init+0x0/0x1000 [snd_hda_codec_realtek] returned 0 after 39 usecs
[    9.630177] hda_codec: ALC892: BIOS auto-probing.
[    9.638351] initcall alsa_card_azx_init+0x0/0x1000 [snd_hda_intel] returned 0 after 177739 usecs
[    9.670173] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xCF6B
[    9.670187] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD05D
[    9.690275] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD290
[    9.690278] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD2F5
[    9.720092] [drm] nouveau 0000:01:00.0: 0xD2F5: Condition still not met after 20ms, skipping following opcodes
[    9.739159] [drm] nouveau 0000:01:00.0: 1 available performance level(s)
[    9.739164] [drm] nouveau 0000:01:00.0: 0: memory 700MHz core 540MHz shader 1188MHz fanspeed 100%
[    9.739183] [drm] nouveau 0000:01:00.0: c: memory 702MHz core 540MHz shader 1188MHz voltage 1320mV
[    9.739682] [TTM] Zone  kernel: Available graphics memory: 3424778 kiB.
[    9.739685] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    9.739687] [TTM] Initializing pool allocator.
[    9.739704] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    9.749025] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    9.765980] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[    9.765983] [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
[    9.766485] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    9.766487] [drm] No driver support for vblank timestamp query.
[    9.987464] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x60000000, bo ffff8801d2539c00
[    9.987911] Console: switching to colour frame buffer device 240x75
[    9.990029] fb0: nouveaufb frame buffer device
[    9.990032] drm: registered panic notifier
[    9.990039] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    9.990360] initcall nouveau_init+0x0/0x1000 [nouveau] returned 0 after 521813 usecs
[   10.266670] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   10.266673] vgaarb: transferring owner from PCI:0000:01:00.0 to PCI:0000:03:00.0
[   10.456627] calling  ppdev_init+0x0/0x1000 [ppdev] @ 1615
[   10.459041] ppdev: user-space parallel port driver
[   10.459047] initcall ppdev_init+0x0/0x1000 [ppdev] returned 0 after 2357 usecs
[   10.469923] calling  parport_pc_init+0x0/0xf40 [parport_pc] @ 1622
[   10.474163] initcall parport_pc_init+0x0/0xf40 [parport_pc] returned 0 after 4133 usecs
[   10.679531] calling  init_misc_binfmt+0x0/0x1000 [binfmt_misc] @ 1711
[   10.679539] initcall init_misc_binfmt+0x0/0x1000 [binfmt_misc] returned 0 after 2 usecs
[   11.274562] EXT4-fs (sdb1): re-mounted. Opts: errors=remount-ro,commit=0
[   12.130837] r8169 0000:05:00.0: eth2: link up
[   12.132090] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[   12.132904] switch: port 1(eth2) entering learning state
[   12.132906] switch: port 1(eth2) entering learning state
[   13.870479] EXT4-fs (sdb1): re-mounted. Opts: errors=remount-ro,commit=0
[   20.020079] switch: no IPv6 routers present
[   22.430069] eth2: no IPv6 routers present
[   27.150096] switch: port 1(eth2) entering forwarding state
[   27.847940] calling  init_sunrpc+0x0/0x73 [sunrpc] @ 3304
[   27.850098] RPC: Registered udp transport module.
[   27.850101] RPC: Registered tcp transport module.
[   27.850104] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   27.850120] initcall init_sunrpc+0x0/0x73 [sunrpc] returned 0 after 2111 usecs
[   27.865067] calling  init_rpcsec_gss+0x0/0x1000 [auth_rpcgss] @ 3326
[   27.865088] initcall init_rpcsec_gss+0x0/0x1000 [auth_rpcgss] returned 0 after 14 usecs
[   27.884329] calling  fscache_init+0x0/0x20e [fscache] @ 3333
[   27.884435] FS-Cache: Loaded
[   27.884442] initcall fscache_init+0x0/0x20e [fscache] returned 0 after 102 usecs
[   27.914478] calling  init_nlm+0x0/0x1000 [lockd] @ 3290
[   27.914526] initcall init_nlm+0x0/0x1000 [lockd] returned 0 after 39 usecs
[   27.995348] calling  init_nfs_fs+0x0/0x16c [nfs] @ 3326
[   27.995357] FS-Cache: Netfs 'nfs' registered for caching
[   27.995966] initcall init_nfs_fs+0x0/0x16c [nfs] returned 0 after 590 usecs
[   28.070897] svc: failed to register lockdv1 RPC service (errno 97).

--ReaqsoxgOBHFXBhH--
