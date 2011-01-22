Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1AVLNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:13:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44172 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1AVLNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:13:13 -0500
Date: Sat, 22 Jan 2011 12:13:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Don't copy per_cpu cpuinfo for BSP two times
Message-ID: <20110122111307.GA11256@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <4D3A16F2.5090902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D3A16F2.5090902@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 03:29:54PM -0800, Yinghai Lu wrote:
> 
> smp_store_cpu_info(0) will do that.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/smpboot.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6/arch/x86/kernel/smpboot.c
> @@ -1071,13 +1071,13 @@ void __init native_smp_prepare_cpus(unsi
>  
>  	preempt_disable();
>  	smp_cpu_index_default();
> -	memcpy(__this_cpu_ptr(&cpu_info), &boot_cpu_data, sizeof(cpu_info));
> -	cpumask_copy(cpu_callin_mask, cpumask_of(0));
> -	mb();
> +
>  	/*
>  	 * Setup boot CPU information
>  	 */
>  	smp_store_cpu_info(0); /* Final full version of the data */
> +	cpumask_copy(cpu_callin_mask, cpumask_of(0));
> +	mb();

Question: why do we need the memory barrier there? We're running on the
BSP and long before smp_init() to be all careful about the callin_mask.
It could be there as a left over from the 32 and 64-bit merge, AFAICT
from git history...

Thanks.

-- 
Regards/Gruss,
    Boris.
