Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab0FPWjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:39:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54743 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0FPWjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:39:40 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Adrian Hunter'" <adrian.hunter@nokia.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
References: <4C14AC91.6020202@nokia.com>
Subject: RE: [PATCH V2 4/4] omap_hsmmc: Add erase capability
Date: Wed, 16 Jun 2010 17:39:00 -0500
Message-ID: <008d01cb0da4$b730fdf0$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <4C14AC91.6020202@nokia.com>
Thread-Index: AcsK33i/gS0v+1YyT5yHWNaVAaggtwCw7BWA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Adrian Hunter [mailto:adrian.hunter@nokia.com]
> Sent: Sunday, June 13, 2010 5:02 AM
> To: Andrew Morton
> Cc: Kyungmin Park; Madhusudhan Chikkature; LKML; linux-mmc@vger.kernel.org
> Subject: [PATCH V2 4/4] omap_hsmmc: Add erase capability
> 
> From 101ce0365d6ce1abc8518f4776ea723038eeb5ae Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Tue, 18 May 2010 17:33:13 +0300
> Subject: [PATCH 4/4] omap_hsmmc: Add erase capability
> 
> Disable the data (busy) timeout for erases and set the
> MMC_CAP_ERASE capability.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index b032828..5cbbe09 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -28,6 +28,7 @@
>  #include <linux/clk.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/core.h>
> +#include <linux/mmc/mmc.h>
>  #include <linux/io.h>
>  #include <linux/semaphore.h>
>  #include <linux/gpio.h>
> @@ -78,6 +79,7 @@
>  #define INT_EN_MASK		0x307F0033
>  #define BWR_ENABLE		(1 << 4)
>  #define BRR_ENABLE		(1 << 5)
> +#define DTO_ENABLE		(1 << 20)
>  #define INIT_STREAM		(1 << 1)
>  #define DP_SELECT		(1 << 21)
>  #define DDIR			(1 << 4)
> @@ -523,7 +525,8 @@ static void omap_hsmmc_stop_clock(struct
> omap_hsmmc_host *host)
>  		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
>  }
> 
> -static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host)
> +static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
> +				  struct mmc_command *cmd)
>  {
>  	unsigned int irq_mask;
> 
> @@ -532,6 +535,10 @@ static void omap_hsmmc_enable_irq(struct
> omap_hsmmc_host *host)
>  	else
>  		irq_mask = INT_EN_MASK;
> 
> +	/* Disable timeout for erases */
> +	if (cmd->opcode == MMC_ERASE)
> +		irq_mask &= ~DTO_ENABLE;
> +

I wonder is it safe to setup something based on the opcode? 

When I first posted the driver I remember some comments on checks in the
driver for opcode were considered as layer violation.

But I don't see any other way of dealing with this. So it should be fine.

Regards,
Madhu

>  	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
>  	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
>  	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
> @@ -782,7 +789,7 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host,
> struct mmc_command *cmd,
>  		mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
>  	host->cmd = cmd;
> 
> -	omap_hsmmc_enable_irq(host);
> +	omap_hsmmc_enable_irq(host, cmd);
> 
>  	host->response_busy = 0;
>  	if (cmd->flags & MMC_RSP_PRESENT) {
> @@ -2094,7 +2101,7 @@ static int __init omap_hsmmc_probe(struct
> platform_device *pdev)
>  	mmc->max_seg_size = mmc->max_req_size;
> 
>  	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
> -		     MMC_CAP_WAIT_WHILE_BUSY;
> +		     MMC_CAP_WAIT_WHILE_BUSY | MMC_CAP_ERASE;
> 
>  	if (mmc_slot(host).wires >= 8)
>  		mmc->caps |= MMC_CAP_8_BIT_DATA;
> --
> 1.6.3.3

