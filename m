Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab1FPXD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 19:03:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab1FPXDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 19:03:54 -0400
Date: Fri, 17 Jun 2011 01:02:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from
 switching anon_vma->lock to mutex
Message-ID: <20110616230247.GB28557@elte.hu>
References: <1308097798.17300.142.camel@schen9-DESK>
 <1308134200.15315.32.camel@twins>
 <1308135495.15315.38.camel@twins>
 <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com>
 <20110615201216.GA4762@elte.hu>
 <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
 <20110616070335.GA7661@elte.hu>
 <20110616171644.GK2582@linux.vnet.ibm.com>
 <20110616202550.GA16214@elte.hu>
 <20110616210119.GD23624@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616210119.GD23624@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Jun 16, 2011 at 10:25:50PM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > > The funny thing about this workload is that context-switches are 
> > > > really a fastpath here and we are using anonymous IRQ-triggered 
> > > > softirqs embedded in random task contexts as a workaround for 
> > > > that.
> > > 
> > > The other thing that the IRQ-triggered softirqs do is to get the 
> > > callbacks invoked in cases where a CPU-bound user thread is never 
> > > context switching.
> > 
> > Yeah - but this workload didnt have that.
> > 
> > > Of course, one alternative might be to set_need_resched() to force 
> > > entry into the scheduler as needed.
> > 
> > No need for that: we can just do the callback not in softirq but in 
> > regular syscall context in that case, in the return-to-userspace 
> > notifier. (see TIF_USER_RETURN_NOTIFY and the USER_RETURN_NOTIFIER 
> > facility)
> > 
> > Abusing a facility like setting need_resched artificially will 
> > generally cause trouble.
> 
> If the task enqueued callbacks in the kernel, thus started a new 
> grace period, it might return to userspace before every CPUs have 
> completed that grace period, and you need that full completion to 
> happen before invoking the callbacks.
> 
> I think you need to keep the tick in such case because you can't 
> count on the other CPUs to handle that completion as they may be 
> all idle.
> 
> So when you resume to userspace and you started a GP, either you 
> find another CPU to handle the GP completion and callbacks 
> executions, or you keep the tick until you are done.

We'll have a scheduler tick in any case, which will act as a 
worst-case RCU tick.

My main point is that we need to check whether this solution improves 
performance over the current softirq code. I think there's a real 
chance that it improves things like VFS workloads, because it 
provides (much!) lower grace period latencies hence provides 
fundamentally better cache locality.

If a workload pays the cost of frequent scheduling then it might as 
well use a beneficial side-effect of that scheduling: high-freq grace 
periods ...

If it improves performance we can figure out all the loose ends. If 
it doesnt then the loose ends are not worth worrying about.

Thanks,

	Ingo
