Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2GKBvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:51:12 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:55352 "HELO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752990Ab2GKBvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:51:10 -0400
Message-ID: <4FFCDBF6.4030005@marvell.com>
Date: Wed, 11 Jul 2012 09:50:46 +0800
From: Qiao Zhou <zhouqiao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: SamuelOrtiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Fix checking return value of regmap_read()
References: <1341970074.11561.1.camel@phoenix>
In-Reply-To: <1341970074.11561.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2012 01:50:32.0077 (UTC) FILETIME=[8E5223D0:01CD5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 09:27 AM, Axel Lin wrote:
> Check the return value of regmap_read() rather than the read value.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>   drivers/mfd/88pm800.c |   16 +++++++++-------
>   drivers/mfd/88pm805.c |    5 +++--
>   2 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
> index ec7d9b8..b67a301 100644
> --- a/drivers/mfd/88pm800.c
> +++ b/drivers/mfd/88pm800.c
> @@ -419,22 +419,24 @@ static int __devinit device_800_init(struct pm80x_chip *chip,
>   				     struct pm80x_platform_data *pdata)
>   {
>   	int ret, pmic_id;
> +	unsigned int val;
>
> -	regmap_read(chip->regmap, PM800_CHIP_ID, &ret);
> +	ret = regmap_read(chip->regmap, PM800_CHIP_ID, &val);
>   	if (ret < 0) {
>   		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
>   		goto out;
>   	}
>
> -	pmic_id = ret & PM80X_VERSION_MASK;
> +	pmic_id = val & PM80X_VERSION_MASK;
>
>   	if ((pmic_id >= PM800_CHIP_A0) && (pmic_id <= PM800_CHIP_END)) {
> -		chip->version = ret;
> +		chip->version = val;
>   		dev_info(chip->dev,
> -			 "88PM80x:Marvell 88PM800 (ID:0x%x) detected\n", ret);
> +			 "88PM80x:Marvell 88PM800 (ID:0x%x) detected\n", val);
>   	} else {
>   		dev_err(chip->dev,
> -			"Failed to detect Marvell 88PM800:ChipID[0x%x]\n", ret);
> +			"Failed to detect Marvell 88PM800:ChipID[0x%x]\n", val);
> +		ret = -EINVAL;
>   		goto out;
>   	}
>
> @@ -442,12 +444,12 @@ static int __devinit device_800_init(struct pm80x_chip *chip,
>   	 * alarm wake up bit will be clear in device_irq_init(),
>   	 * read before that
>   	 */
> -	regmap_read(chip->regmap, PM800_RTC_CONTROL, &ret);
> +	ret = regmap_read(chip->regmap, PM800_RTC_CONTROL, &val);
>   	if (ret < 0) {
>   		dev_err(chip->dev, "Failed to read RTC register: %d\n", ret);
>   		goto out;
>   	}
> -	if (ret & PM800_ALARM_WAKEUP) {
> +	if (val & PM800_ALARM_WAKEUP) {
>   		if (pdata && pdata->rtc)
>   			pdata->rtc->rtc_wakeup = 1;
>   	}
> diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
> index d59ca6b..6146583 100644
> --- a/drivers/mfd/88pm805.c
> +++ b/drivers/mfd/88pm805.c
> @@ -192,6 +192,7 @@ static struct regmap_irq_chip pm805_irq_chip = {
>   static int __devinit device_805_init(struct pm80x_chip *chip)
>   {
>   	int ret = 0;
> +	unsigned int val;
>   	struct regmap *map = chip->regmap;
>
>   	if (!map) {
> @@ -199,12 +200,12 @@ static int __devinit device_805_init(struct pm80x_chip *chip)
>   		return -EINVAL;
>   	}
>
> -	regmap_read(map, PM805_CHIP_ID, &ret);
> +	ret = regmap_read(map, PM805_CHIP_ID, &val);
>   	if (ret < 0) {
>   		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
>   		goto out_irq_init;
>   	}
> -	chip->version = ret;
> +	chip->version = val;
>
>   	chip->regmap_irq_chip = &pm805_irq_chip;
>
>
Axel,

thanks for the fixing.

-- 

Best Regards
Qiao


