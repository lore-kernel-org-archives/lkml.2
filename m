Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227Ab2JYJdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:33:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37642 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935050Ab2JYJdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomZZiXnnkUC=9ZQoux1BVh+uJZw_oM1Ahndua2PZaKiDw@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=L-Xz90h90Q78gr7enOHK3u1TwHSs-QPQNE=0896SjRA@mail.gmail.com>
	<CAJLyvQxEAeP__drUAAz6D_UeeDRvdqKdmim3xAO7sXP8cCM8=g@mail.gmail.com>
	<CAKohpomZZiXnnkUC=9ZQoux1BVh+uJZw_oM1Ahndua2PZaKiDw@mail.gmail.com>
Date: Thu, 25 Oct 2012 17:33:08 +0800
Message-ID: <CAJLyvQw7=ucSTXH8YyPrm6LS8uDyxJkWGEVP2jQ3FL=cYN7frg@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] Thermal: Add ST-Ericsson DB8500 thermal dirver.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 16:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 October 2012 13:56, Hongbo Zhang <hongbo.zhang@linaro.org> wrote:
>
> While replying to mails, don't remove lines like above. They help
> identifying who
> wrote what.
>
>> [...]
>>>> +/* Callback to get temperature changing trend */
>>>> +static int db8500_sys_get_trend(struct thermal_zone_device *thermal,
>
> For example, you can't tell who wrote this line...
>
>>>> +static int __devinit db8500_thermal_probe(struct platform_device *pdev)
>>>> +{
>>>> +       struct db8500_thermal_zone *pzone = NULL;
>>>> +       struct db8500_thsens_platform_data *ptrips = NULL;
>>>> +       int low_irq, high_irq, ret = 0;
>>>> +       unsigned long dft_low, dft_high;
>>>> +
>>>> +       pzone = devm_kzalloc(&pdev->dev, sizeof(*pzone), GFP_KERNEL);
>>>> +       if (!pzone)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       ptrips = db8500_thermal_parse_dt(pdev);
>>>
>>> This is what u have in this routine at the very first line:
>>>
>>>        if (!np) {
>>>                dev_err(&pdev->dev, "Missing device tree data\n");
>>>
>>> So, you will end up printing this line for every non-DT case. Not good.
>>> What u can do is, give preference to normal pdata here.
>> I moved this if(!np) into parse_dt function, no problem again.
>> (in fact have already done this, but it is missed in this sending)
>
> Sorry couldn't get your point. :(
> Can you share diff of latest code in the same mail thread?
Just paste my current pieces of codes here:

static struct db8500_thsens_platform_data*
		db8500_thermal_parse_dt(struct platform_device *pdev)
{
	struct db8500_thsens_platform_data *ptrips;
	struct device_node *np = pdev->dev.of_node;
	char prop_name[32];
	const char *tmp_str;
	u32 tmp_data;
	int i, j;

	if (!np) {
		dev_err(&pdev->dev, "Missing device tree data\n");
		return NULL;
	}
	......
}

static int db8500_thermal_probe(struct platform_device *pdev)
{
	struct db8500_thermal_zone *pzone = NULL;
	struct db8500_thsens_platform_data *ptrips = NULL;
	int low_irq, high_irq, ret = 0;
	unsigned long dft_low, dft_high;

	ptrips = db8500_thermal_parse_dt(pdev);
	if (!ptrips)
		ptrips = dev_get_platdata(&pdev->dev);

	if (!ptrips)
		return -EINVAL;

	pzone = devm_kzalloc(&pdev->dev, sizeof(*pzone), GFP_KERNEL);
	if (!pzone)
		return -ENOMEM;
	......
}

>
>>>> +       ret = devm_request_threaded_irq(&pdev->dev, low_irq, NULL,
>>>
>>> why threaded irq?
>
>> In fact PRCMU firmware is polling the thermal sensor, and if it meets
>> threshold, the PRCMU will write this event into share memory (shared
>> between PRCMU and ARM) and trigger an interrupt to ARM.
>>
>> There may be other events passed via share memory, so it is better to
>> handle this kind of irq as fast as possible(it is always the policy),
>> and threaded irq satisfies this case better then the traditional one.
>
> Its been long that i prepared for an interview, but i believe purpose
> of threaded
> irq is something else.
>
> There can be two use cases of request_irq()
> - We don't want to sleep from interrupt handler, because we don't need to sleep
>   for reading hardware's register. And so handler must be called from interrupt
>   context. We use normal request_irq() here. This is the fastest one.
>
> - We have to sleep from some part of interrupt handler, because we don't have
>   peripherals register on AMBA bus. But we have it on SPI or I2C bus,
> where read/
>   write to SPI/I2C can potentially sleep. So, we want handler to execute from
>   process context and so use request_threaded_irq(), i.e. handler will
> be called
>   from a thread. This will surely be slow.
>
>   Now in threaded irq case, we can give two handlers, one that must be called
>   from interrupt context and other that must be called from process context.
>   Both will be called one by one.
>
Understand your points.

> Sorry if i am wrong in my theory :(
> @Amit: Am i correct??
>
> Now, the same question again. Are you sure you want threaded irq here.
I just saw that all the PRCMU and ab8500 related irqs use request_threaded_irq
only difference is that I use devm_request_threaded_irq

>
>>>> +               prcmu_low_irq_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
>>>> +               "dbx500_temp_low", pzone);
