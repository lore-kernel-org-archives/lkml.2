Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2EBFBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:01:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40980 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2EBFBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:01:18 -0400
X-AuditID: cbfee61b-b7ce2ae00000583e-88-4fa0bf9dc9f5
Message-id: <4FA0BF9C.7090107@samsung.com>
Date: Wed, 02 May 2012 14:01:16 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        Chiwoong byun <woong.byun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] MFD : add MAX77686 mfd driver
References: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120501165825.GA3264@sirena.org.uk>
In-reply-to: <20120501165825.GA3264@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

You point out many things. ;-) Thanks for your concern.
I want to explain one by one.

You mentioned 5 things in your e-mail.

1. I agreed that option is unnecessary, so i decided to remove it.
	(#ifdef CONFIG_RTC_DRV_MAX77686 )

2. Those steps is needed for wake-up interrupt occurred by 77686 irq.
   When system has woken up from Suspend-to-RAM state by 77686 irq,
	then it never call irq handler.

3. I accept your opinion and will apply it.

4. This will work when I2C interface is changed according to board
	revision with board configuration.

5. This is for some board that doesn't use RTC. (e.g. SMDK board)


Thanks,

On 2012-05-02 01:58, Mark Brown wrote:

> On Mon, Apr 30, 2012 at 05:53:42PM +0900, Jonghwa Lee wrote:
> 
>> +	if (irq_src & MAX77686_IRQSRC_RTC) {
>> +#ifdef CONFIG_RTC_DRV_MAX77686
>> +		ret = max77686_read_reg(max77686->rtc, MAX77686_RTC_INT,
>> +					 &irq_reg[RTC_INT]);
>> +#else
>> +		ret = -ENODEV;
>> +#endif
> 
> Why is this in an ifdef?  It's not really idiomatic to do this and if
> the interrupt is never requested presumably everything should be fine.
> 
>> +int max77686_irq_resume(struct max77686_dev *max77686)
>> +{
>> +	if (max77686->irq && max77686->irq_base)
>> +		max77686_irq_thread(max77686->irq_base, max77686);
>> +	return 0;
>> +}
> 
> Why is this needed?  I'd expect the parent IRQ controller to notice if
> the device is asserting an interrupt when it resumes.
> 
>> +int max77686_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
>> +{
>> +	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
>> +	int ret;
>> +
>> +	mutex_lock(&max77686->iolock);
>> +	ret = i2c_smbus_read_byte_data(i2c, reg);
>> +	mutex_unlock(&max77686->iolock);
>> +	if (ret < 0)
>> +		return ret;
> 
> It would be much better to use regmap for the register I/O since this is
> a PMIC and at least the regulator framework (possibly others soon) are
> starting to abstract things out using it.  It also gets you things like
> the debugfs dumps of the register map and so on easily.
> 
>> +	} else
>> +		dev_info(max77686->dev, "device found\n");
> 
> This isn't relly adding much - can you log a chip revision or anything?
> 
>> +#ifdef CONFIG_RTC_DRV_MAX77686
>> +	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
>> +	i2c_set_clientdata(max77686->rtc, max77686);
>> +#endif
> 
> Again, it's very odd that this is conditional.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


