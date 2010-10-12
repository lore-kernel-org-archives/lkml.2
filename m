Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0JLGdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:33:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0JLGdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:33:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=tl8qrN4qrUcIqAChVjwlXSXOT+vuVD+iWNLd/HLrnMesf60bOKvzVALFpbjt73ltR
	zWN3tKEQ7PBoaYxSo15ww==
From: Greg Thelen <gthelen@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: INFO: suspicious rcu_dereference_check() usage - kernel/sched.c:618 invoked rcu_dereference_check() without protection!
References: <xr93lj64dx6s.fsf@ninji.mtv.corp.google.com>
	<20101012042030.GB2496@linux.vnet.ibm.com>
Date: Mon, 11 Oct 2010 23:33:48 -0700
In-Reply-To: <20101012042030.GB2496@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Mon, 11 Oct 2010 21:20:30 -0700")
Message-ID: <xr93fwwbex83.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Mon, Oct 11, 2010 at 06:19:55PM -0700, Greg Thelen wrote:
>> I reliably see a rcu_dereference_check() failure on with v2.6.36-rc7 in
>> a 512MiB VM.  I would be happy to test out proposed patches to this
>> issue.
>
> Hello, Greg,
>
> Commit 6506cf6ce68 in my -rcu tree should address this.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

The patches fixed the reported problem for me in 2.6.36-rc7.  Thanks!

Now I see a different suspicious rcu_dereference_check(), which I will
be reporting in a separate thread.

> Please see below for a patch against tip/core/rcu that gathers up the
> four commits.
>
>> [    0.036082] lockdep: fixing up alternatives.
>> [    0.037184]
>> [    0.037185] ===================================================
>> [    0.037999] [ INFO: suspicious rcu_dereference_check() usage. ]
>> [    0.037999] ---------------------------------------------------
>> [    0.037999] kernel/sched.c:618 invoked rcu_dereference_check() without protection!
>> [    0.037999]
>> [    0.037999] other info that might help us debug this:
>> [    0.037999]
>> [    0.037999]
>> [    0.037999] rcu_scheduler_active = 1, debug_locks = 0
>> [    0.037999] 3 locks held by kworker/0:0/4:
>> [    0.037999]  #0:  (events){+.+.+.}, at: [<ffffffff8105647d>] process_one_work+0x195/0x422
>> [    0.037999]  #1:  ((&c_idle.work)){+.+.+.}, at: [<ffffffff8105647d>] process_one_work+0x195/0x422
>> [    0.037999]  #2:  (&rq->lock){-.-...}, at: [<ffffffff81584f49>] init_idle+0x2b/0x114
>> [    0.037999]
>> [    0.037999] stack backtrace:
>> [    0.037999] Pid: 4, comm: kworker/0:0 Not tainted 2.6.36-rc7 #1
>> [    0.037999] Call Trace:
>> [    0.037999]  [<ffffffff8106c273>] lockdep_rcu_dereference+0xaa/0xb2
>> [    0.037999]  [<ffffffff810331b1>] task_group+0x7b/0x8b
>> [    0.037999]  [<ffffffff810331d6>] set_task_rq+0x15/0x40
>> [    0.037999]  [<ffffffff81584fef>] init_idle+0xd1/0x114
>> [    0.037999]  [<ffffffff815853de>] fork_idle+0xb8/0xc9
>> [    0.037999]  [<ffffffff8103b13a>] ? check_preempt_wakeup+0xf0/0x177
>> [    0.037999]  [<ffffffff81583a88>] do_fork_idle+0x17/0x28
>> [    0.037999]  [<ffffffff8105654d>] process_one_work+0x265/0x422
>> [    0.037999]  [<ffffffff8105647d>] ? process_one_work+0x195/0x422
>> [    0.037999]  [<ffffffff8103cf3e>] ? wake_up_process+0x10/0x12
>> [    0.037999]  [<ffffffff8105810a>] ? manage_workers+0x106/0x191
>> [    0.037999]  [<ffffffff810582cb>] worker_thread+0x136/0x24c
>> [    0.037999]  [<ffffffff81058195>] ? worker_thread+0x0/0x24c
>> [    0.037999]  [<ffffffff8105b86c>] kthread+0x7d/0x85
>> [    0.037999]  [<ffffffff810039d4>] kernel_thread_helper+0x4/0x10
>> [    0.037999]  [<ffffffff8158ae00>] ? restore_args+0x0/0x30
>> [    0.037999]  [<ffffffff8105b7ef>] ? kthread+0x0/0x85
>> [    0.037999]  [<ffffffff810039d0>] ? kernel_thread_helper+0x0/0x10
>> 
>> Below is the .config, which was generated from:
>> $ make defconfig
>> $ make menuconfig
>> - enable CONFIG_SPINLOCK_SLEEP
>> - enable CONFIG_PREEMPT
>> - enable CONFIG_PROVE_LOCKING
>> - enable CONFIG_PROVE_RCU
>
> Please let me know how it goes!
>
> 							Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e750735..ccdc04c 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -545,9 +545,9 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
>  
>  	if (rcu_cpu_stall_suppress)
>  		return;
> -	delta = jiffies - rsp->jiffies_stall;
> +	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
>  	rnp = rdp->mynode;
> -	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
> +	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
>  
>  		/* We haven't checked in, so go dump stack. */
>  		print_cpu_stall(rsp);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc85ceb..ae8f75a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5337,7 +5337,19 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
>  	idle->se.exec_start = sched_clock();
>  
>  	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
> +	/*
> +	 * We're having a chicken and egg problem, even though we are
> +	 * holding rq->lock, the cpu isn't yet set to this cpu so the
> +	 * lockdep check in task_group() will fail.
> +	 *
> +	 * Similar case to sched_fork(). / Alternatively we could
> +	 * use task_rq_lock() here and obtain the other rq->lock.
> +	 *
> +	 * Silence PROVE_RCU
> +	 */
> +	rcu_read_lock();
>  	__set_task_cpu(idle, cpu);
> +	rcu_read_unlock();
>  
>  	rq->curr = rq->idle = idle;
>  #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..5f996d3 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3751,8 +3751,11 @@ static void task_fork_fair(struct task_struct *p)
>  
>  	update_rq_clock(rq);
>  
> -	if (unlikely(task_cpu(p) != this_cpu))
> +	if (unlikely(task_cpu(p) != this_cpu)) {
> +		rcu_read_lock();
>  		__set_task_cpu(p, this_cpu);
> +		rcu_read_unlock();
> +	}
>  
>  	update_curr(cfs_rq);
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index ef30e9d..7d99e13 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1078,8 +1078,11 @@ static void sk_prot_free(struct proto *prot, struct sock *sk)
>  #ifdef CONFIG_CGROUPS
>  void sock_update_classid(struct sock *sk)
>  {
> -	u32 classid = task_cls_classid(current);
> +	u32 classid;
>  
> +	rcu_read_lock();  /* doing current task, which cannot vanish. */
> +	classid = task_cls_classid(current);
> +	rcu_read_unlock();
>  	if (classid && classid != sk->sk_classid)
>  		sk->sk_classid = classid;
>  }
