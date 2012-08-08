Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab2HHNTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339Ab2HHNTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:19:12 -0400
Date: Wed, 8 Aug 2012 15:14:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        gdb-patches@sourceware.org
Subject: Re: [RFC 5/5] uprobes: add global breakpoints
Message-ID: <20120808131457.GA5309@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344355952-2382-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Sebastian Andrzej Siewior wrote:
>
> By setting an uprobe tracepoint, one learns whenever a certain point
> within a program is reached / passed. This is recorded and the
> application continues.
> This patch adds the ability to hold the program once this point has been
> passed and the user may attach to the program via ptrace.
> First, setup a global breakpoint which is very similar to a uprobe trace
> point:
>
> |echo 'g /home/bigeasy/sample:0x0000044d %ip %ax' > uprobe_events
>
> This is exactly what uprobe does except that it starts with the letter
> 'g' instead of 'p'.
>
> Step two is to enable it:
> |echo 1 > events/uprobes/enable
>
> Lets assume you execute ./sample and the breakpoint is hit. In ps you will
> see:
> |1938 pts/1    t+     0:00 ./sample
>
> Now you can attach gdb via 'gdb -p 1938'. The gdb can now interact with
> the tracee and inspect its registers, its stack, single step, let it
> run…
> In case the process is not of great interest, the user may continue
> without gdb by writting its pid into the uprobe_gp_wakeup file
>
> |echo 1938 > uprobe_gp_wakeup
>
> What I miss right now is an interface to tell the user/gdb that there is a
> program that hit a global breakpoint and is waiting for further instructions.
> A "tail -f trace" does not work and may contain also a lot of other
> informations. I've been thinking about a poll()able file which returns pids of
> tasks which are put on hold. Other suggestions?

Honestly, I am not sure this is that useful...

OK, I'll try to read this patch later. But, at first glance,

> +int uprobe_wakeup_task(struct task_struct *t, int traced)
> +{
> +	struct uprobe_task *utask;
> +
> +	utask = t->utask;
> +	if (!utask)
> +		return -EINVAL;
> +	if (utask->state != UTASK_TRACE_SLEEP)
> +		return -EINVAL;
> +
> +	utask->state = traced ?
> +		UTASK_TRACE_WOKEUP_TRACED : UTASK_TRACE_WOKEUP_NORMAL;
> +	wake_up_state(t, __TASK_TRACED);
> +	return 0;
> +}

This can obviously race with uprobe_wait_traced(), see below

> @@ -286,8 +286,10 @@ static int ptrace_attach(struct task_struct *task, long request,
>  	__ptrace_link(task, current);
>
>  	/* SEIZE doesn't trap tracee on attach */
> -	if (!seize)
> +	if (!seize) {
>  		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
> +		uprobe_wakeup_task(task, 1);
> +	}

Can't understand why uprobe_wakeup_task() depends on !PTRACE_SEIZE

> +static void uprobe_wait_traced(struct trace_uprobe *tu)
> +{
> +	struct uprobe_task *utask;
> +
> +	utask = current->utask;
> +	utask->state = UTASK_TRACE_SLEEP;

WINDOW

> +
> +	set_current_state(TASK_TRACED);
> +	schedule();
> +}

Suppose that uprobe_wakeup_task() is called in the WINDOW above.

OTOH, uprobe_wakeup_task() can race with itself if it is called
twice at the same time, say from uprobes_gp_wakeup_write() and
ptrace_attach().

Oleg.

