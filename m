Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2BFQoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:44:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36300 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BFQod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:44:33 -0500
Date: Mon, 6 Feb 2012 08:44:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120206164428.GA21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206163721.GF30752@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 06, 2012 at 11:37:21AM -0500, Vivek Goyal wrote:
> block: Do not lock try to lock already locked queue again
> 
> put_io_context() can be called with one of the request queue lock 
> already held. But if the locked queue's cic is not first in the
> ioc->ioc_list, then we have two possible issues.
> 
> - For above condition, current code bails out and schedules the worker
>   thread for freeing up ioc. This can be optimized.
> 
> - It might happen that we received the queue locked but we still do the
>   trylock on the queue. For SMP case that's not a problem as we will
>   fail to lock already locked queue, but in case of UP, we seem to
>   succeed and in the process increment the preempt count. Once we are
>   done with ioc_exit_icq(), we do not call spin_unlock() on locked
>   queue as we are not supposed to. This leads to imbalance in preemtion
>   count and following warning was reported.
>
> This patch fixes both the above issues by making sure we do not try to
> lock already locked queue again.
> 
> WARNING: at kernel/timer.c:1122 run_timer_softirq+0x199/0x1ec()
> Hardware name: 939Dual-SATA2
> timer: cfq_idle_slice_timer+0x0/0xaa preempt leak: 00000102 -> 00000103
> Modules linked in: sr_mod cdrom videodev media drm_kms_helper ohci_hcd ehci_hcd
> v4l2_compat_ioctl32 usbcore i2c_ali15x3 snd_seq drm snd_timer snd_seq
> Pid: 0, comm: swapper Not tainted 3.3.0-rc2-00110-gd125666 #176
> Call Trace:
> <IRQ>  [<ffffffff81022aaa>] warn_slowpath_common+0x7e/0x96
> [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
> [<ffffffff81022b56>] warn_slowpath_fmt+0x41/0x43
> [<ffffffff8114c526>] ? cfq_idle_slice_timer+0xa1/0xaa
> [<ffffffff8114c485>] ? cfq_slice_expired+0x1d/0x1d
> [<ffffffff8102c124>] run_timer_softirq+0x199/0x1ec
> [<ffffffff81047a53>] ? timekeeping_get_ns+0x12/0x31
> [<ffffffff810145fd>] ? apic_write+0x11/0x13
> [<ffffffff81027475>] __do_softirq+0x74/0xfa
> [<ffffffff812f337a>] call_softirq+0x1a/0x30
> [<ffffffff81002ff9>] do_softirq+0x31/0x68
> [<ffffffff810276cf>] irq_exit+0x3d/0xa3
> [<ffffffff81014aca>] smp_apic_timer_interrupt+0x6b/0x77
> [<ffffffff812f2de9>] apic_timer_interrupt+0x69/0x70
> <EOI>  [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
> [<ffffffff81040136>] ? sched_clock_cpu+0x73/0x7d
> [<ffffffff8100801f>] ? default_idle+0x1e/0x32
> [<ffffffff81008019>] ? default_idle+0x18/0x32
> [<ffffffff810008b1>] cpu_idle+0x87/0xd1
> [<ffffffff812de861>] rest_init+0x85/0x89
> [<ffffffff81659a4d>] start_kernel+0x2eb/0x2f8
> [<ffffffff8165926e>] x86_64_start_reservations+0x7e/0x82
> [<ffffffff81659362>] x86_64_start_kernel+0xf0/0xf7
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Reported-by: Meelis Roos <mroos@linux.ee>
> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> Tested-by: Knut Petersen <Knut_Petersen@t-online.de>

Yeah, this seems better to me.  Jens, if you're gonna amend the
commit, please consider collapsing the following patch into the
original patch too.  Thanks.

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 7490b6d..12978fc 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -204,7 +204,14 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 				spin_unlock(last_q->queue_lock);
 			last_q = NULL;
 
-			/* spin_trylock() always successes in UP case */
+			/*
+			 * If icq for locked_q wasn't at the head of
+			 * icq_list, we can try to switch back to locked_q.
+			 * On SMP, the following locked_q test avoids
+			 * unnecessary deferring to release_work, on UP,
+			 * incorrect lock state transition (trylock
+			 * succeeding while holding the same lock).
+			 */
 			if (this_q != locked_q &&
 			    !spin_trylock(this_q->queue_lock))
 				break;
