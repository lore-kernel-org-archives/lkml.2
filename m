Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0DORSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:18:23 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:59824 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab0DORSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=aw3LJB5kqdUwHvxfE/3/nvdd5eIzspp9XOnSp3+a/sI4e2Oz1BRu6cYBI7PkFuv6Ft
         tSLIbRy4Vnq1F6WSSyziR9a8nHikRwstcyVRLvnQkI1T4vHZS1SBVkmz9Vd0EvsC77D7
         OHzzRMN5xswANzmz5SJ24AzX5XBkjUHzonuEE=
Subject: Re: sched_clock - microblaze
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: michal.simek@petalogix.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BC728DD.5020404@petalogix.com>
References: <4BC728DD.5020404@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 16 Apr 2010 01:18:07 +0800
Message-ID: <1271351887.20625.77.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 16:55 +0200, Michal Simek wrote:
> Hi Thomas and Steven,
> 
> I would like to improve time measuring for ftrace (Log below)
> 
> I looked at http://lkml.org/lkml/2009/11/16/181
> where Thomas suggested to create sched_clock() function.
> I used the same solution as Wu proposed but it is not nice.

Which solution did you use?

>From my point of view, the basic idea of high resolution sched_clock()
looks like:

0. read the clock cycles from the hardware clock counter

cyc = read_clock_counter()

read_clock_counter() is processor specific, for example, in X86, there
is a tsc register, and in a r4k MIPS, there is a c0 counter. such
counters can provide a high resolution of time counting: the tsc
register's frequency is equal to the frequency of the processor, if the
frequency of the processor is 1G, then one cycle of the counter gives us
1ns.

1. convert the clock cycles to ns

ns = cyc * NSEC_PER_SEC / freq (freq is clock freq of the counter)
   = use the scaling math. (please refer to arch/x86/kernel/tsc.c)
   = (cyc * mult) >> shift   (refer to clocksource_calc_mult_shift() )

so, you need to implement the arch specific cyc2ns(), now, we get:

cyc = read_clock_counter();
ns = cyc2ns(cyc);

2. handle the overflow problems

+ overflow of 32bit counter, solution: cnt32_to_63()

If the hardware clock counter is 32bit long, you need to 'avoid' its
counting overflow via cnt32_to_63() defined in
include/linux/cnt32_to_63()

Please ensure the cnt32_to_63() is called every less than half of the
overflow period(the max time the counter can record) of the hardware
clock counter, now, we get:

#ifdef CONFIG_64BIT
cyc = read_clock_counter();
#else /* CONFIG_32BIT */
cyc = cnt32_to_63(read_clock_counter());
#endif
ns = cyc2ns(cyc);

and a kernel software timer(setup_timer(), mod_timer()) is needed to
update call the cnt32_to_63() automatically.

[why cnt32_to_63()? it has less overhead than the other methods, will
talk about it later.]

'avoid' above means avoid it overflow too quickly, for example, a 32bit
clock counter with 400MHz may overflow after about 10+ seconds, which is
not enough for Ftrace since a function may be executed for more 200+
seconds, we need a bigger 'counter', that is why cnt32_to_63() is
needed, it tries to convert the 32bit counter to a virtual 63bit(the
highest bit is used to sync the virtual high 32bit with the low real
32bit in the hardware counter) long, then with the 63bit counter, it
will overflow after several hundreds of days, which is enough for
generic debugging.

+ overflow of (cyc * mult), solution: smaller shift OR 128bit arithmetic

And please ensure the shift is not too big(Seems ARM use 8 as the shift,
and X86 use 10), otherwise, the 64bit arithmetic (cyc * mult) will
overflow quickly.

As we can see, the type of the return value of sched_clock() is unsigned
long long, 64bit, so, the value of (cyc * mult) is limited to 64bit. And
because cyc is also in 64bit (63bit if using cnt32_to_63()), mult can
not be too big, otherwise, (cyc * mult) will overflow quickly, mult is
relative to shift, then shift can not be too big.

In another aspect, the shift can not be too small, otherwise, the
precision will be lost. to learn how to choose such a shift, please
refer to arch/arm/plat-orion/time.c and arch/x86/kernel/tsc.c.

By default, the mult and shift in struct clocksource is calculated by
clocksource_calc_mult_shift(), both of them are in 32bit, and in some
platforms, for a 32bit counter, the shift is calculated from 32 to 0 and
will be set as 31 for getting a good precision, but it is too big a
value for a virtual 63bit counter, so, we need to manually set it a
smaller one, the same to a real 64bit hardware counter.

In some platforms, they have used the 128bit arithmetic to handle the
overflow problem for a real 64bit hardware counter(please refer to
arch/mips/cavium-octeon/csrc-octeon.c), perhaps we also need to use it
for clocksource_cyc2ns() too(I did not check the potential overflow
problem in such processor yet, it should overflow if the shift is too
big!), but we also need to notice that, 128bit arithmetic may not be
supported directly in some processors or it may increase the overhead
obviously.

3. why not getnstimeofday()

we need a lower overhead of clock func (please refer to
kernel/trace/trace_clock.c) to make Ftrace has lower overhead for the
clock func is a basic function needed to get the timestamp of entering
into and exiting from a kernel function.

I have done some overhead benchmarking of the cnt32_to_63() based
sched_clock() and getnstimeofday() on a MIPS machine with 64bit kernel:

Clock func/overhead(ns) Min Avg Max Jitter Std.Dev.
----------------------------------------------
  sched_clock(cnt32_to_63) 105 116.2 236 131 9.5
  getnstimeofday()      160 167.1 437 277 15
  sched_clock(Accumulation method[1])  193 200.9 243 50 2.9
----------------------------------------------

'Overhead' above means the time spent on calling clock func themselves,
as we can see, the result of cnt32_to_63() base method is better than
the other two.

[1] the algorithm looks like this:

static inline unsigned long long notrace read_clock_counter(void)
{
        static u64 clock;
        static u32 old_clock;
        u32 current_clock;

        raw_spin_lock(&clock_lock);
        current_clock = read_c0_count();
        clock += ((current_clock - old_clock) & MASK);
        old_clock = current_clock;
        raw_spin_unlock(&clock_lock);

        return clock;
}

Regards,
	Wu Zhangjin

> 
> Is unimplemented sched_clock the reason why ftrace not show fine grain time?
> 
> Or is there any other thing which is wrong?
> 
> Thanks,
> Michal
> 
> 
> 
> Dumping ftrace buffer:
> ---------------------------------
>   0) ! 10000.00 us |                                }
>   0)   <========== |
>   0) ! 10000.00 us |                            }
>   0) ! 10000.00 us |                          }
>   0)   0.000 us    |                          get_seconds();
>   0)   0.000 us    |                          tcp_rcv_rtt_update();
>   0)   0.000 us    |                          tcp_ack();
>   0)   0.000 us    |                          tcp_rcv_rtt_update();
>   0)   0.000 us    |                          tcp_urg();
>   0)               |                          tcp_data_queue() {
>   0)   0.000 us    |                            __sk_mem_schedule();
>   0)   0.000 us    |                            tcp_event_data_recv();
>   0)   0.000 us    |                            sock_def_readable();
>   0)   0.000 us    |                          }
>   0)   0.000 us    |                          tcp_check_space();
>   0)               |                          __tcp_ack_snd_check() {
> 
> 


