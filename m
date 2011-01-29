Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1A2AE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:04:59 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:57716
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754423Ab1A2AE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:58 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK936eK1432N98dNzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D435988.2090002@am.sony.com>
Date: Fri, 28 Jan 2011 16:04:24 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Oleg Nesterov <oleg@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 17/18] sched: Move the second half of ttwu() to the
 remote cpu
References: <20110104145929.772813816@chello.nl>	 <20110104150103.164045216@chello.nl> <20110105210754.GA2579@redhat.com>	 <1294326577.2016.373.camel@laptop>  <20110107152207.GA16341@redhat.com> <1295368688.30950.925.camel@laptop>
In-Reply-To: <1295368688.30950.925.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/11 08:38, Peter Zijlstra wrote:
> On Fri, 2011-01-07 at 16:22 +0100, Oleg Nesterov wrote:

>> Doesn't __migrate_task() need pi_lock? Consider:

In the reply to this Peter suggests:

"keep ->pi_lock locked over the call to
stop_one_cpu() from set_cpus_allowed_ptr()"

Then Oleg replies to Peter with a possible problem to that.

If I understand Oleg's original suggestion, it solves the problem.
I inject the "pi_lock in __migrate_task()" in Oleg's original problem
description below, and how I think it fixes the problem:

>>
>> 1. A task T runs on CPU_0, it does set_current_state(TASK_INTERRUBTIBLE)
>>
>> 2. some CPU does set_cpus_allowed_ptr(T, new_mask), new_mask doesn't
>>    include CPU_0.
>>
>>    T is running, cpumask_any_and() picks CPU_1, set_cpus_allowed_ptr()
>>    drops pi_lock and rq->lock before stop_one_cpu().
>>
>> 3. T calls schedule() and becomes deactivated.
>>
>> 4. CPU_2 does try_to_wake_up(T, TASK_INTERRUPTIBLE), takes pi_lock
>>    and sees on_rq == F.
>>
>> 5. set_cpus_allowed_ptr() resumes and calls stop_one_cpu(cpu => 1).
>>
>> 6. cpu_stopper_thread() runs on CPU_1 and calls ____migrate_task().

      It attempts to lock p->pi_lock (and thus blocks on lock held by
      try_to_wake_up())

      So do not get to this double rq lock yet:
>>    It locks CPU_0 and CPU_1 rq's and checks task_cpu() == src_cpu.


>>
>> 7. CPU_2 calls select_task_rq(), it returns (to simplify) 2.
>>
>>    Now try_to_wake_up() does set_task_cpu(T, 2), and calls
>>    ttwu_queue()->ttwu_do_activate()->activate_task().

 7.1  Now __migrate_task() gets the p->pi_lock that it was blocked on,
      continues on to get the double rq lock (the last part of step 6
      that got postponed above), discovers that
      (task_cpu(p) != src_cpu), and thus skips over the problematic
      step 8:

>>
>> 8. __migrate_task() on CPU_1 sees p->on_rq and starts the
>>    deactivate/activate dance racing with ttwu_do_activate()
>>    on CPU_2.
> 
> Drad, yes I think you're right, now you've got me worried about the
> other migration paths too.. however did you come up with that
> scenario? :-)
> 
> A simple fix would be to keep ->pi_lock locked over the call to
> stop_one_cpu() from set_cpus_allowed_ptr().
> 
> I think the sched_fair.c load-balance code paths are ok because we only
> find a task to migrate after we've obtained both runqueue locks, so even
> if we migrate current, it cannot schedule (step 3).
> 
> I'm not at all sure about the sched_rt load-balance paths, will need to
> twist my head around that..

I haven't yet tried to twist my head around either the sched_fair or the
sched_rt load balance paths.  But wouldn't it just be safer (especially
given that the load balance code will be modified by somebody at some
point in the future, and that this locking complexity does require head
twisting) to just add the pi_lock in the load-balance paths also?

-Frank

