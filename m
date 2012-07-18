Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2GRVTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:19:04 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38111 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2GRVTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:19:01 -0400
Message-ID: <500727F1.4000609@linux.vnet.ibm.com>
Date: Thu, 19 Jul 2012 02:47:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Lameter <cl@gentwo.org>, Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH v2] x86, mm: only wait for flushes from online cpus
References: <1340402778-28939-1-git-send-email-msb@chromium.org>
In-Reply-To: <1340402778-28939-1-git-send-email-msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071821-4790-0000-0000-000003BFDD5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 03:36 AM, Mandeep Singh Baines wrote:
> A cpu in the mm_cpumask could go offline before we send the invalidate
> IPI causing us to wait forever. Avoid this by only waiting for online
> cpus.
> 
> We are seeing a softlockup reporting during shutdown. The stack
> trace shows us that we are inside default_send_IPI_mask_logical:
> 
[...]
> Changes in V2:
>   * bitmap_and is not atomic so use a temporary bitmask
> 

Looks like I posted my reply to v1. So I'll repeat the same suggestions in
this thread as well.

> ---
>  arch/x86/mm/tlb.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index d6c0418..231a0b9 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -185,6 +185,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
>  	f->flush_mm = mm;
>  	f->flush_va = va;
>  	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
> +		DECLARE_BITMAP(tmp_cpumask, NR_CPUS);
> +
>  		/*
>  		 * We have to send the IPI only to
>  		 * CPUs affected.
> @@ -192,8 +194,13 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
>  		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
>  			      INVALIDATE_TLB_VECTOR_START + sender);
> 

This function is always called with preempt_disabled() right?
In that case, _while_ this function is running, a CPU cannot go offline
because of stop_machine(). (I understand that it might go offline in between
calculating that cpumask and calling preempt_disable() - which is the race
you are trying to handle).

So, why not take the offline cpus out of the way even before sending that IPI?
That way, we need not modify the while loop below.

> -		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
> +		/* Only wait for online cpus */
> +		do {
> +			cpumask_and(to_cpumask(tmp_cpumask),
> +				    to_cpumask(f->flush_cpumask),
> +				    cpu_online_mask);
>  			cpu_relax();
> +		} while (!cpumask_empty(to_cpumask(tmp_cpumask)));
>  	}
> 
>  	f->flush_mm = NULL;
> 

That is, how about something like this:

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5e57e11..9d387a9 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -186,7 +186,11 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 
        f->flush_mm = mm;
        f->flush_va = va;
-       if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
+
+       cpumask_and(to_cpumask(f->flush_cpumask), cpumask, cpu_online_mask);
+       cpumask_clear_cpu(smp_processor_id(), to_cpumask(f->flush_cpumask));
+
+       if (!cpumask_empty(to_cpumask(f->flush_cpumask))) {
                /*
                 * We have to send the IPI only to
                 * CPUs affected.


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

