Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1DKKsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:48:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63337 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab1DKKsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:48:36 -0400
Subject: Re: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task
 breakpoints
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
In-Reply-To: <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
	 <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 11:47:57 +0100
Message-ID: <1302518877.24286.34.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Fri, 2011-04-08 at 18:34 +0100, Frederic Weisbecker wrote:
> When a task is traced and is in a stopped state, the tracer
> may execute a ptrace request to examine the tracee state and
> get its task struct. Right after, the tracee can be killed
> and thus its breakpoints released.
> This can happen concurrently when the tracer is in the middle
> of reading or modifying these breakpoints, leading to dereferencing
> a freed pointer.

Oo, that's nasty. Would an alternative solution be to free the
breakpoints only when the task_struct usage count is zero?

> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 0fc1eed..dc7ab65 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -22,6 +22,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/uaccess.h>
>  #include <linux/regset.h>
> +#include <linux/hw_breakpoint.h>
> 
> 
>  /*
> @@ -879,3 +880,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
>         return ret;
>  }
>  #endif /* CONFIG_COMPAT */
> +
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +int ptrace_get_breakpoints(struct task_struct *tsk)
> +{
> +       if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
> +               return 0;
> +
> +       return -1;
> +}


Would it be better to return -ESRCH here instead?

Will

