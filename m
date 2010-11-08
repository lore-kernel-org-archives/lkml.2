Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0KHUYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:24:40 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57926 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab0KHUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:24:39 -0500
Date: Mon, 8 Nov 2010 12:24:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com
Subject: Re: suspicious rcu_dereference_check() usage splat
Message-ID: <20101108202437.GH4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101107071414.GA3600@deepthought.bhanu.net>
 <20101107185013.GC15561@linux.vnet.ibm.com>
 <20101108153957.GA3418@deepthought.bhanu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108153957.GA3418@deepthought.bhanu.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 11:39:57PM +0800, Arun Bhanu wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sun, Nov 07, 2010 at 03:14:14PM +0800, Arun Bhanu wrote:
> > > I got the following splat while booting 2.6.37-rc1+
> > > (ff8b16d7e15a8ba2a6086645614a483e048e3fbf).
> > > 
> > > [    9.381536] ===================================================
> > > [    9.382380] [ INFO: suspicious rcu_dereference_check() usage. ]
> > > [    9.382867] ---------------------------------------------------
> > > [    9.383412] kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> > > [    9.383959] 
> > > [    9.383959] other info that might help us debug this:
> > > [    9.383960] 
> > > [    9.385599] 
> > > [    9.385599] rcu_scheduler_active = 1, debug_locks = 0
> > > [    9.386686] 1 lock held by readahead/365:
> > > [    9.387227]  #0:  (tasklist_lock){.+.+..}, at: [<c05188f3>] sys_ioprio_set+0x84/0x261
> > > [    9.387765] 
> > > [    9.387765] stack backtrace:
> > > [    9.388840] Pid: 365, comm: readahead Not tainted 2.6.37-rc1-ab1.fc14.i686.PAE+ #1
> > > [    9.389374] Call Trace:
> > > [    9.389909]  [<c07e57ba>] ? printk+0x25/0x2b
> > > [    9.390453]  [<c046b21a>] lockdep_rcu_dereference+0x7d/0x86
> > > [    9.390986]  [<c0459304>] find_task_by_pid_ns+0x3f/0x53
> > > [    9.391521]  [<c0459335>] find_task_by_vpid+0x1d/0x1f
> > > [    9.392050]  [<c051891b>] sys_ioprio_set+0xac/0x261
> > > [    9.392574]  [<c046d80f>] ? trace_hardirqs_on_caller+0xfe/0x11f
> > > [    9.393110]  [<c040951f>] sysenter_do_call+0x12/0x38
> > > 
> > > Complete dmesg and config attached. Let me know if you want me to test
> > > any patches.
> > 
> > Could you please try the patch at http://lkml.org/lkml/2010/10/29/168?
> 
> Thanks for the pointer. With the above patch applied I am no longer
> seeing the splat.
> 
> Tested-by: Arun Bhanu <arun@bhanu.net>

Very good!!!

Looking over the patch again, the scope of the RCU read-side critical
section needs to expand to cover the use of the pointer as well as the
call to find_task_by_vpid().  So, for example:

		case IOPRIO_WHO_PROCESS:
			rcu_read_lock();
			if (!who)
				p = current;
			else
				p = find_task_by_vpid(who);
			if (p)
				ret = set_task_ioprio(p, ioprio);
			rcu_read_unlock();
			break;
		case IOPRIO_WHO_PGRP:


Otherwise, the task could go away before the last use.

Sergey, could you please make this change and re-post your patch?

							Thanx, Paul

> > > -Arun
> 
> [snip]
> 
> -Arun
