Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2CSVEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:04:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2CSVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:04:31 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 19 Mar 2012 23:04:10 +0200
Message-ID: <CA+1xoqf=VBjA6LCktFZCPU5wb63Yd+Eof2TYEv7dgor=PTLzpg@mail.gmail.com>
Subject: sched: BUG: spinlock recursion on CPU#4
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I got the following after some fuzzing with trinity inside a KVM tools guest:

[  599.355078] BUG: spinlock recursion on CPU#4, trinity/3143
[  599.356017]  lock: ffff88003ddd45c0, .magic: dead4ead, .owner:
trinity/3143, .owner_cpu: -1
[  599.356017] Pid: 3143, comm: trinity Not tainted
3.3.0-rc7-next-20120319-sasha-00003-g71e0de6 #60
[  599.356017] Call Trace:
[  599.356017]  [<ffffffff81898a28>] spin_dump+0x78/0xc0
[  599.356017]  [<ffffffff81898a9b>] spin_bug+0x2b/0x40
[  599.356017]  [<ffffffff81898ca7>] do_raw_spin_lock+0x117/0x140
[  599.356017]  [<ffffffff8270b01b>] _raw_spin_lock+0x5b/0x70
[  599.356017]  [<ffffffff810e5c23>] ? ttwu_queue+0xc3/0xf0
[  599.356017]  [<ffffffff810e5c23>] ttwu_queue+0xc3/0xf0
[  599.356017]  [<ffffffff810e6214>] ? try_to_wake_up+0x34/0x250
[  599.356017]  [<ffffffff810e6367>] try_to_wake_up+0x187/0x250
[  599.356017]  [<ffffffff810e65b0>] wake_up_process+0x10/0x20
[  599.356017]  [<ffffffff82708942>] __mutex_unlock_slowpath+0xe2/0x200
[  599.356017]  [<ffffffff82708a69>] mutex_unlock+0x9/0x10
[  599.356017]  [<ffffffff811f1078>] do_lookup+0x2d8/0x3b0
[  599.356017]  [<ffffffff817ca2f7>] ? security_inode_permission+0x17/0x20
[  599.356017]  [<ffffffff811f1758>] link_path_walk+0x138/0x910
[  599.356017]  [<ffffffff811f0958>] ? path_init+0x478/0x5d0
[  599.356017]  [<ffffffff81898ae8>] ? __raw_spin_lock_init+0x38/0x70
[  599.356017]  [<ffffffff811f378a>] path_openat+0xba/0x500
[  599.356017]  [<ffffffff810ec448>] ? sched_clock_cpu+0xc8/0x140
[  599.356017]  [<ffffffff8111264e>] ? put_lock_stats.clone.19+0xe/0x40
[  599.356017]  [<ffffffff811f3c14>] do_filp_open+0x44/0xa0
[  599.356017]  [<ffffffff810e7b41>] ? get_parent_ip+0x11/0x50
[  599.356017]  [<ffffffff8270b230>] ? _raw_spin_unlock+0x30/0x60
[  599.356017]  [<ffffffff812037f6>] ? alloc_fd+0x176/0x240
[  599.356017]  [<ffffffff811e2a3d>] do_sys_open+0xfd/0x1d0
[  599.356017]  [<ffffffff811e2b2c>] sys_open+0x1c/0x20
[  599.356017]  [<ffffffff8270c97d>] system_call_fastpath+0x1a/0x1f

I don't think that the actual problem is with the ttwu code, but with
the spinlocks themselves - why is the owning task set but not the
owning cpu?

btw,
Would it make sense to replace what's going on it spin_dump() with an
actual BUG()?
