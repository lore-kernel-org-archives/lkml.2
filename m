Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2E3QNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:13:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36543 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab2E3QNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:13:04 -0400
Message-ID: <4FC646FF.1000209@ti.com>
Date: Wed, 30 May 2012 11:12:47 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Xiao Jiang <jgq516@gmail.com>, <linux@arm.linux.org.uk>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <rnayak@ti.com>, <tony@atomide.com>, <wim@iguana.be>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 3/3] watchdog: omap_wdt: add device tree support
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com> <1337942552-28218-4-git-send-email-jgq516@gmail.com> <4FC51008.1050004@ti.com> <4FC59171.8040009@gmail.com> <4FC5D21F.2030702@ti.com> <4FC636C9.2050902@ti.com> <4FC63D03.8080501@ti.com>
In-Reply-To: <4FC63D03.8080501@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 05/30/2012 10:30 AM, Cousson, Benoit wrote:
> Hi Jon,
> 
> On 5/30/2012 5:03 PM, Jon Hunter wrote:
>> Hi Benoit,
>>
>> On 05/30/2012 02:54 AM, Cousson, Benoit wrote:
>>> On 5/30/2012 5:18 AM, Xiao Jiang wrote:
>>>> Jon Hunter wrote:
>>>>> On 05/25/2012 05:42 AM, jgq516@gmail.com wrote:
>>>>>> From: Xiao Jiang<jgq516@gmail.com>
>>>>>>
>>>>>> Add device table for omap_wdt to support dt.
>>>>>>
>>>>>> Signed-off-by: Xiao Jiang<jgq516@gmail.com>
>>>>>> ---
>>>>>> drivers/watchdog/omap_wdt.c | 8 ++++++++
>>>>>> 1 files changed, 8 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/watchdog/omap_wdt.c
>>>>>> b/drivers/watchdog/omap_wdt.c
>>>>>> index 8285d65..d98c615 100644
>>>>>> --- a/drivers/watchdog/omap_wdt.c
>>>>>> +++ b/drivers/watchdog/omap_wdt.c
>>>>>> @@ -430,6 +430,13 @@ static int omap_wdt_resume(struct
>>>>>> platform_device *pdev)
>>>>>> #define omap_wdt_resume NULL
>>>>>> #endif
>>>>>>
>>>>>> +static const struct of_device_id omap_wdt_of_match[] = {
>>>>>> + { .compatible = "ti,omap3-wdt", },
>>>>>> + { .compatible = "ti,omap4-wdt", },
>>>
>>> If there is no difference between the OMAP3 and the OMAP4 WDT IP, just
>>> add one entry "ti,omap3-wdt". And then in the OMAP4 DTS you will just
>>> put : compatible = "ti,omap3-wdt"; or compatible =  "ti,omap4-wdt",
>>> "ti,omap3-wdt";
>>
>> Hmmm ... comparing the omap3 and omap4 wdt registers there are some
>> differences. omap4 seems to have more registers than omap3. May be we
>> are not using these right now, but from a register perspective the wdt
>> in omap2, omap3 and omap4 appear to be slightly different. The revision
>> ID register on omap3 and omap4 have different values too.
>>
>> I guess from a driver perspective there is no difference, but it seemed
>> to me that the IP is not completely the same.
> 
> Well, in that case, and assuming that there is no proper HW_REVISION
> information to detect the IP difference, the proper compatible entries
> will indeed have to be used.

So looking at a 4460 and 3430, the WIDR register (IP revision) can be
used to distinguish between IP revisions. So it appears that we do have
proper HW REV info.

So may be I am not completely up to speed of the intent of the
compatible field. In other words, should this be used to indicate if the
IP is same/compatible or the driver is compatible or both. Technically
right now we could just have "ti-omap2-wdt" for all omap2+ devices as
the driver is compatible for all devices. However, technically, the IP
is not completely the same but it is compatible :-)

>>> I'm still a little bit confused about the real need for the
>>> "ti,omap4-wdt: entry, but it seems to be the way to do it in PPC.
>>>
>>>>>> + {},
>>>>>> +};
>>>>>> +MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
>>>>>> +
>>>>>> static struct platform_driver omap_wdt_driver = {
>>>>>> .probe = omap_wdt_probe,
>>>>>> .remove = __devexit_p(omap_wdt_remove),
>>>>>> @@ -439,6 +446,7 @@ static struct platform_driver omap_wdt_driver = {
>>>>>> .driver = {
>>>>>> .owner = THIS_MODULE,
>>>>>> .name = "omap_wdt",
>>>>>> + .of_match_table = omap_wdt_of_match,
>>>>>> },
>>>>>> };
>>>>>>
>>>>>
>>>>> I think we need to add some code to the probe function that calls
>>>>> of_match_device() and ensures we find a match. For example ...
>>>>>
>>>>> if (of_have_populated_dt())
>>>>> if (!of_match_device(omap_wdt_of_match,&pdev->dev))
>>>>> return -EINVAL;
>>>>>
>>>> Will add it in v2, thanks for suggestion.
>>>
>>> No, in fact this is not needed. We need that mainly when several
>>> instances can match the same driver and thus we select the proper one
>>> using the of_match_device. Otherwise, just check is the device_node is
>>> there.
>>>
>>> In that case, the driver does not even care about any DT node so there
>>> is no need to add extra code for that. Keep it simple.
>>
>> Ok. So are you saying get rid of the match table altogether? In other
>> words, drop this patch?
> 
> No, the match table is used by the LDM to find the proper driver to be
> bound to a device. So we do need it. But we do not have to use the
> of_match_device if we do not want to get the entry in the device table.

Ok, thanks.

>> I agree that it does not really do anything today, but I did not know if
>> in the future you were planning to pass things like, register addresses,
>> via DT.
> 
> Well, yes we will have to, otherwise people will keep complaining that
> our DTS sucks and are not compliant with the DTS standards :-)

Ok.

Jon
