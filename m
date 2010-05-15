Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0EORHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 13:07:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:53360 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751054Ab0EORHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 13:07:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/v4AR9963vmE0NV3Cxnz5LiDEZUuO7c5d0eEmNOU
	aVrSS3tEYc4vs3
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1273925052.1674.138.camel@laptop>
References: <1273924628.10630.24.camel@marge.simson.net>
	 <1273925052.1674.138.camel@laptop>
Content-Type: text/plain
Date: Sat, 15 May 2010 19:07:02 +0200
Message-Id: <1273943222.8752.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 14:04 +0200, Peter Zijlstra wrote:
> On Sat, 2010-05-15 at 13:57 +0200, Mike Galbraith wrote:
> > Hi Peter,
> > 
> > This commit excluded RT tasks from rq->load, was that intentional?  The
> > comment in struct rq states that load reflects *all* tasks, but since
> > this commit, that's no longer true.
> 
> Right, because a static load value does not accurately reflect a RT task
> which can run as long as it pretty well pleases. So instead we measure
> the time spend running !fair tasks and scale down the cpu_power
> proportionally.
> 
> > Looking at lmbench lat_udp in a PREEMPT_RT kernel, I noticed that
> > wake_affine() is failing for sync wakeups when it should not.  It's
> > doing so because the waker in this case is an RT kernel thread
> > (sirq-net-rx) - we subtract the sync waker's weight, when it was never
> > added in the first place, resulting in this_load going gaga.  End result
> > is quite high latency numbers due to tasks jabbering cross-cache.
> > 
> > If the exclusion was intentional, I suppose I can do a waker class check
> > in wake_affine() to fix it.
> 
> So basically make all RT wakeups sync?

I was going to just skip subtracting waker's weight ala

        /*
         * If sync wakeup then subtract the (maximum possible)
         * effect of the currently running task from the load
         * of the current CPU:
         */
	if (sync && !task_has_rt_policy(curr))
		...

	-Mike

