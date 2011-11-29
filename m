Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab1K2FA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:00:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54524 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1K2FA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:00:57 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <CAN1soZzeZ9HwD66_X0Yzp+6MpRBGnzpePuCu07mkBWPUCJbkPg@mail.gmail.com>
References: <1321524793-25117-1-git-send-email-dg77.kim@samsung.com>
	<1321524793-25117-2-git-send-email-dg77.kim@samsung.com>
	<CAN1soZzeZ9HwD66_X0Yzp+6MpRBGnzpePuCu07mkBWPUCJbkPg@mail.gmail.com>
Date: Tue, 29 Nov 2011 14:00:55 +0900
X-Google-Sender-Auth: s5uMouyjpJ9Pd3oyHZTGik4uqJ0
Message-ID: <CAJ0PZbSq3a2vPNkbErW1j+9DE130D5gkrEgtfjT2ShhnuZ3aJA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] power: Charger-Manager: add initial
 Charger-Manager driver
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-pm@vger.kernel.org,
        len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, rdunlap@xenotime.net,
        cbouatmailru@gmail.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 1:41 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Thu, Nov 17, 2011 at 6:13 PM, Donggeun Kim <dg77.kim@samsung.com> wrote:
>> Because battery health monitoring should be done even when suspended,
>> it needs to wake up and suspend periodically. Thus, userspace battery
>> monitoring may incur too much overhead; every device and task is woken
>> up periodically. Charger Manager uses suspend-again to provide
>> in-suspend monitoring.
>>
>> This patch allows to monitor battery health in-suspend state.
>>

[]

>> +/**
>> + * cm_setup_timer - For in-suspend monitoring setup wakeup alarm
>> + *                 for suspend_again.
>> + *
>> + * Returns true if the alarm is set for Charger Manager to use.
>> + * Returns false if
>> + *     cm_setup_timer fails to set an alarm,
>> + *     cm_setup_timer does not need to set an alarm for Charger Manager,
>> + *     or an alarm previously configured is to be used.
>> + */
>> +static bool cm_setup_timer(void)
>> +{
>> +       struct charger_manager *cm;
>> +       unsigned int wakeup_ms = UINT_MAX;
>> +       bool ret = false;
>> +
>> +       mutex_lock(&cm_list_mtx);
>> +
>> +       list_for_each_entry(cm, &cm_list, entry) {
>> +               /* Skip if polling is not required for this CM */
>> +               if (!is_polling_required(cm) && !cm->emergency_stop)
>> +                       continue;
>> +               if (cm->desc->polling_interval_ms == 0)
>> +                       continue;
>> +               CM_MIN_VALID(wakeup_ms, cm->desc->polling_interval_ms);
>> +       }
>> +
>> +       mutex_unlock(&cm_list_mtx);
>> +
>> +       if (wakeup_ms < UINT_MAX && wakeup_ms > 0) {
>> +               pr_info("Charger Manager wakeup timer: %u ms.\n", wakeup_ms);
>> +               if (rtc_dev) {
>> +                       struct rtc_wkalrm tmp;
>> +                       unsigned long time, now;
>> +                       unsigned long add = DIV_ROUND_UP(wakeup_ms, 1000);
>> +
>> +                       /*
>> +                        * Set alarm with the polling interval (wakeup_ms)
>> +                        * except when rtc_wkalarm_save comes first.
>> +                        * However, the alarm time should be NOW +
>> +                        * CM_RTC_SMALL or later.
>> +                        */
>> +                       tmp.enabled = 1;
>> +                       rtc_read_time(rtc_dev, &tmp.time);
>> +                       rtc_tm_to_time(&tmp.time, &now);
>> +                       if (add < CM_RTC_SMALL)
>> +                               add = CM_RTC_SMALL;
>> +                       time = now + add;
>> +
>> +                       ret = true;
>> +
>> +                       if (rtc_wkalarm_save.enabled && rtc_wkalarm_save_ &&
>> +                           rtc_wkalarm_save_ < time) {
>> +                               if (rtc_wkalarm_save_ < now + CM_RTC_SMALL)
>> +                                       time = now + CM_RTC_SMALL;
>> +                               else
>> +                                       time = rtc_wkalarm_save_;
>> +
>> +                               /* The timer is not appointed by CM */
>> +                               ret = false;
>> +                       }
>> +
>> +                       pr_info("Waking up after %lu secs.\n",
>> +                                       time - now);
>> +
>> +                       rtc_time_to_tm(time, &tmp.time);
>> +                       rtc_set_alarm(rtc_dev, &tmp);
>> +                       cm_suspend_duration_ms += wakeup_ms;
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       if (rtc_dev)
>> +               rtc_set_alarm(rtc_dev, &rtc_wkalarm_save);
>> +       return false;
>> +}
>> +

[]

>> +
>> +static int cm_suspend_prepare(struct device *dev)
>> +{
>> +       struct platform_device *pdev = container_of(dev, struct platform_device,
>> +                                                   dev);
>> +       struct charger_manager *cm = platform_get_drvdata(pdev);
>> +
>> +       if (!cm_suspended) {
>> +               if (rtc_dev) {
>> +                       struct rtc_time tmp;
>> +                       unsigned long now;
>> +
>> +                       rtc_read_alarm(rtc_dev, &rtc_wkalarm_save);
>> +                       rtc_read_time(rtc_dev, &tmp);
>> +
>> +                       if (rtc_wkalarm_save.enabled) {
>> +                               rtc_tm_to_time(&rtc_wkalarm_save.time,
>> +                                              &rtc_wkalarm_save_);
>> +                               rtc_tm_to_time(&tmp, &now);
>> +                               if (now > rtc_wkalarm_save_)
>> +                                       rtc_wkalarm_save_ = 0;
>> +                       } else {
>> +                               rtc_wkalarm_save_ = 0;
>> +                       }
>> +               }
>> +               cm_suspended = true;
>> +       }
> Donggeun,
>
> I think that this patch is good for saving energy for charging while
> suspend. I think that this driver also works under android. I have
> some concerns on rtc wakeup.
>
> As we know, RTC event doesn't link to timer events in kernel. But
> Android did. Android transfered timer event to rtc event while it
> suspend. So it will occupy one rtc device.
>
> Whatever the device is phone or tablet, it may cost another rtc device
> if it wants to implement power-up alarm feature. If we want to support
> the charger manager feature, we have to add another rtc device. I
> think that it's very hard to find any current platform with three rtc
> devices. How about implement the similar mechanism like android?
> Charger manager can register wakeup event into alarm mechanism like
> android. And we only need two rtc devices.
>
> Loop more guys: list-arm-kernel & linaro.
>
> Thanks
> Haojian

Hello Haojian,

No, we do not need to add another RTC device due to the usage of RTC
alarm from another device drivers or processes.
We can share an RTC device with others as long as others do not set
RTC alarm in the suspend-to-RAM context (specifically from prepare ops
to complete ops).
The reason why we have created cm_setup_timer() looking that awfully
complex is to let it coexist with other RTC alarm events and share the
precious RTC device.
Anyway, why do we even need two RTC devices in general?

If the RTC subsystem supports registering multiple alarm events,
that'd be nice and will make this one simpler as well; however, we do
not have it here for now.

We save previous RTC alarm if the configuration data says so
(rtc_wkalarm_save.enabled) and previously set alarm is later than the
current alarm and restore the RTC alarm value at wakeup.

If the previously set RTC alarm is earlier than the timer setup of
Charger Manager, we do not load the alarm value of Charger Manager and
let the previously set RTC alarm be active for a wakeup.


Cheers!
MyungJoo

>
>> +
>> +       cm->status_save_ext_pwr_inserted = is_ext_pwr_online(cm);
>> +       cm->status_save_batt = is_batt_present(cm);
>> +
>> +       if (!cm_rtc_set) {
>> +               cm_suspend_duration_ms = 0;
>> +               cm_rtc_set = cm_setup_timer();
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void cm_suspend_complete(struct device *dev)
>> +{
>> +       struct platform_device *pdev = container_of(dev, struct platform_device,
>> +                                                   dev);
>> +       struct charger_manager *cm = platform_get_drvdata(pdev);
>> +
>> +       if (cm_suspended) {
>> +               if (rtc_dev) {
>> +                       struct rtc_wkalrm tmp;
>> +
>> +                       rtc_read_alarm(rtc_dev, &tmp);
>> +                       rtc_wkalarm_save.pending = tmp.pending;
>> +                       rtc_set_alarm(rtc_dev, &rtc_wkalarm_save);
>> +               }
>> +               cm_suspended = false;
>> +               cm_rtc_set = false;
>> +       }
>> +
>> +       uevent_notify(cm, NULL);
>> +}
>> +
>> +static const struct dev_pm_ops charger_manager_pm = {
>> +       .prepare        = cm_suspend_prepare,
>> +       .complete       = cm_suspend_complete,
>> +};
>> +

[]

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
