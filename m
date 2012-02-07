Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2BGMYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:24:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2BGMYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:24:14 -0500
Message-ID: <4F3117E5.6000105@redhat.com>
Date: Tue, 07 Feb 2012 14:24:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>
In-Reply-To: <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 03:08 AM, Alexander Graf wrote:
> I don't like the idea too much. On s390 and ppc we can set other vcpu's interrupt status. How would that work in this model?

It would be a "vm-wide syscall".  You can also do that on x86 (through 
KVM_IRQ_LINE).

>
> I really do like the ioctl model btw. It's easily extensible and easy to understand.
>
> I can also promise you that I have no idea what other extensions we will need in the next few years. The non-x86 targets are just really very moving. So having an interface that allows for easy extension is a must-have.

Good point.  If we ever go through with it, it will only be after we see 
the interface has stabilized.

>
> >
> >>  State accessors
> >>  ---------------
> >>  Currently vcpu state is read and written by a bunch of ioctls that
> >>  access register sets that were added (or discovered) along the years.
> >>  Some state is stored in the vcpu mmap area.  These will be replaced by a
> >>  pair of syscalls that read or write the entire state, or a subset of the
> >>  state, in a tag/value format.  A register will be described by a tuple:
> >>
> >>    set: the register set to which it belongs; either a real set (GPR,
> >>  x87, SSE/AVX, segment, cpuid, MSRs) or a fake set (for
> >>  eflags/rip/IDT/interrupt shadow/pending exception/etc.)
> >>    number: register number within a set
> >>    size: for self-description, and to allow expanding registers like
> >>  SSE->AVX or eax->rax
> >>    attributes: read-write, read-only, read-only for guest but read-write
> >>  for host
> >>    value
> >
> >  I do like the idea a lot of being able to read one register at a time as often times that's all you need.
>
> The framework is in KVM today. It's called ONE_REG. So far only PPC implements a few registers. If you like it, just throw all the x86 ones in there and you have everything you need.

This is more like MANY_REG, where you scatter/gather a list of registers 
in userspace to the kernel or vice versa.

>
> >>  The communications between the local APIC and the IOAPIC/PIC will be
> >>  done over a socketpair, emulating the APIC bus protocol.
>
> What is keeping us from moving there today?

The biggest problem with this proposal is that what we have today works 
reasonably well.  Nothing is keeping us from moving there, except the 
fear of performance regressions and lack of strong motivation.

>
> >>
> >>  Ioeventfd/irqfd
> >>  ---------------
> >>  As the ioeventfd/irqfd mechanism has been quite successful, it will be
> >>  retained, and perhaps supplemented with a way to assign an mmio region
> >>  to a socketpair carrying transactions.  This allows a device model to be
> >>  implemented out-of-process.  The socketpair can also be used to
> >>  implement a replacement for coalesced mmio, by not waiting for responses
> >>  on write transactions when enabled.  Synchronization of coalesced mmio
> >>  will be implemented in the kernel, not userspace as now: when a
> >>  non-coalesced mmio is needed, the kernel will first flush the coalesced
> >>  mmio queue(s).
>
> I would vote for completely deprecating coalesced MMIO. It is a generic framework that nobody except for VGA really needs.

It's actually used by e1000 too, don't remember what the performance 
benefits are.  Of course, few people use e1000.

> Better make something that accelerates read and write paths thanks to more specific knowledge of the interface.
>
> One thing I'm thinking of here is IDE. There's no need to PIO callback into user space for all the status ports. We only really care about a callback on write to 7 (cmd). All the others are basically registers that the kernel could just read and write from shared memory.
>
> I'm sure the VGA text stuff could use similar acceleration with well-known interfaces.

This goes back to the discussion about a kernel bytecode vm for 
accelerating mmio.  The problem is that we need something really general.

> To me, coalesced mmio has proven that's it's generalization where it doesn't belong.

But you want to generalize it even more?

There's no way a patch with 'VGA' in it would be accepted.

>
> >>
> >>  Guest memory management
> >>  -----------------------
> >>  Instead of managing each memory slot individually, a single API will be
> >>  provided that replaces the entire guest physical memory map atomically.
> >>  This matches the implementation (using RCU) and plugs holes in the
> >>  current API, where you lose the dirty log in the window between the last
> >>  call to KVM_GET_DIRTY_LOG and the call to KVM_SET_USER_MEMORY_REGION
> >>  that removes the slot.
>
> So we render the actual slot logic invisible? That's a very good idea.

No, slots still exist.  Only the API is "replace slot list" instead of 
"add slot" and "remove slot".

>
> >>
> >>  Slot-based dirty logging will be replaced by range-based and work-based
> >>  dirty logging; that is "what pages are dirty in this range, which may be
> >>  smaller than a slot" and "don't return more than N pages".
> >>
> >>  We may want to place the log in user memory instead of kernel memory, to
> >>  reduce pinned memory and increase flexibility.
> >
> >  Since we really only support 64-bit hosts, what about just pointing the kernel at a address/size pair and rely on userspace to mmap() the range appropriately?
>
> That's basically what he suggested, no?


No.

> >
> >>  vcpu fd mmap area
> >>  -----------------
> >>  Currently we mmap() a few pages of the vcpu fd for fast user/kernel
> >>  communications.  This will be replaced by a more orthodox pointer
> >>  parameter to sys_kvm_enter_guest(), that will be accessed using
> >>  get_user() and put_user().  This is slower than the current situation,
> >>  but better for things like strace.
>
> I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.

Something really critical should be handled in the kernel.  Care to 
provide examples?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

