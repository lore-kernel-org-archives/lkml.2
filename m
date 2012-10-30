Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425Ab2J3SdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:33:23 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:36014 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab2J3SdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:33:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,682,1344211200"; 
   d="scan'208";a="15497723"
Message-ID: <50901D6C.6020500@citrix.com>
Date: Tue, 30 Oct 2012 19:33:16 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Persistent grant maps for xen blk drivers
References: <1351097925-26221-1-git-send-email-roger.pau@citrix.com> <20121030170157.GA29485@phenom.dumpdata.com>
In-Reply-To: <20121030170157.GA29485@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/12 18:01, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 24, 2012 at 06:58:45PM +0200, Roger Pau Monne wrote:
>> This patch implements persistent grants for the xen-blk{front,back}
>> mechanism. The effect of this change is to reduce the number of unmap
>> operations performed, since they cause a (costly) TLB shootdown. This
>> allows the I/O performance to scale better when a large number of VMs
>> are performing I/O.
>>
>> Previously, the blkfront driver was supplied a bvec[] from the request
>> queue. This was granted to dom0; dom0 performed the I/O and wrote
>> directly into the grant-mapped memory and unmapped it; blkfront then
>> removed foreign access for that grant. The cost of unmapping scales
>> badly with the number of CPUs in Dom0. An experiment showed that when
>> Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
>> ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
>> (at which point 650,000 IOPS are being performed in total). If more
>> than 5 guests are used, the performance declines. By 10 guests, only
>> 400,000 IOPS are being performed.
>>
>> This patch improves performance by only unmapping when the connection
>> between blkfront and back is broken.
>>
>> On startup blkfront notifies blkback that it is using persistent
>> grants, and blkback will do the same. If blkback is not capable of
>> persistent mapping, blkfront will still use the same grants, since it
>> is compatible with the previous protocol, and simplifies the code
>> complexity in blkfront.
>>
>> To perform a read, in persistent mode, blkfront uses a separate pool
>> of pages that it maps to dom0. When a request comes in, blkfront
>> transmutes the request so that blkback will write into one of these
>> free pages. Blkback keeps note of which grefs it has already
>> mapped. When a new ring request comes to blkback, it looks to see if
>> it has already mapped that page. If so, it will not map it again. If
>> the page hasn't been previously mapped, it is mapped now, and a record
>> is kept of this mapping. Blkback proceeds as usual. When blkfront is
>> notified that blkback has completed a request, it memcpy's from the
>> shared memory, into the bvec supplied. A record that the {gref, page}
>> tuple is mapped, and not inflight is kept.
>>
>> Writes are similar, except that the memcpy is peformed from the
>> supplied bvecs, into the shared pages, before the request is put onto
>> the ring.
>>
>> Blkback stores a mapping of grefs=>{page mapped to by gref} in
>> a red-black tree. As the grefs are not known apriori, and provide no
>> guarantees on their ordering, we have to perform a search
>> through this tree to find the page, for every gref we receive. This
>> operation takes O(log n) time in the worst case. In blkfront grants
>> are stored using a single linked list.
>>
>> The maximum number of grants that blkback will persistenly map is
>> currently set to RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST, to
>> prevent a malicios guest from attempting a DoS, by supplying fresh
>> grefs, causing the Dom0 kernel to map excessively. If a guest
>> is using persistent grants and exceeds the maximum number of grants to
>> map persistenly the newly passed grefs will be mapped and unmaped.
>> Using this approach, we can have requests that mix persistent and
>> non-persistent grants, and we need to handle them correctly.
>> This allows us to set the maximum number of persistent grants to a
>> lower value than RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST, although
>> setting it will lead to unpredictable performance.
>>
>> In writing this patch, the question arrises as to if the additional
>> cost of performing memcpys in the guest (to/from the pool of granted
>> pages) outweigh the gains of not performing TLB shootdowns. The answer
>> to that question is `no'. There appears to be very little, if any
>> additional cost to the guest of using persistent grants. There is
>> perhaps a small saving, from the reduced number of hypercalls
>> performed in granting, and ending foreign access.
>>
>> Signed-off-by: Oliver Chick <oliver.chick@citrix.com>
>> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
>> Cc: <konrad.wilk@oracle.com>
>> Cc: <linux-kernel@vger.kernel.org>
>> ---
>> Changes since v1:
>>  * Changed the unmap_seg array to a bitmap.
>>  * Only report using persistent grants in blkfront if blkback supports
>>    it.
>>  * Reword some comments.
>>  * Fix a bug when setting the handler, index j was not incremented
>>    correctly.
>>  * Check that the tree of grants in blkback is not empty before
>>    iterating over it when doing the cleanup.
>>  * Rebase on top of linux-net.
> 
> I fixed the 'new_map = [1|0]' you had in and altered it to use 'true'
> or 'false', but when running some tests (with a 64-bit PV guest) I got it
> to bug.

Thanks for the testing. I'm going to rebase on top of your linux-next
branch and see if I can reproduce it. Did you run any kind of specific
test/benchmark? I've been running with this patch for a long time (on
top of your previous linux-next branch), and I haven't been able to get
it to bug.

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.7.0-rc3upstream-00220-g37b7153 (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Tue Oct 30 12:15:12 EDT 2012
> [    0.000000] Command line: earlyprintk=xen debug nofb console=tty console=ttyS1,115200n8 xen-pciback.hide=(00:02:00) loglevel=10
> [    0.000000] Freeing 9d-100 pfn range: 99 pages freed
> [    0.000000] 1-1 mapping on 9d->100
> [    0.000000] 1-1 mapping on cf7fb->cfb63
> [    0.000000] 1-1 mapping on cfd15->cfd70
> [    0.000000] 1-1 mapping on cfd71->cfef7
> [    0.000000] 1-1 mapping on cff00->100001
> [    0.000000] Released 99 pages of unused memory
> [    0.000000] Set 198317 page(s) to 1-1 mapping
> [    0.000000] Populating 3e700-3e763 pfn range: 99 pages added
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] Xen: [mem 0x0000000000000000-0x000000000009cfff] usable
> [    0.000000] Xen: [mem 0x000000000009d800-0x00000000000fffff] reserved
> [    0.000000] Xen: [mem 0x0000000000100000-0x000000004d062fff] usable
> [    0.000000] Xen: [mem 0x000000004d063000-0x00000000cf7fafff] unusable
> [    0.000000] Xen: [mem 0x00000000cf7fb000-0x00000000cf95ffff] reserved
> [    0.000000] Xen: [mem 0x00000000cf960000-0x00000000cfb62fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfb63000-0x00000000cfd14fff] unusable
> [    0.000000] Xen: [mem 0x00000000cfd15000-0x00000000cfd61fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfd62000-0x00000000cfd6cfff] ACPI data
> [    0.000000] Xen: [mem 0x00000000cfd6d000-0x00000000cfd6ffff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfd70000-0x00000000cfd70fff] unusable
> [    0.000000] Xen: [mem 0x00000000cfd71000-0x00000000cfea8fff] reserved
> [    0.000000] Xen: [mem 0x00000000cfea9000-0x00000000cfeb9fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfeba000-0x00000000cfecafff] reserved
> [    0.000000] Xen: [mem 0x00000000cfecb000-0x00000000cfecbfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfecc000-0x00000000cfedbfff] reserved
> [    0.000000] Xen: [mem 0x00000000cfedc000-0x00000000cfedcfff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfedd000-0x00000000cfeddfff] reserved
> [    0.000000] Xen: [mem 0x00000000cfede000-0x00000000cfee3fff] ACPI NVS
> [    0.000000] Xen: [mem 0x00000000cfee4000-0x00000000cfef6fff] reserved
> [    0.000000] Xen: [mem 0x00000000cfef7000-0x00000000cfefffff] unusable
> [    0.000000] Xen: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] Xen: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
> [    0.000000] Xen: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
> [    0.000000] Xen: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
> [    0.000000] Xen: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
> [    0.000000] Xen: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
> [    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] Xen: [mem 0x0000000100001000-0x000000020effffff] unusable
> [    0.000000] bootconsole [xenboot0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.6 present.
> [    0.000000] DMI: System manufacturer System Product Name/F1A75-M, BIOS 0406 06/11/2011
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x4d063 max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped: [mem 0x00000000-0x16bcdfff]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x4d062fff]
> [    0.000000]  [mem 0x00000000-0x4d062fff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x4d062fff @ [mem 0x01e21000-0x0208cfff]
> [    0.000000] xen: setting RW the range 1fd3000 - 208d000
> [    0.000000] RAMDISK: [mem 0x0208d000-0x16bcdfff]
> [    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
> [    0.000000] ACPI: XSDT 00000000cfd62068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 00000000cfd69a68 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
> [    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20120913/tbfadt-598)
> [    0.000000] ACPI: DSDT 00000000cfd62150 07917 (v02 ALASKA    A M I 00000000 INTL 20051117)
> [    0.000000] ACPI: FACS 00000000cfedef80 00040
> [    0.000000] ACPI: APIC 00000000cfd69b60 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
> [    0.000000] ACPI: MCFG 00000000cfd69bd8 0003C (v01 A M I  GMCH945. 01072009 MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000cfd69c18 00038 (v01 ALASKA    A M I 01072009 AMI  00000004)
> [    0.000000] ACPI: SSDT 00000000cfd69c50 00FD8 (v01 AMD    POWERNOW 00000001 AMD  00000001)
> [    0.000000] ACPI: SSDT 00000000cfd6ac28 01923 (v02    AMD     ALIB 00000001 MSFT 04000000)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] NUMA turned off
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000004d062fff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x4d062fff]
> [    0.000000]   NODE_DATA [mem 0x3e75f000-0x3e762fff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x4d062fff]
> [    0.000000] On node 0 totalpages: 315376
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3919 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 4258 pages used for memmap
> [    0.000000]   DMA32 zone: 307137 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 5, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000000100000
> [    0.000000] e820: [mem 0xcff00000-0xdfffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on Xen
> [    0.000000] Xen version: 4.1.4-pre (preserve-AD)
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003e000000 s84288 r8192 d22208 u524288
> [    0.000000] pcpu-alloc: s84288 r8192 d22208 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3
> [    2.763208] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 311056
> [    2.763213] Policy zone: DMA32
> [    2.763218] Kernel command line: earlyprintk=xen debug nofb console=tty console=ttyS1,115200n8 xen-pciback.hide=(00:02:00) loglevel=10
> [    2.763656] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    2.763663] __ex_table already sorted, skipping sort
> [    2.808064] software IO TLB [mem 0x38a00000-0x3ca00000] (64MB) mapped at [ffff880038a00000-ffff88003c9fffff]
> [    2.811300] Memory: 581728k/1261964k available (6413k kernel code, 460k absent, 679776k reserved, 4478k data, 752k init)
> [    2.811414] Hierarchical RCU implementation.
> [    2.811419]  RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=3.
> [    2.811432] NR_IRQS:33024 nr_irqs:704 16
> [    2.811514] xen: sci override: global_irq=9 trigger=0 polarity=1
> [    2.811518] xen: registering gsi 9 triggering 0 polarity 1
> [    2.811531] xen: --> pirq=9 -> irq=9 (gsi=9)
> [    2.811539] xen: acpi sci 9
> [    2.811546] xen: --> pirq=1 -> irq=1 (gsi=1)
> [    2.811551] xen: --> pirq=2 -> irq=2 (gsi=2)
> [    2.811557] xen: --> pirq=3 -> irq=3 (gsi=3)
> [    2.811562] xen: --> pirq=4 -> irq=4 (gsi=4)
> [    2.811568] xen: --> pirq=5 -> irq=5 (gsi=5)
> [    2.811574] xen: --> pirq=6 -> irq=6 (gsi=6)
> [    2.811579] xen: --> pirq=7 -> irq=7 (gsi=7)
> [    2.811585] xen: --> pirq=8 -> irq=8 (gsi=8)
> [    2.811590] xen: --> pirq=10 -> irq=10 (gsi=10)
> [    2.811596] xen: --> pirq=11 -> irq=11 (gsi=11)
> [    2.811602] xen: --> pirq=12 -> irq=12 (gsi=12)
> [    2.811607] xen: --> pirq=13 -> irq=13 (gsi=13)
> [    2.811613] xen: --> pirq=14 -> irq=14 (gsi=14)
> [    2.811618] xen: --> pirq=15 -> irq=15 (gsi=15)
> [    2.813454] Console: colour VGA+ 80x25
> [    2.818363] console [tty0] enabled
> [    2.818422] console [ttyS1] enabled, bootconsole disabled
> [    2.818757] Xen: using vcpuop timer interface
> [    2.819017] installing Xen timer for CPU 0
> [    2.819285] tsc: Detected 2899.980 MHz processor
> [    2.819555] Calibrating delay loop (skipped), value calculated using timer frequency.. 5799.96 BogoMIPS (lpj=2899980)
> [    2.820151] pid_max: default: 32768 minimum: 301
> [    2.820479] Security Framework initialized
> [    2.820728] SELinux:  Initializing.
> [    2.820948] SELinux:  Starting in permissive mode
> [    2.821532] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    2.822565] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    2.823519] Mount-cache hash table entries: 256
> [    2.824126] Initializing cgroup subsys cpuacct
> [    2.824400] Initializing cgroup subsys freezer
> [    2.824730] tseg: 00cff00000
> [    2.824934] CPU: Physical Processor ID: 0
> [    2.825186] CPU: Processor Core ID: 0
> [    2.825417] mce: CPU supports 6 MCE banks
> [    2.825696] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
> [    2.825696] Last level dTLB entries: 4KB 1024, 2MB 128, 4MB 64
> [    2.825696] tlb_flushall_shift: 5
> [    2.826625] Freeing SMP alternatives: 24k freed
> [    2.829704] ACPI: Core revision 20120913
> [    2.856787] cpu 0 spinlock event irq 41
> [    2.857062] Performance Events: Broken PMU hardware detected, using software events only.
> [    2.857602] Failed to access perfctr msr (MSR c0010004 is 0)
> [    2.858234] MCE: In-kernel MCE decoding enabled.
> [    2.858603] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    2.859223] installing Xen timer for CPU 1
> [    2.859499] cpu 1 spinlock event irq 48
> [    2.860218] installing Xen timer for CPU 2
> [    2.860493] cpu 2 spinlock event irq 55
> [    2.860951] Brought up 3 CPUs
> [    2.864412] PM: Registering ACPI NVS region [mem 0xcf960000-0xcfb62fff] (2109440 bytes)
> [    2.865989] PM: Registering ACPI NVS region [mem 0xcfd15000-0xcfd61fff] (315392 bytes)
> [    2.866464] PM: Registering ACPI NVS region [mem 0xcfd6d000-0xcfd6ffff] (12288 bytes)
> [    2.866931] PM: Registering ACPI NVS region [mem 0xcfea9000-0xcfeb9fff] (69632 bytes)
> [    2.867404] PM: Registering ACPI NVS region [mem 0xcfecb000-0xcfecbfff] (4096 bytes)
> [    2.867861] PM: Registering ACPI NVS region [mem 0xcfedc000-0xcfedcfff] (4096 bytes)
> [    2.868321] PM: Registering ACPI NVS region [mem 0xcfede000-0xcfee3fff] (24576 bytes)
> [    2.869081] kworker/u:0 (26) used greatest stack depth: 6120 bytes left
> [    2.869105] Grant tables using version 2 layout.
> [    2.869122] Grant table initialized
> [    2.869164] RTC time: 16:43:55, date: 10/30/12
> [    2.870366] NET: Registered protocol family 16
> [    2.871181] kworker/u:0 (30) used greatest stack depth: 5504 bytes left
> [    2.872440] ACPI: bus type pci registered
> [    2.873480] dca service started, version 1.12.1
> [    2.873891] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    2.874438] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    2.914335] PCI: Using configuration type 1 for base access
> [    2.932999] bio: create slab <bio-0> at 0
> [    2.933584] ACPI: Added _OSI(Module Device)
> [    2.933866] ACPI: Added _OSI(Processor Device)
> [    2.934145] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    2.934432] ACPI: Added _OSI(Processor Aggregator Device)
> [    2.942011] ACPI: EC: Look up EC in DSDT
> [    2.950054] ACPI: Executed 1 blocks of module-level executable AML code
> [    2.956530] ACPI: Interpreter enabled
> [    2.956772] ACPI: (supports S0 S3 S4 S5)
> [    2.957218] ACPI: Using IOAPIC for interrupt routing
> [    2.982389] ACPI: No dock devices found.
> [    2.982650] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    2.983552] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    2.984298] PCI host bridge to bus 0000:00
> [    2.984571] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    2.984906] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
> [    2.985277] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
> [    2.985657] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
> [    2.986029] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    2.986399] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    2.986810] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
> [    2.987214] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xffffffff]
> [    2.987631] pci 0000:00:00.0: [1022:1705] type 00 class 0x060000
> [    2.988106] pci 0000:00:01.0: [1002:9640] type 00 class 0x030000
> [    2.988487] pci 0000:00:01.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
> [    2.988893] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
> [    2.989246] pci 0000:00:01.0: reg 18: [mem 0xfeb00000-0xfeb3ffff]
> [    2.989743] pci 0000:00:01.0: supports D1 D2
> [    2.990053] pci 0000:00:01.1: [1002:1714] type 00 class 0x040300
> [    2.990442] pci 0000:00:01.1: reg 10: [mem 0xfeb44000-0xfeb47fff]
> [    2.990965] pci 0000:00:01.1: supports D1 D2
> [    2.991343] pci 0000:00:10.0: [1022:7812] type 00 class 0x0c0330
> [    2.991752] pci 0000:00:10.0: reg 10: [mem 0xfeb4a000-0xfeb4bfff 64bit]
> [    2.992355] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
> [    2.992803] pci 0000:00:10.1: [1022:7812] type 00 class 0x0c0330
> [    2.993201] pci 0000:00:10.1: reg 10: [mem 0xfeb48000-0xfeb49fff 64bit]
> [    2.993793] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
> [    2.994239] pci 0000:00:11.0: [1022:7801] type 00 class 0x010601
> [    2.994637] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
> [    2.994982] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
> [    2.995333] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
> [    2.995678] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
> [    2.996024] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
> [    2.996374] pci 0000:00:11.0: reg 24: [mem 0xfeb51000-0xfeb517ff]
> [    2.996850] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
> [    2.997235] pci 0000:00:12.0: reg 10: [mem 0xfeb50000-0xfeb50fff]
> [    2.997765] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
> [    2.998161] pci 0000:00:12.2: reg 10: [mem 0xfeb4f000-0xfeb4f0ff]
> [    2.998712] pci 0000:00:12.2: supports D1 D2
> [    2.998977] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
> [    2.999375] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
> [    2.999768] pci 0000:00:13.0: reg 10: [mem 0xfeb4e000-0xfeb4efff]
> [    3.000283] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
> [    3.000681] pci 0000:00:13.2: reg 10: [mem 0xfeb4d000-0xfeb4d0ff]
> [    3.001227] pci 0000:00:13.2: supports D1 D2
> [    3.001495] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
> [    3.001902] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
> [    3.002433] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
> [    3.002840] pci 0000:00:14.2: reg 10: [mem 0xfeb40000-0xfeb43fff 64bit]
> [    3.003376] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
> [    3.003761] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
> [    3.004279] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
> [    3.004730] pci 0000:00:14.5: [1022:7809] type 00 class 0x0c0310
> [    3.005119] pci 0000:00:14.5: reg 10: [mem 0xfeb4c000-0xfeb4cfff]
> [    3.005641] pci 0000:00:15.0: [1022:43a0] type 01 class 0x060400
> [    3.006187] pci 0000:00:15.0: supports D1 D2
> [    3.006515] pci 0000:00:15.1: [1022:43a1] type 01 class 0x060400
> [    3.007059] pci 0000:00:15.1: supports D1 D2
> [    3.007403] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
> [    3.007868] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
> [    3.008320] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
> [    3.008778] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
> [    3.009271] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
> [    3.009716] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
> [    3.010167] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
> [    3.010615] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
> [    3.011117] pci 0000:01:05.0: [9710:9835] type 00 class 0x070002
> [    3.011513] pci 0000:01:05.0: reg 10: [io  0xe050-0xe057]
> [    3.011861] pci 0000:01:05.0: reg 14: [io  0xe040-0xe047]
> [    3.012210] pci 0000:01:05.0: reg 18: [io  0xe030-0xe037]
> [    3.012563] pci 0000:01:05.0: reg 1c: [io  0xe020-0xe027]
> [    3.012912] pci 0000:01:05.0: reg 20: [io  0xe010-0xe017]
> [    3.013259] pci 0000:01:05.0: reg 24: [io  0xe000-0xe00f]
> [    3.013710] pci 0000:00:14.4: PCI bridge to [bus 01] (subtractive decode)
> [    3.014118] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
> [    3.014496] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
> [    3.014967] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
> [    3.015422] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
> [    3.015878] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    3.016343] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    3.016836] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
> [    3.017326] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xffffffff] (subtractive decode)
> [    3.017990] pci 0000:02:00.0: [8086:10d3] type 00 class 0x020000
> [    3.018379] pci 0000:02:00.0: reg 10: [mem 0xfeac0000-0xfeadffff]
> [    3.018769] pci 0000:02:00.0: reg 14: [mem 0xfea00000-0xfea7ffff]
> [    3.019167] pci 0000:02:00.0: reg 18: [io  0xd000-0xd01f]
> [    3.019522] pci 0000:02:00.0: reg 1c: [mem 0xfeae0000-0xfeae3fff]
> [    3.019964] pci 0000:02:00.0: reg 30: [mem 0xfea80000-0xfeabffff pref]
> [    3.020508] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> [    3.023962] pci 0000:00:15.0: PCI bridge to [bus 02]
> [    3.024307] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
> [    3.024689] pci 0000:00:15.0:   bridge window [mem 0xfea00000-0xfeafffff]
> [    3.025293] pci 0000:03:00.0: [1969:1083] type 00 class 0x020000
> [    3.025712] pci 0000:03:00.0: reg 10: [mem 0xfe900000-0xfe93ffff 64bit]
> [    3.026139] pci 0000:03:00.0: reg 18: [io  0xc000-0xc07f]
> [    3.026691] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    3.028949] pci 0000:00:15.1: PCI bridge to [bus 03]
> [    3.029290] pci 0000:00:15.1:   bridge window [io  0xc000-0xcfff]
> [    3.029671] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
> [    3.030148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    3.030844] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
> [    3.031280] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
> [    3.031782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
> [    3.032377]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    3.032947]  pci0000:00: ACPI _OSC control (0x1d) granted
> [    3.051344] ACPI: PCI Interrupt Link [LN24] (IRQs *24)
> [    3.051852] ACPI: PCI Interrupt Link [LN25] (IRQs *25)
> [    3.052329] ACPI: PCI Interrupt Link [LN26] (IRQs *26)
> [    3.052821] ACPI: PCI Interrupt Link [LN27] (IRQs *27)
> [    3.053298] ACPI: PCI Interrupt Link [LN28] (IRQs *28)
> [    3.053787] ACPI: PCI Interrupt Link [LN29] (IRQs *29)
> [    3.054271] ACPI: PCI Interrupt Link [LN30] (IRQs *30)
> [    3.054747] ACPI: PCI Interrupt Link [LN31] (IRQs *31)
> [    3.055243] ACPI: PCI Interrupt Link [LN32] (IRQs *32)
> [    3.055724] ACPI: PCI Interrupt Link [LN33] (IRQs *33)
> [    3.056211] ACPI: PCI Interrupt Link [LN34] (IRQs *34)
> [    3.056692] ACPI: PCI Interrupt Link [LN35] (IRQs *35)
> [    3.057187] ACPI: PCI Interrupt Link [LN36] (IRQs *36)
> [    3.057673] ACPI: PCI Interrupt Link [LN37] (IRQs *37)
> [    3.058165] ACPI: PCI Interrupt Link [LN38] (IRQs *38)
> [    3.058660] ACPI: PCI Interrupt Link [LN39] (IRQs *39)
> [    3.059154] ACPI: PCI Interrupt Link [LN40] (IRQs *40)
> [    3.059643] ACPI: PCI Interrupt Link [LN41] (IRQs *41)
> [    3.060128] ACPI: PCI Interrupt Link [LN42] (IRQs *42)
> [    3.060618] ACPI: PCI Interrupt Link [LN43] (IRQs *43)
> [    3.061095] ACPI: PCI Interrupt Link [LN44] (IRQs *44)
> [    3.061575] ACPI: PCI Interrupt Link [LN45] (IRQs *45)
> [    3.062059] ACPI: PCI Interrupt Link [LN46] (IRQs *46)
> [    3.062543] ACPI: PCI Interrupt Link [LN47] (IRQs *47)
> [    3.063029] ACPI: PCI Interrupt Link [LN48] (IRQs *48)
> [    3.063506] ACPI: PCI Interrupt Link [LN49] (IRQs *49)
> [    3.063989] ACPI: PCI Interrupt Link [LN50] (IRQs *50)
> [    3.064473] ACPI: PCI Interrupt Link [LN51] (IRQs *51)
> [    3.064950] ACPI: PCI Interrupt Link [LN52] (IRQs *52)
> [    3.065440] ACPI: PCI Interrupt Link [LN53] (IRQs *53)
> [    3.065918] ACPI: PCI Interrupt Link [LN54] (IRQs *54)
> [    3.066402] ACPI: PCI Interrupt Link [LN55] (IRQs *55)
> [    3.066889] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
> [    3.068826] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
> [    3.069717] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
> [    3.070606] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
> [    3.071479] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
> [    3.072339] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
> [    3.073195] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
> [    3.074064] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
> [    3.075123] xen/balloon: Initialising balloon driver.
> [    3.076280] xen-balloon: Initialising balloon driver.
> [    3.076885] xen/balloon: Xen selfballooning driver disabled for domain0.
> [    3.077545] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
> [    3.078080] vgaarb: loaded
> [    3.078268] vgaarb: bridge control possible 0000:00:01.0
> [    3.078970] ACPI: bus type usb registered
> [    3.079409] usbcore: registered new interface driver usbfs
> [    3.079813] usbcore: registered new interface driver hub
> [    3.080257] usbcore: registered new device driver usb
> [    3.081098] PCI: Using ACPI for IRQ routing
> [    3.098106] PCI: pci_cache_line_size set to 64 bytes
> [    3.098606] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
> [    3.098972] e820: reserve RAM buffer [mem 0x4d063000-0x4fffffff]
> [    3.099810] NetLabel: Initializing
> [    3.100040] NetLabel:  domain hash size = 128
> [    3.100313] NetLabel:  protocols = UNLABELED CIPSOv4
> [    3.100639] NetLabel:  unlabeled traffic allowed by default
> [    3.101361] Switching to clocksource xen
> [    3.109135] pnp: PnP ACPI init
> [    3.109362] ACPI: bus type pnp registered
> [    3.109832] pnp 00:00: [bus 00-ff]
> [    3.110058] pnp 00:00: [io  0x0cf8-0x0cff]
> [    3.110319] pnp 00:00: [io  0x0000-0x03af window]
> [    3.110611] pnp 00:00: [io  0x03e0-0x0cf7 window]
> [    3.110912] pnp 00:00: [io  0x03b0-0x03df window]
> [    3.111200] pnp 00:00: [io  0x0d00-0xffff window]
> [    3.111492] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    3.111826] pnp 00:00: [mem 0x000c0000-0x000dffff window]
> [    3.112154] pnp 00:00: [mem 0xd0000000-0xffffffff window]
> [    3.112482] pnp 00:00: [mem 0x00000000 window]
> [    3.113097] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
> [    3.113537] pnp 00:01: [mem 0xe0000000-0xefffffff]
> [    3.114213] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> [    3.114626] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    3.116690] pnp 00:02: [io  0x0010-0x001f]
> [    3.116955] pnp 00:02: [io  0x0022-0x003f]
> [    3.117210] pnp 00:02: [io  0x0063]
> [    3.117439] pnp 00:02: [io  0x0065]
> [    3.117667] pnp 00:02: [io  0x0067-0x006f]
> [    3.117932] pnp 00:02: [io  0x0072-0x007f]
> [    3.118191] pnp 00:02: [io  0x0080]
> [    3.118415] pnp 00:02: [io  0x0084-0x0086]
> [    3.118668] pnp 00:02: [io  0x0088]
> [    3.118910] pnp 00:02: [io  0x008c-0x008e]
> [    3.119174] pnp 00:02: [io  0x0090-0x009f]
> [    3.119436] pnp 00:02: [io  0x00a2-0x00bf]
> [    3.119706] pnp 00:02: [io  0x00b1]
> [    3.119936] pnp 00:02: [io  0x00e0-0x00ef]
> [    3.120194] pnp 00:02: [io  0x04d0-0x04d1]
> [    3.120455] pnp 00:02: [io  0x040b]
> [    3.120683] pnp 00:02: [io  0x04d6]
> [    3.120916] pnp 00:02: [io  0x0c00-0x0c01]
> [    3.121172] pnp 00:02: [io  0x0c14]
> [    3.121397] pnp 00:02: [io  0x0c50-0x0c51]
> [    3.121653] pnp 00:02: [io  0x0c52]
> [    3.121885] pnp 00:02: [io  0x0c6c]
> [    3.122109] pnp 00:02: [io  0x0c6f]
> [    3.122335] pnp 00:02: [io  0x0cd0-0x0cd1]
> [    3.122591] pnp 00:02: [io  0x0cd2-0x0cd3]
> [    3.122860] pnp 00:02: [io  0x0cd4-0x0cd5]
> [    3.123120] pnp 00:02: [io  0x0cd6-0x0cd7]
> [    3.123377] pnp 00:02: [io  0x0cd8-0x0cdf]
> [    3.123633] pnp 00:02: [io  0x0800-0x089f]
> [    3.123898] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
> [    3.124249] pnp 00:02: [io  0x0000-0x000f]
> [    3.124506] pnp 00:02: [io  0x0b20-0x0b3f]
> [    3.124768] pnp 00:02: [io  0x0900-0x090f]
> [    3.125026] pnp 00:02: [io  0x0910-0x091f]
> [    3.125282] pnp 00:02: [io  0xfe00-0xfefe]
> [    3.125537] pnp 00:02: [io  0x0060-0x005f disabled]
> [    3.125841] pnp 00:02: [io  0x0064-0x0063 disabled]
> [    3.126136] pnp 00:02: [mem 0xfec00000-0xfec00fff]
> [    3.126426] pnp 00:02: [mem 0xfee00000-0xfee00fff]
> [    3.126724] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
> [    3.127024] pnp 00:02: [mem 0xfed61000-0xfed70fff]
> [    3.127321] pnp 00:02: [mem 0xfec10000-0xfec10fff]
> [    3.127619] pnp 00:02: [mem 0xfed00000-0xfed00fff]
> [    3.127920] pnp 00:02: [mem 0xff000000-0xffffffff]
> [    3.128629] system 00:02: [io  0x04d0-0x04d1] has been reserved
> [    3.129033] system 00:02: [io  0x040b] has been reserved
> [    3.129358] system 00:02: [io  0x04d6] has been reserved
> [    3.129680] system 00:02: [io  0x0c00-0x0c01] has been reserved
> [    3.130042] system 00:02: [io  0x0c14] has been reserved
> [    3.130365] system 00:02: [io  0x0c50-0x0c51] has been reserved
> [    3.130727] system 00:02: [io  0x0c52] has been reserved
> [    3.131046] system 00:02: [io  0x0c6c] has been reserved
> [    3.131369] system 00:02: [io  0x0c6f] has been reserved
> [    3.131692] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
> [    3.132047] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
> [    3.132401] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
> [    3.132756] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
> [    3.133111] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
> [    3.133460] system 00:02: [io  0x0800-0x089f] has been reserved
> [    3.133814] system 00:02: [io  0x0b20-0x0b3f] has been reserved
> [    3.134168] system 00:02: [io  0x0900-0x090f] has been reserved
> [    3.134524] system 00:02: [io  0x0910-0x091f] has been reserved
> [    3.134888] system 00:02: [io  0xfe00-0xfefe] has been reserved
> [    3.135250] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    3.135651] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
> [    3.136053] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserved
> [    3.136437] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserved
> [    3.136829] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserved
> [    3.137219] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserved
> [    3.137608] system 00:02: [mem 0xff000000-0xffffffff] has been reserved
> [    3.138015] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.138611] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
> [    3.138981] pnp 00:03: [io  0x0300-0x031f]
> [    3.139249] pnp 00:03: [io  0x0290-0x029f]
> [    3.139512] pnp 00:03: [io  0x0230-0x023f]
> [    3.140070] system 00:03: [io  0x0300-0x031f] has been reserved
> [    3.140431] system 00:03: [io  0x0290-0x029f] has been reserved
> [    3.140800] system 00:03: [io  0x0230-0x023f] has been reserved
> [    3.141165] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.141595] pnp 00:04: [dma 4]
> [    3.141809] pnp 00:04: [io  0x0000-0x000f]
> [    3.142070] pnp 00:04: [io  0x0081-0x0083]
> [    3.142330] pnp 00:04: [io  0x0087]
> [    3.142557] pnp 00:04: [io  0x0089-0x008b]
> [    3.142825] pnp 00:04: [io  0x008f]
> [    3.143052] pnp 00:04: [io  0x00c0-0x00df]
> [    3.143532] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    3.143961] pnp 00:05: [io  0x0070-0x0071]
> [    3.144222] xen: registering gsi 8 triggering 1 polarity 0
> [    3.144562] pnp 00:05: [irq 8]
> [    3.145001] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    3.145408] pnp 00:06: [io  0x0061]
> [    3.145932] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
> [    3.146422] pnp 00:07: [io  0x0010-0x001f]
> [    3.146682] pnp 00:07: [io  0x0022-0x003f]
> [    3.146977] pnp 00:07: [io  0x0044-0x005f]
> [    3.147238] pnp 00:07: [io  0x0072-0x007f]
> [    3.147491] pnp 00:07: [io  0x0080]
> [    3.147722] pnp 00:07: [io  0x0084-0x0086]
> [    3.147980] pnp 00:07: [io  0x0088]
> [    3.148211] pnp 00:07: [io  0x008c-0x008e]
> [    3.148469] pnp 00:07: [io  0x0090-0x009f]
> [    3.148734] pnp 00:07: [io  0x00a2-0x00bf]
> [    3.148988] pnp 00:07: [io  0x00e0-0x00ef]
> [    3.149250] pnp 00:07: [io  0x04d0-0x04d1]
> [    3.149697] system 00:07: [io  0x04d0-0x04d1] has been reserved
> [    3.150061] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.150478] pnp 00:08: [io  0x00f0-0x00ff]
> [    3.150755] xen: registering gsi 13 triggering 1 polarity 0
> [    3.151101] pnp 00:08: [irq 13]
> [    3.151448] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    3.152100] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.152778] pnp 00:0a: [io  0x03f8-0x03ff]
> [    3.153037] xen: registering gsi 4 triggering 1 polarity 0
> [    3.153376] pnp 00:0a: [irq 4]
> [    3.153581] pnp 00:0a: [dma 0 disabled]
> [    3.153998] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
> [    3.155394] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
> [    3.155978] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
> [    3.156388] pnp: PnP ACPI: found 12 devices
> [    3.156653] ACPI: ACPI bus type pnp unregistered
> [    3.156953] xen-pciback: Error parsing pci_devs_to_hide at "(00:02:00)"
> [    3.170459] PM-Timer failed consistency check  (0x0xffffff) - aborting.
> [    3.170947] pci 0000:00:14.4: PCI bridge to [bus 01]
> [    3.171261] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
> [    3.171655] pci 0000:00:15.0: PCI bridge to [bus 02]
> [    3.171974] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
> [    3.172345] pci 0000:00:15.0:   bridge window [mem 0xfea00000-0xfeafffff]
> [    3.172762] pci 0000:00:15.1: PCI bridge to [bus 03]
> [    3.173067] pci 0000:00:15.1:   bridge window [io  0xc000-0xcfff]
> [    3.173436] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
> [    3.173889] xen: registering gsi 16 triggering 0 polarity 1
> [    3.174247] xen: --> pirq=16 -> irq=16 (gsi=16)
> [    3.174547] xen: registering gsi 16 triggering 0 polarity 1
> [    3.174894] Already setup the GSI :16
> [    3.175131] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
> [    3.175470] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
> [    3.176854] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
> [    3.177184] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
> [    3.177514] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
> [    3.177891] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
> [    3.178267] pci_bus 0000:00: resource 10 [mem 0xd0000000-0xffffffff]
> [    3.178649] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
> [    3.178994] pci_bus 0000:01: resource 4 [io  0x0000-0x03af]
> [    3.179326] pci_bus 0000:01: resource 5 [io  0x03e0-0x0cf7]
> [    3.179672] pci_bus 0000:01: resource 6 [io  0x03b0-0x03df]
> [    3.180015] pci_bus 0000:01: resource 7 [io  0x0d00-0xffff]
> [    3.180344] pci_bus 0000:01: resource 8 [mem 0x000a0000-0x000bffff]
> [    3.180716] pci_bus 0000:01: resource 9 [mem 0x000c0000-0x000dffff]
> [    3.181081] pci_bus 0000:01: resource 10 [mem 0xd0000000-0xffffffff]
> [    3.181452] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
> [    3.181792] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
> [    3.182168] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
> [    3.182505] pci_bus 0000:03: resource 1 [mem 0xfe900000-0xfe9fffff]
> [    3.183045] NET: Registered protocol family 2
> [    3.184322] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    3.186023] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    3.186732] TCP: Hash tables configured (established 262144 bind 65536)
> [    3.187181] TCP: reno registered
> [    3.187411] UDP hash table entries: 1024 (order: 3, 32768 bytes)
> [    3.187803] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
> [    3.188405] NET: Registered protocol family 1
> [    3.188924] RPC: Registered named UNIX socket transport module.
> [    3.189285] RPC: Registered udp transport module.
> [    3.189588] RPC: Registered tcp transport module.
> [    3.189901] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    3.190306] pci 0000:00:01.0: Boot video device
> [    3.190606] xen: registering gsi 18 triggering 0 polarity 1
> [    3.190967] xen: --> pirq=18 -> irq=18 (gsi=18)
> [    3.191310] xen: registering gsi 17 triggering 0 polarity 1
> [    3.191651] xen: --> pirq=17 -> irq=17 (gsi=17)
> [    3.191987] xen: registering gsi 18 triggering 0 polarity 1
> [    3.192322] Already setup the GSI :18
> [    3.779210] xen: registering gsi 17 triggering 0 polarity 1
> [    3.779560] Already setup the GSI :17
> [    3.779854] xen: registering gsi 18 triggering 0 polarity 1
> [    3.780189] Already setup the GSI :18
> [    3.852950] xen: registering gsi 17 triggering 0 polarity 1
> [    3.853302] Already setup the GSI :17
> [    3.853601] xen: registering gsi 18 triggering 0 polarity 1
> [    3.853944] Already setup the GSI :18
> [    3.927246] PCI: CLS 64 bytes, default 64
> [    3.927731] Unpacking initramfs...
> [    4.409499] Freeing initrd memory: 339204k freed
> [    4.502233] Machine check injector initialized
> [    4.504138] microcode: CPU0: patch_level=0x0300000f
> [    4.504463] microcode: CPU1: patch_level=0x0300000f
> [    4.504809] microcode: CPU2: patch_level=0x0300000f
> [    4.505347] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    4.506684] audit: initializing netlink socket (disabled)
> [    4.507060] type=2000 audit(1351615437.471:1): initialized
> [    4.520849] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    4.521549] VFS: Disk quotas dquot_6.5.2
> [    4.521865] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    4.522596] NFS: Registering the id_resolver key type
> [    4.522935] Key type id_resolver registered
> [    4.523199] Key type id_legacy registered
> [    4.523463] NTFS driver 2.1.30 [Flags: R/W].
> [    4.523927] msgmni has been set to 1798
> [    4.524230] SELinux:  Registering netfilter hooks
> [    4.526131] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    4.526572] io scheduler noop registered
> [    4.526834] io scheduler deadline registered
> [    4.527129] io scheduler cfq registered (default)
> [    4.528468] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    4.529395] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> [    4.529907] ACPI: Power Button [PWRB]
> [    4.530299] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    4.530782] ACPI: Power Button [PWRF]
> [    4.592637] GHES: HEST is not enabled!
> [    4.592910] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    4.594402] xen-pciback: backend is vpci
> [    4.666851] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    4.688746] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    4.692137] xen: registering gsi 20 triggering 0 polarity 1
> [    4.692685] xen: --> pirq=20 -> irq=20 (gsi=20)
> [    4.715090] 0000:01:05.0: ttyS1 at I/O 0xe050 (irq = 20) is a 16550A
> [    4.723123] hpet_acpi_add: no address or irqs in _CRS
> [    4.729073] Non-volatile memory driver v1.3
> [    4.733807] Linux agpgart interface v0.103
> [    4.739678] [drm] Initialized drm 1.1.0 20060810
> [    4.747593] loop: module loaded
> [    4.751865] libphy: Fixed MDIO Bus: probed
> [    4.756157] tun: Universal TUN/TAP device driver, 1.6
> [    4.761408] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    4.768474] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.6.0-k
> [    4.778143] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
> [    4.786308] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    4.793112] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
> [    4.799394] xen: registering gsi 17 triggering 0 polarity 1
> [    4.805186] Already setup the GSI :17
> [    4.809041] ehci_hcd 0000:00:12.2: EHCI Host Controller
> [    4.814827] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
> [    4.822582] QUIRK: Enable AMD PLL fix
> [    4.826402] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
> [    4.835422] ehci_hcd 0000:00:12.2: reset hcs_params 0x101505 dbg=1 cc=1 pcc=5 ordered !ppc ports=5
> [    4.844716] ehci_hcd 0000:00:12.2: reset hcc_params a076 thresh 7 uframes 256/512/1024 park
> [    4.853444] ehci_hcd 0000:00:12.2: park 0
> [    4.857628] ehci_hcd 0000:00:12.2: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
> [    4.866843] ehci_hcd 0000:00:12.2: debug port 1
> [    4.871568] ehci_hcd 0000:00:12.2: MWI active
> [    4.876100] ehci_hcd 0000:00:12.2: supports USB remote wakeup
> [    4.882116] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfeb4f000
> [    4.887997] ehci_hcd 0000:00:12.2: init command 0010005 (park)=0 ithresh=1 period=512 RUN
> [    4.901882] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
> [    4.907965] usb usb1: default language 0x0409
> [    4.912513] usb usb1: udev 1, busnum 1, minor = 0
> [    4.917409] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.924454] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.931952] usb usb1: Product: EHCI Host Controller
> [    4.937024] usb usb1: Manufacturer: Linux 3.7.0-rc3upstream-00220-g37b7153 ehci_hcd
> [    4.944967] usb usb1: SerialNumber: 0000:00:12.2
> [    4.950259] usb usb1: usb_probe_device
> [    4.954193] usb usb1: configuration #1 chosen from 1 choice
> [    4.959997] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [    4.966339] hub 1-0:1.0: usb_probe_interface
> [    4.970812] hub 1-0:1.0: usb_probe_interface - got id
> [    4.976063] hub 1-0:1.0: USB hub found
> [    4.979980] hub 1-0:1.0: 5 ports detected
> [    4.984155] hub 1-0:1.0: standalone hub
> [    4.988148] hub 1-0:1.0: no power switching (usb 1.0)
> [    4.993398] hub 1-0:1.0: individual port over-current protection
> [    4.999631] hub 1-0:1.0: power on to power good time: 20ms
> [    5.005333] hub 1-0:1.0: local power source is good
> [    5.010998] hub 1-0:1.0: trying to enable port power on non-switchable hub
> [    5.018235] xen: registering gsi 17 triggering 0 polarity 1
> [    5.024028] Already setup the GSI :17
> [    5.027880] ehci_hcd 0000:00:13.2: EHCI Host Controller
> [    5.033663] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
> [    5.041377] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
> [    5.050398] ehci_hcd 0000:00:13.2: reset hcs_params 0x101505 dbg=1 cc=1 pcc=5 ordered !ppc ports=5
> [    5.059685] ehci_hcd 0000:00:13.2: reset hcc_params a076 thresh 7 uframes 256/512/1024 park
> [    5.068427] ehci_hcd 0000:00:13.2: park 0
> [    5.072610] ehci_hcd 0000:00:13.2: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
> [    5.081823] ehci_hcd 0000:00:13.2: debug port 1
> [    5.086547] ehci_hcd 0000:00:13.2: MWI active
> [    5.091081] ehci_hcd 0000:00:13.2: supports USB remote wakeup
> [    5.097059] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfeb4d000
> [    5.102937] ehci_hcd 0000:00:13.2: init command 0010005 (park)=0 ithresh=1 period=512 RUN
> [    5.116889] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
> [    5.123004] usb usb2: default language 0x0409
> [    5.127553] usb usb2: udev 1, busnum 2, minor = 128
> [    5.132627] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.139668] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.147164] usb usb2: Product: EHCI Host Controller
> [    5.152236] usb usb2: Manufacturer: Linux 3.7.0-rc3upstream-00220-g37b7153 ehci_hcd
> [    5.160180] usb usb2: SerialNumber: 0000:00:13.2
> [    5.165185] hub 1-0:1.0: state 7 ports 5 chg 0000 evt 0000
> [    5.165547] usb usb2: usb_probe_device
> [    5.165551] usb usb2: configuration #1 chosen from 1 choice
> [    5.165570] usb usb2: adding 2-0:1.0 (config #1, interface 0)
> [    5.165905] hub 2-0:1.0: usb_probe_interface
> [    5.165908] hub 2-0:1.0: usb_probe_interface - got id
> [    5.165911] hub 2-0:1.0: USB hub found
> [    5.165929] hub 2-0:1.0: 5 ports detected
> [    5.165930] hub 2-0:1.0: standalone hub
> [    5.165931] hub 2-0:1.0: no power switching (usb 1.0)
> [    5.165933] hub 2-0:1.0: individual port over-current protection
> [    5.165935] hub 2-0:1.0: power on to power good time: 20ms
> [    5.165942] hub 2-0:1.0: local power source is good
> [    5.166518] hub 2-0:1.0: trying to enable port power on non-switchable hub
> [    5.166966] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.166969] ohci_hcd: block sizes: ed 80 td 96
> [    5.167028] xen: registering gsi 18 triggering 0 polarity 1
> [    5.167033] Already setup the GSI :18
> [    5.167075] ohci_hcd 0000:00:12.0: OHCI Host Controller
> [    5.167260] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
> [    5.167338] ohci_hcd 0000:00:12.0: created debug files
> [    5.167340] ohci_hcd 0000:00:12.0: supports USB remote wakeup
> [    5.167385] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfeb50000
> [    5.289966] hub 2-0:1.0: state 7 ports 5 chg 0000 evt 0000
> [    5.293989] ohci_hcd 0000:00:12.0: OHCI controller state
> [    5.293995] ohci_hcd 0000:00:12.0: OHCI 1.0, NO legacy support registers, rh state running
> [    5.293999] ohci_hcd 0000:00:12.0: control 0x283 RWC HCFS=operational CBSR=3
> [    5.294002] ohci_hcd 0000:00:12.0: cmdstatus 0x00000 SOC=0
> [    5.294006] ohci_hcd 0000:00:12.0: intrstatus 0x00000004 SF
> [    5.294009] ohci_hcd 0000:00:12.0: intrenable 0x8000005a MIE RHSC UE RD WDH
> [    5.294019] ohci_hcd 0000:00:12.0: hcca frame #0005
> [    5.294022] ohci_hcd 0000:00:12.0: roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
> [    5.294025] ohci_hcd 0000:00:12.0: roothub.b 00000000 PPCM=0000 DR=0000
> [    5.294027] ohci_hcd 0000:00:12.0: roothub.status 00008000 DRWE
> [    5.294031] ohci_hcd 0000:00:12.0: roothub.portstatus [0] 0x00000100 PPS
> [    5.294034] ohci_hcd 0000:00:12.0: roothub.portstatus [1] 0x00000100 PPS
> [    5.294037] ohci_hcd 0000:00:12.0: roothub.portstatus [2] 0x00000100 PPS
> [    5.294041] ohci_hcd 0000:00:12.0: roothub.portstatus [3] 0x00000100 PPS
> [    5.294044] ohci_hcd 0000:00:12.0: roothub.portstatus [4] 0x00000100 PPS
> [    5.294080] usb usb3: default language 0x0409
> [    5.294093] usb usb3: udev 1, busnum 3, minor = 256
> [    5.294095] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.294097] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.294098] usb usb3: Product: OHCI Host Controller
> [    5.294100] usb usb3: Manufacturer: Linux 3.7.0-rc3upstream-00220-g37b7153 ohci_hcd
> [    5.294101] usb usb3: SerialNumber: 0000:00:12.0
> [    5.294371] usb usb3: usb_probe_device
> [    5.294374] usb usb3: configuration #1 chosen from 1 choice
> [    5.294386] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [    5.294481] hub 3-0:1.0: usb_probe_interface
> [    5.294482] hub 3-0:1.0: usb_probe_interface - got id
> [    5.294484] hub 3-0:1.0: USB hub found
> [    5.294492] hub 3-0:1.0: 5 ports detected
> [    5.294493] hub 3-0:1.0: standalone hub
> [    5.294495] hub 3-0:1.0: no power switching (usb 1.0)
> [    5.294496] hub 3-0:1.0: no over-current protection
> [    5.294497] hub 3-0:1.0: power on to power good time: 4ms
> [    5.294505] hub 3-0:1.0: local power source is good
> [    5.295074] hub 3-0:1.0: trying to enable port power on non-switchable hub
> [    5.295131] ehci_hcd 0000:00:12.2: HS companion for 0000:00:12.0
> [    5.295174] xen: registering gsi 18 triggering 0 polarity 1
> [    5.295178] Already setup the GSI :18
> [    5.295219] ohci_hcd 0000:00:13.0: OHCI Host Controller
> [    5.295337] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 4
> [    5.295397] ohci_hcd 0000:00:13.0: created debug files
> [    5.295399] ohci_hcd 0000:00:13.0: supports USB remote wakeup
> [    5.295409] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeb4e000
> [    5.549971] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0000
> [    5.553975] ohci_hcd 0000:00:13.0: OHCI controller state
> [    5.553980] ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers, rh state running
> [    5.553984] ohci_hcd 0000:00:13.0: control 0x283 RWC HCFS=operational CBSR=3
> [    5.553987] ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
> [    5.553990] ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
> [    5.553993] ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
> [    5.554004] ohci_hcd 0000:00:13.0: hcca frame #0005
> [    5.554008] ohci_hcd 0000:00:13.0: roothub.a 02001205 POTPGT=2 NOCP NPS NDP=5(5)
> [    5.554011] ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
> [    5.554014] ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
> [    5.554018] ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
> [    5.554021] ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS
> [    5.554025] ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
> [    5.554028] ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000100 PPS
> [    5.554031] ohci_hcd 0000:00:13.0: roothub.portstatus [4] 0x00000100 PPS
> [    5.554051] usb usb4: default language 0x0409
> [    5.554064] usb usb4: udev 1, busnum 4, minor = 384
> [    5.554066] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.554068] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.554070] usb usb4: Product: OHCI Host Controller
> [    5.554071] usb usb4: Manufacturer: Linux 3.7.0-rc3upstream-00220-g37b7153 ohci_hcd
> [    5.554072] usb usb4: SerialNumber: 0000:00:13.0
> [    5.554538] usb usb4: usb_probe_device
> [    5.554542] usb usb4: configuration #1 chosen from 1 choice
> [    5.554559] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [    5.554665] hub 4-0:1.0: usb_probe_interface
> [    5.554667] hub 4-0:1.0: usb_probe_interface - got id
> [    5.554669] hub 4-0:1.0: USB hub found
> [    5.554678] hub 4-0:1.0: 5 ports detected
> [    5.554679] hub 4-0:1.0: standalone hub
> [    5.554681] hub 4-0:1.0: no power switching (usb 1.0)
> [    5.554682] hub 4-0:1.0: no over-current protection
> [    5.554683] hub 4-0:1.0: power on to power good time: 4ms
> [    5.554691] hub 4-0:1.0: local power source is good
> [    5.555283] hub 4-0:1.0: trying to enable port power on non-switchable hub
> [    5.555346] ehci_hcd 0000:00:13.2: HS companion for 0000:00:13.0
> [    5.555389] xen: registering gsi 18 triggering 0 polarity 1
> [    5.555394] Already setup the GSI :18
> [    5.555433] ohci_hcd 0000:00:14.5: OHCI Host Controller
> [    5.555598] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 5
> [    5.555670] ohci_hcd 0000:00:14.5: created debug files
> [    5.555672] ohci_hcd 0000:00:14.5: supports USB remote wakeup
> [    5.555685] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfeb4c000
> [    5.809859] hub 4-0:1.0: state 7 ports 5 chg 0000 evt 0000
> [    5.813841] ohci_hcd 0000:00:14.5: OHCI controller state
> [    5.813847] ohci_hcd 0000:00:14.5: OHCI 1.0, NO legacy support registers, rh state running
> [    5.813851] ohci_hcd 0000:00:14.5: control 0x283 RWC HCFS=operational CBSR=3
> [    5.813854] ohci_hcd 0000:00:14.5: cmdstatus 0x00000 SOC=0
> [    5.813857] ohci_hcd 0000:00:14.5: intrstatus 0x00000004 SF
> [    5.813860] ohci_hcd 0000:00:14.5: intrenable 0x8000005a MIE RHSC UE RD WDH
> [    5.813871] ohci_hcd 0000:00:14.5: hcca frame #0004
> [    5.813874] ohci_hcd 0000:00:14.5: roothub.a 02001202 POTPGT=2 NOCP NPS NDP=2(2)
> [    5.813876] ohci_hcd 0000:00:14.5: roothub.b 00000000 PPCM=0000 DR=0000
> [    5.813880] ohci_hcd 0000:00:14.5: roothub.status 00008000 DRWE
> [    5.813884] ohci_hcd 0000:00:14.5: roothub.portstatus [0] 0x00000100 PPS
> [    5.813886] ohci_hcd 0000:00:14.5: roothub.portstatus [1] 0x00000100 PPS
> [    5.813923] usb usb5: default language 0x0409
> [    5.813935] usb usb5: udev 1, busnum 5, minor = 512
> [    5.813938] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.813939] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.813941] usb usb5: Product: OHCI Host Controller
> [    5.813942] usb usb5: Manufacturer: Linux 3.7.0-rc3upstream-00220-g37b7153 ohci_hcd
> [    5.813944] usb usb5: SerialNumber: 0000:00:14.5
> [    5.814220] usb usb5: usb_probe_device
> [    5.814223] usb usb5: configuration #1 chosen from 1 choice
> [    5.814238] usb usb5: adding 5-0:1.0 (config #1, interface 0)
> [    5.814373] hub 5-0:1.0: usb_probe_interface
> [    5.814375] hub 5-0:1.0: usb_probe_interface - got id
> [    5.814377] hub 5-0:1.0: USB hub found
> [    5.814390] hub 5-0:1.0: 2 ports detected
> [    5.814392] hub 5-0:1.0: standalone hub
> [    5.814393] hub 5-0:1.0: no power switching (usb 1.0)
> [    5.814394] hub 5-0:1.0: no over-current protection
> [    5.814396] hub 5-0:1.0: power on to power good time: 4ms
> [    5.814405] hub 5-0:1.0: local power source is good
> [    5.814425] hub 5-0:1.0: trying to enable port power on non-switchable hub
> [    5.814584] uhci_hcd: USB Universal Host Controller Interface driver
> [    6.009259] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    6.009372] usbcore: registered new interface driver usblp
> [    6.009676] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    6.010397] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    6.010409] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    6.010691] mousedev: PS/2 mouse device common for all mice
> [    6.011327] rtc_cmos 00:05: RTC can wake from S4
> [    6.011618] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    6.011662] rtc0: alarms up to one month, y3k, 114 bytes nvram
> [    6.011868] EFI Variables Facility v0.08 2004-May-17
> [    6.011957] zram: num_devices not specified. Using default: 1
> [    6.011958] zram: Creating 1 devices ...
> [    6.077064] Netfilter messages via NETLINK v0.30.
> [    6.082006] nf_conntrack version 0.5.0 (7194 buckets, 28776 max)
> [    6.088334] ctnetlink v0.93: registering with nfnetlink.
> [    6.094201] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    6.099817] TCP: cubic registered
> [    6.103279] Initializing XFRM netlink socket
> [    6.107873] NET: Registered protocol family 10
> [    6.112784] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    6.119125] sit: IPv6 over IPv4 tunneling driver
> [    6.124870] NET: Registered protocol family 17
> [    6.129593] Key type dns_resolver registered
> [    6.135108] PM: Hibernation image not present or could not be loaded.
> [    6.141853] registered taskstats version 1
> [    6.146837]   Magic number: 0:661:743
> [    6.151899] Freeing unused kernel memory: 752k freed
> [    6.157248] Write protecting the kernel read-only data: 10240k
> [    6.169212] Freeing unused kernel memory: 1768k freed
> [    6.175129] Freeing unused kernel memory: 168k freed
> [    6.188257] consoletype (1257) used greatest stack depth: 5272 bytes left
> [    6.524961] modprobe (1286) used greatest stack depth: 5256 bytes left
> [    6.547403] core_filesystem (1258) used greatest stack depth: 4952 bytes left
> [    6.592358] Initialising Xen virtual ethernet driver.
> [    6.722568] wmi: Mapper loaded
> [    6.796831] xen: registering gsi 17 triggering 0 polarity 1
> [    6.802666] Already setup the GSI :17
> [    6.808260] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
> [    6.814354] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
> [    6.816573] SCSI subsystem initialized
> [    6.824498] e1000e 0000:02:00.0: Disabling ASPM L0s L1
> [    6.824524] xen: registering gsi 16 triggering 0 polarity 1
> [    6.824531] Already setup the GSI :16
> [    6.824740] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    6.859455] [drm] radeon defaulting to kernel modesetting.
> [    6.866428] [drm] radeon kernel modesetting enabled.
> [    6.873121] xen: registering gsi 18 triggering 0 polarity 1
> [    6.873126] Already setup the GSI :18
> [    6.883269] atl1c 0000:03:00.0: version 1.0.1.0-NAPI
> [    6.883447] [drm] initializing kernel modesetting (SUMO 0x1002:0x9640 0x1043:0x84C8).
> [    6.883509] [drm] register mmio base: 0xFEB00000
> [    6.883511] [drm] register mmio size: 262144
> [    6.883646] ATOM BIOS: General
> [    6.883717] radeon 0000:00:01.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
> [    6.883720] radeon 0000:00:01.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
> [    6.883722] [drm] Detected VRAM RAM=512M, BAR=256M
> [    6.883725] [drm] RAM width 32bits DDR
> [    6.884463] [TTM] Zone  kernel: Available graphics memory: 461822 kiB
> [    6.884466] [TTM] Initializing pool allocator
> [    6.884476] [TTM] Initializing DMA pool allocator
> [    6.884529] [drm] radeon: 512M of VRAM memory ready
> [    6.884531] [drm] radeon: 512M of GTT memory ready.
> [    6.884622] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    6.884625] [drm] Driver supports precise vblank timestamp query.
> [    6.884802] radeon 0000:00:01.0: radeon: using MSI.
> [    6.884865] [drm] radeon: irq initialized.
> [    6.884871] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    6.895835] [drm] Loading SUMO Microcode
> [    6.933742] ACPI: bus type scsi registered
> [    6.941860] e1000e 0000:02:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 00:1b:21:ab:c6:12
> [    6.941862] e1000e 0000:02:00.0 eth1: Intel(R) PRO/1000 Network Connection
> [    6.941882] e1000e 0000:02:00.0 eth1: MAC: 3, PHY: 8, PBA No: E46981-005
> [    6.997612] ip (1909) used greatest stack depth: 3896 bytes left
> [    7.048540] libata version 3.00 loaded.
> [    7.144568] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
> [    7.151898] radeon 0000:00:01.0: WB enabled
> [    7.156253] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880023235c00
> [    7.185375] [drm] ring test on 0 succeeded in 1 usecs
> [    7.191817] [drm] ib test on ring 0 succeeded in 0 usecs
> [    7.209657] [drm] Radeon Display Connectors
> [    7.214052] [drm] Connector 0:
> [    7.217253] [drm]   VGA-1
> [    7.220007] [drm]   HPD2
> [    7.222674] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
> [    7.230416] [drm]   Encoders:
> [    7.233539] [drm]     CRT1: INTERNAL_UNIPHY2
> [    7.238001] [drm]     CRT1: NUTMEG
> [    7.238003] [drm] Connector 1:
> [    7.238005] [drm]   HDMI-A-1
> [    7.238006] [drm]   HPD1
> [    7.238009] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
> [    7.238011] [drm]   Encoders:
> [    7.238011] [drm]     DFP1: INTERNAL_UNIPHY2
> [    7.255949] [drm] Internal thermal controller without fan control
> [    7.259955] [drm] radeon: power management initialized
> [    7.335529] No connectors reported connected with modes
> [    7.340968] [drm] Cannot find any crtc or sizes - going 1024x768
> [    7.350906] [drm] fb mappable at 0xD0142000
> [    7.355261] [drm] vram apper at 0xD0000000
> [    7.359523] [drm] size 3145728
> [    7.362716] [drm] fb depth is 24
> [    7.366146] [drm]    pitch is 4096
> [    7.370065] fbcon: radeondrmfb (fb0) is primary device
> [    7.376982] ttyS1: 1 input overrun(s)
> [    7.411210] Console: switching to colour frame buffer device 128x48
> [    7.424071] fb0: radeondrmfb frame buffer device
> [    7.428949] drm: registered panic notifier
> [    7.433284] [drm] Initialized radeon 2.24.0 20080528 for 0000:00:01.0 on minor 0
> [    7.441164] ahci 0000:00:11.0: version 3.0
> [    7.445546] xen: registering gsi 19 triggering 0 polarity 1
> [    7.451464] xen: --> pirq=19 -> irq=19 (gsi=19)
> [    7.456473] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
> [    7.465104] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
> [    7.478140] scsi0 : ahci
> [    7.481629] scsi1 : ahci
> [    7.484929] scsi2 : ahci
> [    7.488287] scsi3 : ahci
> [    7.491496] scsi4 : ahci
> [    7.494907] scsi5 : ahci
> [    7.498649] ata1: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51100 irq 71
> [    7.507585] ata2: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51180 irq 71
> [    7.515392] ata3: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51200 irq 71
> [    7.523177] ata4: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51280 irq 71
> [    7.530982] ata5: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51300 irq 71
> [    7.538786] ata6: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51380 irq 71
> [    7.850775] ata1: SATA link down (SStatus 0 SControl 300)
> [    7.856613] ata2: SATA link down (SStatus 0 SControl 300)
> [    7.862497] ata6: SATA link down (SStatus 0 SControl 300)
> [    7.871228] ata3: SATA link down (SStatus 0 SControl 300)
> [    7.879887] ata5: SATA link down (SStatus 0 SControl 300)
> [    8.038131] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    8.062593] ata4.00: ATA-7: WDC WD800AAJS-18TDA0, 01.00A03, max UDMA/133
> [    8.072417] ata4.00: 156250000 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    8.082336] ata4.00: failed to get Identify Device Data, Emask 0x1
> [    8.092297] ata4.00: failed to get Identify Device Data, Emask 0x1
> [    8.100682] ata4.00: configured for UDMA/133
> [    8.107497] scsi 3:0:0:0: Direct-Access     ATA      WDC WD800AAJS-18 01.0 PQ: 0 ANSI: 5
> [    8.129843] sd 3:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
> [    8.140007] sd 3:0:0:0: [sda] Write Protect is off
> [    8.146945] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    8.154244] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    8.199771]  sda: sda1 sda2 sda3 sda4
> [    8.210772] sd 3:0:0:0: [sda] Attached SCSI disk
> [    8.224663] sd 3:0:0:0: Attached scsi generic sg0 type 0
> [    8.944409] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    8.963120] device eth0 entered promiscuous mode
> [    9.181754] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   10.053518] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
> [   10.064785] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   11.555156] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [   11.566749] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [   13.964892] switch: port 1(eth0) entered forwarding state
> [   13.973524] switch: port 1(eth0) entered forwarding state
> [   16.232334] Loading iSCSI transport class v2.0-870.
> [   16.248793] iscsi: registered transport (tcp)
> [   16.306470] Event-channel device installed.
> [   19.630065] mount.nfs (3143) used greatest stack depth: 3224 bytes left
> [   21.157586] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
> [   21.170420] device-mapper: multipath: version 1.5.0 loaded
> [   21.450531] scsi6 : iSCSI Initiator over TCP/IP
> [   21.731710] scsi 6:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
> [   21.747167] sd 6:0:0:0: [sdb] 503316480 512-byte logical blocks: (257 GB/240 GiB)
> [   21.747211] sd 6:0:0:0: Attached scsi generic sg1 type 0
> [   21.748648] scsi 6:0:0:1: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
> [   21.752968] sd 6:0:0:1: [sdc] 167772160 512-byte logical blocks: (85.8 GB/80.0 GiB)
> [   21.753042] sd 6:0:0:1: Attached scsi generic sg2 type 0
> [   21.755647] sd 6:0:0:1: [sdc] Write Protect is off
> [   21.755655] sd 6:0:0:1: [sdc] Mode Sense: 2f 00 00 00
> [   21.756638] sd 6:0:0:1: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [   21.761219] scsi 6:0:0:2: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
> [   21.770871] sd 6:0:0:2: Attached scsi generic sg3 type 0
> [   21.771168] sd 6:0:0:2: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [   21.775163] ttyS1: 1 input overrun(s)
> [   21.776400] sd 6:0:0:2: [sdd] Write Protect is off
> [   21.776405] sd 6:0:0:2: [sdd] Mode Sense: 2f 00 00 00
> [   21.776884] sd 6:0:0:2: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [   21.780001]  sdd: unknown partition table
> [   21.781272] sd 6:0:0:2: [sdd] Attached SCSI disk
> [   21.804226]  sdc: sdc1 sdc2 < sdc5 >
> [   21.806353] sd 6:0:0:1: [sdc] Attached SCSI disk
> [   21.918632] sd 6:0:0:0: [sdb] Write Protect is off
> [   21.926413] sd 6:0:0:0: [sdb] Mode Sense: 2f 00 00 00
> [   21.935417] sd 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [   21.963859]  sdb: unknown partition table
> [   21.974284] sd 6:0:0:0: [sdb] Attached SCSI disk
> [   28.589544] bio: create slab <bio-1> at 1
> [   28.997728] switch: port 1(eth0) entered forwarding state
> [   57.703132] device vif1.0 entered promiscuous mode
> [   57.715328] IPv6: ADDRCONF(NETDEV_UP): vif1.0: link is not ready
> [   59.760909] IPv6: ADDRCONF(NETDEV_CHANGE): vif1.0: link becomes ready
> [   59.770384] switch: port 2(vif1.0) entered forwarding state
> [   59.778900] switch: port 2(vif1.0) entered forwarding state
> [   59.876529] xen-blkback:ring-ref 10, event-channel 18, protocol 2 (x86_32-abi) persistent grants
> [   65.135453] switch: port 2(vif1.0) entered disabled state
> [   65.145638] device vif1.0 left promiscuous mode
> [   65.154458] switch: port 2(vif1.0) entered disabled state
> [   70.836602] device vif2.0 entered promiscuous mode
> [   70.848191] IPv6: ADDRCONF(NETDEV_UP): vif2.0: link is not ready
> [   72.285945] IPv6: ADDRCONF(NETDEV_CHANGE): vif2.0: link becomes ready
> [   72.295310] switch: port 2(vif2.0) entered forwarding state
> [   72.303597] switch: port 2(vif2.0) entered forwarding state
> [   72.403140] xen-blkback:ring-ref 10, event-channel 11, protocol 1 (x86_64-abi) persistent grants
> [   72.544101] ------------[ cut here ]------------
> [   72.552932] kernel BUG at /home/konrad/linux/drivers/block/xen-blkback/blkback.c:589!
> [   72.563680] invalid opcode: 0000 [#1] SMP
> [   72.570865] Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c sg sd_mod ahci libahci libata radeon e1000e scsi_mod atl1c fbcon ttm tileblit font bitblit softcursor drm_kms_helper wmi xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd [last unloaded: dump_dma]
> [   72.617251] CPU 0
> [   72.619173] Pid: 3823, comm: blkback.2.xvda Tainted: G           O 3.7.0-rc3upstream-00220-g37b7153 #1 System manufacturer System Product Name/F1A75-M
> [   72.641606] RIP: e030:[<ffffffff81409766>]  [<ffffffff81409766>] xen_blkbk_map+0x696/0x6e0
> [   72.653181] RSP: e02b:ffff880027dd3728  EFLAGS: 00010246
> [   72.661651] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [   72.672090] RDX: ffff8800232d7f40 RSI: 0000000000000000 RDI: ffff880027dd3d88
> [   72.682437] RBP: ffff880027dd39e8 R08: 0000000000000000 R09: 0000000000000000
> [   72.692835] R10: 0000000000000001 R11: dead000000200200 R12: 0000000000000000
> [   72.703261] R13: 0000000000000000 R14: ffff88002b5e7070 R15: 0000000000000000
> [   72.713560] FS:  00007f6cc62d5700(0000) GS:ffff88003e000000(0000) knlGS:0000000000000000
> [   72.724921] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   72.733811] CR2: 00000000006dd384 CR3: 0000000027b8f000 CR4: 0000000000000660
> [   72.744131] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   72.754517] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   72.764882] Process blkback.2.xvda (pid: 3823, threadinfo ffff880027dd2000, task ffff88002bb15040)
> [   72.777140] Stack:
> [   72.782184]  ffff880027dd3738 ffff880026081af0 ffff880027dd3798 ffffffff810ac7df
> [   72.792960]  ffff880027dd3798 ffffffff8104c506 0000000000000117 ffff88002160d030
> [   72.803712]  ffff880027dd3a38 ffff88002b5e7120 ffff88002160d000 ffff880027dd3d88
> [   72.814469] Call Trace:
> [   72.820094]  [<ffffffff810ac7df>] ? __queue_work+0xff/0x420
> [   72.829023]  [<ffffffff8104c506>] ? xen_spin_lock_flags+0xb6/0x120
> [   72.838462]  [<ffffffff810acb61>] ? queue_work_on+0x31/0x50
> [   72.847279]  [<ffffffff81636eb9>] ? _raw_spin_unlock_irqrestore+0x19/0x30
> [   72.854408] ttyS1: 2 input overrun(s)
> [   72.864352]  [<ffffffff8107e068>] ? pvclock_clocksource_read+0x58/0xd0
> [   72.874471]  [<ffffffff812ea543>] ? cpumask_next_and+0x23/0x40
> [   72.883656]  [<ffffffff812ea543>] ? cpumask_next_and+0x23/0x40
> [   72.892716]  [<ffffffff810cc5e7>] ? update_sd_lb_stats+0x157/0x6c0
> [   72.902178]  [<ffffffff81636e90>] ? _raw_spin_lock_irq+0x20/0x30
> [   72.911486]  [<ffffffff810cd441>] ? find_busiest_group+0x31/0x4d0
> [   72.920849]  [<ffffffff81409e87>] dispatch_rw_block_io+0x377/0x600
> [   72.930187]  [<ffffffff8107e068>] ? pvclock_clocksource_read+0x58/0xd0
> [   72.939957]  [<ffffffff8103e0c0>] ? xen_mc_flush+0xc0/0x1f0
> [   72.948743]  [<ffffffff8103c9e9>] ? xen_end_context_switch+0x19/0x20
> [   72.958251]  [<ffffffff8107e068>] ? pvclock_clocksource_read+0x58/0xd0
> [   72.967917]  [<ffffffff8107e068>] ? pvclock_clocksource_read+0x58/0xd0
> [   72.977617]  [<ffffffff8107e068>] ? pvclock_clocksource_read+0x58/0xd0
> [   72.987474]  [<ffffffff81044359>] ? xen_clocksource_read+0x39/0x50
> [   72.997278]  [<ffffffff8104c506>] ? xen_spin_lock_flags+0xb6/0x120
> [   73.006476]  [<ffffffff8140a32e>] xen_blkif_schedule+0x21e/0xa00
> [   73.015493]  [<ffffffff81111442>] ? irq_to_desc+0x12/0x20
> [   73.023833]  [<ffffffff81114779>] ? irq_get_irq_data+0x9/0x10
> [   73.032418]  [<ffffffff81382909>] ? info_for_irq+0x9/0x20
> [   73.040554]  [<ffffffff81383cb9>] ? notify_remote_via_irq+0x29/0x50
> [   73.049523]  [<ffffffff810c844d>] ? sched_clock_cpu+0xcd/0x110
> [   73.058024]  [<ffffffff8107e068>] ? pvclock_clocksource_read+0x58/0xd0
> [   73.067191]  [<ffffffff8103e0c0>] ? xen_mc_flush+0xc0/0x1f0
> [   73.075338]  [<ffffffff81635e9e>] ? __schedule+0x3be/0x7c0
> [   73.083311]  [<ffffffff810b52a0>] ? wake_up_bit+0x40/0x40
> [   73.091108]  [<ffffffff8140a110>] ? dispatch_rw_block_io+0x600/0x600
> [   73.099902]  [<ffffffff810b4b16>] kthread+0xc6/0xd0
> [   73.107124]  [<ffffffff8103c9e9>] ? xen_end_context_switch+0x19/0x20
> [   73.115845]  [<ffffffff810b4a50>] ? kthread_freezable_should_stop+0x80/0x80
> [   73.125266]  [<ffffffff8163f1fc>] ret_from_fork+0x7c/0xb0
> [   73.133089]  [<ffffffff810b4a50>] ? kthread_freezable_should_stop+0x80/0x80
> [   73.142576] Code: 48 89 d7 e8 ad 66 d8 ff 4a c7 84 3d 70 ff ff ff 00 00 00 00 4c 8b 85 60 fd ff ff 41 8b b0 e4 fd ff ff 41 83 cd 01 e9 ef fb ff ff <0f> 0b eb fe 48 8d 95 10 ff ff ff 48 8d bd b0 fd ff ff 31 f6 44
> [   73.167611] RIP  [<ffffffff81409766>] xen_blkbk_map+0x696/0x6e0
> [   73.176081]  RSP <ffff880027dd3728>
> [   73.182024] ---[ end trace 914a52d8b62134db ]---
> [   87.339441] switch: port 2(vif2.0) entered forwarding state
> [  315.067569] device tap3.0 entered promiscuous mode
> [  315.074965] switch: port 3(tap3.0) entered forwarding state
> [  315.083116] switch: port 3(tap3.0) entered forwarding state
> [  315.142543] switch: port 3(tap3.0) entered disabled state
> [  315.161150] switch: port 3(tap3.0) entered forwarding state
> [  315.169097] switch: port 3(tap3.0) entered forwarding state
> [  330.162411] switch: port 3(tap3.0) entered forwarding state
> [  415.483626] switch: port 3(tap3.0) entered disabled state
> [  415.491439] device tap3.0 left promiscuous mode
> [  415.498191] switch: port 3(tap3.0) entered disabled state
> [  658.839306] device tap4.0 entered promiscuous mode
> [  658.846451] switch: port 3(tap4.0) entered forwarding state
> [  658.854354] switch: port 3(tap4.0) entered forwarding state
> [  658.923751] switch: port 3(tap4.0) entered disabled state
> [  658.942642] switch: port 3(tap4.0) entered forwarding state
> [  658.950492] switch: port 3(tap4.0) entered forwarding state
> [  673.990219] switch: port 3(tap4.0) entered forwarding state
> [  759.263762] switch: port 3(tap4.0) entered disabled state
> [  759.271529] device tap4.0 left promiscuous mode
> [  759.278257] switch: port 3(tap4.0) entered disabled state
> 

