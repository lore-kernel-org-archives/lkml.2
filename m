Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab0KQAZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:25:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab0KQAZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:25:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=img4aNdFLnRJzhyp4a9bfAdoZwmT52rRaQzY1qgMe0zk4jR3LXpFjhH8j019lFv12s
         Id0vwbXhE62v5TITMNvw==
Date: Tue, 16 Nov 2010 16:25:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bodo Eggert <7eggert@gmx.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <alpine.LSU.0.999.1011170035050.5484@be1.lrz>
Message-ID: <alpine.DEB.2.00.1011161613030.23571@chino.kir.corp.google.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141345100.22262@chino.kir.corp.google.com> <alpine.LNX.2.00.1011152255580.17235@be10.lrz> <alpine.DEB.2.00.1011151537580.29081@chino.kir.corp.google.com>
 <alpine.LSU.0.999.1011170035050.5484@be1.lrz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Bodo Eggert wrote:

> The old oom killer's task was to guess the best victim to kill. For me, it 
> did a good job (but the system kept thrashing for too long until it kicked
> the offender). Looking at CAP_SYS_RESOURCE was one way to recognize 
> important processes.
> 

CAP_SYS_RESOURCE does not imply the task is important.

There's a problem when the kernel is oom; killing a thread that is getting 
work done is one of the most serious remedies the kernel will ever do to 
allow forward progress.  In almost all scenarios (except in some cpuset or 
memcg configurations), it's a userspace configuration issue that exhausts 
memory and the VM finds no other alternative.  CAP_SYS_RESOURCE threads 
have access to unbounded amounts of resources and thus can use an 
extremely large amount of memory very quickly and at a detriment to other 
threads that may be as important to more important.  Considering them any 
different is an unsubstantiated and undefined behavior that should not be 
considered in the heuristic _unless_ the administrator or the task itself 
tells the kernel via oom_score_adj of its priority.

> > The old heuristics were a mixture of arbitrary values that didn't adjust 
> > scores based on a unit and would often cause the incorrect task to be 
> > targeted because there was no clear goal being achieved.  The new 
> > heuristic has a solid goal: to identify and kill the most memory-hogging 
> > task that is eligible given the context in which the oom occurs.  If you 
> > disagree with that goal and want any of the old heursitics reintroduced, 
> > please show that it makes sense in the oom killer.
> 
> The first old OOM killer did the same as you promise the current one does,
> except for your bugfixes. That's why it killed the wrong applications and
> all the heuristics were added until the complaints stopped.
> 

No, the old oom killer did not always kill the application that used the 
most amount of memory; it considered other factors with arbitrary point 
deductions such as nice level, runtime, CAP_SYS_RAWIO, CAP_SYS_RESOURCE, 
etc.  We had to remove those heuristics internally in older kernels as 
well because it would often allow a task to runaway using a massive amount 
of memory because of leaks and kill everything else on the system before 
targeting the appropriate task.  At that point, it left the system with 
barely anything running and no work was getting done.

> Off cause I did not yet test your OOM killer, maybe it really is better.
> Heuristics tend to rot and you did much work to make it right.
> 
> I don't want the old OOM killer back, but I don't want you to fall
> into the same pits as the pre-old OOM killer used to do.
> 

Thanks, and that's why I'm trying to avoid additional heuristics such 
CAP_SYS_RESOURCE where the priority is _implied_ rather than _proven_.  If 
CAP_SYS_RESOURCE was defined to be more preferred to stay alive, then I'd 
have no argument; it isn't.

> > > PS) Mapping an exponential value to a linear score is bad. E.g. A
> > >     oom_adj of 8 should make an 1-MB-process as likely to kill as
> > >     a 256-MB-process with oom_adj=0.
> > > 
> > 
> > To show that, you would have to show that an application that exists today 
> > uses an oom_adj for something other than polarization and is based on a 
> > calculation of allowable memory usage.  It simply doesn't exist.
> 
> No such application should exist because the OOM killer should DTRT.
> oom_adj was supposed to let the sysadmin lower his mission-critical
> DB's score to be just lower than the less-important tasks, or to
> point the kernel to his ever-faulty and easily-restarted browser.
> 

oom_score_adj allows use to define when an application is using more 
memory than expected and is often helpful in cpuset, memcg, or mempolicy 
constrained cases as well.  We'd like to be able to say that 30% of 
available memory should be discounted from a particular task that is 
expected to use 30% more memory than others without getting preferred.  
oom_score_adj can do that, oom_adj could not.
