Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2APO4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:56:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50297 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab2APO4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:56:40 -0500
Date: Mon, 16 Jan 2012 20:15:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 7/9] tracing: uprobes trace_event interface
Message-ID: <20120116144538.GG10189@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120116131137.GB5265@m.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011614-8974-0000-0000-000005457570
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I've tested following event:
>         echo "p:probe_libc/free /lib64/libc-2.13.so:0x7a4f0 %ax" > ./uprobe_events
> 
> and commands like:
>         perf record -a -e probe_libc:free  --filter "common_pid == 1127"
>         perf record -e probe_libc:free --filter "arg1 == 0xa" ls
> 
> got me proper results.
> 

Okay thanks for the inputs.

> thanks,
> jirka
> 
> ---
> The preemption needs to be disabled when submitting data into perf.

I actually looked at other places where perf_trace_buf_prepare and
perf_trace_buf_submit are being called. for example perf_syscall_enter
and perf_syscall_exit both call the above routines and they didnt seem
to be called with premption disabled. Is that the way perf probe is
called in our case that needs us to call pre-emption here? Did you see a
case where calling these without preemption disabled caused a problem?


> ---
>  kernel/trace/trace_uprobe.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index af29368..4d3857c 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -653,9 +653,11 @@ static void uprobe_perf_func(struct trace_uprobe *tp, struct pt_regs *regs)
>  		     "profile buffer not large enough"))
>  		return;
> 
> +	preempt_disable();
> +
>  	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
>  	if (!entry)
> -		return;
> +		goto out;
> 
>  	entry->ip = get_uprobe_bkpt_addr(task_pt_regs(current));
>  	data = (u8 *)&entry[1];
> @@ -665,6 +667,8 @@ static void uprobe_perf_func(struct trace_uprobe *tp, struct pt_regs *regs)
> 
>  	head = this_cpu_ptr(call->perf_events);
>  	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
> + out:
> +	preempt_enable();
>  }
>  #endif	/* CONFIG_PERF_EVENTS */
> 

-- 
Thanks and Regards
Srikar

