Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895Ab0J2UX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:23:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48876 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761852Ab0J2UX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:23:56 -0400
Date: Fri, 29 Oct 2010 13:16:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101029201648.GK2367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029125550.GA3932@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 03:55:50PM +0300, Sergey Senozhatsky wrote:
> Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for 
> find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
> Assertion failed in sys_ioprio_get. The patch is fixing assertion
> failure in ioprio_set as well. 
> 
>  ===================================================
>  [ INFO: suspicious rcu_dereference_check() usage. ]
>  ---------------------------------------------------
>  kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> 
>  rcu_scheduler_active = 1, debug_locks = 0
>  1 lock held by iotop/4254:
>  #0:  (tasklist_lock){.?.?..}, at: [<ffffffff811104b4>] sys_ioprio_get+0x22/0x2da
> 
>  stack backtrace:
>  Pid: 4254, comm: iotop Not tainted
>  Call Trace:
>  [<ffffffff810656f2>] lockdep_rcu_dereference+0xaa/0xb2
>  [<ffffffff81053c67>] find_task_by_pid_ns+0x4f/0x68
>  [<ffffffff81053c9d>] find_task_by_vpid+0x1d/0x1f
>  [<ffffffff811104e2>] sys_ioprio_get+0x50/0x2da
>  [<ffffffff81002182>] system_call_fastpath+0x16/0x1b
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
> diff --git a/fs/ioprio.c b/fs/ioprio.c
> index 748cfb9..666343d 100644
> --- a/fs/ioprio.c
> +++ b/fs/ioprio.c
> @@ -113,8 +113,11 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)

Interesting...

The task-list lock is read-held at this point, which should mean that
the PID mapping cannot change.  The lockdep_tasklist_lock_is_held()
function does lockdep_is_held(&tasklist_lock), which must therefore
only be checking for write-holding the lock.  The fix would be to
make lockdep_tasklist_lock_is_held() check for either read-holding or
write-holding tasklist lock.

Or is there some subtle reason that read-holding the tasklist lock is
not sufficient?

							Thanx, Paul

>  		case IOPRIO_WHO_PROCESS:
>  			if (!who)
>  				p = current;
> -			else
> +			else {
> +				rcu_read_lock();
>  				p = find_task_by_vpid(who);
> +				rcu_read_unlock();
> +			}
>  			if (p)
>  				ret = set_task_ioprio(p, ioprio);
>  			break;
> @@ -202,8 +205,11 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
>  		case IOPRIO_WHO_PROCESS:
>  			if (!who)
>  				p = current;
> -			else
> +			else {
> +				rcu_read_lock();
>  				p = find_task_by_vpid(who);
> +				rcu_read_unlock();
> +			}
>  			if (p)
>  				ret = get_task_ioprio(p);
>  			break;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
