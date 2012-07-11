Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2GKEoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 00:44:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46320 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2GKEoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 00:44:14 -0400
Message-ID: <4FFD0463.8030302@linaro.org>
Date: Tue, 10 Jul 2012 21:43:15 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] alarmtimer: add .remove_dev hook to put device
References: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org> <20120711034613.GA16212@S2101-09.ap.freescale.net>
In-Reply-To: <20120711034613.GA16212@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071104-2398-0000-0000-000008621971
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 08:46 PM, Shawn Guo wrote:
> Hi John,
>
> Is this patch a valid fix or just a noise?

Sorry! This is on my list, but I've not had a chance to get to it.

I'll try to get a closer look later this week!

Thanks for reminding me, and sorry again!
-john


> Regards,
> Shawn
>
> On Thu, Jul 05, 2012 at 12:13:07AM +0800, Shawn Guo wrote:
>> The following is a test sequence that installs a rtc module, remove it
>> and installs it again.
>>
>> $ insmod rtc-snvs.ko
>> snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp as rtc0
>> $ hwclock
>> Thu Jul  5 08:53:35 2012  0.000000 seconds
>> $ rmmod rtc-snvs.ko
>> $ insmod rtc-snvs.ko
>> snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp as rtc1
>> $ hwclock
>> hwclock: can't open '/dev/misc/rtc': No such file or directory
>> $
>>
>> The device is registered as rtc0 for the first time insmod, while it
>> becomes rtc1 with the later insmod.
>>
>> It's root caused by alarmtimer which never puts the device even when
>> the rtc is removed.  The patch adds a .remove_dev hook to have device
>> properly put, so that above insmod/rmmod sequence can the rtc device
>> registered in a consistent behavior.
>>
>> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>> ---
>>   kernel/time/alarmtimer.c |   12 ++++++++++++
>>   1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
>> index aa27d39..39e8773 100644
>> --- a/kernel/time/alarmtimer.c
>> +++ b/kernel/time/alarmtimer.c
>> @@ -96,6 +96,17 @@ static int alarmtimer_rtc_add_device(struct device *dev,
>>   	return 0;
>>   }
>>   
>> +static void alarmtimer_rtc_remove_device(struct device *dev,
>> +				struct class_interface *class_intf)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&rtcdev_lock, flags);
>> +	rtcdev = NULL;
>> +	put_device(dev);
>> +	spin_unlock_irqrestore(&rtcdev_lock, flags);
>> +}
>> +
>>   static inline void alarmtimer_rtc_timer_init(void)
>>   {
>>   	rtc_timer_init(&rtctimer, NULL, NULL);
>> @@ -103,6 +114,7 @@ static inline void alarmtimer_rtc_timer_init(void)
>>   
>>   static struct class_interface alarmtimer_rtc_interface = {
>>   	.add_dev = &alarmtimer_rtc_add_device,
>> +	.remove_dev = &alarmtimer_rtc_remove_device,
>>   };
>>   
>>   static int alarmtimer_rtc_interface_setup(void)
>> -- 
>> 1.7.5.4
>>
>>


