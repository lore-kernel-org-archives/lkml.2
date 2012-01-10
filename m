Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2AJBDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:03:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab2AJBDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:03:37 -0500
Date: Mon, 9 Jan 2012 20:03:32 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: chris.mason@oracle.com
Subject: btrfs/mmap lockdep report from 3.2
Message-ID: <20120110010331.GA15942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, chris.mason@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this with Linus' tree as of 37cfc3f67db9f2d907f6bfcfae590cdbbef623e8

	Dave

[  130.932837] ======================================================
[  130.933032] [ INFO: possible circular locking dependency detected ]
[  130.933032] 3.2.0+ #19 Not tainted
[  130.933032] -------------------------------------------------------
[  130.933032] firefox/1630 is trying to acquire lock:
[  130.933032]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffffa011fd5b>] btrfs_page_mkwrite+0x5b/0x310 [btrfs]
[  130.933032] 
[  130.933032] but task is already holding lock:
[  130.933032]  (&mm->mmap_sem){++++++}, at: [<ffffffff816a38c8>] do_page_fault+0xe8/0x5d0
[  130.933032] 
[  130.933032] which lock already depends on the new lock.
[  130.933032] 
[  130.933032] 
[  130.933032] the existing dependency chain (in reverse order) is:
[  130.933032] 
[  130.933032] -> #1 (&mm->mmap_sem){++++++}:
[  130.933032]        [<ffffffff810c60bd>] lock_acquire+0x9d/0x220
[  130.933032]        [<ffffffff81173cd0>] might_fault+0x80/0xb0
[  130.933032]        [<ffffffff811ce057>] filldir+0x77/0xe0
[  130.933032]        [<ffffffffa01163ff>] btrfs_real_readdir+0xbf/0x740 [btrfs]
[  130.933032]        [<ffffffff811ce328>] vfs_readdir+0xb8/0xf0
[  130.933032]        [<ffffffff811ce459>] sys_getdents+0x89/0x100
[  130.933032]        [<ffffffff816a7f69>] system_call_fastpath+0x16/0x1b
[  130.933032] 
[  130.933032] -> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
[  130.933032]        [<ffffffff810c5988>] __lock_acquire+0x1bf8/0x1c20
[  130.933032]        [<ffffffff810c60bd>] lock_acquire+0x9d/0x220
[  130.933032]        [<ffffffff8169cb5e>] __mutex_lock_common+0x5e/0x500
[  130.933032]        [<ffffffff8169d134>] mutex_lock_nested+0x44/0x50
[  130.933032]        [<ffffffffa011fd5b>] btrfs_page_mkwrite+0x5b/0x310 [btrfs]
[  130.933032]        [<ffffffff81175806>] do_wp_page+0x586/0x720
[  130.933032]        [<ffffffff8117705d>] handle_pte_fault+0x27d/0xa10
[  130.933032]        [<ffffffff81177b98>] handle_mm_fault+0x1e8/0x2f0
[  130.933032]        [<ffffffff816a3949>] do_page_fault+0x169/0x5d0
[  130.933032]        [<ffffffff816a0ae5>] page_fault+0x25/0x30
[  130.933032] 
[  130.933032] other info that might help us debug this:
[  130.933032] 
[  130.933032]  Possible unsafe locking scenario:
[  130.933032] 
[  130.933032]        CPU0                    CPU1
[  130.933032]        ----                    ----
[  130.933032]   lock(&mm->mmap_sem);
[  130.933032]                                lock(&sb->s_type->i_mutex_key#13);
[  130.933032]                                lock(&mm->mmap_sem);
[  130.933032]   lock(&sb->s_type->i_mutex_key#13);
[  130.933032] 
[  130.933032]  *** DEADLOCK ***
[  130.933032] 
[  130.933032] 1 lock held by firefox/1630:
[  130.933032]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff816a38c8>] do_page_fault+0xe8/0x5d0
[  130.933032] 
[  130.933032] stack backtrace:
[  130.933032] Pid: 1630, comm: firefox Not tainted 3.2.0+ #19
[  130.933032] Call Trace:
[  130.933032]  [<ffffffff816932f2>] print_circular_bug+0x1fb/0x20c
[  130.933032]  [<ffffffff810c5988>] __lock_acquire+0x1bf8/0x1c20
[  130.933032]  [<ffffffff810c60bd>] lock_acquire+0x9d/0x220
[  130.933032]  [<ffffffffa011fd5b>] ? btrfs_page_mkwrite+0x5b/0x310 [btrfs]
[  130.933032]  [<ffffffff810221b9>] ? sched_clock+0x9/0x10
[  130.933032]  [<ffffffff810a4905>] ? sched_clock_local+0x25/0x90
[  130.933032]  [<ffffffff8169cb5e>] __mutex_lock_common+0x5e/0x500
[  130.933032]  [<ffffffffa011fd5b>] ? btrfs_page_mkwrite+0x5b/0x310 [btrfs]
[  130.933032]  [<ffffffff810221b9>] ? sched_clock+0x9/0x10
[  130.933032]  [<ffffffffa011fd5b>] ? btrfs_page_mkwrite+0x5b/0x310 [btrfs]
[  130.933032]  [<ffffffff8169d134>] mutex_lock_nested+0x44/0x50
[  130.933032]  [<ffffffffa011fd5b>] btrfs_page_mkwrite+0x5b/0x310 [btrfs]
[  130.933032]  [<ffffffff81175806>] do_wp_page+0x586/0x720
[  130.933032]  [<ffffffff8117705d>] handle_pte_fault+0x27d/0xa10
[  130.933032]  [<ffffffff810c066e>] ? put_lock_stats+0xe/0x40
[  130.933032]  [<ffffffff810c0fd7>] ? lock_release_holdtime.part.10+0xd7/0x150
[  130.933032]  [<ffffffff816a40bd>] ? sub_preempt_count+0x9d/0xd0
[  130.933032]  [<ffffffff81177b98>] handle_mm_fault+0x1e8/0x2f0
[  130.933032]  [<ffffffff816a3949>] do_page_fault+0x169/0x5d0
[  130.933032]  [<ffffffff813271ad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  130.933032]  [<ffffffff816a0ae5>] page_fault+0x25/0x30

