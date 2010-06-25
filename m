Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0FYRsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:48:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44660 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0FYRsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:48:15 -0400
Date: Fri, 25 Jun 2010 10:48:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.35-rc3] Add RCU check for find_task_by_vpid().
Message-ID: <20100625174812.GF2432@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201006260108.JFJ86910.VMFOLOFFJOtSQH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006260108.JFJ86910.VMFOLOFFJOtSQH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 01:08:19AM +0900, Tetsuo Handa wrote:
> find_task_by_vpid() says "Must be called under rcu_read_lock().". But due to
> commit 3120438 "rcu: Disable lockdep checking in RCU list-traversal primitives",
> we are currently unable to catch "find_task_by_vpid() with tasklist_lock held
> but RCU lock not held" errors.
> 
>   ===================================================
>   [ INFO: suspicious rcu_dereference_check() usage. ]
>   ---------------------------------------------------
>   kernel/pid.c:386 invoked rcu_dereference_check() without protection!
>   
>   other info that might help us debug this:
>   
>   
>   rcu_scheduler_active = 1, debug_locks = 1
>   1 lock held by rc.sysinit/1102:
>    #0:  (tasklist_lock){.+.+..}, at: [<c1048340>] sys_setpgid+0x40/0x160
>   
>   stack backtrace:
>   Pid: 1102, comm: rc.sysinit Not tainted 2.6.35-rc3-dirty #1
>   Call Trace:
>    [<c105e714>] lockdep_rcu_dereference+0x94/0xb0
>    [<c104b4cd>] find_task_by_pid_ns+0x6d/0x70
>    [<c104b4e8>] find_task_by_vpid+0x18/0x20
>    [<c1048347>] sys_setpgid+0x47/0x160
>    [<c1002b50>] sysenter_do_call+0x12/0x36
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> diff --git a/kernel/pid.c b/kernel/pid.c
> index e9fd8c1..a257471 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -382,6 +382,9 @@ EXPORT_SYMBOL(pid_task);
>   */
>  struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
>  {
> +#ifdef __do_rcu_dereference_check
> +	__do_rcu_dereference_check(rcu_read_lock_held());
> +#endif

How about the following?

	WARN_ON_ONCE(!rcu_read_lock_held());

>  	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
>  }
> 
