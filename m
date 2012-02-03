Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2BCCJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:09:32 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:43000 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab2BCCJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:09:30 -0500
Message-ID: <4F2B41D6.8020603@codemonkey.ws>
Date: Thu, 02 Feb 2012 20:09:26 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>
In-Reply-To: <4F2AB552.2070909@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 10:09 AM, Avi Kivity wrote:
> The kvm api has been accumulating cruft for several years now.  This is
> due to feature creep, fixing mistakes, experience gained by the
> maintainers and developers on how to do things, ports to new
> architectures, and simply as a side effect of a code base that is
> developed slowly and incrementally.
>
> While I don't think we can justify a complete revamp of the API now, I'm
> writing this as a thought experiment to see where a from-scratch API can
> take us.  Of course, if we do implement this, the new and old APIs will
> have to be supported side by side for several years.
>
> Syscalls
> --------
> kvm currently uses the much-loved ioctl() system call as its entry
> point.  While this made it easy to add kvm to the kernel unintrusively,
> it does have downsides:
>
> - overhead in the entry path, for the ioctl dispatch path and vcpu mutex
> (low but measurable)
> - semantic mismatch: kvm really wants a vcpu to be tied to a thread, and
> a vm to be tied to an mm_struct, but the current API ties them to file
> descriptors, which can move between threads and processes.  We check
> that they don't, but we don't want to.
>
> Moving to syscalls avoids these problems, but introduces new ones:
>
> - adding new syscalls is generally frowned upon, and kvm will need several
> - syscalls into modules are harder and rarer than into core kernel code
> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
> mm_struct
>
> Syscalls that operate on the entire guest will pick it up implicitly
> from the mm_struct, and syscalls that operate on a vcpu will pick it up
> from current.

This seems like the natural progression.

> State accessors
> ---------------
> Currently vcpu state is read and written by a bunch of ioctls that
> access register sets that were added (or discovered) along the years.
> Some state is stored in the vcpu mmap area.  These will be replaced by a
> pair of syscalls that read or write the entire state, or a subset of the
> state, in a tag/value format.  A register will be described by a tuple:
>
>    set: the register set to which it belongs; either a real set (GPR,
> x87, SSE/AVX, segment, cpuid, MSRs) or a fake set (for
> eflags/rip/IDT/interrupt shadow/pending exception/etc.)
>    number: register number within a set
>    size: for self-description, and to allow expanding registers like
> SSE->AVX or eax->rax
>    attributes: read-write, read-only, read-only for guest but read-write
> for host
>    value

I do like the idea a lot of being able to read one register at a time as often 
times that's all you need.

>
> Device model
> ------------
> Currently kvm virtualizes or emulates a set of x86 cores, with or
> without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
> PCI devices assigned from the host.  The API allows emulating the local
> APICs in userspace.
>
> The new API will do away with the IOAPIC/PIC/PIT emulation and defer
> them to userspace.

I'm a big fan of this.

> Note: this may cause a regression for older guests
> that don't support MSI or kvmclock.  Device assignment will be done
> using VFIO, that is, without direct kvm involvement.
>
> Local APICs will be mandatory, but it will be possible to hide them from
> the guest.  This means that it will no longer be possible to emulate an
> APIC in userspace, but it will be possible to virtualize an APIC-less
> core - userspace will play with the LINT0/LINT1 inputs (configured as
> EXITINT and NMI) to queue interrupts and NMIs.

I think this makes sense.  An interesting consequence of this is that it's no 
longer necessary to associate the VCPU context with an MMIO/PIO operation.  I'm 
not sure if there's an obvious benefit to that but it's interesting nonetheless.

> The communications between the local APIC and the IOAPIC/PIC will be
> done over a socketpair, emulating the APIC bus protocol.
>
> Ioeventfd/irqfd
> ---------------
> As the ioeventfd/irqfd mechanism has been quite successful, it will be
> retained, and perhaps supplemented with a way to assign an mmio region
> to a socketpair carrying transactions.  This allows a device model to be
> implemented out-of-process.  The socketpair can also be used to
> implement a replacement for coalesced mmio, by not waiting for responses
> on write transactions when enabled.  Synchronization of coalesced mmio
> will be implemented in the kernel, not userspace as now: when a
> non-coalesced mmio is needed, the kernel will first flush the coalesced
> mmio queue(s).
>
> Guest memory management
> -----------------------
> Instead of managing each memory slot individually, a single API will be
> provided that replaces the entire guest physical memory map atomically.
> This matches the implementation (using RCU) and plugs holes in the
> current API, where you lose the dirty log in the window between the last
> call to KVM_GET_DIRTY_LOG and the call to KVM_SET_USER_MEMORY_REGION
> that removes the slot.
>
> Slot-based dirty logging will be replaced by range-based and work-based
> dirty logging; that is "what pages are dirty in this range, which may be
> smaller than a slot" and "don't return more than N pages".
>
> We may want to place the log in user memory instead of kernel memory, to
> reduce pinned memory and increase flexibility.

Since we really only support 64-bit hosts, what about just pointing the kernel 
at a address/size pair and rely on userspace to mmap() the range appropriately?

> vcpu fd mmap area
> -----------------
> Currently we mmap() a few pages of the vcpu fd for fast user/kernel
> communications.  This will be replaced by a more orthodox pointer
> parameter to sys_kvm_enter_guest(), that will be accessed using
> get_user() and put_user().  This is slower than the current situation,
> but better for things like strace.

Look pretty interesting overall.

Regards,

Anthony Liguori

>

