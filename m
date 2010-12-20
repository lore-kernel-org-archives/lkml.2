Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab0LTSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:22:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab0LTSWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:22:32 -0500
Date: Mon, 20 Dec 2010 19:15:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 13/16] ptrace: reorganize __ptrace_unlink() and
	ptrace_untrace()
Message-ID: <20101220181516.GB18070@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit off-topic note,

On 12/06, Tejun Heo wrote:
>
> -static void ptrace_untrace(struct task_struct *child)
> +void __ptrace_unlink(struct task_struct *child)
>  {
> +	struct signal_struct *sig = child->signal;
> +
> +	BUG_ON(!child->ptrace);
> +
>  	spin_lock(&child->sighand->siglock);
> +
>  	if (task_is_traced(child)) {
>  		/*
>  		 * If group stop is completed or in progress, it should
>  		 * participate in the group stop.  Set GROUP_STOP_PENDING
>  		 * before kicking it.
>  		 */
> -		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
> -		    child->signal->group_stop_count)
> +		if (sig->flags & SIGNAL_STOP_STOPPED || sig->group_stop_count)
>  			child->group_stop |= GROUP_STOP_PENDING;
>  		signal_wake_up(child, 1);

OK. Of course, I do not blame this patch, this mimics the current
behaviour.

But, afaics, this is not exactly right in the long term. Suppose
that SIGNAL_STOP_STOPPED is set but the tracee is running (this can
happen if, say, debugger resumes the tracee and exits). In this case,
I think this thread should be stopped too.

IIRC, I already tried to do this, but the patch (or idea) was nacked
because it means another user-visible change. However, if we want to
really fix things, we should fix this case too. If SIGNAL_STOP_STOPPED
is set, there should be no running threads after detach.

Or. We can change the rules for ptrace_resume(), more on this later.

Oleg.

