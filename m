Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031027Ab2CVQ6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:58:15 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13449 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030928Ab2CVQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:58:13 -0400
Message-ID: <4F6B5A22.1090204@cavium.com>
Date: Thu, 22 Mar 2012 09:58:10 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
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
Subject: Re: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't explictly
 specified
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com> <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com> <4F6B4532.7090806@samsung.com>
In-Reply-To: <4F6B4532.7090806@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2012 16:57:55.0952 (UTC) FILETIME=[ED8BEF00:01CD084C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 08:28 AM, Karol Lewandowski wrote:
> On 16.03.2012 13:19, Karol Lewandowski wrote:
>
>>> Commit 488bf314b ("i2c: Allow i2c_add_numbered_adapter() to assign a
>>> bus id") reworked i2c_add_numbered_adapter() to call i2c_add_adapter()
>>> if requested bus was -1.
>
>>> This allows to simplify driver's initialization procedure as it allows
>
>>> static and dynamic adapter id registration using one function.
>>>
>>> This patch updates few more drivers (missed out in original patch) to
>>> use this functionality.
>>
>
>> [ I must have lost actual problem description while rewording
>>   message itself... ]
>>
>> Problem arises when multiple drivers (or multiple instances
>> of one driver) try to assume the same fixed bus number (0).
>>
>> This simply causes i2c_add_numbered_bus() to fail.
>> Leaving -1 works perfectly, as registration function switches
>> to dynamic id registration.
>
>>> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>> ---
>>>   drivers/i2c/busses/i2c-gpio.c         |    7 +------
>>>   drivers/i2c/busses/i2c-octeon.c       |    2 +-
>>>   drivers/i2c/busses/i2c-pca-platform.c |    2 +-
>>>   drivers/i2c/busses/i2c-versatile.c    |    9 ++-------
>>>   4 files changed, 5 insertions(+), 15 deletions(-)
>
>
> Dear Haavard, Rade, Wolfram and Russel
>
> Could you review following changes for gpio, octeon, pca-platform
> and versatile i2c controller drivers (for which you are, or were,
> maintainers)?
>
> Grant requested explicit Ack to get this merged.
>
> Thanks!
>
>>
>> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
>> index a651779..50a2a94 100644
>> --- a/drivers/i2c/busses/i2c-gpio.c
>> +++ b/drivers/i2c/busses/i2c-gpio.c
>> @@ -144,12 +144,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
>>   	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
>>   	adap->dev.parent =&pdev->dev;
>>
>> -	/*
>> -	 * If "dev->id" is negative we consider it as zero.
>> -	 * The reason to do so is to avoid sysfs names that only make
>> -	 * sense when there are multiple adapters.
>> -	 */
>> -	adap->nr = (pdev->id != -1) ? pdev->id : 0;
>> +	adap->nr = pdev->id;
>>   	ret = i2c_bit_add_numbered_bus(adap);
>>   	if (ret)
>>   		goto err_add_bus;
>> diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
>> index ee139a5..8470232 100644
>> --- a/drivers/i2c/busses/i2c-octeon.c
>> +++ b/drivers/i2c/busses/i2c-octeon.c
>> @@ -581,7 +581,7 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
>>
>>   	i2c->adap = octeon_i2c_ops;
>>   	i2c->adap.dev.parent =&pdev->dev;
>> -	i2c->adap.nr = pdev->id>= 0 ? pdev->id : 0;
>> +	i2c->adap.nr = pdev->id;

I guess the OCTEON bit seems sane enough.  I don't fully understand why 
this needs changing, because OCTEON platform code always passes a 
non-negative pdev->id.  But since you asked for it:

Acked-by: David Daney <david.daney@cavium.com>

>>   	i2c_set_adapdata(&i2c->adap, i2c);
>>   	platform_set_drvdata(pdev, i2c);
>>
>> diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
>> index 2adbf1a..675878f 100644
>> --- a/drivers/i2c/busses/i2c-pca-platform.c
>> +++ b/drivers/i2c/busses/i2c-pca-platform.c
>> @@ -171,7 +171,7 @@ static int __devinit i2c_pca_pf_probe(struct platform_device *pdev)
>>   	i2c->io_size = resource_size(res);
>>   	i2c->irq = irq;
>>
>> -	i2c->adap.nr = pdev->id>= 0 ? pdev->id : 0;
>> +	i2c->adap.nr = pdev->id;
>>   	i2c->adap.owner = THIS_MODULE;
>>   	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
>>   		 "PCA9564/PCA9665 at 0x%08lx",
>> diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
>> index 6055601..9458568 100644
>> --- a/drivers/i2c/busses/i2c-versatile.c
>> +++ b/drivers/i2c/busses/i2c-versatile.c
>> @@ -102,13 +102,8 @@ static int i2c_versatile_probe(struct platform_device *dev)
>>   	i2c->algo = i2c_versatile_algo;
>>   	i2c->algo.data = i2c;
>>
>> -	if (dev->id>= 0) {
>> -		/* static bus numbering */
>> -		i2c->adap.nr = dev->id;
>> -		ret = i2c_bit_add_numbered_bus(&i2c->adap);
>> -	} else
>> -		/* dynamic bus numbering */
>> -		ret = i2c_bit_add_bus(&i2c->adap);
>> +	i2c->adap.nr = dev->id;
>> +	ret = i2c_bit_add_numbered_bus(&i2c->adap);
>>   	if (ret>= 0) {
>>   		platform_set_drvdata(dev, i2c);
>>   		return 0;
>
>
>

