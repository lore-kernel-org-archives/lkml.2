Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1GASGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:06:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1GASGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:06:42 -0400
Date: Fri, 1 Jul 2011 19:05:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] ptrace: make former thread ID available via
	PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop
Message-ID: <20110701170559.GA12402@redhat.com>
References: <201106290413.39429.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106290413.39429.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Denys Vlasenko wrote:
>
> When multithreaded program execs under ptrace,
> all traced threads report WIFEXITED status, except for
> thread group leader and the thread which execs.
>
> Unless tracer tracks thread group relationship between tracees,
> which is a nontrivial task, it will not detect that
> execed thread no longer exists.
>
> This patch allows tracer to figure out which thread
> performed this exec, by requesting PTRACE_GETEVENTMSG
> in PTRACE_EVENT_EXEC stop.
>
> Another, samller problem which is solved by this patch
> is that tracer now can figure out which of the several
> concurrent execs in multithreaded program succeeded.
>
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Thanks, applied.

> @@ -1370,6 +1371,11 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  	if (retval)
>  		return retval;
>
> +	/* Need to fetch pid before load_binary changes it */
> +	rcu_read_lock();
> +	old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
> +	rcu_read_unlock();
> +
>  	retval = -ENOENT;
>  	for (try=0; try<2; try++) {
>  		read_lock(&binfmt_lock);
> @@ -1389,7 +1395,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  			bprm->recursion_depth = depth;
>  			if (retval >= 0) {
>  				if (depth == 0)
> -					ptrace_event(PTRACE_EVENT_EXEC, 0);
> +					ptrace_event(PTRACE_EVENT_EXEC,
> +							old_pid);

Just for record. ->parent can be changed after we call task_pid_nr_ns(),
and the new parent (tracer) can have another namespace, in this case
we report the wrong pid. This is possible even now, without
"PT_SEIZED implies PTRACE_EVENT_EXEC" we are going to add, although
this is very unlikely and in this case PTRACE_EVENT_EXEC is spurious
anyway. But when we change the behaviour of PT_SEIZED, this race
becomes not that exotic, although very unlikely anyway.

I do not think we should try to fix this, it is not trivial and
doesn't worth the trouble.

Oleg.

