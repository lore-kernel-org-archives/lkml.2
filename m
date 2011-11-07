Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1KGEfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 23:35:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1KGEfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 23:35:40 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20111106055343.GA21533@ericsson.com>
References: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
	<20111106055343.GA21533@ericsson.com>
Date: Mon, 7 Nov 2011 13:35:36 +0900
X-Google-Sender-Auth: Y7qXJf8JxXZA7KY8CwnT_kdqtc0
Message-ID: <CAJ0PZbQsvz36uN4MDf5EmB_88ttP=5v7JhbB-D5+wE6W5_4BcQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] HWMON: add in-kernel interfaces to read sensor values.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "dg77.kim@samsung.com" <dg77.kim@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 2:53 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Fri, Nov 04, 2011 at 02:50:31AM -0400, MyungJoo Ham wrote:
>> We have been reading hwmon values (TMU, the SoC-core temperature sensor,
>> and NTC, the ambient or battery surface temperature sensor) for
>> Charger-Manager. However, because hwmon does not have in-kernel interface,
>> we have been using undesired method, including "../../../fs/*.h".
>>
>> This patch is to provide in-kernel interface for hwmon:
>> hwmon_get_value and hwmon_set_value. In order to use these two functions,
>> the hwmon driver should provide its sysfs attributes to hwmon framework
>> as well. If the hwmon driver does not provide (by providing NULL), the users
>> of the hwmon won't be able to use hwmon_get/set_value();
>> The sysfs attribute (struct attribuyte_group *) is provided with
>> hwmon_device_register; adding the second parameter to hwmon_device_register().
>> The 2/2 patch shows the changes in device drivers due to this.
>>
>> Among the HWMON device, all but ntc_thermistor.c does not setup attribute_group
>> for HWMON; thus they do not support hwmon_get/set_value with this patch.
>>
>> As soon as the server synchronizes git repositories, you can see how
>> hwmon_get_value() is used at:
>> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/charger-manager
>>
> Hi,
>
> I agree that we'll need a solution for the callback problem at some point.
> However, I have a number of concerns with the approach used in your patch set.
>
> The first patch breaks compilation. It changes the API w/o making the same changes
> in the affected drivers. This is unacceptable. Each patch of a patch series must
> result in working code.

Hello,

I simply thought having a single patch with API change and device
driver change altogether too ugly.
Anyway, by adding another API function to add get/set properties to
HWMON drivers, the need for this issue will disappear.

>
> Merging functionality into one function and then breaking out again, as you do with
> the set/get functions, results in unnecessarily complexity.
>        {set, get} -> access(flag) --> {set, get}
> Better write separate functions and keep the common code in a function called by the
> {set, get} functions.

Ok.

>
> We should not have to change the API for every caller, especially if many of those will
> never benefit from the new API. It would be better to define a new API function and map
> the old API function to the new one. Saves a lot of calls with unnecessary "NULL" parameter,
> and coincidentially reduces the patch size and avoids the breakage mentioned above.
>

Good. I'd like to add a new API function for this functionality, too.
I guess that it'd be easier to address your following comments by
adding another API function.

> The get and set functions are extremely expensive, having to loop through the list
> of attributes and performing a string comparison on each attribute to find the sensor.
>
> The proposed change only works for a small subset of drivers, those with a well defined
> single attribute groups. If and when we implement a solution for the internal-API
> problem, it should work for all hwmon drivers, not only for a small subset.
>
> Thanks,
> Guenter
>
>

Thank you.


Cheers!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
