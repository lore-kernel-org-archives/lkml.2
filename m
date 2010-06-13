Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0FMJxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 05:53:17 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:45282 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753247Ab0FMJxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 05:53:15 -0400
Date: Sun, 13 Jun 2010 11:53:05 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org
Subject: inconsistent IN-HARDIRQ-W -> HARDIRQ-ON-W usage: fasync, 2.6.35-rc3
Message-ID: <20100613095305.GA13231@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

A pristine -rc3 kernel resulted in this warning:

[ 3525.895950] 
[ 3525.895954] =================================
[ 3525.895959] [ INFO: inconsistent lock state ]
[ 3525.895963] 2.6.35-rc3 #235
[ 3525.895965] ---------------------------------
[ 3525.895968] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[ 3525.895972] gnome-session/5565 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 3525.895975]  (&(&new->fa_lock)->rlock){?.-...}, at: [<ffffffff81118486>] kill_fasync+0x76/0x110
[ 3525.895989] {IN-HARDIRQ-W} state was registered at:
[ 3525.895992]   [<ffffffff810a472c>] __lock_acquire+0xe1c/0x1e80
[ 3525.895998]   [<ffffffff810a583c>] lock_acquire+0xac/0xe0
[ 3525.896002]   [<ffffffff81641e5b>] _raw_spin_lock+0x3b/0x70
[ 3525.896009]   [<ffffffff81118486>] kill_fasync+0x76/0x110
[ 3525.896013]   [<ffffffffa001826d>] evdev_pass_event+0x8d/0xa0 [evdev]
[ 3525.896026]   [<ffffffffa0018667>] evdev_event+0x87/0x158 [evdev]
[ 3525.896031]   [<ffffffff814660b8>] input_pass_event+0x68/0x150
[ 3525.896037]   [<ffffffff814672e2>] input_handle_event+0x92/0x410
[ 3525.896041]   [<ffffffff814677e7>] input_event+0x67/0x90
[ 3525.896045]   [<ffffffff8146f67f>] synaptics_process_byte+0x64f/0x8a0
[ 3525.896050]   [<ffffffff8146d292>] psmouse_handle_byte+0x12/0x120
[ 3525.896055]   [<ffffffff8146e264>] psmouse_interrupt+0xd4/0x330
[ 3525.896059]   [<ffffffff814611cd>] serio_interrupt+0x4d/0xa0
[ 3525.896065]   [<ffffffff814626ad>] i8042_interrupt+0x12d/0x3a0
[ 3525.896070]   [<ffffffff810b86ea>] handle_IRQ_event+0x3a/0xe0
[ 3525.896075]   [<ffffffff810bac7e>] handle_edge_irq+0xbe/0x170
[ 3525.896080]   [<ffffffff8102ec0d>] handle_irq+0x1d/0x30
[ 3525.896085]   [<ffffffff8102e0ee>] do_IRQ+0x6e/0xf0
[ 3525.896089]   [<ffffffff81642e93>] ret_from_intr+0x0/0x16
[ 3525.896094]   [<ffffffff814b17a3>] cpuidle_idle_call+0x93/0xf0
[ 3525.896099]   [<ffffffff8102ac3d>] cpu_idle+0xad/0x110
[ 3525.896105]   [<ffffffff8163ad51>] start_secondary+0x285/0x2cd
[ 3525.896111] irq event stamp: 287809
[ 3525.896113] hardirqs last  enabled at (287809): [<ffffffff81642b75>] _raw_spin_unlock_irqrestore+0x65/0x80
[ 3525.896118] hardirqs last disabled at (287808): [<ffffffff81641fed>] _raw_spin_lock_irqsave+0x2d/0xa0
[ 3525.896124] softirqs last  enabled at (287428): [<ffffffff8107a499>] __do_softirq+0x129/0x170
[ 3525.896130] softirqs last disabled at (287411): [<ffffffff8102c99c>] call_softirq+0x1c/0x30
[ 3525.896135] 
[ 3525.896135] other info that might help us debug this:
[ 3525.896139] 3 locks held by gnome-session/5565:
[ 3525.896141]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8151c550>] sock_def_readable+0x0/0xe0
[ 3525.896150]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81519b86>] sock_wake_async+0x26/0x1c0
[ 3525.896159]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff8111842f>] kill_fasync+0x1f/0x110
[ 3525.896166] 
[ 3525.896167] stack backtrace:
[ 3525.896171] Pid: 5565, comm: gnome-session Not tainted 2.6.35-rc3 #235
[ 3525.896174] Call Trace:
[ 3525.896179]  [<ffffffff810a09c8>] print_usage_bug+0x198/0x1e0
[ 3525.896185]  [<ffffffff810395aa>] ? save_stack_trace+0x2a/0x50
[ 3525.896189]  [<ffffffff810a1ae0>] ? check_usage_backwards+0x0/0x110
[ 3525.896193]  [<ffffffff810a0e48>] mark_lock+0x438/0x690
[ 3525.896197]  [<ffffffff810a456c>] __lock_acquire+0xc5c/0x1e80
[ 3525.896202]  [<ffffffff810a583c>] lock_acquire+0xac/0xe0
[ 3525.896206]  [<ffffffff81118486>] ? kill_fasync+0x76/0x110
[ 3525.896210]  [<ffffffff81641e5b>] _raw_spin_lock+0x3b/0x70
[ 3525.896214]  [<ffffffff81118486>] ? kill_fasync+0x76/0x110
[ 3525.896218]  [<ffffffff81118486>] kill_fasync+0x76/0x110
[ 3525.896222]  [<ffffffff8111842f>] ? kill_fasync+0x1f/0x110
[ 3525.896227]  [<ffffffff81519c86>] sock_wake_async+0x126/0x1c0
[ 3525.896231]  [<ffffffff81519b86>] ? sock_wake_async+0x26/0x1c0
[ 3525.896235]  [<ffffffff8151c616>] sock_def_readable+0xc6/0xe0
[ 3525.896239]  [<ffffffff8151c550>] ? sock_def_readable+0x0/0xe0
[ 3525.896243]  [<ffffffff81642bc0>] ? _raw_spin_unlock+0x30/0x60
[ 3525.896249]  [<ffffffff815d0edf>] unix_stream_sendmsg+0x23f/0x3b0
[ 3525.896254]  [<ffffffff81516a56>] sock_aio_write+0x126/0x140
[ 3525.896259]  [<ffffffff81094580>] ? sched_clock_cpu+0xc0/0x110
[ 3525.896265]  [<ffffffff81109772>] do_sync_write+0xd2/0x110
[ 3525.896270]  [<ffffffff8109fa7e>] ? put_lock_stats+0xe/0x30
[ 3525.896275]  [<ffffffff810681e1>] ? get_parent_ip+0x11/0x50
[ 3525.896280]  [<ffffffff8110a286>] vfs_write+0x166/0x180
[ 3525.896284]  [<ffffffff8110abd1>] ? fget_light+0x61/0x130
[ 3525.896288]  [<ffffffff8110a37c>] sys_write+0x4c/0x80
[ 3525.896292]  [<ffffffff8102ba82>] system_call_fastpath+0x16/0x1b

Best,
	Dominik
