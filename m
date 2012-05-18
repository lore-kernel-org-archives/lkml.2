Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab2ERAA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:00:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52491 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2ERAAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:00:55 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 7/8 v2] mfd: tps65910-irq: Add devicetree init support
To: Rhyland Klein <rklein@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
In-Reply-To: <1335310570-12455-8-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com> <1335310570-12455-8-git-send-email-rklein@nvidia.com>
Date: Thu, 17 May 2012 18:00:53 -0600
Message-Id: <20120518000053.6B3C03E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012 16:36:09 -0700, Rhyland Klein <rklein@nvidia.com> wrote:
> Add support for initializing when boot using devicetree. The main difference
> is that the irq_base will not be setup, so it needs to be manually handled.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  v2: split off irq specific changes based on previous review comments
> 
>  drivers/mfd/tps65910-irq.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
> index 0f1ff7f..066a30f 100644
> --- a/drivers/mfd/tps65910-irq.c
> +++ b/drivers/mfd/tps65910-irq.c
> @@ -180,12 +180,6 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
>  		return -EINVAL;
>  	}
>  
> -	tps65910->irq_mask = 0xFFFFFF;
> -
> -	mutex_init(&tps65910->irq_lock);
> -	tps65910->chip_irq = irq;
> -	tps65910->irq_base = pdata->irq_base;
> -
>  	switch (tps65910_chip_id(tps65910)) {
>  	case TPS65910:
>  		tps65910->irq_num = TPS65910_NUM_IRQ;
> @@ -195,6 +189,21 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
>  		break;
>  	}
>  
> +	if (pdata->irq_base <= 0)
> +		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);

Actually, if irqs are being dynamically allocated, then a irq_domain
linear mapping should be used instead of the legacy one so that sparse
allocations can be used.  The api isn't particularly friendly for that
right now because it means conditionally calling either
irq_domain_add_legacy() vs. irq_domain_add_linear(), but I'll try to
tidy that up for the next merge window.

Regardless, please use the linear mapping when irq_base is not set.

g.

