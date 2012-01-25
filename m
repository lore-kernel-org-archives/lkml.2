Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab2AYWtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:49:09 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:50159 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2AYWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:49:08 -0500
Message-ID: <4F2086DA.4040203@numascale.com>
Date: Wed, 25 Jan 2012 23:48:58 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F1FCF02.9060209@numascale-asia.com> <20120125140029.GA2534@linux.vnet.ibm.com> <4F200F4D.5000201@numascale.com> <20120125181441.GD2849@linux.vnet.ibm.com> <4F2070B9.2000104@numascale.com> <20120125213450.GJ2849@linux.vnet.ibm.com>
In-Reply-To: <20120125213450.GJ2849@linux.vnet.ibm.com>
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

On 1/25/2012 22:34, Paul E. McKenney wrote:
> On Wed, Jan 25, 2012 at 10:14:33PM +0100, Steffen Persvold wrote:
>> On 1/25/2012 19:14, Paul E. McKenney wrote:
>> []
>>>
>>> So, it would be very interesting to add the values rdp->mynode->gpnum
>>> and rdp->mynode->completed to your list, perhaps labeling them something
>>> like "rng" and "rnc" respectively.
>>>
>>
>> I added them to the printout. This time I ran with NR_CPUS=512 so there's only two levels but we see more qsmask bits set on the root node :
>>
>> [  738.329672] CPU 48, treason uncloaked, rsp @ ffffffff81a1cd80 (rcu_sched), gpnum=10568, completed=10567, n_force_qs=69, n_force_qs_lh=0, n_force_qs_ngp=0, rnp @ ffffffff81a1cd80, qsmask=0x1f
>> [  738.330137]   0 ffff8803f840d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=66 ql=1 qs=..W. b=10 ci=158068 co=0 ca=0 rng=10568 rnc=10567
>> [  738.330137]  12 ffff880bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=1 ri=0 ql=0 qs=.... b=10 ci=715 co=0 ca=0 rng=10568 rnc=10567
>> [  738.330137]  24 ffff8813d040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=0 ql=0 qs=.... b=10 ci=484 co=0 ca=0 rng=10568 rnc=10567
>> [  738.330137]  36 ffff881bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=1 ri=0 ql=0 qs=.... b=10 ci=369 co=0 ca=0 rng=10568 rnc=10567
>> [  738.330137]  48 ffff8823d040d660 c=10567 g=10567 pq=1 pgp=10567 qp=0 of=0 ri=0 ql=28 qs=.RWD b=10 ci=9292 co=0 ca=0 rng=10568 rnc=10567
>> [  738.330137]  60 ffff882bd040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=1 ql=0 qs=.... b=10 ci=32 co=0 ca=0 rng=10568 rnc=10567
>> [  738.330137]  72 ffff8833d040d660 c=10567 g=10568 pq=1 pgp=10568 qp=0 of=0 ri=0 ql=0 qs=.... b=10 ci=43 co=0 ca=0 rng=10568 rnc=10567
> 
> Yow!!!  This is the message from the root rcu_node, right?
> 
> One way to check is to print (rnp -&rsp->node[0]), which will be zero
> for the root node.

Yes.

> 
> So this is very very strange.  This error is happening out of
> rcu_start_gp(), which updates rsp->gpnum, and then updates each rnp->gpnum
> in rcu_node array order.  When you get the error on the root rcu_node
> structure, the new ->gpnum value should not have yet propagated to the
> leaf rcu_node structures.  Or is the error print happening asynchronously?
> 
> If it is happening asynchronously, so that the actual printing of the
> first set of messages above isn't happening until after initialization
> is complete, could you please copy the relevant values out so that the
> printout is consistent with the state at the time of the error?
> 

I've changed the debug_print function to only print the different completed and gpnum values (for rdp, rnp, rsp and rnp->mynode)  :

static void
rcu_debug_print(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
{
	unsigned long c, g, nc, ng, sc, sg, mc, mg;
	if (rnp->qsmask) {
		c = ACCESS_ONCE(rdp->completed);
		g = ACCESS_ONCE(rdp->gpnum);
		nc = ACCESS_ONCE(rnp->completed);
		ng = ACCESS_ONCE(rnp->gpnum);
		sc = ACCESS_ONCE(rsp->completed);
		sg = ACCESS_ONCE(rsp->gpnum);
		mc = ACCESS_ONCE(rdp->mynode->completed);
		mg = ACCESS_ONCE(rdp->mynode->gpnum);
		printk(KERN_ERR "CPU %d, treason uncloaked, rsp @ %p (%s), rnp @ %p%3s qsmask=0x%lx, c=%lu g=%lu nc=%lu ng=%lu sc=%lu sg=%lu mc=%lu mg=%lu\n",
		       rdp->cpu, rsp, rsp->name, rnp, (rnp == &rsp->node[0]) ? "(r)" : "", rnp->qsmask, c, g, nc, ng, sc, sg, mc, mg);

	}
}

This run it was CPU24 that triggered the issue :

[  231.572688] CPU 24, treason uncloaked, rsp @ ffffffff81a1cd80 (rcu_sched), rnp @ ffffffff81a1cd80(r) qsmask=0x1f, c=5132 g=5132 nc=5132 ng=5133 sc=5132 sg=5133 mc=5132 mg=5133
[  231.576167] ------------[ cut here ]------------
[  231.576167] WARNING: at kernel/rcutree_plugin.h:1011 rcu_preempt_check_blocked_tasks+0x27/0x30()
[  231.576167] Hardware name: H8QI6
[  231.576167] Modules linked in: rcutorture
[  231.576167] Pid: 4603, comm: rcu_torture_rea Not tainted 3.2.1-numaconnect10+ #77
[  231.576167] Call Trace:
[  231.576167]  <IRQ>  [<ffffffff810bb217>] ? rcu_preempt_check_blocked_tasks+0x27/0x30
[  231.576167]  [<ffffffff8106f47b>] warn_slowpath_common+0x8b/0xc0
[  231.576167]  [<ffffffff8106f4c5>] warn_slowpath_null+0x15/0x20
[  231.576167]  [<ffffffff810bb217>] rcu_preempt_check_blocked_tasks+0x27/0x30
[  231.576167]  [<ffffffff810bb330>] rcu_start_gp+0x110/0x1b0
[  231.576167]  [<ffffffff810bbf3b>] __rcu_process_callbacks+0x8b/0xd0
[  231.576167]  [<ffffffff810bc7a0>] rcu_process_callbacks+0x20/0x40
[  231.576167]  [<ffffffff8107580d>] __do_softirq+0x9d/0x140
[  231.576167]  [<ffffffff815d982c>] call_softirq+0x1c/0x30
[  231.576167]  [<ffffffff8103451a>] do_softirq+0x4a/0x80
[  231.576167]  [<ffffffff81075b83>] irq_exit+0x43/0x60
[  231.576167]  [<ffffffff8104aed5>] smp_apic_timer_interrupt+0x45/0x60
[  231.576167]  [<ffffffff815d834b>] apic_timer_interrupt+0x6b/0x70
[  231.576167]  <EOI>  [<ffffffff81067aa9>] ? finish_task_switch+0x59/0xc0
[  231.576167]  [<ffffffff815d4d37>] __schedule+0x337/0x710
[  231.576167]  [<ffffffff81090425>] ? sched_clock_local+0x15/0x80
[  231.576167]  [<ffffffff8107b826>] ? lock_timer_base+0x36/0x70
[  231.576167]  [<ffffffff8107baa2>] ? mod_timer+0xf2/0x1d0
[  231.576167]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
[  231.576167]  [<ffffffff815d53ea>] schedule+0x3a/0x60
[  231.576167]  [<ffffffffa0001640>] rcu_torture_reader+0x130/0x230 [rcutorture]
[  231.576167]  [<ffffffffa0001dc0>] ? rcu_torture_writer+0x160/0x160 [rcutorture]
[  231.576167]  [<ffffffffa0001510>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
[  231.576167]  [<ffffffff8108a726>] kthread+0x96/0xa0
[  231.576167]  [<ffffffff815d9734>] kernel_thread_helper+0x4/0x10
[  231.576167]  [<ffffffff8108a690>] ? kthread_stop+0x70/0x70
[  231.576167]  [<ffffffff815d9730>] ? gs_change+0xb/0xb
[  231.576167] ---[ end trace 828c8d7afbd02d1b ]---


Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
