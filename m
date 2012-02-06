Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2BFJeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 04:34:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2BFJeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 04:34:07 -0500
Message-ID: <4F2F9E89.7090607@redhat.com>
Date: Mon, 06 Feb 2012 11:34:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Gleb Natapov <gleb@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com> <4F2EAFF6.7030006@codemonkey.ws>
In-Reply-To: <4F2EAFF6.7030006@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 06:36 PM, Anthony Liguori wrote:
> On 02/05/2012 03:51 AM, Gleb Natapov wrote:
>> On Sun, Feb 05, 2012 at 11:44:43AM +0200, Avi Kivity wrote:
>>> On 02/05/2012 11:37 AM, Gleb Natapov wrote:
>>>> On Thu, Feb 02, 2012 at 06:09:54PM +0200, Avi Kivity wrote:
>>>>> Device model
>>>>> ------------
>>>>> Currently kvm virtualizes or emulates a set of x86 cores, with or
>>>>> without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
>>>>> PCI devices assigned from the host.  The API allows emulating the
>>>>> local
>>>>> APICs in userspace.
>>>>>
>>>>> The new API will do away with the IOAPIC/PIC/PIT emulation and defer
>>>>> them to userspace.  Note: this may cause a regression for older
>>>>> guests
>>>>> that don't support MSI or kvmclock.  Device assignment will be done
>>>>> using VFIO, that is, without direct kvm involvement.
>>>>>
>>>> So are we officially saying that KVM is only for modern guest
>>>> virtualization?
>>>
>>> No, but older guests may have reduced performance in some workloads
>>> (e.g. RHEL4 gettimeofday() intensive workloads).
>>>
>> Reduced performance is what I mean. Obviously old guests will
>> continue working.
>
> An interesting solution to this problem would be an in-kernel device VM.

It's interesting, yes, but has a very high barrier to implementation.

>
> Most of the time, the hot register is just one register within a more
> complex device.  The reads are often side-effect free and trivially
> computed from some device state + host time.

Look at arch/x86/kvm/i8254.c:pit_ioport_read() for a counterexample. 
There are also interactions with other devices (for example the
apic/ioapic interaction via the apic bus).

>
> If userspace had a way to upload bytecode to the kernel that was
> executed for a PIO operation, it could either pass the operation to
> userspace or handle it within the kernel when possible without taking
> a heavy weight exit.
>
> If the bytecode can access variables in a shared memory area, it could
> be pretty efficient to work with.
>
> This means that the kernel never has to deal with specific in-kernel
> devices but that userspace can accelerator as many of its devices as
> it sees fit.

I would really love to have this, but the problem is that we'd need a
general purpose bytecode VM with binding to some kernel APIs.  The
bytecode VM, if made general enough to host more complicated devices,
would likely be much larger than the actual code we have in the kernel now.

>
> This could replace ioeventfd as a mechanism (which would allow
> clearing the notify flag before writing to an eventfd).
>
> We could potentially just use BPF for this.

BPF generally just computes a predicate.  We could overload the scratch
area for storing internal state and for read results, though (and have
an "mmio scratch register" for reading the time).

-- 
error compiling committee.c: too many arguments to function

