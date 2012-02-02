Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2BBUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:48:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39860 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab2BBUsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:48:21 -0500
Message-ID: <4F2AF68D.1000505@ti.com>
Date: Thu, 2 Feb 2012 21:48:13 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <balbi@ti.com>, <khilman@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com> <1328203851-20435-2-git-send-email-tarun.kanti@ti.com> <20120202184106.GC29215@legolas.emea.dhcp.ti.com> <20120202191630.GT15343@ponder.secretlab.ca> <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/2012 8:45 PM, Felipe Balbi wrote:
> On Thu, Feb 02, 2012 at 12:16:30PM -0700, Grant Likely wrote:
>> On Thu, Feb 02, 2012 at 08:41:07PM +0200, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Thu, Feb 02, 2012 at 11:00:27PM +0530, Tarun Kanti DebBarma wrote:
>>>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>>>> index 0b05629..6ea7390 100644
>>>> --- a/drivers/gpio/gpio-omap.c
>>>> +++ b/drivers/gpio/gpio-omap.c
>>>> @@ -28,7 +28,10 @@
>>>>   #include<asm/gpio.h>
>>>>   #include<asm/mach/irq.h>
>>>>
>>>> +static LIST_HEAD(omap_gpio_list);
>>>
>>> I guess it's now too late because patch is acked and everything, but I
>>> think if you make the driver handle one bank alone and just instantiate
>>> it multiple times (omap_gpio.0, omap_gpio.1, omap_gpio.3, etc) driver
>>> would be faaaaaar simpler.
>>
>> Is there any shared state between the banks?  On my very cursory glance it
>> looked like banks still have some interaction between them.  If not, then
>> yes I agree that multiple instances would be better.
>
> A quick glance at the TRM shows that banks have separate address spaces
> and IRQ lines. I think it's done this way because we can handoff one (or
> more) bank to other cores on the SoC, so they need to be pretty
> independent.
>
> I could be missing something though.

In fact the driver already handled the 6 GPIOS banks as individual devices:

[    0.185638] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.185882] OMAP GPIO hardware version 0.1
[    0.186767] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.187744] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
[    0.188751] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
[    0.189819] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
[    0.190917] gpiochip_add: registered GPIOs 160 to 191 on device: gpio

That list is only used to iterate over all the instances during CPU idle:

void omap2_gpio_prepare_for_idle(int pwr_mode)
{
	struct gpio_bank *bank;

	list_for_each_entry(bank, &omap_gpio_list, node) {
		if (!bank->mod_usage || !bank->loses_context)
			continue;

		bank->power_mode = pwr_mode;

		pm_runtime_put_sync_suspend(bank->dev);
	}
}

void omap2_gpio_resume_after_idle(void)
{
	struct gpio_bank *bank;

	list_for_each_entry(bank, &omap_gpio_list, node) {
		if (!bank->mod_usage || !bank->loses_context)
			continue;

		pm_runtime_get_sync(bank->dev);
	}
}


I don't know if there is some reason to not use driver_for_each_device.


Kevin,

Do we have any constraint inside omap_sram_idle to not use the device 
iterator?


Regards,
Benoit
