Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2G3PjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2G3PjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:39:18 -0400
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <srostedt@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org
In-Reply-To: <20120724090330.GA9830@localhost>
References: <20120724090330.GA9830@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 30 Jul 2012 11:39:12 -0400
Message-ID: <1343662752.3847.2.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 17:03 +0800, Fengguang Wu wrote:
> Hi Steven,

Hi Fengguang,

Just an FYI, It's best to send email to my rostedt@goodmis.org account.
I don't check my redhat account every day.

> 
> This looks like some old bug, so I directly report to you w/o trying
> to bisect it. It only happens on the attached i386 randconfig and
> happens in about half of the kvm boots.
> 
> [    1.380369] Testing tracer irqsoff: [    1.524917] 
> [    1.525217] ===============================
> [    1.525868] [ INFO: suspicious RCU usage. ]
> [    1.526556] 3.5.0+ #1289 Not tainted
> [    1.527124] -------------------------------
> [    1.527799] /c/kernel-tests/src/linux/include/linux/rcupdate.h:730 rcu_read_lock() used illegally while idle!
> [    1.529375] 
> [    1.529375] other info that might help us debug this:
> [    1.529375] 
> [    1.530667] 
> [    1.530667] RCU used illegally from idle CPU!
> [    1.530667] rcu_scheduler_active = 1, debug_locks = 1
> [    1.532383] RCU used illegally from extended quiescent state!
> [    1.533297] 2 locks held by swapper/0/0:
> 
> [    1.533924]  #0: [    1.534271]  (max_trace_lock){......}, at: [<410e9d67>] check_critical_timing+0x67/0x1b0
> [    1.534883]  #1:  (rcu_read_lock){.+.+..}, at: [<410e1ea0>] __update_max_tr+0x0/0x200
> 
> [    1.534883] stack backtrace:
> [    1.534883] Pid: 0, comm: swapper/0 Not tainted 3.5.0+ #1289
> [    1.534883] Call Trace:
> [    1.534883]  [<41093a76>] lockdep_rcu_suspicious+0xc6/0x100
> [    1.534883]  [<410e2071>] __update_max_tr+0x1d1/0x200

This is very weird because __update_max_tr does not use rcu_read lock().
If you still have the kernel around (or can reproduce it), can you show
the objdump of the __update_max_tr function. I wonder if some debug
option requires RCU usage somewhere there.

Thanks,

-- Steve

> [    1.534883]  [<410e1ea0>] ? tracing_record_cmdline+0x130/0x130
> [    1.534883]  [<410e30f5>] update_max_tr_single+0x1f5/0x240
> [    1.534883]  [<410e294c>] ? __trace_stack+0x1c/0x30
> [    1.534883]  [<410e9e96>] check_critical_timing+0x196/0x1b0
> [    1.534883]  [<4100b858>] ? default_idle+0x468/0x4c0
> [    1.534883]  [<4100b858>] ? default_idle+0x468/0x4c0
> [    1.534883]  [<410ea47f>] time_hardirqs_on+0xff/0x110
> [    1.534883]  [<410961eb>] ? trace_hardirqs_on+0xb/0x10
> [    1.534883]  [<4100b858>] ? default_idle+0x468/0x4c0
> [    1.534883]  [<41096031>] trace_hardirqs_on_caller+0x11/0x1c0
> [    1.534883]  [<410961eb>] trace_hardirqs_on+0xb/0x10
> [    1.534883]  [<4100b858>] default_idle+0x468/0x4c0
> [    1.534883]  [<4100c4e6>] cpu_idle+0x186/0x190
> [    1.534883]  [<412953c3>] rest_init+0x127/0x134
> [    1.534883]  [<4129529c>] ? __read_lock_failed+0x14/0x14
> [    1.534883]  [<4141b9e0>] start_kernel+0x36f/0x375
> [    1.534883]  [<4141b4a6>] ? repair_env_string+0x51/0x51
> [    1.534883]  [<4141b2d4>] i386_start_kernel+0x8a/0x8f
> [    1.534883] 
> [    1.534883] ===============================
> 
> Thanks,
> Fengguang


