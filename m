Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab1BCLyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:54:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1BCLyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QSiHRWBtkC6HKAma9xmzPiR2HdCRJosnHhnFflKoq1BAMFmFBRWT63XEGpjQHzrlqC
         PCaFw3LuvjZ7nyTK/VbFXX4Do5oqLlF7iJoB1X7oLJ7uYVhJklJCKyQ+fpASodoV6PTh
         ommLpkPVCkJvi3W2x3ch7mhjsPocLe17TYg2o=
Date: Thu, 3 Feb 2011 19:53:49 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] timer: use local_bh_enable_force_wake() in
 del_timer_sync()
Message-ID: <20110203115349.GB2121@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110203031943.GA8910@elliptictech.com>
 <20110203091227.GA1603@zhy>
 <1296725440.26581.354.camel@laptop>
 <20110203101739.GA1551@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110203101739.GA1551@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 2/2] timer: use local_bh_enable_force_wake() in del_timer_sync()

Nick Bowler reported:
  =================================
  [ INFO: inconsistent lock state ]
  2.6.38-rc3-bisect-00062-g8c007a1 #92
  ---------------------------------
  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
  swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
  (&(&dev->event_lock)->rlock){?.+...}, at: [<ffffffff8125def6>] input_event+0x41/0x83
  {HARDIRQ-ON-W} state was registered at:
  [<ffffffff810656d4>] mark_held_locks+0x52/0x70
  [<ffffffff8106593a>] trace_hardirqs_on_caller+0xf7/0x135
  [<ffffffff81065985>] trace_hardirqs_on+0xd/0xf
  [<ffffffff81044ac2>] __do_softirq+0x62/0x160
  [<ffffffff8100395c>] call_softirq+0x1c/0x28
  [<ffffffff81044cf2>] _local_bh_enable_ip+0xb3/0xe3
  [<ffffffff81044d3a>] local_bh_enable+0xd/0xf
  [<ffffffff8104a418>] del_timer_sync+0x4f/0x8e
  [<ffffffffa00947fe>] rfkill_schedule_global_op+0x41/0x84 [rfkill]
  [<ffffffffa0094858>] rfkill_schedule_evsw_rfkillall+0x17/0x19 [rfkill]
  [<ffffffffa009495f>] rfkill_event+0x58/0x5a [rfkill]
  [<ffffffff8125c980>] input_pass_event+0x97/0xea
  [<ffffffff8125de13>] input_handle_event+0x460/0x46f
  [<ffffffff8125df1b>] input_event+0x66/0x83
  [<ffffffffa009becb>] tpacpi_send_radiosw_update+0x7f/0xc4 [thinkpad_acpi]
  [<ffffffffa009c417>] hotkey_notify+0x507/0x581 [thinkpad_acpi]
  [<ffffffffa009b029>] dispatch_acpi_notify+0x29/0x2b [thinkpad_acpi]
  [<ffffffff8119a18a>] acpi_ev_notify_dispatch+0x62/0x7c
  [<ffffffff8118b323>] acpi_os_execute_deferred+0x24/0x31
  [<ffffffff810511bf>] process_one_work+0x204/0x33b
  [<ffffffff81053384>] worker_thread+0x136/0x255
  [<ffffffff810566da>] kthread+0x7d/0x85
  [<ffffffff81003864>] kernel_thread_helper+0x4/0x10
  irq event stamp: 559266
  hardirqs last  enabled at (559263): [<ffffffff811b40a5>] acpi_idle_enter_bm+0x236/0x275
  hardirqs last disabled at (559264): [<ffffffff812ffd6a>] save_args+0x6a/0x70
  softirqs last  enabled at (559266): [<ffffffff81044bce>] _local_bh_enable+0xe/0x10
  softirqs last disabled at (559265): [<ffffffff81044c0d>] irq_enter+0x3d/0x6f

  other info that might help us debug this:
  1 lock held by swapper/0:
  #0:  (&serio->lock){-.-...}, at: [<ffffffff81259018>] serio_interrupt+0x24/0x7e

  stack backtrace:
  Pid: 0, comm: swapper Tainted: G        W   2.6.38-rc3-bisect-00062-g8c007a1 #92
  Call Trace:
  <IRQ>  [<ffffffff81065442>] ? valid_state+0x17e/0x191
  [<ffffffff8100e159>] ? save_stack_trace+0x28/0x45
  [<ffffffff81065d18>] ? check_usage_forwards+0x0/0x87
  [<ffffffff81065568>] ? mark_lock+0x113/0x22d
  [<ffffffff8106687f>] ? __lock_acquire+0x2ac/0xd01
  [<ffffffff81065482>] ? mark_lock+0x2d/0x22d
  [<ffffffff81065482>] ? mark_lock+0x2d/0x22d
  [<ffffffff81065482>] ? mark_lock+0x2d/0x22d
  [<ffffffff81067338>] ? lock_acquire+0x64/0x81
  [<ffffffff8125def6>] ? input_event+0x41/0x83
  [<ffffffff812ff378>] ? _raw_spin_lock_irqsave+0x53/0x65
  [<ffffffff8125def6>] ? input_event+0x41/0x83
  [<ffffffff8125def6>] ? input_event+0x41/0x83
  [<ffffffff81261fb6>] ? atkbd_interrupt+0x9a/0x574
  [<ffffffff81259034>] ? serio_interrupt+0x40/0x7e
  [<ffffffff8125a31c>] ? i8042_interrupt+0x28e/0x2a8
  [<ffffffff8107e834>] ? handle_IRQ_event+0x20/0xae
  [<ffffffff810805e6>] ? handle_edge_irq+0xde/0x12a
  [<ffffffff810055c9>] ? handle_irq+0x1f/0x2a
  [<ffffffff81004c37>] ? do_IRQ+0x48/0xaf
  [<ffffffff812ffe13>] ? ret_from_intr+0x0/0x1a
  <EOI>  [<ffffffff8100a1aa>] ? native_sched_clock+0x2d/0x5f
  [<ffffffff811b40ac>] ? acpi_idle_enter_bm+0x23d/0x275
  [<ffffffff811b40a5>] ? acpi_idle_enter_bm+0x236/0x275
  [<ffffffff8126c2ae>] ? cpuidle_idle_call+0x9f/0xd5
  [<ffffffff81001e75>] ? cpu_idle+0x61/0xaa
  [<ffffffff812ecdc9>] ? rest_init+0xcd/0xd4
  [<ffffffff812eccfc>] ? rest_init+0x0/0xd4
  [<ffffffff81682d3d>] ? start_kernel+0x3a6/0x3b1
  [<ffffffff816822b1>] ? x86_64_start_reservations+0xb8/0xbc
  [<ffffffff816823bb>] ? x86_64_start_kernel+0x106/0x115

The cause is that local_bh_enable() could call do_softirq()
in certain time, thus break irq status and make lock bite
us.

Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..1654dc1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -972,7 +972,7 @@ int del_timer_sync(struct timer_list *timer)
 	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	local_bh_enable();
+	local_bh_enable_force_wake();
 #endif
 	/*
 	 * don't use it in hardirq context, because it
-- 
1.7.1

