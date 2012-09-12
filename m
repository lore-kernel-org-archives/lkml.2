Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951Ab2ILR4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:56:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43020 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2ILR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:56:23 -0400
Message-ID: <5050CCE0.4090403@gmail.com>
Date: Wed, 12 Sep 2012 19:56:48 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RCU idle CPU detection is broken in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
"RCU used illegally from idle CPU!" warnings several times.

There are a bunch of traces which seem to pop exactly at the same time and from
different places around the kernel. Here are several of them:

(1):

[   29.006532] ===============================
[   29.007033] [ INFO: suspicious RCU usage. ]
[   29.007033] 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331 Tainted:
G        W
[   29.007033] -------------------------------
[   29.007033] include/linux/rcupdate.h:737 rcu_read_lock() used illegally while
idle!
[   29.007033]
[   29.007033] other info that might help us debug this:
[   29.007033]
[   29.007033]
[   29.007033] RCU used illegally from idle CPU!
[   29.007033] rcu_scheduler_active = 1, debug_locks = 1
[   29.007033] RCU used illegally from extended quiescent state!
[   29.007033] 2 locks held by rcu_preempt/11:
[   29.007033]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff83742f50>]
__schedule+0x180/0x8f0
[   29.007033]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8114ff1e>]
cpuacct_charge+0xe/0x200
[   29.007033]
[   29.007033] stack backtrace:
[   29.007033] Pid: 11, comm: rcu_preempt Tainted: G        W
3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331
[   29.007033] Call Trace:
[   29.007033]  [<ffffffff8117eaeb>] lockdep_rcu_suspicious+0x10b/0x120
[   29.007033]  [<ffffffff8114ffa0>] cpuacct_charge+0x90/0x200
[   29.007033]  [<ffffffff8114ff1e>] ? cpuacct_charge+0xe/0x200
[   29.007033]  [<ffffffff811548a3>] update_curr+0x1a3/0x270
[   29.007033]  [<ffffffff8115527a>] dequeue_entity+0x2a/0x210
[   29.007033]  [<ffffffff811556b5>] dequeue_task_fair+0x45/0x130
[   29.007033]  [<ffffffff81148149>] dequeue_task+0x89/0xa0
[   29.007033]  [<ffffffff81148ebe>] deactivate_task+0x1e/0x20
[   29.007033]  [<ffffffff83743649>] __schedule+0x879/0x8f0
[   29.007033]  [<ffffffff8117a60d>] ? trace_hardirqs_on+0xd/0x10
[   29.007033]  [<ffffffff83743715>] schedule+0x55/0x60
[   29.007033]  [<ffffffff811c672d>] rcu_gp_kthread+0xdd/0xed0
[   29.007033]  [<ffffffff83744ebb>] ? _raw_spin_unlock_irq+0x2b/0x80
[   29.007033]  [<ffffffff81137210>] ? abort_exclusive_wait+0xb0/0xb0
[   29.007033]  [<ffffffff811c6650>] ? rcu_gp_fqs+0x80/0x80
[   29.007033]  [<ffffffff81135e43>] kthread+0xe3/0xf0
[   29.007033]  [<ffffffff83747a84>] kernel_thread_helper+0x4/0x10
[   29.007033]  [<ffffffff83745df4>] ? retint_restore_args+0x13/0x13
[   29.007033]  [<ffffffff81135d60>] ? insert_kthread_work+0x90/0x90
[   29.007033]  [<ffffffff83747a80>] ? gs_change+0x13/0x13

(2):

[   28.876466] ===============================
[   28.876466] [ INFO: suspicious RCU usage. ]
[   28.876466] 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331 Tainted:
G        W
[   28.876466] -------------------------------
[   28.876466] include/linux/rcupdate.h:758 rcu_read_unlock() used illegally
while idle!
[   28.876466]
[   28.876466] other info that might help us debug this:
[   28.876466]
[   28.876466]
[   28.876466] RCU used illegally from idle CPU!
[   28.876466] rcu_scheduler_active = 1, debug_locks = 1
[   28.876466] RCU used illegally from extended quiescent state!
[   28.876466] 2 locks held by trinity-child58/5966:
[   28.876466]  #0:  (&(&sighand->siglock)->rlock){-.-...}, at:
[<ffffffff8111f548>] force_sig_info+0x38/0x100
[   28.876466]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8111d410>]
__sigqueue_alloc+0x0/0x230
[   28.876466]
[   28.876466] stack backtrace:
[   28.876466] Pid: 5966, comm: trinity-child58 Tainted: G        W
3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331
[   28.876466] Call Trace:
[   28.876466]  [<ffffffff8117eaeb>] lockdep_rcu_suspicious+0x10b/0x120
[   28.876466]  [<ffffffff8111d558>] __sigqueue_alloc+0x148/0x230
[   28.876466]  [<ffffffff8111d410>] ? check_kill_permission+0x220/0x220
[   28.876466]  [<ffffffff8111e91a>] __send_signal+0x51a/0x580
[   28.876466]  [<ffffffff8111f500>] ? do_signal_stop+0x2c0/0x2d0
[   28.876466]  [<ffffffff8111e9c0>] send_signal+0x40/0x80
[   28.876466]  [<ffffffff8111f548>] ? force_sig_info+0x38/0x100
[   28.876466]  [<ffffffff811c38ad>] ? rcu_user_enter+0xed/0x110
[   28.876466]  [<ffffffff8111f5d3>] force_sig_info+0xc3/0x100
[   28.876466]  [<ffffffff811203a1>] force_sig+0x11/0x20
[   28.876466]  [<ffffffff8106da1d>] do_general_protection+0xfd/0x170
[   28.876466]  [<ffffffff83746075>] general_protection+0x25/0x30

(3):

[   28.876466] ===============================
[   28.876466] [ INFO: suspicious RCU usage. ]
[   28.876466] 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331 Tainted:
G        W
[   28.876466] -------------------------------
[   28.876466] kernel/signal.c:366 suspicious rcu_dereference_check() usage!
[   28.876466]
[   28.876466] other info that might help us debug this:
[   28.876466]
[   28.876466]
[   28.876466] RCU used illegally from idle CPU!
[   28.876466] rcu_scheduler_active = 1, debug_locks = 1
[   28.876466] RCU used illegally from extended quiescent state!
[   28.876466] 2 locks held by trinity-child58/5966:
[   28.876466]  #0:  (&(&sighand->siglock)->rlock){-.-...}, at:
[<ffffffff8111f548>] force_sig_info+0x38/0x100
[   28.876466]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8111d410>]
__sigqueue_alloc+0x0/0x230
[   28.876466]
[   28.876466] stack backtrace:
[   28.876466] Pid: 5966, comm: trinity-child58 Tainted: G        W
3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331
[   28.876466] Call Trace:
[   28.876466]  [<ffffffff8117eaeb>] lockdep_rcu_suspicious+0x10b/0x120
[   28.876466]  [<ffffffff8111d50f>] __sigqueue_alloc+0xff/0x230
[   28.876466]  [<ffffffff8111d410>] ? check_kill_permission+0x220/0x220
[   28.876466]  [<ffffffff8111e91a>] __send_signal+0x51a/0x580
[   28.876466]  [<ffffffff8111f500>] ? do_signal_stop+0x2c0/0x2d0
[   28.876466]  [<ffffffff8111e9c0>] send_signal+0x40/0x80
[   28.876466]  [<ffffffff8111f548>] ? force_sig_info+0x38/0x100
[   28.876466]  [<ffffffff811c38ad>] ? rcu_user_enter+0xed/0x110
[   28.876466]  [<ffffffff8111f5d3>] force_sig_info+0xc3/0x100
[   28.876466]  [<ffffffff811203a1>] force_sig+0x11/0x20
[   28.876466]  [<ffffffff8106da1d>] do_general_protection+0xfd/0x170
[   28.876466]  [<ffffffff83746075>] general_protection+0x25/0x30
