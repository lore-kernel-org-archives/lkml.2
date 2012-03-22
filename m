Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031101Ab2CVRDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:03:11 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40528 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2CVRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:03:06 -0400
Date: Thu, 22 Mar 2012 18:03:04 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't
 explictly specified
In-reply-to: <20120322161134.GA1577@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: w.sang@pengutronix.de, hskinnemoen@gmail.com,
        Rade Bozic <rade.bozic.ext@nsn.com>, ben-linux@fluff.org,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        bigeasy@linutronix.de, m.szyprowski@samsung.com,
        grant.likely@secretlab.ca, kyungmin.park@samsung.com,
        David Daney <ddaney@caviumnetworks.com>
Message-id: <4F6B5B48.1090804@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
 <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com>
 <4F6B4532.7090806@samsung.com> <20120322161134.GA1577@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2012 17:11, Russell King - ARM Linux wrote:

> On Thu, Mar 22, 2012 at 04:28:50PM +0100, Karol Lewandowski wrote:
>> Dear Haavard, Rade, Wolfram and Russel
>>
>> Could you review following changes for gpio, octeon, pca-platform
>> and versatile i2c controller drivers (for which you are, or were,
>> maintainers)?
>>
>> Grant requested explicit Ack to get this merged.
> 
> All I have is the patch below, which doesn't make sense on its own.  Where
> is patch 1, which is presumably the core changes ?


Grant's (core) patch has been merged into v3.1-rc1 - the one I've cited:

  Commit 488bf314b ("i2c: Allow i2c_add_numbered_adapter() to assign a
  bus id") reworked i2c_add_numbered_adapter() to call i2c_add_adapter()
  if requested bus was -1.

This patchset just cleans up the drivers after it.

[ All what patch 1 does is just to drop no longer applicable comment:

  http://permalink.gmane.org/gmane.linux.drivers.i2c/10349 ]

Thanks

>>> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
>>> index a651779..50a2a94 100644
>>> --- a/drivers/i2c/busses/i2c-gpio.c
>>> +++ b/drivers/i2c/busses/i2c-gpio.c
>>> @@ -144,12 +144,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
>>>  	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
>>>  	adap->dev.parent = &pdev->dev;
>>>  
>>> -	/*
>>> -	 * If "dev->id" is negative we consider it as zero.
>>> -	 * The reason to do so is to avoid sysfs names that only make
>>> -	 * sense when there are multiple adapters.
>>> -	 */
>>> -	adap->nr = (pdev->id != -1) ? pdev->id : 0;
>>> +	adap->nr = pdev->id;
>>>  	ret = i2c_bit_add_numbered_bus(adap);
>>>  	if (ret)
>>>  		goto err_add_bus;
>>> diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
>>> index ee139a5..8470232 100644
>>> --- a/drivers/i2c/busses/i2c-octeon.c
>>> +++ b/drivers/i2c/busses/i2c-octeon.c
>>> @@ -581,7 +581,7 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
>>>  
>>>  	i2c->adap = octeon_i2c_ops;
>>>  	i2c->adap.dev.parent = &pdev->dev;
>>> -	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
>>> +	i2c->adap.nr = pdev->id;
>>>  	i2c_set_adapdata(&i2c->adap, i2c);
>>>  	platform_set_drvdata(pdev, i2c);
>>>  
>>> diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
>>> index 2adbf1a..675878f 100644
>>> --- a/drivers/i2c/busses/i2c-pca-platform.c
>>> +++ b/drivers/i2c/busses/i2c-pca-platform.c
>>> @@ -171,7 +171,7 @@ static int __devinit i2c_pca_pf_probe(struct platform_device *pdev)
>>>  	i2c->io_size = resource_size(res);
>>>  	i2c->irq = irq;
>>>  
>>> -	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
>>> +	i2c->adap.nr = pdev->id;
>>>  	i2c->adap.owner = THIS_MODULE;
>>>  	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
>>>  		 "PCA9564/PCA9665 at 0x%08lx",
>>> diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
>>> index 6055601..9458568 100644
>>> --- a/drivers/i2c/busses/i2c-versatile.c
>>> +++ b/drivers/i2c/busses/i2c-versatile.c
>>> @@ -102,13 +102,8 @@ static int i2c_versatile_probe(struct platform_device *dev)
>>>  	i2c->algo = i2c_versatile_algo;
>>>  	i2c->algo.data = i2c;
>>>  
>>> -	if (dev->id >= 0) {
>>> -		/* static bus numbering */
>>> -		i2c->adap.nr = dev->id;
>>> -		ret = i2c_bit_add_numbered_bus(&i2c->adap);
>>> -	} else
>>> -		/* dynamic bus numbering */
>>> -		ret = i2c_bit_add_bus(&i2c->adap);
>>> +	i2c->adap.nr = dev->id;
>>> +	ret = i2c_bit_add_numbered_bus(&i2c->adap);
>>>  	if (ret >= 0) {
>>>  		platform_set_drvdata(dev, i2c);
>>>  		return 0;
>>
>>
>>
>> -- 
>> Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
> 



-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
