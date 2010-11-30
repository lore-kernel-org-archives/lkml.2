Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0K3TCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:02:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0K3TCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:02:15 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=XdCD_VzSwh4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=meVymXHHAAAA:8 a=iSgD_WWdJJCsgZV-QeEA:9 a=Htfk4LoezTes4wXUqDRcOWgrx30A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: make pushable_tasks CONFIG_SMP dependant.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dario Faggioli <raistlin@linux.it>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <1291143093.2697.298.camel@Palantir>
References: <1291143093.2697.298.camel@Palantir>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 30 Nov 2010 14:02:12 -0500
Message-ID: <1291143732.27486.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 19:51 +0100, Dario Faggioli wrote:
> As noted by Peter Zijlstra here https://lkml.org/lkml/2010/11/10/391
> (while reviewing other stuff, though), tracking pushable tasks
> only makes sense on SMPs.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> ---
>  include/linux/init_task.h |    9 ++++++++-
>  include/linux/sched.h     |    2 ++
>  kernel/sched.c            |    2 ++
>  3 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 1f8c06c..6ed8812 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -12,6 +12,13 @@
>  #include <linux/securebits.h>
>  #include <net/net_namespace.h>
>  
> +#ifdef CONFIG_SMP
> +# define INIT_PUSHABLE_TASKS(tsk)					\
> +	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO),
> +#else
> +# define INIT_PUSHABLE_TASKS(tsk)
> +#endif
> +
>  extern struct files_struct init_files;
>  extern struct fs_struct init_fs;
>  
> @@ -137,7 +144,7 @@ extern struct cred init_cred;
>  		.nr_cpus_allowed = NR_CPUS,				\
>  	},								\
>  	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
> -	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
> +	INIT_PUSHABLE_TASKS(tsk)					\
>  	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
>  	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
>  	.real_parent	= &tsk,						\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b0fc8ee..eae4131 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1244,7 +1244,9 @@ struct task_struct {
>  #endif
>  
>  	struct list_head tasks;
> +#ifdef CONFIG_SMP
>  	struct plist_node pushable_tasks;
> +#endif
>  
>  	struct mm_struct *mm, *active_mm;
>  #if defined(SPLIT_RSS_COUNTING)
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0debad9..166f9f8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2595,7 +2595,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  	/* Want to start with kernel preemption disabled. */
>  	task_thread_info(p)->preempt_count = 1;
>  #endif
> +#ifdef CONFIG_SMP
>  	plist_node_init(&p->pushable_tasks, MAX_PRIO);
> +#endif
>  
>  	put_cpu();
>  }
> -- 
> 1.7.2.3
> 


