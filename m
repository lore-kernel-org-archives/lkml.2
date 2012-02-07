Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2BGMv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:51:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2BGMv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:51:56 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F3117E5.6000105@redhat.com>
Date: Tue, 7 Feb 2012 13:51:53 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.02.2012, at 13:24, Avi Kivity wrote:

> On 02/07/2012 03:08 AM, Alexander Graf wrote:
>> I don't like the idea too much. On s390 and ppc we can set other vcpu's interrupt status. How would that work in this model?
> 
> It would be a "vm-wide syscall".  You can also do that on x86 (through KVM_IRQ_LINE).
> 
>> 
>> I really do like the ioctl model btw. It's easily extensible and easy to understand.
>> 
>> I can also promise you that I have no idea what other extensions we will need in the next few years. The non-x86 targets are just really very moving. So having an interface that allows for easy extension is a must-have.
> 
> Good point.  If we ever go through with it, it will only be after we see the interface has stabilized.

Not sure we'll ever get there. For PPC, it will probably take another 1-2 years until we get the 32-bit targets stabilized. By then we will have new 64-bit support though. And then the next gen will come out giving us even more new constraints.

The same goes for ARM, where we will get v7 support for now, but very soon we will also want to get v8. Stabilizing a target so far takes ~1-2 years from what I've seen. And that stabilizing to a point where we don't find major ABI issues anymore.

> 
>> 
>> >
>> >>  State accessors
>> >>  ---------------
>> >>  Currently vcpu state is read and written by a bunch of ioctls that
>> >>  access register sets that were added (or discovered) along the years.
>> >>  Some state is stored in the vcpu mmap area.  These will be replaced by a
>> >>  pair of syscalls that read or write the entire state, or a subset of the
>> >>  state, in a tag/value format.  A register will be described by a tuple:
>> >>
>> >>    set: the register set to which it belongs; either a real set (GPR,
>> >>  x87, SSE/AVX, segment, cpuid, MSRs) or a fake set (for
>> >>  eflags/rip/IDT/interrupt shadow/pending exception/etc.)
>> >>    number: register number within a set
>> >>    size: for self-description, and to allow expanding registers like
>> >>  SSE->AVX or eax->rax
>> >>    attributes: read-write, read-only, read-only for guest but read-write
>> >>  for host
>> >>    value
>> >
>> >  I do like the idea a lot of being able to read one register at a time as often times that's all you need.
>> 
>> The framework is in KVM today. It's called ONE_REG. So far only PPC implements a few registers. If you like it, just throw all the x86 ones in there and you have everything you need.
> 
> This is more like MANY_REG, where you scatter/gather a list of registers in userspace to the kernel or vice versa.

Well, yeah, to me MANY_REG is part of ONE_REG. The idea behind ONE_REG was to give every register a unique identifier that can be used to access it. Taking that logic to an array is trivial.

> 
>> 
>> >>  The communications between the local APIC and the IOAPIC/PIC will be
>> >>  done over a socketpair, emulating the APIC bus protocol.
>> 
>> What is keeping us from moving there today?
> 
> The biggest problem with this proposal is that what we have today works reasonably well.  Nothing is keeping us from moving there, except the fear of performance regressions and lack of strong motivation.

So why bring it up in the "next-gen" api discussion?

> 
>> 
>> >>
>> >>  Ioeventfd/irqfd
>> >>  ---------------
>> >>  As the ioeventfd/irqfd mechanism has been quite successful, it will be
>> >>  retained, and perhaps supplemented with a way to assign an mmio region
>> >>  to a socketpair carrying transactions.  This allows a device model to be
>> >>  implemented out-of-process.  The socketpair can also be used to
>> >>  implement a replacement for coalesced mmio, by not waiting for responses
>> >>  on write transactions when enabled.  Synchronization of coalesced mmio
>> >>  will be implemented in the kernel, not userspace as now: when a
>> >>  non-coalesced mmio is needed, the kernel will first flush the coalesced
>> >>  mmio queue(s).
>> 
>> I would vote for completely deprecating coalesced MMIO. It is a generic framework that nobody except for VGA really needs.
> 
> It's actually used by e1000 too, don't remember what the performance benefits are.  Of course, few people use e1000.

And for e1000 it's only used for nvram which actually could benefit from a more clever "this is backed by ram" logic. Coalesced mmio is not a great fit here.

> 
>> Better make something that accelerates read and write paths thanks to more specific knowledge of the interface.
>> 
>> One thing I'm thinking of here is IDE. There's no need to PIO callback into user space for all the status ports. We only really care about a callback on write to 7 (cmd). All the others are basically registers that the kernel could just read and write from shared memory.
>> 
>> I'm sure the VGA text stuff could use similar acceleration with well-known interfaces.
> 
> This goes back to the discussion about a kernel bytecode vm for accelerating mmio.  The problem is that we need something really general.
> 
>> To me, coalesced mmio has proven that's it's generalization where it doesn't belong.
> 
> But you want to generalize it even more?
> 
> There's no way a patch with 'VGA' in it would be accepted.

Why not? I think the natural step forward is hybrid acceleration. Take a minimal subset of device emulation into kernel land, keep the rest in user space. Similar to how vhost works, where we keep device enumeration and configuration in user space, but ring processing in kernel space.

Good candidates for in-kernel acceleration are:

  - HPET
  - VGA
  - IDE

I'm not sure how easy it would be to only partially accelerate the hot paths of the IO-APIC. I'm not too familiar with its details.

We will run into the same thing with the MPIC though. On e500v2, IPIs are done through the MPIC. So if we want any SMP performance on those, we need to shove that part into the kernel. I don't really want to have all of the MPIC code in there however. So a hybrid approach sounds like a great fit.

The problem with in-kernel device emulation the way we have it today is that it's an all-or-nothing choice. Either we push the device into kernel space or we keep it in user space. That adds a lot of code in kernel land where it doesn't belong.

> 
>> 
>> >>
>> >>  Guest memory management
>> >>  -----------------------
>> >>  Instead of managing each memory slot individually, a single API will be
>> >>  provided that replaces the entire guest physical memory map atomically.
>> >>  This matches the implementation (using RCU) and plugs holes in the
>> >>  current API, where you lose the dirty log in the window between the last
>> >>  call to KVM_GET_DIRTY_LOG and the call to KVM_SET_USER_MEMORY_REGION
>> >>  that removes the slot.
>> 
>> So we render the actual slot logic invisible? That's a very good idea.
> 
> No, slots still exist.  Only the API is "replace slot list" instead of "add slot" and "remove slot".

Why? On PPC we walk the slots on every fault (incl. mmio), so fast lookup times there would be great. I was thinking of something page table like here. That only works when then internal slot structure is hidden from user space though.

> 
>> 
>> >>
>> >>  Slot-based dirty logging will be replaced by range-based and work-based
>> >>  dirty logging; that is "what pages are dirty in this range, which may be
>> >>  smaller than a slot" and "don't return more than N pages".
>> >>
>> >>  We may want to place the log in user memory instead of kernel memory, to
>> >>  reduce pinned memory and increase flexibility.
>> >
>> >  Since we really only support 64-bit hosts, what about just pointing the kernel at a address/size pair and rely on userspace to mmap() the range appropriately?
>> 
>> That's basically what he suggested, no?
> 
> 
> No.
> 
>> >
>> >>  vcpu fd mmap area
>> >>  -----------------
>> >>  Currently we mmap() a few pages of the vcpu fd for fast user/kernel
>> >>  communications.  This will be replaced by a more orthodox pointer
>> >>  parameter to sys_kvm_enter_guest(), that will be accessed using
>> >>  get_user() and put_user().  This is slower than the current situation,
>> >>  but better for things like strace.
>> 
>> I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.
> 
> Something really critical should be handled in the kernel.  Care to provide examples?

Just look at the s390 patches Christian posted recently. I think that's a very nice direction to walk towards.
For permanently mapped space, the hybrid stuff above could fall into that category. We could however to it through copy_from/to_user with a user space pointer.

So maybe you're right - the mmap'ed space isn't all that important. Having kernel space write into user space memory is however.


Alex

