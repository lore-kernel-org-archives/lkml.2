Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0HWR4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0HWR42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:56:28 -0400
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
From: Eric Paris <eparis@redhat.com>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, anton@samba.org
In-Reply-To: <29151.1282270393@neuling.org>
References: <29151.1282270393@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 13:56:17 -0400
Message-ID: <1282586177.2681.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 12:13 +1000, Michael Neuling wrote:
> We found that when auditing is disabled using "auditctl -D", that
> there's still a significant overhead when doing syscalls.  This overhead
> is not present when a single never rule is inserted using "auditctl -a
> task,never".  
> 
> Using Anton's null syscall microbenchmark from
> http://ozlabs.org/~anton/junkcode/null_syscall.c we currently have on a
> powerpc machine:
> 
>   # auditctl -D
>   No rules
>   # ./null_syscall
> 	  null_syscall:     739.03 cycles     100.00%
>   # auditctl -a task,never
>   # ./null_syscall
> 	  null_syscall:     204.63 cycles     100.00%
> 
> This doesn't seem right, as we'd hope that auditing would have the same
> minimal impact when disabled via -D as when we have a single never rule.
> 
> The patch below creates a fast path when initialising a task.  If the
> rules list for tasks is empty (the disabled -D option), we mark auditing
> as disabled for this task.  
> 
> When this is applied, our null syscall benchmark improves in the
> disabled case to match the single never rule case.
> 
>   # auditctl -D
>   No rules
>   # ./null_syscall
> 	  null_syscall:     204.62 cycles     100.00%
>   # auditctl -a task,never
>   # ./null_syscall
> 	  null_syscall:     204.63 cycles     100.00%
> 
> Reported-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
> I'm not familiar with the auditing code/infrastructure so I may have
> misunderstood something here
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 1b31c13..1cd6ec7 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -666,6 +666,11 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
>  	enum audit_state   state;
>  
>  	rcu_read_lock();
> +	/* Fast path.  If the list is empty, disable auditing */
> +	if (list_empty(&audit_filter_list[AUDIT_FILTER_TASK])) {
> +		rcu_read_unlock();
> +		return AUDIT_DISABLED;
> +	}
>  	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
>  		if (audit_filter_rules(tsk, &e->rule, NULL, NULL, &state)) {
>  			if (state == AUDIT_RECORD_CONTEXT)

I don't think this works at all.  I don't see how syscall audit'ing can
work.  What if I have nothing in the AUDIT_FILTER_TASK list but I want
to audit all 'open(2)' syscalls?  This patch is going to leave the task
in the DISABLED state and we won't ever be able to match on the syscall
rules.


I wonder if you could get much back, in terms of performance, by moving
the
         context->dummy = !audit_n_rules;
line to the top and just returning if context->dummy == 1;

I'll play a bit, but I thought that was supposed to be a safe thing to
do....


