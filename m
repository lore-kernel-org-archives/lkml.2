Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0KYIki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:40:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:33759 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KYIkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:40:37 -0500
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in
 check_clock
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101125013557.GB2854@redhat.com>
References: <20101125010948.GA1371@redhat.com>
	 <20101125013557.GB2854@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 09:40:37 +0100
Message-ID: <1290674437.2072.563.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 20:35 -0500, Dave Jones wrote:
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by scrashme/13382:
>  #0:  (tasklist_lock){.?.?..}, at: [<ffffffff8106ddea>] check_clock+0x46/0x9a
> 
> stack backtrace:
> Pid: 13382, comm: scrashme Not tainted 2.6.37-rc3+ #8
> Call Trace:
>  [<ffffffff8107cfe1>] lockdep_rcu_dereference+0x9d/0xa5
>  [<ffffffff81069d08>] find_task_by_pid_ns+0x44/0x5d
>  [<ffffffff81069d43>] find_task_by_vpid+0x22/0x24
>  [<ffffffff8106ddf2>] check_clock+0x4e/0x9a
>  [<ffffffff8106deac>] posix_cpu_clock_getres+0x16/0x41
>  [<ffffffff8106be74>] sys_clock_getres+0x39/0xa0
>  [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 6842eeb..4bef9aa 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -38,11 +38,13 @@ static int check_clock(const clockid_t which_clock)
>  		return 0;
>  
>  	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
>  	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
>  		   same_thread_group(p, current) : thread_group_leader(p))) {
>  		error = -EINVAL;
>  	}
> +	rcu_read_unlock();
>  	read_unlock(&tasklist_lock);
>  
>  	return error;


Pretty much the same comment as the other patch..

<copy/paste>

Do we still need the tasklist_lock in this case?

Also, why is that think complaining, surely the tasklist_lock pins any
and all PID objects?
