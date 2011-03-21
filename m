Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1CURwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab1CURwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:52:46 -0400
Date: Mon, 21 Mar 2011 18:43:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
	events regardless of ptrace
Message-ID: <20110321174306.GA29895@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>
> With recent changes, job control and ptrace stopped states are
> properly separated and accessible to the real parent and the ptracer
> respectively; however, notifications of job control stopped/continued
> events to the real parent while ptraced are still missing.

Yes, great.

>  /*
> + * Test whether the target task of the usual cldstop notification - the
> + * real_parent of the group_leader of @child - is the ptracer.
> + */
> +static bool real_parent_is_ptracer(struct task_struct *child)
> +{
> +	return child->parent == child->group_leader->real_parent;
> +}

Again, I am not sure we do not need same_thread_group(), but this
is minor.

Hmm... in fact I can't convince myself we really need to look at
child->group_leader, will recheck... Anyway, this is minor too.

> @@ -1757,7 +1768,20 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  	spin_unlock_irq(&current->sighand->siglock);
>  	read_lock(&tasklist_lock);
>  	if (may_ptrace_stop()) {
> -		do_notify_parent_cldstop(current, task_ptrace(current), why);
> +		/*
> +		 * Notify parents of the stop.
> +		 *
> +		 * While ptraced, there are two parents - the ptracer and
> +		 * the real_parent of the group_leader.  The ptracer should
> +		 * know about every stop while the real parent is only
> +		 * interested in the completion of group stop.  The states
> +		 * for the two don't interact with each other.  Notify
> +		 * separately unless they're gonna be duplicates.
> +		 */
> +		do_notify_parent_cldstop(current, true, why);
> +		if (gstop_done && !real_parent_is_ptracer(current))
> +			do_notify_parent_cldstop(current, false, why);

OK.

But what about "else" branch? If gstop_done == T but debugger has gone
between spin_unlock(siglock) and read_lock(tasklist), we should do
something.

ptrace_untrace() restores GROUP_STOP_PENDING in this case, so this task
will stop again. But notification is lost.

Just in case, it is not that I blame this patch. Just I think we need
a bit more changes here. Unless I missed something.

> @@ -2017,10 +2041,24 @@ relock:
>
> +		/*
> +		 * Notify the parent that we're continuing.  This event is
> +		 * always per-process and doesn't make whole lot of sense
> +		 * for ptracers, who shouldn't consume the state via
> +		 * wait(2) either, but, for backward compatibility, notify
> +		 * the ptracer of the group leader too unless it's gonna be
> +		 * a duplicate.
> +		 */
>  		read_lock(&tasklist_lock);
> +
> +		do_notify_parent_cldstop(current, false, why);

Nice,

>  		leader = current->group_leader;
> +		if (task_ptrace(leader) && !real_parent_is_ptracer(leader))
> +			do_notify_parent_cldstop(leader, true, why);

Well, yes... This is ugly but compatible and documented, so I agree.

Oleg.

