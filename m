Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2AYUfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:35:23 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:46919 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2AYUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:35:22 -0500
Message-ID: <4F206783.2050901@numascale.com>
Date: Wed, 25 Jan 2012 21:35:15 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F1FCF02.9060209@numascale-asia.com> <20120125140029.GA2534@linux.vnet.ibm.com> <4F200F4D.5000201@numascale.com> <20120125181441.GD2849@linux.vnet.ibm.com>
In-Reply-To: <20120125181441.GD2849@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2012 19:14, Paul E. McKenney wrote:
[]
>> CONFIG_NO_HZ is not set, so it should not happen. We see that the behavior is the same with CONFIG_NO_HZ=y though, but it takes longer to reproduce usually.
>
> OK, the CONFIG_NO_HZ=n has the least code involved, so it would be best
> for debugging.

Good, that was my thought also when looking at the code. I'm reducing 
NR_CPUS to 512 now to get two levels just for simpler debugging (the 
issue is still present).

[]
>> Because the RCU tree is 3 levels, the printout function we added in the patch gets called 3 times each time with the same RDP but with different RNPs (in rcu_start_gp()).
>
> Ah, good point.  Hmmm...
>
> Looking back at Daniel's original email, we have the root rcu_node
> structure with ->qsmask=0x1 (indicating first descendent), the next
> level having ->qsmask=0x8 (indicating fourth descendent) and the last
> level having ->qsmask=0x1, again indicating first descendent.  So,
> zero, 16, 32, 48.  Which agrees with the CPU number below that has not
> yet caught up to the current grace period.
>
> Another really odd thing...  If we are starting the new grace period,
> we should have incremented rsp->gpnum.  And in fact, we do have
> rsp->gpnum being one larger than rsp->completed, as expected.  But
> if we have only initialized the root rcu_node structures, how can
> the per-CPU rcudata structures know about the new grace period yet?
>
> There was a time when the CPUs could find out early, but I think that
> was a long time ago.  Yes, check_for_new_grace_period() does compare
> rdp->gpnum against rsp->gpnum, but it calls note_new_gpnum() which
> acquires the rnp->lock(), and nothing happens unless __note_new_gpnum()
> sees that rnp->gpnum is different rdp->gpnum.
>
> So, it would be very interesting to add the values rdp->mynode->gpnum
> and rdp->mynode->completed to your list, perhaps labeling them something
> like "rng" and "rnc" respectively.

I will add this to the printout.

>
> Of course, CPU 48 should not have decided that it was done with the
> old grace period before clearing its bit.  For that matter, some
> CPU somewhere decided that the grace period was done despite the
> root rcu_node's ->qsmask being non-zero, which should be prevented
> by the:
>
> 	if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
>
> line in rcu_report_qs_rnp().
>
> 3.2 has some event tracing that would be extremely helpful in tracking
> this down.  Are you able to run 3.2?

Yes, 3.2.1 is our debug target right now.

[]
>>> Same here, but most of the ql= values are larger.  Later printout?
>>
>> The loop in rcu_start_gp() releases the node lock between each time it gets a new level in the RCU tree (it has to) :
>>
>> 	rcu_for_each_node_breadth_first(rsp, rnp) {
>> 		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
>> 		rcu_debug_print(rsp, rnp);
>>
>> so I guess this allows ql= values to increase maybe, no ?
>
> The ql= levels can increase anyway -- those queues are only accessed by
> the corresponding CPU or from stop_machine context.  The small increases
> are entirely consistent with your having bits set at all levels of the
> rcu_node tree.  The reason I was surprised is that my earlier bugs (as
> in before the code hit mainline) only ever resulted in a single level
> having a stray bit.

Ok.

[]
>>
>> Thanks for looking into this Paul, we'd be more than happy to test out theories and patches.
>
> The event tracing, particularly the "rcu_grace_period" set, would be
> very helpful.

Are you talking about the data from /sys/kernel/debug/rcu/ ? I have 
CONFIG_RCU_TRACE (and consequently CONFIG_TREE_RCU_TRACE) set, is this 
enough to get the event data you want ?

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
