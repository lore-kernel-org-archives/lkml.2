Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab0JIEaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 00:30:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47908 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0JIEaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 00:30:13 -0400
Message-ID: <4CAFEEFA.1070000@kernel.org>
Date: Fri, 08 Oct 2010 21:26:34 -0700
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
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 02:54 PM, Thomas Gleixner wrote:
> On Fri, 8 Oct 2010, Thomas Gleixner wrote:
> 
>> On Wed, 6 Oct 2010, Yinghai Lu wrote:
>>> On 10/06/2010 09:01 PM, Thomas Gleixner wrote:
>>>> Well, I'm not too happy about this preallocated stuff anyway, which is
>>>> the reason for the warning below.
>>>>  
>>>>> [   80.726176] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
>>>>> [   80.745935] Hardware name: Sun Fire X4800
>>>>> [   80.746179] irq_2_iommu!=NULL irq 8
>>>>
>>>
>>> no, irq_2_iommu are all dynamically allocated even for irq < 16.
>>
>> I know. I was talking about the preallocated irq descriptors and the
>> handling of it in general.
>>
>> Nevertheless, that irq_2_iommu stuff does not need it's own allocation
>> function. It's bound to a specific irq_cfg anyway, so the next logical
>> step is to move irq_2_iommu into struct irq_cfg and get rid of the
>> extra allocation/free in intr_remapping.c.
> 
> Forgot to say, that I updated the git tree with all the fallout
> fixes.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git master
> 
> Can you please retest ?
> 

one warning and two panics

[   37.369332] ------------[ cut here ]------------
[   37.383782] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
[   37.384463] Hardware name: Sun Fire X4800
[   37.403803] irq_2_iommu!=NULL irq 9
[   37.404054] Modules linked in:
[   37.404311] Pid: 1, comm: swapper Not tainted 2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171
[   37.424042] Call Trace:
[   37.424205]  [<ffffffff810787a0>] warn_slowpath_common+0x85/0x9d
[   37.443822]  [<ffffffff8107885b>] warn_slowpath_fmt+0x46/0x48
[   37.444383]  [<ffffffff8141c5f6>] ? radix_tree_lookup+0xb/0xd
[   37.463788]  [<ffffffff8145f97c>] irq_2_iommu_alloc+0x52/0xdc
[   37.464200]  [<ffffffff81ccc593>] ? _raw_spin_lock_irqsave+0x6d/0x7b
[   37.483853]  [<ffffffff8145fb4d>] ? alloc_irte+0x97/0x168
[   37.484296]  [<ffffffff8145fbce>] alloc_irte+0x118/0x168
[   37.503774]  [<ffffffff8105062a>] setup_ioapic_irq+0x13f/0x331
[   37.504278]  [<ffffffff81051d70>] setup_IO_APIC_irq_extra+0xce/0xde
[   37.523868]  [<ffffffff8104c678>] acpi_gsi_to_irq+0x2a/0x31
[   37.524475]  [<ffffffff814867c8>] ? acpi_ev_sci_xrupt_handler+0x0/0x2b
[   37.543942]  [<ffffffff81475056>] acpi_os_install_interrupt_handler+0x31/0xa5
[   37.563764]  [<ffffffff81486826>] acpi_ev_install_sci_handler+0x23/0x25
[   37.564309]  [<ffffffff81485b41>] acpi_ev_install_xrupt_handlers+0x13/0x5f
[   37.583694]  [<ffffffff8149fba1>] acpi_enable_subsystem+0x13a/0x145
[   37.584429]  [<ffffffff827f0c75>] ? acpi_init+0x0/0x1a2
[   37.603653]  [<ffffffff827f0a13>] acpi_bus_init+0x26/0x288
[   37.604032]  [<ffffffff81cc920f>] ? printk+0x41/0x43
[   37.623668]  [<ffffffff827f0cf4>] acpi_init+0x7f/0x1a2
[   37.624130]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
[   37.643480]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
[   37.643871]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   37.663541]  [<ffffffff81ccd07c>] ? restore_args+0x0/0x30
[   37.663951]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
[   37.683515]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10
[   37.684143] ---[ end trace 5003353dd8ff0030 ]---


[   59.429741] BUG: unable to handle kernel NULL pointer dereference at (null)
[   59.449366] IP: [<ffffffff8147d715>] acpi_pci_irq_find_prt_entry+0x85/0xb1
[   59.469016] PGD 0 
[   59.469224] Oops: 0000 [#1] SMP 
[   59.469488] last sysfs file: 
[   59.469725] CPU 0 
[   59.488959] Modules linked in:
[   59.489246] 
[   59.489361] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171      /Sun Fire X4800
[   59.509192] RIP: 0010:[<ffffffff8147d715>]  [<ffffffff8147d715>] acpi_pci_irq_find_prt_entry+0x85/0xb1
[   59.529156] RSP: 0018:ffff88385e455d70  EFLAGS: 00010206
[   59.529481] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88305e460000
[   59.549153] RDX: 0000000000000000 RSI: ffffffff8147d6d7 RDI: ffff88305e460000
[   59.568832] RBP: ffff88385e455da0 R08: 0000000000000001 R09: 000000000000025a
[   59.569424] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[   59.589507] R13: 0000000000000084 R14: 0000000000000000 R15: 0000000000000001
[   59.608643] FS:  0000000000000000(0000) GS:ffff880079c00000(0000) knlGS:0000000000000000
[   59.609242] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   59.628759] CR2: 0000000000000000 CR3: 0000000002466000 CR4: 00000000000006f0
[   59.629316] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.648990] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   59.668728] Process swapper (pid: 1, threadinfo ffff88385e454000, task ffff88305e460000)
[   59.669392] Stack:
[   59.688540]  ffff88385e455d90 ffff88085e93c000 ffffffff82808301 0000000000000000
[   59.689144] <0> ffff88085e93c000 0000000000000001 ffff88385e455e10 ffffffff8147d766
[   59.708944] <0> ffff88385e455dd0 0000000000000002 ffff88385e6a4700 ffffea00c54a73e0
[   59.728590] Call Trace:
[   59.728829]  [<ffffffff82808301>] ? pci_acpi_init+0x2e/0x89
[   59.729292]  [<ffffffff8147d766>] acpi_pci_irq_lookup+0x25/0x1c3
[   59.748704]  [<ffffffff82808301>] ? pci_acpi_init+0x2e/0x89
[   59.749313]  [<ffffffff8147dd74>] acpi_pci_irq_enable+0x98/0x246
[   59.768827]  [<ffffffff828083a7>] ? pci_subsys_init+0x0/0x4d
[   59.769353]  [<ffffffff828083a7>] ? pci_subsys_init+0x0/0x4d
[   59.788753]  [<ffffffff82808341>] pci_acpi_init+0x6e/0x89
[   59.789250]  [<ffffffff828083b6>] pci_subsys_init+0xf/0x4d
[   59.808714]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
[   59.828222]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
[   59.828677]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   59.848214]  [<ffffffff81ccd07c>] ? restore_args+0x0/0x30
[   59.848709]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
[   59.868134]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10
[   59.868525] Code: b7 53 12 41 39 d5 75 20 0f b7 53 14 41 39 d4 75 17 0f b6 53 18 41 39 d7 75 0e 48 c7 c7 80 89 4a 82 e8 08 f6 84 00 eb 20 48 89 c3 <48> 8b 03 48 81 fb c0 89 4a 82 0f 18 08 75 bc 48 c7 c7 80 89 4a 
[   59.908388] RIP  [<ffffffff8147d715>] acpi_pci_irq_find_prt_entry+0x85/0xb1
[   59.908973]  RSP <ffff88385e455d70>
[   59.928176] CR2: 0000000000000000
[   59.928496] ---[ end trace 5003353dd8ff0031 ]---
[   59.928831] Kernel panic - not syncing: Attempted to kill init!
[   59.948349] Pid: 1, comm: swapper Tainted: G      D W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171
[   59.968151] Call Trace:
[   59.968346]  [<ffffffff81cc90be>] panic+0x91/0x1a1
[   59.968787]  [<ffffffff81ccc63a>] ? _raw_write_unlock_irq+0x30/0x35
[   59.988375]  [<ffffffff8107bbb2>] ? do_exit+0x2d8/0x6cb
[   59.988861]  [<ffffffff8107b94c>] do_exit+0x72/0x6cb
[   60.008172]  [<ffffffff81079e0d>] ? kmsg_dump+0x13b/0x156
[   60.008525]  [<ffffffff81ccdece>] oops_end+0xb7/0xbf
[   60.028120]  [<ffffffff8105b056>] no_context+0x1fc/0x20b
[   60.028555]  [<ffffffff8105b1f7>] __bad_area_nosemaphore+0x192/0x1b5
[   60.048409]  [<ffffffff81ccff3b>] ? do_page_fault+0x12d/0x3f1
[   60.048996]  [<ffffffff8105b22d>] bad_area_nosemaphore+0x13/0x15
[   60.068128]  [<ffffffff81cd0005>] do_page_fault+0x1f7/0x3f1
[   60.068695]  [<ffffffff810a8162>] ? __lock_acquire+0x17cf/0x17e1
[   60.088165]  [<ffffffff810a8162>] ? __lock_acquire+0x17cf/0x17e1
[   60.107677]  [<ffffffff81ccd443>] ? error_sti+0x5/0x6
[   60.108081]  [<ffffffff81ccc1b7>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   60.127699]  [<ffffffff81ccd25f>] page_fault+0x1f/0x30
[   60.128081]  [<ffffffff8147d6d7>] ? acpi_pci_irq_find_prt_entry+0x47/0xb1
[   60.147705]  [<ffffffff8147d715>] ? acpi_pci_irq_find_prt_entry+0x85/0xb1
[   60.148453]  [<ffffffff82808301>] ? pci_acpi_init+0x2e/0x89
[   60.167787]  [<ffffffff8147d766>] acpi_pci_irq_lookup+0x25/0x1c3
[   60.168313]  [<ffffffff82808301>] ? pci_acpi_init+0x2e/0x89
[   60.187769]  [<ffffffff8147dd74>] acpi_pci_irq_enable+0x98/0x246
[   60.188167]  [<ffffffff828083a7>] ? pci_subsys_init+0x0/0x4d
[   60.207818]  [<ffffffff828083a7>] ? pci_subsys_init+0x0/0x4d
[   60.208205]  [<ffffffff82808341>] pci_acpi_init+0x6e/0x89
[   60.227805]  [<ffffffff828083b6>] pci_subsys_init+0xf/0x4d
[   60.228250]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
[   60.247819]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
[   60.248195]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   60.267709]  [<ffffffff81ccd07c>] ? restore_args+0x0/0x30
[   60.268206]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
[   60.287632]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10

[   70.976633] ACPI: acpi_idle registered with cpuidle
[   70.978833] Monitor-Mwait will be used to enter C-1 state
[   70.996684] Monitor-Mwait will be used to enter C-3 state
[   71.037469] BUG: unable to handle kernel NULL pointer dereference at (null)
[   71.038065] IP: [<ffffffff8141e232>] strcmp+0x4/0x21
[   71.056510] PGD 0 
[   71.056743] Oops: 0000 [#1] SMP 
[   71.056994] last sysfs file: 
[   71.057194] CPU 49 
[   71.057317] Modules linked in:
[   71.076724] 
[   71.076886] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171      /Sun Fire x4800
[   71.096947] RIP: 0010:[<ffffffff8141e232>]  [<ffffffff8141e232>] strcmp+0x4/0x21
[   71.116524] RSP: 0018:ffff8810794c3c00  EFLAGS: 00010246
[   71.117021] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[   71.136567] RDX: ffff88285b6b6064 RSI: ffff88285b6b6020 RDI: 0000000000000000
[   71.137218] RBP: ffff8810794c3c00 R08: ffffffff82491388 R09: ffff883000000000
[   71.156848] R10: 0000000000000000 R11: 0000000000000003 R12: ffff88285b7b7000
[   71.176524] R13: ffff88285b6b6020 R14: 00000000ffffffef R15: 0000000000000001
[   71.177081] FS:  0000000000000000(0000) GS:ffff88287f000000(0000) knlGS:0000000000000000
[   71.196812] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   71.216423] CR2: 0000000000000000 CR3: 0000000002466000 CR4: 00000000000006e0
[   71.216993] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   71.236653] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   71.237309] Process swapper (pid: 1, threadinfo ffff8810794c2000, task ffff88305b4a8000)
[   71.256941] Stack:
[   71.257101]  ffff8810794c3c30 ffffffff81187d7c ffff8810794c3ca0 ffff881078bfda50
[   71.276856] <0> ffff88103e8b0870 ffff8810794c3ce0 ffff8810794c3c60 ffffffff81187f2f
[   71.296598] <0> ffff88103e8b0870 ffff88103eab7d00 ffff88103e8b0870 ffff8810794c3ce0
[   71.297227] Call Trace:
[   71.316487]  [<ffffffff81187d7c>] sysfs_find_dirent+0x3f/0x59
[   71.316961]  [<ffffffff81187f2f>] __sysfs_add_one+0x2f/0x91
[   71.336455]  [<ffffffff81187fb2>] sysfs_add_one+0x21/0xf6
[   71.336871]  [<ffffffff81188804>] sysfs_do_create_link+0x108/0x1a5
[   71.356562]  [<ffffffff81cccccc>] ? _raw_spin_unlock_irq+0x30/0x36
[   71.357077]  [<ffffffff811888b4>] sysfs_create_link+0x13/0x15
[   71.376588]  [<ffffffff815098f6>] driver_sysfs_add+0x70/0x95
[   71.377087]  [<ffffffff81509b6f>] driver_probe_device+0x6e/0x151
[   71.396602]  [<ffffffff81509cb3>] __driver_attach+0x61/0x85
[   71.397034]  [<ffffffff81509c52>] ? __driver_attach+0x0/0x85
[   71.416639]  [<ffffffff81508d5f>] bus_for_each_dev+0x5c/0x88
[   71.417058]  [<ffffffff81509884>] driver_attach+0x1e/0x20
[   71.436737]  [<ffffffff815094bd>] bus_add_driver+0xfd/0x254
[   71.437164]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   71.456732]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   71.457236]  [<ffffffff81509f31>] driver_register+0x9b/0x108
[   71.476676]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   71.496278]  [<ffffffff81479b71>] acpi_bus_register_driver+0x43/0x46
[   71.496728]  [<ffffffff827f209b>] acpi_processor_init+0x93/0x10b
[   71.516373]  [<ffffffff8109c5a2>] ? ktime_get+0x65/0xbf
[   71.516814]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   71.536413]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
[   71.536865]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
[   71.556395]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   71.556900]  [<ffffffff81ccd07c>] ? restore_args+0x0/0x30
[   71.576432]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
[   71.576874]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10
[   71.596481] Code: 48 ff c1 80 39 00 75 f8 eb 0d 48 ff c1 48 ff ca 75 05 c6 01 00 eb 0e 40 8a 3e 48 ff c6 40 84 ff 40 88 39 75 e5 c9 c3 55 48 89 e5 <8a> 07 8a 16 48 ff c7 48 ff c6 38 d0 74 07 19 c0 83 c8 01 eb 06 
[   71.617378] RIP  [<ffffffff8141e232>] strcmp+0x4/0x21
[   71.636558]  RSP <ffff8810794c3c00>
[   71.636814] CR2: 0000000000000000
[   71.656246] ---[ end trace b7b9396a6ed2edd4 ]---
[   71.656712] Kernel panic - not syncing: Attempted to kill init!
[   71.657202] Pid: 1, comm: swapper Tainted: G      D W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171
[   71.676846] Call Trace:
[   71.696196]  [<ffffffff81cc90be>] panic+0x91/0x1a1
[   71.696532]  [<ffffffff81ccc63a>] ? _raw_write_unlock_irq+0x30/0x35
[   71.716196]  [<ffffffff8107bbb2>] ? do_exit+0x2d8/0x6cb
[   71.716710]  [<ffffffff8107b94c>] do_exit+0x72/0x6cb
[   71.717104]  [<ffffffff81079e0d>] ? kmsg_dump+0x13b/0x156
[   71.736627]  [<ffffffff81ccdece>] oops_end+0xb7/0xbf
[   71.737111]  [<ffffffff8105b056>] no_context+0x1fc/0x20b
[   71.756467]  [<ffffffff810a8162>] ? __lock_acquire+0x17cf/0x17e1
[   71.756999]  [<ffffffff8105b1f7>] __bad_area_nosemaphore+0x192/0x1b5
[   71.776547]  [<ffffffff81ccff3b>] ? do_page_fault+0x12d/0x3f1
[   71.776908]  [<ffffffff8105b22d>] bad_area_nosemaphore+0x13/0x15
[   71.796652]  [<ffffffff81cd0005>] do_page_fault+0x1f7/0x3f1
[   71.816151]  [<ffffffff81ccd443>] ? error_sti+0x5/0x6
[   71.816516]  [<ffffffff81ccc1b7>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   71.836242]  [<ffffffff81ccd25f>] page_fault+0x1f/0x30
[   71.836680]  [<ffffffff8141e232>] ? strcmp+0x4/0x21
[   71.837084]  [<ffffffff81187d7c>] sysfs_find_dirent+0x3f/0x59
[   71.856665]  [<ffffffff81187f2f>] __sysfs_add_one+0x2f/0x91
[   71.876096]  [<ffffffff81187fb2>] sysfs_add_one+0x21/0xf6
[   71.876533]  [<ffffffff81188804>] sysfs_do_create_link+0x108/0x1a5
[   71.896120]  [<ffffffff81cccccc>] ? _raw_spin_unlock_irq+0x30/0x36
[   71.896653]  [<ffffffff811888b4>] sysfs_create_link+0x13/0x15
[   71.916203]  [<ffffffff815098f6>] driver_sysfs_add+0x70/0x95
[   71.916754]  [<ffffffff81509b6f>] driver_probe_device+0x6e/0x151
[   71.936229]  [<ffffffff81509cb3>] __driver_attach+0x61/0x85
[   71.936711]  [<ffffffff81509c52>] ? __driver_attach+0x0/0x85
[   71.956235]  [<ffffffff81508d5f>] bus_for_each_dev+0x5c/0x88
[   71.956729]  [<ffffffff81509884>] driver_attach+0x1e/0x20
[   71.976295]  [<ffffffff815094bd>] bus_add_driver+0xfd/0x254
[   71.976802]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   71.996309]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   71.996810]  [<ffffffff81509f31>] driver_register+0x9b/0x108
[   72.016264]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   72.016670]  [<ffffffff81479b71>] acpi_bus_register_driver+0x43/0x46
[   72.036455]  [<ffffffff827f209b>] acpi_processor_init+0x93/0x10b
[   72.056001]  [<ffffffff8109c5a2>] ? ktime_get+0x65/0xbf
[   72.056441]  [<ffffffff827f2008>] ? acpi_processor_init+0x0/0x10b
[   72.076026]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
[   72.076567]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
[   72.096004]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   72.096503]  [<ffffffff81ccd07c>] ? restore_args+0x0/0x30
[   72.116022]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
[   72.116472]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10



