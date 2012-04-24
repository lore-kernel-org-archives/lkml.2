Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2DXB3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:29:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:29815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab2DXB3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134445459"
Message-ID: <1335231007.14538.71.camel@ymzhang.sh.intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Tue, 24 Apr 2012 09:30:07 +0800
In-Reply-To: <1334915073.2463.36.camel@laptop>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
	 <1334915073.2463.36.camel@laptop>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 11:44 +0200, Peter Zijlstra wrote:
> On Wed, 2012-04-11 at 08:07 +0000, Tu, Xiaobing wrote:
> > From: xiaobing tu <xiaobing.tu@intel.com> 
> > 
> > Here is the kernel patch for this tool, The idea is to output user
> > space stack call-chain from /proc/xxx/stack,
> > currently, /proc/xxx/stack only output kernel stack call chain. We
> > extend it to output user space call chain in hex format
> > 
> > Signed-off-by: yanmin zhang <yanmin_zhang@linux.intel.com>
> > Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> 
> Ok, so I don't like it.. for one I really don't see the need for this,
Sorry. We didn't write down enough information about why we implemented
it. Cong asked the similar question and I explained it in separate emails.
https://lkml.org/lkml/2012/4/19/11
https://lkml.org/lkml/2012/4/19/27

> secondly the implementation is crappy,
I agree it's a little crappy. Other methods like ptrace is slow although
the codes look like clean. When ptrace is slow and might have other
bad impact, could we also say it's crappy?


>  thirdly the interface is poor.
> 
> > ---
> >  arch/x86/kernel/stacktrace.c |   55 ++++++++++++++++++++++++++++++++++++++++++
> >  fs/proc/base.c               |   19 +++++++++++++-
> >  include/linux/stacktrace.h   |    5 +++-
> >  3 files changed, 77 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c index fdd0c64..d802f05 100644
> > --- a/arch/x86/kernel/stacktrace.c
> > +++ b/arch/x86/kernel/stacktrace.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/stacktrace.h>
> >  #include <linux/module.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/mm.h>
> >  #include <asm/stacktrace.h>
> >  
> >  static int save_stack_stack(void *data, char *name) @@ -144,3 +145,57 @@ void save_stack_trace_user(struct stack_trace *trace)
> >  		trace->entries[trace->nr_entries++] = ULONG_MAX;  }
> >  
> > +static inline void __save_stack_trace_user_task(struct task_struct *task,
> > +		struct stack_trace *trace)
> > +{
> > +	const struct pt_regs *regs = task_pt_regs(task);
> > +	const void __user *fp;
> > +	unsigned long addr;
> > +
> > +	if (task != current && task->state == TASK_RUNNING && task->on_cpu) {
> > +		/* To trap into kernel at least once */
> > +		smp_send_reschedule(task_cpu(task));
> > +	}
> 
> This doesn't make any sense at all..
ptrace could put the task to a either STOPPED or TRACED state.
But it's time-consuming.

> 
> > +
> > +	fp = (const void __user *)regs->bp;
> > +	if (trace->nr_entries < trace->max_entries)
> > +		trace->entries[trace->nr_entries++] = regs->ip;
> > +
> > +	while (trace->nr_entries < trace->max_entries) {
> > +		struct stack_frame_user frame;
> > +
> > +		frame.next_fp = NULL;
> > +		frame.ret_addr = 0;
> > +
> > +		addr = (unsigned long)fp;
> > +		if (!access_process_vm(task, addr, (void *)&frame,
> > +				sizeof(frame), 0))
> > +			break;
> > +		if ((unsigned long)fp < regs->sp)
> > +			break;
> > +		if (frame.ret_addr) {
> > +			trace->entries[trace->nr_entries++] =
> > +				frame.ret_addr;
> > +		}
> > +		if (fp == frame.next_fp)
> > +			break;
> > +		fp = frame.next_fp;
> > +	}
> > +}
> > +
> > +void save_stack_trace_user_task(struct task_struct *task,
> > +		struct stack_trace *trace)
> > +{
> > +	if (task == current || !task) {
> > +		save_stack_trace_user(trace);
> > +		return;
> > +	}
> > +
> > +	if (task->mm)
> > +		__save_stack_trace_user_task(task, trace);
> > +
> > +	if (trace->nr_entries < trace->max_entries)
> > +		trace->entries[trace->nr_entries++] = ULONG_MAX; } 
> > +EXPORT_SYMBOL_GPL(save_stack_trace_user_task);
> 
> There's already userspace stack walkers, don't reimplement them yet
> again.
Would you like to point out the workable userspace stack walker?
If there is, we would check if we could reuse it.

> 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c index d4548dd..603e708 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -327,8 +327,25 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
> >  			seq_printf(m, "[<%pK>] %pS\n",
> >  				   (void *)entries[i], (void *)entries[i]);
> >  		}
> > -		unlock_trace(task);
> > +	} else
> > +		goto out;
> > +
> > +	trace.nr_entries	= 0;
> > +	trace.max_entries	= MAX_STACK_TRACE_DEPTH;
> > +	trace.entries		= entries;
> > +	trace.skip		= 0;
> > +
> > +	seq_printf(m, "userspace\n");
> > +
> > +	save_stack_trace_user_task(task, &trace);
> > +
> > +	for (i = 0; i < trace.nr_entries; i++) {
> > +		if (entries[i] != ULONG_MAX)
> > +			seq_printf(m, "%p\n", (void *)entries[i]);
> >  	}
> > +	unlock_trace(task);
> > +
> > +out:
> 
> Writing out just the IPs means you have to have a stored snapshot
> of /proc/$PID/maps around to make any sense of them. This seems a
> relatively poor interface.
Good question.

When implementing it, we had similar questions.
1) Could the parser get the correct data in time, especially when the process
is running fast and doesn't sleep?
2) If /proc/XXX/maps is changing, i.e. it mmaps/munmaps frequently, could
the parser parse data correctly? That's an issue indeed. But Most applications
don't do so.

Currently, in user space, we collect both the HEX stack data and maps,
then save them to a trace file. After all collection is done, we do
the symbol parsing. That mitigates 2) dramatically.

The safest way is to stop the process at a special state, like TASK_STOPPED
or TASK_TRACED. Then, get data and parse. Then, let the process restore. Such
way is used to check more detailed data like variables, and change them by gdb.
But it's too slow and might have bad impact on running system. You might say
it's debugging stuff and debugger should look for a good approach. I don't
think such speaking is to resolve the issue. We need provide more tools to
help developers.

Usage scenario:
A) Performance debug:
When debuggers want to do a quick checking, they don't care if the first
try could get the exact data as system is RUNNING. They would get the data
for many times. So above question 1) doesn't hurt the utilization.
B) Android ANR issue debug: We did root cause some ANR issues with our tools.


Thanks for the comments and sorry for taking you too much time.

Yanmin


