Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2AFHN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 02:13:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16152 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2AFHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 02:13:57 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-8a-4f069f33908b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, "'Greg KH'" <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Kay Sievers'" <kay.sievers@vrfy.org>
References: <20120106175717.5c39c7f62d73889e29e9b764@canb.auug.org.au>
In-reply-to: <20120106175717.5c39c7f62d73889e29e9b764@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the driver-core tree with the arm tree
Date: Fri, 06 Jan 2012 16:13:53 +0900
Message-id: <031901cccc42$bf84a1b0$3e8de510$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczMQHIHp3M9/Zz3RVmFiJc2fC2rMgAAaTrA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-s5pv210/common.c between commit 1f34f0e2fb86 ("ARM: 7252/1:
> restart: S5PV210: use new restart hook") from the arm tree and commit
> 4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
> the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-s5pv210/common.c
> index 2622b8a,28e71ef..0000000
> --- a/arch/arm/mach-s5pv210/common.c
> +++ b/arch/arm/mach-s5pv210/common.c
> @@@ -231,38 -185,20 +232,38 @@@ static struct device s5pv210_dev =
> 
>   static int __init s5pv210_core_init(void)
>   {
> - 	return sysdev_class_register(&s5pv210_sysclass);
> + 	return subsys_system_register(&s5pv210_subsys, NULL);
>   }
>  -
>   core_initcall(s5pv210_core_init);
> 
>   int __init s5pv210_init(void)
>   {
>   	printk(KERN_INFO "S5PV210: Initializing architecture\n");
> - 	return sysdev_register(&s5pv210_sysdev);
> ++	return device_register(&s5pv210_dev);
>  +}
> 
>  -	/* set idle function */
>  -	pm_idle = s5pv210_idle;
>  +static struct s3c24xx_uart_clksrc s5pv210_serial_clocks[] = {
>  +	[0] = {
>  +		.name		= "pclk",
>  +		.divisor	= 1,
>  +		.min_baud	= 0,
>  +		.max_baud	= 0,
>  +	},
>  +};
> 
Hi,

Well, above is removed by commit afba7f91 ("ARM: SAMSUNG: remove struct
's3c24xx_uart_clksrc' and all uses of it"). But I'm not sure we don't need
to add it for current conflicts between driver-core and arm tree because the
commit afba7f91 is in arm-soc tree.

>  -	/* set sw_reset function */
>  -	s5p_reset_hook = s5pv210_sw_reset;
>  +/* uart registration process */
> 
>  -	return device_register(&s5pv210_dev);
>  +void __init s5pv210_init_uarts(struct s3c2410_uartcfg *cfg, int no)
>  +{
>  +	struct s3c2410_uartcfg *tcfg = cfg;
>  +	u32 ucnt;
>  +
>  +	for (ucnt = 0; ucnt < no; ucnt++, tcfg++) {
>  +		if (!tcfg->clocks) {
>  +			tcfg->clocks = s5pv210_serial_clocks;
>  +			tcfg->clocks_size =
ARRAY_SIZE(s5pv210_serial_clocks);
>  +		}
>  +	}
>  +

Same as above.

>  +	s3c24xx_init_uartdevs("s5pv210-uart", s5p_uart_resources, cfg, no);
>   }

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

