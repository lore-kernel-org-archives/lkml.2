Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1GSU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:58:32 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:28979 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1GSU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:58:31 -0400
Message-ID: <4E25F002.2080503@hp.com>
Date: Tue, 19 Jul 2011 14:58:42 -0600
From: Terry Loftin <terry.loftin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: Bob Montgomery <bob.montgomery@hp.com>
Subject: [PATCH 0/2] sched: Fix "divide error: 0000" in find_busiest_group
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

The divide error occurs in inlined function update_sg_lb_stats() in
kernel/sched.c when we adjust the relative CPU power of a group by
dividing group_load by group->cpu_power:

    /* Adjust by relative CPU power of the group */ sgs->avg_load =
    (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;

In this case, group->cpu_power is zero.  This was set in
update_cpu_power(), which depends on scale_rt_power() among other things.
scale_rt_power() is based in part on the rq->clock and rq->age_stamp
values for the runqueue:

    total = sched_avg_period() + (rq->clock - rq->age_stamp);

The clock and age_stamp values are in nanoseconds and come from
__cycles_2_ns() which converts the CPU tsc counter to nanoseconds.
On 64-bit systems, the computation returned from __cycles_2_ns() wraps
when the nanosecond value is 54 bits or larger (about 208.5 days).

The rq->age_stamp is designed to follow the clock value but does not
account for the fact that the clock value may wrap, and it is never reset.
After rq->clock wraps, the expression (rq->clock - rq->age_stamp) leads
to large negative values which in turn lead to very large values for
scale_rt_power().

In update_cpu_power(), an unsigned long local variable, 'power', is
used to hold the intermediate result, including the return value from
scale_rt_power(), before it is placed in an unsigned int rq->cpu_power.
If the power calculated in update_cpu_power() is > 32 bits, but all
the low order bits are zero, then the value will be truncated and
rq->cpu_power will be set to zero, leading to the divide by zero error.
There is a protective check immediately before the assignment, but it
compares the full 64-bit value instead of the 32-bit portion that will
be stored in rq->cpu_power.

I have analyzed two crash dumps from systems that were up 220 and 230
days to confirm this.

-T

Signed-off-by: Terry Loftin <terry.loftin@hp.com>
Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>


