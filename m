Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0HDKS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:18:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab0HDKSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:18:54 -0400
Subject: Re: [PATCH 0/6] [RFC] Large weight differential leads to
 inefficient  load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>
In-Reply-To: <AANLkTimMyUd9BxXO5JxgpAiAKCJAS1xZiTXTgp+GKSU0@mail.gmail.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
	 <1280749178.1923.114.camel@laptop>
	 <AANLkTimMyUd9BxXO5JxgpAiAKCJAS1xZiTXTgp+GKSU0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 12:18:41 +0200
Message-ID: <1280917121.1923.931.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 14:28 -0700, Nikhil Rao wrote:

> I see your point here, and yes I agree having 1 nice-0 on one cpu, 512
> SCHED_IDLE tasks on another cpu and all other cpus idle is correct if
> we only considered fairness. However, we would also like to maximize
> machine utilization. The fitness function we would ideally like to
> optimize for is a combination of both fairness and utilization.

Sure, I see (and agree with) the fact that we want to optimize
utilization as well (although I bet the power management people might
feel otherwise :-)

> Thanks for your suggestions; I explored the first one a bit and I
> added a check into find_busiest_queue() (instead of
> find_busiest_group()) to skip a cpu if it has only 1 task on it (patch
> attached below - did you have something else in mind?). 

You might also need some changes to find_busiest_group(), suppose you
have a 4 cpu machine, with 2 groups of 2, now also assume you have 4
tasks, 2 of nice-0 and 2 idle, if both nice-0 are in the same group,
each on their own cpu, then f_b_g() could select that group as being the
busiest (its got W=2048, against W=4 of the other group after all).

Once you have that group, f_b_q() won't be able to do anything sensible.

> This fixes the
> example I posted in the RFC, but it doesn't work as well when the
> SCHED_NORMAL tasks have a sleep/wakeup pattern. I have some data below
> where the load balancer fails to fully utilize a machine. In these
> examples, I ran with the upstream kernel and with a kernel compiled
> with the check in fbq().

Right, so wakeup/sleep are indeed more interesting. For wakeup we also
have select_task_rq() to consider, it is responsible to choosing where
to run the newly woken task.

For sleeps we have new idle balancing, which is a lot like the regular
load-balancing but differs enough to need looking at.

>From the data you provided I cannot tell you which of these two is
responsible for the thing you see (although under-utilization suggests
the new-idle balancer), you can use perf/ftrace to look at what your
tasks are doing and how they could be doing it better (Arjan's timechart
might be a good help).

If they get woken to the wrong CPU, its select_task_rq(), if they leave
a CPU idle too long, its new idle balancing -- or possibly its something
I overlooked all together :-)

