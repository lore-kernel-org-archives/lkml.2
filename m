Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2H1Q7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:59:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab2H1Q7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:59:00 -0400
Date: Tue, 28 Aug 2012 19:01:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120828170121.GA30165@redhat.com>
References: <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com> <20120821183408.GA11721@redhat.com> <20120824185619.GA16719@redhat.com> <1346171342.2296.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346171342.2296.4.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Peter Zijlstra wrote:
>
> On Fri, 2012-08-24 at 20:56 +0200, Oleg Nesterov wrote:
> >
> > Peter, if you think it can work for you and if you agree with
> > the implementation I will be happy to send the patch.
>
> Yeah I think it would work, but I'm not sure why you're introducing the
> cmp_xchg helper just for this..

Please look at 1-4 the patches I sent (only 1-2 are relevant), I removed
this helper. Although I still think it makes sense, but of course not in
task_work.c.

>  struct callback_head *
>  task_work_cancel(struct task_struct *task, task_work_func_t func)
>  {
> -	unsigned long flags;
> -	struct callback_head *last, *res = NULL;
> -
> -	raw_spin_lock_irqsave(&task->pi_lock, flags);
> -	last = task->task_works;
> -	if (last) {
> -		struct callback_head *q = last, *p = q->next;
> -		while (1) {
> -			if (p->func == func) {
> -				q->next = p->next;
> -				if (p == last)
> -					task->task_works = q == p ? NULL : q;
> -				res = p;
> -				break;
> -			}
> -			if (p == last)
> -				break;
> -			q = p;
> -			p = q->next;
> +	struct callback_head **workp, *work;
> +
> +again:
> +	workp = &task->task_works;
> +	work = *workp;
> +	while (work) {
> +		if (work->func == func) {

But you can't dereference this pointer. Without some locking this
can race with another task_work_cancel() or task_work_run(), this
work can be free/unmapped/reused.

> +			if (cmpxchg(workp, work, work->next) == work)
> +				return work;

Or this can race with task_work_cancel(work) + task_work_add(work).
cmpxchg() can succeed even if work->func is already different.

> +static callback_head *task_work_pop(void)
>  {
> -	struct task_struct *task = current;
> -	struct callback_head *p, *q;
> -
> -	while (1) {
> -		raw_spin_lock_irq(&task->pi_lock);
> -		p = task->task_works;
> -		task->task_works = NULL;
> -		raw_spin_unlock_irq(&task->pi_lock);
> -
> -		if (unlikely(!p))
> -			return;
> -
> -		q = p->next; /* head */
> -		p->next = NULL; /* cut it */
> -		while (q) {
> -			p = q->next;
> -			q->func(q);
> -			q = p;
> -		}
> +	struct callback_head **head = &current->task_work;
> +	struct callback_head *entry, *old_entry;
> +
> +	entry = *head;
> +	for (;;) {
> +		if (!entry || entry == &dead)
> +			return NULL;
> +
> +		old_entry = entry;
> +		entry = cmpxchg(head, entry, entry->next);

Well, this obviously means cmpxchg() for each entry...

> ( And yeah, I know, its not FIFO ;-)

Cough. akpm didn't like fifo, Linus disliked it too...

And now you! Whats going on??? ;)

Oleg.

