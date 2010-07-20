Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0GTH2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:28:08 -0400
Received: from mail4.comsite.net ([205.238.176.238]:30757 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab0GTH2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:28:06 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=74.61.84.126;
From: Milton Miller <miltonm@bga.com>
To: Alexander Graf <agraf@suse.de>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PPC64/Power7 - 2.6.35-rc5] Bad relocation warnings whileBuilding
 a CONFIG_RELOCATABLE kernel with CONFIG_ISERIES enabled
Message-ID: <reloc-2010-07-19-3@mdm.bga.com>
In-Reply-To: <4C443E78.6020902@suse.de>
References: <4C443E78.6020902@suse.de> <reloc-2010-07-19@mdm.bga.com>
	<8C4BCF61-7F5D-4C80-A311-93CF8521FBF5@suse.de>
	<1273060251.13463.8.camel@subratamodak.linux.ibm.com>
	<20100507054034.GB25173@drongo>
	<1279193743.10707.5.camel@subratamodak.linux.ibm.com>
	<1279501889.10390.1834.camel@pasglop> <reloc-2010-07-19-2@mdm.bga.com>
Date: Tue, 20 Jul 2010 02:27:58 -0500
X-Originating-IP: 74.61.84.126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 about 14:00:56 +0200, Alexander Graf wrote:
>Milton Miller wrote:
>> I wrote:
>>   
>>> On Mon Jul 19 2010 at about 03:36:51 EST, Alexander Graf wrote:
>>>     
>>>> On 19.07.2010, at 03:11, Benjamin Herrenschmidt wrote:
>>>>
>>>>       
>>>>> On Thu, 2010-07-15 at 17:05 +0530, Subrata Modak wrote:
>>>>>         
>>>>>> commit e62cee42e66dcca83aae02748535f62e0f564a0c solved the problem for
>>>>>> 2.6.34-rc6. However some other bad relocation warnings generated against
>>>>>> 2.6.35-rc5 on Power7/ppc64 below:
>>>>>>
>>>>>> MODPOST 2004 modules^M
>>>>>> WARNING: 2 bad relocations^M
>>>>>> c000000000008590 R_PPC64_ADDR32 .text+0x4000000000008460^M
>>>>>> c000000000008594 R_PPC64_ADDR32 .text+0x4000000000008598^M
>>>>>>           
>>>>> I think this is KVM + CONFIG_RELOCATABLE. Caused by:
>>>>>
>>>>> .global kvmppc_trampoline_lowmem
>>>>> kvmppc_trampoline_lowmem:
>>>>> .long kvmppc_handler_lowmem_trampoline - CONFIG_KERNEL_START
>>>>>
>>>>> .global kvmppc_trampoline_enter
>>>>> kvmppc_trampoline_enter:
>>>>> .long kvmppc_handler_trampoline_enter - CONFIG_KERNEL_START
>>>>>
>>>>> Alex, can you turn these into 64-bit on ppc64 so the relocator
>>>>> can grok them ?
>>>>>         
>>>> If I turn them into 64-bit, will the values be > RMA? In that case
>>>> things would break anyways. How does relocation work on PPC? Are the
>>>> first few megs copied over to low memory? Would I have to mask anything
>>>> in the above code to make sure I use the real values? 
>>>>
>>>> Alex
>>>>
>>>>       
>>> You can still do the subtraction, but you have to allocate 64 bits for
>>> storage.  Relocatable ppc64 kernels work by adjusting PPC64_RELOC_RELATIVE
>>> entries during early boot (reloc in reloc_64.S called from head_64.S).
>>>
>>> The code purposely only supports 64 bit relative addressing.
>>>     
>>
>> Oh yea, and for book-3s, the code copies from 0x100 to __end_interrupts
>> in arch/powerpc/kernel/exceptions-64s.h down to the real 0, but the rest
>> of the kernel is at some disjointed address.  The interrupt will go to
>> the copy at the real zero.  Any references to code outside that region
>> must be done via a full indrect branch (not a relative one), simiar to
>> the secondary startup (via following the function pointer in a descriptor
>> set in very low memory), or syscall entry and exception vectors via paca.
>>   
>
>That would still break on normal PPC boxes, as any address accessed in
>real mode has to be inside the RMA. And the #include for
>kvm/book3s_rmhandlers.S happens after __end_interrupts. So I'd end up
>with code that gets executed outside of the RMA after a relocation, right?
>
>Alex
>

Weither its outside of the RMA or not, DO_KVM is creating a branch outside
of code copied to lowmem.

This is BROKEN.

We have a hard limit that we can't extend _end_interrupts past 0x7000, and
a soft limit that we can't exceed 0x6000.  If there is space, we could
move the real mode handler extensions inside end_interrupts in
exceptions-64s.S, and store the full address in a .quad so it gets
relocated properly.  Don't subtract the start, we have designed the kernel
to run with start at a VA that can be used as a EA in real mode.

Otherwise we need to mark KVM_BOOK3S_64 depends on (!RELOCATABLE ||
BROKEN) for 2.6.35 until we get fixes.

I took a read though the book3s code as of 2.6.34.   A few things I noticed:

(1) The code is using slb large to control the segment size.   It should
be using SLB B field (or just impliment 256M segments only).

(2) It appears that the mtspr and mfspr code is using the same storage for
bats 4-7 as 0-3 ... I would have expected a 4 + a few places.

(3) Its not clear to me that you clear RI when transitioning to the guest
but its obviously required because you place state in srr0 & srr1.

(4) I don't understand why __kvmppc_vcpu_run turns on interrupts so that
__kvmppc_vcpu_entry can turn them back off.   Something to do with
irq trace annotations?

milton
