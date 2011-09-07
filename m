Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1IGRWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1IGRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:22:08 -0400
Date: Wed, 7 Sep 2011 19:02:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PTRACE_SEIZE set ptrace options specified in data
	parameter
Message-ID: <20110907170212.GB5176@redhat.com>
References: <201109070647.40850.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109070647.40850.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07, Denys Vlasenko wrote:
>
> Make PTRACE_SEIZE set ptrace options specified in data parameter

Personally I think this makes sense, and in fact I suggested this
from the very beginning.

Oh. But since we are goin to establish the API rules, this should
be discussed.

IIRC, Tejun disliked this idea. Tejun?

>  	retval = -EIO;
> -	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
> -		goto out;
> +	if (seize) {
> +		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
> +			goto out;
> +		flags &= ~PTRACE_SEIZE_DEVEL;
> +	} else
> +		flags = 0;

Personally I do not care, but this is against the coding-style rules. This
should be

	} else {
		flags = 0;
	}

Or, better,

	flags = 0;
	if (seize) {
		flags = ...
	}


> @@ -263,7 +267,7 @@ static int ptrace_attach(struct task_struct *task, long request,
>  	if (task->ptrace)
>  		goto unlock_tasklist;
>
> -	task->ptrace = PT_PTRACED;
> +	task->ptrace = PT_PTRACED | (flags << PT_OPT_FLAG_SHIFT);
>  	if (seize)
>  		task->ptrace |= PT_SEIZED;

Hmm. Tejun, Denys, this doesn't look exactly right.

I already thought about this before, but somehow I convinced myself
this is fine.

I think we should set both PT_PTRACED | PT_SEIZED "atomically", at
once. Otherwise, say, the tracee can do do_jobctl_trap() in between,
no? Nothing really bad can happen, but we shouldn't lose EVENT_STOP
code.

IOW, I think we need the small fix before this patch.

Oleg.

