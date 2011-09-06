Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1IFSrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:47:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1IFSrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:47:00 -0400
Date: Tue, 6 Sep 2011 20:43:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v2] Fix clearing of task->ptrace if PTRACE_SETOPTIONS
	fails
Message-ID: <20110906184346.GA25904@redhat.com>
References: <201109042311.18793.vda.linux@googlemail.com> <1315327963.29637.1.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315327963.29637.1.camel@dhcp-25-63.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06, Denys Vlasenko wrote:
>
> Exchange PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which makes
> PT_option bits contiguous and therefore makes code in ptrace_setoptions()
> much simpler.

Agreed, this probably makes sense. Although I don't think "contiguous"
really helps, even if I agree it looks better. What does mater is that
PTRACE_O_TRACESYSGOOD << PT_OPT_FLAG_SHIFT becomes PT_TRACESYSGOOD.

But,

> +#define PT_OPT_FLAG_SHIFT	3
> +/* must be directly before PT_TRACE_event bits */
> +#define PT_TRACESYSGOOD	0x00000008

This probably means PT_TRACESYSGOOD should be also defined as PT_EVENT_FLAG(0),

>  /* PT_TRACE_* event enable flags */
> -#define PT_EVENT_FLAG_SHIFT	4
> -#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
> -
> +#define PT_EVENT_FLAG(event)	(1 << (PT_OPT_FLAG_SHIFT + (event)))

And ptrace_setoptions() does

	child->ptrace |= (data << PT_OPT_FLAG_SHIFT);

Now we should verify that

	PTRACE_O_XXX == 1 << PTRACE_EVENT_XXX;

for every XXX... Looks correct. But perhaps it makes sense to do this
explicitely and redefine PTRACE_O_* via PTRACE_EVENT_*.

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -219,19 +219,23 @@ static int ptrace_attach(struct task_struct *task, long request,
>  
>  	/*
>  	 * SEIZE will enable new ptrace behaviors which will be implemented
> -	 * gradually.  SEIZE_DEVEL is used to prevent applications
> +	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
>  	 * expecting full SEIZE behaviors trapping on kernel commits which
>  	 * are still in the process of implementing them.
>  	 *
>  	 * Only test programs for new ptrace behaviors being implemented
>  	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
>  	 *
> -	 * Once SEIZE behaviors are completely implemented, this flag and
> -	 * the following test will be removed.
> +	 * Once SEIZE behaviors are completely implemented, this flag
> +	 * will be removed.
>  	 */
>  	retval = -EIO;
> -	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
> -		goto out;
> +	if (seize) {
> +		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
> +			goto out;
> +		flags &= ~PTRACE_SEIZE_DEVEL;
> +	} else
> +		flags = 0;
>  
>  	audit_ptrace(task);

This chunk looks completely off-topic, why it is needed in this patch?

>  static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  {
> -	child->ptrace &= ~PT_TRACE_MASK;
> -
> -	if (data & PTRACE_O_TRACESYSGOOD)
> -		child->ptrace |= PT_TRACESYSGOOD;
> -
> -	if (data & PTRACE_O_TRACEFORK)
> -		child->ptrace |= PT_TRACE_FORK;
> -
> -	if (data & PTRACE_O_TRACEVFORK)
> -		child->ptrace |= PT_TRACE_VFORK;
> -
> -	if (data & PTRACE_O_TRACECLONE)
> -		child->ptrace |= PT_TRACE_CLONE;
> -
> -	if (data & PTRACE_O_TRACEEXEC)
> -		child->ptrace |= PT_TRACE_EXEC;
> -
> -	if (data & PTRACE_O_TRACEVFORKDONE)
> -		child->ptrace |= PT_TRACE_VFORK_DONE;
> +	if (data & ~(long)PTRACE_O_MASK)
> +		return -EINVAL;

Oh, yes, I always hated this logic. We change ->ptrace first, then
return -EINVAL if data is wrong.

But. Denys, I think this needs a separate patch. And of course, of
course this can break things. Say, a poor application passes the
unsupported bit along with the valid bits, and doesn't check the result.
This works before this patch.

Honestly, I'd prefer to keep this oddity. But if you send a separate
patch... I do not know ;)

Oleg.

