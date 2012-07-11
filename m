Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2GKM4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:56:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:35058 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2GKM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175994494"
Date: Wed, 11 Jul 2012 20:55:59 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120711125559.GA27383@localhost>
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
 <20120711123616.GA27086@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711123616.GA27086@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 08:36:16PM +0800, Fengguang Wu wrote:
> On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> > On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > > Hi Paul,
> > > 
> > > Fortunately this bug is bisectable and the first bad commit is:
> > > 
> > >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> > >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > > 
> > >             rcu: Track idleness independent of idle tasks
> > 
> > OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> > traces while in idle.  The confusion on my part was that in TREE_RCU,
> > the nesting and dyntick-idle indication are different, while in
> > TINY_RCU they are one and the same.
> > 
> > Does the following patch help?
> 
> Not exactly, but the error message is now changed to:

Then I think it may help to test the linux-next tree that contains
latest RCU fixes. And it somehow helped. There are no warnings in
the linux-next tree 1 or 2 days ago; there is a maybe unrelated warning
in today's linux-next tree.

[    0.013241] Performance Events: 
[    0.014222] ------------[ cut here ]------------
[    0.014975] WARNING: at /c/wfg/linux/kernel/workqueue.c:1217 worker_enter_idle+0x2fa/0x37c()
[    0.016000] Hardware name: Bochs
[    0.016000] Modules linked in:
[    0.016000] Pid: 1, comm: swapper Not tainted 3.5.0-rc6-next-20120710+ #58
[    0.016000] Call Trace:
[    0.016000]  [<c10374bc>] warn_slowpath_common+0xfc/0x13b
[    0.016000]  [<c106530f>] ? worker_enter_idle+0x2fa/0x37c
[    0.016000]  [<c106530f>] ? worker_enter_idle+0x2fa/0x37c
[    0.016000]  [<c1037539>] warn_slowpath_null+0x3e/0x4e
[    0.016000]  [<c106530f>] worker_enter_idle+0x2fa/0x37c
[    0.016000]  [<c143d177>] ? _raw_spin_lock_irq+0xc3/0xe5
[    0.016000]  [<c10653bb>] start_worker+0x2a/0x51
[    0.016000]  [<c174ec11>] init_workqueues+0x29f/0x656
[    0.016000]  [<c174e972>] ? usermodehelper_init+0xac/0xac
[    0.016000]  [<c1001145>] do_one_initcall+0xf7/0x272
[    0.016000]  [<c1124cb6>] ? trace_preempt_on+0x1c/0x7c
[    0.016000]  [<c173d60e>] kernel_init+0x1a4/0x4da
[    0.016000]  [<c173d46a>] ? start_kernel+0x8ff/0x8ff
[    0.016000]  [<c144a942>] kernel_thread_helper+0x6/0x10
[    0.016000] ---[ end trace 50864a5de9c2f446 ]---
[    0.020353] Testing tracer nop: PASSED

Both trees freeze after this point:

modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6-next-20120710+/modules.dep: No such file or directory
^M
modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6-next-20120710+/modules.dep: No such file or directory
^M
[   31.223314] CPA self-test:
[   31.224750]  4k 3069 large 61 gb 0 x 3130[c0000000-cfffc000] miss 0
[   31.239798]  4k 65533 large 0 gb 0 x 65533[c0000000-cfffc000] miss 0
[   31.249441]  4k 65533 large 0 gb 0 x 65533[c0000000-cfffc000] miss 0
[   31.250402] ok.

So I'd better to base the test on one of your RCU branches..
Which branch would your recommend?

Thanks,
Fengguang
