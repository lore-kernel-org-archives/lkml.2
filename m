Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab1LONgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:36:36 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61380 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LONgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <1323943710.18942.24.camel@twins>
References: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
	<1323943710.18942.24.camel@twins>
Date: Thu, 15 Dec 2011 14:36:34 +0100
Message-ID: <CAKfTPtB7Lib71iGrf=fGC5qtKFwD_qw3yz2OSkNy+CW7fCDtgw@mail.gmail.com>
Subject: Re: [RFC] sched: Ensure cpu_power periodic update
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 December 2011 11:08, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-12-12 at 20:21 +0100, Vincent Guittot wrote:
>> With a lot of small tasks, the softirq sched is nearly never called
>> when no_hz is enable. In this case the load_balance is mainly called with
>> the newly_idle mode which doesn't update the cpu_power.
>> Add a next_update field which ensure a maximum update period when
>> there is short activity
>
>> +     if (local_group) {
>> +             if (idle != CPU_NEWLY_IDLE) {
>> +                     if (balance_cpu != this_cpu) {
>> +                             *balance = 0;
>> +                             return;
>> +                     }
>> +                     update_group_power(sd, this_cpu);
>> +             } else if (time_after_eq(jiffies, group->sgp->next_update))
>> +                     update_group_power(sd, this_cpu);
>>       }
>
> Hmm, I would have expected it to be called from the NOHZ balancing path
> instead of the new_idle path. Your changelog fails to mentions any
> considerations on this..
>

As we are not lucky, the small tasks are mainly running between ticks
and  the timer interrupt doesn't fire which implies that both
rebalance_domain of the cpu and nohz_balancer_kick are not called. We
have a lot of call to idle_balance() when cpus become idle and very
few calls to rebalance or nohz_idle_balance. If some tasks are rt
tasks, the cpu_power should be updated regularly to reflect current
use of the cpu by rt scheduler.

I'm using cyclictest to easily reproduce the problem on my dual cortex-A9

> Then again, its probably easier to keep update_group_power on this_cpu
> than to allow a remote update of your cpu_power.
>

This additional path for updating the cpu_power will only be used by
this_cpu because it is called by idle_balance. But we still have a
call to update_group_power by a remote cpu when nohz_idle_balance is
called.

> So I'm not opposed to this patch, I'd just like a little extra
> clarification.

Vincent
