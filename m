Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2FOKDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:03:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:41261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2FOKDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:03:19 -0400
Message-ID: <1339754590.2559.51.camel@twins>
Subject: Re: [RFC][PATCH 2/4] sched: Push put_prev_task() into
 pick_next_task()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 12:03:10 +0200
In-Reply-To: <4FDB050F.7040503@parallels.com>
References: <20120614132902.800827488@chello.nl>
	 <20120614133212.690691207@chello.nl> <4FDB050F.7040503@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 13:49 +0400, Glauber Costa wrote:
> On 06/14/2012 05:29 PM, Peter Zijlstra wrote:
> > +static struct task_struct *
> > +pick_next_task_rt(struct rq *rq, struct task_struct *prev)
> >   {
> > -	struct task_struct *p = _pick_next_task_rt(rq);
> > +	struct task_struct *p;
> > +	struct rt_rq *rt_rq =&rq->rt;
> > +
> > +	if (!rt_rq->rt_nr_running)
> > +		return NULL;
> > +
> > +	if (rt_rq_throttled(rt_rq))
> > +		return NULL;
> > +
> > +	if (prev)
> > +		prev->sched_class->put_prev_task(rq, prev);
> > +
> it might be me, but this one sounds strange. If the responsibility of 
> putting the task now lays with pic_next_task, you can't return NULL 
> without doing this first.

Its the responsibility of the sched_class::pick_next_task implementation
that will return the next task. Not of the first one called.

Clearly this needs a comment.. /me adds.

---
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1096,6 +1096,11 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
+	/*
+	 * It is the responsibility of the pick_next_task() method that will
+	 * return the next task to call put_prev_task() on the @prev task or
+	 * something equivalent.
+	 */
 	struct task_struct * (*pick_next_task) (struct rq *rq,
 						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);

