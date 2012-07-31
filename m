Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2GaNoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:44:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2GaNoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:44:15 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=I5RZEMmPgckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=GMf3nbrKfh60RD8fxcMA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343742253.27983.47.camel@gandalf.stny.rr.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jul 2012 09:44:13 -0400
In-Reply-To: <20120731121030.GA17617@localhost>
References: <20120724090330.GA9830@localhost>
	 <1343662752.3847.2.camel@fedora> <20120731120556.GB17252@localhost>
	 <20120731121030.GA17617@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 20:10 +0800, Fengguang Wu wrote:

> Another note: the above __update_max_tr back trace only appear accasionally.
> The more typical error messages look like this:
> 
> [   16.195315] Running tests on trace events:
> [   16.196586] Testing event kfree_skb: [   16.200404] ------------[ cut here ]------------
> [   16.201428] WARNING: at /c/wfg/linux/kernel/lockdep.c:3506 check_flags+0x125/0x154()
> [   16.203036] Hardware name: Bochs
> [   16.203763] Pid: 44, comm: rcu_torture_wri Not tainted 3.5.0+ #82
> [   16.205067] Call Trace:
> 
> [   16.205640]  [<c102a9f8>] warn_slowpath_common+0x63/0x78
> [   16.206842]  [<c10644ed>] ? check_flags+0x125/0x154
> [   16.207865]  [<c102aaa7>] warn_slowpath_null+0x14/0x18
> [   16.208939]  [<c10644ed>] check_flags+0x125/0x154
> [   16.210009]  [<c106522b>] lock_is_held+0x28/0x82
> [   16.210023]  [<c1031849>] ? _local_bh_enable_ip+0x9e/0x166
> [   16.210023]  [<c107d0ac>] rcu_read_lock_held+0x26/0x2c

This is caused by the function tracer. Every function can call this
(even rcu_read_lock itself).

We use a schedule rcu to reference a structure, and call
rcu_dereference_raw() to get it.

Perhaps we should just bypass the check?

Hmm, looking at this again, perhaps it needs the
rcu_dereference_sched()? When this was first added (3f379b03)
rcu_dereference_raw was:

#define rcu_dereference_raw(p)  ({ \
                                typeof(p) _________p1 = ACCESS_ONCE(p); \
                                smp_read_barrier_depends(); \
                                (_________p1); \
                                })

With no check. In fact, the check called the raw. Now it's reversed. I'm
thinking that we need a way to not have a check. Function tracing is
*extremely* invasive. As I said, this gets called *by* rcu_read_lock()!
I'm not sure we want checks involved here.

-- Steve

> [   16.210023]  [<c107d59d>] ftrace_ops_list_func+0x82/0xca
> [   16.210023]  [<c1050ce8>] ? sub_preempt_count+0x5/0xf1
> [   16.210023]  [<c13e5699>] trace+0x13/0x1b
> [   16.210023]  [<c10318ec>] ? _local_bh_enable_ip+0x141/0x166
> [   16.210023]  [<c1050ced>] ? sub_preempt_count+0xa/0xf1
> [   16.210023]  [<c1031849>] _local_bh_enable_ip+0x9e/0x166
> [   16.210023]  [<c1077fea>] ? rcu_torture_writer+0xa1/0x1c5
> [   16.220592]  [<c1031bc4>] local_bh_enable_ip+0xd/0xf
> [   16.220592]  [<c13e3ff9>] _raw_spin_unlock_bh+0x34/0x37
> [   16.220592]  [<c1077fea>] rcu_torture_writer+0xa1/0x1c5
> [   16.220592]  [<c104544f>] kthread+0x6c/0x71
> [   16.220592]  [<c1077f49>] ? rcu_torture_barrier_cbs+0x199/0x199
> [   16.220592]  [<c10453e3>] ? insert_kthread_work+0xa8/0xa8
> [   16.220592]  [<c13e5662>] kernel_thread_helper+0x6/0x10
> 
> Thanks,
> Fengguang


