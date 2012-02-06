Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2BFNye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 08:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab2BFNyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 08:54:33 -0500
Message-ID: <4F2FDB91.80200@redhat.com>
Date: Mon, 06 Feb 2012 15:54:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com>	<20120205095153.GA29265@redhat.com>	<4F2EAFF6.7030006@codemonkey.ws> <4F2F9E89.7090607@redhat.com> <4F2FD692.5060708@codemonkey.ws>
In-Reply-To: <4F2FD692.5060708@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 03:33 PM, Anthony Liguori wrote:
>> Look at arch/x86/kvm/i8254.c:pit_ioport_read() for a counterexample.
>> There are also interactions with other devices (for example the
>> apic/ioapic interaction via the apic bus).
>
>
> Hrm, maybe I'm missing it, but the path that would be hot is:
>
> if (!status_latched && !count_latched) {
>    value = kpit_elapsed()
>    // manipulate count based on mode
>    // mask value depending on read_state
> }
>
> This path is side-effect free, and applies relatively simple math to a
> time counter.

Do guests always read an unlatched counter?  Doesn't seem reasonable
since they can't get a stable count this way.

>
> The idea would be to allow the filter to not handle an I/O request
> depending on existing state.  Anything that's modifies state (like
> reading the latch counter) would drop to userspace.

This restricts us to a subset of the device which is at the mercy of the
guest.

>
>>
>>>
>>> If userspace had a way to upload bytecode to the kernel that was
>>> executed for a PIO operation, it could either pass the operation to
>>> userspace or handle it within the kernel when possible without taking
>>> a heavy weight exit.
>>>
>>> If the bytecode can access variables in a shared memory area, it could
>>> be pretty efficient to work with.
>>>
>>> This means that the kernel never has to deal with specific in-kernel
>>> devices but that userspace can accelerator as many of its devices as
>>> it sees fit.
>>
>> I would really love to have this, but the problem is that we'd need a
>> general purpose bytecode VM with binding to some kernel APIs.  The
>> bytecode VM, if made general enough to host more complicated devices,
>> would likely be much larger than the actual code we have in the
>> kernel now.
>
> I think the question is whether BPF is good enough as it stands.  I'm
> not really sure.

I think not.  It doesn't have 64-bit muldiv, required for hpet, for example.

>   I agree that inventing a new bytecode VM is probably not worth it.
>
>>>
>>> This could replace ioeventfd as a mechanism (which would allow
>>> clearing the notify flag before writing to an eventfd).
>>>
>>> We could potentially just use BPF for this.
>>
>> BPF generally just computes a predicate.
>
> Can it modify a packet in place?  I think a predicate is about right
> (can this io operation be handled in the kernel or not) but the
> question is whether there's a way produce an output as a side effect.

You can use the scratch area, and say that it's persistent.  But the VM
itself isn't rich enough.

>
>> We could overload the scratch
>> area for storing internal state and for read results, though (and have
>> an "mmio scratch register" for reading the time).
>
> Right.
>

We could define mmio registers for muldiv64, and for communicating over
the APIC bus.  But then the device model for BPF ends up more
complicated than the kernel devices we have put together.

-- 
error compiling committee.c: too many arguments to function

