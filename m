Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab2DYC57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:57:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:59016 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829Ab2DYC56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133486798"
Message-ID: <1335322697.14538.116.camel@ymzhang.sh.intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Wed, 25 Apr 2012 10:58:17 +0800
In-Reply-To: <1335262248.28150.191.camel@twins>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
	 <1334915073.2463.36.camel@laptop>
	 <1335231007.14538.71.camel@ymzhang.sh.intel.com>
	 <1335262248.28150.191.camel@twins>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 12:10 +0200, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 09:30 +0800, Yanmin Zhang wrote:
> > > > +static inline void __save_stack_trace_user_task(struct task_struct *task,
> > > > +           struct stack_trace *trace)
> > > > +{
> > > > +   const struct pt_regs *regs = task_pt_regs(task);
> > > > +   const void __user *fp;
> > > > +   unsigned long addr;
> > > > +
> > > > +   if (task != current && task->state == TASK_RUNNING && task->on_cpu) {
> > > > +           /* To trap into kernel at least once */
> > > > +           smp_send_reschedule(task_cpu(task));
> > > > +   }
> > > 
> > > This doesn't make any sense at all..
> > ptrace could put the task to a either STOPPED or TRACED state.
> > But it's time-consuming. 
> 
> Yeah, but what is the above meant to achieve? it doesn't actually stop
> the task or anything, it will just trap the remote cpu, by the time you
> do your stack walk below the cpu might be running another task entirely
> or you're walking a life stack with all the 'fun' issues that'll bring.
When we access the user space stack, it's based on _task_, not cpu.

The IPI is to make sure the task could trap into kernel at least once,
so we could get its regs->bp. If the task is running on another cpu
for a long time, the regs->bp might be too old. I am also a little worried
about that if the task restores to user space to run quickly after the IPI,
regs->bp might be ruined. If it's true, we might get bad data, or couldn't
get useful data.

See below codes.
+       const struct pt_regs *regs = task_pt_regs(task);
Above pt_regs is task's, not current's.

+       const void __user *fp;
+       unsigned long addr;
+
+       if (task != current && task->state == TASK_RUNNING && task->on_cpu) {
+               /* To trap into kernel at least once */
+               smp_send_reschedule(task_cpu(task));
+       }
+
+       fp = (const void __user *)regs->bp;
+       if (trace->nr_entries < trace->max_entries)
+               trace->entries[trace->nr_entries++] = regs->ip;
+
+       while (trace->nr_entries < trace->max_entries) {
+               struct stack_frame_user frame;
+
+               frame.next_fp = NULL;
+               frame.ret_addr = 0;
+
+               addr = (unsigned long)fp;
+               if (!access_process_vm(task, addr, (void *)&frame,
+                               sizeof(frame), 0))
Above line would access the task's user space stack.

We implemented the tool based on real requirement and it's not perfect. So
we need your expertise help.

Thanks for the comments.

Yanmin


