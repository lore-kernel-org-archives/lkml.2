Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2BFPMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:12:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab2BFPMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:12:34 -0500
Date: Mon, 6 Feb 2012 10:12:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <vivek.goyal2008@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120206151219.GC30752@redhat.com>
References: <1328514611.21268.66.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328514611.21268.66.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 03:50:11PM +0800, Shaohua Li wrote:
> Meelis reported a warning:
> 
> WARNING: at kernel/timer.c:1122 run_timer_softirq+0x199/0x1ec()
> Hardware name: 939Dual-SATA2
> timer: cfq_idle_slice_timer+0x0/0xaa preempt leak: 00000102 -> 00000103
> Modules linked in: sr_mod cdrom videodev media drm_kms_helper ohci_hcd ehci_hcd v4l2_compat_ioctl32 usbcore i2c_ali15x3 snd_seq drm snd_timer snd_seq
> Pid: 0, comm: swapper Not tainted 3.3.0-rc2-00110-gd125666 #176
> Call Trace:
>  <IRQ>  [<ffffffff81022aaa>] warn_slowpath_common+0x7e/0x96
>  [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
>  [<ffffffff81022b56>] warn_slowpath_fmt+0x41/0x43
>  [<ffffffff8114c526>] ? cfq_idle_slice_timer+0xa1/0xaa
>  [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
>  [<ffffffff8102c124>] run_timer_softirq+0x199/0x1ec
>  [<ffffffff81047a53>] ? timekeeping_get_ns+0x12/0x31
>  [<ffffffff810145fd>] ? apic_write+0x11/0x13
>  [<ffffffff81027475>] __do_softirq+0x74/0xfa
>  [<ffffffff812f337a>] call_softirq+0x1a/0x30
>  [<ffffffff81002ff9>] do_softirq+0x31/0x68
>  [<ffffffff810276cf>] irq_exit+0x3d/0xa3
>  [<ffffffff81014aca>] smp_apic_timer_interrupt+0x6b/0x77
>  [<ffffffff812f2de9>] apic_timer_interrupt+0x69/0x70
>  <EOI>  [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
>  [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
>  [<ffffffff8100801f>] ? default_idle+0x1e/0x32
>  [<ffffffff81008019>] ? default_idle+0x18/0x32
>  [<ffffffff810008b1>] cpu_idle+0x87/0xd1
>  [<ffffffff812de861>] rest_init+0x85/0x89
>  [<ffffffff81659a4d>] start_kernel+0x2eb/0x2f8
>  [<ffffffff8165926e>] x86_64_start_reservations+0x7e/0x82
>  [<ffffffff81659362>] x86_64_start_kernel+0xf0/0xf7
> 
> this_q == locked_q is possible. There are two problems here:
> 1. In UP case, there is preemption counter issue as spin_trylock always
> successes.
> 2. In SMP case, the loop breaks too earlier.

Thanks Shaohua. So is it the case where there are more than one cic's on
ioc->ioc_list and first cic's queue is not same as locked_queue. But some
other cic other than first has queue same as locked_queue.

In that case current code will still defer freeing of ioc and cic to a
worker thread. So this patch will introduce one optimization to handle
those cases and avoid calling worker thread.

Secondly it fixes the discrepancy of preemption count on UP machines, 
where we have one extra preemption count after finish of function
put_io_context(). So for UP case spin_trylock() increases the preemption
count and always returns success. As this_q == locked_q we never try to do
unlock on this queue and hence never decrement the preemption count
hence resulting in preemption count warning.

Changlog was not obivious atleast to me. I wished it was little more
descriptive. Anyway, patch is already committed..

Thanks
Vivek
