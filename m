Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0DSJZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:25:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:59014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0DSJZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:25:40 -0400
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
Date: Mon, 19 Apr 2010 11:25:35 +0200
Message-ID: <1271669135.1674.615.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 09:13 -0400, Mathieu Desnoyers wrote:

> Detailed explanation in my ELC2010 presentation at:
> 
> http://www.efficios.com/elc2010

So what happened to comprehensive changelogs?

> I've torn the CFS scheduler apart in the past days to figure out what is causing
> this weird behavior, and the culprit seems to be place_entity(). The problem
> appears to be the cumulative effect of letting the min_vruntime go backward when
> putting sleepers back on the runqueue.

Right, that should not happen, ever, min_vruntime should be monotonic.
Your explanation fails to mention how exactly this happens.

>  It lets the vruntime spread grow to
> "entertaining" values (it is supposed to be in the 5ms range, not 18 minutes!).
> 
> In the original code, a max between the sched entity vruntime and the calculated
> vruntime was supposed to "ensure that the thread time never go backward". But I
> don't see why we even care about that.

Fairness, a task's vruntime going backwards means it can obtain more
cputime than a while(1) loop would get, not a good thing.

>  The key point is that the min_vruntime
> of the runqueue should not go backward.

That is certainly important too.

> I propose to fix this by calculating the relative offset from
> min_vruntime + sysctl_sched_latency rather than directly from min_vruntime. I
> also ensure that the value never goes below min_vruntime.

I'm not sure that's a good idea, that'll end up being a 'fairer'
scheduler in the strict sense, but I suspect it will break the wakeup
preemption model we have.

> Under the Xorg workload, moving a few windows around and starting firefox while
> executing the wakeup-latency.c program (program waking up every 10ms and
> reporting wakeup latency), this patch brings worse latency from 60ms down to
> 12ms. Even doing a kernel compilation at the same time, the worse latency stays
> around 20ms now.

That seems nice enough. But really, this changelog doesn't explain the
cause at all.

/me goes try and figure out where this min_vruntime goes backwards.

So update_min_vruntime() is the sole place where we change min_vruntime,
it is called from update_curr() where we add runtime to the task we're
currently servicing, and dequeue_entity() where we remove someone from
the tree.

These two sites are the only places where min_vruntime can change
because only adding service to the leftmost task, or removal thereof can
make the min_vruntime go forward.

So update_min_vruntime():

 - takes the smaller vruntime between the current task and the leftmost
tree entry (current is not in the tree, and we can pass beyond the
leftmost waiting task due to limited preemption and minimum service
windows).

 - set min_vruntime to the larger between the existing min_vruntime and
the smallest vruntime.

So colour me confused if I'm not seeing min_vruntime going backwards...



