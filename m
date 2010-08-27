Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0H0NOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:14:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56932 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0H0NOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AG3BiQYkZMDMXxahkJfPtfrZDY3tbcpG7z5vg4V4IuOn55FJsZcTJJLXtFrnevoXyH
         hBp33ZU9oNgFc608/aKW1FM6WF3j47MypHkQ0w2rO2n8w7ZiYNxUaoX67KCbrDW1o91s
         orK70LfvntFPzpmmsruobCOZSuCqEJV2rPlt4=
Date: Fri, 27 Aug 2010 15:14:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org
Subject: Re: [PATCH] workqueue: Add basic tracepoints to track workqueue
	execution
Message-ID: <20100827131405.GB5241@nowhere>
References: <20100821131402.577c4d75@infradead.org> <20100822040101.GE5258@nowhere> <4C72436A.8080000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C72436A.8080000@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:46:18AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 08/22/2010 06:01 AM, Frederic Weisbecker wrote:
> > On Sat, Aug 21, 2010 at 01:14:02PM -0700, Arjan van de Ven wrote:
> >>
> >> From: Arjan van de Ven <arjan@linux.intel.com>
> >> Date: Sat, 21 Aug 2010 13:07:26 -0700
> >> Subject: [PATCH] workqueue: Add basic tracepoints to track workqueue execution
> >>
> >> With the introduction of the new unified work queue thread pools,
> >> we lost one feature: It's no longer possible to know which worker
> >> is causing the CPU to wake out of idle. The result is that PowerTOP
> >> now reports a lot of "kworker/a:b" instead of more readable results.
> >>
> >> This patch adds a pair of tracepoints to the new workqueue code,
> >> similar in style to the timer/hrtimer tracepoints.
> >>
> >> With this pair of tracepoints, the next PowerTOP can correctly
> >> report which work item caused the wakeup (and how long it took):
> >>
> >> Interrupt (43)            i915      time   3.51ms    wakeups 141
> >> Work      ieee80211_iface_work      time   0.81ms    wakeups  29
> >> Work              do_dbs_timer      time   0.55ms    wakeups  24
> >> Process                   Xorg      time  21.36ms    wakeups   4
> >> Timer    sched_rt_period_timer      time   0.01ms    wakeups   1
> >>
> >> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > Ok, Linus applied it. That answers my doubts about the
> > route for this patch :)
> 
> I was planning to work on wq tracing in this devel cycle but yeah
> Arjan's patch seems like a good starting place.
> 
> We definitely need more tracing points tho.  Also, David was wondering
> whether it would be possible to have simple file based interface to
> monitor the current status of workers.  That's doable w/ tracing API,
> right?



Yeah but the ftrace API that handles statistics is a very basic thing.
It works well for measuring entities that won't be freed, like
for branch and function profiling for example.
But once you deal with entities that can disappear (like workqueue threads),
you need to handle all the locking by yourself.

You can have a look at kernel/trace/trace_workqueue.c. It's broken
as we have removed some workqueue tracepoints, so I planned to
remove it. It's a basic thing but perhaps you can restart from there.

I think there was also a race between reader and writer. A stat node
probably need to be read under rcu (and freed after a grace period).

