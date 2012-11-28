Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2K1SUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:20:10 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45249 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2K1SUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:20:05 -0500
MIME-Version: 1.0
In-Reply-To: <001a01cdcd4a$cf01ad40$6d0507c0$%jun@samsung.com>
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
	<1353624835-19137-1-git-send-email-dianders@chromium.org>
	<001a01cdcd4a$cf01ad40$6d0507c0$%jun@samsung.com>
Date: Wed, 28 Nov 2012 10:20:03 -0800
X-Google-Sender-Auth: 1YceWH6wCcFfAML8OQWJJrpXDP0
Message-ID: <CAD=FV=Xdb5W_WrDPgxaTzMOYNP7DpD6Gztq9k2B85z1boUV+3w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: dw_mmc: exynos: Stop claiming wp-gpio
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

Thanks for the review.  See below for comments.  If you'd like me to
respin then please let me know.  Otherwise I look forward to your ack.

On Wed, Nov 28, 2012 at 1:29 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Yes. pin of write protection is common property.
> This change is good. I have some suggestion below.
> Could you check it?
>
> On Friday, November 23, 2012, Doug Anderson wrote:
>> The exynos code claimed wp-gpio with devm_gpio_request() but never did
>> anything with it.  That meant that anyone using a write protect GPIO
>> would effectively be write protected all the time.
>>
>> A future change will move the wp-gpio support to the core dw_mmc.c
>> file.  Now the exynos-specific code won't claim the GPIO but will
>> just set the DW_MCI_QUIRK_NO_WRITE_PROTECT quirk if write protect
>> won't be used.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>
>> ---
>> Changes in v2:
>> - Nothing new in this patch
>>
>>  drivers/mmc/host/dw_mmc-exynos.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>> index 4d50da6..58cc03e 100644
>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>> @@ -175,12 +175,12 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
>>               }
>>       }
>>
>> -     gpio = of_get_named_gpio(slot_np, "wp-gpios", 0);
>> -     if (gpio_is_valid(gpio)) {
>> -             if (devm_gpio_request(host->dev, gpio, "dw-mci-wp"))
>> -                     dev_info(host->dev, "gpio [%d] request failed\n",
>> -                                             gpio);
>> -     } else {
>> +     /*
>> +      * If there are no write-protect GPIOs present then we assume no write
>> +      * protect.  The mci_readl() in dw_mmc.c won't work since it's not
>> +      * hooked up on exynos.
>> +      */
>> +     if (!of_find_property(slot_np, "wp-gpios", NULL)) {
>>               dev_info(host->dev, "wp gpio not available");
>>               host->pdata->quirks |= DW_MCI_QUIRK_NO_WRITE_PROTECT;
>>       }
> All card types need this quirk in case wp-gpio property is empty?
> I think wp-pin is valid for SD card, not eMMC/SDIO.

Right.  It is only checked right now by the SD code (mmc/core/sd.c).
It doesn't particularly hurt to set it the quirk in other cases though
and it seems nice not to add special cases.  I could imagine someone
extending the MMC code at some point to support write protect (via
GPIO) for eMMC, so there's even a slight justification for avoiding
the special case.


> Of course, I know origin code did it.
> How about removing whole checking routine?
> Instead, new definition for this quirk can be added into 'dw_mci_of_quirks'(dw_mmc.c) and dts file.

On _exynos_ all SD cards need this quirk if there is no wp-gpio
property.  However this is not generally true for all users of dw_mmc.
 The DesignWare IP Block actually has a write protect input that can
be read with "mci_readl(slot->host, WRTPRT)" but on exynos the
DesignWare write protect line isn't exposed on any physical pins.
That means that the only possible way to do write protect on exynos is
using a GPIO.

The above means that on exynos if the GPIO isn't defined we will
assume no write protect.  On other platforms if the GPIO isn't defined
we'll assume that the "mci_readl" will work and we'll use that.

If people would prefer it I can code up an alternate solution that
doesn't touch any exynos code but that would introduce a new device
tree binding.  We could accomplish what's needed for exynos using a
property like "broken-internal-wp".

Please let me know if you'd like me to submit a new patch with this
solution or if you like the existing solution.


> Thanks,
> Seungwon Jeon
>> --
>> 1.7.7.3
>
