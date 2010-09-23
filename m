Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0IWBbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:31:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0IWBbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:31:07 -0400
Message-ID: <4C9AAEA3.2020209@cn.fujitsu.com>
Date: Thu, 23 Sep 2010 09:34:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] rcu: rcu_read_lock_bh_held(): disabling
 irqs also disables bh
References: <20100923003220.GA21822@linux.vnet.ibm.com>
In-Reply-To: <20100923003220.GA21822@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 08:32 AM, Paul E. McKenney wrote:
> rcu_dereference_bh() doesnt know yet about hard irq being disabled, so
> lockdep can trigger in netpoll_rx() after commit f0f9deae9e7c4 (netpoll:
> Disable IRQ around RCU dereference in netpoll_rx)
> 
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Tested-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/rcupdate.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 9fbc54a..0dcc00e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -454,7 +454,8 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   * Makes rcu_dereference_check() do the dirty work.
>   */
>  #define rcu_dereference_bh(p) \
> -		rcu_dereference_check(p, rcu_read_lock_bh_held())
> +		rcu_dereference_check(p, rcu_read_lock_bh_held() || \
> +					 irqs_disabled())
>  
>  /**
>   * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched

In -rt, rcu_read_lock_bh() is preemptible, but all RCU Implementation,
PREEMPT_RCU, TREE_PREEMPT_RCU, TINY_PREEMPT_RCU, do not guarantee
hard-irq/irq-disabled contexts are preeemptible-rcu-read-site critical regions,
so it(disabling irqs also disables bh) is not true in -rt I think,
To make the codes be still safe in the future(-rt), I strongly recommend to
use rcu_read_lock_bh() as needed even irq disabled.

Current, preempt_disable()/rcu_read_lock_sched() do not guarantee that
they implies rcu_read_lock() either.

But in future, the rcu may give these guarantees, it's a plan of mine.

Lai
