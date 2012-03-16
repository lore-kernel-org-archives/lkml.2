Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946322Ab2CPXz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:55:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42595 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946120Ab2CPXzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:55:23 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4F63472C.5050102@metafoo.de>
References: <1331904943.2891.1.camel@phoenix> <4F63472C.5050102@metafoo.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 17 Mar 2012 07:55:00 +0800
Message-ID: <CAF+7xWmV71m4HR4wk-X1WxudNR5AFEuKpa=1wDa2Eo8krmLOcQ@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/drivers/regulator/pcf50633-regulator.c
>> +++ b/drivers/regulator/pcf50633-regulator.c
>> @@ -52,7 +52,7 @@ static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
>>[...]
>>
>> @@ -161,6 +158,9 @@ static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
>>
>>       switch (id) {
>>       case PCF50633_REGULATOR_AUTO:
>> +             /* AUTOOUT: 00000000 to 00101110 are reserved */
>> +             if (bits < 0x2f)
>> +                     return -EINVAL;
>>               millivolts = auto_voltage_value(bits);
>>               break;
>>       case PCF50633_REGULATOR_DOWN1:
>> @@ -208,20 +208,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
>>  static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
>>                                               unsigned int index)
>>  {
>> -     struct pcf50633 *pcf;
>> -     int regulator_id;
>> -
>> -     pcf = rdev_get_drvdata(rdev);
>> -
>> -     regulator_id = rdev_get_id(rdev);
>> -
>> -     switch (regulator_id) {
>> -     case PCF50633_REGULATOR_AUTO:
>> -             index += 0x2f;
>> -             break;
>> -     default:
>> -             break;
>> -     }
>
> Does this make sense? Now we return -EINVAL if index is less than 0x2f
>
>
I check the code and regulator core again.
I think for this case we should return 0 instead of -EINVAL.

/**
 * regulator_list_voltage - enumerate supported voltages
 * @regulator: regulator source
 * @selector: identify voltage to list
 * Context: can sleep
 *
 * Returns a voltage that can be passed to @regulator_set_voltage(),
 * zero if this selector code can't be used on this system, or a
 * negative errno.
 */

I'll send a V2 soon.
Thanks for the review.
Axel
