Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0KWRGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:06:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab0KWRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:06:42 -0500
Date: Tue, 23 Nov 2010 17:59:51 +0100
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
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 3/4] taskstats: Introduce cdata_acct for complete
	cumulative accounting
Message-ID: <20101123165951.GA5938@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com> <20101119201144.542948128@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119201144.542948128@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Michael Holzheu wrote:
>
> Currently the cumulative time accounting in Linux is not complete.
> Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
> to the cumulative time of the parents, if the parents ignore SIGCHLD
> or have set SA_NOCLDWAIT. This behaviour has the major drawback that
> it is not possible to calculate all consumed CPU time of a system by
> looking at the current tasks. CPU time can be lost.
>
> This patch adds a new set of cumulative time counters. We then have two
> cumulative counter sets:
>
> * cdata_wait: Traditional cumulative time used e.g. by getrusage.
> * cdata_acct: Cumulative time that also includes dead processes with
>               parents that ignore SIGCHLD or have set SA_NOCLDWAIT.
>               cdata_acct will be exported by taskstats.

Looks correct at first glance. A couple of nits below.

> TODO:
> -----
> With this patch we take the siglock twice. First for the dead task
> and second for the parent of the dead task. This give the following
> lockdep warning (probably a lockdep annotation is needed here):

And we already discussed this ;) We do not need 2 siglock's, only
parent's. Just move the callsite in __exit_signal() down, under
another (lockless) group_dead check.

Or I missed something?

> @@ -595,6 +595,8 @@ struct signal_struct {
>  	 */
>  	struct cdata cdata_wait;
>  	struct cdata cdata_threads;
> +	struct cdata cdata_acct;
> +	struct task_io_accounting ioac_acct;
>  	struct task_io_accounting ioac;

Given that task_io_accounting is Linux specific, perhaps we can use
signal->ioac in both cases?

Yes, this is a user-visible change anyway. But, at least we can
forget about POSIX.

> +	spin_lock_irqsave(&p->real_parent->sighand->siglock, flags);
> +	if (wait) {
> +		pcd = &p->real_parent->signal->cdata_wait;
> +		tcd = &p->signal->cdata_threads;
> +		cd = &p->signal->cdata_wait;
> +	} else {
> +		pcd = &p->real_parent->signal->cdata_acct;
> +		tcd = &p->signal->cdata_threads;
> +		cd = &p->signal->cdata_acct;
> +	}

We can do this before taking ->siglock. Not that I think this really
matters, but otherwise this looks a bit confusing imho, as if we need
parent's ->siglock to pin something.


And thanks for splitting these changes. It was much, much easier to
read now.

Oleg.

