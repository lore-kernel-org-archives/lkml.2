Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2JMIsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 04:48:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38750 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2JMIsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 04:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <507920E0.2050104@gmail.com>
References: <1350039495-360-1-git-send-email-zonque@gmail.com>
 <1350039495-360-2-git-send-email-zonque@gmail.com> <5078295E.2090803@gmail.com>
 <50782F82.8060206@ti.com> <507833ED.8060903@gmail.com> <507835E9.9020200@ti.com>
 <ae718323-6d65-4e69-b8f9-6382c6299294@email.android.com> <507920E0.2050104@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 13 Oct 2012 09:48:21 +0100
X-Google-Sender-Auth: w8s2sfDMEO1PGag2g_Fjd-qXjFg
Message-ID: <CACxGe6tGYrO8Z0MxiOV+rjBprRxzT-4v6CiBh8wV0Avufd0doA@mail.gmail.com>
Subject: Re: [PATCH 1/4] MMC: omap_hsmmc: set platform data after probe from
 DT node
To: Daniel Mack <zonque@gmail.com>
Cc: Balaji T K <balajitk@ti.com>, linux-mmc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 9:05 AM, Daniel Mack <zonque@gmail.com> wrote:
> Hi Grant,
>
> On 13.10.2012 02:05, Grant Likely wrote:
>>
>>
>> Balaji T K <balajitk@ti.com> wrote:
>>
>>> On Friday 12 October 2012 08:44 PM, Daniel Mack wrote:
>>>> On 12.10.2012 16:56, Balaji T K wrote:
>>>>> On Friday 12 October 2012 07:59 PM, Daniel Mack wrote:
>>>>>> On 12.10.2012 12:58, Daniel Mack wrote:
>>>>>>> diff --git a/drivers/mmc/host/omap_hsmmc.c
>>> b/drivers/mmc/host/omap_hsmmc.c
>>>>>>> index 19ccb59..4b70823 100644 ---
>>>>>>> a/drivers/mmc/host/omap_hsmmc.c +++
>>>>>>> b/drivers/mmc/host/omap_hsmmc.c @@ -1728,6 +1728,7 @@
>>>>>>> static int __devinit omap_hsmmc_probe(struct
>>> platform_device *pdev)
>>>>>>> const u16 *offsetp = match->data; pdata->reg_offset =
>>>>>>> *offsetp; } +            pdev->dev.platform_data = pdata; }
>>>>>>>
>>>>>>> if (pdata == NULL) {
>>>>>>>
>>>>>>
>>>>>> FWIW, this is the Oops I see without this patch:
>>>>> Hi, Shouldn't pdev->dev.platform_data be set to NULL on _remove
>>>>> ?
>>>>
>>>> Why?
>>>
>>> To make sure on second insmod it is NULL, When built as module, So
>>> that of_get_hsmmc_pdata is called to create pdata.
>>
>> Actually the driver should *never* modify the value of
>> dev->platform_data. Ever.
>
> That's interesting, because many drivers do this, especially since they
> were converted to DT probing. Mostly because that way, the platform data
> logic in callback functions can be reused, and often the platform
> specific data is only stored in pdata and taken from there during the
> lifetime of a device.
>
> Is there any particular reason why this approach is frowned upon?

Yes. The platform data pointer is "owned" by the code that registered
the platform device, not by the device driver. Some drivers do it, but
it is definitely illegal. I should add code to the platform bus core
code to throw a warning to any drivers that do that. It is a problem
because it becomes easy to mess up the lifetime model of device data,
particularly when it comes to unbinding/rebinding devices. For
example, if a driver changes the pdata pointer and then gets unbound,
then there will be a stale pdata pointer that may point to either
incorrect data or a data structure that is no longer allocated. You
could argue that it is fine if the driver is smart about how it cleans
up after itself, but in my experience driver authors rarely get it
correct and it results in a lot more code than is necessary. It is far
better for the driver to either grab all the data it needs out of
pdata at .probe() time, or to keep a copy of the 'correct' pdata
(correct depending on where the device retrieved it's data) in it's
private data structure instead of modifying the device.

>
>> Make a copy instead.
>
> A copy of what exactly? Of all members of the legacy pdata you mean?

Yes. If the driver directly accesses the pdata structure outside of
the .probe() hook, then it should be modified to either copy the pdata
into the driver's private data structure, or it should copy the
pointer to the pdata so that OF usage can allocate one itself. For
example:

somedriver_probe(struct platform_device *pdev)
{
      struct somedriver_private *somedriver;

      somedriver = devm_kzalloc(sizeof (*somedriver), GFP_KERNEL);
      somedriver->pdata = pdev->platform_data;
      if (OF)
              somedriver->pdata = devm_kzalloc(sizeof
(*somedriver->pdata), GFP_KERNEL);
}

The bonus with using devm_kzalloc is the driver doesn't even need to
do anything special to undo these allocations on failure or release.
:-)

g.
