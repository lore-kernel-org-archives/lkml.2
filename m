Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2BFHxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:53:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:5307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab2BFHxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:53:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103682465"
Subject: [patch]block: fix ioc locking warning
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 15:50:11 +0800
Message-ID: <1328514611.21268.66.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis reported a warning:

WARNING: at kernel/timer.c:1122 run_timer_softirq+0x199/0x1ec()
Hardware name: 939Dual-SATA2
timer: cfq_idle_slice_timer+0x0/0xaa preempt leak: 00000102 -> 00000103
Modules linked in: sr_mod cdrom videodev media drm_kms_helper ohci_hcd ehci_hcd v4l2_compat_ioctl32 usbcore i2c_ali15x3 snd_seq drm snd_timer snd_seq
Pid: 0, comm: swapper Not tainted 3.3.0-rc2-00110-gd125666 #176
Call Trace:
 <IRQ>  [<ffffffff81022aaa>] warn_slowpath_common+0x7e/0x96
 [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
 [<ffffffff81022b56>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8114c526>] ? cfq_idle_slice_timer+0xa1/0xaa
 [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
 [<ffffffff8102c124>] run_timer_softirq+0x199/0x1ec
 [<ffffffff81047a53>] ? timekeeping_get_ns+0x12/0x31
 [<ffffffff810145fd>] ? apic_write+0x11/0x13
 [<ffffffff81027475>] __do_softirq+0x74/0xfa
 [<ffffffff812f337a>] call_softirq+0x1a/0x30
 [<ffffffff81002ff9>] do_softirq+0x31/0x68
 [<ffffffff810276cf>] irq_exit+0x3d/0xa3
 [<ffffffff81014aca>] smp_apic_timer_interrupt+0x6b/0x77
 [<ffffffff812f2de9>] apic_timer_interrupt+0x69/0x70
 <EOI>  [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
 [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
 [<ffffffff8100801f>] ? default_idle+0x1e/0x32
 [<ffffffff81008019>] ? default_idle+0x18/0x32
 [<ffffffff810008b1>] cpu_idle+0x87/0xd1
 [<ffffffff812de861>] rest_init+0x85/0x89
 [<ffffffff81659a4d>] start_kernel+0x2eb/0x2f8
 [<ffffffff8165926e>] x86_64_start_reservations+0x7e/0x82
 [<ffffffff81659362>] x86_64_start_kernel+0xf0/0xf7

this_q == locked_q is possible. There are two problems here:
1. In UP case, there is preemption counter issue as spin_trylock always
successes.
2. In SMP case, the loop breaks too earlier.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reported-by: Meelis Roos <mroos@linux.ee>
Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Tested-by: Knut Petersen <Knut_Petersen@t-online.de>

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 27a06e0..7490b6d 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -204,7 +204,9 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 				spin_unlock(last_q->queue_lock);
 			last_q = NULL;
 
-			if (!spin_trylock(this_q->queue_lock))
+			/* spin_trylock() always successes in UP case */
+			if (this_q != locked_q &&
+			    !spin_trylock(this_q->queue_lock))
 				break;
 			last_q = this_q;
 			continue;


