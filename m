Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab2HTPIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab2HTPIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:08:38 -0400
Date: Mon, 20 Aug 2012 17:05:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120820150507.GC18499@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345463081.23018.34.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> +static void __task_work_run(struct callback_head *tail)
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
> +	struct callback_head **head = &current->task_works;
> +
> +	do {
> +		struct callback_head *work = xchg(head, NULL);
> +		while (work) {
> +			struct callback_head *next = ACCESS_ONCE(work->next);
> +
> +			WARN_ON_ONCE(work == &dead);
> +
> +			work->func(work);
> +			work = next;
>  		}
> -	}
> +	} while (cmpxchg(head, NULL, tail) != NULL);

Yes, we can add the explicit argument to __task_work_run(), but it can
check PF_EXITING instead, this looks simpler to me.

Note also your patch breaks fifo, but this is fixable.

Oleg.

