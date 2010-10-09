Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0JIHFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 03:05:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45909 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0JIHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 03:05:45 -0400
Message-ID: <4CB013CB.1040904@kernel.org>
Date: Sat, 09 Oct 2010 00:03:39 -0700
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
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6> <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <alpine.LFD.2.00.1010090758420.13094@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010090758420.13094@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 11:10 PM, Thomas Gleixner wrote:
> On Fri, 8 Oct 2010, Yinghai Lu wrote:
> 
>> On 10/08/2010 02:54 PM, Thomas Gleixner wrote:
>>> On Fri, 8 Oct 2010, Thomas Gleixner wrote:
>>>
>>>> On Wed, 6 Oct 2010, Yinghai Lu wrote:
>>>>> On 10/06/2010 09:01 PM, Thomas Gleixner wrote:
>>>>>> Well, I'm not too happy about this preallocated stuff anyway, which is
>>>>>> the reason for the warning below.
>>>>>>  
>>>>>>> [   80.726176] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
>>>>>>> [   80.745935] Hardware name: Sun Fire X4800
>>>>>>> [   80.746179] irq_2_iommu!=NULL irq 8
>>>>>>
>>>>>
>>>>> no, irq_2_iommu are all dynamically allocated even for irq < 16.
>>>>
>>>> I know. I was talking about the preallocated irq descriptors and the
>>>> handling of it in general.
>>>>
>>>> Nevertheless, that irq_2_iommu stuff does not need it's own allocation
>>>> function. It's bound to a specific irq_cfg anyway, so the next logical
>>>> step is to move irq_2_iommu into struct irq_cfg and get rid of the
>>>> extra allocation/free in intr_remapping.c.
>>>
>>> Forgot to say, that I updated the git tree with all the fallout
>>> fixes.
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git master
>>>
>>> Can you please retest ?
>>>
>>
>> one warning and two panics
>>
>> [   37.369332] ------------[ cut here ]------------
>> [   37.383782] WARNING: at drivers/pci/intr_remapping.c:67 irq_2_iommu_alloc+0x52/0xdc()
>> [   37.384463] Hardware name: Sun Fire X4800
>> [   37.403803] irq_2_iommu!=NULL irq 9
>> [   37.404054] Modules linked in:
>> [   37.404311] Pid: 1, comm: swapper Not tainted 2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171
> 
> Hmm, so that interrupt is already set up in the iommmu.
>  
>> [   59.429741] BUG: unable to handle kernel NULL pointer dereference at (null)
>> [   59.449366] IP: [<ffffffff8147d715>] acpi_pci_irq_find_prt_entry+0x85/0xb1
> 
> I can hardly see how this is related to the irq work.
> 
>> [   71.076886] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc7-tip-yh-01944-ge8a4c5f-dirty #171      /Sun Fire x4800
>> [   71.096947] RIP: 0010:[<ffffffff8141e232>]  [<ffffffff8141e232>] strcmp+0x4/0x21
> 
> Ditto.

don't know.

but without merging your branch, those problems don't come out.

only thing i can think about that you real free irq code could stress or expose other subsystem's bug etc.

Yinghai
