Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1LVD6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:58:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1LVD6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:58:30 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=AeyuYyoRGF4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=puUi8bHbO5-COIx8g_AA:9 a=b5IKaz63Mri_q0SreykA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324526308.5916.123.camel@gandalf.stny.rr.com>
Subject: Re: Subject: [PATCH 2/2] priority System V Semaphores
From: Steven Rostedt <rostedt@goodmis.org>
To: raz ben yehuda <raziebe@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lior Brafman <LBrafman@manz.com>,
        Torsten Scherer <TScherer@manz.com>,
        Rasty Slutsker <RSlutsker@manz.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 21 Dec 2011 22:58:28 -0500
In-Reply-To: <1324500515.5467.18.camel@raz>
References: <1324419795.20886.3.camel@raz>
	 <4EF2261F.4050002@colorfullife.com> <1324500515.5467.18.camel@raz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 22:48 +0200, raz ben yehuda wrote:
> On Wed, 2011-12-21 at 19:31 +0100, Manfred Spraul wrote:
> > Hi raz,
> > 
> > 
> > On 12/20/2011 11:23 PM, raz ben yehuda wrote:
> > > > From 25aa166505aff2561dd715c927c654d0bbb432ba Mon Sep 17 00:00:00 2001
> > > From: raz<raziebe@gmail.com>
> > > Date: Tue, 20 Dec 2011 22:54:56 +0200
> > >
> > >
> > > Add positioning routine find_pos. find_pos returns
> > > the place where to put the sleeper before.
> > > I sort only rt tasks, OTHER policy is pushed back in
> > > queue. I do not distinct between SCHED_RR and SCHED_FIFO
> > > policies and they are treated as a single policy
> > > for the sorting algorithm.
> > >
> > > SETPRIO operates only when user issues a single semop
> > > operation and not an array of opretions.
> > As far as I can see, the advantages of sysvsem are backward 
> > compatibility and the ability to use complex ops.
> > You propose to add a new feature that doesn't work on complex ops.
> > 
> > Are there any apps that use SETPRIO?
> > What is the use case?
> Vxworks is the use case. And there are plenty of companies with
> vxWorks software and in i believe they will migrate sooner or later to
> PreemptRT.  My current company uses old wrapper software that implements
> vxWorks semaphores as system V semaphores. vxWorks semaphores have a priority
> feature which is widely used.
> I will probably change it some time in the future to posix semaphores , but posix 
> semaphores are implemented in glibc with futexes and atomic ops and i rather 
> mess with kernel and not glibc. funny , but true. glibc is harder. 
> 
> > > SETFIFO is the default for backward compatbility.
> > >
> > > Signed-off-by: raz<raziebe@gmail.com>
> > > ---
> > >   ipc/sem.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > >   1 files changed, 49 insertions(+), 2 deletions(-)
> > >e
> > > diff --git a/ipc/sem.c b/ipc/sem.c
> > > index 90dc5a1..921056d 100644
> > > --- a/ipc/sem.c
> > > +++ b/ipc/sem.c
> > > @@ -1343,6 +1343,51 @@ static int get_queue_result(struct sem_queue *q)
> > >   	return error;
> > >   }
> > >
> > > +/*
> > > + * find the best place to put the task sorted by rt prio
> > > +*/
> > > +static struct list_head *find_pos(struct sem *curr, int alter,
> > > +		struct task_struct *p)
> > > +{
> > > +	struct sem_queue *q;
> > > +	struct sem_queue *ret_pos = NULL;
> > > +	struct list_head *tasks_queue =&curr->sem_pending;
> > > +
> > > +	if (!alter)
> > > +		return tasks_queue;
> > > +
> > Tasks that do not alter anything end up first - IMHO correct.
> > 
> > > +	if (!(curr->flags&  PRIO_SEM))
> > > +		return tasks_queue;
> > > +	/*
> > > +	 *  make no effort to sort SCHED_OTHER,
> > > +	 *  just push task to the back of the queue.
> > > +	*/
> > > +	if (!(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
> > > +		return tasks_queue;
> > > +	/*
> > > +	 *  make no distinction between SCHED_FIFO
> > > +	 *  and SCHED_RR policies.
> > > +	 */
> > > +	list_for_each_entry(q, tasks_queue, simple_list) {
> > > +		struct task_struct *t;
> > > +
> > > +		t  = q->sleeper;
> > > +		if (current->rt_priority == t->rt_priority) {
> > > +			/*
> > > +			* push in a FIFO manner
> > > +			* tasks in same priority
> > > +			*/
> > > +			ret_pos = q;
> > > +			continue;
> > > +		}
> > > +		if (current->rt_priority<  t->rt_priority)
> > > +			continue;
> > > +		return&q->simple_list;
> > > +	}
> > Here in the loop, non-alter tasks are evaluated as well.
> > I think that's wrong, it could starve non-alter tasks.
> > e.g. queue:
> > - high prio non-alter
> > - low prio non-alter.
> > 
> > Now a medium prio alter task is added.
> > I think it will end up in the wrong position (before the low-prio 
> > non-alter task), correct?
> hammm.. correct. thanks. I did not check non-alter tasks at all. The entire queue might be a total mess. 
> I will sort non alter tasks as well.
> Also, this patch is missing scenario where a task priority is changed whilst it is waiting. 
> I fixed that already. 
> 
> Who maintains this code ? 
> 

It's mainly core kernel code and only changes when true changes are
made. An update could be done to extend its use as long as it doesn't
break any tools in the process. IOW, it must stay backward compatible.

-- Steve


