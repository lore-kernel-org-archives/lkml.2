Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1CVUDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:03:36 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59517 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753775Ab1CVUDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:03:33 -0400
Date: Tue, 22 Mar 2011 15:02:34 -0500
From: Jack Steiner <steiner@sgi.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110322200234.GA10441@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <20110321175110.GL1239@redhat.com> <20110321182235.GA14562@sgi.com> <20110321193740.GN1239@redhat.com> <20110322171118.GA6294@sgi.com> <20110322184450.GU1239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322184450.GU1239@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 02:44:50PM -0400, Don Zickus wrote:
> On Tue, Mar 22, 2011 at 12:11:18PM -0500, Jack Steiner wrote:
> > How certain are you that multiple NMIs triggered at about the same time will
> > deliver discrete NMI events? I updated the patch so that I'm running with:
> 
> I think as long as there isn't more than two (1 active, 1 latched), you
> would be ok.  A third one looks like it would get dropped.

Hmmm. Although extremely unlikely, would that mean that a problem exists
if there are 3 NMI sources: ie., kdb/kgdb, hw_perf & UV.


> 
> > 
> > 	- no special code in traps.c (I removed the traps.c code that was
> > 	  in the patch I posted)
> > 	- used die_notifier for calling the UV nmi handler
> > 	- UV priority is higher than the hw_perf priority
> > 
> > Both hw_perf (perf top) & UV NMIs work correctly under light loads. However, if I
> > run for 10 - 15 minutes injecting UV NMIs at a rate of about 30/min, "perf top"
> > stops generating output. Strace shows that it continues to poll() but no data
> > is received.
> 
> That's a low frequency and it still gets stuck?

Yes. Usually take about a minute.

The current NMI mechanism from our node controller limits the NMI
rate to about 1 every 2 sec for the current config that I'm running on.


> 
> > 
> > While "perf top" is hung, if I inject an NMI into the system in a way that will NOT
> > be consumed by the UV nmi handler, "perf top" resumes output but will stop again after
> > a few minutes.
> 
> So that means the PMU set its interrupt bit but the cpu failed to get the
> NMI.

That is what it looks like.


> 
> > 
> > 
> > AFAICT, the UV nmi handler is not consuming extra NMI interrupts. I can't
> > rule out that I'm missing something but I don't see it.
> 
> What happens if you put the UV nmi handler below the hw_perf handler in
> priority?  I assume the DIE_NMIUNKNOWN snippet in the hw_perf handler will
> swallow some of the UV NMIs, but more importantly does it still generate
> the hang you see?

I'll try that although it may be tomorrow AM before I get a chance.


> 
> > 
> > 
> > Do you have any ideas or clues???
> 
> Part of the problem is most of the NMI testing is done with perf and maybe
> kgdb.  So high frequency NMI sharing is probably exposing more bugs.
> 
> Also is it a problem to move your testing on to the latest upstream code
> instead of RHEL-6?  Not all the latest NMI work is there.  I want to make
> sure we are all starting at the same code. :-)

Sure.

--- jack

> 
> Cheers,
> Don
> 
> > 
> > 
> > > 
> > > > 
> > > > The root cause of the problem is that architecturally, x86 does not
> > > > have a way to identifies the source(s) that cause an NMI. If multiple
> > > > events occur at about the same time, there is no way that I can see that the
> > > > OS can detect it.
> > > 
> > > There are registers we can check to see who owns trigger the NMI (at least
> > > for the perf code, the SGI code maybe not, which is why I set it to a
> > > lower priority to be a catch-all).
> > > 
> > > I'm not aware of the x86 architecture dropping NMIs, so they should all
> > > get processed.  It is just a matter of which subsystems get determine if
> > > they are the source of the NMI or not.
> > > 
> > > > 
> > > > > 
> > > > > My first impression is the skip nmi logic in the perf handler is probably
> > > > > accidentally thinking the SGI external nmi is the perf's 'extra' nmi it is
> > > > > supposed to skip and thus swallows it.  At least that is the impression I
> > > > 
> > > > Agree
> > > > 
> > > > 
> > > > > get from the RedHat bugzilla which says SGI is running 'perf top', getting
> > > > > a hang, then pressing their nmi button to see the stack traces.
> > > > > 
> > > > > Jack,
> > > > > 
> > > > > I worked through a number of these issues upstream and I already talked to
> > > > > George and Russ over here at RedHat about working through the issue over
> > > > > here with them.  They can help me get access to your box to help debug.
> > > > 
> > > > Russ is right down the hall.
> > > 
> > > Great!
> > > 
> > > Cheers,
> > > Don
