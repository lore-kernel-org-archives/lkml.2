Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1BWRiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:38:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1BWRiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:38:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f2gSTqQBdg9Zz+1nmVaXbZ8un8uqg46MrRml2DjjfwsvpljMlnJCi/STyU0nkJwzoU
         dIVy7yUQYIG2ncZA+SDw==
MIME-Version: 1.0
In-Reply-To: <1298481080-27120-1-git-send-email-swarren@nvidia.com>
References: <1298481080-27120-1-git-send-email-swarren@nvidia.com>
Date: Wed, 23 Feb 2011 09:35:50 -0800
X-Google-Sender-Auth: ldGRbsOIbR7EoNyBLw70slaQwh0
Message-ID: <AANLkTikcO=VH3R5KaxCSJoEyKdueO+Tcr13a9KSJ6MM1@mail.gmail.com>
Subject: Re: [PATCH] ARM: Tegra: Make tegra_dma_init a postcore_initcall
From: Colin Cross <ccross@android.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, olof@lixom.net,
        konkers@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 9:11 AM, Stephen Warren <swarren@nvidia.com> wrote:
> The following commit makes the Tegra APB DMA engine fail to initialize
> correctly: 0cf6230af909a86f81907455eca2a5c9b8f68fe6
> ARM: tegra: Move tegra_common_init to tegra_init_early
>
> The reason is that tegra_init_early_ calls tegra_dma_init which calls
> request_threaded_irq, which fails since the IRQ hasn't yet been marked
> valid; that only happens in tegra_init_irq, which gets called after
> tegra_init_early.
>
> This used to work OK, since tegra_init_early was tegra_common_init, which
> got called after tegra_init_irq, basically from the beginning of
> tegra_harmony_init.
>
> Solve this by converting tegra_dma_init to a postcore_initcall. This makes
> it execute late enough that IRQs are marked valid, and avoids having to
> add it back to every machine's init function.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/mach-tegra/common.c |    3 ---
>  arch/arm/mach-tegra/dma.c    |    1 +
>  2 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
> index 516e100..b6ab3f8 100644
> --- a/arch/arm/mach-tegra/common.c
> +++ b/arch/arm/mach-tegra/common.c
> @@ -81,7 +81,4 @@ void __init tegra_init_early(void)
>        tegra_init_clock();
>        tegra_clk_init_from_table(common_clk_init_table);
>        tegra_init_cache();
> -#ifdef CONFIG_TEGRA_SYSTEM_DMA
> -       tegra_dma_init();
> -#endif
>  }

Can you also drop the #include <mach/dma.h> from common.c?
