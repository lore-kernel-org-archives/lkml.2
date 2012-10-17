Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab2JQEFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:05:17 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38675 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab2JQEFO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:05:14 -0400
From: Yong Ding <yongd@marvell.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>, Jialing Fu <jlfu@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 16 Oct 2012 21:01:40 -0700
Subject: RE: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Thread-Topic: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Thread-Index: Ac2klQFug+5LbyYjQF+LpMIdHAyeJgHhYrS6
Message-ID: <89813612683626448B837EE5A0B6A7CB30388601C9@SC-VEXCH4.marvell.com>
References: <1348828113-19668-1-git-send-email-yongd@marvell.com>
 <1348828113-19668-2-git-send-email-yongd@marvell.com>,<20121007140648.GA10148@S2101-09.ap.freescale.net>
In-Reply-To: <20121007140648.GA10148@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn,
Thanks for your comment. And sorry for my so late due to illness:-)
SDHCI_QUIRK_BROKEN_CARD_DETECTION is used for notifying we don't use the host internal card detection method so that we don't need enable/disable those relevant interrupt bits of host(sdhci_set_card_detection in sdhci.c). 
And as I double-checked the latest kernel code, actually sdhci-esdhc-imx sets this flag by default, and then will clear it only when the detection type is ESDHC_CD_CONTROLLER. So this aligns with my understanding. 
What I want to do is that 1st we shall set MMC_CAP_NEEDS_POLL by our host driver itself and 2nd remove the improper logic in sdhci_add_host() . How do u think? Thanks.

________________________________________
From: Shawn Guo [shawn.guo@linaro.org]
Sent: Sunday, October 07, 2012 22:06
To: Yong Ding
Cc: Chris Ball; Anton Vorontsov; Marek Szyprowski; Wolfram Sang; Daniel Drake; Sascha Hauer; Wilson Callan; Ben Dooks; Zhangfei Gao; Kevin Liu; Jialing Fu; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself

On Fri, Sep 28, 2012 at 06:28:31PM +0800, yongd wrote:
> In the current code logic, sdhci_add_host() will enable the polling
> method (set MMC_CAP_NEEDS_POLL) for a removable card (MMC_CAP_
> NONREMOVABLE is not set) whose host's internal card detection method
> is disabled for some reason (SDHCI_QUIRK_BROKEN_CARD_DETECTION is set).
>
> However, this is improper since we can have some other card detection
> methods besides host internal card detection and polling method. For
> example, if the card detection type is ESDHC_CD_GPIO (external gpio pin
> for CD), we will keep SDHCI_QUIRK_BROKEN_CARD_DETECTION set. This is right.
> But, just as above said, sdhci_add_host() will also enable polling for such
> a card. This is redundant.
>
At least for sdhci-esdhc-imx, SDHCI_QUIRK_BROKEN_CARD_DETECTION will
be set only when neither ESDHC_CD_GPIO nor ESDHC_CD_CONTROLLER works.

Shawn

> On the other hand, for the card with ESDHC_CD_NONE detection type(no CD, neither
> controller nor gpio, so use polling), we currently rely on sdhci_add_host() to
> enable polling for us.
>
> Here proposed a solution for such an embarrassing case. 1st, this patch will
> de-couple polling enabling with sdhci_add_host() by doing this in host driver
> itself, just as some other vendors. 2nd, one more patch will remove such improper
> MMC_CAP_NEEDS_POLL enabling in sdhci_add_host().
>
> Change-Id: Ia7525009d8fd188e3f0169f225e4a76ff9e94b47
> Signed-off-by: yongd <yongd@marvell.com>
> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index e23f813..f70079c 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -569,6 +569,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>               break;
>
>       case ESDHC_CD_NONE:
> +             host->mmc->caps = MMC_CAP_NEEDS_POLL;
>               break;
>       }
>
> --
> 1.7.9.5
>
