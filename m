Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2JZIz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:55:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:10190 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2JZIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:55:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,653,1344236400"; 
   d="scan'208";a="209594023"
Message-ID: <1351241719.2207.17.camel@ymzhang.sh.intel.com>
Subject: [PATCH V2] hrtimer:__run_hrtimer races with enqueue_hrtimer
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: "he, bo" <bo.he@intel.com>
Date: Fri, 26 Oct 2012 16:55:19 +0800
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2 adds a checking HRTIMER_STATE_ENQUEUED. If HRTIMER_STATE_ENQUEUED is set,
We don't call enqueue_hrtimer. It should be rare that HRTIMER_STATE_ENQUEUED is set.

---

We hit a kernel panic at __run_hrtimer=>BUG_ON(timer->state != HRTIMER_STATE_CALLBACK).
<2>[   10.226053, 3] kernel BUG at /home/android/xiaobing/ymz/r4/hardware/intel/linux-2.6/kernel/hrtimer.c:1228!
<0>[   10.235682, 3] invalid opcode: 0000 [#1] PREEMPT SMP
<4>[   10.240716, 3] Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat btwilink rmi4(C) fmdrv_chr st_drv matrix(C)
<4>[   10.251651, 3]
<4>[   10.253391, 3] Pid: 68, comm: kworker/3:4 Tainted: G        WC  3.0.34-140430-g2af538d #45 Intel Corporation CloverTrail/FFRD
<4>[   10.264674, 3] EIP: 0060:[<c126c7ed>] EFLAGS: 00010002 CPU: 3
<4>[   10.270411, 3] EIP is at __run_hrtimer+0xbd/0x240
<4>[   10.275091, 3] EAX: 00000001 EBX: f67fb6b8 ECX: f57b4000 EDX: 00007301
<4>[   10.281602, 3] ESI: c1d614c0 EDI: f67fb680 EBP: f57b5dd8 ESP: f57b5da8
<4>[   10.288113, 3]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>[   10.293754, 3] Process kworker/3:4 (pid: 68, ti=f57b4000 task=f57aa730 task.ti=f57b4000)
<0>[   10.301827, 3] Stack:
<4>[   10.304083, 3]  00000000 c1afef40 f57b5dd8 c167a6e0 f67fb680 20b366e3 f67fb6b8 f57b5e14
<4>[   10.312069, 3]  00000001 f67fb6b8 00000001 f67fb680 f57b5e28 c126d1e5 f57b5e08 c126f325
<4>[   10.320055, 3]  00000000 86b9868d 00000001 86b9868d 00000001 00000003 ffffffff 7fffffff
<0>[   10.328041, 3] Call Trace:
<4>[   10.330742, 3]  [<c167a6e0>] ? gburst_thread_stop.isra.25+0x40/0x40
<4>[   10.336988, 3]  [<c126d1e5>] hrtimer_interrupt+0xd5/0x250
<4>[   10.342368, 3]  [<c126f325>] ? sched_clock_cpu+0xe5/0x150
<4>[   10.347753, 3]  [<c1871d44>] smp_apic_timer_interrupt+0x54/0x88
<4>[   10.353654, 3]  [<c1496558>] ? trace_hardirqs_off_thunk+0xc/0x14
<4>[   10.359643, 3]  [<c186be9f>] apic_timer_interrupt+0x2f/0x34
<4>[   10.365199, 3]  [<c186e60f>] ? sub_preempt_count+0x1f/0x50
<4>[   10.370669, 3]  [<c149558a>] delay_tsc+0x3a/0xc0
<6>[   10.371589, 0] android_work: did not send uevent (0 0   (null))
<4>[   10.381171, 3]  [<c14954e3>] __const_udelay+0x23/0x30
<4>[   10.386207, 3]  [<c16d043a>] mdfld_dsi_send_dcs+0x12a/0x5d0
<4>[   10.391760, 3]  [<c186b6c6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
<4>[   10.398101, 3]  [<c16af431>] ? ospm_power_using_hw_begin+0xa1/0x350
<4>[   10.399053, 3]  [<c186a49f>] ? __mutex_lock_slowpath+0x1ff/0x2f0
<4>[   10.399069, 3]  [<c16bd59e>] mdfld_dbi_update_panel+0x21e/0x2d0
<4>[   10.399085, 3]  [<c16b1ae1>] mdfld_te_handler_work+0x71/0x80
<4>[   10.399099, 3]  [<c12642be>] process_one_work+0xfe/0x3f0
<4>[   10.399114, 3]  [<c16b1a70>] ? mdfld_async_flip_te_handler+0xf0/0xf0

Basically, __run_hrtimer has a race with enqueue_hrtimer. When __run_hrtimer calls
the timer callback fn, another thread might call enqueue_hrtimer or hrtimer_start
to requeue it, and the timer->state is equal to HRTIMER_STATE_CALLBACK|HRTIMER_STATE_ENQUEUED,
which causes the BUG_ON(timer->state != HRTIMER_STATE_CALLBACK) checking fails.

The patch fixes it by checking only bit HRTIMER_STATE_CALLBACK and also bypass
enqueue_hrtimer when the timer is queued.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: He Bo <bo.he@intel.com>
---
 kernel/hrtimer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..535cdbb 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1235,8 +1235,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
 	 */
 	if (restart != HRTIMER_NORESTART) {
-		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-		enqueue_hrtimer(timer, base);
+		BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
+		if (likely(!(timer->state & HRTIMER_STATE_ENQUEUED)))
+			enqueue_hrtimer(timer, base);
 	}
 
 	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
-- 
1.7.4.1



