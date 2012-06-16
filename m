Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2FPQc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 12:32:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40334 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2FPQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 12:32:56 -0400
Date: Sat, 16 Jun 2012 09:32:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 09/10] POWERPC: smp: remove call to
 ipi_call_lock()/ipi_call_unlock()
Message-ID: <20120616163219.GI2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
 <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061616-7408-0000-0000-000005E9217E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 03:16:04PM +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang@windriver.com>
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

However, there is an effort to get rid of stop_machine() from the
CPU-down path...  So something else will be needed.

							Thanx, Paul

> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/kernel/smp.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index e4cb343..e1417c4 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -571,7 +571,6 @@ void __devinit start_secondary(void *unused)
>  	if (system_state == SYSTEM_RUNNING)
>  		vdso_data->processorCount++;
>  #endif
> -	ipi_call_lock();
>  	notify_cpu_starting(cpu);
>  	set_cpu_online(cpu, true);
>  	/* Update sibling maps */
> @@ -601,7 +600,6 @@ void __devinit start_secondary(void *unused)
>  		of_node_put(np);
>  	}
>  	of_node_put(l2_cache);
> -	ipi_call_unlock();
> 
>  	local_irq_enable();
> 
> -- 
> 1.7.5.4
> 

