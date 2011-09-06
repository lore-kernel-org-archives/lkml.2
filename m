Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1IFPPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:15:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1IFPP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:15:27 -0400
Date: Tue, 6 Sep 2011 11:14:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
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
Message-ID: <20110906151408.GA7459@redhat.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
 <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>
 <1314974826.1861.1.camel@twins>
 <4E612EA1.20007@goop.org>
 <1314996468.8255.0.camel@twins>
 <4E614FBD.2030509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E614FBD.2030509@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 02:50:53PM -0700, Jeremy Fitzhardinge wrote:
> On 09/02/2011 01:47 PM, Peter Zijlstra wrote:
> > On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> >>> I know that its generally considered bad form, but there's at least one
> >>> spinlock that's only taken from NMI context and thus hasn't got any
> >>> deadlock potential.
> >> Which one? 
> > arch/x86/kernel/traps.c:nmi_reason_lock
> >
> > It serializes NMI access to the NMI reason port across CPUs.
> 
> Ah, OK.  Well, that will never happen in a PV Xen guest.  But PV
> ticketlocks are equally applicable to an HVM Xen domain (and KVM guest),
> so I guess there's at least some chance there could be a virtual
> emulated NMI.  Maybe?  Does qemu do that kind of thing?
> 
> But, erm, does that even make sense?  I'm assuming the NMI reason port
> tells the CPU why it got an NMI.  If multiple CPUs can get NMIs and
> there's only a single reason port, then doesn't that mean that either 1)
> they all got the NMI for the same reason, or 2) having a single port is
> inherently racy?  How does the locking actually work there?

The reason port is for an external/system NMI.  All the IPI-NMI don't need
to access this register to process their handlers, ie perf.  I think in
general the IOAPIC is configured to deliver the external NMI to one cpu,
usually the bsp cpu.  However, there has been a slow movement to free the
bsp cpu from exceptions like this to allow one to eventually hot-swap the
bsp cpu.  The spin locks in that code were an attempt to be more abstract
about who really gets the external NMI.  Of course SGI's box is setup to
deliver an external NMI to all cpus to dump the stack when the system
isn't behaving.

This is a very low usage NMI (in fact almost all cases lead to loud
console messages).

Hope that clears up some of the confusion.

Cheers,
Don
