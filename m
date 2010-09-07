Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0IGL1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 07:27:54 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43000 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab0IGL1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:27:49 -0400
Date: Tue, 7 Sep 2010 13:27:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.35.2 - hit BUG_ON in __disable_runtime during cpu
 hotplug stress
Message-ID: <20100907112745.GB2201@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

we've seen a BUG where you added the corresponding BUG_ON statement. Maybe you
have an idea what got wrong?

This happened with 2.6.35.2 which does have my book domain patches applied,
but naturally I think it's not my fault ;)
Test case was a busy system and performing cpu hotplug stress.

    <2>kernel BUG at /home/wirbser/rpm/BUILD/linux-2.6.35.2-20100823/kernel/sched_rt.c:447!
    <4>illegal operation: 0001 [#1] PREEMPT SMP DEBUG_PAGEALLOC
    <4>Modules linked in: sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 qeth ccwgroup [last unloaded: scsi_wait_scan]
    <4>CPU: 9 Not tainted 2.6.35.2-44.x.20100823-s390xdefault #1
    <4>Process events/9 (pid: 1321, task: 0000000035a2c740, ksp: 000000003c623bb0)
    <4>Krnl PSW : 0404100180000000 000000000012a5b8 (__disable_runtime+0x390/0x394)
    <4>           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
    <4>Krnl GPRS: 0000000000000001 0000000035a2c740 0000000000000000 040000000012a46a
    <4>           000000000012a46a 0000000000000000 0000000035f50000 00000000048edc50
    <4>           000000000080e790 0000000000a5db00 0000000000000040 ffffffffdf37aa80
    <4>           0000000000000040 000000000055f7b8 000000000012a46a 000000003c623b08
    <4>Krnl Code: 000000000012a5a8: f0f80004eb6f        srp     4(16,%r0),2927(%r14),8
    <4>           000000000012a5ae: f0b8000407f4        srp     4(12,%r0),2036,8
    <4>           000000000012a5b4: a7f40001            brc     15,12a5b6
    <4>          >000000000012a5b8: a7f40000            brc     15,12a5b8
    <4>           000000000012a5bc: ebcff0780024        stmg    %r12,%r15,120(%r15)
    <4>           000000000012a5c2: a7f13fc0            tmll    %r15,16320
    <4>           000000000012a5c6: b90400ef            lgr     %r14,%r15
    <4>           000000000012a5ca: c0100037166b        larl    %r1,80d2a0
    <4>Call Trace:
    <4>([<000000000012a46a>] __disable_runtime+0x242/0x394)
    <4> [<000000000012dc28>] rq_offline_rt+0xa4/0xc4
    <4> [<00000000001268dc>] set_rq_offline+0x48/0xb0
    <4> [<000000000012f5a0>] rq_attach_root+0x1f8/0x214
    <4> [<000000000012fe7a>] cpu_attach_domain+0x1a2/0x200
    <4> [<000000000013190e>] partition_sched_domains+0x16a/0x65c
    <4> [<00000000001a4288>] do_rebuild_sched_domains+0x54/0x64
    <4> [<000000000015c580>] worker_thread+0x200/0x344
    <4> [<000000000016280c>] kthread+0xa0/0xa8
    <4> [<000000000010b3fa>] kernel_thread_starter+0x6/0xc
    <4> [<000000000010b3f4>] kernel_thread_starter+0x0/0xc
    <4>INFO: lockdep is turned off.
    <4>Last Breaking-Event-Address:
    <4> [<000000000012a5b4>] __disable_runtime+0x38c/0x394

Since this happened within __disable_runtime() the most import config option
seems to be CONFIG_RT_GROUP_SCHED which is turned off.

A dump is available and a short analysis:

static void __disable_runtime(struct rq *rq)  <-- rq == 0x048edb00
{
	struct root_domain *rd = rq->rd;
	struct rt_rq *rt_rq;

	if (unlikely(!scheduler_running))
		return;

	for_each_leaf_rt_rq(rt_rq, rq) {
		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
=====
Because of !CONFIG_RT_GROUP_SCHED we end up with

#define for_each_leaf_rt_rq(rt_rq, rq) \
	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)

and

static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
{
	return &def_rt_bandwidth;
}
=====
		s64 want;
		int i;

		raw_spin_lock(&rt_b->rt_runtime_lock);
		raw_spin_lock(&rt_rq->rt_runtime_lock);
		/*
		 * Either we're all inf and nobody needs to borrow, or we're
		 * already disabled and thus have nothing to do, or we have
		 * exactly the right amount of runtime to take out.
		 */
		if (rt_rq->rt_runtime == RUNTIME_INF ||
				rt_rq->rt_runtime == rt_b->rt_runtime)
			goto balanced;
		raw_spin_unlock(&rt_rq->rt_runtime_lock);

		/*
		 * Calculate the difference between what we started out with
		 * and what we current have, that's the amount of runtime
		 * we lend and now have to reclaim.
		 */
		want = rt_b->rt_runtime - rt_rq->rt_runtime;
=====
rt_rq->rt_runtime = 0x59682f00
rt_b->rt_runtime = 0x389fd980

--> want =  0xffffffffdf37aa80
=====
		/*
		 * Greedy reclaim, take back as much as we can.
		 */
		for_each_cpu(i, rd->span) {
			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
=====
With !CONFIG_RT_GROUP_SCHED we get

static inline
struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
{
	return &cpu_rq(cpu)->rt;
}

we have

rd->span = 0x800 (aka cpu 11)

after calculating a bit with percpu offsets we finally end up with
cpu_rq(cpu 11) == 0x48edb00

which is the same rq which got passed to the function.
=====
			s64 diff;

			/*
			 * Can't reclaim from ourselves or disabled runqueues.
			 */
			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
				continue;
=====
And therefore we have iter == rt_rq, so the rest of the loop doesn't get
executed a single time.
=====
			raw_spin_lock(&iter->rt_runtime_lock);
			if (want > 0) {
				diff = min_t(s64, iter->rt_runtime, want);
				iter->rt_runtime -= diff;
				want -= diff;
			} else {
				iter->rt_runtime -= want;
				want -= want;
			}
			raw_spin_unlock(&iter->rt_runtime_lock);

			if (!want)
				break;
		}

		raw_spin_lock(&rt_rq->rt_runtime_lock);
		/*
		 * We cannot be left wanting - that would mean some runtime
		 * leaked out of the system.
		 */
		BUG_ON(want);
=====
Hence we hit this BUG_ON statement. The content of want is in register 11 in
the register dump above. It's the initial value as calculated above.
=====
balanced:
		/*
		 * Disable all the borrow logic by pretending we have inf
		 * runtime - in which case borrowing doesn't make sense.
		 */
		rt_rq->rt_runtime = RUNTIME_INF;
		raw_spin_unlock(&rt_rq->rt_runtime_lock);
		raw_spin_unlock(&rt_b->rt_runtime_lock);
	}
}
