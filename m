Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423009Ab2JaOgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:36:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42714 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427Ab2JaOgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:36:16 -0400
Subject: Re: [PATCH] [RFC]IRQ CORE: irq_work_queue function return value
 not used.
From: anish kumar <anish198519851985@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
In-Reply-To: <1351692914.4004.83.camel@gandalf.local.home>
References: <1351692126-8944-1-git-send-email-anish198519851985@gmail.com>
	 <1351692914.4004.83.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 23:36:06 +0900
Message-ID: <1351694166.1504.36.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 10:15 -0400, Steven Rostedt wrote:
> On Wed, 2012-10-31 at 23:02 +0900, anish kumar wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> > As no one is using the return value of irq_work_queue function
> > it is better to just make it void.
> > 
> > This patch is just a way to understand if there is some future
> > plan to use it but in any case please let me know the reason.
> > ---
> >  kernel/irq_work.c |   21 ++++++++++-----------
> >  1 files changed, 10 insertions(+), 11 deletions(-)
> > 
> > diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> > index 1588e3b..4a9a44c 100644
> > --- a/kernel/irq_work.c
> > +++ b/kernel/irq_work.c
> > @@ -32,21 +32,21 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
> >  /*
> >   * Claim the entry so that no one else will poke at it.
> >   */
> > -static bool irq_work_claim(struct irq_work *work)
> > +static void irq_work_claim(struct irq_work *work)
> >  {
> >  	unsigned long flags, nflags;
> >  
> >  	for (;;) {
> >  		flags = work->flags;
> >  		if (flags & IRQ_WORK_PENDING)
> > -			return false;
> > +			return;
> >  		nflags = flags | IRQ_WORK_FLAGS;
> >  		if (cmpxchg(&work->flags, flags, nflags) == flags)
> >  			break;
> >  		cpu_relax();
> >  	}
> >  
> > -	return true;
> > +	return;
> >  }
> >  
> >  void __weak arch_irq_work_raise(void)
> > @@ -79,15 +79,14 @@ static void __irq_work_queue(struct irq_work *work)
> >   *
> >   * Can be re-enqueued while the callback is still in progress.
> >   */
> > -bool irq_work_queue(struct irq_work *work)
> > +void irq_work_queue(struct irq_work *work)
> >  {
> > -	if (!irq_work_claim(work)) {
> > -		/*
> > -		 * Already enqueued, can't do!
> > -		 */
> > -		return false;
> > -	}
> > -
> > +	/*
> > +	 * This function either will claim the entry to queue
> > +	 * the work or if the work is already queued and is in
> > +	 * pending state then it will simply return.
> > +	 */
> > +	irq_work_claim(work)
> 
> Um, no.
> 
> If the state was already pending, we will corrupt the llist node of the
> work if we call irq_work_queue(). You must check the return value of
> irq_work_claim() and return if it fails. You can not call
> __irq_work_queue() if irq_work_claim() does not succeed.
> 
> The return value of irq_work_queue() can be ignored, but not
> irq_work_claim().
Oh I didn't see that logic properly and rightly pointed out by you, we
should _just_ return instead of queuing the work if the state was
already pending.
> 
> -- Steve
> 
> >  	__irq_work_queue(work);
> >  	return true;
> >  }
> 
> 


