Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2HTPMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:12:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:54999 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab2HTPMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:12:18 -0400
Message-ID: <1345475530.23018.50.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 17:12:10 +0200
In-Reply-To: <20120820150507.GC18499@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <20120820150507.GC18499@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 17:05 +0200, Oleg Nesterov wrote:
> On 08/20, Peter Zijlstra wrote:
> >
> > +static void __task_work_run(struct callback_head *tail)
> >  {
> > -	struct task_struct *task = current;
> > -	struct callback_head *p, *q;
> > -
> > -	while (1) {
> > -		raw_spin_lock_irq(&task->pi_lock);
> > -		p = task->task_works;
> > -		task->task_works = NULL;
> > -		raw_spin_unlock_irq(&task->pi_lock);
> > -
> > -		if (unlikely(!p))
> > -			return;
> > -
> > -		q = p->next; /* head */
> > -		p->next = NULL; /* cut it */
> > -		while (q) {
> > -			p = q->next;
> > -			q->func(q);
> > -			q = p;
> > +	struct callback_head **head = &current->task_works;
> > +
> > +	do {
> > +		struct callback_head *work = xchg(head, NULL);
> > +		while (work) {
> > +			struct callback_head *next = ACCESS_ONCE(work->next);
> > +
> > +			WARN_ON_ONCE(work == &dead);
> > +
> > +			work->func(work);
> > +			work = next;
> >  		}
> > -	}
> > +	} while (cmpxchg(head, NULL, tail) != NULL);
> 
> Yes, we can add the explicit argument to __task_work_run(), but it can
> check PF_EXITING instead, this looks simpler to me.

I guess we could.. but I thought the explicit callback was simpler ;-)

> Note also your patch breaks fifo, but this is fixable.

Why do you care about the order? Iterating a single linked queue in fifo
seems more expensive than useful.
