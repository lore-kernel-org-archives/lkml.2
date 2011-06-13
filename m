Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1FMKl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:41:58 -0400
Received: from service87.mimecast.com ([94.185.240.25]:46055 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750826Ab1FMKlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:41:55 -0400
Date: Mon, 13 Jun 2011 11:41:45 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] ARM: gic: Use cpu pm notifiers to save gic state
Message-ID: <20110613104145.GA8230@e102568-lin.cambridge.arm.com>
References: <1307925825-28566-1-git-send-email-ccross@android.com>
 <1307925825-28566-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
In-Reply-To: <1307925825-28566-3-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Jun 2011 10:42:26.0028 (UTC) FILETIME=[95C31AC0:01CC29B6]
X-MC-Unique: 111061311415102801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Mon, Jun 13, 2011 at 01:43:44AM +0100, Colin Cross wrote:
> When the cpu is powered down in a low power mode, the gic cpu
> interface may be reset, and when the cpu complex is powered
> down, the gic distributor may also be reset.
> 
> This patch uses CPU_PM_ENTER and CPU_PM_EXIT notifiers to save
> and restore the gic cpu interface registers, and the
> CPU_COMPLEX_PM_ENTER and CPU_COMPLEX_PM_EXIT notifiers to save
> and restore the gic distributor registers.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/common/gic.c |  212 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 212 insertions(+), 0 deletions(-)
> 

[...]

> +
> +static void __init gic_cpu_pm_init(struct gic_chip_data *gic)
> +{
> +	gic->saved_ppi_enable = __alloc_percpu(DIV_ROUND_UP(32, 32) * 4,
> +		sizeof(u32));
> +	BUG_ON(!gic->saved_ppi_enable);
> +
> +	gic->saved_ppi_conf = __alloc_percpu(DIV_ROUND_UP(32, 16) * 4,
> +		sizeof(u32));
> +	BUG_ON(!gic->saved_ppi_conf);
> +
> +	gic->saved_ppi_pri = __alloc_percpu(DIV_ROUND_UP(32, 4) * 4,
> +		sizeof(u32));
> +	BUG_ON(!gic->saved_ppi_pri);
> +
> +	cpu_pm_register_notifier(&gic_notifier_block);
> +}
> +#else
> +static void __init gic_cpu_pm_init(struct gic_chip_data *gic)
> +{
> +}
> +#endif
> +
>  void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
>  	void __iomem *dist_base, void __iomem *cpu_base)
>  {
> @@ -367,6 +578,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
>  
>  	gic_dist_init(gic, irq_start);
>  	gic_cpu_init(gic);
> +	gic_cpu_pm_init(gic);
>  }
>  
> 

I have been using this patchset for a while and it works perfectly fine.
I reckon one bit we could improve is allowing to register a subsystem depending
on a flag set @init, for now it is a save "all default registered subsystems or nothing" solution on cpu_pm_enter(), maybe we could add this level of
configurability as an improvement (GIC being a good example, see OMAP).

Lorenzo

