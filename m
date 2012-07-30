Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2G3Ppa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:45:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab2G3PpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:45:11 -0400
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
From: Steven Rostedt <srostedt@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20120724090720.GA10434@localhost>
References: <20120724090330.GA9830@localhost>
	 <20120724090720.GA10434@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 30 Jul 2012 11:45:05 -0400
Message-ID: <1343663105.3847.7.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 17:07 +0800, Fengguang Wu wrote:
> On Tue, Jul 24, 2012 at 05:03:30PM +0800, Fengguang Wu wrote:

> And this warning shows up in one of the dozens of boots, for the same
> kconfig.
> 
> [    2.320434] Testing tracer wakeup: PASSED
> [    2.840288] Testing tracer wakeup_rt: .. no entries found ..FAILED!
> [    3.280861] ------------[ cut here ]------------
> [    3.281967] WARNING: at /c/kernel-tests/src/linux/kernel/trace/trace.c:834 register_tracer+0x1b0/0x270()
> [    3.284162] Hardware name: Bochs
> [    3.284933] Modules linked in:
> [    3.285695] Pid: 1, comm: swapper/0 Not tainted 3.5.0+ #1371
> [    3.287032] Call Trace:
> [    3.287626]  [<41035c32>] warn_slowpath_common+0x72/0xa0
> [    3.288938]  [<410e7dd0>] ? register_tracer+0x1b0/0x270
> [    3.290280]  [<410e7dd0>] ? register_tracer+0x1b0/0x270
> [    3.291516]  [<41035c82>] warn_slowpath_null+0x22/0x30
> [    3.292723]  [<410e7dd0>] register_tracer+0x1b0/0x270
> [    3.293921]  [<41434c7a>] ? init_irqsoff_tracer+0x11/0x11
> [    3.295269]  [<41434c95>] init_wakeup_tracer+0x1b/0x1d
> [    3.296464]  [<41001112>] do_one_initcall+0x112/0x160
> [    3.297639]  [<4141fadd>] kernel_init+0xf7/0x18e
> [    3.298724]  [<4141f455>] ? do_early_param+0x7a/0x7a
> [    3.299879]  [<4141f9e6>] ? start_kernel+0x375/0x375
> [    3.301093]  [<412b15c2>] kernel_thread_helper+0x6/0x10
> [    3.302352] ---[ end trace 57f7151f6a5def05 ]---
> 

The comment above this test shows:

	 * Yes this is slightly racy. It is possible that for some
	 * strange reason that the RT thread we created, did not
	 * call schedule for 100ms after doing the completion,
	 * and we do a wakeup on a task that already is awake.
	 * But that is extremely unlikely, and the worst thing that
	 * happens in such a case, is that we disable tracing.
	 * Honestly, if this race does happen something is horrible
	 * wrong with the system.

I guess the question now is, why didn't the RT test wake up?

Oh wait! You did this on a virt machine. This test isn't designed for
virt machines because the thread could have woken on another vcpu, but
due to scheduling of the host system, it didn't get to run for 100ms,
thus the test will fail because it never recorded the wakeup of the RT
task.

In other-words, the test is bogus on virt boxes :-/

-- Steve


