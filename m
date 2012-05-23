Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab2EWRp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:45:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33647 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760655Ab2EWRp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:45:56 -0400
Message-ID: <4FBD2248.3000404@ti.com>
Date: Wed, 23 May 2012 10:45:44 -0700
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120509 Thunderbird/13.0
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>, <mporter@ti.com>
Subject: Re: [PATCH] [ARM] Unconditional call to smp_cross_call on UP crashes
References: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 10:09 AM, Pantelis Antoniou wrote:
> omap2plus_defconfig builds with SMP & SMP_ON_UP set.
> On beagle (which is UP) is_smp() returns false and we don't call
> smp_init_cpus which in turn does not initialize smp_cross_call which
> remains NULL.
>
> When issuing a reboot we OOPS with a NULL dereference on stop smp_call.
>
> Fixed by checking is_smp in smp_send_stop()
> ---
>  arch/arm/kernel/smp.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Acked-by: Russ.Dill@ti.com

> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 8f46446..2a61335 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -588,6 +588,10 @@ void smp_send_stop(void)
>  	unsigned long timeout;
>  	struct cpumask mask;
>  
> +	/* make sure we don't bother if not SMP */
> +	if (!is_smp())
> +		return;
> +
>  	cpumask_copy(&mask, cpu_online_mask);
>  	cpumask_clear_cpu(smp_processor_id(), &mask);
>  	smp_cross_call(&mask, IPI_CPU_STOP);


