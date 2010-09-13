Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0IMRpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:45:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60033 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752474Ab0IMRpg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:45:36 -0400
Date: Mon, 13 Sep 2010 13:45:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime
	with wall time
Message-ID: <20100913174533.GA15653@Krystal>
References: <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal> <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:40:01 up 233 days, 19:16,  5 users,  load average: 0.53, 0.22,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Mon, Sep 13, 2010 at 9:16 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > OK, the long IRC discussions we just had convinced me that the current scheme
> > takes things into account by adapting the granularity dynamically, but also got
> > me to notice that check_preempt seems to compare vruntime with wall time, which
> > is utterly incorrect. So maybe all my patch was doing was to expose this bug:
> 
> Do you have latency numbers for this patch?

Sure, see below,

In addition to this patch, I also used Peter's approach of reducing the minimum
granularity (given that now I am confident that the value of
sysctl_sched_min_granularity won't affect the preemption granularity directly,
but rather indirectly through the period length). The result, succinctly, is
that just the "check_preempt" fix does not seem to do much difference in terms
of fork wakeup latency (the results below give an order of magnitude, but should
be taken with a grain of salt due to the noise). I ran 3 the tests 3 times each,
and took the average, but there is clearly some noise.

FWIW, Xorg and firefox feel _much more_ responsive with the fix I propose when
running with a make -j10. The system is even usable with a make -j20 on my UP
machine, even though I can start feeling a some lag. This is probably a more
important, yet less scientific, result.

It turns out that the min_granularity value (and hence the associated nr_latency
values) have been brought from 20 down to 5
(commit 722aab0c3bbd7648d66790515c14d95d10a15bf3), and then down to 3 lately
(commit 21406928afe43f1db6acab4931bb8c886f4d04ce). I would not be surprised that
this last change might have been trying to hide the vruntime vs wall time
comparison bug, which has been introduced in
commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb.


2.0GHz Pentium M

* wakeup-latency.c (SIGEV_THREAD) with make -j10 

- Mainline 2.6.35.2 kernel

maximum latency: 45762.1 탎
average latency: 7348.6 탎
missed timer events: 0

- check_preempt fix

maximum latency: 39858.9 탎
average latency: 7728.1 탎
missed timer events: 0

- With only Peter's smaller min_gran (shown below):

maximum latency: 29100.6 탎
average latency: 6684.1 탎
missed timer events: 0

- check_preempt fix + Peter's smaller min_gran:
maximum latency: 20433.0 탎
average latency: 5112.5 탎
missed timer events: 0

Thanks,

Mathieu


Diminish min granularity patch:

---
 kernel/sched_fair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -54,13 +54,13 @@ enum sched_tunable_scaling sysctl_sched_
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

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
