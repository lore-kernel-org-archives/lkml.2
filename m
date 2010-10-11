Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0JKDyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 23:54:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54013 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0JKDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 23:54:19 -0400
Message-ID: <4CB28988.4090207@kernel.org>
Date: Sun, 10 Oct 2010 20:50:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <4CB00122.3030301@kernel.org> <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6> <4CB014F5.5080209@kernel.org> <alpine.LFD.2.00.1010101130160.2413@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010101130160.2413@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2010 02:32 AM, Thomas Gleixner wrote:
> On Sat, 9 Oct 2010, Yinghai Lu wrote:
>> On 10/08/2010 11:34 PM, Thomas Gleixner wrote:
>>> On Fri, 8 Oct 2010, Yinghai Lu wrote:
>>>> +	/* only handle fall out from setup_IO_APIC_irqs() */
>>>
>>> What's the fallout ? And why are we coming here in the first place
>>> when the irq is < 16 ?
>>
>> setup_IO_APIC_irqs only handle apic_id == 0 or apic_id > 0 but irq < 16 via acpi override.
>>
>> it seems IBM's system have apic_id == 1, and sci irq is using 30.
>>
>> so at that time add that setup_IO_APIC_irq_extra() to workaround it.
>> but it seems we set that two time when irq < 16.
>>
>>>
>>>> +	if (!((apic_id > 0) && (irq > 16)))
>>>> +		return;
> 
> I added this into the queue, but simplified it to 
> 
>   if (apic_id == 0 || irq < NR_IRQS_LEGACY)
> 
> Folded in the other fix and pushed out an updated tree.

still have the irq_2_iommu_alloc warning from pnpacpi

[   79.199117] calling  pnpacpi_init+0x0/0x8c @ 1
[   79.199478] pnp: PnP ACPI init
[   79.218953] ACPI: bus type pnp registered
[   79.219874] pnp 00:00: [bus 00-3f]
[   79.220182] pnp 00:00: [io  0x0000-0x5fff window]
[   79.239384] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[   79.239898] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[   79.258900] pnp 00:00: [mem 0x00000000-0xffffffff window]
[   79.259454] pnp 00:00: [mem 0x90000000-0xafffffff window]
[   79.278769] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[   79.279163] pnp 00:00: [mem 0xfc000000000-0xfc07fffffff window]
[   79.299403] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[   79.299988] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[   79.318841] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[   79.319243] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[   79.339986] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[   79.395515] pnp 00:02: [dma 4]
[   79.395849] pnp 00:02: [io  0x0000-0x000f]
[   79.396152] pnp 00:02: [io  0x0081-0x0083]
[   79.408405] pnp 00:02: [io  0x0087]
[   79.408739] pnp 00:02: [io  0x0089-0x008b]
[   79.409041] pnp 00:02: [io  0x008f]
[   79.428422] pnp 00:02: [io  0x00c0-0x00df]
[   79.429289] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[   79.429927] pnp 00:03: [io  0x0070-0x0071]
[   79.448615] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[   79.468286] ------------[ cut here ]------------
[   79.468664] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xde()
[   79.488347] Hardware name: Sun Fire X4800
[   79.488714] irq_2_iommu!=NULL irq 8
[   79.489046] Modules linked in:
[   79.508267] Pid: 1, comm: swapper Not tainted 2.6.36-rc7-tip-yh-01962-g3229a4e-dirty #9
[   79.508815] Call Trace:
[   79.528192]  [<ffffffff81079001>] warn_slowpath_common+0x85/0x9d
[   79.528670]  [<ffffffff810790bc>] warn_slowpath_fmt+0x46/0x48
[   79.548166]  [<ffffffff8146879c>] irq_2_iommu_alloc+0x52/0xde
[   79.548762]  [<ffffffff81cdfac3>] ? _raw_spin_lock_irqsave+0x6d/0x7b
[   79.568209]  [<ffffffff81468956>] ? alloc_irte+0xa4/0x176
[   79.568621]  [<ffffffff814689d9>] alloc_irte+0x127/0x176
[   79.588232]  [<ffffffff81050d3b>] setup_ioapic_irq+0x13f/0x337
[   79.588783]  [<ffffffff810c4f9f>] ? irq_to_desc+0x17/0x19
[   79.608202]  [<ffffffff810c6df7>] ? irq_get_irq_data+0xe/0x10
[   79.608682]  [<ffffffff81051043>] io_apic_set_pci_routing+0x110/0x121
[   79.628297]  [<ffffffff8104c8c8>] mp_register_gsi+0x19b/0x1ac
[   79.628811]  [<ffffffff8104c955>] acpi_register_gsi+0x4a/0x78
[   79.648259]  [<ffffffff810504d5>] ? acpi_get_override_irq+0x3e/0x13e
[   79.648770]  [<ffffffff814bb7de>] pnpacpi_parse_allocated_irqresource+0xf0/0x127
[   79.668439]  [<ffffffff814bb86f>] pnpacpi_allocated_resource+0x5a/0x2cf
[   79.687979]  [<ffffffff814a8bdb>] ? acpi_ut_remove_reference+0x6a/0x71
[   79.688490]  [<ffffffff814a457d>] ? acpi_rs_get_method_data+0x3b/0x45
[   79.708209]  [<ffffffff814bb815>] ? pnpacpi_allocated_resource+0x0/0x2cf
[   79.708805]  [<ffffffff814a3cc1>] acpi_walk_resources+0x81/0xc9
[   79.728209]  [<ffffffff814bb648>] pnpacpi_parse_allocated_resource+0x5c/0x85
[   79.748009]  [<ffffffff828076c1>] pnpacpi_add_device_handler+0x192/0x215
[   79.748593]  [<ffffffff8149c1c3>] acpi_ns_get_device_callback+0x14a/0x16c
[   79.767968]  [<ffffffff8149f27d>] acpi_ns_walk_namespace+0xbe/0x17d
[   79.768518]  [<ffffffff8149c079>] ? acpi_ns_get_device_callback+0x0/0x16c
[   79.788261]  [<ffffffff8149c062>] acpi_get_devices+0x66/0x7d
[   79.807674]  [<ffffffff8280752f>] ? pnpacpi_add_device_handler+0x0/0x215
[   79.808189]  [<ffffffff8148001e>] ? register_acpi_bus_type+0x70/0x7e
[   79.837937]  [<ffffffff82807412>] ? pnpacpi_init+0x0/0x8c
[   79.838448]  [<ffffffff82807470>] pnpacpi_init+0x5e/0x8c
[   79.857771]  [<ffffffff810001f2>] do_one_initcall+0x57/0x133
[   79.858157]  [<ffffffff827d38ef>] kernel_init+0x167/0x1f1
[   79.878118]  [<ffffffff81034994>] kernel_thread_helper+0x4/0x10
[   79.878614]  [<ffffffff81ce05bc>] ? restore_args+0x0/0x30
[   79.897624]  [<ffffffff827d3788>] ? kernel_init+0x0/0x1f1
[   79.897994]  [<ffffffff81034990>] ? kernel_thread_helper+0x0/0x10
[   79.917614] ---[ end trace 5003353dd8ff0030 ]---
[   79.917963] pnp 00:03: [irq 8]
[   79.918692] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[   79.937833] pnp 00:04: [io  0x00f0-0x00ff]
[   79.938151] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[   79.957809] pnp 00:04: [irq 13]
[   79.958514] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[   79.978078] pnp 00:05: [io  0x0010-0x001f]
[   79.978454] pnp 00:05: [io  0x0022-0x003f]
[   79.997386] pnp 00:05: [io  0x0044-0x005f]
[   79.997690] pnp 00:05: [io  0x0062-0x0063]
[   79.998074] pnp 00:05: [io  0x0065-0x006f]
[   80.017420] pnp 00:05: [io  0x0072-0x007f]
[   80.017750] pnp 00:05: [io  0x0080]
[   80.017988] pnp 00:05: [io  0x0084-0x0086]
[   80.037443] pnp 00:05: [io  0x0088]
[   80.037791] pnp 00:05: [io  0x008c-0x008e]
[   80.057114] pnp 00:05: [io  0x0090-0x009f]
[   80.057498] pnp 00:05: [io  0x00a2-0x00bf]
[   80.057792] pnp 00:05: [io  0x00e0-0x00ef]
[   80.077168] pnp 00:05: [io  0x04d0-0x04d1]
[   80.077454] pnp 00:05: [io  0x0800-0x087f]
[   80.077801] pnp 00:05: [io  0x0000-0xffffffffffffffff disabled]
[   80.097401] pnp 00:05: [io  0x0500-0x057f]
[   80.097733] pnp 00:05: [mem 0xfed1c000-0xfed1ffff]
[   80.117202] pnp 00:05: [mem 0xfed20000-0xfed3ffff]
[   80.117627] pnp 00:05: [mem 0xfed40000-0xfed8ffff]
[   80.138465] pnp 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[   80.139192] pnp 00:06: [mem 0xfed00000-0xfed003ff]
[   80.157924] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   80.158793] pnp 00:07: [io  0x0060]
[   80.177052] pnp 00:07: [io  0x0064]
[   80.177288] pnp 00:07: [mem 0xfec00000-0xfec00fff]
[   80.177676] pnp 00:07: [mem 0xfee00000-0xfee00fff]
[   80.198356] pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[   80.198877] pnp 00:08: [io  0x03f8-0x03ff]
[   80.216890] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[   80.217523] pnp 00:08: [irq 4]
[   80.236833] pnp 00:08: [dma 0 disabled]
[   80.237611] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[   80.256743] pnp 00:09: [io  0x0ca2]
[   80.257080] pnp 00:09: [io  0x0ca6]
[   80.257821] pnp 00:09: Plug and Play ACPI device, IDs IPI0001 (active)
[   80.277222] pnp 00:0a: [mem 0x80000000-0x8fffffff]
[   80.279023] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[   80.297523] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[   80.297893] pnp 00:0b: [mem 0x000c0000-0x000cffff]
[   80.316657] pnp 00:0b: [mem 0x000e0000-0x000fffff]
[   80.317020] pnp 00:0b: [mem 0x00100000-0xffffffff]
[   80.336561] pnp 00:0b: [mem 0xfed90000-0xffffffff]
[   80.337082] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:c4:00.0 BAR 0 [mem 0x00000000-0x000fffff 64bit]
[   80.356938] pnp 00:0b: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:c4:00.0 BAR 0 [mem 0x00000000-0x000fffff 64bit]
[   80.377019] pnp 00:0b: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:c4:00.0 BAR 0 [mem 0x00000000-0x000fffff 64bit]
[   80.397045] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff disabled] because it overlaps 0000:c4:00.0 BAR 2 [mem 0x00000000-0x007fffff 64bit pref]
[   80.417131] pnp 00:0b: disabling [mem 0x000c0000-0x000cffff disabled] because it overlaps 0000:c4:00.0 BAR 2 [mem 0x00000000-0x007fffff 64bit pref]
[   80.456390] pnp 00:0b: disabling [mem 0x000e0000-0x000fffff disabled] because it overlaps 0000:c4:00.0 BAR 2 [mem 0x00000000-0x007fffff 64bit pref]
[   80.476537] pnp 00:0b: disabling [mem 0x00100000-0xffffffff] because it overlaps 0000:c4:00.0 BAR 2 [mem 0x00000000-0x007fffff 64bit pref]
[   80.496584] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff disabled] because it overlaps 0000:c4:00.0 BAR 4 [mem 0x00000000-0x0fffffff 64bit pref]
[   80.516724] pnp 00:0b: disabling [mem 0x000c0000-0x000cffff disabled] because it overlaps 0000:c4:00.0 BAR 4 [mem 0x00000000-0x0fffffff 64bit pref]
[   80.536892] pnp 00:0b: disabling [mem 0x000e0000-0x000fffff disabled] because it overlaps 0000:c4:00.0 BAR 4 [mem 0x00000000-0x0fffffff 64bit pref]
[   80.576556] pnp 00:0b: disabling [mem 0x00100000-0xffffffff disabled] because it overlaps 0000:c4:00.0 BAR 4 [mem 0x00000000-0x0fffffff 64bit pref]
[   80.597519] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[   80.598653] pnp 00:0c: [bus 40-7f]
[   80.616111] pnp 00:0c: [io  0x0000 window]
[   80.616464] pnp 00:0c: [io  0x0000 window]
[   80.616826] pnp 00:0c: [io  0x6000-0x9fff window]
[   80.636240] pnp 00:0c: [mem 0x00000000 window]
[   80.636525] pnp 00:0c: [mem 0x00000000 window]
[   80.655911] pnp 00:0c: [mem 0xb0000000-0xcfffffff window]
[   80.656462] pnp 00:0c: [mem 0x00000000-0xffffffff window]
[   80.675917] pnp 00:0c: [mem 0xfc080000000-0xfc0ffffffff window]
[   80.676936] pnp 00:0c: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[   80.697473] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[   80.698718] pnp 00:0e: [bus 80-bf]
[   80.715901] pnp 00:0e: [io  0x0000 window]
[   80.716215] pnp 00:0e: [io  0x0000 window]
[   80.716604] pnp 00:0e: [io  0xa000-0xdfff window]
[   80.735981] pnp 00:0e: [mem 0x00000000 window]
[   80.736349] pnp 00:0e: [mem 0x00000000 window]
[   80.755714] pnp 00:0e: [mem 0xd0000000-0xefffffff window]
[   80.756197] pnp 00:0e: [mem 0x00000000-0xffffffff window]
[   80.775696] pnp 00:0e: [mem 0xfc100000000-0xfc17fffffff window]
[   80.776768] pnp 00:0e: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[   80.797339] pnp 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[   80.798666] pnp 00:10: [bus c0-f7]
[   80.815710] pnp 00:10: [io  0x0000 window]
[   80.816075] pnp 00:10: [io  0x0000 window]
[   80.816527] pnp 00:10: [io  0xe000-0xffff window]
[   80.835833] pnp 00:10: [mem 0x00000000 window]
[   80.836145] pnp 00:10: [mem 0x00000000 window]
[   80.855581] pnp 00:10: [mem 0xf0000000-0xfbffffff window]
[   80.856100] pnp 00:10: [mem 0x00000000-0xffffffff window]
[   80.875531] pnp 00:10: [mem 0xfc180000000-0xfc1ffffffff window]
[   80.876551] pnp 00:10: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[   80.897293] pnp 00:11: Plug and Play ACPI device, IDs PNP0c01 (active)
[   80.898293] pnp: PnP ACPI: found 18 devices
[   80.915724] ACPI: ACPI bus type pnp unregistered
[   80.916140] initcall pnpacpi_init+0x0/0x8c returned 0 after 1680029 usecs
