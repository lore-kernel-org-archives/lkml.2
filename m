Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0CaCKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:10:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58587 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab0CaCKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:10:22 -0400
Message-ID: <4BB2AF2F.6030406@cn.fujitsu.com>
Date: Wed, 31 Mar 2010 10:10:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: only raise softirq when need
References: <4BB1CE6B.6030207@cn.fujitsu.com> <20100330163036.GC2513@linux.vnet.ibm.com>
In-Reply-To: <20100330163036.GC2513@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Mar 30, 2010 at 06:11:55PM +0800, Lai Jiangshan wrote:
>> I found something RCU_SOFTIRQ are called without do any thing.
>> (use function_graph to find it:
>>  1)               |  rcu_process_callbacks() {
>>  1)               |    __rcu_process_callbacks() {
>>  1)   0.634 us    |      rcu_process_gp_end();
>>  1)   0.487 us    |      check_for_new_grace_period();
>>  1)   2.672 us    |    }
>>  1)               |    __rcu_process_callbacks() {
>>  1)   0.633 us    |      rcu_process_gp_end();
>>  1)   0.491 us    |      check_for_new_grace_period();
>>  1)   2.672 us    |    }
>> )
>>
>> This patch make RCU_SOFTIRQ raised when need.
> 
> So this seems to have two effects:
> 
> 1.	Avoid checking for a quiescent state if RCU doesn't need one
> 	from this CPU.
> 
> 2.	Avoid RCU_SOFTIRQ if RCU did need a quiescent state from
> 	this CPU, and if rcu_check_callbacks() saw a quiescent state.

This RCU_SOFTIRQ is not avoided.

+	if (rdp->qs_pending && rdp->passed_quiesc) {
+		rdp->n_rp_report_qs++;
 		return 1;
 	}

Old: raise RCU_SOFTIRQ when rdp->qs_pending is not zero
New: raise RCU_SOFTIRQ when rdp->qs_pending && rdp->passed_quiesc

So the different effects only happen when this state:
rdp->qs_pending == 1 && rdp->passed_quiesc == 0,
But this state will be changed after next rcu_sched_qs() or families.
So it will not hang up.

> 
> Except that if rcu_check_callbacks() did see a quiescent state, then we
> -need- RCU_SOFTIRQ to propagate this up the tree.  So I don't see how
> this patch helps, and unless I am missing something, it can result in
> grace-period hangs.  (This CPU is the last one to pass through a
> quiescent state, and this call to rcu_check_callbacks() finds one,
> and we fail to report it up the tree.)
> 
> Please note that there are other possible causes for empty calls to
> rcu_process_callbacks():
> 
> 1.	RCU needs a call to force_quiescent_state(), but some other
> 	CPU beats us to it.  We raise RCU_SOFTIRQ, but by the time
> 	we get there, our work is done.
> 
> 2.	RCU needs to check for CPU stalls, but some other CPU beats
> 	us to it.
> 
> 3.	RCU is idle, and this CPU needs another grace period, but
> 	some other CPU starts up a new grace period before our
> 	softirq gets started.

These may happen, but I have not seen any empty call after patch applied.

> 
> So I do not believe that this patch is worthwhile even if it does turn
> out to be safe.

I accept that this patch is not worthwhile.

Raising empty call is harmless, and it is a chance
to progress RCU or detect problems.

