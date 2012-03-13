Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2CMGoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:44:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57295 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2CMGoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120313034306.16CF73E07E4@localhost>
References: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
	<1330000688-11226-3-git-send-email-thomas.abraham@linaro.org>
	<20120313034306.16CF73E07E4@localhost>
Date: Tue, 13 Mar 2012 12:14:42 +0530
Message-ID: <CAJuYYwRAXyU7d7qhGUX-=qWUJ0M1KB3XCGPOnUxToP=0XOhzqg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2012 09:13, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, 23 Feb 2012 18:08:08 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> Add device tree based discovery support for max8997.
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  .../devicetree/bindings/regulator/max8997-pmic.txt |  134 +++++++++++++++++++
>>  drivers/mfd/max8997.c                              |   72 ++++++++++-
>>  drivers/regulator/max8997.c                        |  139 +++++++++++++++++++-
>>  include/linux/mfd/max8997.h                        |    1 +
>>  4 files changed, 344 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/regulator/max8997-pmic.txt
>>

[...]

>> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
>> index 20ecad3..13180be 100644
>> --- a/drivers/mfd/max8997.c
>> +++ b/drivers/mfd/max8997.c
>> @@ -23,6 +23,7 @@
>>
>>  #include <linux/slab.h>
>>  #include <linux/i2c.h>
>> +#include <linux/of_irq.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/module.h>
>> @@ -123,6 +124,60 @@ int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
>>  }
>>  EXPORT_SYMBOL_GPL(max8997_update_reg);
>>
>> +#ifdef CONFIG_OF
>> +/*
>> + * Only the common platform data elements for max8997 are parsed here from the
>> + * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
>> + * to parse their own platform data elements from device tree.
>> + *
>> + * The max8997 platform data structure is instantiated here and the drivers for
>> + * the sub-modules need not instantiate another instance while parsing their
>> + * platform data.
>> + */
>> +static int max8997_i2c_parse_dt_pdata(struct device *dev,
>> +                                     struct max8997_platform_data **pdata)
>> +{
>> +     struct max8997_platform_data *pd;
>> +
>> +     pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
>> +     if (!pd) {
>> +             dev_err(dev, "could not allocate memory for pdata\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     pd->ono = irq_of_parse_and_map(dev->of_node, 1);
>> +
>> +     /*
>> +      * ToDo: the 'wakeup' member in the platform data is more of a linux
>> +      * specfic information. Hence, there is no binding for that yet and
>> +      * not parsed here.
>> +      */
>> +
>> +     *pdata = pd;
>> +     return 0;
>> +}
>> +#else
>> +static int max8997_i2c_parse_dt_pdata(struct device *dev,
>> +                                     struct max8997_platform_data **pdata)
>> +{
>> +     return 0;
>> +}
>> +#endif
>> +
>> +static struct of_device_id __devinitdata max8997_pmic_dt_match[];
>
> Move the actual definition of this structure up to here so that a forward
> declaration becomes unnecessary.
>

Ok.

>> +static inline int max8997_i2c_get_driver_data(struct i2c_client *i2c,
>> +                                             const struct i2c_device_id *id)
>> +{
>> +#ifdef CONFIG_OF
>> +     if (i2c->dev.of_node) {
>> +             const struct of_device_id *match;
>> +             match = of_match_node(max8997_pmic_dt_match, i2c->dev.of_node);
>> +             return (int)match->data;
>> +     }
>> +#endif
>> +     return (int)id->driver_data;
>> +}
>> +
>>  static int max8997_i2c_probe(struct i2c_client *i2c,
>>                           const struct i2c_device_id *id)
>>  {
>> @@ -137,9 +192,16 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>>       i2c_set_clientdata(i2c, max8997);
>>       max8997->dev = &i2c->dev;
>>       max8997->i2c = i2c;
>> -     max8997->type = id->driver_data;
>> +     max8997->type = max8997_i2c_get_driver_data(i2c, id);
>>       max8997->irq = i2c->irq;
>>
>> +     if (max8997->dev->of_node) {
>> +             ret = max8997_i2c_parse_dt_pdata(max8997->dev, &pdata);
>> +             if (ret)
>> +                     goto err;
>> +             i2c->dev.platform_data = pdata;
>
> This line is illegal.  Drivers must *not* change the value of dev->platform_data.
> instead the valid pdata pointer needs to be stored in the max8997 private data
> structure.

The intention here was to let the max8897 driver's mfd portion create
an 'common' instance of max8897 platform data and allow the max8997
sub-drivers such as the pmic driver and charger driver use that
'common' instance to populate their respective platform data portions
from dt. But, assigning that allocated pdata pointer to
i2c->dev.platform_data was not correct, I agree.

Instead, a new pointer to 'struct max8997_platform_data' will be added
to 'struct max8997_dev', assign the pdata in the mfd driver to this
new member and let the sub-drivers use the pdata pointer in 'struct
max8997_dev'. I will do this change and repost this patch.

>
>> +     }
>> +
>
> If you tweak the definition of max8997_i2c_parse_dt_pdata() then this block can
> be simplified to:
>
>        pdata = max8997_i2c_parse_dt_pdata(max8997->dev, &pdata);
>        if (!pdata)
>                pdata = i2c->dev.platform_data,
>        if (!pdata)
>                goto err;
>
>
> Otherwise, the patch looks pretty good.  (although seeing the decode function
> has got me thinking that we need a much better way of decoding the dt data).

The parsing function looks huge since there is lot of data to pick up
from the dt node.

Thanks for your comments.

Regards,
Thomas.

[...]

>
> g.
