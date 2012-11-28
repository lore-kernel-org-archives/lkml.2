Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2K1USL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:18:11 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44391 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752896Ab2K1USJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:18:09 -0500
Date: Wed, 28 Nov 2012 22:18:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v3 2/3] davinci: vpss: dm365: set vpss clk ctrl
Message-ID: <20121128201804.GI31879@valkosipuli.retiisi.org.uk>
References: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
 <1354100134-21095-3-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354100134-21095-3-git-send-email-prabhakar.lad@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Wed, Nov 28, 2012 at 04:25:33PM +0530, Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> request_mem_region for VPSS_CLK_CTRL register and ioremap.
> and enable clocks appropriately.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> ---
>  drivers/media/platform/davinci/vpss.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
> index 34ad7bd..a36d694 100644
> --- a/drivers/media/platform/davinci/vpss.c
> +++ b/drivers/media/platform/davinci/vpss.c
> @@ -103,6 +103,7 @@ struct vpss_hw_ops {
>  struct vpss_oper_config {
>  	__iomem void *vpss_regs_base0;
>  	__iomem void *vpss_regs_base1;
> +	resource_size_t *vpss_regs_base2;
>  	enum vpss_platform_type platform;
>  	spinlock_t vpss_lock;
>  	struct vpss_hw_ops hw_ops;
> @@ -484,11 +485,24 @@ static struct platform_driver vpss_driver = {
>  
>  static void vpss_exit(void)
>  {
> +	iounmap(oper_cfg.vpss_regs_base2);
> +	release_mem_region(*oper_cfg.vpss_regs_base2, 4);

release_mem_region(VPSS_CLK_CTRL, 4);?

>  	platform_driver_unregister(&vpss_driver);
>  }
>  
> +#define VPSS_CLK_CTRL			0x01c40044
> +#define VPSS_CLK_CTRL_VENCCLKEN		BIT(3)
> +#define VPSS_CLK_CTRL_DACCLKEN		BIT(4)
> +
>  static int __init vpss_init(void)
>  {
> +	if (request_mem_region(VPSS_CLK_CTRL, 4, "vpss_clock_control")) {

if (!request_mem_region())
	return -EBUSY;

...

> +		oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
> +		__raw_writel(VPSS_CLK_CTRL_VENCCLKEN |
> +			     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
> +	} else {
> +		return -EBUSY;
> +	}
>  	return platform_driver_register(&vpss_driver);
>  }
>  subsys_initcall(vpss_init);

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
