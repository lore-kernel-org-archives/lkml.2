Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0KXAod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:44:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62997 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0KXAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:44:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6176"; a="64098677"
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1011231456380.17082@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org>
	 <1290109970-26752-2-git-send-email-gbean@codeaurora.org>
	 <1290534717.4165.43.camel@m0nster>
	 <alpine.DEB.2.00.1011231456380.17082@gbean-linux.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 16:44:31 -0800
Message-ID: <1290559471.4165.85.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 15:08 -0800, Gregory Bean wrote:
> >> +static inline void set_gpio_bits(unsigned n, void __iomem *reg)
> >> +{
> >> +	writel(readl(reg) | n, reg);
> >> +}
> >> +
> >> +static inline void clr_gpio_bits(unsigned n, void __iomem *reg)
> >> +{
> >> +	writel(readl(reg) & ~n, reg);
> >> +}
> >
> > It seems these functions actually accept output from BIT(). It would be
> > safer to force these to accept the bit number then use BIT() inside this
> > function to translate. That way you wouldn't use "unsigned n" for the
> > argument you would use a named enum for the argument.
> 
> I don't think that will work well, because there are cases where we want
> to set or clear more than one bit at a time.  Making these functions
> take a bit number as an argument would restrict them to setting or clearing
> only one bit at a time, forcing users to call them multiple times to set
> or clear more than one bit, meaning lots of readl & writel calls for
> compount bit-changes.

How often will you do the multiple bit changes tho?

> >> +static struct msm_gpio_dev msm_gpio = {
> >> +	.gpio_chip = {
> >> +		.base             = 0,
> >
> > I guess it's fine to do "offset - chip->base" if base is always zero,
> > but why do subtraction at all.
> 
> If the chip is ever moved, not accounting for the base would produce an error.
> I know that 'speculative coding' is frowned upon, but isn't removing an 
> addition (as you pointed out, the subtraction is a bug) because this instance
> of the chip is at offset zero a little over the top?

Up to you what to do here ..  I don't care if you have it be redundant
addition, you might want to comment on it tho.

> >> +	set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
> >
> > I's just break this into two calls, or make another helper that to set
> > that accepts the mask and have set_gpio_bits call that. This here you
> > would just use the other helper. like set_gpio_bits calls
> > set_gpio_bits_mask() and you call the mask version here.
> 
> Why make two readl/writel call pairs, or have one version of a helper which
> can set a single bit and another version which can set more than one
> at a time?  That seems really complicated.

The benefit is that you would have type checking on the values sent in.
You would get that from using the enum to define the argument. With just
using unsigned int you can send in any value you want (even invalid
ones).

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


