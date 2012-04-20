Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2DTJok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:44:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43204 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2DTJoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:44:39 -0400
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
In-Reply-To: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 11:44:33 +0200
Message-ID: <1334915073.2463.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 08:07 +0000, Tu, Xiaobing wrote:
> From: xiaobing tu <xiaobing.tu@intel.com> 
> 
> Here is the kernel patch for this tool, The idea is to output user
> space stack call-chain from /proc/xxx/stack,
> currently, /proc/xxx/stack only output kernel stack call chain. We
> extend it to output user space call chain in hex format
> 
> Signed-off-by: yanmin zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>

Ok, so I don't like it.. for one I really don't see the need for this,
secondly the implementation is crappy, thirdly the interface is poor.

> ---
>  arch/x86/kernel/stacktrace.c |   55 ++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/base.c               |   19 +++++++++++++-
>  include/linux/stacktrace.h   |    5 +++-
>  3 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c index fdd0c64..d802f05 100644
> --- a/arch/x86/kernel/stacktrace.c
> +++ b/arch/x86/kernel/stacktrace.c
> @@ -7,6 +7,7 @@
>  #include <linux/stacktrace.h>
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
> +#include <linux/mm.h>
>  #include <asm/stacktrace.h>
>  
>  static int save_stack_stack(void *data, char *name) @@ -144,3 +145,57 @@ void save_stack_trace_user(struct stack_trace *trace)
>  		trace->entries[trace->nr_entries++] = ULONG_MAX;  }
>  
> +static inline void __save_stack_trace_user_task(struct task_struct *task,
> +		struct stack_trace *trace)
> +{
> +	const struct pt_regs *regs = task_pt_regs(task);
> +	const void __user *fp;
> +	unsigned long addr;
> +
> +	if (task != current && task->state == TASK_RUNNING && task->on_cpu) {
> +		/* To trap into kernel at least once */
> +		smp_send_reschedule(task_cpu(task));
> +	}

This doesn't make any sense at all..

> +
> +	fp = (const void __user *)regs->bp;
> +	if (trace->nr_entries < trace->max_entries)
> +		trace->entries[trace->nr_entries++] = regs->ip;
> +
> +	while (trace->nr_entries < trace->max_entries) {
> +		struct stack_frame_user frame;
> +
> +		frame.next_fp = NULL;
> +		frame.ret_addr = 0;
> +
> +		addr = (unsigned long)fp;
> +		if (!access_process_vm(task, addr, (void *)&frame,
> +				sizeof(frame), 0))
> +			break;
> +		if ((unsigned long)fp < regs->sp)
> +			break;
> +		if (frame.ret_addr) {
> +			trace->entries[trace->nr_entries++] =
> +				frame.ret_addr;
> +		}
> +		if (fp == frame.next_fp)
> +			break;
> +		fp = frame.next_fp;
> +	}
> +}
> +
> +void save_stack_trace_user_task(struct task_struct *task,
> +		struct stack_trace *trace)
> +{
> +	if (task == current || !task) {
> +		save_stack_trace_user(trace);
> +		return;
> +	}
> +
> +	if (task->mm)
> +		__save_stack_trace_user_task(task, trace);
> +
> +	if (trace->nr_entries < trace->max_entries)
> +		trace->entries[trace->nr_entries++] = ULONG_MAX; } 
> +EXPORT_SYMBOL_GPL(save_stack_trace_user_task);

There's already userspace stack walkers, don't reimplement them yet
again.

> diff --git a/fs/proc/base.c b/fs/proc/base.c index d4548dd..603e708 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -327,8 +327,25 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
>  			seq_printf(m, "[<%pK>] %pS\n",
>  				   (void *)entries[i], (void *)entries[i]);
>  		}
> -		unlock_trace(task);
> +	} else
> +		goto out;
> +
> +	trace.nr_entries	= 0;
> +	trace.max_entries	= MAX_STACK_TRACE_DEPTH;
> +	trace.entries		= entries;
> +	trace.skip		= 0;
> +
> +	seq_printf(m, "userspace\n");
> +
> +	save_stack_trace_user_task(task, &trace);
> +
> +	for (i = 0; i < trace.nr_entries; i++) {
> +		if (entries[i] != ULONG_MAX)
> +			seq_printf(m, "%p\n", (void *)entries[i]);
>  	}
> +	unlock_trace(task);
> +
> +out:

Writing out just the IPs means you have to have a stored snapshot
of /proc/$PID/maps around to make any sense of them. This seems a
relatively poor interface.

