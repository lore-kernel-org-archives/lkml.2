Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab0EZPCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:02:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0EZPCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:02:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Tejun Heo <tj@kernel.org>, davem@davemloft.net, jens.axboe@oracle.com
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Change to invalidate_bdev() may break emergency remount R/O
Date: Wed, 26 May 2010 16:01:07 +0100
Message-ID: <25328.1274886067@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following commit may be a problem for emergency_remount() [Alt+SysRq+U]:

	commit fa4b9074cd8428958c2adf9dc0c831f46e27c193
	Author: Tejun Heo <tj@kernel.org>
	Date:   Sat May 15 20:09:27 2010 +0200

	    buffer: make invalidate_bdev() drain all percpu LRU add caches

	    invalidate_bdev() should release all page cache pages which are clean
	    and not being used; however, if some pages are still in the percpu LRU
	    add caches on other cpus, those pages are considered in used and don't
	    get released.  Fix it by calling lru_add_drain_all() before trying to
	    invalidate pages.

	    This problem was discovered while testing block automatic native
	    capacity unlocking.  Null pages which were read before automatic
	    unlocking didn't get released by invalidate_bdev() and ended up
	    interfering with partition scan after unlocking.

	    Signed-off-by: Tejun Heo <tj@kernel.org>
	    Acked-by: David S. Miller <davem@davemloft.net>
	    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

The symptoms are a lockdep warning:

SysRq : Emergency Remount R/O

=============================================
[ INFO: possible recursive locking detected ]
2.6.34-cachefs #101
---------------------------------------------
events/0/9 is trying to acquire lock:
 (events){+.+.+.}, at: [<ffffffff81042cf0>] flush_work+0x34/0xec

but task is already holding lock:
 (events){+.+.+.}, at: [<ffffffff81042264>] worker_thread+0x19a/0x2e2

other info that might help us debug this:
3 locks held by events/0/9:
 #0:  (events){+.+.+.}, at: [<ffffffff81042264>] worker_thread+0x19a/0x2e2
 #1:  ((work)#3){+.+...}, at: [<ffffffff81042264>] worker_thread+0x19a/0x2e2
 #2:  (&type->s_umount_key#30){++++..}, at: [<ffffffff810b3fc8>] do_emergency_remount+0x54/0xda

stack backtrace:
Pid: 9, comm: events/0 Not tainted 2.6.34-cachefs #101
Call Trace:
 [<ffffffff81054e80>] validate_chain+0x584/0xd23
 [<ffffffff81052ad4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8101c264>] ? flat_send_IPI_mask+0x74/0x86
 [<ffffffff81055ea8>] __lock_acquire+0x889/0x8fa
 [<ffffffff8102bcc9>] ? try_to_wake_up+0x23b/0x24d
 [<ffffffff8108fe45>] ? lru_add_drain_per_cpu+0x0/0xb
 [<ffffffff81055f70>] lock_acquire+0x57/0x6d
 [<ffffffff81042cf0>] ? flush_work+0x34/0xec
 [<ffffffff81042d1c>] flush_work+0x60/0xec
 [<ffffffff81042cf0>] ? flush_work+0x34/0xec
 [<ffffffff8108fbc1>] ? ____pagevec_lru_add+0x140/0x156
 [<ffffffff8108fe45>] ? lru_add_drain_per_cpu+0x0/0xb
 [<ffffffff8108fdc5>] ? lru_add_drain+0x3b/0x8f
 [<ffffffff81042eba>] schedule_on_each_cpu+0x112/0x152
 [<ffffffff8108fc5a>] lru_add_drain_all+0x10/0x12
 [<ffffffff810d509e>] invalidate_bdev+0x28/0x3a
 [<ffffffff810b3ef3>] do_remount_sb+0x129/0x14e
 [<ffffffff810b3ff3>] do_emergency_remount+0x7f/0xda
 [<ffffffff810422b9>] worker_thread+0x1ef/0x2e2
 [<ffffffff81042264>] ? worker_thread+0x19a/0x2e2
 [<ffffffff810b3f74>] ? do_emergency_remount+0x0/0xda
 [<ffffffff81045fcd>] ? autoremove_wake_function+0x0/0x34
 [<ffffffff810420ca>] ? worker_thread+0x0/0x2e2
 [<ffffffff81045be7>] kthread+0x7a/0x82
 [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
 [<ffffffff813e2c3c>] ? restore_args+0x0/0x30
 [<ffffffff81045b6d>] ? kthread+0x0/0x82
 [<ffffffff81002cd0>] ? kernel_thread_helper+0x0/0x10
Emergency Remount complete

David
