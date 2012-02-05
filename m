Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2BEJY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 04:24:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2BEJYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 04:24:50 -0500
Message-ID: <4F2E4ADB.2000105@redhat.com>
Date: Sun, 05 Feb 2012 11:24:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws>
In-Reply-To: <4F2B41D6.8020603@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 04:09 AM, Anthony Liguori wrote:
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
> I think this makes sense.  An interesting consequence of this is that
> it's no longer necessary to associate the VCPU context with an
> MMIO/PIO operation.  I'm not sure if there's an obvious benefit to
> that but it's interesting nonetheless.

It doesn't follow (at least from the above), and it isn't allowed in
some situations (like PIO invoking synchronous SMI).  So we'll have to
retain synchronous PIO/MMIO (but we can allow to relax this for
socketpair mmio).

>
>> The communications between the local APIC and the IOAPIC/PIC will be
>> done over a socketpair, emulating the APIC bus protocol.
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
>>
>> Guest memory management
>> -----------------------
>> Instead of managing each memory slot individually, a single API will be
>> provided that replaces the entire guest physical memory map atomically.
>> This matches the implementation (using RCU) and plugs holes in the
>> current API, where you lose the dirty log in the window between the last
>> call to KVM_GET_DIRTY_LOG and the call to KVM_SET_USER_MEMORY_REGION
>> that removes the slot.
>>
>> Slot-based dirty logging will be replaced by range-based and work-based
>> dirty logging; that is "what pages are dirty in this range, which may be
>> smaller than a slot" and "don't return more than N pages".
>>
>> We may want to place the log in user memory instead of kernel memory, to
>> reduce pinned memory and increase flexibility.
>
> Since we really only support 64-bit hosts, 

We don't (Red Hat does, but that's a distro choice).  Non-x86 also needs
32-bit.

> what about just pointing the kernel at a address/size pair and rely on
> userspace to mmap() the range appropriately?

The "one large slot" approach.  Even if we ignore the 32-bit issue, we
still need some per-slot information, like per-slot dirty logging.  It's
also hard to create aliases this way (BIOS at 0xe0000 and 0xfffe0000) or
to move memory around (framebuffer BAR).

>
>> vcpu fd mmap area
>> -----------------
>> Currently we mmap() a few pages of the vcpu fd for fast user/kernel
>> communications.  This will be replaced by a more orthodox pointer
>> parameter to sys_kvm_enter_guest(), that will be accessed using
>> get_user() and put_user().  This is slower than the current situation,
>> but better for things like strace.
>
> Look pretty interesting overall.

I'll get an actual API description for the next round.

-- 
error compiling committee.c: too many arguments to function

