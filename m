Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0JIHKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 03:10:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46693 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0JIHKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 03:10:24 -0400
Message-ID: <4CB014F5.5080209@kernel.org>
Date: Sat, 09 Oct 2010 00:08:37 -0700
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
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <4CB00122.3030301@kernel.org> <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 11:34 PM, Thomas Gleixner wrote:
> On Fri, 8 Oct 2010, Yinghai Lu wrote:
>> On 10/08/2010 09:26 PM, Yinghai Lu wrote:
>> [PATCH] x86: Don't setup ioapic irq for sci two times.
>>
>> With Thomas's sparseirq cleanup patchset, found one warning.
>>
>> [   37.369332] ------------[ cut here ]------------
>> [   37.383782] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
>> [   37.384463] Hardware name: Sun Fire X4800
>> [   37.403803] irq_2_iommu!=NULL irq 9
>> [   37.404054] Modules linked in:
>> [   37.404311] Pid: 1, comm: swapper Not tainted 2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171
>> [   37.424042] Call Trace:
>> [   37.424205]  [<ffffffff810787a0>] warn_slowpath_common+0x85/0x9d
>> [   37.443822]  [<ffffffff8107885b>] warn_slowpath_fmt+0x46/0x48
>> [   37.444383]  [<ffffffff8141c5f6>] ? radix_tree_lookup+0xb/0xd
>> [   37.463788]  [<ffffffff8145f97c>] irq_2_iommu_alloc+0x52/0xdc
>> [   37.464200]  [<ffffffff81ccc593>] ? _raw_spin_lock_irqsave+0x6d/0x7b
>> [   37.483853]  [<ffffffff8145fb4d>] ? alloc_irte+0x97/0x168
>> [   37.484296]  [<ffffffff8145fbce>] alloc_irte+0x118/0x168
>> [   37.503774]  [<ffffffff8105062a>] setup_ioapic_irq+0x13f/0x331
>> [   37.504278]  [<ffffffff81051d70>] setup_IO_APIC_irq_extra+0xce/0xde
>> [   37.523868]  [<ffffffff8104c678>] acpi_gsi_to_irq+0x2a/0x31
>> ...
>>
>> It turns We could setup ioapic irq for sci two times if that is normal SCI.
>>
>> Actually setup_IO_APIC_irq_extra() is for big apic id or big irq sci.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>> @@ -1449,6 +1449,10 @@ void setup_IO_APIC_irq_extra(u32 gsi)
>>  
>>  	irq = pin_2_irq(idx, apic_id, pin);
>>  
>> +	/* only handle fall out from setup_IO_APIC_irqs() */
> 
> What's the fallout ? And why are we coming here in the first place
> when the irq is < 16 ?

setup_IO_APIC_irqs only handle apic_id == 0 or apic_id > 0 but irq < 16 via acpi override.

it seems IBM's system have apic_id == 1, and sci irq is using 30.

so at that time add that setup_IO_APIC_irq_extra() to workaround it.
but it seems we set that two time when irq < 16.

> 
>> +	if (!((apic_id > 0) && (irq > 16)))
>> +		return;
>> +
>>  	cfg = alloc_irq_and_cfg_at(irq, node);
>>  	if (!cfg)
>>  		return;
>>

