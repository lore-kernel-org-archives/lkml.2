Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0KIUQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:16:34 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37688 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab0KIUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:16:33 -0500
Date: Tue, 9 Nov 2010 12:15:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jaxboe@fusionio.com
Subject: Re: [PATCH] ioprio: rcu_read_lock/unlock protect find_task_by_vpid
 call (V2)
Message-ID: <20101109201557.GS4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101109102124.GA3916@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109102124.GA3916@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:21:24PM +0200, Sergey Senozhatsky wrote:
> Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
> find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
> Assertion failed in sys_ioprio_get. The patch is fixing assertion
> failure in ioprio_set as well.
> 
>  kernel/pid.c:419 invoked rcu_dereference_check() without protection!
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
> V2: rcu critical section expanded according to comment by Paul E. McKenne:
> | Looking over the patch again, the scope of the RCU read-side critical
> | section needs to expand to cover the use of the pointer as well as the
> | call to find_task_by_vpid().

Thank you, Sergey!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Jens, are you willing to take this one?

							Thanx, Paul

> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
> diff --git a/fs/ioprio.c b/fs/ioprio.c
> index 748cfb9..64cd50b 100644
> --- a/fs/ioprio.c
> +++ b/fs/ioprio.c
> @@ -111,12 +111,14 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
>  	read_lock(&tasklist_lock);
>  	switch (which) {
>  		case IOPRIO_WHO_PROCESS:
> +			rcu_read_lock();
>  			if (!who)
>  				p = current;
>  			else
>  				p = find_task_by_vpid(who);
>  			if (p)
>  				ret = set_task_ioprio(p, ioprio);
> +			rcu_read_unlock();
>  			break;
>  		case IOPRIO_WHO_PGRP:
>  			if (!who)
> @@ -200,12 +202,14 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
>  	read_lock(&tasklist_lock);
>  	switch (which) {
>  		case IOPRIO_WHO_PROCESS:
> +			rcu_read_lock();
>  			if (!who)
>  				p = current;
>  			else
>  				p = find_task_by_vpid(who);
>  			if (p)
>  				ret = get_task_ioprio(p);
> +			rcu_read_unlock();
>  			break;
>  		case IOPRIO_WHO_PGRP:
>  			if (!who)
> 
