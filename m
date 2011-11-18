Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab1KRQ5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:57:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:22721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab1KRQ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:57:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,533,1315206000"; 
   d="scan'208";a="86890599"
Date: Fri, 18 Nov 2011 08:57:37 -0800
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [BUG] e1000: possible deadlock scenario caught by lockdep
Message-ID: <20111118085737.0000387f@unknown>
In-Reply-To: <1321579620.3533.29.camel@frodo>
References: <1321579620.3533.29.camel@frodo>
X-Mailer: Claws Mail 3.7.10cvs7 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'd netdev, and e1000-devel

On Thu, 17 Nov 2011 17:27:00 -0800
Steven Rostedt <rostedt@goodmis.org> wrote:

> I hit the following lockdep splat:
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.2.0-rc2-test+ #14
> -------------------------------------------------------
> reboot/2316 is trying to acquire lock:
>  ((&(&adapter->watchdog_task)->work)){+.+...}, at: [<ffffffff81069553>] wait_on_work+0x0/0xac
> 
> but task is already holding lock:
>  (&adapter->mutex){+.+...}, at: [<ffffffff81359b1d>] __e1000_shutdown+0x56/0x1f5
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&adapter->mutex){+.+...}:
>        [<ffffffff8108261a>] lock_acquire+0x103/0x158
>        [<ffffffff8150bcf3>] __mutex_lock_common+0x6a/0x441
>        [<ffffffff8150c13d>] mutex_lock_nested+0x1b/0x1d
>        [<ffffffff81359288>] e1000_watchdog+0x56/0x4a4
>        [<ffffffff8106a1b0>] process_one_work+0x1ef/0x3e0
>        [<ffffffff8106b4e0>] worker_thread+0xda/0x15e
>        [<ffffffff8106f00e>] kthread+0x9f/0xa7
>        [<ffffffff81514e84>] kernel_thread_helper+0x4/0x10
> 
> -> #0 ((&(&adapter->watchdog_task)->work)){+.+...}:
>        [<ffffffff81081e4a>] __lock_acquire+0xa29/0xd06
>        [<ffffffff8108261a>] lock_acquire+0x103/0x158
>        [<ffffffff81069590>] wait_on_work+0x3d/0xac
>        [<ffffffff8106a616>] __cancel_work_timer+0xb9/0xff
>        [<ffffffff8106a66e>] cancel_delayed_work_sync+0x12/0x14
>        [<ffffffff81355c8f>] e1000_down_and_stop+0x2e/0x4a
>        [<ffffffff813581ed>] e1000_down+0x116/0x176
>        [<ffffffff81359b4a>] __e1000_shutdown+0x83/0x1f5
>        [<ffffffff81359cd6>] e1000_shutdown+0x1a/0x43
>        [<ffffffff8126fdad>] pci_device_shutdown+0x29/0x3d
>        [<ffffffff8130c601>] device_shutdown+0xbe/0xf9
>        [<ffffffff81065b17>] kernel_restart_prepare+0x31/0x38
>        [<ffffffff81065b32>] kernel_restart+0x14/0x51
>        [<ffffffff81065cd8>] sys_reboot+0x157/0x1b0
>        [<ffffffff81513882>] system_call_fastpath+0x16/0x1b
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&adapter->mutex);
>                                lock((&(&adapter->watchdog_task)->work));
>                                lock(&adapter->mutex);
>   lock((&(&adapter->watchdog_task)->work));
> 
>  *** DEADLOCK ***
> 
> 2 locks held by reboot/2316:
>  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff81065c20>] sys_reboot+0x9f/0x1b0
>  #1:  (&adapter->mutex){+.+...}, at: [<ffffffff81359b1d>] __e1000_shutdown+0x56/0x1f5
> 
> stack backtrace:
> Pid: 2316, comm: reboot Not tainted 3.2.0-rc2-test+ #14
> Call Trace:
>  [<ffffffff81503eb2>] print_circular_bug+0x1f8/0x209
>  [<ffffffff81081e4a>] __lock_acquire+0xa29/0xd06
>  [<ffffffff81069553>] ? wait_on_cpu_work+0x94/0x94
>  [<ffffffff8108261a>] lock_acquire+0x103/0x158
>  [<ffffffff81069553>] ? wait_on_cpu_work+0x94/0x94
>  [<ffffffff810c7caf>] ? trace_preempt_on+0x2a/0x2f
>  [<ffffffff81069590>] wait_on_work+0x3d/0xac
>  [<ffffffff81069553>] ? wait_on_cpu_work+0x94/0x94
>  [<ffffffff8106a616>] __cancel_work_timer+0xb9/0xff
>  [<ffffffff8106a66e>] cancel_delayed_work_sync+0x12/0x14
>  [<ffffffff81355c8f>] e1000_down_and_stop+0x2e/0x4a
>  [<ffffffff813581ed>] e1000_down+0x116/0x176
>  [<ffffffff81359b4a>] __e1000_shutdown+0x83/0x1f5
>  [<ffffffff8150d51c>] ? _raw_spin_unlock+0x33/0x56
>  [<ffffffff8130c583>] ? device_shutdown+0x40/0xf9
>  [<ffffffff81359cd6>] e1000_shutdown+0x1a/0x43
>  [<ffffffff81510757>] ? sub_preempt_count+0xa1/0xb4
>  [<ffffffff8126fdad>] pci_device_shutdown+0x29/0x3d
>  [<ffffffff8130c601>] device_shutdown+0xbe/0xf9
>  [<ffffffff81065b17>] kernel_restart_prepare+0x31/0x38
>  [<ffffffff81065b32>] kernel_restart+0x14/0x51
>  [<ffffffff81065cd8>] sys_reboot+0x157/0x1b0
>  [<ffffffff81072ccb>] ? hrtimer_cancel+0x17/0x24
>  [<ffffffff8150c304>] ? do_nanosleep+0x74/0xac
>  [<ffffffff8125c72d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8150e066>] ? error_sti+0x5/0x6
>  [<ffffffff810c7c80>] ? time_hardirqs_off+0x2a/0x2f
>  [<ffffffff8125c6ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8150db5d>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff8150db5d>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff81082a78>] ? trace_hardirqs_on_caller+0x12d/0x164
>  [<ffffffff810a74ce>] ? audit_syscall_entry+0x11c/0x148
>  [<ffffffff8125c6ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81513882>] system_call_fastpath+0x16/0x1b
> 
> 
> The issue comes from two recent commits:
> 
> commit a4010afef585b7142eb605e3a6e4210c0e1b2957
> Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Date:   Wed Oct 5 07:24:41 2011 +0000
> e1000: convert hardware management from timers to threads
> 
> and
> 
> commit 0ef4eedc2e98edd51cd106e1f6a27178622b7e57
> Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Date:   Wed Oct 5 07:24:51 2011 +0000
> e1000: convert to private mutex from rtnl
> 
> 
> What we have is on __e1000_shutdown():
> 
> 	mutex_lock(&adapter->mutex);
> 
> 	if (netif_running(netdev)) {
> 		WARN_ON(test_bit(__E1000_RESETTING, &adapter->flags));
> 		e1000_down(adapter);
> 	}
> 
> but e1000_down() calls: e1000_down_and_stop():
> 
> static void e1000_down_and_stop(struct e1000_adapter *adapter)
> {
> 	set_bit(__E1000_DOWN, &adapter->flags);
> 	cancel_work_sync(&adapter->reset_task);
> 	cancel_delayed_work_sync(&adapter->watchdog_task);
> 	cancel_delayed_work_sync(&adapter->phy_info_task);
> 	cancel_delayed_work_sync(&adapter->fifo_stall_task);
> }
> 
> 
> Here you see that we are calling cancel_delayed_work_sync(&adapter->watchdog_task);
> 
> The problem is that adapter->watchdog_task grabs the mutex &adapter->mutex.
> 
> If the work has started and it blocked on that mutex, the
> cancel_delayed_work_sync() will block indefinitely and we have a
> deadlock.
> 
> Not sure what's the best way around this. Can we call e1000_down()
> without grabbing the adapter->mutex?

Thanks for the report, I'll look at it today and see if I can work out
a way to avoid the bonk.
