Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686Ab1IOTqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:46:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:46325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934627Ab1IOTqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:46:01 -0400
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
From: Peter Zijlstra <peterz@infradead.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Thu, 15 Sep 2011 21:45:54 +0200
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.916911903@chello.nl> <4E7235F6.1030303@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316115954.4060.23.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 21:35 +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-15 at 21:32 +0200, Peter Zijlstra wrote:
> > > > +static void wake_up_sem_queue_prepare(struct wake_list_head *wake_list,
> > > >                             struct sem_queue *q, int error)
> > > >   {
> > > > +   struct task_struct *p = ACCESS_ONCE(q->sleeper);
> > > >
> > > > +   get_task_struct(p);
> > > > +   q->status = error;
> > > > +   /*
> > > > +    * implies a full barrier
> > > > +    */
> > > > +   wake_list_add(wake_list, p);
> > > > +   put_task_struct(p);
> > > >   }
> > 
> > > I think the get_task_struct()/put_task_struct is not necessary:
> > > Just do the wake_list_add() before writing q->status:
> > > wake_list_add() is identical to list_add_tail(&q->simple_list, pt).
> > > [except that it contains additional locking, which doesn't matter here]
> 
> OK, I can't read properly.. so the problem with doing the
> wake_list_add() before the write is that the wakeup can actually happen
> before the write in case p already had a wakeup queued.

Ah, but if the wakeup happens early, we return from schedule with -EINTR
and re-acquire the sem_lock and re-test. Since we do this update from
under sem_lock it should serialize and come out all-right,.. right?
