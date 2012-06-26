Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2FZX1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:27:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46656 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2FZX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:27:03 -0400
Date: Tue, 26 Jun 2012 16:26:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch V2 0/7] Per cpu thread hotplug infrastructure
Message-ID: <20120626232620.GA24468@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615140217.933711648@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615140217.933711648@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062623-6148-0000-0000-00000718398F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:13:19PM -0000, Thomas Gleixner wrote:
> The following series implements the infrastructure for parking and
> unparking kernel threads to avoid the full teardown and fork on cpu
> hotplug operations along with management infrastructure for hotplug
> and users.
> 
> Changes since V1:
> 
>  - Addressed the review comments
>  - Fixed a missing state update in parkme (reported by Paul)
>  - Simplified rcu_yield()
>  - Added Pauls RCU conversion
> 
> Full diffstat below. Due to the RCU cleanup we now remove more code
> than we add. :)

;-)

With the exception of a build error for CONFIG_SMP=y:

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I finally tracked down a hang, which turned out to be an unrelated bug
of mine that happened to be triggered more reliably with these patches
applied, hence the delay.  Sigh!

For CONFIG_SMP=y:

softirq.c:(.text+0xa6d3): undefined reference to `smpboot_thread_check_parking'
softirq.c:(.init.text+0x4aa): undefined reference to `smpboot_register_percpu_thread'
softirq.c:(.text+0xb763): undefined reference to `smpboot_thread_check_parking'
softirq.c:(.init.text+0x48e): undefined reference to `smpboot_register_percpu_thread'

My approach would be to make smpboot.o be unconditionally created by
kernel/Makefile and to use conditional compilation as needed.  The real
question is whether we want to allow parking in !SMP kernels.  I cannot
see why we wouldn't -- there might be other reasons to park besides
CPU hotplug.  Thoughts?

							Thanx, Paul

> Thanks,
> 
> 	tglx
> ---
>  drivers/infiniband/hw/ehca/ehca_irq.c |  240 ++++++++-------------
>  drivers/infiniband/hw/ehca/ehca_irq.h |    5 
>  include/linux/kthread.h               |   11 
>  include/linux/smpboot.h               |   40 +++
>  kernel/cpu.c                          |   10 
>  kernel/kthread.c                      |  184 ++++++++++++++--
>  kernel/rcutree.c                      |   12 -
>  kernel/rcutree.h                      |   15 -
>  kernel/rcutree_plugin.h               |  375 +++++-----------------------------
>  kernel/rcutree_trace.c                |    3 
>  kernel/smpboot.c                      |  206 ++++++++++++++++++
>  kernel/smpboot.h                      |    4 
>  kernel/softirq.c                      |   84 +------
>  kernel/watchdog.c                     |  232 ++++++---------------
>  14 files changed, 678 insertions(+), 743 deletions(-)
> 

