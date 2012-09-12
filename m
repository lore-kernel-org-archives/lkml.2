Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab2ILO2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363Ab2ILO2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:28:36 -0400
Date: Wed, 12 Sep 2012 16:30:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: srikar@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        gdb-patches@sourceware.org
Subject: Re: [PATCH 2/2] uprobes: add global breakpoints
Message-ID: <20120912143010.GA1447@redhat.com>
References: <1347377843-16017-1-git-send-email-bigeasy@linutronix.de> <1347377843-16017-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347377843-16017-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11, Sebastian Andrzej Siewior wrote:
>
> This patch adds the ability to hold the program once this point has been
> reached and the user may attach to the program via ptrace.
> Setting up a global breakpoint which is very similar to a uprobe trace
> point:

Well, I hoped that someone else will nack^Wreview this patch. You know
that personally I hate this feature ;)

And, to be honest, I also dislike the implementation.

> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1274,11 +1274,15 @@ void uprobe_free_utask(struct task_struct *t)
>  {
>  	struct uprobe_task *utask = t->utask;
>
> +	uprobe_gb_allow_pid(t->pid);
>  	if (!utask)
>  		return;
>
>  	if (utask->active_uprobe)
>  		put_uprobe(utask->active_uprobe);
> +	if (utask->skip_handler)
> +		put_uprobe(utask->skip_handler);
> +	uprobe_gb_remove_active(t->pid);
>
>  	xol_free_insn_slot(t);
>  	kfree(utask);
> @@ -1446,7 +1450,21 @@ static void handle_swbp(struct pt_regs *regs)
>  			goto cleanup_ret;
>  	}
>  	utask->active_uprobe = uprobe;
> -	handler_chain(uprobe, regs);
> +	if (utask->skip_handler == uprobe) {
> +		put_uprobe(uprobe);
> +		utask->skip_handler = NULL;
> +	} else {
> +		handler_chain(uprobe, regs);
> +	}
> +
> +	if (utask->state == UTASK_TRACE_WOKEUP_TRACED) {
> +		send_sig(SIGTRAP, current, 0);
> +		if (utask->skip_handler)

(afaics this is not possible)

> +			put_uprobe(utask->skip_handler);
> +		utask->skip_handler = uprobe;
> +		atomic_inc(&uprobe->ref);
> +		goto cleanup_ret;
> +	}
>  	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
>  		goto cleanup_ret;
>
> @@ -1461,7 +1479,8 @@ cleanup_ret:
>  		utask->active_uprobe = NULL;
>  		utask->state = UTASK_RUNNING;
>  	}
> -	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> +	if (!(uprobe->flags & UPROBE_SKIP_SSTEP) ||
> +			utask->skip_handler == uprobe)

IMHO, IMHO, but I think this is ugly. This all connects to the "special"
consumer which does the "strange" things. This is not generic, say, you
can't have 2 consumers playing with UTASK_TRACE_WOKEUP_*.

OK. Even if we need something like this, is it really important to notify
gdb _before_ the probed insn? If yes, why?

If not, you do not need any modification in uprobe code, and the changes
kernel/trace/ can be simplified.

To simplify the discussion, lets ignore races/locking/filtering/all_details.

	- uprobe_wait_traced() simply does schedule() in TASK_KILLABLE state

	- uprobe_wakeup_task() wakes it up

If a user wants to debug this task, it can do

	$ gdb -p pidof_task
	$ kill -TRAP pidof_task
	$ echo pidof_task > uprobe_gb_active

That is all.




OK. If you insist that it should report first and then execute the
probed insn. Lets start with the patch below, then your consumer
can can roughly do something like

	set_current_state(TASK_KILLABLE);
	schedule();

	if (traced) {
		// again, not really necessary
		send_sig(SIGTRAP, current);
		return UPROBE_RESTART;
	}

	return 0;

Yes, yes, yes. Your consumer should remember the fact it returned
UPROBE_RESTART, the next time it should not sleep but retun 0. But
please do not complicate the generic code for this! Yes, other
consumers will see the same probe again but I think this is fine.

Oleg.

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -506,19 +506,22 @@ static struct uprobe *alloc_uprobe(struc
 	return uprobe;
 }
 
-static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
+static int handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
+	int ret = 0;
 
 	if (!(uprobe->flags & UPROBE_RUN_HANDLER))
-		return;
+		return ret;
 
 	down_read(&uprobe->consumer_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
 		if (!uc->filter || uc->filter(uc, current))
-			uc->handler(uc, regs);
+			ret |= uc->handler(uc, regs);
 	}
 	up_read(&uprobe->consumer_rwsem);
+
+	return ret;
 }
 
 /* Returns the previous consumer */
@@ -1464,6 +1467,7 @@ static void handle_swbp(struct pt_regs *
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
 	int uninitialized_var(is_swbp);
+	int action = 0;
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
@@ -1494,7 +1498,7 @@ static void handle_swbp(struct pt_regs *
 			goto cleanup_ret;
 	}
 	utask->active_uprobe = uprobe;
-	handler_chain(uprobe, regs);
+	action = handler_chain(uprobe, regs);
 	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
 		goto cleanup_ret;
 
@@ -1509,7 +1513,7 @@ cleanup_ret:
 		utask->active_uprobe = NULL;
 		utask->state = UTASK_RUNNING;
 	}
-	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
+	if (!(uprobe->flags & UPROBE_SKIP_SSTEP) || (action & UPROBE_RESTART))
 
 		/*
 		 * cannot singlestep; cannot skip instruction;

