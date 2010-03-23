Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0CWLCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:02:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:39606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0CWLCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:02:51 -0400
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
	 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 12:01:55 +0100
Message-ID: <1269342115.5279.1620.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 19:56 +0530, Srikar Dronamraju wrote:
> +struct uprobe {
> +       /*
> +        * The pid of the probed process.  Currently, this can be the
> +        * thread ID (task->pid) of any active thread in the process.
> +        */
> +       pid_t pid;
> +
> +       /* Location of the probepoint */
> +       unsigned long vaddr;
> +
> +       /* Handler to run when the probepoint is hit */
> +       void (*handler)(struct uprobe*, struct pt_regs*);
> +
> +       /* true if handler runs in interrupt context*/
> +       bool handler_in_interrupt;
> +}; 

I would still prefer to see something like:

 vma:offset, instead of tid:vaddr

You want to probe a symbol in a DSO, filtering per-task comes after that
if desired.

Also, like we discussed in person, I think we can do away with the
handler_in_interrupt thing by letting the handler have an error return
value and doing something like:

do_int3:

  uprobe = find_probe_point(addr);

  pagefault_disable();
  err = uprobe->handler(uprobe, regs);
  pagefault_enable();

  if (err == -EFAULT) {
    /* set TIF flag and call the handler again from
       task context */
  }

This should allow the handler to optimistically access memory from the
trap handler, but in case it does need to fault pages in we'll call it
from task context.

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index dad7f66..2d2433a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1506,6 +1506,9 @@ struct task_struct {
>                 unsigned long memsw_bytes; /* uncharged mem+swap usage */
>         } memcg_batch;
>  #endif
> +#ifdef CONFIG_UPROBES
> +       struct uprobe_task *utask;
> +#endif
>  };
>  
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
> index 10db010..9a91d1e 100644
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -49,6 +49,7 @@
>  #include <linux/sched.h>
>  #include <linux/ptrace.h>
>  #include <linux/security.h>
> +#include <linux/uprobes.h>
>  struct linux_binprm;
>  
>  /**
> @@ -204,6 +205,11 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
>         if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
>             unlikely(task_ptrace(current) & PT_PTRACED))
>                 send_sig(SIGTRAP, current, 0);
> +
> +#ifdef CONFIG_UPROBES
> +       if (unlikely(current->utask))
> +               uprobe_free_utask();
> +#endif
>  }
>  
>  /**
> @@ -219,6 +225,10 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
>  static inline void tracehook_report_exit(long *exit_code)
>  {
>         ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
> +#ifdef CONFIG_UPROBES
> +       if (unlikely(current->utask))
> +               uprobe_free_utask();
> +#endif
>  }
>  
>  /**
> @@ -293,6 +303,10 @@ static inline void tracehook_report_clone(struct pt_regs *regs,
>                 sigaddset(&child->pending.signal, SIGSTOP);
>                 set_tsk_thread_flag(child, TIF_SIGPENDING);
>         }
> +#ifdef CONFIG_UPROBES
> +       if (unlikely(current->utask))
> +               uprobe_handle_clone(clone_flags, child);
> +#endif
>  }
>  
>  /**
> @@ -593,6 +607,10 @@ static inline void set_notify_resume(struct task_struct *task)
>   */
>  static inline void tracehook_notify_resume(struct pt_regs *regs)
>  {
> +#ifdef CONFIG_UPROBES
> +       if (current->utask && current->utask->active_ppt)
> +               uprobe_notify_resume(regs);
> +#endif
>  }
>  #endif /* TIF_NOTIFY_RESUME */


Everybody else simply places callbacks in kernel/fork.c and
kernel/exit.c, but as it is I don't think you want per-task state like
this.

One thing I would like to see is a slot per task, that has a number of
advantages over the current patch-set in that it doesn't have one page
limit in number of probe sites, nor do you need to insert vmas into each
and every address space that happens to have your DSO mapped.

Also, I would simply kill the user_bkpt stuff and merge it into uprobes,
we don't have a kernel_bkpt thing either, only kprobes.


