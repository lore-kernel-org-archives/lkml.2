Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2KEDgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 22:36:03 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:59973 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583Ab2KEDgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 22:36:00 -0500
Message-ID: <509733D9.2060807@marvell.com>
Date: Mon, 05 Nov 2012 11:34:49 +0800
From: yongd <yongd@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] mmc: esdhc: enable polling to detect card by itself
References: <1351589403-26398-1-git-send-email-yongd@marvell.com> <1351589403-26398-2-git-send-email-yongd@marvell.com> <20121031152030.GE8100@S2100-06.ap.freescale.net> <5093BE95.6040709@marvell.com> <20121105015421.GA26512@S2100-06.ap.freescale.net>
In-Reply-To: <20121105015421.GA26512@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Nov 2012 03:34:47.0159 (UTC) FILETIME=[80F8A870:01CDBB06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年11月05日 09:54, Shawn Guo wrote:
> On Fri, Nov 02, 2012 at 08:37:41PM +0800, yongd wrote:
>> I got it. So how do you think of such below partition/reorganization?
>>
> It looks fine to me for imx.

Ok. I will update like this way if we have no other issues. Thanks.

>
>> Patch-1:
>> For sdhci-esdhc-imx.c, only add MMC_CAP_NEEDS_POLL for ESDHC_CD_NONE. With that
>> improper logic of sdhci_add_host(), this is redundant, but shall be better
>> than something unpleasant you mentioned.
>>
>> Patch-2:
>> For sdhci-s3c.c, do exactly the same thing as Patch-1.
>>
>> Patch-3:
>> For sdhci.c, remove that improper logic of sdhci_add_host().
>>
>> Patch-4:
>> For sdhci-esdhc-imx.c, set SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO.
>>
>> Patch-5:
>> For sdhci-s3c.c, broaden SDHCI_QUIRK_BROKEN_CARD_DETECTION range for all detection
>> types except S3C_SDHCI_CD_INTERNAL.
> <snip>
>
>> Yes, not equal as before. But you just remind me of one more improper place in our current sdhci.c.
>> Let's review those lines in sdhci_request() which are added by Anton long long ago in commit
>> 68d1fb7e229c6f95be4fbbe3eb46b24e41184924(sdhci: Add support for card-detection polling),
>>
>> 	/* If polling, assume that the card is always present. */
>> 	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
>> 		present = true;
>> 	else
>> 		present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
>> 				SDHCI_CARD_PRESENT;
>>
>> Here before sending command, if we can confirm the card dose not exist, we will return quickly without
>> sending this command.This is a good optimization. But if polling, we can't do such checking, so we can
>> only assume the card is always present.
>> Here is another improper example of using SDHCI_QUIRK_BROKEN_CARD_DETECTION. Exactly the same as
>> sdhci_add_host(), it thinks only polling and host internal card detection methods exist.
>> Maybe we can determine whether and how we can do such card-existence-checking optimization based on our
>> detection type directly rather than an indirect flag which should have its own pure meaning. But Let's
>> do such similar further improvement in future since currently with my patch of setting
>> SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, functionality is OK as before. How do u think?
>>
> I'm not sure it will function same as before.  When I was testing your
> v2 series, I can not see card removal message with removing card, but
> can see it show up together with the next card inserting message.
>
> Shawn
>

Shawn,
 From the code logic, without SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, when your card (using
GPIO detection) is removed, we can know the card's absence through the fake CARD_PRESENT flag in esdhc_readl_le().
As a result, we can quickly return ENOMEDIUM error without command sending. Finally mmc_rescan can know the card
is removed.

On the other hand, with SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, we will just send MMC_SEND_STATUS
command (cd_irq->sdhci_tasklet_card->mmc_recan->mmc_sd_detect->mmc_sd_alive), and we will find error since the card
is already gone. Finally, we shall also know the card is removed.

This is really strange why the removal message shows up together with the next card inserting message.
Could u pls tell us more about what actually happened when the card is removed with my patches? Did the GPIO interrupt
happen? Was mmc_rescan() called? Did mmc_sd_detect() finally find error when it sent MMC_SEND_STATUS? What step did
the card removing procedure arrive at? Really really thanks a lot:-)





