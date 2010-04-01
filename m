Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0DAHjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:39:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56071 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab0DAHjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:39:42 -0400
Message-ID: <4BB44DD0.7050302@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 15:40:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: only raise softirq when need
References: <4BB1CE6B.6030207@cn.fujitsu.com> <20100330163036.GC2513@linux.vnet.ibm.com> <4BB2AF2F.6030406@cn.fujitsu.com> <20100331153037.GD2461@linux.vnet.ibm.com>
In-Reply-To: <20100331153037.GD2461@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Wed, Mar 31, 2010 at 10:10:55AM +0800, Lai Jiangshan wrote:
>> Paul E. McKenney wrote:
>>> On Tue, Mar 30, 2010 at 06:11:55PM +0800, Lai Jiangshan wrote:
>>>> I found something RCU_SOFTIRQ are called without do any thing.
>>>> (use function_graph to find it:
>>>>  1)               |  rcu_process_callbacks() {
>>>>  1)               |    __rcu_process_callbacks() {
>>>>  1)   0.634 us    |      rcu_process_gp_end();
>>>>  1)   0.487 us    |      check_for_new_grace_period();
>>>>  1)   2.672 us    |    }
>>>>  1)               |    __rcu_process_callbacks() {
>>>>  1)   0.633 us    |      rcu_process_gp_end();
>>>>  1)   0.491 us    |      check_for_new_grace_period();
>>>>  1)   2.672 us    |    }
>>>> )
>>>>
>>>> This patch make RCU_SOFTIRQ raised when need.
>>> So this seems to have two effects:
>>>
>>> 1.	Avoid checking for a quiescent state if RCU doesn't need one
>>> 	from this CPU.
>>>
>>> 2.	Avoid RCU_SOFTIRQ if RCU did need a quiescent state from
>>> 	this CPU, and if rcu_check_callbacks() saw a quiescent state.
>> This RCU_SOFTIRQ is not avoided.
>>
>> +	if (rdp->qs_pending && rdp->passed_quiesc) {
>> +		rdp->n_rp_report_qs++;
>>  		return 1;
>>  	}
>>
>> Old: raise RCU_SOFTIRQ when rdp->qs_pending is not zero
>> New: raise RCU_SOFTIRQ when rdp->qs_pending && rdp->passed_quiesc
>>
>> So the different effects only happen when this state:
>> rdp->qs_pending == 1 && rdp->passed_quiesc == 0,
>> But this state will be changed after next rcu_sched_qs() or families.
>> So it will not hang up.
> 
> You are quite correct.  I clearly need to give myself a day to think
> about patches to RCU functionality before replying.  On the other hand,
> I might have been just as confused after thinking on it, so airing my
> confusion immediately might well have been the optimal approach.  ;-)
> 
> So this patch looks like it would work, so the next question is how much
> it helps and/or hurts.
> 
>>> Except that if rcu_check_callbacks() did see a quiescent state, then we
>>> -need- RCU_SOFTIRQ to propagate this up the tree.  So I don't see how
>>> this patch helps, and unless I am missing something, it can result in
>>> grace-period hangs.  (This CPU is the last one to pass through a
>>> quiescent state, and this call to rcu_check_callbacks() finds one,
>>> and we fail to report it up the tree.)
>>>
>>> Please note that there are other possible causes for empty calls to
>>> rcu_process_callbacks():
>>>
>>> 1.	RCU needs a call to force_quiescent_state(), but some other
>>> 	CPU beats us to it.  We raise RCU_SOFTIRQ, but by the time
>>> 	we get there, our work is done.
>>>
>>> 2.	RCU needs to check for CPU stalls, but some other CPU beats
>>> 	us to it.
>>>
>>> 3.	RCU is idle, and this CPU needs another grace period, but
>>> 	some other CPU starts up a new grace period before our
>>> 	softirq gets started.
>> These may happen, but I have not seen any empty call after patch applied.
> 
> Before the patch, what fraction of the calls were empty calls?
> 
>>> So I do not believe that this patch is worthwhile even if it does turn
>>> out to be safe.
>> I accept that this patch is not worthwhile.
>>
>> Raising empty call is harmless, and it is a chance
>> to progress RCU or detect problems.
> 
> If you say "this patch has not been yet proven to be worthwhile" instead
> of "this patch is not worthwhile", I will agree with you.  Here is a
> quick rundown of my thoughts on it, which cannot be considered to be
> fully formed:
> 
> 1.	It cannot improve real-time scheduling latency, since there
> 	can be RCU_SOFTIRQ actions that really do something.  This
> 	patch therefore does not improve the worst-case code path
> 	(though it might -- or might not -- help the average path).
> 
> 2.	It seems to increase path length a bit, but I doubt that this
> 	is measurable, so not a valid objection.
> 
> 3.	It -might- improve throughput, but this would need to be
> 	proven.  This is the motivation for my question about the
> 	fraction of empty calls above.
> 
> 	Kernels that force all softirqs to execute in process
> 	context (e.g., CONFIG_PREEMPT_RT) are the most likely to
> 	see benefit from this patch, as a pair of context switches
> 	are saved in that case.  Of course, CONFIG_PREEMPT_RT is
> 	more about scheduling latency than maximum throughput.
> 
> 4.	It does complicate the code a bit, but could be refactored
> 	to reduce the complication.  (I haven't thought this through,
> 	but my guess is that the initial check should be factored
> 	across the "if" statement.)
> 
> All that aside, I don't believe the priority of this patch is particularly
> high, although it did do a good job of showing that your understanding
> of the treercu implementation is increasing.  Which is a very good thing!
> 
> Just out of curiosity, what is your test procedure?
> 
> 							Thanx, Paul
> 
>

1------------------result
(CONFIG_HZ=1000 and CONFIG_PREEMPT=y)
Before patch applied: 10% empty calls (something 30+ percent)
after patch applied: <0.5% empty calls

2------------------test procedure
I think you can add kernel trace code to detect it. (I think it's simpler)
The next is my fast test:

ensure CONFIG_FUNCTION_GRAPH_TRACER = y

mount -t debugfs xx /debugfs/
echo rcu_process_callbacks > /debugfs/tracing/set_graph_function
echo function_graph > /debugfs/tracing/current_tracer

# make all cpu busy, example: complier the kernel with 'make -j XXX'
cat /debugfs/tracing/trace_pipe > trace.tmp # CTRL-C after 20 seconds
./parser.py trace.tmp

3----------------------test code and ....
(Because compiler may or may not inline a static function, So:)
Your 'empty_call_graph' is not deferent from mine very likely,
you should change it.

Q: why 'rcu_process_gp_end();' is empty call?
A: _raw_spin_trylock() is not inline-ed, we will
see a '{' and '_raw_spin_trylock()' in the graph
when it is not empty call:
 0)               |      rcu_process_gp_end() {
 0)   0.350 us    |        _raw_spin_trylock();
 0)   0.250 us    |        _raw_spin_unlock_irqrestore();
 0)   1.326 us    |      }

Q: Is this test trusted.
A: No, but I believe it.

------------------parser.py----------
#!/bin/env python

import sys

empty_call_graph = tuple(
''' rcu_process_callbacks() {
 __rcu_process_callbacks() {
 rcu_process_gp_end();
 check_for_new_grace_period();
 }
 __rcu_process_callbacks() {
 rcu_process_gp_end();
 check_for_new_grace_period();
 }
 }
'''.splitlines())

total=0
empty=0
match=0
empty_block=[]

for line in file(sys.argv[1]):
  empty_block.append(line)
  if line.find('force_quiescent_state();') >= 0:
    continue

  if line.find(empty_call_graph[match]) < 0:
    match = 0
    empty_block=[]
    continue

  match = match + 1
  if match == 1:
    total = total + 1
  elif match == len(empty_call_graph):
    empty = empty + 1
    for emptyline in empty_block:
      print emptyline,
    empty_block=[]
    match = 0

print('empty call/total call: %d/%d' % (empty, total))
print('fraction: %f%%' % (100.0 * empty / total))


