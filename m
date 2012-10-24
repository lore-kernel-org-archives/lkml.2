Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2JXKqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:46:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44190 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab2JXKqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:46:15 -0400
Date: Wed, 24 Oct 2012 12:46:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andre Przywara <andre.przywara@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com
Subject: Re: [PATCH] x86/amd: disable way access filter on affected CPUs
Message-ID: <20121024104609.GA13010@gmail.com>
References: <1351065377-1989-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351065377-1989-1-git-send-email-andre.przywara@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andre Przywara <andre.przywara@amd.com> wrote:

> The WAF may hurt the performance of some workloads, caused by
> aliasing issues in the L1 cache.
> Disable it on the affected CPUs.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index f7e98a2..1b7d165 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -631,6 +631,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  		}
>  	}
>  
> +	/*
> +	 * The way access filter has a performance penalty on some workloads.
> +	 * Disable it on the affected CPUs.
> +	 */
> +	if ((c->x86 == 0x15) &&
> +	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
> +		u64 val;
> +
> +		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
> +			val |= 0x1E;
> +			wrmsrl_safe(0xc0011021, val);
> +		}
> +	}

Would be nice to hear more about the background of this change, 
about the amount of 'penalty' and the nature of the workloads. 
Also, it would be useful to know how the [0x02..0x1f] model 
range was chosen.

Thanks,

	Ingo
