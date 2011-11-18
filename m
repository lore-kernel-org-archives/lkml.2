Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1KRMbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:31:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52036 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab1KRMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:31:42 -0500
Subject: [BUG] Recursive locking in sound/core
From: Sasha Levin <levinsasha928@gmail.com>
To: perex@perex.cz, tiwai@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 18 Nov 2011 14:31:37 +0200
Message-ID: <1321619497.8010.46.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got the following error on a 3.2-rc2 kernel when (what looks like)
a device handle was closed:

[ 3077.131020] =============================================
[ 3077.131020] [ INFO: possible recursive locking detected ]
[ 3077.131020] 3.2.0-rc2-sasha-00059-g2723aa2 #8
[ 3077.131020] ---------------------------------------------
[ 3077.131020] trinity/4841 is trying to acquire lock:
[ 3077.131020]  (&grp->list_mutex){++++.+}, at: [<ffffffff818f7e0b>] snd_seq_deliver_event+0x9a/0x19c
[ 3077.131020] 
[ 3077.131020] but task is already holding lock:
[ 3077.131020]  (&grp->list_mutex){++++.+}, at: [<ffffffff818fc352>] snd_seq_port_disconnect+0x38/0x162
[ 3077.131020] 
[ 3077.131020] other info that might help us debug this:
[ 3077.131020]  Possible unsafe locking scenario:
[ 3077.131020] 
[ 3077.131020]        CPU0
[ 3077.131020]        ----
[ 3077.131020]   lock(&grp->list_mutex);
[ 3077.131020]   lock(&grp->list_mutex);
[ 3077.131020] 
[ 3077.131020]  *** DEADLOCK ***
[ 3077.131020] 
[ 3077.131020]  May be due to missing lock nesting notation
[ 3077.131020] 
[ 3077.131020] 3 locks held by trinity/4841:
[ 3077.131020]  #0:  (register_mutex#4){+.+.+.}, at: [<ffffffff818fd723>] odev_release+0x2b/0x45
[ 3077.131020]  #1:  (&grp->list_mutex){++++.+}, at: [<ffffffff818fc352>] snd_seq_port_disconnect+0x38/0x162
[ 3077.131020]  #2:  (&grp->list_mutex/1){+.+...}, at: [<ffffffff818fc36a>] snd_seq_port_disconnect+0x50/0x162
[ 3077.131020] 
[ 3077.131020] stack backtrace:
[ 3077.131020] Pid: 4841, comm: trinity Tainted: G        W    3.2.0-rc2-sasha-00059-g2723aa2 #8
[ 3077.131020] Call Trace:
[ 3077.131020]  [<ffffffff810b3c84>] __lock_acquire+0xdc8/0xe50
[ 3077.131020]  [<ffffffff810a4835>] ? sched_clock_local+0x12/0x75
[ 3077.131020]  [<ffffffff810a4a04>] ? sched_clock_cpu+0xc4/0xd2
[ 3077.131020]  [<ffffffff818fb8b9>] ? snd_seq_port_use_ptr+0x61/0x8d
[ 3077.131020]  [<ffffffff810b41b5>] lock_acquire+0x8a/0xa7
[ 3077.131020]  [<ffffffff818f7e0b>] ? snd_seq_deliver_event+0x9a/0x19c
[ 3077.131020]  [<ffffffff810b2b9a>] ? lock_is_held+0x92/0x9d
[ 3077.131020]  [<ffffffff81bbbc3f>] down_read+0x47/0x7a
[ 3077.131020]  [<ffffffff818f7e0b>] ? snd_seq_deliver_event+0x9a/0x19c
[ 3077.131020]  [<ffffffff818f7e0b>] snd_seq_deliver_event+0x9a/0x19c
[ 3077.131020]  [<ffffffff8107ecbc>] ? get_parent_ip+0x11/0x41
[ 3077.131020]  [<ffffffff818f89a9>] snd_seq_kernel_client_dispatch+0x61/0x7d
[ 3077.131020]  [<ffffffff8190180a>] dummy_unuse+0x69/0xa7
[ 3077.131020]  [<ffffffff81bbcee4>] ? _raw_write_unlock_irqrestore+0x40/0x75
[ 3077.131020]  [<ffffffff818fb776>] unsubscribe_port.clone.4+0x56/0x8b
[ 3077.131020]  [<ffffffff818fc42a>] snd_seq_port_disconnect+0x110/0x162
[ 3077.131020]  [<ffffffff818f8506>] snd_seq_ioctl_unsubscribe_port+0x101/0x18a
[ 3077.131020]  [<ffffffff81bbc754>] ? _raw_spin_unlock_irqrestore+0x40/0x75
[ 3077.131020]  [<ffffffff818f5a8d>] snd_seq_do_ioctl+0x6d/0x85
[ 3077.131020]  [<ffffffff81bbc77b>] ? _raw_spin_unlock_irqrestore+0x67/0x75
[ 3077.131020]  [<ffffffff818f8a0b>] snd_seq_kernel_client_ctl+0x46/0x5d
[ 3077.131020]  [<ffffffff81900964>] snd_seq_oss_midi_close+0x7d/0xe2
[ 3077.131020]  [<ffffffff818ffd81>] snd_seq_oss_synth_reset+0x9d/0x17c
[ 3077.131020]  [<ffffffff818fddff>] snd_seq_oss_reset+0x1d/0x75
[ 3077.131020]  [<ffffffff818fde7b>] snd_seq_oss_release+0x24/0x58
[ 3077.131020]  [<ffffffff818fd72b>] odev_release+0x33/0x45
[ 3077.131020]  [<ffffffff811416e3>] fput+0x11e/0x1dc
[ 3077.131020]  [<ffffffff8113f1ec>] filp_close+0x6e/0x79
[ 3077.131020]  [<ffffffff81089ed7>] put_files_struct+0xcc/0x196
[ 3077.131020]  [<ffffffff8108a034>] exit_files+0x46/0x4f
[ 3077.131020]  [<ffffffff8108a716>] do_exit+0x264/0x75c
[ 3077.131020]  [<ffffffff8104c9db>] ? smp_apic_timer_interrupt+0x76/0x84
[ 3077.131020]  [<ffffffff81bbd338>] ? retint_restore_args+0x13/0x13
[ 3077.131020]  [<ffffffff8108acc1>] do_group_exit+0x83/0xb1
[ 3077.131020]  [<ffffffff8108ad01>] sys_exit_group+0x12/0x16
[ 3077.131020]  [<ffffffff81bbdbd2>] system_call_fastpath+0x16/0x1b

I'm not really sure if the proper solution is to change the down_write()
in seq_ports.c:566 to down_write_nested() like the next line, so I
figured it's better to ask first :)

Thanks!

-- 

Sasha.

