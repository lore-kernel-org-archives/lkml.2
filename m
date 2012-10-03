Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2JCOWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:22:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25420 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab2JCOWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:22:52 -0400
Date: Wed, 3 Oct 2012 10:11:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: point xen_start_info to a dummy struct
 for PV on HVM guests
Message-ID: <20121003141116.GA10633@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
 <1349272182.650.150.camel@zakaz.uk.xensource.com>
 <alpine.DEB.2.02.1210031450220.29232@kaball.uk.xensource.com>
 <1349272482.650.151.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349272482.650.151.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 02:54:42PM +0100, Ian Campbell wrote:
> On Wed, 2012-10-03 at 14:51 +0100, Stefano Stabellini wrote:
> > On Wed, 3 Oct 2012, Ian Campbell wrote:
> > > On Wed, 2012-10-03 at 14:37 +0100, Stefano Stabellini wrote:
> > > > PV on HVM guests don't have a start_info page mapped by Xen, so
> > > > xen_start_info is just NULL for them.
> > > > That is problem because other parts of the code expect xen_start_info to
> > > > point to something valid, for example xen_initial_domain() is defined as
> > > > follow:
> > > > 
> > > > #define xen_initial_domain()    (xen_domain() && \
> > > >                  xen_start_info->flags & SIF_INITDOMAIN)
> > > 
> > > But anyone who calls this before xen_start_info is setup is going to get
> > > a bogus result, specifically in this case they will think they are domU
> > > when in reality they are dom0 -- wouldn't it be better to fix those
> > > callsites?
> > 
> > That cannot be the case because setting up xen_start_info is the very
> > first thing that is done, before even calling to C.
> 
> On PV, yes, but you are trying to fix PVHVM here, no?
> 
> Otherwise if this is always set before calling into C then what is the
> purpose of this patch?

to fix this - as PVHVM has it set to NULL and we end up de-referencing
the xen_start_info and crashing. As so::


Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0upstream-04121-g0313983 (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Tue Oct 2 16:31:21 EDT 2012
[    0.000000] Command line: initrd=initramf.gz  console=ttyS0,115200 test=net nofb earlyprintk=serial,ttyS0,115200 BOOT_IMAGE=vmlinuz 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000ffffffff] reserved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] Hypervisor detected: Xen HVM
[    0.000000] Xen version 4.1.
[    0.000000] Netfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated NICs.
[    0.000000] Blkfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated disks.
[    0.000000] You might have to change the root device
[    0.000000] from /dev/hd[a-d] to /dev/xvd[a-d]
[    0.000000] in your root= kernel command line option
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x80000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fbc90-0x000fbc9f] mapped at [ffff8800000fbc90]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x7fffffff]
[    0.000000] RAMDISK: [mem 0x7abeb000-0x7ffdefff]
[    0.000000] ACPI: RSDP 00000000000ea020 00024 (v02    Xen)
[    0.000000] ACPI: XSDT 00000000fc00f2b0 00034 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: FACP 00000000fc00f0d0 000F4 (v04    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: DSDT 00000000fc003440 0BC09 (v02    Xen      HVM 00000000 INTL 20100528)
[    0.000000] ACPI: FACS 00000000fc003400 00040
[    0.000000] ACPI: APIC 00000000fc00f1d0 000D8 (v02    Xen      HVM 00000000 HVML 00000000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffffff]
[    0.000000]   NODE_DATA [mem 0x7fffc000-0x7fffffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7fffffff]
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x1c] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 15 CPUs, 13 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0x80000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen HVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:15 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007a800000 s84352 r8192 d22144 u131072
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 517000
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: initrd=initramf.gz  console=ttyS0,115200 test=net nofb earlyprintk=serial,ttyS0,115200 BOOT_IMAGE=vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1967336k/2097152k available (6368k kernel code, 456k absent, 129360k reserved, 4525k data, 752k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=15.
[    0.000000] NR_IRQS:33024 nr_irqs:1208 16
[    0.000000] Xen HVM callback vector for event delivery is enabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[    0.000000] IP: [<ffffffff813ab3be>] xen_cons_init+0x1e/0x60
[    0.000000] PGD 0 
[    0.000000] Oops: 0000 [#1] SMP 
[    0.000000] Modules linked in:
[    0.000000] CPU 0 
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.6.0upstream-04121-g0313983 #1 Xen HVM domU
[    0.000000] RIP: 0010:[<ffffffff813ab3be>]  [<ffffffff813ab3be>] xen_cons_init+0x1e/0x60
[    0.000000] RSP: 0000:ffffffff81a01ef8  EFLAGS: 00010202
[    0.000000] RAX: 0000000000000000 RBX: ffffffff81b3be60 RCX: 0000000000000002
[    0.000000] RDX: ffffffff81a59c40 RSI: ffffffff81a59b01 RDI: ffffffff81ba7e81
[    0.000000] RBP: ffffffff81a01ef8 R08: 00000000000003fd R09: 0000000000000020
[    0.000000] R10: 0000000000000000 R11: 000000000000000d R12: ffffffff81b008e0
[    0.000000] R13: ffffffff81b092e0 R14: 0000000000000000 R15: 0000000000026bf0
[    0.000000] FS:  0000000000000000(0000) GS:ffff88007a800000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.000000] CR2: 0000000000000030 CR3: 0000000001a0b000 CR4: 00000000000006b0
[    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.000000] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a13420)
[    0.000000] Stack:
[    0.000000]  ffffffff81a01f18 ffffffff81aeb9fb ffffffff81b008e0 ffffffffffffffff
[    0.000000]  ffffffff81a01f68 ffffffff81abac39 ffffffff81aba80d 0000000000026bf0
[    0.000000]  ffffffff81a01f58 ffffffff81b092e0 0000000001000000 0000000001c72000
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81aeb9fb>] console_init+0x19/0x2a
[    0.000000]  [<ffffffff81abac39>] start_kernel+0x24a/0x3a3
[    0.000000]  [<ffffffff81aba80d>] ? kernel_init+0x1e8/0x1e8
[    0.000000]  [<ffffffff81aba356>] x86_64_start_reservations+0x131/0x136
[    0.000000]  [<ffffffff81aba45e>] x86_64_start_kernel+0x103/0x112
[    0.000000] Code: 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 8b 0d 5a 2e 7c 00 55 31 c0 48 89 e5 85 c9 74 37 48 8b 05 51 2e 7c 00 48 c7 c2 40 9c a5 81 <f6> 40 30 02 75 15 83 f9 02 74 27 e8 52 fc ff ff 85 c0 78 15 48 
[    0.000000] RIP  [<ffffffff813ab3be>] xen_cons_init+0x1e/0x60
[    0.000000]  RSP <ffffffff81a01ef8>
[    0.000000] CR2: 0000000000000030
[    0.000000] ---[ end trace 5cb378039a20e088 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> 
> > 
> > 
> > > Perhaps turn this into a static inline with a BUG_ON(!xen_start_info) to
> > > make catching these cases easier?
> > 
> 
