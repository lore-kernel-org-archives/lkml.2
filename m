Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1KIMdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:33:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48220 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1KIMds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:33:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111109132238.0a35ccee@endymion.delvare>
References: <1320837303-30697-1-git-send-email-eric.y.miao@gmail.com> <20111109132238.0a35ccee@endymion.delvare>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 9 Nov 2011 20:33:27 +0800
Message-ID: <CAMPhdO-LLzPLfTzwf721ut75KYcGtAsW3VeqYusAG+jw-=yVXg@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max1111) change sysfs interface to
 in[0-3]_input in millivolts
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 8:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Eric,
>
> On Wed,  9 Nov 2011 19:15:03 +0800, Eric Miao wrote:
>> This patch fixed the inconsistent max1111 sysfs interface as pointed
>> out by Jean Delvare:
>>
>>     It was pointed to me that the max1111 driver doesn't implement the
>>     standard sysfs interface for hwmon drivers (as described in
>>     Documentation/hwmon/sysfs-interface). It exports files adc[0-3]_in,
>>     which
>>     aren't part of the standard interface. Presumably these should be
>>     renamed to in[0-3]_input. Renaming them is probably not sufficient
>>     though, as I see no scaling done in the driver. As the MAX1111 chip has
>>     a documented full scale of 2.048V, I take it that the LSB of the ADC
>>     has a weight of 8 mV. Exporting raw register values to user-space is
>>     not OK.
>>
>> Reported-by: Jean Delvare <khali@linux-fr.org>
>> Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
>> ---
>>  drivers/hwmon/max1111.c |   13 +++++++------
>>  1 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
>> index c97b78e..0e9fcfd 100644
>> --- a/drivers/hwmon/max1111.c
>> +++ b/drivers/hwmon/max1111.c
>> @@ -106,11 +106,12 @@ static ssize_t show_adc(struct device *dev,
>>       if (ret < 0)
>>               return ret;
>>
>> -     return sprintf(buf, "%d\n", ret);
>> +     /* assume the reference voltage to be 2.048V */
>> +     return sprintf(buf, "%d\n", 2048 * 256 / ret);
>
> I bet you did not actually test your changes? ret == 0 would obviously
> crash the driver. The formula looks wrong anyway, should be 2048 *
> ret / 256. Or in short ret * 8, i.e. LSB weight of the ADC is 8 mV.
>

Oops, shame to death.

How about simply '2048 * ret / 256' to make it clear and leave it to
the compiler to optimize?

>>  }
>>
>>  #define MAX1111_ADC_ATTR(_id)                \
>> -     SENSOR_DEVICE_ATTR(adc##_id##_in, S_IRUGO, show_adc, NULL, _id)
>> +     SENSOR_DEVICE_ATTR(in##_id##_input, S_IRUGO, show_adc, NULL, _id)
>>
>>  static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
>>  static MAX1111_ADC_ATTR(0);
>> @@ -120,10 +121,10 @@ static MAX1111_ADC_ATTR(3);
>>
>>  static struct attribute *max1111_attributes[] = {
>>       &dev_attr_name.attr,
>> -     &sensor_dev_attr_adc0_in.dev_attr.attr,
>> -     &sensor_dev_attr_adc1_in.dev_attr.attr,
>> -     &sensor_dev_attr_adc2_in.dev_attr.attr,
>> -     &sensor_dev_attr_adc3_in.dev_attr.attr,
>> +     &sensor_dev_attr_in0_input.dev_attr.attr,
>> +     &sensor_dev_attr_in1_input.dev_attr.attr,
>> +     &sensor_dev_attr_in2_input.dev_attr.attr,
>> +     &sensor_dev_attr_in3_input.dev_attr.attr,
>>       NULL,
>>  };
>>
>
> The rest of the changes look good.
>
> --
> Jean Delvare
>
