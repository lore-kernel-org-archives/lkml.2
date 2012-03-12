Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2CLEiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 00:38:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63487 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2CLEh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 00:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2XJ3HrQROc-_6Lq6zccgF-QZupVozXCQnXYGN7+DBnq+A@mail.gmail.com>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
	<1331469965-28846-6-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2XJ3HrQROc-_6Lq6zccgF-QZupVozXCQnXYGN7+DBnq+A@mail.gmail.com>
Date: Mon, 12 Mar 2012 10:07:54 +0530
Message-ID: <CAJuYYwSbtJvOM_EY7MXRJ-wEk-vNZvjk64+yKgYRxXABSFk2AQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] mmc: sdhci-s3c: setup pins using pinctrl interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        kgene.kim@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 March 2012 08:08, Kyungmin Park <kmpark@infradead.org> wrote:
> On 3/11/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> The platform specific callback to setup the sdhci pin mux and pin config
>> is removed and the pinctrl subsystem interface is used to setup the
>> mux and config.
>>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  drivers/mmc/host/sdhci-s3c.c |   15 +++++++++++++--
>>  1 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
>> index ea0767e..76c1c36 100644
>> --- a/drivers/mmc/host/sdhci-s3c.c
>> +++ b/drivers/mmc/host/sdhci-s3c.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>>  #include <linux/of_gpio.h>
>> +#include <linux/pinctrl/consumer.h>
>>
>>  #include <linux/mmc/host.h>
>>
>> @@ -50,6 +51,7 @@ struct sdhci_s3c {
>>       struct platform_device  *pdev;
>>       struct resource         *ioarea;
>>       struct s3c_sdhci_platdata *pdata;
>> +     struct pinctrl          *pinctrl;
>>       unsigned int            cur_clk;
>>       int                     ext_cd_irq;
>>       int                     ext_cd_gpio;
>> @@ -529,6 +531,9 @@ static inline struct sdhci_s3c_drv_data
>> *sdhci_s3c_get_driver_data(
>>                       platform_get_device_id(pdev)->driver_data;
>>  }
>>
>> +#include <plat/map-s5p.h>
>> +#include <plat/map-base.h>
>
> Why this header files are required?

Sorry, that was a mistake. This was left over here after adding it
here for some debugging. I will take care next time.

>> +
>>  static int __devinit sdhci_s3c_probe(struct platform_device *pdev)
>>  {
>>       struct s3c_sdhci_platdata *pdata;
>> @@ -538,6 +543,7 @@ static int __devinit sdhci_s3c_probe(struct
>> platform_device *pdev)
>>       struct sdhci_s3c *sc;
>>       struct resource *res;
>>       int ret, irq, ptr, clks;
>> +     char *pstate;
>>
>>       if (!pdev->dev.platform_data && !pdev->dev.of_node) {
>>               dev_err(dev, "no device data specified\n");
>> @@ -643,8 +649,13 @@ static int __devinit sdhci_s3c_probe(struct
>> platform_device *pdev)
>>       }
>>
>>       /* Ensure we have minimal gpio selected CMD/CLK/Detect */
>> -     if (pdata->cfg_gpio)
>> -             pdata->cfg_gpio(pdev, pdata->max_width);
>> +     pstate = pdata->max_width ? "sdhci-pcfg8" : "sdhci-pcfg4";
> You should check pdata->max_width == 8 instead of max_width itself.

Thanks. I will fix that.

> BTW if platform set the amx_width as 1. How do you handle this?

If the bus width is 1, we need to add pin map entry for 1 bit bus
width and correspondingly change the code here. I used the sdhci-s3c
driver for testing the samsung pinctrl driver and only tested with
4-bit and 8-bit bus width. The changes in this patch are not final yet
and was mainly included in this series to show how platform callbacks
can be removed.

Thanks,
Thomas.
