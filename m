Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0DSOny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:43:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0DSOnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:43:50 -0400
Subject: Re: [RFC patch] CFS fix place entity spread issue (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100418131302.GA3614@Krystal>
References: <20100418131302.GA3614@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 16:43:45 +0200
Message-ID: <1271688225.1488.237.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 09:13 -0400, Mathieu Desnoyers wrote:

OK, so looking purely at the patch:

> Index: linux-2.6-lttng.git/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-lttng.git.orig/kernel/sched_fair.c        2010-04-18 01:48:04.000000000 -0400
> +++ linux-2.6-lttng.git/kernel/sched_fair.c     2010-04-18 08:58:30.000000000 -0400
> @@ -738,6 +738,14 @@
>                 unsigned long thresh = sysctl_sched_latency;
>  
>                 /*
> +                * Place the woken up task relative to
> +                * min_vruntime + sysctl_sched_latency.
> +                * We must _never_ decrement min_vruntime, because the effect is

Nobody I could find decrements min_vruntime, and certainly
place_entity() doesn't change min_vruntime. So this is a totally
mis-guided comment.

> +                * that spread increases progressively under the Xorg workload.
> +                */
> +               vruntime += sysctl_sched_latency;

So in effect you change: 
  vruntime = max(vruntime, min_vruntime - thresh/2)
into
  vruntime = max(vruntime, min_vruntime + thresh/2)

in a non-obvious way and unclear reason.

> +               /*
>                  * Convert the sleeper threshold into virtual time.
>                  * SCHED_IDLE is a special sub-class.  We care about
>                  * fairness only relative to other SCHED_IDLE tasks,
> @@ -755,6 +763,9 @@
>                         thresh >>= 1;
>  
>                 vruntime -= thresh;
> +
> +               /* ensure min_vruntime never go backwards. */
> +               vruntime = max_t(u64, vruntime, cfs_rq->min_vruntime);

So the comment doesn't match the code, nor is it correct.

The code tries to implement clipping vruntime to min_vruntime, not
clipping min_vruntime, but then botches it by not taking wrap-around
into account.

Now, I know why your patch helps you (its in effect similar to what
START_DEBIT does for fork()), but getting the wakeup-preemption to do
something nice along with it is the hard part.

The whole perfectly fair scheduling thing is more-or-less doable
(dealing with tasks dying with !0-lag gets interesting, you'd have to
start adjusting global-timeline like things for that). But the thing is
that it makes for rather poor interactive behaviour.

Letting a task that sleeps long and runs short preempt heavier tasks
generally works well. Also, there's a number of apps that get a nice
boost from getting preempted before they can actually block on a
(read-like) systemcall, That saves a whole scheduler round-trip on the
wakeup side, so ping-pong like tasks love this too.

And then there is the whole signal delivery muck..

