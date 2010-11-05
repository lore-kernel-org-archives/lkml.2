Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0KEVsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:48:20 -0400
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:51769 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752616Ab0KEVsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:48:19 -0400
Subject: Re: [PATCH] mce: fix RCU lockdep from mce_log()
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andi Kleen <andi@firstfloor.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1288993499.2065.4.camel@cowboy>
References: <1288993499.2065.4.camel@cowboy>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 18:48:04 -0300
Message-ID: <1288993685.2065.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the title should have been:
[PATCH] mce: fix RCU lockdep from mce_poll()

On Fri, 2010-11-05 at 18:44 -0300, Davidlohr Bueso wrote:
> Hi,
> 
> Please review this patch, I am not very familiar with MCE/RCU so I'm not sure that this is the correct fix (otherwise consider it a bug report :)).
> This does "fix" the message though and I can use MCE normally.
> 
> Thanks,
> Davidlohr
> 
> 
> From: Davidlohr Bueso <dave@gnu.org>
> 
> Based on the following message:
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 1
> no locks held by mcelog/2350.
> 
> stack backtrace:
> Pid: 2350, comm: mcelog Tainted: G        W   2.6.37-rc1+ #7
> Call Trace:
>  [<ffffffff8108e6d4>] lockdep_rcu_dereference+0xa4/0xc0
>  [<ffffffff810189e9>] mce_poll+0xa9/0xd0
>  [<ffffffff81160585>] do_sys_poll+0x275/0x550
>  [<ffffffff8115f0e0>] ? __pollwait+0x0/0xf0
>  [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
>  [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
>  [<ffffffff8130431c>] ? rcu_read_lock_held+0x2c/0x30
>  [<ffffffff8130549a>] ? radix_tree_lookup_element+0xda/0x100
>  [<ffffffff81121f08>] ? __do_fault+0x128/0x470
>  [<ffffffff81100bdb>] ? filemap_fault+0xdb/0x4e0
>  [<ffffffff810ffe75>] ? unlock_page+0x25/0x30
>  [<ffffffff81069ddf>] ? sigprocmask+0x3f/0x100
>  [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
>  [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
>  [<ffffffff8108ff4d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
>  [<ffffffff811608a7>] sys_ppoll+0x47/0x190
>  [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
>  [<ffffffff81835d39>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff810030eb>] system_call_fastpath+0x16/0x1b
> 
> At this point the arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 1
> no locks held by mcelog/2350.
> 
> stack backtrace:
> Pid: 2350, comm: mcelog Tainted: G        W   2.6.37-rc1+ #7
> Call Trace:
>  [<ffffffff8108e6d4>] lockdep_rcu_dereference+0xa4/0xc0
>  [<ffffffff810189e9>] mce_poll+0xa9/0xd0
>  [<ffffffff81160585>] do_sys_poll+0x275/0x550
>  [<ffffffff8115f0e0>] ? __pollwait+0x0/0xf0
>  [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
>  [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
>  [<ffffffff8130431c>] ? rcu_read_lock_held+0x2c/0x30
>  [<ffffffff8130549a>] ? radix_tree_lookup_element+0xda/0x100
>  [<ffffffff81121f08>] ? __do_fault+0x128/0x470
>  [<ffffffff81100bdb>] ? filemap_fault+0xdb/0x4e0
>  [<ffffffff810ffe75>] ? unlock_page+0x25/0x30
>  [<ffffffff81069ddf>] ? sigprocmask+0x3f/0x100
>  [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
>  [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
>  [<ffffffff8108ff4d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
>  [<ffffffff811608a7>] sys_ppoll+0x47/0x190
>  [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
>  [<ffffffff81835d39>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff810030eb>] system_call_fastpath+0x16/0x1b
> 
> At this point the lockdep_is_held(&mce_read_mutex) call is failing.
> So check if the mce_read_mutex is held before derefencing instead of using rcu_dereference_check_mce()
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 7a35b72..6f95b2c 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1625,8 +1625,12 @@ out:
>  static unsigned int mce_poll(struct file *file, poll_table *wait)
>  {
>  	poll_wait(file, &mce_wait, wait);
> -	if (rcu_dereference_check_mce(mcelog.next))
> -		return POLLIN | POLLRDNORM;
> +
> +	if (mutex_is_locked(&mce_read_mutex)) {
> +		if (rcu_dereference_index_check(mcelog.next, 
> +						rcu_read_lock_sched_held()))
> +			return POLLIN | POLLRDNORM;
> +	}
>  	if (!mce_apei_read_done && apei_check_mce())
>  		return POLLIN | POLLRDNORM;
>  	return 0;
> -- 
> 1.7.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


