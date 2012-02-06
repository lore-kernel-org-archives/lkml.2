Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2BFV0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:26:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58356 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2BFV0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:26:20 -0500
MIME-Version: 1.0
In-Reply-To: <1328562166.2482.40.camel@laptop>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<1328562166.2482.40.camel@laptop>
Date: Mon, 6 Feb 2012 13:26:19 -0800
Message-ID: <CABeCy1ayUHxpyqwYQKUZcGCBpiqDZyMcaB4bz7JuEycrZV6CEw@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 1:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
>> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
>> to target CPU. However, if the target CPU is in mwait based idle, we can
>> do IPI-less wakeups using the magical powers of monitor-mwait.
>> Doing this has certain advantages:
>> * Lower overhead on Async IPI send path. Measurements on Westmere based
>>   systems show savings on "no wait" smp_call_function_single with idle
>>   target CPU (as measured on the sender side).
>>   local socket smp_call_func cost goes from ~1600 to ~1200 cycles
>>   remote socket smp_call_func cost goes from ~2000 to ~1800 cycles
>> * Avoiding actual interrupts shows a measurable reduction (10%) in system
>>   non-idle cycles and cache-references with micro-benchmark sending IPI from
>>   one CPU to all the other mostly idle CPUs in the system.
>> * On a mostly idle system, turbostat shows a tiny decrease in C0(active) time
>>   and a corresponding increase in C6 state (Each row being 10min avg)
>>           %c0   %c1   %c6
>>   Before
>>   Run 1  1.51  2.93 95.55
>>   Run 2  1.48  2.86 95.65
>>   Run 3  1.46  2.78 95.74
>>   After
>>   Run 1  1.35  2.63 96.00
>>   Run 2  1.46  2.78 95.74
>>   Run 3  1.37  2.63 95.98
>>
>> * As a bonus, we can avoid sched/call IPI overhead altogether in a special case.
>>   When CPU Y has woken up CPU X (which can take 50-100us to actually wakeup
>>   from a deep idle state) and CPU Z wants to send IPI to CPU X in this period.
>>   It can get it for free.
>>
>> We started looking at this with one of our workloads where system is partially
>> busy and we noticed some kernel hotspots in find_next_bit and
>> default_send_IPI_mask_sequence_phys coming from sched wakeup (futex wakeups)
>> and networking call functions. So, this change addresses those two specific
>> IPI types. This could be extended to nohz_kick, etc.
>>
>> Note:
>> * This only helps when target CPU is idle. When it is busy we will still send
>>   IPI as before.
>> * Only for X86_64 and mwait_idle_with_hints for now, with limited testing.
>> * Will need some accounting for these wakeups exported for powertop and friends.
>>
>> Comments?
>
> Curiously you avoided the existing tsk_is_polling() magic, which IIRC is
> doing something similar for waking from the idle loop.
>

Yes. That needs remote CPU's current task, which extends onto rq lock,
which I was trying to avoid. So, I went with conditional waiting on
idle exit for the small window of WAKING to WOKEN state change, as we
know we are always polling in the mwait loop.
