Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0CXKbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0CXKbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:31:11 -0400
Message-ID: <4BA9EA0C.6070200@redhat.com>
Date: Wed, 24 Mar 2010 11:31:40 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hwmon: f71882fg: Add support for the Fintek F71808E
References: <20100323141718.GA23172@salidar.me.mortis.eu> <1269385936-3440-1-git-send-email-me@mortis.eu> <4BA9CC64.5010807@redhat.com> <20100324092357.GE6368@salidar.me.mortis.eu>
In-Reply-To: <20100324092357.GE6368@salidar.me.mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/24/2010 10:23 AM, Giel van Schijndel wrote:
> On Wed, Mar 24, 2010 at 09:25:08AM +0100, Hans de Goede wrote:
>> See comments inline.
>>
>> On 03/24/2010 12:12 AM, Giel van Schijndel wrote:
>>> Allow device probing to recognise the Fintek F71808E.
>>>
>>> Sysfs interface:
>>>    * Fan/pwm control is the same as for F71889FG
>>>    * Temperature and voltage sensor handling is largely the same as for
>>>      the F71889FG
>>>     - Has one temperature sensor less (doesn't have temp3)
>>>     - Misses one voltage sensor (doesn't have V6, thus in6_input refers to
>>>       what in7_input refers for F71889FG)
>>>
>>> For the purpose of the sysfs interface fxxxx_in_temp_attr[] is split up
>>> such that it can largely be reused.
>>> ---
>>>    Documentation/hwmon/f71882fg |    4 ++
>>>    drivers/hwmon/Kconfig        |    6 ++--
>>>    drivers/hwmon/f71882fg.c     |   80 +++++++++++++++++++++++++++++++++++++----
>>>    3 files changed, 79 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
>>> index 25e1cad..b290b87 100644
>>> --- a/drivers/hwmon/f71882fg.c
>>> +++ b/drivers/hwmon/f71882fg.c
>>> @@ -1974,8 +2002,27 @@ static int __devinit f71882fg_probe(struct platform_device *pdev)
>>>    			/* fall through! */
>>>    		case f71862fg:
>>>    			err = f71882fg_create_sysfs_files(pdev,
>>> -					fxxxx_in_temp_attr,
>>> -					ARRAY_SIZE(fxxxx_in_temp_attr));
>>> +					f71862_temp_attr,
>>> +					ARRAY_SIZE(f71862_temp_attr));
>>> +			if (err)
>>> +				goto exit_unregister_sysfs;
>>> +			err = f71882fg_create_sysfs_files(pdev,
>>> +					fxxxx_in_attr,
>>> +					ARRAY_SIZE(fxxxx_in_attr));
>>> +			if (err)
>>> +				goto exit_unregister_sysfs;
>>> +			/* fall through! */
>>
>> Ugh, please don't fall through, and then have an if below to only do
>> some parts of the case falling through. This is quite confusing
>> at first I thought your code was buggy I had to read it twice to notice
>> the if. Instead just duplicate the following lines:
>>> +			err = f71882fg_create_sysfs_files(pdev,
>>> +					fxxxx_temp_attr,
>>> +					ARRAY_SIZE(fxxxx_temp_attr));
>> In the f71862fg case, end the f71862fg case with a break and remove
>> the if test from the f71808fg case.
>>
>>> +		case f71808fg:
>>> +			if (data->type == f71808fg) {
>>> +				err = f71882fg_create_sysfs_files(pdev,
>>> +						f71808_in_attr,
>>> +						ARRAY_SIZE(f71808_in_attr));
>>> +				if (err)
>>> +					goto exit_unregister_sysfs;
>>> +			}
>>> +			err = f71882fg_create_sysfs_files(pdev,
>>> +					fxxxx_temp_attr,
>>> +					ARRAY_SIZE(fxxxx_temp_attr));
>>>    			break;
>>>    		case f8000:
>>>    			err = f71882fg_create_sysfs_files(pdev,
>>> @@ -2126,8 +2175,20 @@ static int f71882fg_remove(struct platform_device *pdev)
>>>    			/* fall through! */
>>>    		case f71862fg:
>>>    			f71882fg_remove_sysfs_files(pdev,
>>> -					fxxxx_in_temp_attr,
>>> -					ARRAY_SIZE(fxxxx_in_temp_attr));
>>> +					f71862_temp_attr,
>>> +					ARRAY_SIZE(f71862_temp_attr));
>>> +			f71882fg_remove_sysfs_files(pdev,
>>> +					fxxxx_in_attr,
>>> +					ARRAY_SIZE(fxxxx_in_attr));
>>> +			/* fall through! */
>>
>> Idem.
>
> Ack. New and improved patch follows this line.
> ========================================================================
> hwmon: f71882fg: Add support for the Fintek F71808E
>

This new version looks good to me:
Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
