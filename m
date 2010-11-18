Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542Ab0KRVCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:02:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477Ab0KRVCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:02:52 -0500
Date: Thu, 18 Nov 2010 16:02:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        ying.huang@intel.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118210231.GB11445@redhat.com>
References: <20101116184325.GB4823@redhat.com>
 <4CE2E3C3.6060800@windriver.com>
 <20101118080516.GJ32621@elte.hu>
 <4CE52048.5080802@windriver.com>
 <1290086232.2109.1507.camel@laptop>
 <20101118193247.GF18100@redhat.com>
 <4CE583D0.8050407@windriver.com>
 <20101118200807.GC8131@redhat.com>
 <20101118202850.GD6028@lenovo>
 <20101118203948.GE6028@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118203948.GE6028@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:39:48PM +0300, Cyrill Gorcunov wrote:
> On Thu, Nov 18, 2010 at 11:28:50PM +0300, Cyrill Gorcunov wrote:
> > On Thu, Nov 18, 2010 at 03:08:07PM -0500, Don Zickus wrote:
> > > On Thu, Nov 18, 2010 at 01:51:44PM -0600, Jason Wessel wrote:
> > > > > So the problem is when the nmi watchdog is enabled, the perf event is
> > > > > 'active' and thus tries to read the counter value.  Because it is always
> > > > > zero, perf just assumes the counter overflowed and the NMI is his.
> > > > >
> > > > > Not sure how to fix it yet, other than include the logic that detects we
> > > > > are on a guest and disable perf??
> > > > >
> > > > >   
> > > > 
> > > > I highly doubt we want to disable perf.   I would rather use the source
> > > > and fix the nmi emulation in KVM/Qemu after we hear back the results
> > > 
> > > Well I think Peter does not have a positive opinion about emulating perf
> > > inside a guest.  Nor are the KVM folks having much success in doing so.
> > > 
> > > Just to clarify, perf counter emulation is _not_ implemented in kvm.
> > > Therefore disabling perf in the guest makes sense until someone gets
> > > around to actually writing the emulation code for perf in a guest. :-)
> > > 
> > > Cheers,
> > > Don
> > 
> >  Don, Robert,
> > 
> >  I still have suspicious on ours 'pending' nmi handler. Look what I mean --
> > (keep in mind that p4 has a a way more counters than others).
> > 
> 
>  To be precise -- it seems this scenario may force the back-to-back
> nmi handler to eat unknown nmi.

That was the point of the change to do exactly that.

The problem is/was when you go to check to see if the period expired in
x86_perf_event_set_period(), you refresh the perf counter.  The next step
is to see if the event period has expired, if so disabled the 'active'
bit.

However, there is a race between when you refresh the counter to when you
actually disable it, such that you may cause the counter to overflow again
and thus generate another NMI.  The whole ->running thing was implemented
by Robert to try and check for that condition and eat the NMI as we have
no intention of handling it (because it is bogus).

The alternative is to use another rdmsrl to actually see if we trigger
another NMI.  This was deemed a performance hit for such a small case.

Cheers,
Don
