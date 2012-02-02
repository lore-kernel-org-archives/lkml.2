Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2BBWAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:00:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43219 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2BBWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:00:51 -0500
Message-ID: <4F2B078B.1040709@ti.com>
Date: Thu, 2 Feb 2012 23:00:43 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <khilman@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com> <1328203851-20435-2-git-send-email-tarun.kanti@ti.com> <20120202184106.GC29215@legolas.emea.dhcp.ti.com> <20120202191630.GT15343@ponder.secretlab.ca> <20120202194545.GA29351@legolas.emea.dhcp.ti.com> <4F2AF68D.1000505@ti.com> <20120202214907.GA22888@legolas.emea.dhcp.ti.com> <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/2012 10:53 PM, Felipe Balbi wrote:
> Hi again,
>
> On Thu, Feb 02, 2012 at 11:49:08PM +0200, Felipe Balbi wrote:
>>> In fact the driver already handled the 6 GPIOS banks as individual devices:
>>>
>>> [    0.185638] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
>>> [    0.185882] OMAP GPIO hardware version 0.1
>>> [    0.186767] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
>>> [    0.187744] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
>>> [    0.188751] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
>>> [    0.189819] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
>>> [    0.190917] gpiochip_add: registered GPIOs 160 to 191 on device: gpio
>>
>> yeah, but you can get all of that for free from driver core. Just add
>> one platform_device for each bank and make the omap-gpio.c only
>> understand one bank. No tricks.
>>
>> What I'm trying to say is to remove the Bank array or list_head and make
>> probe() get called 6 times by creating 6 omap_gpio platform_devices.
>>
>>  From probe you cann gpiochip_add() once and only once.
> 		^^^^
> 		 call
>
> I actually just took the time to go over the driver and that's what it
> does. So the list_head is only there fo the nasty cpuidle stuff below:

Yes, that was my point :-)

>>> That list is only used to iterate over all the instances during CPU idle:
>>>
>>> void omap2_gpio_prepare_for_idle(int pwr_mode)
>>> {
>>> 	struct gpio_bank *bank;
>>>
>>> 	list_for_each_entry(bank,&omap_gpio_list, node) {
>>> 		if (!bank->mod_usage || !bank->loses_context)
>>> 			continue;
>>>
>>> 		bank->power_mode = pwr_mode;
>>>
>>> 		pm_runtime_put_sync_suspend(bank->dev);
>>> 	}
>>> }
>>>
>>> void omap2_gpio_resume_after_idle(void)
>>> {
>>> 	struct gpio_bank *bank;
>>>
>>> 	list_for_each_entry(bank,&omap_gpio_list, node) {
>>> 		if (!bank->mod_usage || !bank->loses_context)
>>> 			continue;
>>>
>>> 		pm_runtime_get_sync(bank->dev);
>>> 	}
>>> }
>>
>> that's the thing which is unnecessary, actually :-)
>>
>> Why do we even have this omap2_gpio_resume_after_idle() ? Can't the gpio
>> driver handle its own PM or listen to cpuidle notificaitons for that ?
>>
>> I would like to understand why do we need this hack for pm runtime.
>> Can't you just use ->prepare() and ->complete() from dev_pm_ops ?
>
> This question remains. Why do we need those funtions ?

These functions are called from the CPUIdle path so outside the scope of 
the GPIO driver. These are part of a bunch of nasty PM hacks we are 
doing in the CPU idle loop. We are in the process of getting rid of most 
of them, but it looks like some are still needed.

Regards,
Benoit

