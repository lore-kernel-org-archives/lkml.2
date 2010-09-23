Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0IWRO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:14:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab0IWRO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:14:56 -0400
Date: Thu, 23 Sep 2010 19:10:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20100923171025.GA26623@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop> <1285250541.1837.95.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285250541.1837.95.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I didn't look at other patches, but this one looks strange
to me...

On 09/23, Michael Holzheu wrote:
>
> Currently there are code pathes (e.g. for kthreads) where the consumed
> CPU time is not accounted to the parents cumulative counters.

Could you explain more?

> +static void account_to_parent(struct task_struct *p)
> +{
> +	struct signal_struct *psig, *sig;
> +	struct task_struct *tsk_parent;
> +
> +	read_lock(&tasklist_lock);

No need to take tasklist, you can use rcu_read_lock() if you need
get_task_struct(). But this can't help, please see below.

> +	tsk_parent = p->real_parent;
> +	if (!tsk_parent) {
> +		read_unlock(&tasklist_lock);
> +		return;
> +	}
> +	get_task_struct(tsk_parent);
> +	read_unlock(&tasklist_lock);
> +
> +	// printk("XXX Fix accounting: pid=%d ppid=%d\n", p->pid, tsk_parent->pid);
> +	spin_lock_irq(&tsk_parent->sighand->siglock);

This is racy. ->real_parent can exit after we drop tasklist_lock,
->sighand can be NULL.

>  void release_task(struct task_struct * p)
>  {
>  	struct task_struct *leader;
>  	int zap_leader;
> +
> +	if (!p->exit_accounting_done)
> +		account_to_parent(p);
>  repeat:
>  	tracehook_prepare_release_task(p);
>  	/* don't need to get the RCU readlock here - the process is dead and
> @@ -1279,6 +1313,7 @@
>  			psig->cmaxrss = maxrss;
>  		task_io_accounting_add(&psig->ioac, &p->ioac);
>  		task_io_accounting_add(&psig->ioac, &sig->ioac);
> +		p->exit_accounting_done = 1;

Can't understand.

Suppose that a thread T exits and reaps itself (calls release_task).
Now we call account_to_parent() which accounts T->signal->XXX + T->XXX.
After that T calls __exit_signal and does T->signal->XXX += T->XXX.

If another thread exits it does the same and we account the already
exited thread T again?

When the last thread exits, wait_task_zombie() accounts T->signal
once again.

IOW, this looks like the over-accounting to me, no?

Oleg.

