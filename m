Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab2FHOgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:36:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48548 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab2FHOgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:36:18 -0400
Date: Fri, 08 Jun 2012 10:36:13 -0400
Message-Id: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>
Subject: writeback: bad unlock balance detected in 3.5-rc1
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I can reproduce this fairly easily by using ext4 w/o a journal, running
under KVM with 1024megs memory, with fsstress (xfstests #13):

013	[   45.152457] 
[   45.153294] =====================================
[   45.154784] [ BUG: bad unlock balance detected! ]
[   45.155591] 3.5.0-rc1-00002-gb22b1f1 #124 Not tainted
[   45.155591] -------------------------------------
[   45.155591] flush-254:16/2499 is trying to release lock (&(&wb->list_lock)->rlock) at:
[   45.155591] [<c022c3da>] writeback_sb_inodes+0x160/0x327
[   45.155591] but there are no more locks to release!
[   45.155591] 
[   45.155591] other info that might help us debug this:
[   45.155591] 1 lock held by flush-254:16/2499:
[   45.155591]  #0:  (&sb->s_type->i_lock_key#13){+.+...}, at: [<c022c33d>] writeback_sb_inodes+0xc3/0x327
[   45.155591] 
[   45.155591] stack backtrace:
[   45.155591] Pid: 2499, comm: flush-254:16 Not tainted 3.5.0-rc1-00002-gb22b1f1 #124
[   45.155591] Call Trace:
[   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
[   45.155591]  [<c019930e>] print_unlock_inbalance_bug+0xb4/0xc1
[   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
[   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
[   45.155591]  [<c019b5c2>] lock_release_non_nested+0x9f/0x1e8
[   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
[   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
[   45.155591]  [<c019b875>] lock_release+0x16a/0x18a
[   45.155591]  [<c06ec713>] _raw_spin_unlock+0x1b/0x25
[   45.155591]  [<c022c3da>] writeback_sb_inodes+0x160/0x327
[   45.155591]  [<c022c784>] wb_writeback+0xf2/0x1c1
[   45.155591]  [<c0160477>] ? _local_bh_enable_ip+0x9d/0xa6
[   45.155591]  [<c022c8c4>] wb_do_writeback+0x71/0x18c
[   45.155591]  [<c022ca7b>] bdi_writeback_thread+0x9c/0x18d
[   45.155591]  [<c0199b97>] ? trace_hardirqs_on+0xb/0xd
[   45.155591]  [<c022c9df>] ? wb_do_writeback+0x18c/0x18c
[   45.155591]  [<c017316a>] kthread+0x6c/0x71
[   45.155591]  [<c01730fe>] ? __init_kthread_worker+0x47/0x47
[   45.155591]  [<c06f237a>] kernel_thread_helper+0x6/0x10
[  105.196666] INFO: rcu_sched self-detected stall on CPU { 1}  (t=18000 jiffies)
[  105.196670] Pid: 2499, comm: flush-254:16 Not tainted 3.5.0-rc1-00002-gb22b1f1 #124
[  105.199991] INFO: rcu_sched self-detected stall on CPU { 0}  (t=18000 jiffies)
