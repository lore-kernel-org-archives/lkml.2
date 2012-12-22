Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2LVQjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:39:18 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:35135 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LVQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <1356106396.5896.111.camel@gandalf.local.home>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	<1356028391-14427-8-git-send-email-fweisbec@gmail.com>
	<1356106396.5896.111.camel@gandalf.local.home>
Date: Sat, 22 Dec 2012 17:39:14 +0100
Message-ID: <CAFTL4hxSMmu5h1=yVK1qn6NNVYF3WfTZYxPxPTJ=xzibgpkayQ@mail.gmail.com>
Subject: Re: [PATCH 07/24] nohz: Assign timekeeping duty to a non-full-nohz CPU
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/21 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
>
> kernel/time/tick-sched.c:517:6: error: have_full_nohz_mask undeclared
> (first use in this function)
>
>
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -112,7 +112,8 @@ static void tick_sched_do_timer(ktime_t now)
>>        * this duty, then the jiffies update is still serialized by
>>        * jiffies_lock.
>>        */
>> -     if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
>> +     if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
>> +         && !tick_nohz_full_cpu(cpu))
>>               tick_do_timer_cpu = cpu;
>>  #endif
>>
>> @@ -512,6 +513,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>>               return false;
>>       }
>>
>> +     /* If there are full nohz CPUs around, we need to keep the timekeeping duty */
>> +     if (have_full_nohz_mask && tick_do_timer_cpu == cpu)
>> +             return false;
>> +
>>       return true;
>>  }
>>
>
> Fold in:
>
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 4a68b50..00e5682 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -164,6 +164,8 @@ static int __init tick_nohz_full_setup(char *str)
>         return 1;
>  }
>  __setup("full_nohz=", tick_nohz_full_setup);
> +#else
> +#define have_full_nohz_mask 0
>  #endif

Ah thanks! I'm folding your patch.
I can add your SOB, right?
