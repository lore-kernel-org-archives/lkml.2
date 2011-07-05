Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1GEOTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:19:18 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:55294 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GEOTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:19:17 -0400
Date: Tue, 5 Jul 2011 18:19:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705141913.GD4060@sun>
References: <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
 <20110705133105.GB5843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705133105.GB5843@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 03:31:05PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > So the question is, why does the NMI watchdog prevent 'perf top' 
> > > from working on a P4?
> > 
> > because the NMI watchdog is a pinned event, you don't want to share 
> > the counter, that would be very bad, suppose you lock up when the 
> > NMI watchdog was scheduled out. Unreliably debug tools are worse 
> > than no tools.
> 
> Yeah, indeed that explains the symptom.
> 
> Firstly, we should fix/enhance perf top to print out an error message 
> in this case, not just hang there doing nothing.

It waits for event to be scheduled, so seems first the kernel should
have top level context-schedule-in functions changed from void to
int (so I have admit I might be missin something here).

> 
> Secondly, the proper solution would be to allow the multiplexing of 
> like-minded hw events. Here if we have two events:
> 
>   - pinned NMI watchdog, set to a period of 2 billion cycles
>   - perf top with a default of 1 khz auto-freq cycles
> 
> We should first change the NMI watchdog to use auto-freq samples - 
> the hw_nmi_get_sample_period() looks unnecessary - if we set the NMI 
> watchdog to 1 Hz by default it should be more than enough.

Should we drop tunability of watchdog period as well? At moment
there is a way to setup period via /sys.

> 
> Thus we'd have two events:
> 
>   - pinned NMI watchdog, set to 1 Hz
>   - perf top, set to 1000 Hz
> 
> The 1000 Hz event could serve the 1 Hz event just fine.
> 
> Thirdly, even if we mucked the NMI event to be somewhat different 
> from the real cycles event (so the P4 PMU can co-schedule it with 
> perf top), the real solution there would *still* be to express this 
> as a variation of a cycles event: use the same trick to allow up to 
> two cycles events to be present in the PMU - but hide this from the 
> generic interfaces, just allow up to two cycles events to be 
> scheduled at once.

This sounds like event aliases PeterZ was proposed pretty ago, I tried
it but didn't success, one of problem was that current p4 code structure
does not care how exactly events came into, it simply checks for registers
resource being 'free' and schedule event in if possible.

I will try to implement aliases again, probably there is still a way
and I overlooked it in first place.

> 
> This will have the advantage of not only fixing the NMI watchdog, but 
> other users as well.
> 
> Now, if there's some real behavioral difference between the two 
> events (one is halted cycles the other is unhalted cycles), then i'd 
> suggest to use PERF_COUNT_HW_BUS_CYCLES in the NMI watchdog - that is 
> the generic 'constant frequency' cycles event.

Should not be much difference here as far as I can tell.

> 
> So there's lots of options to fix/improve this more intelligently.
> 

	Cyrill
