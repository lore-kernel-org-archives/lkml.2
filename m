Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab2KEB3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 20:29:01 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:21745
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab2KEB3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 20:29:00 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 5 Nov 2012 09:54:22 +0800
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
Message-ID: <20121105015421.GA26512@S2100-06.ap.freescale.net>
References: <1351589403-26398-1-git-send-email-yongd@marvell.com>
 <1351589403-26398-2-git-send-email-yongd@marvell.com>
 <20121031152030.GE8100@S2100-06.ap.freescale.net>
 <5093BE95.6040709@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5093BE95.6040709@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 08:37:41PM +0800, yongd wrote:
> I got it. So how do you think of such below partition/reorganization?
> 
It looks fine to me for imx.

> Patch-1:
> For sdhci-esdhc-imx.c, only add MMC_CAP_NEEDS_POLL for ESDHC_CD_NONE. With that
> improper logic of sdhci_add_host(), this is redundant, but shall be better
> than something unpleasant you mentioned.
> 
> Patch-2:
> For sdhci-s3c.c, do exactly the same thing as Patch-1.
> 
> Patch-3:
> For sdhci.c, remove that improper logic of sdhci_add_host().
> 
> Patch-4:
> For sdhci-esdhc-imx.c, set SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO.
> 
> Patch-5:
> For sdhci-s3c.c, broaden SDHCI_QUIRK_BROKEN_CARD_DETECTION range for all detection
> types except S3C_SDHCI_CD_INTERNAL.

<snip>

> Yes, not equal as before. But you just remind me of one more improper place in our current sdhci.c.
> Let's review those lines in sdhci_request() which are added by Anton long long ago in commit
> 68d1fb7e229c6f95be4fbbe3eb46b24e41184924(sdhci: Add support for card-detection polling),
> 
> 	/* If polling, assume that the card is always present. */
> 	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
> 		present = true;
> 	else
> 		present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
> 				SDHCI_CARD_PRESENT;
> 
> Here before sending command, if we can confirm the card dose not exist, we will return quickly without
> sending this command.This is a good optimization. But if polling, we can't do such checking, so we can
> only assume the card is always present.
> Here is another improper example of using SDHCI_QUIRK_BROKEN_CARD_DETECTION. Exactly the same as
> sdhci_add_host(), it thinks only polling and host internal card detection methods exist.
> Maybe we can determine whether and how we can do such card-existence-checking optimization based on our
> detection type directly rather than an indirect flag which should have its own pure meaning. But Let's
> do such similar further improvement in future since currently with my patch of setting
> SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, functionality is OK as before. How do u think?
> 
I'm not sure it will function same as before.  When I was testing your
v2 series, I can not see card removal message with removing card, but
can see it show up together with the next card inserting message.

Shawn

