Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1AEEl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:41:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41270 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751144Ab1AEEl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:41:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18OLsIqTREO8kxbu6v8V5ActuM5SMrk+3fLvHNbyh
	JOVjsxlUGAdBep
Subject: [PATCH] Re: [PATCH] sched: Buggy comparison in check_preempt_tick
From: Mike Galbraith <efault@gmx.de>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Ranjit Manomohan <ranjitm@google.com>
In-Reply-To: <1293515293.6930.11.camel@marge.simson.net>
References: <1293236813-31550-1-git-send-email-venki@google.com>
	 <1293263418.6896.54.camel@marge.simson.net>
	 <AANLkTintN2e-NHB=USQ4RSi1LMrC8TxB7BB0MNpPscSB@mail.gmail.com>
	 <1293348184.6942.72.camel@marge.simson.net>
	 <1293515293.6930.11.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 05:41:17 +0100
Message-ID: <1294202477.9384.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going through my mailbox, I see this remains unaddressed.  I chose the
keep it option, but whack it and revisit later is also viable.

On Tue, 2010-12-28 at 06:48 +0100, Mike Galbraith wrote:
> On Sun, 2010-12-26 at 08:23 +0100, Mike Galbraith wrote:
> 
> > But anyway..
> > 
> > echo NO_WAKEUP_PREEMPT > sched_features
> > echo NO_TESTME > sched_features
> > two hogs running on isolcpu 3, pid 6890 at nice -2
> > 
> > while sleep 1; do  grep 'pert.*6890' /proc/sched_debug; done
> > 
> > runnable tasks:
> >             task   PID         tree-key  switches  prio
> > -------------------------------------------------------
> > R           pert  6890     50201.071851      7453   118
> > R           pert  6890     50596.171290      7513   118  +60
> > R           pert  6890     50991.265264      7572   118  +59
> > R           pert  6890     51383.781965      7631   118  +59
> >             pert  6890     51781.463129      7691   118  +60
> > 
> > echo TESTME > sched_features
> >             pert  6890    126881.306733     18977   118
> > R           pert  6890    127273.825719     19036   118  +59
> > R           pert  6890    127668.928218     19095   118  +59
> > R           pert  6890    128064.031372     19154   118  +59
> > R           pert  6890    128459.134339     19213   118  +59
> > 
> > ...with a compute load, the thing should be a noop, and appears to be so
> > (with busted compare fixed anyway;).  You have to be well overloaded for
> > buddies to kick in these days, so it's probably pretty hard to get
> > enough spread for the thing to fire.
> 
> I did a bit more testing yesterday with wakeup loads.  There's enough
> spread for the test to nudge things a few [0..4] times per second/core.
> 
> I'd either fix the comparison, and let it keep on nudging once in a
> while, or whack the whole thing.

sched: fix signed unsigned comparison in check_preempt_tick()

signed unsigned comparison may lead to superfluous resched if leftmost
is right of the current task, wasting a few cycles, and inadvertently
_lengthening_ the current task's slice.  

Reported-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.37.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.37.git.orig/kernel/sched_fair.c
+++ linux-2.6.37.git/kernel/sched_fair.c
@@ -872,7 +872,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
-		if (delta > ideal_runtime)
+		if (delta > (s64)ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }


