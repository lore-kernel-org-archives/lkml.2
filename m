Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2BFVC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:02:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33037 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BFVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:02:57 -0500
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1328560933-3037-1-git-send-email-venki@google.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 22:02:46 +0100
Message-ID: <1328562166.2482.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
> to target CPU. However, if the target CPU is in mwait based idle, we can
> do IPI-less wakeups using the magical powers of monitor-mwait.
> Doing this has certain advantages:
> * Lower overhead on Async IPI send path. Measurements on Westmere based
>   systems show savings on "no wait" smp_call_function_single with idle
>   target CPU (as measured on the sender side).
>   local socket smp_call_func cost goes from ~1600 to ~1200 cycles
>   remote socket smp_call_func cost goes from ~2000 to ~1800 cycles
> * Avoiding actual interrupts shows a measurable reduction (10%) in system
>   non-idle cycles and cache-references with micro-benchmark sending IPI from
>   one CPU to all the other mostly idle CPUs in the system.
> * On a mostly idle system, turbostat shows a tiny decrease in C0(active) time
>   and a corresponding increase in C6 state (Each row being 10min avg)
>           %c0   %c1   %c6
>   Before
>   Run 1  1.51  2.93 95.55
>   Run 2  1.48  2.86 95.65
>   Run 3  1.46  2.78 95.74
>   After
>   Run 1  1.35  2.63 96.00
>   Run 2  1.46  2.78 95.74
>   Run 3  1.37  2.63 95.98
> 
> * As a bonus, we can avoid sched/call IPI overhead altogether in a special case.
>   When CPU Y has woken up CPU X (which can take 50-100us to actually wakeup
>   from a deep idle state) and CPU Z wants to send IPI to CPU X in this period.
>   It can get it for free.
> 
> We started looking at this with one of our workloads where system is partially
> busy and we noticed some kernel hotspots in find_next_bit and
> default_send_IPI_mask_sequence_phys coming from sched wakeup (futex wakeups)
> and networking call functions. So, this change addresses those two specific
> IPI types. This could be extended to nohz_kick, etc.
> 
> Note:
> * This only helps when target CPU is idle. When it is busy we will still send
>   IPI as before.
> * Only for X86_64 and mwait_idle_with_hints for now, with limited testing.
> * Will need some accounting for these wakeups exported for powertop and friends.
> 
> Comments?

Curiously you avoided the existing tsk_is_polling() magic, which IIRC is
doing something similar for waking from the idle loop.

