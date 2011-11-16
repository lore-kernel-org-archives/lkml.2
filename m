Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1KPJmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:42:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42906 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1KPJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:42:29 -0500
Date: Wed, 16 Nov 2011 17:42:19 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH -rt] printk: Don't emit console_cpu_notify() for CPU_DYING
Message-ID: <20111116094219.GA9281@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we will get below warning:

BUG: sleeping function called from invalid context at /build/linux/kernel/rtmutex.c:645
in_atomic(): 1, irqs_disabled(): 1, pid: 1054, name: migration/9
no locks held by migration/9/1054.
irq event stamp: 36
hardirqs last  enabled at (35): [<ffffffff815f5b50>] _raw_spin_unlock_irq+0x30/0x70
hardirqs last disabled at (36): [<ffffffff810b7eaf>] stop_machine_cpu_stop+0x8f/0x110
softirqs last  enabled at (0): [<ffffffff81051b53>] copy_process+0x6d3/0x1640
softirqs last disabled at (0): [<          (null)>]           (null)
Pid: 1054, comm: migration/9 Not tainted 3.2.0-rc1-rt2-11312-gbf51260-dirty #12
Call Trace:
 [<ffffffff81040c4e>] __might_sleep+0x12e/0x1e0
 [<ffffffff815f4d24>] rt_spin_lock+0x24/0x60
 [<ffffffff810c4aa2>] ? touch_nmi_watchdog+0x42/0x80
 [<ffffffff813f58f3>] serial8250_console_write+0x143/0x150
 [<ffffffff81054323>] __call_console_drivers+0x93/0xb0
 [<ffffffff8105438c>] _call_console_drivers+0x4c/0x80
 [<ffffffff8105448d>] console_unlock+0xcd/0x240
 [<ffffffff815ef5ac>] console_cpu_notify+0x26/0x2d
 [<ffffffff81083744>] notifier_call_chain+0x84/0xf0
 [<ffffffff810837be>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff81055ac0>] __cpu_notify+0x20/0x40
 [<ffffffff815de3e2>] take_cpu_down+0x32/0x40
 [<ffffffff810b7eca>] stop_machine_cpu_stop+0xaa/0x110
 [<ffffffff810b7e20>] ? stop_one_cpu+0x80/0x80
 [<ffffffff810b7e20>] ? stop_one_cpu+0x80/0x80
 [<ffffffff810b79be>] cpu_stopper_thread+0xce/0x1b0
 [<ffffffff810b78f0>] ? wait_for_stop_done+0xa0/0xa0
 [<ffffffff810b78f0>] ? wait_for_stop_done+0xa0/0xa0
 [<ffffffff810430c9>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff810b78f0>] ? wait_for_stop_done+0xa0/0xa0
 [<ffffffff810b78f0>] ? wait_for_stop_done+0xa0/0xa0
 [<ffffffff8107c096>] kthread+0xa6/0xb0
 [<ffffffff810430c9>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff815f5b5b>] ? _raw_spin_unlock_irq+0x3b/0x70
 [<ffffffff815f8534>] kernel_thread_helper+0x4/0x10
 [<ffffffff810423bc>] ? finish_task_switch+0x8c/0x110
 [<ffffffff815f5b5b>] ? _raw_spin_unlock_irq+0x3b/0x70
 [<ffffffff815f5f21>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107bff0>] ? kthreadd+0x160/0x160
 [<ffffffff815f8530>] ? gs_change+0xb/0xb
CPU 9 is now offline

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/printk.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 535bc3b..ba0393e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1223,7 +1223,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();
-- 
1.7.5.4

