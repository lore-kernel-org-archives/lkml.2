Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2FPQbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 12:31:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39359 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2FPQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 12:30:58 -0400
Date: Sat, 16 Jun 2012 09:30:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 00/10] Cleanup
 ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
Message-ID: <20120616163050.GH2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061616-6148-0000-0000-000006C25475
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 03:15:55PM +0800, Yong Zhang wrote:
> As discussed with Srivatsa [1], it seems there is no need to keep
> ipi_call_[un]lock_irq() when cpu bring-up/down. Because:
> 
> 1) call_function.lock used in smp_call_function_many() is just to protect
>    call_function.queue and &data->refs, cpu_online_mask is outside of the
>    lock. And it's not necessary to protect cpu_online_mask,
>    because data->cpumask is pre-calculate and even if a cpu is brougt up
>    when calling arch_send_call_function_ipi_mask(), it's harmless because
>    validation test in generic_smp_call_function_interrupt() will take care
>    of it.
> 
> 2) For cpu down issue, stop_machine() will guarantee that no concurrent
>    smp_call_fuction() is processing.
> 
> In short it's more likely that keeping ipi_call_[un]lock() is leftover
> before we introduce generic smp helper. This patchset is just to clean
> things up.

This series gets rid of the call_function lockdep splat I was seeing,
very good!

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> [1] http://marc.info/?l=linux-kernel&m=133766786814484&w=2
> 
> Yong Zhang (10):
>   hexagon: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   mn10300: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   parisc: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   S390: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   tile: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   x86: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   ia64: smp: remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()
>   SPARC: smp: remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()
>   POWERPC: smp: remove call to ipi_call_lock()/ipi_call_unlock()
>   smp: remove ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
> 
>  arch/hexagon/kernel/smp.c  |    2 --
>  arch/ia64/kernel/smpboot.c |    2 --
>  arch/mn10300/kernel/smp.c  |    2 --
>  arch/parisc/kernel/smp.c   |    2 --
>  arch/powerpc/kernel/smp.c  |    2 --
>  arch/s390/kernel/smp.c     |    2 --
>  arch/sparc/kernel/smp_64.c |    6 ++----
>  arch/tile/kernel/smpboot.c |   10 ----------
>  arch/x86/kernel/smpboot.c  |    9 ---------
>  arch/x86/xen/smp.c         |    2 --
>  include/linux/smp.h        |    4 ----
>  kernel/smp.c               |   20 --------------------
>  12 files changed, 2 insertions(+), 61 deletions(-)
> 
> -- 
> 1.7.5.4
> 

