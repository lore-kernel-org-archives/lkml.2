Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2JRG27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:28:59 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:34401 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246Ab2JRG25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:28:57 -0400
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
Date: Wed, 17 Oct 2012 23:27:17 -0700
Subject: RE: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Thread-Topic: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Thread-Index: Ac2s9HGuMpkRLJ47QdyKWMr71HmqIAAA7ucg
Message-ID: <89813612683626448B837EE5A0B6A7CB3038855FF9@SC-VEXCH4.marvell.com>
References: <1348828113-19668-1-git-send-email-yongd@marvell.com>
 <1348828113-19668-2-git-send-email-yongd@marvell.com>
 <20121007140648.GA10148@S2101-09.ap.freescale.net>
 <89813612683626448B837EE5A0B6A7CB30388601C9@SC-VEXCH4.marvell.com>
 <20121018054053.GA4513@S2101-09.ap.freescale.net>
In-Reply-To: <20121018054053.GA4513@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9I6TCNo008860

Shawn,
Thanks. Oh, sorry I really have missed the fact u mentioned. U are right in the current code, the bit will also be cleared for ESDHC_CD_GPIO. 
But I think this is improper since for GPIO detection type, we don't use the host controller internal card detection(ESDHC_CD_CONTROLLER), but with SDHCI_QUIRK_BROKEN_CARD_DETECTION cleared, we'll still enable/disable relevant INT bits (in sdhci_set_card_detection in sdhci.c). This is my biggest concern. And I think the SDHCI_QUIRK_BROKEN_CARD_DETECTION shall be purely used to notify whether the host controller detection method is used or not. So even for the ESDHC_CD_GPIO type, we should still set this flag. How do u think?

-----Original Message-----
From: Shawn Guo [mailto:shawn.guo@linaro.org] 
Sent: 2012Äê10ÔÂ18ÈÕ 13:51
To: Yong Ding
Cc: Chris Ball; Anton Vorontsov; Marek Szyprowski; Wolfram Sang; Daniel Drake; Sascha Hauer; Wilson Callan; Ben Dooks; Zhangfei Gao; Kevin Liu; Jialing Fu; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself

On Tue, Oct 16, 2012 at 09:01:40PM -0700, Yong Ding wrote:
> Shawn,
> Thanks for your comment. And sorry for my so late due to illness:-)
> SDHCI_QUIRK_BROKEN_CARD_DETECTION is used for notifying we don't use the host internal card detection method so that we don't need enable/disable those relevant interrupt bits of host(sdhci_set_card_detection in sdhci.c). 
> And as I double-checked the latest kernel code, actually sdhci-esdhc-imx sets this flag by default, and then will clear it only when the detection type is ESDHC_CD_CONTROLLER. So this aligns with my understanding. 

What I was saying is the bit will be cleared when the detection type is
ESDHC_CD_CONTROLLE or ESDHC_CD_GPIO.  You may have missed the fact that
there is no "break" in case ESDHC_CD_GPIO but a "fall through" comment.

        switch (boarddata->cd_type) {
        case ESDHC_CD_GPIO:
                err = gpio_request_one(boarddata->cd_gpio, GPIOF_IN, "ESDHC_CD");
                if (err) {
                        dev_err(mmc_dev(host->mmc),
                                "no card-detect pin available!\n");
                        goto no_card_detect_pin;
                }

                err = request_irq(gpio_to_irq(boarddata->cd_gpio), cd_irq,
                                 IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
                                 mmc_hostname(host->mmc), host);
                if (err) {
                        dev_err(mmc_dev(host->mmc), "request irq error\n");
                        goto no_card_detect_irq;
                }
                /* fall through */

        case ESDHC_CD_CONTROLLER:
                /* we have a working card_detect back */
                host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
                break;

        case ESDHC_CD_PERMANENT:
                host->mmc->caps = MMC_CAP_NONREMOVABLE;
                break;

        case ESDHC_CD_NONE:
                break;
        }

Shawn

> What I want to do is that 1st we shall set MMC_CAP_NEEDS_POLL by our host driver itself and 2nd remove the improper logic in sdhci_add_host() . How do u think? Thanks.
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
