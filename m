Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0DAFcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:32:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:57968 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752516Ab0DAFcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:32:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19iCK9fMqpiZE/xwhLLEWnHY4Z9QU/wjp/VghW4Uq
	nHWaubIZ5/skyI
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Thu, 01 Apr 2010 07:32:20 +0200
Message-Id: <1270099940.6707.148.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 16:47 -0700, Suresh Siddha wrote:

> Issues in the current select_idle_sibling() logic in select_task_rq_fair()
> in the context of a task wake-up:
> 
> a) Once we select the idle sibling, we use that domain (spanning the cpu that
>    the task is currently woken-up and the idle sibling that we found) in our
>    wake_affine() decisions. This domain is completely different from the
>    domain(we are supposed to use) that spans the cpu that the task currently
>    woken-up and the cpu where the task previously ran.

Why does that matter?  If we find an idle shared cache cpu before we hit
the spanning domain, we don't use affine_sd other than maybe (unlikely)
for updating group scheduler shares.

> b) We do select_idle_sibling() check only for the cpu that the task is
>    currently woken-up on. If select_task_rq_fair() selects the previously run
>    cpu for waking the task, doing a select_idle_sibling() check
>    for that cpu also helps and we don't do this currently.

True, but that costs too.  Those idle checks aren't cheap.

> c) In the scenarios where the cpu that the task is woken-up is busy but
>    with its HT siblings are idle, we are selecting the task be woken-up
>    on the idle HT sibling instead of a core that it previously ran
>    and currently completely idle. i.e., we are not taking decisions based on
>    wake_affine() but directly selecting an idle sibling that can cause
>    an imbalance at the SMT/MC level which will be later corrected by the
>    periodic load balancer.

Yes, the pressing decision for this one wakeup is can we wake to a
shared cache and thus avoid cache misses.

IMHO, the point of the affinity decision isn't instant perfect balance,
it's cache affinity if at all possible without wrecking balance.  Load
balancing moves tasks for optimal CPU utilization, tasks waking each
other pull to a shared domain.. a tug-of-war that balances buddies over
time.  wake_affine()'s job is only to say "no, leave it where it was for
now".  I don't see any reason to ask wake_affine()'s opinion about an
idle CPU.  We paid for idle shared cache knowledge.

We certainly wouldn't want to leave the wakee on it's previous CPU only
because that CPU is idle, it would have to be idle and sharing cache.

That said, Nehalem may ramp better with select_idle_sibling() turned off
at the HT level, and ramp was it's motivation.  Maybe you could continue
checking until out of shared cache country, but that's more expensive.

The logic may not be perfect, but it really needs to become cheaper, not
more expensive.

	-Mike

