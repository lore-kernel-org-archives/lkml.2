Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0DFQIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0DFQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:08:08 -0400
Subject: Re: [PATCH] libertas/sdio: 8686: set ECSI bit for 1-bit transfers
From: Dan Williams <dcbw@redhat.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <1270543964-18130-1-git-send-email-daniel@caiaq.de>
References: <1270521759.24724.6.camel@localhost.localdomain>
	 <1270543964-18130-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 09:07:34 -0700
Message-ID: <1270570054.2969.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 10:52 +0200, Daniel Mack wrote:
> When operating in 1-bit mode, SDAT1 is used as dedicated interrupt line.
> However, the 8686 will only drive this line when the ECSI bit is set in
> the CCCR_IF register.
> 
> Thanks to Alagu Sankar for pointing me in the right direction.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Alagu Sankar <alagusankar@embwise.com>
> Cc: Volker Ernst <volker.ernst@txtr.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Holger Schurig <hs4233@mail.mn-solutions.de>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: libertas-dev@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |   22 ++++++++++++++++++++++
>  include/linux/mmc/sdio.h                |    2 ++
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 7a73f62..33206a9 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -34,6 +34,8 @@
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/sdio_func.h>
>  #include <linux/mmc/sdio_ids.h>
> +#include <linux/mmc/sdio.h>
> +#include <linux/mmc/host.h>
>  
>  #include "host.h"
>  #include "decl.h"
> @@ -942,6 +944,7 @@ static int if_sdio_probe(struct sdio_func *func,
>  	int ret, i;
>  	unsigned int model;
>  	struct if_sdio_packet *packet;
> +	struct mmc_host *host = func->card->host;
>  
>  	lbs_deb_enter(LBS_DEB_SDIO);
>  
> @@ -1022,6 +1025,25 @@ static int if_sdio_probe(struct sdio_func *func,
>  	if (ret)
>  		goto disable;
>  
> +	/* For 1-bit transfers to the 8686 model, we need to enable the
> +	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
> +	 * bit to allow access to non-vendor registers. */
> +	if ((card->model == IF_SDIO_MODEL_8686) &&
> +	    (host->caps & MMC_CAP_SDIO_IRQ) &&
> +	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
> +		u8 reg;
> +
> +		func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
> +		reg = sdio_f0_readb(func, SDIO_CCCR_IF, &ret);
> +		if (ret)
> +			goto release_int;
> +
> +		reg |= SDIO_BUS_ECSI;
> +		sdio_f0_writeb(func, reg, SDIO_CCCR_IF, &ret);
> +		if (ret)
> +			goto release_int;
> +	}
> +
>  	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
>  	if (ret)
>  		goto release_int;
> diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
> index 0ebaef5..329a8fa 100644
> --- a/include/linux/mmc/sdio.h
> +++ b/include/linux/mmc/sdio.h
> @@ -94,6 +94,8 @@
>  
>  #define  SDIO_BUS_WIDTH_1BIT	0x00
>  #define  SDIO_BUS_WIDTH_4BIT	0x02
> +#define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
> +#define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
>  
>  #define  SDIO_BUS_ASYNC_INT	0x20
>  


