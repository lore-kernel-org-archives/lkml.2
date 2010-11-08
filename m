Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0KHQBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:01:49 -0500
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:47103 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753022Ab0KHQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:01:48 -0500
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101029125550.GA3932@swordfish.minsk.epam.com>
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 13:01:35 -0300
Message-ID: <1289232095.2206.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 15:55 +0300, Sergey Senozhatsky wrote:
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

If you add the rcu_read_lock/unlock() sections, we would also need to
update the comment above accordingly.

Thanks,
Davidlohr

From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH] ioprio: remove comment to not use RCU

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/ioprio.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ioprio.c b/fs/ioprio.c
index 748cfb9..72d71de 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -103,11 +103,6 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who,
int, ioprio)
 	}
 
 	ret = -ESRCH;
-	/*
-	 * We want IOPRIO_WHO_PGRP/IOPRIO_WHO_USER to be "atomic",
-	 * so we can't use rcu_read_lock(). See re-copy of ->ioprio
-	 * in copy_process().
-	 */
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case IOPRIO_WHO_PROCESS:
-- 
1.7.1



