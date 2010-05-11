Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0EKIy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:54:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41522 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab0EKIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:54:52 -0400
Date: Tue, 11 May 2010 03:54:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pids: fix fork_idle() to setup ->pids correctly
Message-ID: <20100511085410.GA22688@us.ibm.com>
References: <4BE01C86.3050908@secunet.com>
 <20100509184510.GA15219@redhat.com>
 <4BE7B3BD.70901@secunet.com>
 <20100510194917.GA5249@redhat.com>
 <20100510195038.GD5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510195038.GD5249@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> copy_process(pid => &init_struct_pid) doesn't do attach_pid/etc.
> 
> It shouldn't, but this means that the idle threads run with the wrong
> pids copied from the caller's task_struct. In x86 case the caller is
> either kernel_init() thread or keventd.
> 
> In particular, this means that after the series of cpu_up/cpu_down an
> idle thread (which never exits) can run with .pid pointing to nowhere.
> 
> Change fork_idle() to initialize idle->pids[] correctly. We only set
> .pid = &init_struct_pid but do not add .node to list, INIT_TASK() does
> the same for the boot-cpu idle thread (swapper).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Serge E. Hallyn <serue@us.ibm.com>

> ---
> 
>  kernel/fork.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> --- 34-rc1/kernel/fork.c~3_FORK_IDLE_SET_PIDS	2010-03-24 18:07:03.000000000 +0100
> +++ 34-rc1/kernel/fork.c	2010-05-10 20:45:33.000000000 +0200
> @@ -1339,6 +1339,16 @@ noinline struct pt_regs * __cpuinit __at
>  	return regs;
>  }
> 
> +static inline void init_idle_pids(struct pid_link *links)
> +{
> +	enum pid_type type;
> +
> +	for (type = PIDTYPE_PID; type < PIDTYPE_MAX; ++type) {
> +		INIT_HLIST_NODE(&links[type].node); /* not really needed */
> +		links[type].pid = &init_struct_pid;
> +	}
> +}
> +
>  struct task_struct * __cpuinit fork_idle(int cpu)
>  {
>  	struct task_struct *task;
> @@ -1346,8 +1356,10 @@ struct task_struct * __cpuinit fork_idle
> 
>  	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
>  			    &init_struct_pid, 0);
> -	if (!IS_ERR(task))
> +	if (!IS_ERR(task)) {
> +		init_idle_pids(task->pids);
>  		init_idle(task, cpu);
> +	}
> 
>  	return task;
>  }
