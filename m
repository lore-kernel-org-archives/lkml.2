Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0CWLHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab0CWLHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:07:18 -0400
Message-ID: <4BA8A100.3000301@redhat.com>
Date: Tue, 23 Mar 2010 12:07:44 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Giel van Schijndel <me@mortis.eu>, Jonathan Cameron <jic23@cam.ac.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Hwmon: f71882fg: use strict_stro(l|ul) instead of
  simple_strto$1
References: <1269185834-10266-1-git-send-email-me@mortis.eu>	<1269185834-10266-2-git-send-email-me@mortis.eu>	<20100322112308.13d58db4@hyperion.delvare>	<20100322114157.GA14077@salidar.me.mortis.eu> <20100323115921.7d094e64@hyperion.delvare>
In-Reply-To: <20100323115921.7d094e64@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/23/2010 11:59 AM, Jean Delvare wrote:
> Hi Giel,
>
> On Mon, 22 Mar 2010 12:41:57 +0100, Giel van Schijndel wrote:
>> On Mon, Mar 22, 2010 at 11:23:08AM +0100, Jean Delvare wrote:
>>> On Sun, 21 Mar 2010 16:37:14 +0100, Giel van Schijndel wrote:
>>>> Use the strict_strol and strict_stroul functions instead of simple_strol
>>>> and simple_stroul respectively in sysfs functions.
>>>>
>>>> Signed-off-by: Giel van Schijndel<me@mortis.eu>
>>>> ---
>>>>   drivers/hwmon/f71882fg.c |   89 ++++++++++++++++++++++++++++++++++++++--------
>>>>   1 files changed, 74 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
>>>> index 21bc661..5c725a3 100644
>>>> --- a/drivers/hwmon/f71882fg.c
>>>> +++ b/drivers/hwmon/f71882fg.c
>>>> @@ -1128,7 +1128,10 @@ static ssize_t store_fan_full_speed(struct device *dev,
>>>>   {
>>>>   	struct f71882fg_data *data = dev_get_drvdata(dev);
>>>>   	int nr = to_sensor_dev_attr_2(devattr)->index;
>>>> -	long val = simple_strtol(buf, NULL, 10);
>>>> +	long val;
>>>> +
>>>> +	if (strict_strtol(buf, 10,&val) == -EINVAL)
>>>> +		return -EINVAL;
>>>
>>> That's not correct. You want to return an error if strict_strtol()
>>> returns _any_ error, not just -EINVAL. Maybe the current
>>> implementation can't return any other error code, but you should not
>>> assume this will always be the case in the future.
>>
>> Agreed. New patch follows this line:
>> ------------------------------------------------------------------------
>> Hwmon: f71882fg: use strict_stro(l|ul) instead of simple_strto$1
>>
>> Use the strict_strol and strict_stroul functions instead of simple_strol
>> and simple_stroul respectively in sysfs functions.
>>
>> Signed-off-by: Giel van Schijndel<me@mortis.eu>
>> ---
>>   drivers/hwmon/f71882fg.c |  133 ++++++++++++++++++++++++++++++++++++----------
>>   1 files changed, 104 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
>> index 21bc661..4230729 100644
>> --- a/drivers/hwmon/f71882fg.c
>> +++ b/drivers/hwmon/f71882fg.c
>> @@ -1127,8 +1127,12 @@ static ssize_t store_fan_full_speed(struct device *dev,
>>   				    const char *buf, size_t count)
>>   {
>>   	struct f71882fg_data *data = dev_get_drvdata(dev);
>> -	int nr = to_sensor_dev_attr_2(devattr)->index;
>> -	long val = simple_strtol(buf, NULL, 10);
>> +	int err, nr = to_sensor_dev_attr_2(devattr)->index;
>> +	long val;
>> +
>> +	err = strict_strtol(buf, 10,&val);
>> +	if (err)
>> +		return err;
>>
>>   	val = SENSORS_LIMIT(val, 23, 1500000);
>>   	val = fan_to_reg(val);
>> (...)
>
> Looks good to me this time. I'll apply this patch unless Hans objects.
>

No objections from me, IOW I'm still ack.

Regards,

Hans
