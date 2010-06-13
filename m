Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0FMFa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 01:30:26 -0400
Received: from trinity.fluff.org ([89.16.178.74]:57622 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0FMFaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 01:30:25 -0400
Date: Sun, 13 Jun 2010 06:30:15 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: Ben Dooks <ben-linux@fluff.org>, akpm@linux-foundation.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/2] gpio: msm7200a: Add gpiolib support for MSM chips.
Message-ID: <20100613053015.GL3498@trinity.fluff.org>
References: <1276286332-13515-1-git-send-email-gbean@codeaurora.org> <1276286332-13515-2-git-send-email-gbean@codeaurora.org> <20100612021252.GB31045@fluff.org.uk> <4C131D0E.60109@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C131D0E.60109@codeaurora.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:37:18PM -0700, Gregory Bean wrote:
>> Why not put this under arch/arm?
>
> Is there an appropriate place for loadable device drivers under  
> arch/arm?  I don't know of one.
>
>>> +static inline void set_gpio_bit(unsigned n, void __iomem *reg)
>>> +{
>>> +	writel(readl(reg) | bit(n), reg);
>>> +}
>>> +
>>> +/*
>>> + * This function assumes that msm_gpio_dev::lock is held.
>>> + */
>>> +static inline void clr_gpio_bit(unsigned n, void __iomem *reg)
>>> +{
>>> +	writel(readl(reg)&  ~bit(n), reg);
>>> +}
>>> +
>>> +/*
>>> + * This function assumes that msm_gpio_dev::lock is held.
>>> + */
>>> +static inline void
>>> +msm_gpio_write(struct msm_gpio_dev *dev, unsigned n, unsigned on)
>>> +{
>>> +	if (on)
>>> +		set_gpio_bit(n, dev->regs.out);
>>> +	else
>>> +		clr_gpio_bit(n, dev->regs.out);
>>> +}
>>
>> wouldn't it be easier to inline a set_to function and just role the
>> set and clr bit functions into it, since they pretty much do the
>> same thing. even better, on arm the code won't require a branch.
>
> I'm not sure I understand you.  Can you clarify?  set_ and clr_gpio_bit  
> are used in more places than just here, so they can't just be rolled  
> into msm_gpio_write and disappear.

Hmm, thought the compiler was clever enough to inline and sort that
out, I'll have a check later into whether this is true or not for
a few versions of gcc.

>>> +static int msm_gpio_remove(struct platform_device *dev)
>>> +{
>>> +	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(dev);
>>> +	int ret = gpiochip_remove(&msm_gpio->gpio_chip);
>>> +
>>> +	if (ret == 0)
>>> +		kfree(msm_gpio);
>>
>> hmm, not sure if you really need to check the result here before
>> kfrree() the memory.
>
> I feel that this is important.  If any clients are still holding gpio  
> lines, gpiochip_remove will fail.  In those circumstances, is it not  
> important that the device not be freed (which would leave clients with  
> stale references) and that the remove call return a proper failure code?

Right, confused holding onto the module to holding onto the device too.

Maybe devices should be refcounted too so that holding an open gpio on
via the driver would force the driver core to refuse to remove the device.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

