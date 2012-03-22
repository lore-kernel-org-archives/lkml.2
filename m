Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2CVRsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:48:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20660 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2CVRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:48:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 22 Mar 2012 18:48:00 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't
 explictly specified
In-reply-to: <4F6B5A22.1090204@cavium.com>
To: David Daney <david.daney@cavium.com>
Cc: "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "hskinnemoen@gmail.com" <hskinnemoen@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Rade Bozic <rade.bozic.ext@nsn.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "Daney, David" <David.Daney@caviumnetworks.com>
Message-id: <4F6B65D0.1030506@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
 <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com>
 <4F6B4532.7090806@samsung.com> <4F6B5A22.1090204@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2012 17:58, David Daney wrote:

> On 03/22/2012 08:28 AM, Karol Lewandowski wrote:
>> On 16.03.2012 13:19, Karol Lewandowski wrote:
>>
>>>> Commit 488bf314b ("i2c: Allow i2c_add_numbered_adapter() to assign a
>>>> bus id") reworked i2c_add_numbered_adapter() to call i2c_add_adapter()
>>>> if requested bus was -1.
>>
>>>> This allows to simplify driver's initialization procedure as it allows
>>
>>>> static and dynamic adapter id registration using one function.
>>>>
>>>> This patch updates few more drivers (missed out in original patch) to
>>>> use this functionality.
>>>
>>
>>> [ I must have lost actual problem description while rewording
>>>   message itself... ]
>>>
>>> Problem arises when multiple drivers (or multiple instances
>>> of one driver) try to assume the same fixed bus number (0).
>>>
>>> This simply causes i2c_add_numbered_bus() to fail.
>>> Leaving -1 works perfectly, as registration function switches
>>> to dynamic id registration.
>>
>>>> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> ---
>>>>   drivers/i2c/busses/i2c-gpio.c         |    7 +------
>>>>   drivers/i2c/busses/i2c-octeon.c       |    2 +-
>>>>   drivers/i2c/busses/i2c-pca-platform.c |    2 +-
>>>>   drivers/i2c/busses/i2c-versatile.c    |    9 ++-------
>>>>   4 files changed, 5 insertions(+), 15 deletions(-)
>>
>>
>> Dear Haavard, Rade, Wolfram and Russel
>>
>> Could you review following changes for gpio, octeon, pca-platform
>> and versatile i2c controller drivers (for which you are, or were,
>> maintainers)?
>>
>> Grant requested explicit Ack to get this merged.
>>
>> Thanks!
>>
>>>
>>> diff --git a/drivers/i2c/busses/i2c-gpio.c
>>> b/drivers/i2c/busses/i2c-gpio.c
>>> index a651779..50a2a94 100644
>>> --- a/drivers/i2c/busses/i2c-gpio.c
>>> +++ b/drivers/i2c/busses/i2c-gpio.c
>>> @@ -144,12 +144,7 @@ static int __devinit i2c_gpio_probe(struct
>>> platform_device *pdev)
>>>       adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
>>>       adap->dev.parent =&pdev->dev;
>>>
>>> -    /*
>>> -     * If "dev->id" is negative we consider it as zero.
>>> -     * The reason to do so is to avoid sysfs names that only make
>>> -     * sense when there are multiple adapters.
>>> -     */
>>> -    adap->nr = (pdev->id != -1) ? pdev->id : 0;
>>> +    adap->nr = pdev->id;
>>>       ret = i2c_bit_add_numbered_bus(adap);
>>>       if (ret)
>>>           goto err_add_bus;
>>> diff --git a/drivers/i2c/busses/i2c-octeon.c
>>> b/drivers/i2c/busses/i2c-octeon.c
>>> index ee139a5..8470232 100644
>>> --- a/drivers/i2c/busses/i2c-octeon.c
>>> +++ b/drivers/i2c/busses/i2c-octeon.c
>>> @@ -581,7 +581,7 @@ static int __devinit octeon_i2c_probe(struct
>>> platform_device *pdev)
>>>
>>>       i2c->adap = octeon_i2c_ops;
>>>       i2c->adap.dev.parent =&pdev->dev;
>>> -    i2c->adap.nr = pdev->id>= 0 ? pdev->id : 0;
>>> +    i2c->adap.nr = pdev->id;
> 
> I guess the OCTEON bit seems sane enough.  I don't fully understand why
> this needs changing, because OCTEON platform code always passes a
> non-negative pdev->id.


i2c controllers instantiated from device tree seem to have -1 as id.
Thus, trying to register more than one controller will fail as both
will try to register on bus 0.

However, I've just found that you got rid of this line altogether and
switched to dynamic id allocation (i2c_add_adapter() instead of
_numbered_ variant) in "MIPS: Octeon: Use Device Tree." RFC.
Found here:

  http://thread.gmane.org/gmane.linux.kernel/1104062

In the light of above my (octeon-)fixup becomes redundant.

Shall I repost this patch without octeon changes or is ok anyway?

Thanks!

>  But since you asked for it:
> 
> Acked-by: David Daney <david.daney@cavium.com>
> 
>>>       i2c_set_adapdata(&i2c->adap, i2c);
>>>       platform_set_drvdata(pdev, i2c);
>>>
>>> diff --git a/drivers/i2c/busses/i2c-pca-platform.c
>>> b/drivers/i2c/busses/i2c-pca-platform.c
>>> index 2adbf1a..675878f 100644
>>> --- a/drivers/i2c/busses/i2c-pca-platform.c
>>> +++ b/drivers/i2c/busses/i2c-pca-platform.c
>>> @@ -171,7 +171,7 @@ static int __devinit i2c_pca_pf_probe(struct
>>> platform_device *pdev)
>>>       i2c->io_size = resource_size(res);
>>>       i2c->irq = irq;
>>>
>>> -    i2c->adap.nr = pdev->id>= 0 ? pdev->id : 0;
>>> +    i2c->adap.nr = pdev->id;
>>>       i2c->adap.owner = THIS_MODULE;
>>>       snprintf(i2c->adap.name, sizeof(i2c->adap.name),
>>>            "PCA9564/PCA9665 at 0x%08lx",
>>> diff --git a/drivers/i2c/busses/i2c-versatile.c
>>> b/drivers/i2c/busses/i2c-versatile.c
>>> index 6055601..9458568 100644
>>> --- a/drivers/i2c/busses/i2c-versatile.c
>>> +++ b/drivers/i2c/busses/i2c-versatile.c
>>> @@ -102,13 +102,8 @@ static int i2c_versatile_probe(struct
>>> platform_device *dev)
>>>       i2c->algo = i2c_versatile_algo;
>>>       i2c->algo.data = i2c;
>>>
>>> -    if (dev->id>= 0) {
>>> -        /* static bus numbering */
>>> -        i2c->adap.nr = dev->id;
>>> -        ret = i2c_bit_add_numbered_bus(&i2c->adap);
>>> -    } else
>>> -        /* dynamic bus numbering */
>>> -        ret = i2c_bit_add_bus(&i2c->adap);
>>> +    i2c->adap.nr = dev->id;
>>> +    ret = i2c_bit_add_numbered_bus(&i2c->adap);
>>>       if (ret>= 0) {
>>>           platform_set_drvdata(dev, i2c);
>>>           return 0;
>>
>>
>>
> 
> 



-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
