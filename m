Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0HSKE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:04:58 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:47303 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0HSKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:04:56 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C6D02B2.4020802@jic23.retrosnub.co.uk>
Date: Thu, 19 Aug 2010 11:08:50 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100808 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        m.szyprowski@samsung.com, broonie@opensource.wolfsonmicro.com,
        jy0922.shim@samsung.com
Subject: Re: [PATCH] MFD: LP3974 PMIC support
References: <20100802035422.GA2883@july>	<AANLkTimkd5HLs7EyCX3--VO8fyJhXCBG-KMuG9wr0ZZk@mail.gmail.com>	<4C6D0025.1090502@jic23.retrosnub.co.uk> <AANLkTimmygeV-eaYHTXPhX+2cimHGP5W-3jt_mesAp8s@mail.gmail.com>
In-Reply-To: <AANLkTimmygeV-eaYHTXPhX+2cimHGP5W-3jt_mesAp8s@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/10 10:56, Kyungmin Park wrote:
> On Thu, Aug 19, 2010 at 6:57 PM, Jonathan Cameron
> <kernel@jic23.retrosnub.co.uk> wrote:
>> On 08/19/10 06:08, Kyungmin Park wrote:
>>> Any comments? I hope it's included the 2.6.36 if possible.
>> One request for clarification below....
>>>
>>> Thank you,
>>> Kyungmin Park
>>>
>>> On Mon, Aug 2, 2010 at 12:54 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>>>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>>>
>>>> LP3974 PMIC support. It has same functionality with max8998.
>>>>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>>> index db63d40..50383b1 100644
>>>> --- a/drivers/mfd/Kconfig
>>>> +++ b/drivers/mfd/Kconfig
>>>> @@ -303,6 +303,18 @@ config MFD_MAX8998
>>>>          accessing the device, additional drivers must be enabled in order
>>>>          to use the functionality of the device.
>>>>
>>>> +config MFD_LP3974
>>>> +       bool "National Semiconductor LP3974 PMIC Support"
>>>> +       depends on I2C=y
>>>> +       select MFD_CORE
>>>> +       select MFD_MAX8998
>>>> +       help
>>>> +         Say yes here to support for National Semiconductor LP3974. This is
>>>> +         a Power Management IC. This driver provies common support for
>>>> +         accessing the device, additional drivers must be enabled in order
>>>> +         to use the functionality of the device.
>>>> +         Note that it has same functionality with max8998.
>> What is gained from adding a second kconfig option?
>> Numerous drivers throughout the kernel support very differently named parts, so why
>> not just change the text for the MFD_MAX8998 to say it supports this part as well?
> 
> I also consider that. If I got the LP3974 but can't find a config so
> it's some confused.
> Well, I will modify the MAX8998 comment. if you want
Not my area of the kernel, so up to maintainers for what they would prefer.
Having worked on drivers supporting 10s of different parts I'm personally
anti this as I see it as bloat.

Actually, looking a little more closely...

Currently no use is being made of the enum.
You could turn this patch into a simple change to the Kconfig comment
and 
 { "max8998", 0 },
+{ "lp3874", 0 },
 {}

Unless there is a follow up patch using the enum, the usual principle
of don't add code that isn't used applies.  Also, that makes the patch
even more trivial and so easier to merge post merge window.

Jonathan
> 
> Thank you,
> Kyungmin Park
> 
>>>> +
>>>>  config MFD_WM8400
>>>>        tristate "Support Wolfson Microelectronics WM8400"
>>>>        select MFD_CORE
>>>> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
>>>> index 0d68de2..cea9f48 100644
>>>> --- a/drivers/mfd/max8998.c
>>>> +++ b/drivers/mfd/max8998.c
>>>> @@ -30,6 +30,11 @@
>>>>  #include <linux/mfd/max8998.h>
>>>>  #include <linux/mfd/max8998-private.h>
>>>>
>>>> +enum max8998_type {
>>>> +       TYPE_MAX8998,
>>>> +       TYPE_LP3974,
>>>> +};
>>>> +
>>>>  static struct mfd_cell max8998_devs[] = {
>>>>        {
>>>>                .name = "max8998-pmic",
>>>> @@ -127,8 +132,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
>>>>  }
>>>>
>>>>  static const struct i2c_device_id max8998_i2c_id[] = {
>>>> -       { "max8998", 0 },
>>>> -       { }
>>>> +       { "max8998", TYPE_MAX8998 },
>>>> +       { "lp3974", TYPE_LP3974 },
>>>>  };
>>>>  MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>

