Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031290Ab2CAPLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:11:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20155 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031255Ab2CAPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:11:19 -0500
Date: Thu, 01 Mar 2012 16:11:16 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 1/3] [media] s5p-tv: Add initial DT-support for sii9234
In-reply-to: <CAJuYYwRSgHLyWSaAyxAWwdSzUHXRmGTirgi_Wvcsfd89kWDx0g@mail.gmail.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F4F9194.5010705@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1330527107-21222-1-git-send-email-k.lewandowsk@samsung.com>
 <1330527107-21222-2-git-send-email-k.lewandowsk@samsung.com>
 <CAJuYYwRSgHLyWSaAyxAWwdSzUHXRmGTirgi_Wvcsfd89kWDx0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.03.2012 04:09, Thomas Abraham wrote:

> Hi Karol,


Hi!


> On 29 February 2012 20:21, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
>> Make it possible to instantiate sii9234, HDMI's MHL, from regular
>> device tree description.
>>
>> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/devicetree/bindings/i2c/sii9234.txt |   14 ++++++++++++++
>>  drivers/media/video/s5p-tv/sii9234_drv.c          |   20 +++++++++++++++++++-
>>  2 files changed, 33 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/i2c/sii9234.txt
>>
>> diff --git a/Documentation/devicetree/bindings/i2c/sii9234.txt b/Documentation/devicetree/bindings/i2c/sii9234.txt
>> new file mode 100644
>> index 0000000..7bb7636
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/i2c/sii9234.txt
>> @@ -0,0 +1,14 @@
>> +* SII 9234
>> +
> 
> A minimal description about this device would be helpful here.
> 
>> +Required properties :
>> + - compatible : "sii,9234"
> 
> To be more informative, can this be changed to "sil,mhl-9234".


Thanks for pointing this out - I'll fix compat string and add description.

> 
>> + - reg        : i2c device address
>> + - gpio-reset : gpio line used to reset IC
>> +
>> +Example:
>> +
>> +       mhl@39 {
>> +               compatible = "sii,9234";
>> +               reg = <0x39>;
>> +               gpio-reset = <&gpf3 4 0 0 0>;
>> +       };
>> diff --git a/drivers/media/video/s5p-tv/sii9234_drv.c b/drivers/media/video/s5p-tv/sii9234_drv.c
>> index 0f31ecc..0a1511a 100644
>> --- a/drivers/media/video/s5p-tv/sii9234_drv.c
>> +++ b/drivers/media/video/s5p-tv/sii9234_drv.c
>> @@ -22,6 +22,8 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/regulator/machine.h>
>>  #include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/of_gpio.h>
>>
>>  #include <mach/gpio.h>
>>  #include <plat/gpio-cfg.h>
>> @@ -338,7 +340,15 @@ static int __devinit sii9234_probe(struct i2c_client *client,
>>                goto fail_ctx;
>>        }
>>
>> -       ctx->gpio_n_reset = pdata->gpio_n_reset;
>> +       if (dev->of_node) {
>> +               ctx->gpio_n_reset = of_get_named_gpio(dev->of_node, "gpio-reset", 0);
>> +               if (ctx->gpio_n_reset < 0) {
> 
> if (gpio_is_valid(ctx->gpio_n_reset)) can be used here.


Will fix, I wasn't aware of this either.

> 
>> +                       ret = -ENODEV;
>> +                       goto fail_power;
>> +               }
>> +       } else
>> +               ctx->gpio_n_reset = pdata->gpio_n_reset;
> 
> linux coding style suggests to have braces for 'else' branch when
> braces are used for the 'if' branch.


Ok.

> 
>> +
>>        ret = gpio_request(ctx->gpio_n_reset, "MHL_RST");
>>        if (ret) {
>>                dev_err(dev, "failed to acquire MHL_RST gpio\n");
>> @@ -401,6 +411,13 @@ static int __devexit sii9234_remove(struct i2c_client *client)
>>        return 0;
>>  }
>>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id sii9234_dt_match[] = {
>> +       { .compatible = "sii,9234" },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(of, sii9234_dt_match);
>> +#endif
>>
>>  static const struct i2c_device_id sii9234_id[] = {
>>        { "SII9234", 0 },
>> @@ -413,6 +430,7 @@ static struct i2c_driver sii9234_driver = {
>>                .name   = "sii9234",
>>                .owner  = THIS_MODULE,
>>                .pm = &sii9234_pm_ops,
>> +               .of_match_table = of_match_ptr(sii9234_dt_match),
>>        },
>>        .probe          = sii9234_probe,
>>        .remove         = __devexit_p(sii9234_remove),
>> --
>> 1.7.8.3
>>
> 
> Thanks,
> Thomas.


Thanks for reviewing this!

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
