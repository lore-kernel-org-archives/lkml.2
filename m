Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2KUSuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:50:20 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:23519 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755497Ab2KUSuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:50:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 67.169.73.11
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18GsU9378F3VdciLGt2E/p7
Date: Wed, 21 Nov 2012 10:50:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>, Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH v5 4/5] iommu/omap: adapt to runtime pm
Message-ID: <20121121185002.GB18567@atomide.com>
References: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
 <1353373552-16039-5-git-send-email-omar.luna@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353373552-16039-5-git-send-email-omar.luna@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Omar Ramirez Luna <omar.luna@linaro.org> [121119 17:08]:
> Use runtime PM functionality interfaced with hwmod enable/idle
> functions, to replace direct clock operations and sysconfig
> handling.
> 
> Due to reset sequence, pm_runtime_[get|put]_sync must be used, to
> avoid possible operations with the module under reset. Because of
> this and given that the driver uses spin_locks to protect their
> critical sections, we must use pm_runtime_irq_safe in order for the
> runtime ops to be happy, otherwise might_sleep_if checks in runtime
> framework will complain.
> 
> The remaining pm_runtime out of iommu_enable and iommu_disable
> corresponds to paths that can be accessed through debugfs, some of
> them doesn't work if the module is not enabled first, but in future
> if the mmu is idled withouth freeing, these are needed to debug.
> 
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
> ---
>  arch/arm/mach-omap2/omap-iommu.c         |    1 -
>  drivers/iommu/omap-iommu.c               |   40 ++++++++++++++---------------
>  drivers/iommu/omap-iommu.h               |    3 --
>  drivers/iommu/omap-iommu2.c              |   17 ------------
>  include/linux/platform_data/iommu-omap.h |    1 -
>  5 files changed, 19 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
> index 02726a6..7642fc4 100644
> --- a/arch/arm/mach-omap2/omap-iommu.c
> +++ b/arch/arm/mach-omap2/omap-iommu.c
> @@ -31,7 +31,6 @@ static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
>  		return -ENOMEM;
>  
>  	pdata->name = oh->name;
> -	pdata->clk_name = oh->main_clk;
>  	pdata->nr_tlb_entries = a->nr_tlb_entries;
>  	pdata->da_start = a->da_start;
>  	pdata->da_end = a->da_end;

The runtime PM related changes would be good to be checked
by Kevin, added him to cc. For the arch/arm/mach-omap2/ change above:

Acked-by: Tony Lindgren <tony@atomide.com>
