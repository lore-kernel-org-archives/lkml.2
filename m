Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0JIFp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 01:45:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28749 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0JIFp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 01:45:56 -0400
Message-ID: <4CB00122.3030301@kernel.org>
Date: Fri, 08 Oct 2010 22:44:02 -0700
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
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org>
In-Reply-To: <4CAFEEFA.1070000@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 09:26 PM, Yinghai Lu wrote:
> On 10/08/2010 02:54 PM, Thomas Gleixner wrote:
>> On Fri, 8 Oct 2010, Thomas Gleixner wrote:
>>
>>> On Wed, 6 Oct 2010, Yinghai Lu wrote:
>>>> On 10/06/2010 09:01 PM, Thomas Gleixner wrote:
>>>>> Well, I'm not too happy about this preallocated stuff anyway, which is
>>>>> the reason for the warning below.
>>>>>  
>>>>>> [   80.726176] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
>>>>>> [   80.745935] Hardware name: Sun Fire X4800
>>>>>> [   80.746179] irq_2_iommu!=NULL irq 8
>>>>>
>>>>
>>>> no, irq_2_iommu are all dynamically allocated even for irq < 16.
>>>
>>> I know. I was talking about the preallocated irq descriptors and the
>>> handling of it in general.
>>>
>>> Nevertheless, that irq_2_iommu stuff does not need it's own allocation
>>> function. It's bound to a specific irq_cfg anyway, so the next logical
>>> step is to move irq_2_iommu into struct irq_cfg and get rid of the
>>> extra allocation/free in intr_remapping.c.
>>
>> Forgot to say, that I updated the git tree with all the fallout
>> fixes.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git master
>>
>> Can you please retest ?
>>
> 
> one warning and two panics
> 
> [   37.369332] ------------[ cut here ]------------
> [   37.383782] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
> [   37.384463] Hardware name: Sun Fire X4800
> [   37.403803] irq_2_iommu!=NULL irq 9
> [   37.404054] Modules linked in:
> [   37.404311] Pid: 1, comm: swapper Not tainted 2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171
> [   37.424042] Call Trace:
> [   37.424205]  [<ffffffff810787a0>] warn_slowpath_common+0x85/0x9d
> [   37.443822]  [<ffffffff8107885b>] warn_slowpath_fmt+0x46/0x48
> [   37.444383]  [<ffffffff8141c5f6>] ? radix_tree_lookup+0xb/0xd
> [   37.463788]  [<ffffffff8145f97c>] irq_2_iommu_alloc+0x52/0xdc
> [   37.464200]  [<ffffffff81ccc593>] ? _raw_spin_lock_irqsave+0x6d/0x7b
> [   37.483853]  [<ffffffff8145fb4d>] ? alloc_irte+0x97/0x168
> [   37.484296]  [<ffffffff8145fbce>] alloc_irte+0x118/0x168
> [   37.503774]  [<ffffffff8105062a>] setup_ioapic_irq+0x13f/0x331
> [   37.504278]  [<ffffffff81051d70>] setup_IO_APIC_irq_extra+0xce/0xde
> [   37.523868]  [<ffffffff8104c678>] acpi_gsi_to_irq+0x2a/0x31
> [   37.524475]  [<ffffffff814867c8>] ? acpi_ev_sci_xrupt_handler+0x0/0x2b
> [   37.543942]  [<ffffffff81475056>] acpi_os_install_interrupt_handler+0x31/0xa5
> [   37.563764]  [<ffffffff81486826>] acpi_ev_install_sci_handler+0x23/0x25
> [   37.564309]  [<ffffffff81485b41>] acpi_ev_install_xrupt_handlers+0x13/0x5f
> [   37.583694]  [<ffffffff8149fba1>] acpi_enable_subsystem+0x13a/0x145
> [   37.584429]  [<ffffffff827f0c75>] ? acpi_init+0x0/0x1a2
> [   37.603653]  [<ffffffff827f0a13>] acpi_bus_init+0x26/0x288
> [   37.604032]  [<ffffffff81cc920f>] ? printk+0x41/0x43
> [   37.623668]  [<ffffffff827f0cf4>] acpi_init+0x7f/0x1a2
> [   37.624130]  [<ffffffff810002da>] do_one_initcall+0x57/0x135
> [   37.643480]  [<ffffffff827bff7a>] kernel_init+0x167/0x1f1
> [   37.643871]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
> [   37.663541]  [<ffffffff81ccd07c>] ? restore_args+0x0/0x30
> [   37.663951]  [<ffffffff827bfe13>] ? kernel_init+0x0/0x1f1
> [   37.683515]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10
> [   37.684143] ---[ end trace 5003353dd8ff0030 ]---
> 

warning can be fixed by:

[PATCH] x86: Don't setup ioapic irq for sci two times.

With Thomas's sparseirq cleanup patchset, found one warning.

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
...

It turns We could setup ioapic irq for sci two times if that is normal SCI.

Actually setup_IO_APIC_irq_extra() is for big apic id or big irq sci.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1449,6 +1449,10 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 
 	irq = pin_2_irq(idx, apic_id, pin);
 
+	/* only handle fall out from setup_IO_APIC_irqs() */
+	if (!((apic_id > 0) && (irq > 16)))
+		return;
+
 	cfg = alloc_irq_and_cfg_at(irq, node);
 	if (!cfg)
 		return;
