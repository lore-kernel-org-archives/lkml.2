Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2GaMSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:18:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:26496 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2GaMSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:18:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="191093612"
Date: Tue, 31 Jul 2012 20:17:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
Message-ID: <20120731121759.GA17822@localhost>
References: <20120724090330.GA9830@localhost>
 <20120724090720.GA10434@localhost>
 <1343663105.3847.7.camel@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343663105.3847.7.camel@fedora>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC kvm developers]

On Mon, Jul 30, 2012 at 11:45:05AM -0400, Steven Rostedt wrote:
> On Tue, 2012-07-24 at 17:07 +0800, Fengguang Wu wrote:
> > On Tue, Jul 24, 2012 at 05:03:30PM +0800, Fengguang Wu wrote:
> 
> > And this warning shows up in one of the dozens of boots, for the same
> > kconfig.
> > 
> > [    2.320434] Testing tracer wakeup: PASSED
> > [    2.840288] Testing tracer wakeup_rt: .. no entries found ..FAILED!
> > [    3.280861] ------------[ cut here ]------------
> > [    3.281967] WARNING: at /c/kernel-tests/src/linux/kernel/trace/trace.c:834 register_tracer+0x1b0/0x270()
> > [    3.284162] Hardware name: Bochs
> > [    3.284933] Modules linked in:
> > [    3.285695] Pid: 1, comm: swapper/0 Not tainted 3.5.0+ #1371
> > [    3.287032] Call Trace:
> > [    3.287626]  [<41035c32>] warn_slowpath_common+0x72/0xa0
> > [    3.288938]  [<410e7dd0>] ? register_tracer+0x1b0/0x270
> > [    3.290280]  [<410e7dd0>] ? register_tracer+0x1b0/0x270
> > [    3.291516]  [<41035c82>] warn_slowpath_null+0x22/0x30
> > [    3.292723]  [<410e7dd0>] register_tracer+0x1b0/0x270
> > [    3.293921]  [<41434c7a>] ? init_irqsoff_tracer+0x11/0x11
> > [    3.295269]  [<41434c95>] init_wakeup_tracer+0x1b/0x1d
> > [    3.296464]  [<41001112>] do_one_initcall+0x112/0x160
> > [    3.297639]  [<4141fadd>] kernel_init+0xf7/0x18e
> > [    3.298724]  [<4141f455>] ? do_early_param+0x7a/0x7a
> > [    3.299879]  [<4141f9e6>] ? start_kernel+0x375/0x375
> > [    3.301093]  [<412b15c2>] kernel_thread_helper+0x6/0x10
> > [    3.302352] ---[ end trace 57f7151f6a5def05 ]---
> > 
> 
> The comment above this test shows:
> 
> 	 * Yes this is slightly racy. It is possible that for some
> 	 * strange reason that the RT thread we created, did not
> 	 * call schedule for 100ms after doing the completion,
> 	 * and we do a wakeup on a task that already is awake.
> 	 * But that is extremely unlikely, and the worst thing that
> 	 * happens in such a case, is that we disable tracing.
> 	 * Honestly, if this race does happen something is horrible
> 	 * wrong with the system.
> 
> I guess the question now is, why didn't the RT test wake up?
> 
> Oh wait! You did this on a virt machine. This test isn't designed for
> virt machines because the thread could have woken on another vcpu, but
> due to scheduling of the host system, it didn't get to run for 100ms,
> thus the test will fail because it never recorded the wakeup of the RT
> task.
> 
> In other-words, the test is bogus on virt boxes :-/

It's good to quickly get to the root cause :) Can we possibly detect
whether we are in a virtual machine and hence skip this particular
test case?

Thanks,
Fengguang
