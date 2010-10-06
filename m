Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab0JFPbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab0JFPbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:31:15 -0400
Date: Wed, 6 Oct 2010 17:26:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20101006152609.GA21169@redhat.com>
References: <1285250541.1837.95.camel@holzheu-laptop> <20100923171025.GA26623@redhat.com> <1285330688.2179.305.camel@holzheu-laptop> <20100926181127.GA26985@redhat.com> <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com> <20100927165133.GA23535@redhat.com> <20100929191916.21E1840038@magilla.sf.frob.com> <1285854460.1856.14.camel@holzheu-laptop> <20101005085751.4490A401B2@magilla.sf.frob.com> <1286357350.1888.25.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286357350.1888.25.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't read the whole patch, but some parts doesn't look right,

On 10/06, Michael Holzheu wrote:
>
> The patch also approaches another ugly Unix behavior regarding process
> accounting. If a parent process dies before his children, the children
> get the reaper process (init) as new parent. If we want to determine the
> CPU usage of a process tree with cumulative time, this is very
> suboptimal. To fix this I added a new process relationship tree for
> accounting.

Well, I must admit, I can't say I like the complications this change adds ;)
In any case, imho this change needs a separate patch/discussion.

> Besides of that the patch adds an "acct_parent" pointer next to the parent
> pointer and a "children_acct" list next to the children list to the
> task_struct in order to remember the correct accounting task relationship.

I am not sure I understand the "correct accounting" above. ->acct_parent
adds the "parallel" hierarchy. In the simplest case, suppose that some
process P forks the child C and exits. Then C->acct_parent == P->real_parent
(P->acct_parent in general). I am not sure this is always good.

Anyway,

> @@ -90,6 +156,24 @@ static void __exit_signal(struct task_st
>  
>  	posix_cpu_timers_exit(tsk);
>  	if (group_dead) {
> +		if (!tsk->exit_accounting_done) {
> +#ifdef __s390x__
> +		/*
> +		 * FIXME: On s390 we can call account_process_tick to update
> +		 * CPU time information. This is probably not valid on other
> +		 * architectures.
> +		 */
> +			if (current == tsk)
> +				account_process_tick(current, 1);
> +#endif
> +			/*
> +			 * FIXME: This somehow has to be moved to
> +			 * finish_task_switch(), because otherwise
> +			 * if the process accounts itself, the CPU time
> +			 * that is used for this code will be lost.
> +			 */
> +			__account_to_parent(tsk, 0);

We hold the wrong ->siglock here.

Also, the logic behind ->exit_accounting_done looks wrong (and unneeded)
but I am not sure...

> @@ -772,6 +869,15 @@ static void forget_original_parent(struc
>  	LIST_HEAD(dead_children);
>  
>  	write_lock_irq(&tasklist_lock);
> +	list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
> +		struct task_struct *t = p;
> +		do {
> +			t->acct_parent = t->acct_parent->acct_parent;
> +		} while_each_thread(p, t);
> +		list_move_tail(&p->sibling_acct,
> +			       &p->acct_parent->children_acct);

This is certainly wrong if there are other live threads in father's
thread-group.

Also, you need to change de_thread() if it changes the leader.

>  	list_for_each_entry_safe(p, n, &dead_children, sibling) {
>  		list_del_init(&p->sibling);
> +		list_del_init(&p->sibling_acct);

This list_del() can race with ->acct_parent if it in turn exits and
does forget_original_parent() -> list_move_tail(sibling_acct).

Oleg.

