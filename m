Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab0JGASE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:18:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52418 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0JGASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:18:03 -0400
Message-ID: <4CAD1154.3080403@kernel.org>
Date: Wed, 06 Oct 2010 17:16:20 -0700
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
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org>
In-Reply-To: <4CAD082B.40908@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 04:37 PM, Yinghai Lu wrote:
> On 10/06/2010 03:52 PM, Thomas Gleixner wrote:
>> On Wed, 6 Oct 2010, Yinghai Lu wrote:
>>
>>> On 10/05/2010 03:22 AM, Thomas Gleixner wrote:
>>>> On Sun, 3 Oct 2010, Thomas Gleixner wrote:
>>>>> On Sun, 3 Oct 2010, Grant Likely wrote:
>>>>>> Okay, patch 14 looks good to me too (including Yinghai's comment).
>>>>>> The new allocator seems sane, and I didn't see any obvious errors in
>>>>>> patches 16-47.  I've not tested any of this yet.  Hopefully I'll be
>>>>>> able to carve out some time to do so early this week.
>>>>>
>>>>> Wait until I pushed out a fixed tree. In meantime I found out how I
>>>>> managed to screw up the quilt series :(
>>>>>
>>>>> Will post, once it's ready.
>>>>
>>>> Pushed out an updated tree to
>>>>
>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git master
>>>>
>>>
>>> test it together with tip, it seems all io apic routing is not set rightly. MSI is ok...
>>>
>>> [  200.290040] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
>>> [  200.290991] ehci_hcd 0000:00:1d.7: setting latency timer to 64
>>> [  200.310002] ehci_hcd 0000:00:1d.7: EHCI Host Controller
>>> [  200.310455] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
>>> [  200.330127] ehci_hcd 0000:00:1d.7: debug port 1
>>> [  200.334395] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
>>> [  200.350042] ehci_hcd 0000:00:1d.7: request interrupt 23 failed
>>> [  200.350491] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
>>> [  200.372257] ehci_hcd 0000:00:1d.7: PCI INT A disabled
>>> [  200.372644] ehci_hcd 0000:00:1d.7: init 0000:00:1d.7 fail, -38
>>> [  200.389916] ehci_hcd: probe of 0000:00:1d.7 failed with error -38
>>
>> Yep. Ingo's testing found that already. Does the patch below fix it ?
>>
>> Thanks,
>>
>> 	tglx
>> ---
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 2f171df..eb3d01d 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -252,11 +252,15 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
>>  static struct irq_cfg *get_irq_cfg_at(unsigned int at, int node)
>>  {
>>  	int res = irq_alloc_desc_at(at, node);
>> +	struct irq_data *data;
>>  
>>  	if (res < 0 && res != -EEXIST)
>>  		return NULL;
>>  
>> -	return get_irq_chip_data(at);
>> +	data = irq_get_irq_data(at);
>> +	if (res >= 0 && !data->chip_data)
>> +		data->chip_data = alloc_irq_cfg(at, node);
>> +	return data->chip_data;
>>  }
>>  
>>  static int alloc_irq_from(unsigned int from, int node)
> 
> yes, it fixes the problem.
> 
> but can you merge get_irq_cfg_at() and alloc_irq_and_cfg_at() ? 
> it's confusing to let get_...() to do the alloc work.

more:

[   80.725830] ------------[ cut here ]------------
[   80.726176] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
[   80.745935] Hardware name: Sun Fire X4800
[   80.746179] irq_2_iommu!=NULL irq 8
[   80.746460] Modules linked in:
[   80.765852] Pid: 1, comm: swapper Not tainted 2.6.36-rc7-tip-yh-01782-g0d439ac-dirty #161
[   80.766500] Call Trace:
[   80.786032]  [<ffffffff810787a0>] warn_slowpath_common+0x85/0x9d
[   80.786503]  [<ffffffff8107885b>] warn_slowpath_fmt+0x46/0x48
[   80.805801]  [<ffffffff8141c5f2>] ? radix_tree_lookup+0xb/0xd
[   80.806304]  [<ffffffff8145f97c>] irq_2_iommu_alloc+0x52/0xdc
[   80.825786]  [<ffffffff81ccb2cb>] ? _raw_spin_lock_irqsave+0x6d/0x7b
[   80.826291]  [<ffffffff8145fb4d>] ? alloc_irte+0x97/0x168
[   80.845811]  [<ffffffff8145fbce>] alloc_irte+0x118/0x168
[   80.846200]  [<ffffffff810505ec>] setup_ioapic_irq+0x137/0x330
[   80.865804]  [<ffffffff810c3e73>] ? irq_to_desc+0x17/0x19
[   80.866236]  [<ffffffff810c5bcd>] ? irq_get_irq_data+0xe/0x10
[   80.885735]  [<ffffffff81051b42>] io_apic_set_pci_routing+0x119/0x12b
[   80.886229]  [<ffffffff810a5984>] ? debug_check_no_locks_freed+0x113/0x129
[   80.905778]  [<ffffffff8104c800>] mp_register_gsi+0x180/0x191
[   80.906225]  [<ffffffff815060c9>] ? dev_printk+0x45/0x47
[   80.925725]  [<ffffffff8104c85e>] acpi_register_gsi+0x4d/0x5b
[   80.926182]  [<ffffffff814b2d45>] pnpacpi_parse_allocated_irqresource+0xd0/0x107
[   80.945838]  [<ffffffff814b2dd9>] pnpacpi_allocated_resource+0x5d/0x2df
[   80.965584]  [<ffffffff8149c5cf>] ? acpi_rs_get_method_data+0x3b/0x45
[   80.966058]  [<ffffffff814b2d7c>] ? pnpacpi_allocated_resource+0x0/0x2df
[   80.985665]  [<ffffffff8149bc2e>] acpi_walk_resources+0x82/0xd3
[   80.986091]  [<ffffffff814b30ba>] pnpacpi_parse_allocated_resource+0x5f/0x87
[   81.005805]  [<ffffffff827f2e93>] pnpacpi_add_device_handler+0x199/0x220
[   81.025459]  [<ffffffff81494187>] acpi_ns_get_device_callback+0x14a/0x174
[   81.025960]  [<ffffffff81497237>] acpi_ns_walk_namespace+0xc0/0x181
[   81.045481]  [<ffffffff8149403d>] ? acpi_ns_get_device_callback+0x0/0x174
[   81.046027]  [<ffffffff81494026>] acpi_get_devices+0x66/0x7d
[   81.065529]  [<ffffffff827f2cfa>] ? pnpacpi_add_device_handler+0x0/0x220
[   81.085206]  [<ffffffff81477ef0>] ? register_acpi_bus_type+0x75/0x7b
[   81.085667]  [<ffffffff827f2bdd>] ? pnpacpi_init+0x0/0x8c
[   81.105175]  [<ffffffff827f2c3b>] pnpacpi_init+0x5e/0x8c
[   81.105587]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
[   81.125214]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
[   81.125633]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   81.145165]  [<ffffffff81ccbdbc>] ? restore_args+0x0/0x30
[   81.145568]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
[   81.165084]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10
[   81.165646] ---[ end trace 5003353dd8ff0030 ]---

