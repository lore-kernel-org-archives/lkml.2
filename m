Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0F1Xlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:41:35 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57501 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0F1Xle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:41:34 -0400
Date: Mon, 28 Jun 2010 16:41:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.35-rc3] Add RCU check for find_task_by_vpid().
Message-ID: <20100628234120.GI2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201006260108.JFJ86910.VMFOLOFFJOtSQH@I-love.SAKURA.ne.jp>
 <20100625174812.GF2432@linux.vnet.ibm.com>
 <201006260741.FBG78196.FVQMFOHtOFSJOL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006260741.FBG78196.FVQMFOHtOFSJOL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 07:41:06AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > > diff --git a/kernel/pid.c b/kernel/pid.c
> > > index e9fd8c1..a257471 100644
> > > --- a/kernel/pid.c
> > > +++ b/kernel/pid.c
> > > @@ -382,6 +382,9 @@ EXPORT_SYMBOL(pid_task);
> > >   */
> > >  struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
> > >  {
> > > +#ifdef __do_rcu_dereference_check
> > > +	__do_rcu_dereference_check(rcu_read_lock_held());
> > > +#endif
> > 
> > How about the following?
> > 
> > 	WARN_ON_ONCE(!rcu_read_lock_held());
> > 
> > >  	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
> > >  }
> > > 
> Fine by me if you don't mind WARN_ON_ONCE(!1); for CONFIG_DEBUG_LOCK_ALLOC=n .
> Personally,
> 
> > >   ===================================================
> > >   [ INFO: suspicious rcu_dereference_check() usage. ]
> > >   ---------------------------------------------------
> > >   kernel/pid.c:386 invoked rcu_dereference_check() without protection!
> > >   
> > >   other info that might help us debug this:
> > >   
> > >   
> > >   rcu_scheduler_active = 1, debug_locks = 1
> > >   1 lock held by rc.sysinit/1102:
> > >    #0:  (tasklist_lock){.+.+..}, at: [<c1048340>] sys_setpgid+0x40/0x160
> > >   
> > >   stack backtrace:
> > >   Pid: 1102, comm: rc.sysinit Not tainted 2.6.35-rc3-dirty #1
> > >   Call Trace:
> > >    [<c105e714>] lockdep_rcu_dereference+0x94/0xb0
> > >    [<c104b4cd>] find_task_by_pid_ns+0x6d/0x70
> > >    [<c104b4e8>] find_task_by_vpid+0x18/0x20
> > >    [<c1048347>] sys_setpgid+0x47/0x160
> > >    [<c1002b50>] sysenter_do_call+0x12/0x36
> 
> is more helpful messages than messages by WARN_ON() (shown below).

OK, you convinced me.  ;-)  I will take your earlier patch and remove
the leading "__" from __do_rcu_dereference_check(), and make it be a
first-class RCU API citizen.

							Thanx, Paul

> Regards.
> ----------------------------------------
> [PATCH 2.6.35-rc3] Add RCU check for find_task_by_vpid().
> 
> find_task_by_vpid() says "Must be called under rcu_read_lock().". But due to
> commit 3120438 "rcu: Disable lockdep checking in RCU list-traversal primitives",
> we are currently unable to catch "find_task_by_vpid() with tasklist_lock held
> but RCU not held" errors.
> 
>   ------------[ cut here ]------------
>   WARNING: at kernel/pid.c:385 find_task_by_pid_ns+0x5b/0x70()
>   Hardware name: VMware Virtual Platform
>   Modules linked in: mptspi mptscsih mptbase scsi_transport_spi
>   Pid: 1102, comm: rc.sysinit Not tainted 2.6.35-rc3-dirty #1
>   Call Trace:
>    [<c104b4bb>] ? find_task_by_pid_ns+0x5b/0x70
>    [<c103783c>] warn_slowpath_common+0x7c/0xa0
>    [<c104b4bb>] ? find_task_by_pid_ns+0x5b/0x70
>    [<c103787d>] warn_slowpath_null+0x1d/0x20
>    [<c104b4bb>] find_task_by_pid_ns+0x5b/0x70
>    [<c104b4e8>] find_task_by_vpid+0x18/0x20
>    [<c1048347>] sys_setpgid+0x47/0x160
>    [<c1002b50>] sysenter_do_call+0x12/0x36
>   ---[ end trace e68939acb5ea5560 ]---
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> diff --git a/kernel/pid.c b/kernel/pid.c
> index e9fd8c1..7123215 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -382,6 +382,7 @@ EXPORT_SYMBOL(pid_task);
>   */
>  struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
>  {
> +	WARN_ON_ONCE(!rcu_read_lock_held());
>  	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
>  }
> 
