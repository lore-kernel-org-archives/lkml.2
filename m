Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2IQL5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:57:19 -0400
Received: from smtp-out-029.synserver.de ([212.40.185.29]:1147 "EHLO
	smtp-out-029.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2IQL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:57:16 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21961
Message-ID: <50571045.9030304@metafoo.de>
Date: Mon, 17 Sep 2012 13:57:57 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: anish singh <anish198519851985@gmail.com>
CC: jic23@cam.ac.uk, cbou@mail.ru, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] [V1]power: battery: Generic battery driver using IIO
References: <1347779683-5025-1-git-send-email-anish198519851985@gmail.com> <5055F31E.30905@metafoo.de> <CAK7N6vrRF1XdMstnM2UcBof4TM-NR3g7bUBn_noZk+aZZiGyrQ@mail.gmail.com>
In-Reply-To: <CAK7N6vrRF1XdMstnM2UcBof4TM-NR3g7bUBn_noZk+aZZiGyrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 05:57 AM, anish singh wrote:
> Hello Lars,
> 
> Thanks for the review.All of you comments are valid but
> i just have a small question w.r.t one of your comments.
> Inline below.
> 
> On Sun, Sep 16, 2012 at 9:11 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 09/16/2012 09:14 AM, anish kumar wrote:
>>> From: anish kumar <anish198519851985@gmail.com>
>>>
>>> In last version:
>>> Addressed concerns raised by lars:
>>> a. made the adc_bat per device.
>>> b. get the IIO channel using hardcoded channel names.
>>> c. Minor issues related to gpio_is_valid and some code
>>>    refactoring.
>>>
>>> In this version:
>>> Addressed concerns raised by Anton:
>>> a. changed the struct name to gab(generic adc battery).
>>> b. Added some functions to neaten the code.
>>> c. Some minor coding guidelines changes.
>>> d. Used the latest function introduce by lars:
>>>    iio_read_channel_processed to streamline the code.
>>>
>>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>>> ---
>>>  drivers/power/generic-adc-battery.c       |  442 +++++++++++++++++++++++++++++
>>>  include/linux/power/generic-adc-battery.h |   19 ++
>>>  2 files changed, 461 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/power/generic-adc-battery.c
>>>  create mode 100644 include/linux/power/generic-adc-battery.h
>>>
>>> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
>>> new file mode 100644
>>> index 0000000..fd62916
>>> --- /dev/null
>>> +++ b/drivers/power/generic-adc-battery.c
>>> @@ -0,0 +1,442 @@
>>> +/*
>>> + * Generic battery driver code using IIO
>>> + * Copyright (C) 2012, Anish Kumar <anish198519851985@gmail.com>
>>> + * based on jz4740-battery.c
>>> + * based on s3c_adc_battery.c
>>> + *
>>> + * This file is subject to the terms and conditions of the GNU General Public
>>> + * License.  See the file COPYING in the main directory of this archive for
>>> + * more details.
>>> + *
>>> + */
>>> +#include <linux/interrupt.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/power_supply.h>
>>> +#include <linux/gpio.h>
>>> +#include <linux/err.h>
>>> +#include <linux/timer.h>
>>> +#include <linux/jiffies.h>
>>> +#include <linux/errno.h>
>>> +#include <linux/init.h>
>>> +#include <linux/module.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/iio/consumer.h>
>>> +#include <linux/iio/types.h>
>>> +#include <linux/power/generic-adc-battery.h>
>>> +
>>> +enum gab_chan_type {
>>> +     VOLTAGE = 0,
>>> +     CURRENT,
>>> +     POWER,
>>> +     MAX_CHAN_TYPE
>>> +};
>>> +
>>> +/*
>>> + * gab_chan_name suggests the standard channel names for commonly used
>>> + * channel types.
>>> + */
>>> +static char *gab_chan_name[] = {
>>
>> const char *const
>>
>>> +     [VOLTAGE]       = "voltage",
>>> +     [CURRENT]       = "current",
>>> +     [POWER]         = "power",
>>> +};
>>> +
>>> +struct gab {
>>> +     struct power_supply     psy;
>>> +     struct iio_channel      **channel;
>>> +     struct gab_platform_data        *pdata;
>>> +     struct delayed_work bat_work;
>>> +     int             was_plugged;
>>> +     int             volt_value;
>>> +     int             cur_value;
>>
>> The two above are never really used.
>>
>>> +     int             level;
>>> +     int             status;
>>> +     int             cable_plugged:1;
>>> +};
>> [...]
>>> +static enum power_supply_property gab_props[] = {
>> const
>>> +     POWER_SUPPLY_PROP_STATUS,
>>> +     POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
>>> +     POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
>>> +     POWER_SUPPLY_PROP_CHARGE_NOW,
>>> +     POWER_SUPPLY_PROP_VOLTAGE_NOW,
>>> +     POWER_SUPPLY_PROP_CURRENT_NOW,
>>> +     POWER_SUPPLY_PROP_TECHNOLOGY,
>>> +     POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>>> +     POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
>>> +     POWER_SUPPLY_PROP_MODEL_NAME,
>>> +};
>>> +
>>> +/*
>>> + * This properties are set based on the received platform data and this
>>> + * should correspond one-to-one with enum chan_type.
>>> + */
>>> +static enum power_supply_property gab_dyn_props[] = {
>> const
>>> +     POWER_SUPPLY_PROP_VOLTAGE_NOW,
>>> +     POWER_SUPPLY_PROP_CURRENT_NOW,
>>> +     POWER_SUPPLY_PROP_POWER_NOW,
>>> +};
>>> +
>>> +static bool charge_finished(struct gab *adc_bat)
>>
>> missing prefix
>>
>>> +{
>>> +     bool ret = gpio_get_value(adc_bat->pdata->gpio_charge_finished);
>>> +     bool inv = adc_bat->pdata->gpio_inverted;
>>> +
>>> +     return ret ^ inv;
>>> +}
>>> +
>>> +int gab_get_status(struct gab *adc_bat)
>> static
>>> +{
>>> +     struct gab_platform_data *pdata = adc_bat->pdata;
>>> +     int chg_gpio = pdata->gpio_charge_finished;
>>> +
>>> +     if (!gpio_is_valid(chg_gpio) || adc_bat->level < 100000)
>>
>> level is never really set, is it? Also the 100000 seems to come directly from
>> the s3c_adc_battery driver, while this value may be different for every
>> battery. I'd use the bat_info->charge_full_design here. Also I'd remove the
>> !gpio_is_valid(chg_gpio)  I don't see a reason why the battery could not be
>> fully charged even though no charger gpio is given.
> gpio_is_valid is just a call to check if the particular gpio is valid or not[1].
> I don't seem to understand why we are using it everywhere when only in probe it
> makes sense as far as my understanding goes.If in probe it is proper then why
> this check again and again(?) or is it possible that someone else
> does something somewhere which necessitates this gpio_is_valid check.
> 
> And we are using charger gpio in the probe function.
> 

Well, the charger gpio is optional. The behavior of the driver needs to be
different at some points whether a gpio is provided or not. E.g. if it is
not provided we do not know whether the device is currently being charged or
not.

- Lars

