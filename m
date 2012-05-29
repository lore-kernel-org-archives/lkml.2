Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab2E2MkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:40:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54529 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2E2MkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:40:17 -0400
Message-ID: <4FC4C391.50700@mvista.com>
Date: Tue, 29 May 2012 16:39:45 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
CC: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] ide: icside.c: Fix compile with CONFIG_BLK_DEV_IDEDMA_ICS=n
References: <20120529103002.GA13283@faui49q.informatik.uni-erlangen.de>
In-Reply-To: <20120529103002.GA13283@faui49q.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-05-2012 14:30, Christian Dietrich wrote:

> The icside driver can be configured without DMA support, but it
> doesn't compile in this case, because DMA operations are referenced.

> drivers/ide/icside.c:523: error: ‘icside_v6_port_ops’ undeclared
> drivers/ide/icside.c:522: error: ‘icside_dma_init’ undeclared

> Signed-off-by: Christian Dietrich<christian.dietrich@informatik.uni-erlangen.de>
> ---
>   drivers/ide/icside.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)

> I attach the configuration, that exposes this compilation error.

    Apparently, you forgot to do it. :-)

> This patch was
> *NOT* tested on real hardware. I don't if the fix really does solve the
> problem, but at least it is a hint that there is a problem.

> diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
> index 8716066..62c59c1 100644
> --- a/drivers/ide/icside.c
> +++ b/drivers/ide/icside.c
> @@ -271,7 +271,7 @@ static void icside_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
>
>   	ide_set_drivedata(drive, (void *)cycle_time);
>
> -	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
> +	printk("%s: %s selected (peak %ldMB/s)\n", drive->name,

    Unrelated change, should go into its own patch.

>   		ide_xfer_verbose(xfer_mode),
>   		2000 / (unsigned long)ide_get_drivedata(drive));
>   }
> @@ -456,7 +456,9 @@ err_free:
>   static const struct ide_port_info icside_v6_port_info __initdata = {
>   	.init_dma		= icside_dma_off_init,
>   	.port_ops		=&icside_v6_no_dma_port_ops,
> +#ifdef CONFIG_BLK_DEV_IDEDMA_ICS

    You forgot to remove the useless '#define icside_v6_dma_ops NULL' above.
Also, you could set .dma_ops inside the 'if' below (and get rid of 'else' 
then), removing this line.

>   	.dma_ops		=&icside_v6_dma_ops,
> +#endif
>   	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
>   	.mwdma_mask		= ATA_MWDMA2,
>   	.swdma_mask		= ATA_SWDMA2,
> @@ -518,10 +520,12 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
>
>   	ecard_set_drvdata(ec, state);
>
> +#ifdef CONFIG_BLK_DEV_IDEDMA_ICS
>   	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
>   		d.init_dma = icside_dma_init;
>   		d.port_ops = &icside_v6_port_ops;
>   	} else
> +#endif
>   		d.dma_ops = NULL;
>
>   	ret = ide_host_register(host,&d, hws);

MBR, Sergei
