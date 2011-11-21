Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1KUQ7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:59:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:47430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1KUQ7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:59:37 -0500
Message-ID: <1321894767.28118.14.camel@twins>
Subject: Re: [RFC][PATCH 6/6] perf, tools: X86 RDPMC, RDTSC test
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, William Cohen <wcohen@redhat.com>,
        linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Date: Mon, 21 Nov 2011 17:59:27 +0100
In-Reply-To: <1321889842.28118.9.camel@twins>
References: <20111121145114.049265181@chello.nl>
	 <20111121145337.912104693@chello.nl>
	 <CABPqkBTg69-EzvtGVxdAuf=EvM6Maag_tGc_a7jE5LdMwDqRgw@mail.gmail.com>
	 <1321889842.28118.9.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 16:37 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-21 at 16:29 +0100, Stephane Eranian wrote:
> > Peter,
> > 
> > I don't see how this test and infrastructure handles the case where the event
> > is multiplexed. I know there is time_enabled and time_running. But those are
> > not sync'd to the moment of the rdpmc(). I think there needs to be some other
> > timestamp in the mmap struct so the user can compute a delta to then add to
> > time_enabled and time_running.
> 
> When the counter isn't actually on the PMU, ->index will be 0 and rdpmc
> should not be attempted.
> 
> > Unless, we assume the two time metrics are there ONLY to compute a scaling
> > ratio. In which case, I think, we don't need the delta because if we
> > can do rdpmc()
> > it means the event is currently scheduled and thus time_enabled and time_running
> > are both ticking which means the scaling ratio does not change since the moment
> > the event was scheduled in.
> 
> Right, you don't need delta to compute the scale, but its useful for
> user-space time based measurements, Arun wanted to do something like
> that.

I'm full of crap, of course that makes a difference :-)

Even when both running and enabled are incremented, the scaling does
still change: 3/2 != 4/3 etc..

Using that we can actually deal with the whole multiplexing thing
without ever having to fall back to read(), something like:


static u64 mmap_read_self(void *addr)
{
        struct perf_event_mmap_page *pc = addr;
        u32 seq, idx, time_mult, time_shift;
        u64 count, cyc, time_offset, enabled, running, delta;

        do {
                seq = pc->lock;
                barrier();

                enabled = pc->time_enabled;
                running = pc->time_running;

                if (enabled != running) {
                        cyc = rdtsc();
                        time_mult = pc->time_mult;
                        time_shift = pc->time_shift;
                        time_offset = pc->time_offset;
                } 

                idx = pc->index;
                count = pc->offset;
                if (idx)
                        count += rdpmc(idx - 1);

                barrier();
        } while (pc->lock != seq);

        if (enabled != running) {
                u64 quot, rem;

                quot = (cyc >> time_shift);
                rem = cyc & ((1 << time_shift) - 1);
                delta = time_offset + quot * time_mult + 
                        ((rem * time_mult) >> time_shift);
                
                enabled += delta;
                if (idx)
                        running += delta;
                
                quot = count / running;
                rem = count % running;
                count = quot * enabled + (rem * enabled) / running;
        }

        return count;
}

Now all I need to do is make sure pc->offset actually makes sense,
because currently it looks like we're off by a factor
event->hw.prev_count when idx is set.



