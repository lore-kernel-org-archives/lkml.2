Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0LTJDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:03:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab0LTJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:03:35 -0500
Message-ID: <4D0F1BD8.20601@redhat.com>
Date: Mon, 20 Dec 2010 11:03:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>	 <1292834372.8948.27.camel@marge.simson.net>  <4D0F1794.3010803@redhat.com> <1292835302.8948.35.camel@marge.simson.net>
In-Reply-To: <1292835302.8948.35.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 10:55 AM, Mike Galbraith wrote:
> >  >  >
> >  >  >   I don't want it to run now.  I want it to run before some other task.  I
> >  >  >   don't care if N other tasks run before both.  So no godlike powers
> >  >  >   needed, simply a courteous "after you".
> >  >
> >  >  Ponders that...
> >  >
> >  >  What if: we test that both tasks are in the same thread group, if so,
> >
> >  In my use case, both tasks are in the same thread group, so that works.
> >  I don't see why the requirement is needed though.
>
> Because preempting a perfect stranger is not courteous, all tasks have
> to play nice.

I don't want to preempt anybody, simply make the task run before me.

Further, this is a kernel internal API, so no need for these types of 
restrictions.  If we expose it to userspace, sure.

> >  >  use cfs_rq->next to pass the scheduler a HINT of what you would LIKE to
> >  >  happen.
> >
> >  Hint is fine, so long as the scheduler seriously considers it.
>
> It will take the hint if the target the target hasn't had too much cpu.

Since I'm running and the target isn't, it's clear the scheduler thinks 
the target had more cpu than I did [73].  That's why I want to donate 
cpu time.

[73] at least it'd be clear if the scheduler were globally fair.  As it 
is, I might be the only task running on my cpu, therefore in a cpu glut, 
while the other task shares the cpu with some other task and is 
currently waiting for its turn.

> >  >  If the current task on that rq is also in your group, resched
> >  >  it, then IFF the task you would like to run isn't too far right, it'll
> >  >  be selected.  If the current task is not one of yours, tough, you can
> >  >  set cfs_rq->next and hope it doesn't get overwritten, but you may not
> >  >  preempt a stranger.  If you happen to be sharing an rq, cool, you
> >  >  accomplished your yield_to().  If not, there's no practical way (I can
> >  >  think of) to ensure that the target runs before you run again if you try
> >  >  to yield, but you did your best to try to get him to the cpu sooner, and
> >  >  in a manner that preserves fairness without dangerous vruntime diddling.
> >  >
> >  >  Would that be good enough to stop (or seriously improve) cpu wastage?
> >
> >  The cross-cpu limitation is bothersome.  Since there are many cpus in
> >  modern machines, particularly ones used for virt, the probability of the
> >  two tasks being on the same cpu is quite low.
>
> What would you suggest?  There is no global execution timeline, so if
> you want to definitely run after this task, you're stuck with moving to
> his timezone or moving him to yours.  Well, you could sleep a while, but
> we know how productive sleeping is.

I don't know.  The whole idea of donating runtime was predicated on CFS 
being completely fair.  Now I find that (a) it isn't (b) donating 
runtimes between tasks on different cpus is problematic.

Moving tasks between cpus is expensive and sometimes prohibited by 
pinning.  I'd like to avoid it if possible, but it's better than nothing.

-- 
error compiling committee.c: too many arguments to function

