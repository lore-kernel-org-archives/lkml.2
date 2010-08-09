Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0HIRNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:13:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38215 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab0HIRNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:13:50 -0400
Date: Mon, 9 Aug 2010 10:13:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: 2.6.35 - INFO: kernel/signal.c:660 invoked
 rcu_dereference_check() without protection!
Message-ID: <20100809171329.GF3026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTin4RV1uw4vPqRjmM4HDEi8TT3YT5WVZ91a-8AWj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4RV1uw4vPqRjmM4HDEi8TT3YT5WVZ91a-8AWj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:18:07PM -0400, Miles Lane wrote:
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/signal.c:660 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by udevd/670:
>  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8104628c>] do_exit+0x252/0x671
>  stack backtrace:
>  Pid: 670, comm: udevd Not tainted 2.6.35 #15
>  Call Trace:
>  [<ffffffff8106759c>] lockdep_rcu_dereference+0x9d/0xa6
>  [<ffffffff8104f297>] check_kill_permission+0x9d/0x132
>  [<ffffffff8105010e>] group_send_sig_info+0x1a/0x3d
>  [<ffffffff81046388>] do_exit+0x34e/0x671
>  [<ffffffff81046723>] do_group_exit+0x78/0xa3
>  [<ffffffff81046760>] sys_exit_group+0x12/0x16
>  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b

Thank you again for your testing efforts!

This one is a bit odd.  exit_signals() holds either the tasklist_lock
or the ->sighand->siglock over its signal manipulations, so this is
not the code path triggering the above.  I might be missing something,
but I don't see either hrtimer_cancel() or exit_itimers() attempting
to send signals.

I am copying Oleg, as he might see something that I am missing.

							Thanx, Paul
