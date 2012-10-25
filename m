Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab2JYI06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:26:58 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44442 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829Ab2JYI0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=L-Xz90h90Q78gr7enOHK3u1TwHSs-QPQNE=0896SjRA@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=L-Xz90h90Q78gr7enOHK3u1TwHSs-QPQNE=0896SjRA@mail.gmail.com>
Date: Thu, 25 Oct 2012 16:26:53 +0800
Message-ID: <CAJLyvQxEAeP__drUAAz6D_UeeDRvdqKdmim3xAO7sXP8cCM8=g@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] Thermal: Add ST-Ericsson DB8500 thermal dirver.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>> +/* Callback to get temperature changing trend */
>> +static int db8500_sys_get_trend(struct thermal_zone_device *thermal,
>> +                       int trip, enum thermal_trend *trend)
>> +{
>> +       struct db8500_thermal_zone *pzone = thermal->devdata;
>> +
>> +       *trend = pzone->trend;
>> +
>> +       return 0;
>
> Can make it return void.
No, it is callback of thermal layer, prototype it to return int.

[...]
>> +static int __devinit db8500_thermal_probe(struct platform_device *pdev)
>> +{
>> +       struct db8500_thermal_zone *pzone = NULL;
>> +       struct db8500_thsens_platform_data *ptrips = NULL;
>> +       int low_irq, high_irq, ret = 0;
>> +       unsigned long dft_low, dft_high;
>> +
>> +       pzone = devm_kzalloc(&pdev->dev, sizeof(*pzone), GFP_KERNEL);
>> +       if (!pzone)
>> +               return -ENOMEM;
>> +
>> +       ptrips = db8500_thermal_parse_dt(pdev);
>
> This is what u have in this routine at the very first line:
>
>        if (!np) {
>                dev_err(&pdev->dev, "Missing device tree data\n");
>
> So, you will end up printing this line for every non-DT case. Not good.
> What u can do is, give preference to normal pdata here.
I moved this if(!np) into parse_dt function, no problem again.
(in fact have already done this, but it is missed in this sending)
>
>> +       if (!ptrips)
>> +               ptrips = dev_get_platdata(&pdev->dev);
>> +
>> +       if (!ptrips)
>
[...]
>> +       }
>> +
>> +       ret = devm_request_threaded_irq(&pdev->dev, low_irq, NULL,
>
> why threaded irq?
In fact PRCMU firmware is polling the thermal sensor, and if it meets
threshold, the PRCMU will write this event into share memory (shared
between PRCMU and ARM) and trigger an interrupt to ARM.
There may be other events passed via share memory, so it is better to
handle this kind of irq as fast as possible(it is always the policy),
and threaded irq satisfies this case better then the traditional one.
>
>> +               prcmu_low_irq_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
>> +               "dbx500_temp_low", pzone);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "Failed to allocate temp low irq.\n");
>> +               return ret;
>> +       }
>> +
>> +       high_irq = platform_get_irq_byname(pdev, "IRQ_HOTMON_HIGH");
>> +       if (high_irq < 0) {
>> +               dev_err(&pdev->dev, "Get IRQ_HOTMON_HIGH failed.\n");
>> +               return high_irq;
>
> don't want to free resources?
devm_* is used to allocate resources, so no need to free them manually.
>
>> +       }
>> +
>> +       ret = devm_request_threaded_irq(&pdev->dev, high_irq, NULL,
>> +               prcmu_high_irq_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
>> +               "dbx500_temp_high", pzone);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "Failed to allocate temp high irq.\n");
>> +               return ret;
>> +       }
>> +
[...]
