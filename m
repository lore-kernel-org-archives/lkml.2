Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243Ab0KRU25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:28:57 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63457 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229Ab0KRU2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qYrF09pNhEy9E4ekR8nzBiZ8qdjRo58ifY+5kaGvbQPbBI+4uvKOb3Ngu26KCfd7M8
         B1GEN7Opy+OavQ7rLSoWYEOauu292vw6dy03x6I03q/P0qzUQSQ4kmsZlVfGARNiqvqk
         u+S/Ds3nEmbYZTYOmsco3WLLvEDFh2hYPpSgw=
Date: Thu, 18 Nov 2010 23:28:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118202850.GD6028@lenovo>
References: <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118200807.GC8131@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:08:07PM -0500, Don Zickus wrote:
> On Thu, Nov 18, 2010 at 01:51:44PM -0600, Jason Wessel wrote:
> > > So the problem is when the nmi watchdog is enabled, the perf event is
> > > 'active' and thus tries to read the counter value.  Because it is always
> > > zero, perf just assumes the counter overflowed and the NMI is his.
> > >
> > > Not sure how to fix it yet, other than include the logic that detects we
> > > are on a guest and disable perf??
> > >
> > >   
> > 
> > I highly doubt we want to disable perf.   I would rather use the source
> > and fix the nmi emulation in KVM/Qemu after we hear back the results
> 
> Well I think Peter does not have a positive opinion about emulating perf
> inside a guest.  Nor are the KVM folks having much success in doing so.
> 
> Just to clarify, perf counter emulation is _not_ implemented in kvm.
> Therefore disabling perf in the guest makes sense until someone gets
> around to actually writing the emulation code for perf in a guest. :-)
> 
> Cheers,
> Don

 Don, Robert,

 I still have suspicious on ours 'pending' nmi handler. Look what I mean --
(keep in mind that p4 has a a way more counters than others).

 So lets consider the situation counters 1,2,3 activated, so we have
in 'active_mask' them set (lets say they are bits 1,2,3) and same time
the bits 1,2,3 is set in 'running' mask (they are set in x86_pmu_start).

 So then after small time period when no counters overflowed, the counter
2 were diactivated (for any reason), so that

 active_mask 1,3
 running     1,2,3

 Then nmi happens from counter 1, which calls for perf nmi handler,
which goes over all counters trying to figure out which counter just
being oveflowed. And when the cycle reaches counter 2 the interesting
thing happens

 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
		int overflow;

		if (!test_bit(idx, cpuc->active_mask)) {

--->			for counter 2 there is no active_mask bit set

			/* catch in-flight IRQs */
			if (__test_and_clear_bit(idx, cpuc->running))

--->				but it still set in running
				regardless that the counter were
				already freed and it give us false
				positive

				handled++;
			continue;
		}

 Guys, I have a gut feeling that I'm missing something obvious, no?

  Cyrill
