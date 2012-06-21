Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab2FUIl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:41:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:45766 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2FUIly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:41:54 -0400
Message-ID: <1340268104.21745.159.camel@twins>
Subject: Re: [RFC][PATCH 2/4] sched: Push put_prev_task() into
 pick_next_task()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 10:41:44 +0200
In-Reply-To: <4FE2CEB0.7080200@linux.vnet.ibm.com>
References: <20120614132902.800827488@chello.nl>
	 <20120614133212.690691207@chello.nl> <4FE2CEB0.7080200@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 15:35 +0800, Michael Wang wrote:
> > +pick_next_task_fair(struct rq *rq, struct task_struct *prev)
> >  {
> >  	struct task_struct *p;
> >  	struct cfs_rq *cfs_rq = &rq->cfs;
> > @@ -2999,6 +3000,9 @@ static struct task_struct *pick_next_tas
> >  	if (!cfs_rq->nr_running)
> >  		return NULL;
> > 
> > +	if (prev)
> > +		prev->sched_class->put_prev_task(rq, prev);
> > +
> >  	do {
> >  		se = pick_next_entity(cfs_rq);
> >  		set_next_entity(cfs_rq, se);
> > --- a/kernel/sched/idle_task.c
> > +++ b/kernel/sched/idle_task.c
> > @@ -22,8 +22,12 @@ static void check_preempt_curr_idle(stru
> >  	resched_task(rq->idle);
> >  }
> 
> Will it cause trouble when the last task on cfs_rq was dequeued before
> been putted?
> 
> The cfs_rq->nr_running will be 0 and we will miss the chance to put
> prev, will we?

pick_next_task_idle() will then do the put, no?
