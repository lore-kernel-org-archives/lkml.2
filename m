Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2JXEkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:40:22 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:63447 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2JXEkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <508595A0.4040604@gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
	<50840E3D.1060204@gmail.com>
	<CAJLyvQxC8eNRmB40o18JR0k7f38+=fpt4UimSYxDCNzNH03Cfw@mail.gmail.com>
	<508595A0.4040604@gmail.com>
Date: Wed, 24 Oct 2012 12:40:19 +0800
Message-ID: <CAJLyvQzv6d929PLutObQBbagUwA=PKoQz+8=b3mSQ2p4cZH6xg@mail.gmail.com>
Subject: Re: [PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2012 02:51, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> On 10/22/2012 02:02 PM, Hongbo Zhang wrote:
> [...]
>>>> +static irqreturn_t prcmu_low_irq_handler(int irq, void *irq_data)
>>>> +{
>>>> +     struct db8500_thermal_zone *pzone = irq_data;
>>>> +     struct db8500_thsens_platform_data *ptrips;
>>>> +     unsigned long next_low, next_high;
>>>> +     unsigned int idx;
>>>> +
>>>> +     ptrips = pzone->trip_tab;
>>>> +     idx = pzone->cur_index;
>>>> +     if (unlikely(idx == 0))
>>>> +             /* Meaningless for thermal management, ignoring it */
>>>> +             return IRQ_HANDLED;
>>>> +
>>>> +     if (idx == 1) {
>>>> +             next_high = ptrips->trip_points[0].temp;
>>>> +             next_low = PRCMU_DEFAULT_LOW_TEMP;
>>>> +     } else {
>>>> +             next_high = ptrips->trip_points[idx-1].temp;
>>>> +             next_low = ptrips->trip_points[idx-2].temp;
>>>> +     }
>>>> +
>>>> +     pzone->cur_index -= 1;
>>>> +     pzone->cur_temp_pseudo = (next_high + next_low)/2;
>>>> +
>>>> +     prcmu_stop_temp_sense();
>>>> +     prcmu_config_hotmon((u8)(next_low/1000), (u8)(next_high/1000));
>>>> +     prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>>>> +
>>>> +     pr_debug("PRCMU set max %ld, set min %ld\n", next_high, next_low);
>>>> +
>>>> +     pzone->trend = THERMAL_TREND_DROPPING;
>>>> +     schedule_work(&pzone->therm_work);
>>>> +
>>>> +     return IRQ_HANDLED;
>>>> +}
>>>> +
>>>> +static irqreturn_t prcmu_high_irq_handler(int irq, void *irq_data)
>>>> +{
>>>> +     struct db8500_thermal_zone *pzone = irq_data;
>>>> +     struct db8500_thsens_platform_data *ptrips;
>>>> +     unsigned long next_low, next_high;
>>>> +     unsigned int idx;
>>>> +
>>>> +     ptrips = pzone->trip_tab;
>>>> +     idx = pzone->cur_index;
>>>> +
>>>> +     if (idx < ptrips->num_trips - 1) {
>>>> +             next_high = ptrips->trip_points[idx+1].temp;
>>>> +             next_low = ptrips->trip_points[idx].temp;
>>>> +
>>>> +             pzone->cur_index += 1;
>>>> +             pzone->cur_temp_pseudo = (next_high + next_low)/2;
>>>> +
>>>> +             prcmu_stop_temp_sense();
>>>> +             prcmu_config_hotmon((u8)(next_low/1000), (u8)(next_high/1000));
>>>> +             prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>>>> +
>>>> +             pr_debug("PRCMU set max %ld, min %ld\n", next_high, next_low);
>>>> +     }
>>>> +
>>>> +     if (idx == ptrips->num_trips - 1)
>>>
>>> } else if ()
>> There is no else condition here, because it it the highest critical
>> trip point, system will be shut down in thermal_work.
>> But I'd like to add some comments here to state this situation.
>
> I didn't mean adding a new else condition, what I meant is that if the
> first condition (idx < ptrips->num_trips - 1) is verified, then there is
> no need to check for the second condition (idx == ptrips->num_trips -
> 1). So I was thinking of changing the code to:
>
> if (idx < ptrips->num_trips - 1)
>         ...
> else if (idx == ptrips->num_trips - 1)
>         ...
>
> Sorry if I wasn't clear.
Got it, thanks.
>
>>>
>>>> +             pzone->cur_temp_pseudo = ptrips->trip_points[idx].temp + 1;
>>>> +
>>>> +     pzone->trend = THERMAL_TREND_RAISING;
>>>> +     schedule_work(&pzone->therm_work);
>>>> +
>>>> +     return IRQ_HANDLED;
>>>> +}
>>>> +
>>>> +static void db8500_thermal_work(struct work_struct *work)
>>>> +{
>>>> +     enum thermal_device_mode cur_mode;
>>>> +     struct db8500_thermal_zone *pzone;
>>>> +
>>>> +     pzone = container_of(work, struct db8500_thermal_zone, therm_work);
>>>> +
>>>> +     mutex_lock(&pzone->th_lock);
>>>> +     cur_mode = pzone->mode;
>>>> +     mutex_unlock(&pzone->th_lock);
>>>> +
>>>> +     if (cur_mode == THERMAL_DEVICE_DISABLED) {
>>>> +             pr_warn("Warning: thermal function disabled.\n");
>>>> +             return;
>>>> +     }
>>>> +
>>>> +     thermal_zone_device_update(pzone->therm_dev);
>>>> +     pr_debug("db8500_thermal_work finished.\n");
>>>> +}
>>>> +
>>>> +static int __devinit db8500_thermal_probe(struct platform_device *pdev)
>>>> +{
>>>> +     struct db8500_thermal_zone *pzone = NULL;
>>>> +     struct db8500_thsens_platform_data *ptrips;
>>>> +     int low_irq, high_irq, ret = 0;
>>>> +     unsigned long dft_low, dft_high;
>>>> +
>>>> +     pzone = devm_kzalloc(&pdev->dev,
>>>> +                     sizeof(struct db8500_thermal_zone), GFP_KERNEL);
>>>> +     if (!pzone)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     pzone->thsens_pdev = pdev;
>>>> +
>>>> +     low_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_LOW");
>>>> +     if (low_irq < 0) {
>>>> +             pr_err("Get IRQ_HOTMON_LOW failed.\n");
>>>> +             return low_irq;
>>>> +     }
>>>> +
>>>> +     ret = devm_request_threaded_irq(&pdev->dev, low_irq, NULL,
>>>> +             prcmu_low_irq_handler,
>>>> +             IRQF_NO_SUSPEND | IRQF_ONESHOT, "dbx500_temp_low", pzone);
>>>> +     if (ret < 0) {
>>>> +             pr_err("Failed to allocate temp low irq.\n");
>>>> +             return ret;
>>>> +     }
>>>> +
>>>> +     high_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_HIGH");
>>>> +     if (high_irq < 0) {
>>>> +             pr_err("Get IRQ_HOTMON_HIGH failed.\n");
>>>> +             return high_irq;
>>>> +     }
>>>> +
>>>> +     ret = devm_request_threaded_irq(&pdev->dev, high_irq, NULL,
>>>> +             prcmu_high_irq_handler,
>>>> +             IRQF_NO_SUSPEND | IRQF_ONESHOT, "dbx500_temp_high", pzone);
>>>> +     if (ret < 0) {
>>>> +             pr_err("Failed to allocate temp high irq.\n");
>>>> +             return ret;
>>>> +     }
>>>> +
>>>> +     pzone->low_irq = low_irq;
>>>> +     pzone->high_irq = high_irq;
>>>> +
>>>> +     pzone->mode = THERMAL_DEVICE_DISABLED;
>>>> +
>>>> +     mutex_init(&pzone->th_lock);
>>>> +
>>>> +     INIT_WORK(&pzone->therm_work, db8500_thermal_work);
>>>> +
>>>> +     ptrips = pdev->dev.platform_data;
>>>> +     pzone->trip_tab = ptrips;
>>>> +
>>>> +     pzone->therm_dev = thermal_zone_device_register("db8500_thermal_zone",
>>>> +             ptrips->num_trips, 0, pzone, &thdev_ops, 0, 0);
>>>> +
>>>> +     if (IS_ERR(pzone->therm_dev)) {
>>>> +             pr_err("Failed to register thermal zone device\n");
>>>> +             return PTR_ERR(pzone->therm_dev);
>>>> +     }
>>>> +
>>>> +     dft_low = PRCMU_DEFAULT_LOW_TEMP;
>>>> +     dft_high = ptrips->trip_points[0].temp;
>>>> +
>>>> +     prcmu_stop_temp_sense();
>>>> +     prcmu_config_hotmon((u8)(dft_low/1000), (u8)(dft_high/1000));
>>>> +     prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>>>> +
>>>> +     pzone->cur_index = 0;
>>>> +     pzone->cur_temp_pseudo = (dft_low + dft_high)/2;
>>>> +     pzone->trend = THERMAL_TREND_STABLE;
>>>
>>> All the stuff from prcmu_stop_temp_sense() up to this line can race with
>>> the irq handlers, I would suggest doing it before requesting the irqs.
>>>
>>>> +     pzone->mode = THERMAL_DEVICE_ENABLED;
>>>
>>> Shouldn't this be protected by pzone->th_lock? Otherwise it should be
>>> set before the thermal zone is registered.
>>>
>>>> +
>>>> +     platform_set_drvdata(pdev, pzone);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int __devexit db8500_thermal_remove(struct platform_device *pdev)
>>>> +{
>>>> +     struct db8500_thermal_zone *pzone;
>>>> +     pzone = platform_get_drvdata(pdev);
>>>> +
>>>> +     cancel_work_sync(&pzone->therm_work);
>>>> +
>>>> +     if (pzone->therm_dev)
>>>> +             thermal_zone_device_unregister(pzone->therm_dev);
>>>> +
>>>> +     return 0;
>>>> +}
>>>
>>> mutex_destroy() should be called on pzone->th_lock
>>>
>>>> +
>>>> +static int db8500_thermal_suspend(struct platform_device *pdev,
>>>> +             pm_message_t state)
>>>> +{
>>>> +     struct db8500_thermal_zone *pzone;
>>>> +     pzone = platform_get_drvdata(pdev);
>>>> +
>>>> +     flush_work_sync(&pzone->therm_work);
>>>> +     prcmu_stop_temp_sense();
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int db8500_thermal_resume(struct platform_device *pdev)
>>>> +{
>>>> +     struct db8500_thermal_zone *pzone;
>>>> +     struct db8500_thsens_platform_data *ptrips;
>>>> +     unsigned long dft_low, dft_high;
>>>> +
>>>> +     pzone = platform_get_drvdata(pdev);
>>>> +     ptrips = pzone->trip_tab;
>>>> +     dft_low = PRCMU_DEFAULT_LOW_TEMP;
>>>> +     dft_high = ptrips->trip_points[0].temp;
>>>> +
>>>> +     prcmu_config_hotmon((u8)(dft_low/1000), (u8)(dft_high/1000));
>>>> +     prcmu_start_temp_sense(PRCMU_DEFAULT_MEASURE_TIME);
>>>
>>> Shouldn't cur_index and cur_temp_pseudo be updated as well? You may want
>>> to define a helper function with all the code shared by irq handlers
>>> (both high and low), probe and resume.
>> No, they cannot be update because we don't know the actual current
>> temp[1] after short or long time suspend, everything goes as
>> beginning.
>
> That's what I wanted to say, if everything is reset to a default value,
> then cur_index and cur_temp should be reset too, as it's done in the
> probe function. Otherwise you may have a current pseudo-temp and a
> current index unrelated to how the hotmon is configured.
Yes, right.
>
>> If a helper function is introduced, it can be only used in probe and
>> resume I think, different and a bit complicated algorithm in irq
>> handlers.
>
> I was thinking about a function which takes the new index and the new
> low and high parameters, and updates cur_index and cur_pseudo_temp and
> does the prcmu stuff. It seems to me this is (or should be) common to
> all the 4 functions.
I misunderstood this helper will do all the updates, but algorithm of
cur_index is different everywhere.
If cur_index is calculated outside this new helper function, it works.
I will do that.
>
>> [1] due to lack of corresponding interface, search "TODO" in this file
>> to get more explanation.
>
> --
> Francesco
