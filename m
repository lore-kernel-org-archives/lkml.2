Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0KEIxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 04:53:43 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44127 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200Ab0KEIxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 04:53:41 -0400
Message-ID: <4CD3C5E7.1030301@euromail.se>
Date: Fri, 05 Nov 2010 09:52:55 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 5/8] hwmon: applesmc: Extract all features
 generically
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <1288511434-5662-6-git-send-email-rydberg@euromail.se> <20101105025020.GD28308@ericsson.com>
In-Reply-To: <20101105025020.GD28308@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PEI36-0003W8-8R.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PEI36-0003W8-8R add330733ec5d4cfe21e7c21e38338c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  /* Dynamic device node attributes */

>>  struct applesmc_dev_attr {
>>         struct sensor_device_attribute sda;     /* hwmon attributes */
>> @@ -145,6 +135,10 @@ static struct applesmc_registers {
>>         unsigned int temp_count;        /* number of temperature registers */
>>         unsigned int temp_begin;        /* temperature lower index bound */
>>         unsigned int temp_end;          /* temperature upper index bound */
>> +       bool has_accelerometer;         /* has motion sensor */
>> +       bool has_left_light;            /* has left light sensor */
>> +       bool has_right_light;           /* has right light sensor */
>> +       bool has_key_light;             /* has keyboard backlight */
> 
> Maybe has_key_backlight ? Might be a bit less confusing.


Good point, thanks.

>> @@ -534,9 +535,26 @@ static int applesmc_init_smcreg_try(void)
>>                 return ret;
>>         s->temp_count = s->temp_end - s->temp_begin;
>>
>> +       ret = applesmc_has_key(LIGHT_SENSOR_LEFT_KEY, &s->has_left_light);
>> +       if (ret)
>> +               return ret;
>> +       ret = applesmc_has_key(LIGHT_SENSOR_RIGHT_KEY, &s->has_right_light);
>> +       if (ret)
>> +               return ret;
>> +       ret = applesmc_has_key(MOTION_SENSOR_KEY, &s->has_accelerometer);
>> +       if (ret)
>> +               return ret;
>> +       ret = applesmc_has_key(BACKLIGHT_KEY, &s->has_key_light);
>> +       if (ret)
>> +               return ret;
>> +
>>         s->init_complete = true;
>>
>> -       pr_info("key=%d temp=%d\n", s->key_count, s->temp_count);
>> +       pr_info("key=%d temp=%d acc=%d, light=%d, keyb=%d\n",
> 
> 	light= and keyb= are a bit confusing. Maybe at least use backlight= ?


I think "key" is important, since there are many confusions regarding lcd and
key backlight. And the dmesg line becomes awfully long quickly... I'll check.

> 
>> +              s->key_count, s->temp_count,
>> +              s->has_accelerometer,
>> +              s->has_left_light + s->has_right_light,
> 
> Resulting output is 0, 1, or 3. And "1" can mean left or right.
> Is this useful ?


Yes. Newer models seem to be moving away from the whole light sensor thing, but
a few machines had "stereo" light sensors, which later turned into a single
sensor. The "left and right" is less important than "stereo and mono", which
boils down to the number of sensors. Maybe I can change the names to make this
clearer.

>> +static int applesmc_dmi_match(const struct dmi_system_id *id)
>> +{
>> +       pr_info("%s detected\n", id->ident);
> 
> Is this useful enough to be pr_info or just noisy ?


Nah, noise. :-)

>> @@ -1468,18 +1349,20 @@ static int __init applesmc_init(void)
>>         if (ret)
>>                 goto out_fans;
>>
>> -       if (applesmc_accelerometer) {
>> +       if (smcreg.has_accelerometer) {
>>                 ret = applesmc_create_accelerometer();
>>                 if (ret)
>>                         goto out_temperature;
>>         }
>>
>> -       if (applesmc_light) {
>> +       if (smcreg.has_left_light) {
>>                 /* Add light sensor file */
>>                 ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_light.attr);
>>                 if (ret)
>>                         goto out_accelerometer;
>> +       }
>>
> So "light" == left light sensor. How about the right light sensor ?
> 
> If (theoretically) a device as only a right light sensor, you would display
> that a light sensor exists and then not create a sysfs file for it.


Yep. See comment above.

> Maybe add a right_light sysfs attribute ? Or drop the knowledge about it entirely
> since you don't use it anyway. Or merge the two into a single attribute file
> (if that makes sense).


Merging the has_left and has_right into a number might resolve the problems.

Thanks,
Henrik
