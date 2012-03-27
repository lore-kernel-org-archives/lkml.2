Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2C0BWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 21:22:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54116 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2C0BWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 21:22:13 -0400
Message-ID: <4F71163A.5090309@gmail.com>
Date: Mon, 26 Mar 2012 20:22:02 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>
Subject: Re: [PATCH 1/5] i2c: Convert i2c-octeon.c to use device tree.
References: <1332808075-8333-1-git-send-email-ddaney.cavm@gmail.com> <1332808075-8333-2-git-send-email-ddaney.cavm@gmail.com> <4F7115FA.6080507@gmail.com>
In-Reply-To: <4F7115FA.6080507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 08:20 PM, Rob Herring wrote:
> On 03/26/2012 07:27 PM, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> There are three parts to this:
>>
>> 1) Remove the definitions of OCTEON_IRQ_TWSI and OCTEON_IRQ_TWSI2.
>>    The interrupts are specified by the device tree and these hard
>>    coded irq numbers block the used of the irq lines by the irq_domain
>>    code.
>>
>> 2) Remove platform device setup code from octeon-platform.c, it is
>>    now unused.
>>
>> 3) Convert i2c-octeon.c to use device tree.  Part of this includes
>>    using the devm_* functions instead of the raw counterparts, thus
>>    simplifying error handling.  No functionality is changed.
> 
> Shouldn't this patch go after converting the platform to DT?

Nevermind this comment...

> 
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
>> Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
>> Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
>> Cc: linux-i2c@vger.kernel.org
>> ---
>>
>> Should probably go via Ralf's linux-mips.org tree.
>>
>>  arch/mips/cavium-octeon/octeon-irq.c      |    2 -
>>  arch/mips/cavium-octeon/octeon-platform.c |   84 -------------------------
>>  arch/mips/include/asm/octeon/octeon.h     |    5 --
>>  drivers/i2c/busses/i2c-octeon.c           |   94 ++++++++++++++++-------------
>>  4 files changed, 52 insertions(+), 133 deletions(-)
> 
> snip
> 
>>  
>> -	if (i2c_data == NULL) {
>> -		dev_err(i2c->dev, "no I2C frequency data\n");
>> +	/*
>> +	 * "clock-rate" is a legacy binding, the official binding is
>> +	 * "clock-frequency".  Try the official one first and then
>> +	 * fall back if it doesn't exist.
>> +	 */
>> +	data = of_get_property(pdev->dev.of_node, "clock-frequency", &len);
>> +	if (!data || len != sizeof(*data))
>> +		data = of_get_property(pdev->dev.of_node, "clock-rate", &len);
>> +	if (data && len == sizeof(*data)) {
>> +		i2c->twsi_freq = be32_to_cpup(data);
> 
> Can't you use of_property_read_u32?
> 
> Does the legacy binding really exist as DT support is new?
> 
> Otherwise,
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
>> +	} else {
>> +		dev_err(i2c->dev,
>> +			"no I2C 'clock-rate' or 'clock-frequency' property\n");
>>  		result = -ENXIO;
>> -		goto fail_region;
>> +		goto out;
>>  	}
>>  
>> -	i2c->twsi_phys = res_mem->start;
>> -	i2c->regsize = resource_size(res_mem);
>> -	i2c->twsi_freq = i2c_data->i2c_freq;
>> -	i2c->sys_freq = i2c_data->sys_freq;
>> +	i2c->sys_freq = octeon_get_io_clock_rate();
>>  
>> -	if (!request_mem_region(i2c->twsi_phys, i2c->regsize, res_mem->name)) {
>> +	if (!devm_request_mem_region(&pdev->dev, i2c->twsi_phys, i2c->regsize,
>> +				      res_mem->name)) {
>>  		dev_err(i2c->dev, "request_mem_region failed\n");
>> -		goto fail_region;
>> +		goto out;
>>  	}
>> -	i2c->twsi_base = ioremap(i2c->twsi_phys, i2c->regsize);
>> +	i2c->twsi_base = devm_ioremap(&pdev->dev, i2c->twsi_phys, i2c->regsize);
>>  
>>  	init_waitqueue_head(&i2c->queue);
>>  
>>  	i2c->irq = irq;
>>  
>> -	result = request_irq(i2c->irq, octeon_i2c_isr, 0, DRV_NAME, i2c);
>> +	result = devm_request_irq(&pdev->dev, i2c->irq,
>> +				  octeon_i2c_isr, 0, DRV_NAME, i2c);
>>  	if (result < 0) {
>>  		dev_err(i2c->dev, "failed to attach interrupt\n");
>> -		goto fail_irq;
>> +		goto out;
>>  	}
>>  
>>  	result = octeon_i2c_initlowlevel(i2c);
>>  	if (result) {
>>  		dev_err(i2c->dev, "init low level failed\n");
>> -		goto  fail_add;
>> +		goto  out;
>>  	}
>>  
>>  	result = octeon_i2c_setclock(i2c);
>>  	if (result) {
>>  		dev_err(i2c->dev, "clock init failed\n");
>> -		goto  fail_add;
>> +		goto  out;
>>  	}
>>  
>>  	i2c->adap = octeon_i2c_ops;
>>  	i2c->adap.dev.parent = &pdev->dev;
>> -	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
>> +	i2c->adap.dev.of_node = pdev->dev.of_node;
>>  	i2c_set_adapdata(&i2c->adap, i2c);
>>  	platform_set_drvdata(pdev, i2c);
>>  
>> -	result = i2c_add_numbered_adapter(&i2c->adap);
>> +	result = i2c_add_adapter(&i2c->adap);
>>  	if (result < 0) {
>>  		dev_err(i2c->dev, "failed to add adapter\n");
>>  		goto fail_add;
>>  	}
>> -
>>  	dev_info(i2c->dev, "version %s\n", DRV_VERSION);
>>  
>> -	return result;
>> +	of_i2c_register_devices(&i2c->adap);
>> +
>> +	return 0;
>>  
>>  fail_add:
>>  	platform_set_drvdata(pdev, NULL);
>> -	free_irq(i2c->irq, i2c);
>> -fail_irq:
>> -	iounmap(i2c->twsi_base);
>> -	release_mem_region(i2c->twsi_phys, i2c->regsize);
>> -fail_region:
>> -	kfree(i2c);
>>  out:
>>  	return result;
>>  };
>> @@ -613,19 +619,24 @@ static int __devexit octeon_i2c_remove(struct platform_device *pdev)
>>  
>>  	i2c_del_adapter(&i2c->adap);
>>  	platform_set_drvdata(pdev, NULL);
>> -	free_irq(i2c->irq, i2c);
>> -	iounmap(i2c->twsi_base);
>> -	release_mem_region(i2c->twsi_phys, i2c->regsize);
>> -	kfree(i2c);
>>  	return 0;
>>  };
>>  
>> +static struct of_device_id octeon_i2c_match[] = {
>> +	{
>> +		.compatible = "cavium,octeon-3860-twsi",
>> +	},
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, octeon_i2c_match);
>> +
>>  static struct platform_driver octeon_i2c_driver = {
>>  	.probe		= octeon_i2c_probe,
>>  	.remove		= __devexit_p(octeon_i2c_remove),
>>  	.driver		= {
>>  		.owner	= THIS_MODULE,
>>  		.name	= DRV_NAME,
>> +		.of_match_table = octeon_i2c_match,
>>  	},
>>  };
>>  
>> @@ -635,4 +646,3 @@ MODULE_AUTHOR("Michael Lawnick <michael.lawnick.ext@nsn.com>");
>>  MODULE_DESCRIPTION("I2C-Bus adapter for Cavium OCTEON processors");
>>  MODULE_LICENSE("GPL");
>>  MODULE_VERSION(DRV_VERSION);
>> -MODULE_ALIAS("platform:" DRV_NAME);
> 

