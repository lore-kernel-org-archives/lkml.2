Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1F3Mku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:40:50 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57811 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab1F3Mkm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <87pqlwqwb1.fsf@ti.com>
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
	<87d3ix5c6y.fsf@ti.com>
	<BANLkTim43pAKe1o-aFmgh79bNqSyZmW_Fg@mail.gmail.com>
	<BANLkTi=pKL6RDBTDBStv+uhxVKp3-bwXbg@mail.gmail.com>
	<87pqlwqwb1.fsf@ti.com>
Date: Thu, 30 Jun 2011 18:10:40 +0530
Message-ID: <BANLkTimcaRX0epF27ntGnK7rvrCgQ-zyBQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and ohci
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        b-cousson@ti.com, paul@pwsan.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:50 AM, Kevin Hilman <khilman@ti.com> wrote:
> "Munegowda, Keshava" <keshava_mgowda@ti.com> writes:
>
>> On Wed, Jun 29, 2011 at 8:52 PM, Munegowda, Keshava
>> <keshava_mgowda@ti.com> wrote:
>>> On Thu, Jun 2, 2011 at 5:36 AM, Kevin Hilman <khilman@ti.com> wrote:
>>>> Keshava Munegowda <keshava_mgowda@ti.com> writes:
>>>>
>>>>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>>>>
>>>>> The global suspend and resume functions for usbhs core driver
>>>>> are implemented.These routine are called when the global suspend
>>>>> and resume occurs. Before calling these functions, the
>>>>> bus suspend and resume of ehci and ohci drivers are called
>>>>> from runtime pm.
>>>>>
>>>>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>>>>
>>>> First, from what I can see, this is only a partial implementation of
>>>> runtime PM.  What I mean is that the runtime PM methods are used only
>>>> during the suspend path.  The rest of the time the USB host IP block is
>>>> left enabled, even when nothing is connected.
>>>>
>>>> I tested this on my 3530/Overo board, and verified that indeed the
>>>> usbhost powerdomain hits retention on suspend, but while idle, when
>>>> nothing is connected, I would expect the driver could be clever enough
>>>> to use runtime PM (probably using autosuspend timeouts) to disable the
>>>> hardware as well.
>>>>
>>>>> ---
>>>>>  drivers/mfd/omap-usb-host.c |  103 +++++++++++++++++++++++++++++++++++++++++++
>>>>>  1 files changed, 103 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>>>>> index 43de12a..32d19e2 100644
>>>>> --- a/drivers/mfd/omap-usb-host.c
>>>>> +++ b/drivers/mfd/omap-usb-host.c
>>>>> @@ -146,6 +146,10 @@
>>>>>  #define is_ehci_hsic_mode(x) (x == OMAP_EHCI_PORT_MODE_HSIC)
>>>>>
>>>>>
>>>>> +/* USBHS state bits */
>>>>> +#define OMAP_USBHS_INIT              0
>>>>> +#define OMAP_USBHS_SUSPEND   4
>>>>
>>>> These additional state bits don't seem to be necessary.
>>>>
>>>> For suspend, just check 'pm_runtime_is_suspended()'
>>>>
>>>> The init flag is only used in the suspend/resume hooks, but the need for
>>>> it is a side effect of not correctly using the runtime PM callbacks.
>>>>
>>>> Remember that the runtime PM get/put hooks have usage counting.  Only
>>>> when the usage count transitions to/from zero is the actual
>>>> hardware-level enable/disable (via omap_hwmod) being done.
>>>>
>>>> The current code is making the assumption that every call to get/put is
>>>> going to result in an enable/disable of the hardware.
>>>>
>>>> Instead, all of the code that needs to be run only upon actual
>>>> enable/disable of the hardware should be done in the driver's
>>>> runtime_suspend/runtime_resume callbacks.  These are only called when
>>>> the hardware actually changes state.
>>>>
>>>> Not knowing that much about the EHCI block, upon first glance, it looks
>>>> like mmuch of what is done in usbhs_enable() should actually be done in
>>>> the ->runtime_resume() callback, and similarily, much of what is done in
>>>> usbhs_disable() should be done in the ->runtime_suspend() callback.
>>>
>>> Kevin,
>>>   do you mean driver->runtime_resume and driver->runtime_resume call backs.
>>> are these call backs from pm_runtime_get_sync and pm_runtime_put_sync?
>>
>> for usb host case , I am seeing that the pm_runtime_get_sync
>>
>>
>> static int rpm_resume(struct device *dev, int rpmflags)
>> {
>>   ............
>>  ..........
>>       if (dev->pwr_domain) {
>>               callback = dev->pwr_domain->ops.runtime_resume;
>>               if(!strcmp(dev_name(dev),"usbhs_omap"))
>>                        pr_err("dev->pwr_domain->ops.runtime_resume");
>>       }
>>       else if (dev->type && dev->type->pm) {
>>               callback = dev->type->pm->runtime_resume;
>>               if(!strcmp(dev_name(dev),"usbhs_omap"))
>>                        pr_err("dev->type->pm->runtime_resume");
>>       }
>>       else if (dev->class && dev->class->pm) {
>>               callback = dev->class->pm->runtime_resume;
>>               if(!strcmp(dev_name(dev),"usbhs_omap"))
>>                        pr_err("ev->class->pm->runtime_resume");
>>       }
>>       else if (dev->bus && dev->bus->pm) {
>>               callback = dev->bus->pm->runtime_resume;
>>       if(!strcmp(dev_name(dev),"usbhs_omap"))
>>                pr_err("dev->bus->pm->runtime_resume");
>>       }
>>       else
>>               callback = NULL;
>> }
>>
>>
>> I am seeing that below if statement was hitting true:
>>
>>       if (dev->pwr_domain) {
>>               callback = dev->pwr_domain->ops.runtime_resume;
>>               if(!strcmp(dev_name(dev),"usbhs_omap"))
>>                        pr_err("dev->pwr_domain->ops.runtime_resume");
>>
>>
>> due to this; the driver->runtime_resume was not getting called.
>>
>> Any idea on why I am seeing only the dev->pwr_domain is set not
>> dev->bus && dev->bus->pm is hitting here?
>
> Because that's how it was designed. :)
>
> On OMAP, for on-chip devices (omap_devices) we use PM domains
> (pwr_domain) and not the subsystem (bus) to implment runtime PM, and as
> Alan pointed out, PM domains have precedence over subsystem callbacks.
>
> I'm curious why you determined the driver's runtime resume was not
> getting called?
>
> The PM domain callback will call your driver's runtime_resume (assuming
> it exists.)
>
> rpm_resume()
>   dev->pwr_domain->ops.runtime_resume()
>       omap_device_enable()
>       pm_generic_runtime_resume()
>          dev->driver->pm->runtime_resume()
>
> Note that the PM domain implementation is done at the omap_device
> level.  Specifically, see plat-omap/omap_device.c:_od_runtime_resume()
>
> Kevin

Thanks to partha and others

I was an rc issue; I migrated to latest kernel ; its working now.
driver runtime call backs are getting
called now. :-)
