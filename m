Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0GWS4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:56:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30628 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0GWS4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:56:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48316672"
Message-ID: <4C49E5EE.2070103@codeaurora.org>
Date: Fri, 23 Jul 2010 12:56:46 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: khali@linux-fr.org, ben-linux@fluff.org, linux-arm-msm@vger.kernel.org,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1279853264-16311-1-git-send-email-kheitke@codeaurora.org> <4C494086.5080408@codeaurora.org>
In-Reply-To: <4C494086.5080408@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trilok Soni wrote:
> Hi Ken,
> 
> On 7/23/2010 8:17 AM, Kenneth Heitke wrote:
>> This bus driver supports the QUP i2c hardware controller in the Qualcomm
>> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
>> purpose data path engine with input/output FIFOs and an embedded i2c
>> mini-core. The driver supports FIFO mode (for low bandwidth applications)
>> and block mode (interrupt generated for each block-size data transfer).
>> The driver currently does not support DMA transfers.
>>
>> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> 
> Thanks for the posting the driver.
> 
>> +
>> +static void
>> +qup_i2c_pwr_timer(unsigned long data)
>> +{
>> +	struct qup_i2c_dev *dev = (struct qup_i2c_dev *) data;
>> +	dev_dbg(dev->dev, "QUP_Power: Inactivity based power management\n");
>> +	if (dev->clk_state == 1)
>> +		qup_i2c_pwr_mgmt(dev, 0);
>> +}
> 
> Why this timer can't be converted to run-time PM functionality? I see this very much related
> to what we are introducing in the Runtime-PM functionality, isn't it?

Thanks, We will investigate further.

> 
>> +
>> +	if (!pdata->msm_i2c_config_gpio) {
>> +		dev_err(&pdev->dev, "config_gpio function not initialized\n");
>> +		ret = -ENOSYS;
>> +		goto err_config_failed;
>> +	}
> 
> I don't agree here. What if I do all the gpio configuration from the bootloader itself,
> because I know that the device I am working on is production device and don't change
> its configuration, then why I should provide the pdata hooks from the board files?

The reason that this hook is required is so that the driver can enable 
and disable the GPIOs as needed (although we currently only enable them).

> 
> Please also specify what are the operations we are doing in the msm_i2c_config_gpio?

Takes ownership of the GPIOs that are needed and assigns the ownership 
to the i2c controller.  The drive strength is also set.

> 
>> +
>> +	/* We support frequencies upto FAST Mode(400KHz) */
>> +	if (pdata->clk_freq <= 0 ||
>> +			pdata->clk_freq > 400000) {
>> +		dev_err(&pdev->dev, "clock frequency not supported\n");
> 
> Which freq? Should we add that freq value in the debug message?

I'll add that.  Thanks.

> 
>> +		ret = -EIO;
>> +		goto err_config_failed;
>> +	}
>> +
>> +	dev = kzalloc(sizeof(struct qup_i2c_dev), GFP_KERNEL);
>> +	if (!dev) {
>> +		ret = -ENOMEM;
>> +		goto err_alloc_dev_failed;
>> +	}
>> +
>> +	dev->dev = &pdev->dev;
>> +	if (in_irq)
>> +		dev->in_irq = in_irq->start;
>> +	if (out_irq)
>> +		dev->out_irq = out_irq->start;
>> +	dev->err_irq = err_irq->start;
>> +	if (in_irq && out_irq)
>> +		dev->num_irqs = 3;
>> +	else
>> +		dev->num_irqs = 1;
>> +	dev->clk = clk;
>> +	dev->pclk = pclk;
>> +	dev->base = ioremap(qup_mem->start, resource_size(qup_mem));
>> +	if (!dev->base) {
>> +		ret = -ENOMEM;
>> +		goto err_ioremap_failed;
>> +	}
>> +
>> +	/* Configure GSBI block to use I2C functionality */
>> +	dev->gsbi = ioremap(gsbi_mem->start, resource_size(gsbi_mem));
>> +	if (!dev->gsbi) {
>> +		ret = -ENOMEM;
>> +		goto err_gsbi_failed;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, dev);
>> +
>> +	dev->one_bit_t = USEC_PER_SEC/pdata->clk_freq;
>> +	dev->pdata = pdata;
>> +	dev->clk_ctl = 0;
>> +
>> +	/*
>> +	 * We use num_irqs to also indicate if we got 3 interrupts or just 1.
>> +	 * If we have just 1, we use err_irq as the general purpose irq
>> +	 * and handle the changes in ISR accordingly
>> +	 * Per Hardware guidelines, if we have 3 interrupts, they are always
>> +	 * edge triggering, and if we have 1, it's always level-triggering
>> +	 */
>> +	if (dev->num_irqs == 3) {
>> +		ret = request_irq(dev->in_irq, qup_i2c_interrupt,
>> +				IRQF_TRIGGER_RISING, "qup_in_intr", dev);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "request_in_irq failed\n");
>> +			goto err_request_irq_failed;
>> +		}
>> +		/*
>> +		 * We assume out_irq exists if in_irq does since platform
>> +		 * configuration either has 3 interrupts assigned to QUP or 1
>> +		 */
>> +		ret = request_irq(dev->out_irq, qup_i2c_interrupt,
>> +				IRQF_TRIGGER_RISING, "qup_out_intr", dev);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "request_out_irq failed\n");
>> +			free_irq(dev->in_irq, dev);
>> +			goto err_request_irq_failed;
>> +		}
>> +		ret = request_irq(dev->err_irq, qup_i2c_interrupt,
>> +				IRQF_TRIGGER_RISING, "qup_err_intr", dev);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "request_err_irq failed\n");
>> +			free_irq(dev->out_irq, dev);
>> +			free_irq(dev->in_irq, dev);
>> +			goto err_request_irq_failed;
>> +		}
>> +	} else {
>> +		ret = request_irq(dev->err_irq, qup_i2c_interrupt,
>> +				IRQF_TRIGGER_HIGH, "qup_err_intr", dev);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "request_err_irq failed\n");
>> +			goto err_request_irq_failed;
>> +		}
>> +	}
>> +	disable_irq(dev->err_irq);
>> +	if (dev->num_irqs == 3) {
>> +		disable_irq(dev->in_irq);
>> +		disable_irq(dev->out_irq);
>> +	}
>> +	i2c_set_adapdata(&dev->adapter, dev);
>> +	dev->adapter.algo = &qup_i2c_algo;
>> +	strlcpy(dev->adapter.name,
>> +		"QUP I2C adapter",
>> +		sizeof(dev->adapter.name));
>> +	dev->adapter.nr = pdev->id;
>> +	pdata->msm_i2c_config_gpio(dev->adapter.nr, 1);
> 
> Why there is no error check here? 

Currently the configuration function returns a void but I'll change that 
to return an error code and check for it here.

> ---Trilok Soni
> 


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
