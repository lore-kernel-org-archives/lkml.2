Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2FDRQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:16:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35458 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2FDRQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:16:24 -0400
Message-ID: <1338830167.28282.115.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 19:16:07 +0200
In-Reply-To: <4FCCE823.8090700@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	     <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	    <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	   <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	  <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
	 <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 09:53 -0700, Arjan van de Ven wrote:
> > 
> > False, you can have 0 idle time and still have low load.
> 
> 1 is not low in this context fwiw.

I think you're mis-understanding the load number you're using. I suspect
you're expecting something like the load-avg top/uptime provide. You're
very much not using anything similar. 

Nor do we compute anything like that, and I want to avoid having to
compute anything like that because its expensive.

> >>  but because idle
> >> time tends to be bursty, we can still be idle for, say, a millisecond
> >> every 10 milliseconds. In this scenario, the load average is used to
> >> ensure that the 200 usecond cost of exiting idle is acceptable.
> > 
> > So what you're saying is that if you have 1ms idle in 10ms, it might not
> > be a continuous 1ms. And you're using load as a measure of how many
> > fragments it comes apart in?
> 
> no
> 
> what I'm saying is that if you have a workload where you have 10 msec of
> work, then 1 msec of idle, then 10 msec of work, 1 msec of idle etc etc,
> it is very different from 100 msec of work, 10 msec of idle, 100 msec of
> work, even though utilization is the same.

Sure..

> what the logic is trying to do, on a 10 km level, is to limit the damage
> of accumulated C state exit time.
> (I'll avoid the word "latency" here, since the real time people will
> then immediately think this is about controlling latency response, which
> it isn't)

But why? There's a natural limit to his, say the wakeup costs 0.2ms then
you can only do 5k of those a second. Once you need to actually do some
work as well this comes down.

But its all idle time, you cannot be idle longer than there is a lack of
work. So if you're idle too long (because of long exit latency) your
work shifts and the future idle time reduces, eventually causing a lower
C state to be used.

Also, when you notice you're waking up too soon, you can quickly ramp
down on the C state levels.

> Now, if you're very idle for a sustained duration (e.g. low load),
> you're assumed not sensitive to a bit of performance cost.
> but if you're actually busy (over a longer period, not just "right
> now"), you're assumed to be sensitive to the performance cost,
> and what the algorithm does is make it less easy to go into the
> expensive states.

My brain still sparks and fizzles when I read that.. it just doesn't
compute.

What performance? performance isn't a well defined word.

> the closest metric we have right now to "sensitive to performance cost"
> that I know of is "load average". If the scheduler has a better metric,
> I'd be more than happy to switch the idle selection code over to it...

I can't suggest anything better for something I've still no clue about.
You're completely failing to explain this thing to me.

> note that the idle selection code has 3 metrics, this is only one of them:
> 1. PM_QOS latency tolerance
> 2. Energy break even
> 3. Performance tolerance

That 3rd, I'm completely failing to understand.
