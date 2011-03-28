Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1C1Iep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:34:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37333 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1C1Ieo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Mon, 28 Mar 2011 04:34:44 -0400
Message-Id: <4D90647902000078000389CB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 28 Mar 2011 09:35:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
        "Alexander van Heukelum" <heukelum@fastmail.fm>,
        "Dipankar Sarma" <dipankar@in.ibm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Sam Ravnborg" <sam@ravnborg.org>,
        "David Howells" <dhowells@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Roland McGrath" <roland@redhat.com>,
        "Serge Hallyn" <serue@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com>
 <4D8FF9BC.7050609@cn.fujitsu.com>
In-Reply-To: <4D8FF9BC.7050609@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.03.11 at 05:00, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> We can not include linux/sched.h in linux/rcupdate.h.
> If we access task's task_rcu_strut without linux/sched.h included,
> We will failed with compiling error.
> 
> So we add TASK_RCU_OFFSET, which help us access
> task's task_rcu_strut without linux/sched.h included.
> Now, task_rcu_struct(), current_task_rcu_struct(), task_of_task_rcu() and
> rcu_copy_process() can be used anywhere without linux/sched.h included.

Aren't the offsets-generation methods meant for assembly
consumption only? Header dependency problems normally can
be solved by splitting headers into a type declaration one and
a second one carrying inline function implementations. Is that
indeed completely impossible here?

Jan

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/rcupdate.h |   49 
> +++++++++++++++++++++++++++++++++++++++++----
>  kernel/kernel-offsets.c  |    3 ++
>  2 files changed, 47 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 3500138..a5ed3fe 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -140,11 +140,50 @@ static inline void init_task_rcu_struct(struct 
> task_rcu_struct *task_rcu)
>  #endif
>  }
>  
> -#define task_rcu_struct(t) (&(t)->task_rcu_struct)
> -#define current_task_rcu_struct() task_rcu_struct(current)
> -#define task_of_task_rcu(task_rcu) container_of(task_rcu, struct 
> task_struct,\
> -				   task_rcu_struct)
> -#define rcu_copy_process(tsk) init_task_rcu_struct(task_rcu_struct(tsk))
> +#ifdef __KBUILD_GENARATING__
> +/*
> + * Very eary kbuild stage, many important defines including TASK_RCU_OFFSET
> + * are not available, use dummies to avoid compiling errors.
> + */
> +static inline
> +struct task_rcu_struct *task_rcu_struct(struct task_struct *t)
> +{
> +	(void)t;
> +	return (struct task_rcu_struct *)0x3L;
> +}
> +
> +static inline
> +struct task_struct *task_of_task_rcu(struct task_rcu_struct *task_rcu)
> +{
> +	(void)task_rcu;
> +	return (struct task_struct *)-0x3L;
> +}
> +#else
> +/* for generated TASK_RCU_OFFSET */
> +#include <generated/kernel-offsets.h>
> +
> +static inline
> +struct task_rcu_struct *task_rcu_struct(struct task_struct *t)
> +{
> +	return (struct task_rcu_struct *)(((void *)t) + TASK_RCU_OFFSET);
> +}
> +
> +static inline
> +struct task_struct *task_of_task_rcu(struct task_rcu_struct *task_rcu)
> +{
> +	return (struct task_struct *)(((void *)task_rcu) - TASK_RCU_OFFSET);
> +}
> +#endif
> +
> +static inline struct task_rcu_struct *current_task_rcu_struct(void)
> +{
> +	return task_rcu_struct(current);
> +}
> +
> +static inline void rcu_copy_process(struct task_struct *tsk)
> +{
> +	init_task_rcu_struct(task_rcu_struct(tsk));
> +}
>  
>  #ifdef CONFIG_PREEMPT_RCU
>  
> diff --git a/kernel/kernel-offsets.c b/kernel/kernel-offsets.c
> index fb73ccf..a890511 100644
> --- a/kernel/kernel-offsets.c
> +++ b/kernel/kernel-offsets.c
> @@ -4,11 +4,14 @@
>   * Copyright (C) 2010 Lai Jiangshan
>   */
>  
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
>  #include <linux/kbuild.h>
>  
>  void foo(void);
>  
>  void foo(void)
>  {
> +	OFFSET(TASK_RCU_OFFSET, task_struct, task_rcu_struct);
>  }
>  
> -- 
> 1.7.4



