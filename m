Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1IFSHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:07:37 -0400
Received: from claw.goop.org ([74.207.240.146]:50717 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1IFSHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:07:31 -0400
Message-ID: <4E66615E.8070806@goop.org>
Date: Tue, 06 Sep 2011 11:07:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com>
In-Reply-To: <20110906151408.GA7459@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 08:14 AM, Don Zickus wrote:
> On Fri, Sep 02, 2011 at 02:50:53PM -0700, Jeremy Fitzhardinge wrote:
>> On 09/02/2011 01:47 PM, Peter Zijlstra wrote:
>>> On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
>>>>> I know that its generally considered bad form, but there's at least one
>>>>> spinlock that's only taken from NMI context and thus hasn't got any
>>>>> deadlock potential.
>>>> Which one? 
>>> arch/x86/kernel/traps.c:nmi_reason_lock
>>>
>>> It serializes NMI access to the NMI reason port across CPUs.
>> Ah, OK.  Well, that will never happen in a PV Xen guest.  But PV
>> ticketlocks are equally applicable to an HVM Xen domain (and KVM guest),
>> so I guess there's at least some chance there could be a virtual
>> emulated NMI.  Maybe?  Does qemu do that kind of thing?
>>
>> But, erm, does that even make sense?  I'm assuming the NMI reason port
>> tells the CPU why it got an NMI.  If multiple CPUs can get NMIs and
>> there's only a single reason port, then doesn't that mean that either 1)
>> they all got the NMI for the same reason, or 2) having a single port is
>> inherently racy?  How does the locking actually work there?
> The reason port is for an external/system NMI.  All the IPI-NMI don't need
> to access this register to process their handlers, ie perf.  I think in
> general the IOAPIC is configured to deliver the external NMI to one cpu,
> usually the bsp cpu.  However, there has been a slow movement to free the
> bsp cpu from exceptions like this to allow one to eventually hot-swap the
> bsp cpu.  The spin locks in that code were an attempt to be more abstract
> about who really gets the external NMI.  Of course SGI's box is setup to
> deliver an external NMI to all cpus to dump the stack when the system
> isn't behaving.
>
> This is a very low usage NMI (in fact almost all cases lead to loud
> console messages).
>
> Hope that clears up some of the confusion.

Hm, not really.

What does it mean if two CPUs go down that path?  Should one do some NMI
processing while the other waits around for it to finish, and then do
some NMI processing on its own?

It sounds like that could only happen if you reroute NMI from one CPU to
another while the first CPU is actually in the middle of processing an
NMI - in which case, shouldn't the code doing the re-routing be taking
the spinlock?

Or perhaps a spinlock isn't the right primitive to use at all?  Couldn't
the second CPU just set a flag/counter (using something like an atomic
add/cmpxchg/etc) to make the first CPU process the second NMI?

But on the other hand, I don't really care if you can say that this path
will never be called in a virtual machine.

    J
