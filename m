Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0GBC56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 22:57:58 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34097 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0GBC55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 22:57:57 -0400
Date: Fri, 2 Jul 2010 11:57:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
       paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
Message-ID: <20100702025716.GA25499@linux-sh.org>
References: <20100624142804.431553874@chello.nl> <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com> <1277464589.32034.276.camel@twins> <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com> <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop> <1277996555.1917.205.camel@laptop> <20100701153112.GA13511@console-pimps.org> <1277998793.1917.212.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277998793.1917.212.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:39:53PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-01 at 16:31 +0100, MattFleming wrote:
> > On Thu, Jul 01, 2010 at 05:02:35PM +0200, Peter Zijlstra wrote:
> > > 
> > > Matt, you said it broke SH completely, but did you try perf stat? perf
> > > record is not supposed to work on SH due to the hardware not having an
> > > overflow interrupt.
> > 
> > perf record does work to some degree. It definitely worked before
> > applying your changes but not after. I admit I haven't really read the
> > perf event code, but Paul will know.
> 
> Ok, let me look at that again.
> 
Any perf record functionality observed is entirely coincidental and not
by design. It was something I planned to revisit, but most of what we
have right now is only geared at the one-shot perf stat case.

> > > Which made me think, what on SH guarantees we update the counter often
> > > enough not to suffer from counter wrap? Would it make sense to make the
> > > SH code hook into their arch tick handler and update the counters from
> > > there?
> > 
> > This was the way that the oprofile code used to work. Paul and I were
> > talking about using a hrtimer to sample performance counters as
> > opposed to piggy-backing on the tick handler.
> 
> Ah, for sampling for sure, simply group a software perf event and a
> hardware perf event together and use PERF_SAMPLE_READ.
> 
> But suppose its a non sampling counter, how do you avoid overflows of
> the hardware register?

At the moment it's not an issue since we have big enough counters that
overflows don't really happen, especially if we're primarily using them
for one-shot measuring.

SH-4A style counters behave in such a fashion that we have 2 general
purpose counters, and 2 counters for measuring bus transactions. These
bus counters can optionally be disabled and used in a chained mode to
provide the general purpose counters a 64-bit counter (the actual
validity in the upper half of the chained counter varies depending on the
CPUs, but all of them can do at least 48-bits when chained).

Each counter has overflow detection and asserts an overflow bit, but
there are no exceptions associated with this, so it's something that we
would have to tie in to the tick or defer to a bottom half handler in the
non-sampling case (or simply test on every read, and accept some degree
of accuracy loss). Any perf record functionality we implement with this
sort of scheme is only going to provide ballpark figures anyways, so it's
certainly within the parameters of acceptable loss in exchange for
increased functionality.

Different CPUs also implement their overflows differently, some will roll
and resume counting, but most simply stop until the overflow bit is
cleared.

My main plan was to build on top of the multi-pmu stuff, unchain the
counters, and expose the bus counters with their own event map as a
separate PMU instance. All of the other handling logic can pretty much be
reused directly, but it does mean that we need to be a bit smarter about
overflow detection/handling. Sampling and so on is also on the TODO list,
but is as of yet still not supported.
