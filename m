Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1HHVhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:37:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab1HHVhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:37:34 -0400
Date: Mon, 8 Aug 2011 17:37:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ZAK Magnus <zakmagnus@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
Message-ID: <20110808213721.GA1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
 <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
 <20110805134042.GJ1972@redhat.com>
 <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
 <20110805184323.GK20762@redhat.com>
 <CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
 <20110808201951.GY1972@redhat.com>
 <1312836771.22367.35.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312836771.22367.35.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:52:51PM +0200, Peter Zijlstra wrote:
> Since its the NMI context that's generating the data, disabling IRQs
> will obviously not do much good.
> 
> Also, if you've got a procfs output, what do you need irq_work for?
> 
> Depending on the type of data and kind of data loss you can incur, would
> a static per-cpu buffer be ok? You can guard it by a single bit, if
> cleared NMI can write, if set NMI will skip over and loose the data.
> 
> Then your procfs routine can set the bit, dump out the latest version of
> the data and clear the bit again. If you always want the NMI thing to be
> able to write, use two buffers, if you 'lock' then one at a time,
> there's always one writable.
> 
> All you need is atomic bitops :-)
> 
> > > > The softstall case should be ok though.
> > > Why's that? The soft stall traces are not written in a NMI context but
> > > just in a regular interrupt context, right? Doesn't that pose similar
> > > problems?
> 
> You should be able to do stack traces from NMI context, that's what perf
> does after all.
> 
> > > These are weird rare corner cases anyway, right? Maybe the simplest
> > > thing could be to let the interrupts only try_lock(), so they might
> > > sometimes fail to record a stall, but it would be a pretty big
> > > coincidence.
> 
> Sure you can do a trylock. I'm still not quite sure what you want the
> irq_work for.. there's no guarantee the interrupt runs immediately after
> the NMI, it could be the NMI is in the middle of a irq disabled region,
> or the whole thing is ran on an architecture without
> arch_irq_work_raise().

Maybe irq_work isn't what we needed.  I just wasn't smart enough to figure
out how to make sure we can write data in an NMI context and read it in a
normal context.  I supposed the whole swapping buffers could work and is
simpler.

Basically, Zak was working on a way to save stack traces of potential
hard/soft lockups (ones that lockup for a minimum amount of time but
un-lockup before actually triggering anything).  The idea was to get
visibility of who is spending time doing some wrong before it is too late.

Cheers,
Don

