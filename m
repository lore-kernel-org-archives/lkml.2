Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2GLACe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:02:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57590 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2GLACc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <1341431285.19870.15.camel@laptop>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
 <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com> <1341431285.19870.15.camel@laptop>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 Jul 2012 17:02:01 -0700
Message-ID: <CAPM31R+JdOUpFCtxj79Z9srDQ8MPSqCSecQEHXdHfz8T4DqB8A@mail.gmail.com>
Subject: Re: [PATCH 09/16] sched: normalize tg load contributions against
 runnable time
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 12:48 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> > Entities of equal weight should receive equitable distribution of cpu time.
> > This is challenging in the case of a task_group's shares as execution may be
> > occurring on multiple cpus simultaneously.
> >
> > To handle this we divide up the shares into weights proportionate with the load
> > on each cfs_rq.  This does not however, account for the fact that the sum of
> > the parts may be less than one cpu and so we need to normalize:
> >   load(tg) = min(runnable_avg(tg), 1) * tg->shares
> > Where runnable_avg is the aggregate time in which the task_group had runnable
> > children.
>
> I remember we had a bit of a discussion on this last time, I thought you
> were going to convince me this approximation was 'right'.


I thought I had :-)

Here's what I wrote previously:

"""
So, as an estimate it has the nice property that it's always a lower
bound on the true value.

Consider the two cases for runnable contributions across a pair of cpus:

Either they are disjoint by wall time, in which case they would have
accounted for the same amount were they actually on the same cpu.
Or they overlap, in which case that over-lap period would be an
additional run-delay incurred on one of them.

Then, the maximum amount we understate for a given overlap is n(n+1)/2
* k where k is the the width of the overlap and n is the number of
cpus we over-lapped on.

But then, n is bounded by num_cpus -- so on a small machine our error
is bounded (e.g. we can be no more than 1/3 less than true on 2
cpus). On a larger machine this term can be larger, however, if k is
of consequential size we know we accounted at least n*k so we're still
going to approach the ceiling of 1 very quickly at which point it
doesn't matter that we under-estimated. The flip side on a larger
machine is that if k is of inconsequential size then n*2 * k is still
tiny relative to the size of the machine and the accuracy of the
approximation matters less.
"""

I approach it from a slightly different angle, nonetheless, it's
coherent with your analysis in your next reply.

What I forgot to do here was add the comments to this effect.  Will do.


>
>
> Care to still do so.. the rationale used should at least live in a
> comment somewhere, otherwise someone will go silly trying to understand
> things later on.
>
