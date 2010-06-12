Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0FLFhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:37:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0FLFhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:37:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44228421"
Message-ID: <4C131D0E.60109@codeaurora.org>
Date: Fri, 11 Jun 2010 22:37:18 -0700
From: Gregory Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: akpm@linux-foundation.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/2] gpio: msm7200a: Add gpiolib support for MSM chips.
References: <1276286332-13515-1-git-send-email-gbean@codeaurora.org> <1276286332-13515-2-git-send-email-gbean@codeaurora.org> <20100612021252.GB31045@fluff.org.uk>
In-Reply-To: <20100612021252.GB31045@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not put this under arch/arm?

Is there an appropriate place for loadable device drivers under 
arch/arm?  I don't know of one.

>> +static inline void set_gpio_bit(unsigned n, void __iomem *reg)
>> +{
>> +	writel(readl(reg) | bit(n), reg);
>> +}
>> +
>> +/*
>> + * This function assumes that msm_gpio_dev::lock is held.
>> + */
>> +static inline void clr_gpio_bit(unsigned n, void __iomem *reg)
>> +{
>> +	writel(readl(reg)&  ~bit(n), reg);
>> +}
>> +
>> +/*
>> + * This function assumes that msm_gpio_dev::lock is held.
>> + */
>> +static inline void
>> +msm_gpio_write(struct msm_gpio_dev *dev, unsigned n, unsigned on)
>> +{
>> +	if (on)
>> +		set_gpio_bit(n, dev->regs.out);
>> +	else
>> +		clr_gpio_bit(n, dev->regs.out);
>> +}
>
> wouldn't it be easier to inline a set_to function and just role the
> set and clr bit functions into it, since they pretty much do the
> same thing. even better, on arm the code won't require a branch.

I'm not sure I understand you.  Can you clarify?  set_ and clr_gpio_bit 
are used in more places than just here, so they can't just be rolled 
into msm_gpio_write and disappear.

>> +static int msm_gpio_remove(struct platform_device *dev)
>> +{
>> +	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(dev);
>> +	int ret = gpiochip_remove(&msm_gpio->gpio_chip);
>> +
>> +	if (ret == 0)
>> +		kfree(msm_gpio);
>
> hmm, not sure if you really need to check the result here before
> kfrree() the memory.

I feel that this is important.  If any clients are still holding gpio 
lines, gpiochip_remove will fail.  In those circumstances, is it not 
important that the device not be freed (which would leave clients with 
stale references) and that the remove call return a proper failure code?
--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
