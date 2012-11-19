Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2KSIvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:51:23 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:16500
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab2KSIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:51:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z37d5kz9371I542M1432Izz1de0h1202h1d1ah1d2ahzz17326ah8275bh8275dha509lz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631hbe9i15d0l1155h)
From: Huang Changming-R66093 <r66093@freescale.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>,
        "cjb@laptop.org" <cjb@laptop.org>, "ohad@wizery.com" <ohad@wizery.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mmc,sdio: advancing the setting of dev name in
 mmc_sdio_init_card()
Thread-Topic: [PATCH] mmc,sdio: advancing the setting of dev name in
 mmc_sdio_init_card()
Thread-Index: AQHNxjEK5+7M3J5sqk2jnfr3oGMzOZfw2WRA
Date: Mon, 19 Nov 2012 08:51:18 +0000
Message-ID: <110EED8CC96DFC488B7E717A2027A27C22535E@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1353070447.15558.1681.camel@cliu38-desktop-build>
 <1353346703.15558.1686.camel@cliu38-desktop-build>
In-Reply-To: <1353346703.15558.1686.camel@cliu38-desktop-build>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.67]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAJ8pRpp014085

This is new version?
Maybe you should add prefix v2 in subject and the version history.

Best Regards
Jerry Huang


> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Chuansheng Liu
> Sent: Tuesday, November 20, 2012 1:38 AM
> To: cjb@laptop.org; ohad@wizery.com
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org;
> chuansheng.liu@intel.com
> Subject: [PATCH] mmc,sdio: advancing the setting of dev name in
> mmc_sdio_init_card()
> 
> 
> In below call trace:
>     mmc_rescan
>     -> mmc_rescan_try_freq()
>     -> mmc_attach_sdio()
>     -> mmc_sdio_init_card()
>        ...
>        pm_runtime_set_active()
>        ...
>        mmc_add_card()
> 
> The dev name is set until in mmc_add_card(), but before that, it is
> possible the dev name is needed, for example in pm_runtime_set_active(),
> we can call trace event to trace which dev is changing the runtime status.
> 
> So here advance it into mmc_sdio_init_card() to benefit others.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/mmc/core/bus.c  |    5 +++--
>  drivers/mmc/core/sdio.c |    5 ++++-
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c index
> 9b68933..4884d6e 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -270,8 +270,9 @@ int mmc_add_card(struct mmc_card *card)
>  		[UHS_DDR50_BUS_SPEED] = "DDR50 ",
>  	};
> 
> -
> -	dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host), card-
> >rca);
> +	if (!dev_name(&card->dev))
> +		dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host),
> +			card->rca);
> 
>  	switch (card->type) {
>  	case MMC_TYPE_MMC:
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c index
> 2273ce6..a9f6f02 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -795,8 +795,11 @@ static int mmc_sdio_init_card(struct mmc_host *host,
> u32 ocr,
>  			goto remove;
>  	}
>  finish:
> -	if (!oldcard)
> +	if (!oldcard) {
>  		host->card = card;
> +		dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host),
> +			card->rca);
> +	}
>  	return 0;
> 
>  remove:
> --
> 1.7.0.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
