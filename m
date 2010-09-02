Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0IBGLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:11:25 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:58607 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752504Ab0IBGLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:11:23 -0400
Date: Thu, 2 Sep 2010 16:11:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc3: inconsistent lock state (iprune_sem,
 shrink_icache_memory)
Message-ID: <20100902061116.GW705@dastard>
References: <tkrat.ed8eda6bc8ffe64e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.ed8eda6bc8ffe64e@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 08:37:43AM +0200, Stefan Richter wrote:
> I switched from 2.6.35 to 2.6.36-rc3 a few days ago and while doing so
> enabled lockdep.  Just got the following report during normal desktop
> usage:
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.36-rc3 #3
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
> kswapd0/436 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (iprune_sem){+++++-}, at: [<ffffffff810bde0b>] shrink_icache_memory+0x48/0x217
> {RECLAIM_FS-ON-W} state was registered at:
>   [<ffffffff810598b3>] mark_held_locks+0x4d/0x6b
>   [<ffffffff8105995f>] lockdep_trace_alloc+0x8e/0xa7
>   [<ffffffff810a5a7f>] kmem_cache_alloc+0x2a/0xc8
>   [<ffffffff810d4f8a>] fsnotify_create_event+0x39/0x160
>   [<ffffffff810d49e8>] send_to_group+0x108/0x13f
>   [<ffffffff810d4b86>] fsnotify+0x167/0x266
>   [<ffffffff810d57d0>] fsnotify_unmount_inodes+0xb8/0xf9
>   [<ffffffff810bda9b>] invalidate_inodes+0x4b/0x13a
>   [<ffffffff810ad3e5>] generic_shutdown_super+0x42/0xd2
>   [<ffffffff810ad497>] kill_block_super+0x22/0x3a
>   [<ffffffff810aca61>] deactivate_locked_super+0x21/0x41
>   [<ffffffff810acc39>] deactivate_super+0x40/0x44
>   [<ffffffff810c1c29>] mntput_no_expire+0xdc/0x10a
>   [<ffffffff810c2e5d>] sys_umount+0x2a4/0x2d1
>   [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b
> irq event stamp: 281663
> hardirqs last  enabled at (281663): [<ffffffff81072d32>] __call_rcu+0x119/0x125
> hardirqs last disabled at (281662): [<ffffffff81072c41>] __call_rcu+0x28/0x125
> softirqs last  enabled at (278242): [<ffffffff81038cff>] __do_softirq+0x14a/0x15b
> softirqs last disabled at (278217): [<ffffffff81002e8c>] call_softirq+0x1c/0x28
> 
> other info that might help us debug this:
> 1 lock held by kswapd0/436:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810891d7>] shrink_slab+0x38/0x164
> 
> stack backtrace:
> Pid: 436, comm: kswapd0 Not tainted 2.6.36-rc3 #3
> Call Trace:
>  [<ffffffff8105933b>] print_usage_bug+0x1af/0x1c0
>  [<ffffffff81059e81>] ? check_usage_forwards+0x0/0xcd
>  [<ffffffff81059637>] mark_lock+0x2eb/0x51a
>  [<ffffffff8105af8c>] __lock_acquire+0x862/0x182c
>  [<ffffffff810ba6ea>] ? shrink_dcache_memory+0x114/0x1a9
>  [<ffffffff810ba6f3>] ? shrink_dcache_memory+0x11d/0x1a9
>  [<ffffffff810ba6ea>] ? shrink_dcache_memory+0x114/0x1a9
>  [<ffffffff8105bfb0>] lock_acquire+0x5a/0x71
>  [<ffffffff810bde0b>] ? shrink_icache_memory+0x48/0x217
>  [<ffffffff8133cb68>] down_read+0x42/0x55
>  [<ffffffff810bde0b>] ? shrink_icache_memory+0x48/0x217
>  [<ffffffff810bde0b>] shrink_icache_memory+0x48/0x217
>  [<ffffffff81089280>] shrink_slab+0xe1/0x164
>  [<ffffffff81089893>] kswapd+0x590/0x7e2
>  [<ffffffff8104b1d6>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff8133deff>] ? _raw_spin_unlock_irqrestore+0x4c/0x68
>  [<ffffffff81089303>] ? kswapd+0x0/0x7e2
>  [<ffffffff8104ade2>] kthread+0x81/0x89
>  [<ffffffff81002d94>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8102d5ba>] ? finish_task_switch+0x69/0xa9
>  [<ffffffff8133e3c0>] ? restore_args+0x0/0x30
>  [<ffffffff8104ad61>] ? kthread+0x0/0x89
>  [<ffffffff81002d90>] ? kernel_thread_helper+0x0/0x10
> 
> A web search finds reports of this kind from months ago.  I haven't read
> up on them yet whether there were any conclusions from them.

Any memory allocation that enters reclaim in the unmount path will
generate this warning. The problem is that the normal memory reclaim
path is:

	alloc -> reclaim -> shrink_slab -> shrink_icache_memory -> iprune_sem -> s_umount

while unmmount does:

	unmount -> s_umount -> alloc -> lockdep goes boom!
or
	unmount -> iprune_sem -> alloc -> lockdep goes boom!

I never got a straight answer on this, but it the warnings are
indicating that you must use GFP_NOFS allocations for every
allocation in the unmount path, which is kind of hard to know
about given the code is not unomunt path specific....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
