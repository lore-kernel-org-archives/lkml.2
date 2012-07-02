Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2GBVle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:41:34 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48884 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2GBVld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:41:33 -0400
Message-ID: <4FF21580.6000202@ahsoftware.de>
Date: Mon, 02 Jul 2012 23:41:20 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Linux Kernel Mail List <linux-kernel@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [BUG]INFO: suspicious RCU usage for 3.5-rc1+
References: <20120612162629.15519f39@feng-i7>
In-Reply-To: <20120612162629.15519f39@feng-i7>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Feng,

sorry for the late answer.

Am 12.06.2012 10:26, schrieb Feng Tang:
> During Fengguang's build test, we found a problem here:
>
> (x86_64-allyesdebian config)
>
> [ 1526.520230] ===============================
> [ 1526.520230] [ INFO: suspicious RCU usage. ]
> [ 1526.520230] 3.5.0-rc1+ #12 Not tainted
> [ 1526.520230] -------------------------------
> [ 1526.520230] /c/kernel-tests/mm/include/linux/rcupdate.h:436 Illegal context switch in RCU read-side critical section!
> [ 1526.520230]
> [ 1526.520230] other info that might help us debug this:
> [ 1526.520230]
> [ 1526.520230]
> [ 1526.520230] rcu_scheduler_active = 1, debug_locks = 0
> [ 1526.520230] 3 locks held by net.agent/3279:
> [ 1526.520230]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff82f85962>] do_page_fault+0x193/0x390
> [ 1526.520230]  #1:  (panic_lock){+.+...}, at: [<ffffffff82ed2830>] panic+0x37/0x1d3
> [ 1526.520230]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff810b9b28>] rcu_lock_acquire+0x0/0x29
> [ 1526.520230]
> [ 1526.520230] stack backtrace:
> [ 1526.520230] Pid: 3279, comm: net.agent Not tainted 3.5.0-rc1+ #12
> [ 1526.520230] Call Trace:
> [ 1526.520230]  [<ffffffff810e1570>] lockdep_rcu_suspicious+0x109/0x112
> [ 1526.520230]  [<ffffffff810bfe3a>] rcu_preempt_sleep_check+0x45/0x47
> [ 1526.520230]  [<ffffffff810bfe5a>] __might_sleep+0x1e/0x19a
> [ 1526.520230]  [<ffffffff82f8010e>] down_write+0x26/0x81
> [ 1526.520230]  [<ffffffff8276a966>] led_trigger_unregister+0x1f/0x9c
> [ 1526.520230]  [<ffffffff8276def5>] heartbeat_reboot_notifier+0x15/0x19
> [ 1526.520230]  [<ffffffff82f85bf5>] notifier_call_chain+0x96/0xcd
> [ 1526.520230]  [<ffffffff82f85cba>] __atomic_notifier_call_chain+0x8e/0xff
> [ 1526.520230]  [<ffffffff81094b7c>] ? kmsg_dump+0x37/0x1eb
> [ 1526.520230]  [<ffffffff82f85d3f>] atomic_notifier_call_chain+0x14/0x16
> [ 1526.520230]  [<ffffffff82ed28e1>] panic+0xe8/0x1d3
> [ 1526.520230]  [<ffffffff811473e2>] out_of_memory+0x15d/0x1d3
>
>
>
> Seems it is caused by doing sleepable option in led_trigger_unregister() inside the panic atomic environment.
>
> The original commit is:
> commit 49dca5aebfdeadd4bf27b6cb4c60392147dc35a4
> Author: Alexander Holler <holler@ahsoftware.de>
> Date:   Tue May 29 15:07:29 2012 -0700
>
>      leds: heartbeat: stop on shutdown
>
>      A halted kernel should not show a heartbeat.
>

Hmm, I'm not very familiar with what happens when a panic occurs and my 
tests with panics haven't revealed that (or I didn't have seen it).

I will try to get the same error and will have a deeper look at what 
happens in led_trigger_unregister() (and if and how that might be 
avoidable) in the next days. Thanks.

Regards,

Alexander
