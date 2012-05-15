Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2EOFQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:16:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37370 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2EOFQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:16:34 -0400
Date: Mon, 14 May 2012 22:16:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, sds@tycho.nsa.gov,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: paul@paul-moore.com
Subject: Re: suspicious RCU usage in security/selinux/netnode.c
Message-ID: <20120515051607.GH2412@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120515044145.GA21910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515044145.GA21910@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051505-6148-0000-0000-000005D73804
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:41:45AM -0400, Dave Jones wrote:
> I just triggered this on Linus' current tree.

This is a bare:

	rcu_dereference(sel_netnode_hash[idx].list.prev)

which needs to be in an RCU read-side critical section.  Alternatively,
the above should instead be something like:

	rcu_dereference_check(sel_netnode_hash[idx].list.prev,
			      lockdep_is_held(&sel_netnode_lock));

This second approach assumes that all modifications to the hash table
are protected by sel_netnode_lock.  Paul Moore, thoughts?

							Thanx, Paul

> 	Dave
> 
>  ===============================
>  [ INFO: suspicious RCU usage. ]
>  3.4.0-rc7+ #93 Not tainted
>  -------------------------------
>  security/selinux/netnode.c:178 suspicious rcu_dereference_check() usage!
> 
>  other info that might help us debug this:
> 
> 
>  rcu_scheduler_active = 1, debug_locks = 0
>  1 lock held by trinity/25132:
>   #0:  (sel_netnode_lock){+.....}, at: [<ffffffff812db738>] sel_netnode_sid+0x148/0x3c0
> 
>  stack backtrace:
>  Pid: 25132, comm: trinity Not tainted 3.4.0-rc7+ #93
>  Call Trace:
>   [<ffffffff810cc7cd>] lockdep_rcu_suspicious+0xfd/0x130
>   [<ffffffff812db981>] sel_netnode_sid+0x391/0x3c0
>   [<ffffffff812db5f0>] ? sel_netnode_find+0x1a0/0x1a0
>   [<ffffffff812d4a84>] selinux_socket_bind+0x104/0x350
>   [<ffffffff810a6648>] ? sched_clock_cpu+0xb8/0x130
>   [<ffffffff816a47b9>] ? sub_preempt_count+0xa9/0xe0
>   [<ffffffff812cb3e6>] security_socket_bind+0x16/0x20
>   [<ffffffff815468aa>] sys_bind+0x7a/0x100
>   [<ffffffff816a8795>] ? sysret_check+0x22/0x5d
>   [<ffffffff810d149d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
>   [<ffffffff810fc18c>] ? __audit_syscall_entry+0xcc/0x310
>   [<ffffffff8133839e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff816a8769>] system_call_fastpath+0x16/0x1b
> 

