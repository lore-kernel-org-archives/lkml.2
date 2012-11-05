Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2KEMWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:22:54 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:17672
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342Ab2KEMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:22:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 5 Nov 2012 20:48:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: yongd <yongd@marvell.com>
CC: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] mmc: esdhc: enable polling to detect card by
 itself
Message-ID: <20121105124809.GA27260@S2100-06.ap.freescale.net>
References: <1351589403-26398-1-git-send-email-yongd@marvell.com>
 <1351589403-26398-2-git-send-email-yongd@marvell.com>
 <20121031152030.GE8100@S2100-06.ap.freescale.net>
 <5093BE95.6040709@marvell.com>
 <20121105015421.GA26512@S2100-06.ap.freescale.net>
 <509733D9.2060807@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <509733D9.2060807@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:34:49AM +0800, yongd wrote:
> From the code logic, without SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, when your card (using
> GPIO detection) is removed, we can know the card's absence through the fake CARD_PRESENT flag in esdhc_readl_le().
> As a result, we can quickly return ENOMEDIUM error without command sending. Finally mmc_rescan can know the card
> is removed.
> 
Yes, that's the existing implementation, which does not require retry
sending MMC_SEND_STATUS to know if card is removed.

> On the other hand, with SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, we will just send MMC_SEND_STATUS
> command (cd_irq->sdhci_tasklet_card->mmc_recan->mmc_sd_detect->mmc_sd_alive), and we will find error since the card
> is already gone. Finally, we shall also know the card is removed.
> 
> This is really strange why the removal message shows up together with the next card inserting message.
> Could u pls tell us more about what actually happened when the card is removed with my patches? Did the GPIO interrupt
> happen? Was mmc_rescan() called? Did mmc_sd_detect() finally find error when it sent MMC_SEND_STATUS? What step did
> the card removing procedure arrive at? Really really thanks a lot:-)
> 
I just tracked it down a little bit.  Interesting enough, it depends on
how I remove the card.  If I do it slowly, when the gpio interrupt
triggers the MMC_SEND_STATUS query, the command can still retrieve
the card status successfully.  Thus driver does not detect the card
removal.  If I remove the card from slot quickly, I can see the removal
message.

With your patch series, in ESDHC_CD_GPIO case the driver will have
to send MMC_SEND_STATUS (with retry) to card for knowing its presence.
This is also an unpleasant behavior comparing to the existing code.
I think we should query gpio state to know card presence for this case.

Shawn

