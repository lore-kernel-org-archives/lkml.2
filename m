Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2GaOm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:42:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46320 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2GaOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:42:27 -0400
Date: Tue, 31 Jul 2012 07:41:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
Message-ID: <20120731144159.GA2422@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120724090330.GA9830@localhost>
 <1343662752.3847.2.camel@fedora>
 <20120731120556.GB17252@localhost>
 <20120731121030.GA17617@localhost>
 <1343742253.27983.47.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343742253.27983.47.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073114-2398-0000-0000-00000901CB2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 09:44:13AM -0400, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 20:10 +0800, Fengguang Wu wrote:
> 
> > Another note: the above __update_max_tr back trace only appear accasionally.
> > The more typical error messages look like this:
> > 
> > [   16.195315] Running tests on trace events:
> > [   16.196586] Testing event kfree_skb: [   16.200404] ------------[ cut here ]------------
> > [   16.201428] WARNING: at /c/wfg/linux/kernel/lockdep.c:3506 check_flags+0x125/0x154()
> > [   16.203036] Hardware name: Bochs
> > [   16.203763] Pid: 44, comm: rcu_torture_wri Not tainted 3.5.0+ #82
> > [   16.205067] Call Trace:
> > 
> > [   16.205640]  [<c102a9f8>] warn_slowpath_common+0x63/0x78
> > [   16.206842]  [<c10644ed>] ? check_flags+0x125/0x154
> > [   16.207865]  [<c102aaa7>] warn_slowpath_null+0x14/0x18
> > [   16.208939]  [<c10644ed>] check_flags+0x125/0x154
> > [   16.210009]  [<c106522b>] lock_is_held+0x28/0x82
> > [   16.210023]  [<c1031849>] ? _local_bh_enable_ip+0x9e/0x166
> > [   16.210023]  [<c107d0ac>] rcu_read_lock_held+0x26/0x2c
> 
> This is caused by the function tracer. Every function can call this
> (even rcu_read_lock itself).
> 
> We use a schedule rcu to reference a structure, and call
> rcu_dereference_raw() to get it.
> 
> Perhaps we should just bypass the check?
> 
> Hmm, looking at this again, perhaps it needs the
> rcu_dereference_sched()? When this was first added (3f379b03)
> rcu_dereference_raw was:
> 
> #define rcu_dereference_raw(p)  ({ \
>                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
>                                 smp_read_barrier_depends(); \
>                                 (_________p1); \
>                                 })
> 
> With no check. In fact, the check called the raw. Now it's reversed. I'm
> thinking that we need a way to not have a check. Function tracing is
> *extremely* invasive. As I said, this gets called *by* rcu_read_lock()!
> I'm not sure we want checks involved here.

???

#define rcu_dereference_raw(p) rcu_dereference_check(p, 1)

#define rcu_dereference_check(p, c) \
	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)

Which becomes "__rcu_dereference_check(p, 1, __rcu)":

#define __rcu_dereference_check(p, c, space) \
	({ \
		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
				      " usage"); \
		rcu_dereference_sparse(p, space); \
		smp_read_barrier_depends(); \
		((typeof(*p) __force __kernel *)(_________p1)); \
	})

Which should therefore never trigger.  So what is really happening here?

There is also an rcu_dereference_sched_check() as well as
rcu_dereference_sched(), so you could pass "1" in to that, but I would
hope that you are in an environment where rcu_dereference_sched_check()
would validate things correctly.

							Thanx, Paul

> -- Steve
> 
> > [   16.210023]  [<c107d59d>] ftrace_ops_list_func+0x82/0xca
> > [   16.210023]  [<c1050ce8>] ? sub_preempt_count+0x5/0xf1
> > [   16.210023]  [<c13e5699>] trace+0x13/0x1b
> > [   16.210023]  [<c10318ec>] ? _local_bh_enable_ip+0x141/0x166
> > [   16.210023]  [<c1050ced>] ? sub_preempt_count+0xa/0xf1
> > [   16.210023]  [<c1031849>] _local_bh_enable_ip+0x9e/0x166
> > [   16.210023]  [<c1077fea>] ? rcu_torture_writer+0xa1/0x1c5
> > [   16.220592]  [<c1031bc4>] local_bh_enable_ip+0xd/0xf
> > [   16.220592]  [<c13e3ff9>] _raw_spin_unlock_bh+0x34/0x37
> > [   16.220592]  [<c1077fea>] rcu_torture_writer+0xa1/0x1c5
> > [   16.220592]  [<c104544f>] kthread+0x6c/0x71
> > [   16.220592]  [<c1077f49>] ? rcu_torture_barrier_cbs+0x199/0x199
> > [   16.220592]  [<c10453e3>] ? insert_kthread_work+0xa8/0xa8
> > [   16.220592]  [<c13e5662>] kernel_thread_helper+0x6/0x10
> > 
> > Thanks,
> > Fengguang
> 
> 

