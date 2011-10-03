Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1JCRxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:53:41 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50895 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab1JCRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:53:36 -0400
Date: Mon, 3 Oct 2011 18:53:22 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: lockdep recursive locking detected (rcu_kthread / __cache_free)
Message-ID: <20111003175322.GA26122@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running 3.1.0-rc8 the following lockdep warning (seemingly related
to RCU) was printed as the kernel was starting.


udev: starting version 151
udevd (263): /proc/263/oom_adj is deprecated, please use /proc/263/oom_score_adj instead.

=============================================
[ INFO: possible recursive locking detected ]
3.1.0-rc8-dirty #508
---------------------------------------------
rcu_kthread/6 is trying to acquire lock:
 (&(&parent->list_lock)->rlock){..-...}, at: [<b016fe11>] __cache_free+0x2dd/0x382

but task is already holding lock:
 (&(&parent->list_lock)->rlock){..-...}, at: [<b016fe11>] __cache_free+0x2dd/0x382

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&parent->list_lock)->rlock);
  lock(&(&parent->list_lock)->rlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by rcu_kthread/6:
 #0:  (&(&parent->list_lock)->rlock){..-...}, at: [<b016fe11>] __cache_free+0x2dd/0x382

stack backtrace:
Pid: 6, comm: rcu_kthread Not tainted 3.1.0-rc8-dirty #508
Call Trace:
 [<b0144466>] __lock_acquire+0xb90/0xc0e
 [<b044c0c2>] ? _raw_spin_unlock_irqrestore+0x2f/0x46
 [<b0223ebc>] ? debug_object_active_state+0x94/0xbc
 [<b01315af>] ? rcuhead_fixup_activate+0x26/0x4c
 [<b01448be>] lock_acquire+0x5b/0x72
 [<b016fe11>] ? __cache_free+0x2dd/0x382
 [<b044bb22>] _raw_spin_lock+0x25/0x34
 [<b016fe11>] ? __cache_free+0x2dd/0x382
 [<b016fe11>] __cache_free+0x2dd/0x382
 [<b016ff5c>] kmem_cache_free+0x3e/0x5b
 [<b0170097>] slab_destroy+0x11e/0x126
 [<b0170184>] free_block+0xe5/0x112
 [<b016fe54>] __cache_free+0x320/0x382
 [<b01759a1>] ? file_free_rcu+0x32/0x39
 [<b016ff5c>] kmem_cache_free+0x3e/0x5b
 [<b01759a1>] file_free_rcu+0x32/0x39
 [<b014ca68>] rcu_process_callbacks+0x95/0xa8
 [<b014cb34>] rcu_kthread+0xb9/0xd2
 [<b013356c>] ? wake_up_bit+0x1b/0x1b
 [<b014ca7b>] ? rcu_process_callbacks+0xa8/0xa8
 [<b0133305>] kthread+0x6c/0x71
 [<b0133299>] ? __init_kthread_worker+0x42/0x42
 [<b044ce02>] kernel_thread_helper+0x6/0xd

-- 
Sitsofe | http://sucs.org/~sits/
