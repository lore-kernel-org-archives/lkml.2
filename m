Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2HAGUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 02:20:09 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53509 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2HAGUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 02:20:06 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q716JH83003472, This message is released by code: ctaloc0852
Message-ID: <5018CA65.1080906@realsil.com.cn>
Date: Wed, 1 Aug 2012 14:19:17 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
References: <1343720536-22077-1-git-send-email-wei_wang@realsil.com.cn> <201207311123.25862.arnd@arndb.de>
In-Reply-To: <201207311123.25862.arnd@arndb.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月31日 19:23, Arnd Bergmann 写道:
>
> You posted the sdmmc host driver and the pci card reader driver.
> I assume that the USB card reader and the memstick host
> will also get posted at some point. Do you have a timeframe
> for those?

I will submit my memstick host driver around two months later, and
submit USB part at the end of this year.

>
> The hardware seems to also support xd/smartmedia. Do you have
> plans to add those? I think we have some code in drivers/mfd
> that acts as an abstraction layer for these, given that the
> host has to do the wear leveling there too.

Yes, xD is still in our plan. But because the user population of xD/SM
is so small, we put the priority of writing xD host driver in a relevant
low level.
Maybe we will submit this driver in the next year.

> As usual for most things getting added to drivers/misc, I'm skeptical
> about it actually fitting in here. Normally I'd put such a multiplexer
> into drivers/mfd. Given that you actually need your own bus, rather
> than just a single host with multiple endpoints, drivers/bus/realtek/cr
> might be best.
We do need a bus driver. We support multi models of card at the same
time, so we need a way to bind all of the host drivers. And in the
internal of our card reader, we have only one DMA engine and one ring
buffer to handle massive data, so we also need a way to protect the
critical area between different card hosts. Bus driver is convenient to
handle this situation. Another way to fulfill is to call every register
function of different host (like mmc, memstick) in sequence in card
reader driver, whether pci-based or usb-based, if not using bus driver.
I prefer the prior scheme, which is more flexible and less redundant code.

Using bus driver:

sdmmc memstick
\ /
\ /
\ /
rtsx bus driver
/ \
/ \
/ \
/ \
rtsx pci rtsx usb


Not using bus driver:

sdmmc-pci memstick-pci
\ /
\ /
\ /
\ /
rtsx pci

sdmmc-usb memstick-usb
\ /
\ /
\ /
\ /
rtsx usb

And you said we should put our own bus driver in drivers/bus/realtek/cr,
but where is drivers/bus? Or can I just put this bus driver and our
pci/usb card reader driver into drivers/mfd?

>> +udev rules
>> +----------
>> +
>> +In order to modprobe Realtek SD/MMC interface driver automatically, the following rule
>> +should be added to the udev rules file:
>> +
>> +SUBSYSTEM=="rtsx_cr", ENV{RTSX_CARD_TYPE}=="SD", RUN+="/sbin/modprobe -bv rtsx_sdmmc"
> This should not be necessary if you put the right module alias into the driver itself.
>
> You should generally use EXPORT_SYMBOL_GPL for new symbols unless there is
> a strong reason not to (and then you should explain that reason).

Got it, I will modify it.

>> +
>> +void rtsx_queue_work(struct work_struct *work)
>> +{
>> +	queue_work(workqueue, work);
>> +}
>> +EXPORT_SYMBOL(rtsx_queue_work);
>> +
>> +void rtsx_queue_delayed_work(struct delayed_work *dwork, unsigned long delay)
>> +{
>> +	queue_delayed_work(workqueue, dwork, delay);
>> +}
>> +EXPORT_SYMBOL(rtsx_queue_delayed_work);
> I would not bother with this, just move the workqueue into the client driver
> itself, which may result in a few duplicate lines but less code overall.
>
>> +int rtsx_register_driver(struct rtsx_driver *drv)
>> +{
>> +	drv->driver.bus = &rtsx_bus_type;
>> +
>> +	return driver_register(&drv->driver);
>> +}
>> +EXPORT_SYMBOL(rtsx_register_driver);
>> +
>> +void rtsx_unregister_driver(struct rtsx_driver *drv)
>> +{
>> +	driver_unregister(&drv->driver);
>> +}
>> +EXPORT_SYMBOL(rtsx_unregister_driver);
> Same thing here: There will only be very few drivers for this bus, so it's
> easier to call the driver_register function from the drivers. You need to export
> the rtsx_bus_type in that case though, but that is done for most buses.

I will consider this.

> With this level of abstraction in your own driver, I wonder if it wouldn't be
> easier to have completely separate mmc drivers for each of the two host options
> (pci and usb). Apparently you have almost no shared code in the MMC driver
> /or/ in the bus driver.

If we support MMC only, writing separate drivers for pci and usb is more
proper and clear. But we try to support mmc and memstick, and maybe xD
later, it seems that having a bus driver is more convenient.

>
> From this, I think it would be easier to kill off your own bus driver entirely
> and move the rtsx_pci.c driver into drivers/mfd, and then merge your
> pci/sdmmc.c file with rtsx_sdmmc.c.
>
>> +#define wait_timeout_x(task_state, msecs)			\
>> +do {								\
>> +	set_current_state((task_state));			\
>> +	schedule_timeout(msecs_to_jiffies(msecs));		\
>> +} while (0)
>> +
>> +#define wait_timeout(msecs)	wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
> This is the same as msleep_interruptible, right? Note that with interuptible
> sleep, you should always check if you got interrupted and return -ERESTARTSYS
> to user space.

Thank you for your explanation. It seems that I should call msleep
instead of msleep_interruptible.

Best regards,
wwang

