Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2BGBIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:08:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab2BGBIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:08:09 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F2B41D6.8020603@codemonkey.ws>
Date: Tue, 7 Feb 2012 02:08:06 +0100
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws>
To: Anthony Liguori <anthony@codemonkey.ws>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03.02.2012, at 03:09, Anthony Liguori wrote:

> On 02/02/2012 10:09 AM, Avi Kivity wrote:
>> The kvm api has been accumulating cruft for several years now.  This is
>> due to feature creep, fixing mistakes, experience gained by the
>> maintainers and developers on how to do things, ports to new
>> architectures, and simply as a side effect of a code base that is
>> developed slowly and incrementally.
>> 
>> While I don't think we can justify a complete revamp of the API now, I'm
>> writing this as a thought experiment to see where a from-scratch API can
>> take us.  Of course, if we do implement this, the new and old APIs will
>> have to be supported side by side for several years.
>> 
>> Syscalls
>> --------
>> kvm currently uses the much-loved ioctl() system call as its entry
>> point.  While this made it easy to add kvm to the kernel unintrusively,
>> it does have downsides:
>> 
>> - overhead in the entry path, for the ioctl dispatch path and vcpu mutex
>> (low but measurable)
>> - semantic mismatch: kvm really wants a vcpu to be tied to a thread, and
>> a vm to be tied to an mm_struct, but the current API ties them to file
>> descriptors, which can move between threads and processes.  We check
>> that they don't, but we don't want to.
>> 
>> Moving to syscalls avoids these problems, but introduces new ones:
>> 
>> - adding new syscalls is generally frowned upon, and kvm will need several
>> - syscalls into modules are harder and rarer than into core kernel code
>> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>> mm_struct
>> 
>> Syscalls that operate on the entire guest will pick it up implicitly
>> from the mm_struct, and syscalls that operate on a vcpu will pick it up
>> from current.
> 
> This seems like the natural progression.

I don't like the idea too much. On s390 and ppc we can set other vcpu's interrupt status. How would that work in this model?

I really do like the ioctl model btw. It's easily extensible and easy to understand.

I can also promise you that I have no idea what other extensions we will need in the next few years. The non-x86 targets are just really very moving. So having an interface that allows for easy extension is a must-have.

> 
>> State accessors
>> ---------------
>> Currently vcpu state is read and written by a bunch of ioctls that
>> access register sets that were added (or discovered) along the years.
>> Some state is stored in the vcpu mmap area.  These will be replaced by a
>> pair of syscalls that read or write the entire state, or a subset of the
>> state, in a tag/value format.  A register will be described by a tuple:
>> 
>>   set: the register set to which it belongs; either a real set (GPR,
>> x87, SSE/AVX, segment, cpuid, MSRs) or a fake set (for
>> eflags/rip/IDT/interrupt shadow/pending exception/etc.)
>>   number: register number within a set
>>   size: for self-description, and to allow expanding registers like
>> SSE->AVX or eax->rax
>>   attributes: read-write, read-only, read-only for guest but read-write
>> for host
>>   value
> 
> I do like the idea a lot of being able to read one register at a time as often times that's all you need.

The framework is in KVM today. It's called ONE_REG. So far only PPC implements a few registers. If you like it, just throw all the x86 ones in there and you have everything you need.

> 
>> 
>> Device model
>> ------------
>> Currently kvm virtualizes or emulates a set of x86 cores, with or
>> without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
>> PCI devices assigned from the host.  The API allows emulating the local
>> APICs in userspace.
>> 
>> The new API will do away with the IOAPIC/PIC/PIT emulation and defer
>> them to userspace.
> 
> I'm a big fan of this.
> 
>> Note: this may cause a regression for older guests
>> that don't support MSI or kvmclock.  Device assignment will be done
>> using VFIO, that is, without direct kvm involvement.
>> 
>> Local APICs will be mandatory, but it will be possible to hide them from
>> the guest.  This means that it will no longer be possible to emulate an
>> APIC in userspace, but it will be possible to virtualize an APIC-less
>> core - userspace will play with the LINT0/LINT1 inputs (configured as
>> EXITINT and NMI) to queue interrupts and NMIs.
> 
> I think this makes sense.  An interesting consequence of this is that it's no longer necessary to associate the VCPU context with an MMIO/PIO operation.  I'm not sure if there's an obvious benefit to that but it's interesting nonetheless.
> 
>> The communications between the local APIC and the IOAPIC/PIC will be
>> done over a socketpair, emulating the APIC bus protocol.

What is keeping us from moving there today?

>> 
>> Ioeventfd/irqfd
>> ---------------
>> As the ioeventfd/irqfd mechanism has been quite successful, it will be
>> retained, and perhaps supplemented with a way to assign an mmio region
>> to a socketpair carrying transactions.  This allows a device model to be
>> implemented out-of-process.  The socketpair can also be used to
>> implement a replacement for coalesced mmio, by not waiting for responses
>> on write transactions when enabled.  Synchronization of coalesced mmio
>> will be implemented in the kernel, not userspace as now: when a
>> non-coalesced mmio is needed, the kernel will first flush the coalesced
>> mmio queue(s).

I would vote for completely deprecating coalesced MMIO. It is a generic framework that nobody except for VGA really needs. Better make something that accelerates read and write paths thanks to more specific knowledge of the interface.

One thing I'm thinking of here is IDE. There's no need to PIO callback into user space for all the status ports. We only really care about a callback on write to 7 (cmd). All the others are basically registers that the kernel could just read and write from shared memory.

I'm sure the VGA text stuff could use similar acceleration with well-known interfaces.

To me, coalesced mmio has proven that's it's generalization where it doesn't belong.

>> 
>> Guest memory management
>> -----------------------
>> Instead of managing each memory slot individually, a single API will be
>> provided that replaces the entire guest physical memory map atomically.
>> This matches the implementation (using RCU) and plugs holes in the
>> current API, where you lose the dirty log in the window between the last
>> call to KVM_GET_DIRTY_LOG and the call to KVM_SET_USER_MEMORY_REGION
>> that removes the slot.

So we render the actual slot logic invisible? That's a very good idea.

>> 
>> Slot-based dirty logging will be replaced by range-based and work-based
>> dirty logging; that is "what pages are dirty in this range, which may be
>> smaller than a slot" and "don't return more than N pages".
>> 
>> We may want to place the log in user memory instead of kernel memory, to
>> reduce pinned memory and increase flexibility.
> 
> Since we really only support 64-bit hosts, what about just pointing the kernel at a address/size pair and rely on userspace to mmap() the range appropriately?

That's basically what he suggested, no?

> 
>> vcpu fd mmap area
>> -----------------
>> Currently we mmap() a few pages of the vcpu fd for fast user/kernel
>> communications.  This will be replaced by a more orthodox pointer
>> parameter to sys_kvm_enter_guest(), that will be accessed using
>> get_user() and put_user().  This is slower than the current situation,
>> but better for things like strace.

I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.

> Look pretty interesting overall.

Yeah, I agree with most ideas, except for the syscall one. Everything else can easily be implemented on top of the current model.


Alex

