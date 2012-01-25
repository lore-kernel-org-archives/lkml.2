Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2AYQ3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:29:36 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:35438 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2AYQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:29:35 -0500
X-Greylist: delayed 7831 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 11:29:34 EST
Message-ID: <4F200F4D.5000201@numascale.com>
Date: Wed, 25 Jan 2012 15:18:53 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F1FCF02.9060209@numascale-asia.com> <20120125140029.GA2534@linux.vnet.ibm.com>
In-Reply-To: <20120125140029.GA2534@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
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

On 1/25/2012 15:00, Paul E. McKenney wrote:
> On Wed, Jan 25, 2012 at 05:44:34PM +0800, Daniel J Blueman wrote:
[]
> 
> I do test three-level trees regularly, but on relatively small systems
> by limiting CONFIG_RCU_FANOUT.  If you are running 64-bit systems
> with default values of CONFIG_RCU_FANOUT, a 1024-CPU system fits into a
> two-level tree, so I would guess that you either have more than 1024 CPUs
> (at least as far as NR_CPUS is concerned) or gaps in your CPU-numbering
> scheme.

NR_CPU is set to 4096 (i.e CONFIG_MAXSMP=y) and CONFIG_FCU_FANOUT is 64. We see 3 levels of RCU nodes with this configuration.

> 
>> Has this been encountered previously?
> 
> I haven't seen that warning since I was originally developing
> TREE_PREEMPT_RCU some years back.
> 
> Numascale NumaConnect is cache-coherent, right?

Correct.

[]
>>
>> WARNING: at kernel/rcutree_plugin.h:990
> 
> OK, if I have the right version, RCU-sched is trying to do a new grace
> period, but finds that one of the rcu_node structure's ->qsmask fields
> indicates that a CPU (or group of CPUs) failed to check into the previous
> grace period.
> 
[]

>>
>> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
>> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d000,
>> qsmask is 0x1
>>    0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=279
>> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
>>   12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=10
>> ql=2 qs=.R.. b=10 ci=561 co=0 ca=0
>>   24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=14
>> ql=0 qs=.... b=10 ci=406 co=0 ca=0
>>   36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=22
>> ql=0 qs=.... b=10 ci=215 co=0 ca=0
>>   48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=14
>> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0
> 
> And it looks like CPU 48 is the one that did not check in.  What is
> CONFIG_NO_HZ set to?  If CONFIG_NO_HZ=y, this can legitimately
> happen, and printing the values of rdp->dynticks->dynticks,
> rdp->dynticks->dynticks_nesting, rdp->dynticks->dynticks_nmi_nesting,
> and rdp->dynticks_fqs will determine whether or not the situation is
> legitimate or not.
> 
> If CONFIG_NO_HZ=n, than this should not happen.  In this case, I should
> be able to provide you with a more focused debug print.

CONFIG_NO_HZ is not set, so it should not happen. We see that the behavior is the same with CONFIG_NO_HZ=y though, but it takes longer to reproduce usually.

> 
>>   60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
>> ql=0 qs=.... b=10 ci=50 co=0 ca=0
>>   72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
>> ql=0 qs=.... b=10 ci=22 co=0 ca=0
[]

>> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
>> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d100,
>> qsmask is 0x8
>>    0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=279
>> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
>>   12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=10
>> ql=3 qs=NR.. b=10 ci=561 co=0 ca=0
>>   24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=14
>> ql=0 qs=.... b=10 ci=406 co=0 ca=0
>>   36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=22
>> ql=0 qs=.... b=10 ci=215 co=0 ca=0
>>   48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=19
>> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0
> 
> Hmmmm...  Same CPU and grace-period number.  This is a repeat of the
> above printout, correct?

Because the RCU tree is 3 levels, the printout function we added in the patch gets called 3 times each time with the same RDP but with different RNPs (in rcu_start_gp()).

> 
>>   60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
>> ql=0 qs=.... b=10 ci=50 co=0 ca=0
>>   72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
>> ql=0 qs=.... b=10 ci=22 co=0 ca=0
>> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
>> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d800,
>> qsmask is 0x1
>>    0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=280
>> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
>>   12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=11
>> ql=3 qs=NR.. b=10 ci=561 co=0 ca=0
>>   24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=15
>> ql=0 qs=.... b=10 ci=406 co=0 ca=0
>>   36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=23
>> ql=0 qs=.... b=10 ci=215 co=0 ca=0
>>   48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=21
>> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0
> 
> Same here, but most of the ql= values are larger.  Later printout?

The loop in rcu_start_gp() releases the node lock between each time it gets a new level in the RCU tree (it has to) :

	rcu_for_each_node_breadth_first(rsp, rnp) {
		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
		rcu_debug_print(rsp, rnp);

so I guess this allows ql= values to increase maybe, no ?

> 
> 							Thanx, Paul
> 
>>   60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
>> ql=0 qs=.... b=10 ci=50 co=0 ca=0
>>   72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
>> ql=0 qs=.... b=10 ci=22 co=0 ca=0
>>

Thanks for looking into this Paul, we'd be more than happy to test out theories and patches.


Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
