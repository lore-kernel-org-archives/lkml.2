Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0HIR1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:27:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59158 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab0HIR1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:27:32 -0400
Date: Mon, 9 Aug 2010 10:27:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: 2.6.35 - INFO: kernel/exit.c:1387 invoked
 rcu_dereference_check() without protection!
Message-ID: <20100809172719.GG3026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTimULDfJ9n2XxNmtq8yUcNRfAywHpiDDXRKtev10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimULDfJ9n2XxNmtq8yUcNRfAywHpiDDXRKtev10@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:20:58PM -0400, Miles Lane wrote:
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/exit.c:1387 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 2 locks held by init/1:
>  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff81045ca8>] do_wait+0xa9/0x1fa
>  #1:  (&(&sighand->siglock)->rlock){......}, at: [<ffffffff810457e8>]
> wait_consider_task+0x5e1/0x9f8
> 
> stack backtrace:
> Pid: 1, comm: init Not tainted 2.6.35 #15
> Call Trace:
>  [<ffffffff8106759c>] lockdep_rcu_dereference+0x9d/0xa6
>  [<ffffffff81045877>] wait_consider_task+0x670/0x9f8
>  [<ffffffff81045d14>] do_wait+0x115/0x1fa
>  [<ffffffff81045f41>] sys_waitid+0x7f/0x178
>  [<ffffffff81009cba>] ? sysret_check+0x2e/0x69
>  [<ffffffff8104454e>] ? child_wait_callback+0x0/0x53
>  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b

This one is interesting.  The ->sighand->siglock is held, but the
rcu_dereference_check() check condition requires that either the
task is dead or that we are in an RCU read-side critical section.
The comment preceding the call to __task_cred() claims that we
"don't need the RCU readlock here as we're holding a spinlock."
This comment dates back to 2008, so might be obsolete.

David, should we enclose the __task_cred() in wait_task_stopped()
with rcu_read_lock()?  Or would it be better to add a check to
__task_cred() checking for ->sighand->siglock?  Or do we need to
do something else entirely?  ;-)

							Thanx, Paul
