Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab0JSMi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:38:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0JSMiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:38:54 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=O21JH8oWZ5MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=4YC9ZLZlW7zBmXA5HJgA:9 a=0s76a9iGO5bt5fQno3_BXgIOo20A:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed
 when calling find_lowest_rq
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1287486167.1994.1.camel@twins>
References: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
	 <1287486167.1994.1.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 08:38:51 -0400
Message-ID: <1287491931.16971.358.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 13:02 +0200, Peter Zijlstra wrote:

> > Remove the check for nr_cpus_allowed of an RT task before calling
> > find_lowest_cpu() from select_task_rq_rt function. Cause
> > find_lowest_cpu checks for rt.nr_cpus_allowed of a process.
> > It would've been nice, if we make the check before calling
> > find_lowest_cpu. But its called from other places, so keep the
> > nr_cpus_allowed check into find_lowest_cpu().
> 

Yes it is redundant, but I'm wondering if we should modify
find_lowest_rq() just to short cut this case.

That is, instead of assigning all the variables on the stack, which I'm
thinking __get_cpu_var() may act like a barrier() where gcc can't
optimize. We should probably also do the following:

static int find_lowest_rq(struct task_struct *task)
{
	struct sched_domain *sd;
-	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
-	int this_cpu = smp_processor_id();
-	int cpu      = task_cpu(task);
+	struct cpumask *lowest_mask;
+	int this_cpu;
+	int cpu;

	if (task->rt.nr_cpus_allowed == 1)
		return -1; /* No other targets possible */

+	lowest_mask = __get_cpu_var(local_cpu_mask);
+	this_cpu = smp_processor_id();
+	cpu = task_cpu(task;


Then removing the redundant check may not hurt anything.

-- Steve


> > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> > ---
> > 
> > --- linus-rc8/kernel/sched_rt.c	2010-10-15 05:26:43.000000000 +0600
> > +++ rakib-rc8/kernel/sched_rt.c	2010-10-19 16:22:30.000000000 +0600
> > @@ -971,8 +971,7 @@ select_task_rq_rt(struct rq *rq, struct
> >  	 * that is just being woken and probably will have
> >  	 * cold cache anyway.
> >  	 */
> > -	if (unlikely(rt_task(rq->curr)) &&
> > -	    (p->rt.nr_cpus_allowed > 1)) {
> > +	if (unlikely(rt_task(rq->curr))) {
> >  		int cpu = find_lowest_rq(p);
> > 
> >  		return (cpu == -1) ? task_cpu(p) : cpu;


