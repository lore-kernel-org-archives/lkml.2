Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2JYF5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:57:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39330 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2JYF5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:57:53 -0400
Date: Wed, 24 Oct 2012 22:55:31 -0700
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121025055531.GB2661@swordfish>
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <CAFTL4hxmh7yV8ePUhY_7hOuG=JrbZZcNvV88bWcUmwG9X0W04A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxmh7yV8ePUhY_7hOuG=JrbZZcNvV88bWcUmwG9X0W04A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/25/12 00:32), Frederic Weisbecker wrote:
> > My understanding is (I may be wrong) that we can schedule() from ptrace chain to
> > some arbitrary task, which will continue its execution from the point where RCU assumes
> > CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
> > (or similar) prior to schedule() call.
> 
> Yeah but when we are in syscall_trace_leave(), the CPU shouldn't be in
> RCU idle mode. That's where the bug is. How do you manage to trigger
> this bug?
> 

just for note, 
git bisect good v3.6

[  199.897703] ===============================
[  199.897706] [ INFO: suspicious RCU usage. ]
[  199.897710] 3.6.0-dbg-06307-ga78562e-dirty #1379 Not tainted
[  199.897713] -------------------------------
[  199.897717] include/linux/rcupdate.h:738 rcu_read_lock() used illegally while idle!
[  199.897719] 
other info that might help us debug this:

[  199.897724] 
RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 1
[  199.897729] RCU used illegally from extended quiescent state!
[  199.897732] 2 locks held by top/2396:
[  199.897735]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff815c7ae9>] __schedule+0x119/0xb10
[  199.897755]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81081f25>] cpuacct_charge+0x15/0x250
[  199.897770] 
stack backtrace:
[  199.897775] Pid: 2396, comm: top Not tainted 3.6.0-dbg-06307-ga78562e-dirty #1379
[  199.897779] Call Trace:
[  199.897791]  [<ffffffff810a7ed2>] lockdep_rcu_suspicious+0xe2/0x130
[  199.897798]  [<ffffffff810820cc>] cpuacct_charge+0x1bc/0x250
[  199.897804]  [<ffffffff81081f25>] ? cpuacct_charge+0x15/0x250
[  199.897810]  [<ffffffff815c7ae9>] ? __schedule+0x119/0xb10
[  199.897818]  [<ffffffff8108567c>] update_curr+0xec/0x230
[  199.897825]  [<ffffffff8108653c>] put_prev_task_fair+0x9c/0xf0
[  199.897831]  [<ffffffff815c7b7c>] __schedule+0x1ac/0xb10
[  199.897841]  [<ffffffff8131addd>] ? do_raw_spin_unlock+0x5d/0xb0
[  199.897847]  [<ffffffff810a6fdd>] ? trace_hardirqs_off+0xd/0x10
[  199.897853]  [<ffffffff815ca0c7>] ? _raw_spin_unlock_irqrestore+0x77/0x80
[  199.897860]  [<ffffffff8107f7ff>] ? try_to_wake_up+0x1ff/0x350
[  199.897867]  [<ffffffff810aac19>] ? __lock_acquire+0x3d9/0xb70
[  199.897875]  [<ffffffff8115c5b9>] ? kfree+0xa9/0x260
[  199.897882]  [<ffffffff810dc575>] ? __call_rcu+0x105/0x250
[  199.897887]  [<ffffffff8107c67a>] __cond_resched+0x2a/0x40
[  199.897891]  [<ffffffff815c855f>] _cond_resched+0x2f/0x40
[  199.897898]  [<ffffffff81182da8>] dput+0x128/0x1e0
[  199.897902]  [<ffffffff81169c78>] __fput+0x148/0x260
[  199.897907]  [<ffffffff8107981f>] ? finish_task_switch+0x3f/0x120
[  199.897911]  [<ffffffff81169e4e>] ____fput+0xe/0x10
[  199.897917]  [<ffffffff81067bbc>] task_work_run+0xbc/0xf0
[  199.897923]  [<ffffffff8105a4a9>] ptrace_notify+0x89/0x90
[  199.897931]  [<ffffffff8100fa1d>] syscall_trace_leave+0x8d/0x220
[  199.897939]  [<ffffffff815d39d1>] ? int_very_careful+0x5/0xd
[  199.897944]  [<ffffffff810ac555>] ? trace_hardirqs_on_caller+0x105/0x190
[  199.897949]  [<ffffffff815d3a0d>] int_check_syscall_exit_work+0x34/0x3d


	-ss
