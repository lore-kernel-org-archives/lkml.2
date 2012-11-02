Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2KBMi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:38:56 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:52206 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2KBMiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:38:54 -0400
Message-ID: <5093BE95.6040709@marvell.com>
Date: Fri, 02 Nov 2012 20:37:41 +0800
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
References: <1351589403-26398-1-git-send-email-yongd@marvell.com> <1351589403-26398-2-git-send-email-yongd@marvell.com> <20121031152030.GE8100@S2100-06.ap.freescale.net>
In-Reply-To: <20121031152030.GE8100@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Nov 2012 12:37:41.0534 (UTC) FILETIME=[D99293E0:01CDB8F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年10月31日 23:20, Shawn Guo wrote:
> On Tue, Oct 30, 2012 at 05:30:01PM +0800, yongd wrote:
>> In the current code logic, sdhci_add_host() will enable the polling
>> method (set MMC_CAP_NEEDS_POLL) for a removable card (MMC_CAP_
>> NONREMOVABLE is not set) whose host's internal card detection method
>> is disabled for some reason (SDHCI_QUIRK_BROKEN_CARD_DETECTION is set).
>>
>> However, this is improper since we can have some other card detection
>> methods besides host internal card detection and polling method. For
>> example, if the card detection type is ESDHC_CD_GPIO (external gpio pin
>> for CD), we should keep SDHCI_QUIRK_BROKEN_CARD_DETECTION set, or host
>> internal card detection interrupt will still be enabled. So, here comes
>> the 1st change in this patch to keep SDHCI_QUIRK_BROKEN_CARD_DETECTION
>> set for ESDHC_CD_GPIO type. But, after the 1st change, just as above
>> said, sdhci_add_host() will still enable polling for such a card.This
>> is redundant.
>>
> This actually results in an unpleasant rather than redundant behavior.
> Right after this patch gets applied and before patch #3 gets applied,
> driver sdhci-esdhc-imx will use polling even for ESDHC_CD_GPIO case.

Shawn,
I got it. So how do you think of such below partition/reorganization?

Patch-1:
For sdhci-esdhc-imx.c, only add MMC_CAP_NEEDS_POLL for ESDHC_CD_NONE. With that
improper logic of sdhci_add_host(), this is redundant, but shall be better
than something unpleasant you mentioned.

Patch-2:
For sdhci-s3c.c, do exactly the same thing as Patch-1.

Patch-3:
For sdhci.c, remove that improper logic of sdhci_add_host().

Patch-4:
For sdhci-esdhc-imx.c, set SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO.

Patch-5:
For sdhci-s3c.c, broaden SDHCI_QUIRK_BROKEN_CARD_DETECTION range for all detection
types except S3C_SDHCI_CD_INTERNAL.


>> On the other hand, for the card with ESDHC_CD_NONE detection type(no CD,
>> neither controller nor gpio, so use polling), we currently rely on
>> sdhci_add_host() to enable polling for us.
>>
>> Here propose the 2nd change in this patch for such an embarrassing case.
> Besides above, this is another sign that the patch (and series) should
> be better partitioned.
>
>> 1st, this patch will de-couple polling enabling with sdhci_add_host() by
>> doing this in host driver itself, just as some other vendors. 2nd, one
>> more patch will remove such improper MMC_CAP_NEEDS_POLL enabling in
>> sdhci_add_host().
>>
>> Change-Id: Ia7525009d8fd188e3f0169f225e4a76ff9e94b47
> Remove this, please.

Shawn,
I got it, and will remove such thing in updated patches. Thanks.

>> Signed-off-by: yongd <yongd@marvell.com>
>> ---
>>   drivers/mmc/host/sdhci-esdhc-imx.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
>> index effc2ac..ff201a5 100644
>> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
>> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
>> @@ -557,7 +557,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>>   			dev_err(mmc_dev(host->mmc), "request irq error\n");
>>   			goto no_card_detect_irq;
>>   		}
>> -		/* fall through */
>> +		break;
> The current sdhci-esdhc-imx implementation clears flag
> SDHCI_QUIRK_BROKEN_CARD_DETECTION even for ESDHC_CD_GPIO case
> and then emulate flag SDHCI_CARD_PRESENT by reading CD gpio state in
> esdhc_readl_le().  Obviously, simply setting the flag for gpio case
> does not provide an equal behavior as before.
>
> Shawn
>

Shawn,
Yes, not equal as before. But you just remind me of one more improper place in our current sdhci.c.
Let's review those lines in sdhci_request() which are added by Anton long long ago in commit
68d1fb7e229c6f95be4fbbe3eb46b24e41184924(sdhci: Add support for card-detection polling),

	/* If polling, assume that the card is always present. */
	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
		present = true;
	else
		present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
				SDHCI_CARD_PRESENT;

Here before sending command, if we can confirm the card dose not exist, we will return quickly without
sending this command.This is a good optimization. But if polling, we can't do such checking, so we can
only assume the card is always present.
Here is another improper example of using SDHCI_QUIRK_BROKEN_CARD_DETECTION. Exactly the same as
sdhci_add_host(), it thinks only polling and host internal card detection methods exist.
  
Maybe we can determine whether and how we can do such card-existence-checking optimization based on our
detection type directly rather than an indirect flag which should have its own pure meaning. But Let's
do such similar further improvement in future since currently with my patch of setting
SDHCI_QUIRK_BROKEN_CARD_DETECTION for ESDHC_CD_GPIO, functionality is OK as before. How do u think?


>>   
>>   	case ESDHC_CD_CONTROLLER:
>>   		/* we have a working card_detect back */
>> @@ -569,6 +569,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>>   		break;
>>   
>>   	case ESDHC_CD_NONE:
>> +		host->mmc->caps = MMC_CAP_NEEDS_POLL;
>>   		break;
>>   	}
>>   
>> -- 
>> 1.7.9.5
>>

