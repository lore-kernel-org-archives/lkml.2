Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0IOLmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:42:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51395 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0IOLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IC8sUzldTckWTgUJMfM63AryGol3Hsl8yNa6ujAvKl68OldDt4GaSCF0ILFAtZ03HP
         0yzndsut6CtY4kxtc/BTMA/mLfu4lYtq9p03GbexyVJ5vBxmZTqL1u8+jTMh7FPBsB7V
         sa/9x3W3sp94CAGqYgNejagWn6F0ymUjd6tMs=
Date: Wed, 15 Sep 2010 13:41:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        greenrd@greenrd.org, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] hw breakpoints: Fix pid namespace bug
Message-ID: <20100915114150.GA5621@nowhere>
References: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com> <tip-d958077d007d98125766d11e82da2fd6497b91d6@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d958077d007d98125766d11e82da2fd6497b91d6@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:03:06AM +0000, tip-bot for Matt Helsley wrote:
> Commit-ID:  d958077d007d98125766d11e82da2fd6497b91d6
> Gitweb:     http://git.kernel.org/tip/d958077d007d98125766d11e82da2fd6497b91d6
> Author:     Matt Helsley <matthltc@us.ibm.com>
> AuthorDate: Mon, 13 Sep 2010 13:01:18 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 15 Sep 2010 10:43:59 +0200
> 
> hw breakpoints: Fix pid namespace bug
> 
> Hardware breakpoints can't be registered within pid namespaces
> because tsk->pid is passed rather than the pid in the current
> namespace.
> 
> (See https://bugzilla.kernel.org/show_bug.cgi?id=17281 )
> 
> This is a quick fix demonstrating the problem but is not the
> best method of solving the problem since passing pids internally
> is not the best way to avoid pid namespace bugs. Subsequent patches
> will show a better solution.
> 
> Much thanks to Frederic Weisbecker <fweisbec@gmail.com> for doing the
> bulk of the work finding this bug.
> 
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Robin Green <greenrd@greenrd.org>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> LKML-Reference: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---


Aiie, you have been too fast too apply that on -tip, especially it should
go to perf/urgent with some stable backport tags. And I need to test them as
he said that was only compile tested.

Lemme just check it really fixes the issue and I'll package his
three patches in according pull requests.

Thanks.



>  kernel/hw_breakpoint.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index 3b2aaff..6122f02 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -433,7 +433,8 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
>  			    perf_overflow_handler_t triggered,
>  			    struct task_struct *tsk)
>  {
> -	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
> +	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
> +						triggered);
>  }
>  EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

