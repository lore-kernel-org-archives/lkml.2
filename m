Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2DQTcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:32:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55010 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2DQTcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120417174213.GD3852@pengutronix.de>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
 <1334620214-25803-2-git-send-email-rob.lee@linaro.org> <20120417074301.GM20478@pengutronix.de>
 <CAMXH7KH41kWMPu_dEpetZc8OUD3C0-mtxGbXX0Vqd4EODPWJUg@mail.gmail.com> <20120417174213.GD3852@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Tue, 17 Apr 2012 14:32:02 -0500
Message-ID: <CAMXH7KFYA24sPUcwgKfwVLNPA0jWQ-QG02y+SfPNnAqdiv0+gg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> +void __init imx_cpuidle_set_driver(struct cpuidle_driver *p)
>> >> +{
>> >> +     drv = p;
>> >> +}
>> >
>> > You like it complicated, eh? Why do you introduce a function which sets
>> > a variable...
>> >
>>
>> This complication is used to deal with the timing of various levels of
>> init calls.  More explanation below.
>>
>> >> +
>> >> +void imx_cpuidle_devices_uninit(void)
>> >> +{
>> >> +     int cpu_id;
>> >> +     struct cpuidle_device *dev;
>> >> +
>> >> +     for_each_possible_cpu(cpu_id) {
>> >> +             dev = per_cpu_ptr(imx_cpuidle_devices, cpu_id);
>> >> +             cpuidle_unregister_device(dev);
>> >> +     }
>> >> +
>> >> +     free_percpu(imx_cpuidle_devices);
>> >> +}
>> >> +
>> >> +static int __init imx_cpuidle_init(void)
>> >
>> > ... instead of passing it directly to the function which uses it?
>> >
>>
>> If I called imx_cpuidle_init directly from imx5 or imx6q init
>> routines, it would be getting called before the coreinit_call of core
>> cpuidle causing a failure.  There were various other directions to
>> take and all seemed less desirable than this one.
>>
>> One alternative would be to add a function to return the pointer to
>> the cpuidle driver object based on the machine type.  Functionality
>> exists to identify imx5 as a machine type but not imx6q, so I couldn't
>> use that machine based method without adding that extra code.
>>
>> Another alternative would be to add a general platform lateinit_call
>> function to each platforms that support cpuidle.
>
> Just put the initcall into mm-imx5.c and check the cpu type. Then you
> also don't have to make imx5_idle global.

That solution is currently available for imx5 but for imx6q it implies
adding the cpu type support for imx6q.  Are you ok with that?

>
> Sascha
>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
