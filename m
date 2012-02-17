Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2BQMea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:34:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53575 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2BQMe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:34:29 -0500
Message-ID: <1329482054.2293.273.camel@twins>
Subject: Re: [RFC PATCH 08/14] sched: normalize tg load contributions
 against runnable time
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 13:34:14 +0100
In-Reply-To: <1329348972.2293.189.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013826.20844.39042.stgit@kitami.mtv.corp.google.com>
	 <1329348972.2293.189.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 00:36 +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
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
> 
> >  static inline void __update_group_entity_contrib(struct sched_entity *se)
> >  {
> >         struct cfs_rq *cfs_rq = group_cfs_rq(se);
> >         struct task_group *tg = cfs_rq->tg;
> > +       int runnable_avg;
> >  
> >         se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
> >         se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;
> > +
> > +       /*
> > +        * Unlike a task-entity, a group entity may be using >=1 cpu globally.
> > +        * However, in the case that it's using <1 cpu we need to form a
> > +        * correction term so that we contribute the same load as a task of
> > +        * equal weight. (Global runnable time is taken as a fraction over 2^12.)
> > +        */
> > +       runnable_avg = atomic_read(&tg->runnable_avg);
> > +       if (runnable_avg < (1<<12)) {
> > +               se->avg.load_avg_contrib *= runnable_avg;
> > +               se->avg.load_avg_contrib /= (1<<12);
> > +       }
> >  } 
> 
> This seems weird, and the comments don't explain anything.
> 
> Ah,.. you can count runnable multiple times (on each cpu), this also
> means that the number you're using (when below 1) can still be utter
> crap.
> 
> Neither the comment nor the changelog mention this, it should, it should
> also mention why it doesn't matter (does it?).

Since we don't know when we were runnable in the window, we can take our
runnable fraction as a flat probability distribution over the entire
window.

The combined answer we're looking for is what fraction of time was any
of our cpus running.

Take p_i to be the runnable probability of cpu i, then the probability
that both cpu0 and cpu1 were runnable is pc_0,1 = p_0 * p_1, so the
probability that either was running is p_01 = p_0 + p_1 - pc_0,1.

The 3 cpu case becomes when was either cpu01 or cpu2 running, yielding
the iteration: p_012 = p_01 + p_2 - pc_01,2.

p_012 = p_0 + p_1 + p_2 - (p_0 * p_1 + (p_0 + p_1 - p_0 * p_1) * p_2)

Now for small values of p our combined/corrective term is small, since
its a product of small, which is smaller, however it becomes more
dominant the nearer we get to 1.

Since its more likely to get near to 1 the more CPUs we have, I'm not
entirely convinced we can ignore it.
