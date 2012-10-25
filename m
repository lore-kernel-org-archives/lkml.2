Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148Ab2JYJmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:42:17 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33168 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884Ab2JYJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:42:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAJLyvQw7=ucSTXH8YyPrm6LS8uDyxJkWGEVP2jQ3FL=cYN7frg@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=L-Xz90h90Q78gr7enOHK3u1TwHSs-QPQNE=0896SjRA@mail.gmail.com>
	<CAJLyvQxEAeP__drUAAz6D_UeeDRvdqKdmim3xAO7sXP8cCM8=g@mail.gmail.com>
	<CAKohpomZZiXnnkUC=9ZQoux1BVh+uJZw_oM1Ahndua2PZaKiDw@mail.gmail.com>
	<CAJLyvQw7=ucSTXH8YyPrm6LS8uDyxJkWGEVP2jQ3FL=cYN7frg@mail.gmail.com>
Date: Thu, 25 Oct 2012 15:12:12 +0530
Message-ID: <CAKohpokVR3wmung6SY=e2G3mdHnvbZRGvB8JYNxz1vFXTAma7w@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] Thermal: Add ST-Ericsson DB8500 thermal dirver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 15:03, Hongbo Zhang <hongbo.zhang@linaro.org> wrote:
> On 25 October 2012 16:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Just paste my current pieces of codes here:
>
> static struct db8500_thsens_platform_data*
>                 db8500_thermal_parse_dt(struct platform_device *pdev)
> {

>         if (!np) {
>                 dev_err(&pdev->dev, "Missing device tree data\n");

> }
>
> static int db8500_thermal_probe(struct platform_device *pdev)
> {

>         ptrips = db8500_thermal_parse_dt(pdev);
>         if (!ptrips)
>                 ptrips = dev_get_platdata(&pdev->dev);

So, the above code still has the flaw i pointed out. It will print
"Missing device tree data", while booting for non-DT case.

What i would suggest you is:

static int db8500_thermal_probe(struct platform_device *pdev)
{
        struct device_node *np = pdev->dev.of_node;

        if (np)
                ptrips = db8500_thermal_parse_dt(pdev);
        else
                ptrips = dev_get_platdata(&pdev->dev);

       if (!ptrips)
              explode!!


>>>>> +       ret = devm_request_threaded_irq(&pdev->dev, low_irq, NULL,

> I just saw that all the PRCMU and ab8500 related irqs use request_threaded_irq
> only difference is that I use devm_request_threaded_irq

See, i started this threaded_irq thread is to make sure you know
exactly what you
are doing. Others are doing it doesn't mean you should do it too.. :)

You must dig in a bit to see why is it required for your case? If
earlier code related
to PRCMU and db8500 is correct, then i am sure you need to sleep from your
handler.

--
viresh
