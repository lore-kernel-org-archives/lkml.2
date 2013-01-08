Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3AHO1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:27:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:37717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab3AHO1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:27:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="188861864"
Message-ID: <50EC2CB9.5090707@intel.com>
Date: Tue, 08 Jan 2013 22:27:05 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        preeti@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-10-git-send-email-alex.shi@intel.com> <50E7EAB1.6020302@intel.com> <50E92DC3.4050906@intel.com> <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
In-Reply-To: <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 02:31 AM, Linus Torvalds wrote:
> On Sat, Jan 5, 2013 at 11:54 PM, Alex Shi <alex.shi@intel.com> wrote:
>>
>> I just looked into the aim9 benchmark, in this case it forks 2000 tasks,
>> after all tasks ready, aim9 give a signal than all tasks burst waking up
>> and run until all finished.
>> Since each of tasks are finished very quickly, a imbalanced empty cpu
>> may goes to sleep till a regular balancing give it some new tasks. That
>> causes the performance dropping. cause more idle entering.
> 
> Sounds like for AIM (and possibly for other really bursty loads), we
> might want to do some load-balancing at wakeup time by *just* looking
> at the number of running tasks, rather than at the load average. Hmm?

Millions thanks for your suggestions! :)

It's worth to try use instant load -- nr_running in waking balancing, I
will try this. but in this case, I tried to print sleeping tasks by
print_task() in sched/debug.c. Find the 2000 tasks were forked on just 2
LCPUs which in different cpu sockets whenever with/without this load avg
patch.

So, I am wondering if it's worth to consider the sleeping tasks' load in
fork/wake balancing. Does anyone consider this in history?

===
print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
        if (rq->curr == p)
                SEQ_printf(m, "R");
+       else if (!p->on_rq)
+               SEQ_printf(m, "S");
        else
                SEQ_printf(m, " ");
...
@@ -166,13 +170,14 @@ static void print_rq(struct seq_file *m, struct rq
*rq, int rq_cpu)
        read_lock_irqsave(&tasklist_lock, flags);

        do_each_thread(g, p) {
-               if (!p->on_rq || task_cpu(p) != rq_cpu)
+               if (task_cpu(p) != rq_cpu)
                        continue;
===

> 
> The load average is fundamentally always going to run behind a bit,
> and while you want to use it for long-term balancing, a short-term you
> might want to do just a "if we have a huge amount of runnable
> processes, do a load balancing *now*". Where "huge amount" should
> probably be relative to the long-term load balancing (ie comparing the
> number of runnable processes on this CPU right *now* with the load
> average over the last second or so would show a clear spike, and a
> reason for quick action).

Many thanks for suggestion!
Will try it. :)
> 
>            Linus
> 
