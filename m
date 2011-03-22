Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1CVUmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab1CVUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:42:38 -0400
Date: Tue, 22 Mar 2011 21:33:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 0.2/8] ptrace: Always put ptracee into appropriate
	execution state
Message-ID: <20110322203322.GD28038@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <20110322102046.GO12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322102046.GO12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Tejun Heo wrote:
>
> This patch updates __ptrace_unlink() such that GROUP_STOP_PENDING is
> reinstated regardless of the ptracee's current state as long as it's
> alive and makes sure that signal_wake_up() is called if execution
> state transition is necessary.

Looks correct (and the previous one too).

But I don't understand the PF_EXITING check,

> +	/*
> +	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
> +	 * @child isn't dead.
> +	 */
> +	if (!(child->flags & PF_EXITING) &&
> +	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
> +	     child->signal->group_stop_count))
> +		child->group_stop |= GROUP_STOP_PENDING;

Why do we need to filter out PF_EXITING tasks? This doesn't look
strictly necessary. And note that exit_signals() doesn't always
take ->siglock, we can race anyway.

> +	 * Note that @resume should be used iff @child
> +	 * is in TASK_TRACED; otherwise, we might unduly disrupt
> +	 * TASK_KILLABLE sleeps.

Yes. but, just in case,

> +	 */
> +	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
> +		signal_wake_up(child, task_is_traced(child));

signal_wake_up() is not needed if task_is_traced(). Even if we added
GROUP_STOP_PENDING, ptrace_stop() does recalc_sigpending_tsk() anyway
before return.

So we could do

	if (SIGNAL_STOP_STOPPED || group_stop_count) {
		child->group_stop |= GROUP_STOP_PENDING;
		signal_wake_up(child, 0);
	}

	if (task_is_traced(child))
		wake_up_state(TASK_TRACED);

But probably a single wakeup looks more simple/clean, so I agree.

Oleg.

