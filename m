Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2HCJwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:52:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:22724 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2HCJv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192834177"
Date: Fri, 3 Aug 2012 17:51:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: uart_startup: GFP_KERNEL allocation with IRQs disabled
Message-ID: <20120803095151.GA16994@localhost>
References: <20120803014600.GA7886@localhost>
 <501B9BF1.2050006@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501B9BF1.2050006@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:37:53AM +0200, Jiri Slaby wrote:
> On 08/03/2012 03:46 AM, Fengguang Wu wrote:
> > Hi all,
> 
> Hi,
> 
> > The IRQ should be disabled somewhere in the path walk, which makes
> > the GFP_KERNEL allocation in uart_startup() no longer valid..
> > 
> > [    0.499537] kworker/u:1 (29) used greatest stack depth: 7156 bytes left
> > [    0.500947] ------------[ cut here ]------------
> > [    0.501445] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:2739 lockdep_trace_alloc+0x86/0xb2()
> > [    0.502413] Modules linked in:
> > [    0.502766] Pid: 1, comm: init Not tainted 3.5.0-01258-g1ade992 #182
> > [    0.503419] Call Trace:
> ...
> > [    0.504381]  [<c1079e7d>] get_zeroed_page+0xd/0xf
> > [    0.504381]  [<c10f976f>] uart_startup.part.8+0x46/0x152
> > [    0.504381]  [<c10f745f>] ? tty_port_tty_set+0x37/0x3c
> > [    0.504381]  [<c10fa175>] uart_open+0xc9/0x10b
> > [    0.504381]  [<c10fa0ac>] ? uart_suspend_port+0x229/0x229
> > [    0.504381]  [<c10f1bc2>] tty_open+0x26b/0x3d3
> > [    0.504381]  [<c109872a>] chrdev_open+0xf7/0x117
> 
> This does not make sense to me. I would not blame TTY/serial for this.
> There is somebody who forgot to enable interrupts somewhere. Could you
> enable DEBUG_ATOMIC_SLEEP? It might trigger earlier revealing us the
> culprit.

Jiri, thanks for the info. After turning on DEBUG_ATOMIC_SLEEP, this
shows up which I just reported in another email. Ah I didn't notice
that it's running the same commit "x86: switch to generic sys_execve
and kernel_execve"..

[    0.408108] BUG: sleeping function called from invalid context at /c/wfg/linux/kernel/rwsem.c:47
[    0.408966] in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: init
[    0.409556] no locks held by init/1.
[    0.409929] irq event stamp: 74784
[    0.410247] hardirqs last  enabled at (74783): [<c101e4e1>] do_page_fault+0x95/0x330
[    0.411015] hardirqs last disabled at (74784): [<c1158337>] resume_userspace+0x17/0x28
[    0.411759] softirqs last  enabled at (74726): [<c102a42e>] __do_softirq+0x109/0x12d
[    0.412011] softirqs last disabled at (74713): [<c10038f1>] do_softirq+0x5e/0xb3
[    0.412011] Pid: 1, comm: init Not tainted 3.5.0-01258-g1ade992 #60
[    0.412011] Call Trace:
[    0.412011]  [<c1025c95>] ? console_unlock+0x340/0x36d
[    0.412011]  [<c103fa89>] __might_sleep+0x159/0x161
[    0.412011]  [<c1156dc9>] down_write+0x17/0x40
[    0.412011]  [<c108c829>] sys_brk+0x21/0xe4
[    0.412011]  [<c115838d>] syscall_call+0x7/0xb

Thanks,
Fengguang
