Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2KHCq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:46:26 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40205 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab2KHCqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:46:24 -0500
Message-ID: <509B1CEE.6090306@marvell.com>
Date: Thu, 08 Nov 2012 10:46:06 +0800
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
References: <1351589403-26398-1-git-send-email-yongd@marvell.com> <1351589403-26398-2-git-send-email-yongd@marvell.com> <20121031152030.GE8100@S2100-06.ap.freescale.net> <5093BE95.6040709@marvell.com> <20121105015421.GA26512@S2100-06.ap.freescale.net> <509733D9.2060807@marvell.com> <20121105124809.GA27260@S2100-06.ap.freescale.net> <5098CF26.3060202@marvell.com> <20121106125253.GC27643@S2100-06.ap.freescale.net>
In-Reply-To: <20121106125253.GC27643@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Nov 2012 02:46:12.0791 (UTC) FILETIME=[371CA470:01CDBD5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年11月06日 20:52, Shawn Guo wrote:
> On Tue, Nov 06, 2012 at 04:49:42PM +0800, yongd wrote:
>>  From your info, we can see that on your platform, those pins (including
>> power, clk, DATA) necessary for MMC_SEND_STATUS transaction still keep
>> connected for some time just after the GPIO's level changes due to card
>> removable. And if we remove the card very slowly, such time duration can be
>> such long that the MMC_SEND_STATUS query can still succeed.
>>
> I was not removing the card as slowly as you think. It's actually
> a normal speed.  That's why I thought your patch breaks the
> card-detection functionality before I found the cause.
>
>> So I think we can add a proper delay(maybe 100ms) before the gpio interrupt
>> triggers the MMC_SEND_STATUS query, and maybe this can probably fix this issue:-)
>>
> I do not think it's a proper fixing.
Anyway, u can try such delay like msleep(100) in cd_irq() before calling
tasklet_schedule(&sdhost->card_tasklet). Yes, this is not a proper fix even
it works:-)
>
> <snip>
>
>> Anyway, I 100% agree with you that for a ESDHC_CD_GPIO card, we shall query gpio
>> state to know such card's presence rather than sending MMC_SEND_STATUS rudely.
>>
>> But just as I mentioned before, I don't think using SDHCI_QUIRK_BROKEN_CARD_DETECTION
>> as the flag to determine whether and how we can know card's presence before sending
>> command is a proper way.
>>
>> I haven't gotten any good idea. Do u have any idea on this?
>>
> I guess what we need is to call mmc_gpio_get_cd() trying to know card's
> presence before sending MMC_SEND_STATUS command.  sdhci-esdhc-imx
> driver will surely need some changes to cope with that.
>
> Shawn
>
Yes, gpio card detection should better use the existing framework 
offered by slot-gpio.
Then the fake-card-present will be unnecessary. BTW, sdhci-s3c.c also 
dose not use slot-gpio,
and then it also adds some tricky logic for gpio detection. U can check 
sdhci_s3c_notify_change(),
which dynamically set/clear SDHCI_QUIRK_BROKEN_CARD_DETECTION. This 
patch adding
mmc_gpio_get_cd(), bec9d4e5939987053169a9bb48fc58b6a2d3e237, mentioned 
this 1stly.

But using SDHCI_QUIRK_BROKEN_CARD_DETECTION to do such judging in 
sdhci_request()
is still not proper. I think this is the root causing such above 
workarounds.

So I am thinking of adding a new operation like get_card_presence into 
sdhci_ops,
and then different host drivers can implement differently by themselves, 
eg, for
sdhci-esdhc-imx.c,

static bool esdhc_get_card_presence(struct sdhci_host *host)
{
bool present = true;

if (detection_type == ESDHC_CD_CONTROLLER)
present = sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT;
else if (detection_type == ESDHC_CD_GPIO) {
if (gpio_get_value(boarddata->cd_gpio))
/* no card, if a valid gpio says so... */
present = false;
}

return present;
}


But this will also cause lots of host drivers corresponding changes. Oh, 
still inconvenient:-(
Any better ideas?

