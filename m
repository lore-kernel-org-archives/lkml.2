Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0LMOkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:40:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0LMOkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:40:19 -0500
Date: Mon, 13 Dec 2010 15:33:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
	taskstats
Message-ID: <20101213143306.GA22840@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com> <20101129164435.903722027@linux.vnet.ibm.com> <20101201185128.GA7656@redhat.com> <1291307641.1928.125.camel@holzheu-laptop> <20101208202308.GA1804@redhat.com> <1291987580.1933.10.camel@holzheu-laptop> <20101211173931.GA8084@redhat.com> <1292245515.2063.168.camel@holzheu-laptop> <1292246456.2063.179.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292246456.2063.179.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Michael Holzheu wrote:
>
> On Mon, 2010-12-13 at 14:05 +0100, Michael Holzheu wrote:
> > > And this looks racy, or I missed something again. group_dead can be
> > > true, but this doesn't mean all other threads have already passed
> > > taskstats_exit()->fill_tgid_exit()->delayacct_add_tsk().
> >
> > I think you are right.
> >
> > One way to fix that could be to separate the aggregation from the
> > sending. We could call fill_tgid_exit()->delayacct_add_tsk() before
> > atomic_dec_and_test(&tsk->signal->live) in do_exit() and
> > taskstats_exit() with the sender part afterwards.

Yes, I think this should fix the race. Some nits below...

> --- a/include/linux/taskstats_kern.h
> +++ b/include/linux/taskstats_kern.h
> @@ -21,7 +21,8 @@ static inline void taskstats_tgid_free(s
>  		kmem_cache_free(taskstats_cache, sig->stats);
>  }
>  
> -extern void taskstats_exit(struct task_struct *, int group_dead);
> +extern void taskstats_exit_notify(struct task_struct *, int group_dead);
> +extern void taskstats_exit_add_thread(struct task_struct *);

You forgot to update the !CONFIG_TASKSTATS case ;)

> -static void fill_tgid_exit(struct task_struct *tsk)
> +static void alloc_signal_stats(struct task_struct *tsk)
> +{
> +	struct signal_struct *sig = tsk->signal;
> +	struct taskstats *stats;
> +
> +	/* No problem if kmem_cache_zalloc() fails */
> +	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> +
> +	spin_lock_irq(&tsk->sighand->siglock);
> +	if (!sig->stats) {
> +		sig->stats = stats;
> +		stats = NULL;
> +	}
> +	spin_unlock_irq(&tsk->sighand->siglock);
> +
> +	if (stats)
> +		kmem_cache_free(taskstats_cache, stats);
> +}
> +
> +void taskstats_exit_add_thread(struct task_struct *tsk)
>  {
>  	unsigned long flags;
>  
> +	if (tsk->signal->stats == NULL && !thread_group_empty(tsk))
> +		alloc_signal_stats(tsk);
> +
>  	spin_lock_irqsave(&tsk->sighand->siglock, flags);
>  	if (!tsk->signal->stats)
>  		goto ret;

Well. I do not like the fact we take ->siglock unconditionally.
And _irqsave is not needed. And we take it twice if sig->stats == NULL.
And "if (!tsk->signal->stats)" under ->siglock in
taskstats_exit_add_thread() looks a bit ugly...

How about

	void taskstats_exit_add_thread(struct task_struct *tsk)
	{
		struct taskstats *stats = NULL;

		if (!tsk->signal->stats) {
			if (thread_group_empty(tsk)
				return;

			stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
			if (!stats)
				return;
		}

		spin_lock_irq(&tsk->sighand->siglock);
		if (!tsk->signal->stats) {
			tsk->signal->stats = stats;
			stats = NULL;
		}
		/*
		 * Each accounting subsystem calls its functions here to
		 * accumalate its per-task stats for tsk, into the per-tgid structure
		 *
		 *	per-task-foo(tsk->signal->stats, tsk);
		 */
		delayacct_add_tsk(tsk->signal->stats, tsk);
		spin_unlock_irq(&tsk->sighand->siglock);

		if (unlikely(stats))
			kmem_cache_free(taskstats_cache, stats);
	}

?

Note that it absorbs alloc_signal_stats().

But up to you, probably this is matter of taste.

Oleg.

