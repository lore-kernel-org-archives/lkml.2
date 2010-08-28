Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0H1Hdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 03:33:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41249 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751748Ab0H1Hdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 03:33:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19be3pUpG5blzZxLthU8uiPdh7Oob4naH6jARJBGD
	lg4Lz+CgwhLKZw
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100827183830.GD22679@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop> <20100826234910.GB4194@Krystal>
	 <1282894960.1975.1666.camel@laptop>
	 <1282897192.7185.28.camel@marge.simson.net>
	 <20100827154334.GE14926@Krystal>  <20100827183830.GD22679@Krystal>
Content-Type: text/plain
Date: Sat, 28 Aug 2010 09:33:59 +0200
Message-Id: <1282980839.17756.81.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 14:38 -0400, Mathieu Desnoyers wrote: 
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > * Mike Galbraith (efault@gmx.de) wrote:
> > > On Fri, 2010-08-27 at 09:42 +0200, Peter Zijlstra wrote:
> > > > On Thu, 2010-08-26 at 19:49 -0400, Mathieu Desnoyers wrote:
> > > > > AFAIK, I don't think we would end up starving the system in any possible way.
> > > > 
> > > > Correct, it does maintain fairness.
> > > > 
> > > > > So far I cannot see a situation where selecting the next buddy would _not_ make
> > > > > sense in any kind of input-driven wakeups (interactive, timer, disk, network,
> > > > > etc). But maybe it's just a lack of imagination on my part. 
> > > > 
> > > > The risk is that you end up with always using next-buddy, and we tried
> > > > that a while back and that didn't work well for some, Mike might
> > > > remember.
> > > 
> > > I turned it off because it was ripping spread apart badly, and last
> > > buddy did a better job of improving scalability without it.
> > 
> > Maybe with the dyn min_vruntime feature proposed in this patchset we should
> > reconsider this. Spread being ripped apart is exactly what it addresses.

Dunno.  Messing with spread is a very sharp double edged sword.

I took the patch set out for a spin, and saw some negative effects in
that regard.  I did see some positive effects as well though, x264 for
example really wants round robin, so profits.  Things where preemption
translates to throughput don't care for the idea much.  vmark rather
surprised me, it hated this feature for some reason, I expected the
opposite.

It's an interesting knob, but I wouldn't turn it on by default on
anything but maybe a UP desktop box.

(i kinda like cgroups classified by pgid for desktop interactivity under
load, works pretty darn well)

> I'm curious: which workload was showing this kind of problem exactly ?

Hm, I don't recall exact details.  I was looking at a lot of different
load mixes at the time, mostly interactive and batch, trying to shrink
the too darn high latencies seen with modest load mixes.

I never tried to figure out why next buddy had worse effect on spread
than last buddy (not obvious to me), just noted the fact that it did.  I
recall that it had a large negative effect on x264 throughput as well.

	-Mike

some numbers:

35.3x = DYN_MIN_VRUNTIME

netperf TCP_RR
35.3              97624.82   96982.62   97387.50   avg 97331.646 RR/sec  1.000
35.3x             95044.98   95365.52   94581.92   avg 94997.473 RR/sec   .976

tbench 8
35.3               1200.36    1200.56    1199.29   avg 1200.070 MB/sec   1.000
35.3x              1106.92    1110.50    1106.58   avg 1108.000 MB/sec    .923

x264 8
35.3                407.12     408.80     414.60   avg 410.173 fps       1.000
35.3x               428.07     436.43     438.16   avg 434.220 fps       1.058

vmark
35.3                149678     149269     150584   avg 149843.666 m/sec  1.000
35.3x               120872     120932     121247   avg 121017.000 m/sec   .807

mysql+oltp
                      1          2          4          8         16         32         64        128        256
35.3           10956.33   20747.86   37139.27   36898.70   36575.90   36104.63   34390.26   31574.46   29148.01
               10938.44   20835.17   37058.51   37051.71   36630.06   35930.90   34464.88   32024.50   28989.14
               10935.72   20792.54   37238.17   36989.97   36568.37   35961.00   34342.54   31532.39   29235.20
         avg   10943.49   20791.85   37145.31   36980.12   36591.44   35998.84   34399.22   31710.45   29124.11

35.3x          10944.22   20851.09   35609.32   35744.05   35137.49   33362.16   30796.03   28286.87   25105.84
               10958.68   20811.93   35604.57   35610.71   35147.65   33371.81   30877.52   28325.79   25113.85
               10962.72   20745.81   35728.36   35638.23   35124.56   33336.20   30794.99   28225.99   25202.88
         avg   10955.20   20802.94   35647.41   35664.33   35136.56   33356.72   30822.84   28279.55   25140.85
    vs 35.3       1.001      1.000       .959       .964       .960       .926       .896       .891       .863


