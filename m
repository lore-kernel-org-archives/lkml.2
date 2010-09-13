Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0IMSYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:24:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0IMSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:24:10 -0400
Date: Mon, 13 Sep 2010 20:23:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH] sched: Improve latencies under load by decreasing minimum
 scheduling granularity
Message-ID: <20100913182355.GC20171@elte.hu>
References: <20100912203712.GD32327@Krystal>
 <1284382387.2275.265.camel@laptop>
 <1284383758.2275.283.camel@laptop>
 <20100913135621.GA13442@Krystal>
 <1284387398.2275.311.camel@laptop>
 <20100913161641.GA28707@Krystal>
 <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
 <20100913174533.GA15653@Krystal>
 <20100913180348.GA20171@elte.hu>
 <20100913181925.GA15107@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913181925.GA15107@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > > > On Mon, Sep 13, 2010 at 9:16 AM, Mathieu Desnoyers
> > > > <mathieu.desnoyers@efficios.com> wrote:
> > > > >
> > > > > OK, the long IRC discussions we just had convinced me that the current scheme
> > > > > takes things into account by adapting the granularity dynamically, but also got
> > > > > me to notice that check_preempt seems to compare vruntime with wall time, which
> > > > > is utterly incorrect. So maybe all my patch was doing was to expose this bug:
> > > > 
> > > > Do you have latency numbers for this patch?
> > > 
> > > Sure, see below,
> > > 
> > > In addition to this patch, [...]
> > 
> > Note, which is a NOP for your latency workload.
> > 
> > > [...] I also used Peter's approach of reducing the minimum granularity
> > 
> > Ok, that's the very first patch i sent yesterday morning - so we also 
> > have my numbers that it reduces latencies.
> > 
> > To move things along i'll apply it with your Reported-by and Acked-by 
> > line, ok?
> > 
> > We can also work on the other, more complex things after that, but first 
> > lets make some progress on the latency front ...
> 
> Yep, that's fine with me.
> 
> Thanks!

You are welcome!

Linus, Mathieu, you can test the granularity reduction patch via:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched/urgent

Patch also attached below.

Note, i'd like to keep this separate from the check_preempt() change - 
which only affects reniced tasks and isnt essential to these tests. (we 
want such things to be in separate commits, for bisectability)

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched: Improve latencies under load by decreasing minimum scheduling granularity


 kernel/sched_fair.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..a171138 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -54,13 +54,13 @@ enum sched_tunable_scaling sysctl_sched_tunable_scaling
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 2000000ULL;
-unsigned int normalized_sysctl_sched_min_granularity = 2000000ULL;
+unsigned int sysctl_sched_min_granularity = 750000ULL;
+unsigned int normalized_sysctl_sched_min_granularity = 750000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
-static unsigned int sched_nr_latency = 3;
+static unsigned int sched_nr_latency = 8;
 
 /*
  * After fork, child runs first. If set to 0 (default) then

