Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab1F1R00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:26:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48441 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab1F1RZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:25:17 -0400
Date: Tue, 28 Jun 2011 10:25:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [next][bug] rcu_dyntick_kick_cpu() kills ARM SMP.
Message-ID: <20110628172513.GB2294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4E09EE75.9040204@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E09EE75.9040204@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 04:08:37PM +0100, Marc Zyngier wrote:
> Paul,
> 
> I've updated my -next tree (to next-20110628) today, and discovered 
> that my favorite ARM board wouldn't boot anymore:
> 
> [...]
> Hierarchical RCU implementation.
> NR_IRQS:128 nr_irqs:128 128
> Console: colour dummy device 80x30
> Calibrating delay loop... 83.35 BogoMIPS (lpj=416768)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> CPU: Testing write buffer coherency: ok
> Calibrating local timer... 104.04MHz.
> CPU1: Booted secondary processor
> CPU1: Unknown IPI message 0x1
> CPU2: Booted secondary processor
> CPU2: Unknown IPI message 0x1
> CPU3: Booted secondary processor
> CPU3: Unknown IPI message 0x1
> Brought up 4 CPUs
> SMP: Total of 4 processors activated (333.92 BogoMIPS).
> ------------[ cut here ]------------
> WARNING: at kernel/smp.c:320 smp_call_function_single+0xe4/0x1c0()
> NET: Registered protocol family 16
> Modules linked in:
> [<c00415d4>] (unwind_backtrace+0x0/0xf4) from [<c0056184>] (warn_slowpath_common+0x4c/0x64)
> [<c0056184>] (warn_slowpath_common+0x4c/0x64) from [<c00561b8>] (warn_slowpath_null+0x1c/0x24)
> [<c00561b8>] (warn_slowpath_null+0x1c/0x24) from [<c0088218>] (smp_call_function_single+0xe4/0x1c0)
> [<c0088218>] (smp_call_function_single+0xe4/0x1c0) from [<c0094804>] (rcu_start_gp+0x184/0x310)
> [<c0094804>] (rcu_start_gp+0x184/0x310) from [<c00955b0>] (__rcu_process_callbacks+0x274/0x398)
> [<c00955b0>] (__rcu_process_callbacks+0x274/0x398) from [<c0095708>] (rcu_process_callbacks+0x34/0x5c)
> [<c0095708>] (rcu_process_callbacks+0x34/0x5c) from [<c005c964>] (__do_softirq+0xa4/0x16c)
> [<c005c964>] (__do_softirq+0xa4/0x16c) from [<c005cc0c>] (irq_exit+0x80/0x9c)
> [<c005cc0c>] (irq_exit+0x80/0x9c) from [<c00353cc>] (do_local_timer+0x54/0x70)
> [<c00353cc>] (do_local_timer+0x54/0x70) from [<c003b618>] (__irq_svc+0x38/0xc0)
> Exception stack(0xdf467f90 to 0xdf467fd8)
> 7f80:                                     df466000 00000000 df467fd8 00000000
> 7fa0: df466000 c045dd24 c034f6cc 00000000 c0445514 410fb020 70409ddc 00000000
> 7fc0: 00000000 df467fd8 c003c4ac c003c4b0 60000013 ffffffff
> [<c003b618>] (__irq_svc+0x38/0xc0) from [<c003c4b0>] (default_idle+0x24/0x28)
> [<c003c4b0>] (default_idle+0x24/0x28) from [<c003ccd0>] (cpu_idle+0x9c/0xdc)
> [<c003ccd0>] (cpu_idle+0x9c/0xdc) from [<70348734>] (0x70348734)
> ---[ end trace 1b75b31a2719ed1c ]---
> 
> ... and here it dies.
> 
> The offending commit is b983032b7 (rcu: Avoid grace-period overflow for 
> long dyntick-idle periods). rcu_dyntick_kick_cpu() tries to do a CPU 
> cross-call with interrupts disabled, which kills the box. Reverting this
> patch results in a working system.

That does sound problematic...

> My RCU-foo being rather low, I haven't dug deeper into this. Please let
> me know if you want me to test anything.

I will put together a patch to defer the actual cross-call until irqs
are enabled.  The call would be from softirq -- that is OK, correct?

And thank you for testing this!

							Thanx, Paul
