Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2FDJZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:25:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50156 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750973Ab2FDJZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:25:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tv4pl7Mltv188WrjVchRahIjPtaIzHA9Ng4qv/o
	9TByHfSNNH5gN7
Message-ID: <1338801907.7356.163.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Mike Galbraith <efault@gmx.de>
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 11:25:07 +0200
In-Reply-To: <4FCC4E3B.4090209@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 11:27 +0530, Prashanth Nageshappa wrote: 
> Based on the description in
> http://marc.info/?l=linux-kernel&m=133108682113018&w=2 , I was able to recreate
> a problem where in a SCHED_OTHER thread never gets runtime, even though there is
> one allowed CPU where it can run and make progress.
> 
> On a dual socket box (4 cores per socket, 2 threads per core) with following
> config:
> 0 8	1 9	4 12	5 13
> 2 10	3 11	6 14	7 15
> |__________|    |__________|
>  socket 1        socket 2
> 
> If we have following 4 tasks (2 SCHED_FIFO and 2 SCHED_OTHER) started in the
> following order:
> 1> SCHED_FIFO cpu hogging task bound to cpu 1
> 2> SCHED_OTHER cpu hogging task bound to cpus 3 & 9 - running on cpu 3
>    sleeps and wakes up after all other tasks are started
> 3> SCHED_FIFO cpu hogging task bound to cpu 3
> 4> SCHED_OTHER cpu hogging task bound to cpu 9
> 
> Once all the 4 tasks are started, we observe that 2nd task is starved of CPU
> after waking up. When it wakes up, it wakes up on its prev_cpu (3) where
> a FIFO task is now hogging the cpu. To prevent starvation, 2nd task
> needs to be pulled to cpu 9. However, between cpus 1, 9, cpu1 is the chosen
> cpu that attempts pulling tasks towards its core. When it tries pulling
> 2nd tasks towards its core, it is unable to do so as cpu1 is not in 2nd
> task's cpus_allowed mask. Ideally cpu1 should note that the task can be
> moved to its sibling and trigger that movement.

Isn't this poking the wrong spot?

Making load balancing try to correct a bad situation created by a gone
insane SCHED_FIFO task looks wrong to me.  Better would be to make sure
insane RT tasks cannot borrow runtime indefinitely.  End result of 100%
SCHED_FIFO is dead box, so whether we have a spot where we could place
poor doomed SCHED_OTHER task seems kinda moot. 

Also, seems everybody and his brother thinks their stuff is so critical
that they run stuff SCHED_FIFO/99, which is dainbramaged but seemingly
common practice.  To make the system more robust in the face of that
insanity, we _could_ perhaps tick SCHED_FIFO when budget is staying
exceeded, which would allow sane threads at the same prio to get CPU
instead of returning CPU to the criminally insane.  Better would be to
just detect elite sociopath, and noisily cancel his Unobtanium CPU Card.

-Mike

