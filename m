Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1KQGvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:51:32 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49842 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1KQGva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:51:30 -0500
Message-ID: <4EC4AEF7.7030803@kernel.org>
Date: Thu, 17 Nov 2011 06:51:35 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Lars-Peter Clausen <lars@metafoo.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jean Delvare <khali@linux-fr.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 1/5] drivercore: Generalize module_platform_driver
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-2-git-send-email-lars@metafoo.de> <CACxGe6twCU9Nb+b00ei83jxaz0YnVa6nT0ra6Kp0c4PO7hjT6Q@mail.gmail.com>
In-Reply-To: <CACxGe6twCU9Nb+b00ei83jxaz0YnVa6nT0ra6Kp0c4PO7hjT6Q@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:11 PM, Grant Likely wrote:
> On Wed, Nov 16, 2011 at 2:13 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> This patch generalizes the module_platform_driver macro and introduces a new
>> module_driver macro. The module_driver macro takes a driver name, a register
>> and a unregister function for this driver type. Using these it construct the
>> module init and exit sections which register and unregister the driver. Since
>> such init/exit sections are commonly found in drivers this macro can be used
>> to eliminate a lot of boilerplate code.
>>
>> The macro is not intended to be used by driver modules directly, instead it
>> should be used to generate bus specific macros for registering drivers like
>> the module_platform_driver macro.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> 
>> ---
>>  include/linux/init.h            |   21 +++++++++++++++++++++
>>  include/linux/platform_device.h |   12 ++----------
>>  2 files changed, 23 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/init.h b/include/linux/init.h
>> index 9146f39..3e2d238 100644
>> --- a/include/linux/init.h
>> +++ b/include/linux/init.h
>> @@ -346,4 +346,25 @@ void __init parse_early_options(char *cmdline);
>>  #define __exit_p(x) NULL
>>  #endif
>>
>> +/**
>> + * module_driver() - Helper macro for drivers that don't do anything
>> + * special in module init/exit. This eliminates a lot of boilerplate.
>> + * Each module may only use this macro once, and calling it replaces
>> + * module_init() and module_exit().
>> + * Use this macro to construct bus specific macros for registering
>> + * drivers.
>> + */
>> +#define module_driver(__driver, __register, __unregister) \
>> +static int __init __driver##_init(void) \
>> +{ \
>> +       return __register(&(__driver)); \
>> +} \
>> +module_init(__driver##_init); \
>> +static void __exit __driver##_exit(void) \
>> +{ \
>> +       __unregister(&(__driver)); \
>> +} \
>> +module_exit(__driver##_exit);
>> +
>>  #endif /* _LINUX_INIT_H */
>> +
>> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
>> index 2a23f7d..165a8d1 100644
>> --- a/include/linux/platform_device.h
>> +++ b/include/linux/platform_device.h
>> @@ -196,16 +196,8 @@ static inline void platform_set_drvdata(struct platform_device *pdev, void *data
>>  * calling it replaces module_init() and module_exit()
>>  */
>>  #define module_platform_driver(__platform_driver) \
>> -static int __init __platform_driver##_init(void) \
>> -{ \
>> -       return platform_driver_register(&(__platform_driver)); \
>> -} \
>> -module_init(__platform_driver##_init); \
>> -static void __exit __platform_driver##_exit(void) \
>> -{ \
>> -       platform_driver_unregister(&(__platform_driver)); \
>> -} \
>> -module_exit(__platform_driver##_exit);
>> +       module_driver(__platform_driver, platform_driver_register, \
>> +                       platform_driver_unregister)
>>
>>  extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
>>                                        int (*probe)(struct platform_device *),
>> --
>> 1.7.7.1
>>
>>
>>
> 
> 
> 

