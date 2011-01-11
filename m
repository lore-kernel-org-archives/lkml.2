Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1AKLFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:05:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35557 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1AKLFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:05:41 -0500
Date: Tue, 11 Jan 2011 12:05:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de
Subject: BUG: spinlock recursion (sys_chdir, user_path_at, do_path_lookup
 ...)
Message-ID: <20110111110539.GP24920@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

when testing yesterday's Linus' master branch
(a08948812b30653eb2c536ae613b635a989feb6f + some arch support including
Trond's latest nfsfix[1]) I hit the following reproducibly:

[    5.580000] BUG: spinlock recursion on CPU#0, init/1
[    5.580000]  lock: c7487e10, .magic: dead4ead, .owner: init/1, .owner_cpu: 0
[    5.590000] Backtrace: 
[    5.590000] [<c0037c2c>] (dump_backtrace+0x0/0x110) from [<c028240c>] (dump_stack+0x1c/0x20)
[    5.600000]  r7:c7487e10 r6:c0321368 r5:c7487e10 r4:c7848000
[    5.610000] [<c02823f0>] (dump_stack+0x0/0x20) from [<c01b516c>] (spin_bug+0x90/0xa4)
[    5.620000] [<c01b50dc>] (spin_bug+0x0/0xa4) from [<c01b52d4>] (do_raw_spin_lock+0x50/0x154)
[    5.620000]  r6:c7487e10 r5:c7487e10 r4:00000000
[    5.630000] [<c01b5284>] (do_raw_spin_lock+0x0/0x154) from [<c028524c>] (_raw_spin_lock_nested+0x40/0x48)
[    5.640000] [<c028520c>] (_raw_spin_lock_nested+0x0/0x48) from [<c00f436c>] (nameidata_dentry_drop_rcu+0x90/0x1a4)
[    5.650000]  r5:c7843efc r4:c7487dc0
[    5.650000] [<c00f42dc>] (nameidata_dentry_drop_rcu+0x0/0x1a4) from [<c00f44c0>] (d_revalidate+0x40/0x68)
[    5.660000] [<c00f4480>] (d_revalidate+0x0/0x68) from [<c00f6ed4>] (link_path_walk+0xb84/0xbf0)
[    5.670000]  r6:c7843efc r5:c7843efc r4:00000000
[    5.680000] [<c00f6350>] (link_path_walk+0x0/0xbf0) from [<c00f7164>] (do_path_lookup+0x48/0xd4)
[    5.680000] [<c00f711c>] (do_path_lookup+0x0/0xd4) from [<c00f7c08>] (user_path_at+0x64/0x9c)
[    5.690000] [<c00f7ba4>] (user_path_at+0x0/0x9c) from [<c00e9614>] (sys_chdir+0x2c/0x78)
[    5.700000]  r8:c0034108 r7:0000000c r6:be961ee4 r5:c7843f88 r4:00063015
[    5.710000] [<c00e95e8>] (sys_chdir+0x0/0x78) from [<c0033e80>] (ret_fast_syscall+0x0/0x44)
[    5.720000]  r5:be961ee4 r4:00063015
[   11.720000] BUG: spinlock lockup on CPU#0, init/1, c7487e10
[   11.730000] Backtrace: 
[   11.730000] [<c0037c2c>] (dump_backtrace+0x0/0x110) from [<c028240c>] (dump_stack+0x1c/0x20)
[   11.740000]  r7:c7842000 r6:c7487e10 r5:00000000 r4:00000000
[   11.740000] [<c02823f0>] (dump_stack+0x0/0x20) from [<c01b539c>] (do_raw_spin_lock+0x118/0x154)
[   11.750000] [<c01b5284>] (do_raw_spin_lock+0x0/0x154) from [<c028524c>] (_raw_spin_lock_nested+0x40/0x48)
[   11.760000] [<c028520c>] (_raw_spin_lock_nested+0x0/0x48) from [<c00f436c>] (nameidata_dentry_drop_rcu+0x90/0x1a4)
[   11.770000]  r5:c7843efc r4:c7487dc0
[   11.780000] [<c00f42dc>] (nameidata_dentry_drop_rcu+0x0/0x1a4) from [<c00f44c0>] (d_revalidate+0x40/0x68)
[   11.790000] [<c00f4480>] (d_revalidate+0x0/0x68) from [<c00f6ed4>] (link_path_walk+0xb84/0xbf0)
[   11.790000]  r6:c7843efc r5:c7843efc r4:00000000
[   11.800000] [<c00f6350>] (link_path_walk+0x0/0xbf0) from [<c00f7164>] (do_path_lookup+0x48/0xd4)
[   11.810000] [<c00f711c>] (do_path_lookup+0x0/0xd4) from [<c00f7c08>] (user_path_at+0x64/0x9c)
[   11.820000] [<c00f7ba4>] (user_path_at+0x0/0x9c) from [<c00e9614>] (sys_chdir+0x2c/0x78)
[   11.820000]  r8:c0034108 r7:0000000c r6:be961ee4 r5:c7843f88 r4:00063015
[   11.830000] [<c00e95e8>] (sys_chdir+0x0/0x78) from [<c0033e80>] (ret_fast_syscall+0x0/0x44)
[   11.840000]  r5:be961ee4 r4:00063015
[   75.280000] BUG: soft lockup - CPU#0 stuck for 64s! [init:1]
[   75.280000] Modules linked in:
[   75.280000] irq event stamp: 113662
[   75.280000] hardirqs last  enabled at (113662): [<c0285a7c>] _raw_spin_unlock_irqrestore+0x48/0x50
[   75.280000] hardirqs last disabled at (113661): [<c0285398>] _raw_spin_lock_irqsave+0x30/0x64
[   75.280000] softirqs last  enabled at (113509): [<c026447c>] rpc_wake_up_next+0x1b0/0x1c4
[   75.280000] softirqs last disabled at (113507): [<c02854f0>] _raw_spin_lock_bh+0x20/0x58
[   75.280000] 
[   75.280000] Pid: 1, comm:                 init
[   75.280000] CPU: 0    Not tainted  (2.6.37-04021-gb8b018c-dirty #41)
[   75.280000] PC is at do_raw_spin_lock+0xac/0x154
[   75.280000] LR is at do_raw_spin_lock+0xc0/0x154
[   75.280000] pc : [<c01b5330>]    lr : [<c01b5344>]    psr: 20000013
[   75.280000] sp : c7843dd0  ip : c7843cd4  fp : c7843e04
[   75.280000] r10: 06bd0000  r9 : 00000000  r8 : 00000000
[   75.280000] r7 : c7842000  r6 : c7487e10  r5 : 00000000  r4 : 03dd5aca
[   75.280000] r3 : 00000000  r2 : 00000001  r1 : c0285a74  r0 : 00000001
[   75.280000] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   75.280000] Control: 0005317f  Table: 479a8000  DAC: 00000015
[   75.280000] [<c00356c4>] (show_regs+0x0/0x54) from [<c0089dac>] (watchdog_timer_fn+0x13c/0x1a4)
[   75.280000]  r4:c7842000
[   75.280000] [<c0089c70>] (watchdog_timer_fn+0x0/0x1a4) from [<c006cb58>] (__run_hrtimer+0x114/0x1f0)
[   75.280000] [<c006ca44>] (__run_hrtimer+0x0/0x1f0) from [<c006ced8>] (hrtimer_interrupt+0x154/0x338)
[   75.280000] [<c006cd84>] (hrtimer_interrupt+0x0/0x338) from [<c003e36c>] (mxs_timer_interrupt+0x28/0x34)
[   75.280000] [<c003e344>] (mxs_timer_interrupt+0x0/0x34) from [<c008a408>] (handle_IRQ_event+0x7c/0x1a8)
[   75.280000] [<c008a38c>] (handle_IRQ_event+0x0/0x1a8) from [<c008c948>] (handle_level_irq+0xc8/0x148)
[   75.280000] [<c008c880>] (handle_level_irq+0x0/0x148) from [<c002d320>] (asm_do_IRQ+0x80/0xa4)
[   75.280000]  r7:c7842000 r6:c7487e10 r5:00000000 r4:00000030
[   75.280000] [<c002d2a0>] (asm_do_IRQ+0x0/0xa4) from [<c0033ab8>] (__irq_svc+0x38/0x80)
[   75.280000] Exception stack(0xc7843d88 to 0xc7843dd0)
[   75.280000] 3d80:                   00000001 c0285a74 00000001 00000000 03dd5aca 00000000
[   75.280000] 3da0: c7487e10 c7842000 00000000 00000000 06bd0000 c7843e04 c7843cd4 c7843dd0
[   75.280000] 3dc0: c01b5344 c01b5330 20000013 ffffffff
[   75.280000]  r5:f5000000 r4:ffffffff
[   75.280000] [<c01b5284>] (do_raw_spin_lock+0x0/0x154) from [<c028524c>] (_raw_spin_lock_nested+0x40/0x48)
[   75.280000] [<c028520c>] (_raw_spin_lock_nested+0x0/0x48) from [<c00f436c>] (nameidata_dentry_drop_rcu+0x90/0x1a4)
[   75.280000]  r5:c7843efc r4:c7487dc0
[   75.280000] [<c00f42dc>] (nameidata_dentry_drop_rcu+0x0/0x1a4) from [<c00f44c0>] (d_revalidate+0x40/0x68)
[   75.280000] [<c00f4480>] (d_revalidate+0x0/0x68) from [<c00f6ed4>] (link_path_walk+0xb84/0xbf0)
[   75.280000]  r6:c7843efc r5:c7843efc r4:00000000
[   75.280000] [<c00f6350>] (link_path_walk+0x0/0xbf0) from [<c00f7164>] (do_path_lookup+0x48/0xd4)
[   75.280000] [<c00f711c>] (do_path_lookup+0x0/0xd4) from [<c00f7c08>] (user_path_at+0x64/0x9c)
[   75.280000] [<c00f7ba4>] (user_path_at+0x0/0x9c) from [<c00e9614>] (sys_chdir+0x2c/0x78)
[   75.280000]  r8:c0034108 r7:0000000c r6:be961ee4 r5:c7843f88 r4:00063015
[   75.280000] [<c00e95e8>] (sys_chdir+0x0/0x78) from [<c0033e80>] (ret_fast_syscall+0x0/0x44)
[   75.280000]  r5:be961ee4 r4:00063015

I started to bisect, but already the first test case showed a different
error (my getty dying every few seconds).

Does this ring a bell for someone?

If you have questions don't hesitate to ask.

Hardware: mxs-based arm9

Best regards
Uwe

[1] http://mid.gmane.org/1294528551.4181.19.camel@heimdal.trondhjem.org

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
