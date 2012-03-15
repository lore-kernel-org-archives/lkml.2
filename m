Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab2COODQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:03:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:40366 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2COODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:03:13 -0400
Date: Thu, 15 Mar 2012 15:03:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <levinsasha928@gmail.com>
cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: ntp: BUG: spinlock lockup on CPU#1
In-Reply-To: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203151440590.2466@ionos>
References: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Sasha Levin wrote:

> Hi all,
> 
> I was doing some more fuzzing with trinity in a KVM tools guest, using
> today's linux-next, when I've experienced a complete system lockup
> (just in the guest ofcourse). After a bit I got the spew at the bottom
> of this mail.
> 
> >From what I can tell from the logs, there were several threads waiting
> on syscall results, and I suspect that the adjtimex() call on CPU3 is
> somehow responsible for this lockup.
> [   69.785019] Call Trace:
> [   69.785019]  [<ffffffff8110e41d>] clockevents_program_event+0x3d/0x100
> [   69.785019]  [<ffffffff8189babb>] ? debug_object_activate+0x11b/0x190
> [   69.785019]  [<ffffffff8111009f>] tick_program_event+0x1f/0x30
> [   69.785019]  [<ffffffff810da8d5>] hrtimer_reprogram.clone.21+0x95/0xe0
> [   69.785019]  [<ffffffff810dafe4>] __hrtimer_start_range_ns+0x2c4/0x3b0
> [   69.785019]  [<ffffffff810db103>] hrtimer_start+0x13/0x20
> [   69.785019]  [<ffffffff8110a001>] do_adjtimex+0x541/0x6d0
> [   69.785019]  [<ffffffff8119ee07>] ? might_fault+0x97/0xa0
> [   69.785019]  [<ffffffff810b895e>] sys_adjtimex+0x4e/0x90
> [   69.785019]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f

Indeed, that's a long standing bug. In mainline it's live locking due
to:

do_adjtimex()
  write_seqlock_irq(&xtime_lock);
    process_adjtimex_modes();
      process_adj_status();
        ntp_start_leap_timer();
          hrtimer_start();
             hrtimer_reprogram();
               tick_program_event()
                 clockevents_program_event()
		   ktime_get()
                     seq = req_seqbegin(xtime_lock);

-->     Live lock, because xtime lock is write locked.

This affects all other cpus as well as they call any of the xtime_lock
protected functions. Happy spinning for ever!

But in -next we have a separate ntp lock. So here the problem is more
subtle:

[   69.785020]  <IRQ>  [<ffffffff81899118>] spin_dump+0x78/0xc0
[   69.785020]  [<ffffffff818993b0>] do_raw_spin_lock+0x130/0x140
[   69.785020]  [<ffffffff81110500>] ? tick_nohz_handler+0x100/0x100
[   69.785020]  [<ffffffff82709a12>] _raw_spin_lock_irqsave+0x92/0xc0
[   69.785020]  [<ffffffff81109925>] ? ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8107bfe6>] ? kvm_clock_read+0x46/0x80
[   69.785020]  [<ffffffff81109925>] ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8110834c>] update_wall_time+0xbc/0x210
[   69.785020]  [<ffffffff811093c8>] do_timer+0x18/0x30
[   69.785020]  [<ffffffff811103a5>] tick_do_update_jiffies64+0x75/0xd0
[   69.785020]  [<ffffffff811105b0>] tick_sched_timer+0xb0/0xc0
[   69.785020]  [<ffffffff810daa71>] __run_hrtimer.clone.23+0x81/0x130
[   69.785020]  [<ffffffff810db537>] hrtimer_interrupt+0xe7/0x220
[   69.785020]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785020]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80

CPU 0                                                    CPU 1
do_adjtimex()
  spin_lock_irq(&ntp_lock);
    process_adjtimex_modes();				 timer_interrupt()
      process_adj_status();                                do_timer()
        ntp_start_leap_timer();                             write_lock(&xtime_lock);
          hrtimer_start();                                  update_wall_time();
             hrtimer_reprogram();                            ntp_tick_length()
               tick_program_event()                            spin_lock(&ntp_lock);
                 clockevents_program_event()
		   ktime_get()
                     seq = req_seqbegin(xtime_lock);

So CPU0 waits for xtime seqence to become valid and CPU1 cant make
progress because it's stuck on ntp_lock.

That means we need two fixes. One for mainline/stable and one for the
new split lock version.

Thanks,

	tglx
