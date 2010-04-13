Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0DMSWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:22:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0DMSWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:22:46 -0400
Subject: Re: [RFC][PATCH 02/11] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267384639.13676.87.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
	 <1267384639.13676.87.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 20:22:18 +0200
Message-ID: <1271182938.4807.1880.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:17 +0100, Raistlin wrote:
> +++ b/kernel/fork.c
> @@ -937,6 +937,16 @@ SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
>         return task_pid_vnr(current);
>  }
>  
> +static void init_task_dl_entity(struct task_struct *p)
> +{
> +       RB_CLEAR_NODE(&p->dl.rb_node);
> +       hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +
> +       p->dl.dl_runtime = p->dl.runtime = 0;
> +       p->dl.dl_deadline = p->dl.deadline = 0;
> +       p->dl.flags = 0;
> +}
> +
>  static void rt_mutex_init_task(struct task_struct *p)
>  {
>         raw_spin_lock_init(&p->pi_lock);
> @@ -1025,6 +1035,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>         ftrace_graph_init_task(p);
>  
> +       init_task_dl_entity(p);
> +
>         rt_mutex_init_task(p);
>  

Why doesn't that live in/use sched_fork()?
