Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1K3H7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:59:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39158 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1K3H66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:58:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1soZwn5K3997fwh4b3HHcc9B6q32hm-q9M-X79vK_CatTAHA@mail.gmail.com>
References: <1321524793-25117-1-git-send-email-dg77.kim@samsung.com>
	<1321524793-25117-2-git-send-email-dg77.kim@samsung.com>
	<CAN1soZzeZ9HwD66_X0Yzp+6MpRBGnzpePuCu07mkBWPUCJbkPg@mail.gmail.com>
	<CAJ0PZbSq3a2vPNkbErW1j+9DE130D5gkrEgtfjT2ShhnuZ3aJA@mail.gmail.com>
	<CAN1soZwn5K3997fwh4b3HHcc9B6q32hm-q9M-X79vK_CatTAHA@mail.gmail.com>
Date: Wed, 30 Nov 2011 16:58:56 +0900
Message-ID: <CAJ0PZbSkRp5axKZ7s3Eogu=FB5agPNsHeRW_kNfem5R0d7191A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] power: Charger-Manager: add initial
 Charger-Manager driver
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-pm@vger.kernel.org,
        len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, rdunlap@xenotime.net,
        cbouatmailru@gmail.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 2:33 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Tue, Nov 29, 2011 at 1:00 PM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> On Tue, Nov 29, 2011 at 1:41 PM, Haojian Zhuang
>> <haojian.zhuang@gmail.com> wrote:
>>> On Thu, Nov 17, 2011 at 6:13 PM, Donggeun Kim <dg77.kim@samsung.com> wrote:
>>>> Because battery health monitoring should be done even when suspended,
>>>> it needs to wake up and suspend periodically. Thus, userspace battery
>>>> monitoring may incur too much overhead; every device and task is woken
>>>> up periodically. Charger Manager uses suspend-again to provide
>>>> in-suspend monitoring.
>>>>
>>>> This patch allows to monitor battery health in-suspend state.
>>>>
>>
>>> Donggeun,
>>>
>>> I think that this patch is good for saving energy for charging while
>>> suspend. I think that this driver also works under android. I have
>>> some concerns on rtc wakeup.
>>>
>>> As we know, RTC event doesn't link to timer events in kernel. But
>>> Android did. Android transfered timer event to rtc event while it
>>> suspend. So it will occupy one rtc device.
>>>
>>> Whatever the device is phone or tablet, it may cost another rtc device
>>> if it wants to implement power-up alarm feature. If we want to support
>>> the charger manager feature, we have to add another rtc device. I
>>> think that it's very hard to find any current platform with three rtc
>>> devices. How about implement the similar mechanism like android?
>>> Charger manager can register wakeup event into alarm mechanism like
>>> android. And we only need two rtc devices.
>>>
>>> Loop more guys: list-arm-kernel & linaro.
>>>
>>> Thanks
>>> Haojianbelow patch and comment whether
>>
>> Hello Haojian,
>>
>> No, we do not need to add another RTC device due to the usage of RTC
>> alarm from another device drivers or processes.
>> We can share an RTC device with others as long as others do not set
>> RTC alarm in the suspend-to-RAM context (specifically from prepare ops
>> to complete ops).
>> The reason why we have created cm_setup_timer() looking that awfully
>> complex is to let it coexist with other RTC alarm events and share the
>> precious RTC device.
>> Anyway, why do we even need two RTC devices in general?
>>
> If we want the device to implement power-up alarm, we need two rtc devices.
>
> Let me use an example in Android system.
> 1. Application set time interval to receive mail after 10 minutes.
> 2. Android suspend and it convert the timer event into RTC event.
> 3. Battery is removed. After a while, we put the battery back. The
> battery insertion won't trigger phone up since it's depend on custom
> scenario.
> 4. 10 minutes interval past and phone will be powered up since rtc
> wakeup. Absolutely it's incorrect. We only need a resume event, not a
> power up event.
>
> If we have two rtc devices, one is external rtc and the other is
> contained in SoC. While battery removed, only SoC rtc will lost power
> and external rtc can keep status for a long time. So let's check the
> item #4.
> 4. Since status is lost in SoC rtc, system won't wakeup while 10
> minutes interval past.

Ah.. yes. If we have alarms with different reaction conditions for
power-down/suspend-to-RAM, then, yes, we do need at least two.

>
>> If the RTC subsystem supports registering multiple alarm events,
>> that'd be nice and will make this one simpler as well; however, we do
>> not have it here for now.
>>
>> We save previous RTC alarm if the configuration data says so
>> (rtc_wkalarm_save.enabled) and previously set alarm is later than the
>> current alarm and restore the RTC alarm value at wakeup.
>>
>> If the previously set RTC alarm is earlier than the timer setup of
>> Charger Manager, we do not load the alarm value of Charger Manager and
>> let the previously set RTC alarm be active for a wakeup.
>>
> But it's a little complex, isn't it?

Yes, if we have timer-like support from RTC, it'd be gread and make
this one less complex.
But, I think we can keep doing this until RTC is ready for that because
1. it appears that charger manager would be the only one who wants to
use(update) RTC ALARM in kernel (meaningless to support "multialarm"
service in kernel) and 2. introducing a whole new interface and
mechanism in RTC subsystem for multialarm support--at least, we need
to alter the semantics of RTC APIs--seems to be somewhat overkill or
overreaction to what we need for now. (or just blame me for the
lazyness :D ) It may make Charger Manager itself to be more complex or
to have more lines; however, it does not create pain in the charger
manager users' butt (or hope so).

Thanks for your input anyway.


Cheers!
MyungJoo.


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
