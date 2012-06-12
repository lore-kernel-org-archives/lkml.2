Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2FLIaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:30:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:4904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2FLIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:30:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111067982"
Date: Tue, 12 Jun 2012 16:26:29 +0800
From: Feng Tang <feng.tang@intel.com>
To: Linux Kernel Mail List <linux-kernel@vger.kernel.org>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
        Alexander Holler <holler@ahsoftware.de>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [BUG]INFO: suspicious RCU usage for 3.5-rc1+
Message-ID: <20120612162629.15519f39@feng-i7>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During Fengguang's build test, we found a problem here:

(x86_64-allyesdebian config)
               
[ 1526.520230] ===============================
[ 1526.520230] [ INFO: suspicious RCU usage. ]
[ 1526.520230] 3.5.0-rc1+ #12 Not tainted
[ 1526.520230] -------------------------------
[ 1526.520230] /c/kernel-tests/mm/include/linux/rcupdate.h:436 Illegal context switch in RCU read-side critical section!
[ 1526.520230]  
[ 1526.520230] other info that might help us debug this:
[ 1526.520230]  
[ 1526.520230]  
[ 1526.520230] rcu_scheduler_active = 1, debug_locks = 0
[ 1526.520230] 3 locks held by net.agent/3279:
[ 1526.520230]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff82f85962>] do_page_fault+0x193/0x390
[ 1526.520230]  #1:  (panic_lock){+.+...}, at: [<ffffffff82ed2830>] panic+0x37/0x1d3
[ 1526.520230]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff810b9b28>] rcu_lock_acquire+0x0/0x29
[ 1526.520230]  
[ 1526.520230] stack backtrace:
[ 1526.520230] Pid: 3279, comm: net.agent Not tainted 3.5.0-rc1+ #12
[ 1526.520230] Call Trace:
[ 1526.520230]  [<ffffffff810e1570>] lockdep_rcu_suspicious+0x109/0x112
[ 1526.520230]  [<ffffffff810bfe3a>] rcu_preempt_sleep_check+0x45/0x47
[ 1526.520230]  [<ffffffff810bfe5a>] __might_sleep+0x1e/0x19a
[ 1526.520230]  [<ffffffff82f8010e>] down_write+0x26/0x81
[ 1526.520230]  [<ffffffff8276a966>] led_trigger_unregister+0x1f/0x9c
[ 1526.520230]  [<ffffffff8276def5>] heartbeat_reboot_notifier+0x15/0x19
[ 1526.520230]  [<ffffffff82f85bf5>] notifier_call_chain+0x96/0xcd
[ 1526.520230]  [<ffffffff82f85cba>] __atomic_notifier_call_chain+0x8e/0xff
[ 1526.520230]  [<ffffffff81094b7c>] ? kmsg_dump+0x37/0x1eb
[ 1526.520230]  [<ffffffff82f85d3f>] atomic_notifier_call_chain+0x14/0x16
[ 1526.520230]  [<ffffffff82ed28e1>] panic+0xe8/0x1d3
[ 1526.520230]  [<ffffffff811473e2>] out_of_memory+0x15d/0x1d3



Seems it is caused by doing sleepable option in led_trigger_unregister() inside the panic atomic environment.

The original commit is:
commit 49dca5aebfdeadd4bf27b6cb4c60392147dc35a4
Author: Alexander Holler <holler@ahsoftware.de>
Date:   Tue May 29 15:07:29 2012 -0700

    leds: heartbeat: stop on shutdown

    A halted kernel should not show a heartbeat.


Thanks,
Feng
