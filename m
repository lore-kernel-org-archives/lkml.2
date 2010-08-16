Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0HPUV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:21:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42572 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab0HPUV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:21:27 -0400
Date: Mon, 16 Aug 2010 13:21:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35+vfs-scale: INFO: suspicious rcu_dereference_check()
 usage (kernel/exit.c:1387)
Message-ID: <20100816202124.GI2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTiniV_jqMi4vN5yw7q-NjsH1WAPgauWqwy9uxO-A@mail.gmail.com>
 <AANLkTik4x6h-8aR9e_o-O9NcJ0nD2X7O2=MW7ry=+o3u@mail.gmail.com>
 <AANLkTimVbbdW4iFDgc2jDThbh-p3BWPjMogE9NU8YpZr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimVbbdW4iFDgc2jDThbh-p3BWPjMogE9NU8YpZr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 07:03:40PM +0200, Vegard Nossum wrote:
> On the third try it will hopefully work.
> 
> 
> Vegard
> 
> ---------- Forwarded message ----------
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: 16 August 2010 19:01
> Subject: Re: 2.6.35+vfs-scale: INFO: suspicious
> rcu_dereference_check() usage (kernel/exit.c:1387)
> To: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells
> <dhowells@redhat.com>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>
> 
> 
> Nick Piggin might update his git config because the commits in the
> vfs-scale tree appear to bear an invalid e-mail address. Please reply
> to this e-mail instead. Thanks.
> 
> Vegard
> 
> 
> ---------- Forwarded message ----------
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: 16 August 2010 18:57
> Subject: 2.6.35+vfs-scale: INFO: suspicious rcu_dereference_check()
> usage (kernel/exit.c:1387)
> To: Nick Piggin <npiggin@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, David Howells
> <dhowells@redhat.com>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>
> 
> 
> Hi,
> 
> I was testing your VFS scaling tree*, but I get the following in my dmesg:
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/exit.c:1387 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 2 locks held by bash/2878:
>  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8103a275>] do_wait+0xb3/0x200
>  #1:  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff810399e9>]
> wait_consider_task+0x2ca/0xaa3

Thank you for locating this!

OK, so we aren't holding rcu_read_lock(), nor is this task dead, so
something needs some help.

We get from wait_consider_task() as follows: wait_consider_task()
calls security_task_wait(), which calls either selinux_task_wait() or
smack_task_wait().  Let's start with selinux_task_wait(), which calls
task_has_perm(), which does a couple of __task_cred(), but does so
under rcu_read_lock() protection, so presumably we didn't come in
that way.

Dave, am I missing a code path somewhere here?

							Thanx, Paul

> stack backtrace:
> Pid: 2878, comm: bash Not tainted 2.6.35-00079-g4067b85 #7
> Call Trace:
>  [<ffffffff8105e9f2>] lockdep_rcu_dereference+0x9b/0xa6
>  [<ffffffff8103a036>] wait_consider_task+0x917/0xaa3
>  [<ffffffff8102cf36>] ? add_preempt_count+0xc2/0xc9
>  [<ffffffff8103a29d>] do_wait+0xdb/0x200
>  [<ffffffff8103a45b>] sys_wait4+0x99/0xd3
>  [<ffffffff810387e5>] ? child_wait_callback+0x0/0x5d
>  [<ffffffff8109be66>] ? might_fault+0x96/0xbc
>  [<ffffffff810737a6>] compat_sys_wait4+0x8a/0xc1
>  [<ffffffff8109be83>] ? might_fault+0xb3/0xbc
>  [<ffffffff8109be38>] ? might_fault+0x68/0xbc
>  [<ffffffff815d02c3>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8102862c>] sys32_waitpid+0xb/0xd
>  [<ffffffff81027bb4>] sysenter_dispatch+0x7/0x30
>  [<ffffffff815d0284>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> 
> I don't think it's related to the VFS patches, however, so I added
> some other (maybe relevant) CCs too.
> 
> At the time I was simply invoking gcc from bash.
> 
> 
> Vegard
> 
> * git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> branch vfs-scale
