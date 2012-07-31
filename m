Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2GaSN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:13:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2GaSN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:13:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH 1/5] clk: mmp: add mmp specific clocks
Date: Tue, 31 Jul 2012 11:47:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1343716792-10399-1-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1343716792-10399-1-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207311147.25862.arnd@arndb.de>
X-Provags-ID: V02:K0:ZqZPqKKKkmYaCnRk5J5ETUA4WHPArjIhsBohv+LxKaj
 HbtWOFoCTVaSP2v7ZtOllwp5tHibCKsPBjuYK7iQZrsu+cwm/n
 GVptmKwjxC/vPZz5V1b8BwxZzSt2JLISEtotXoXaJMH5RO5lOP
 eQLP7EspCL6DF9xOboZZpJKjY9CEpfmxUM8PlusEz45Gd0X1BI
 rE+bX9eZrCJFabd53ZIivnixYrAj56WtW+IqaE+BbxWZCySkKp
 q9mCPxJr/4wPW7KVMZTneX9pEc4RAoBB985g5meJWwyrZ0Reqv
 qlgqsr8NpyQ/8reYxz0/FcEQtXUuvP1WyVKV7UJdx6i0DOtBtz
 ms9RXmJDtVajA0wyXnOs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Chao Xie wrote:
> +static int clk_apbc_prepare(struct clk_hw *hw)
> +{
> +	struct clk_apbc *apbc = to_clk_apbc(hw);
> +	unsigned int data;
> +	unsigned long flags = 0;
> +
> +	/*
> +	 * It may share same register as MUX clock,
> +	 * and it will impact FNCLK enable. Spinlock is needed
> +	 */
> +	if (apbc->lock)
> +		spin_lock_irqsave(apbc->lock, flags);
> +
> +	data = __raw_readl(apbc->base);
> +	if (apbc->flags & APBC_POWER_CTRL)
> +		data |= APBC_POWER;
> +	data |= APBC_FNCLK;
> +	__raw_writel(data, apbc->base);

Better use readl_relaxed() in device drivers rather than __raw_readl().

> +#define MPMU_PLL2CR		MPMU_REG(0x0034)
> +#define MPMU_PLL2_CTRL1		MPMU_REG(0x0414)

In a device driver like this, don't hardcode the MMIO register addresses. Instead,
use ioremap or of_iomap to get a virtual address from a resource or a DT
property that gets passed.

> +static int clk_pll2_prepare(struct clk_hw *hw)
> +{
> +	unsigned long data;
> +
> +	data = __raw_readl(MPMU_PLL2CR);
> +	if (data & (1 << 8))
> +		return 0;
> +	data |= (1 << 8);
> +	__raw_writel(data, MPMU_PLL2CR);
> +
> +	udelay(500);
> +
> +	if (cpu_is_mmp2()) {
> +		/* out of reset */
> +		data = __raw_readl(MPMU_PLL2_CTRL1);
> +		data |= (1 << 29);
> +		__raw_writel(data, MPMU_PLL2CR);
> +
> +		udelay(500);
> +	}
> +
> +	return 0;
> +}

500 microsends is a long time to waste. Can you do an msleep(1)
instead so the CPU is allowed to sleep here?

The cpu_is_mmp2() check here looks a bit clumsy. I think you're
better off making this two separate functions like

static int pxa_clk_pll2_prepare(struct clk_hw *hw)
{
	unsigned long data;

	data = __raw_readl(MPMU_PLL2CR);
	if (data & (1 << 8))
		return 0;
	data |= (1 << 8);
	__raw_writel(data, MPMU_PLL2CR);

	udelay(500);
	return 0;
}

static int mmp2_clk_pll2_prepare(struct clk_hw *hw)
{
	unsigned long data;

	pxa_clk_pll2_prepare(hw);

	/* out of reset */
	data = __raw_readl(MPMU_PLL2_CTRL1);
	data |= (1 << 29);
	__raw_writel(data, MPMU_PLL2CR);
	udelay(500);
	return 0;
}

and then using two separate clk_ops structures but picking the one
you need based on the chip.

> +#define MMP_CLK_REGISTER_FIXED_RATE(_clk, _name, _rate)			\
> +	do {								\
> +		_clk[_name] = clk_register_fixed_rate(NULL, #_name,	\
> +					NULL, CLK_IS_ROOT, _rate);	\
> +		clk_register_clkdev(_clk[_name], #_name, NULL);		\
> +	} while (0)
> +
> +#define MMP_CLK_REGISTER_FIXED_FACTOR(_clk, _name, _parent, _flags,	\
> +				_mul, _div)				\
> +	do {								\
> +		_clk[_name] = clk_register_fixed_factor(NULL, #_name,	\
> +				 #_parent, _flags, _mul, _div);		\
> +		clk_register_clkdev(_clk[_name], #_name, NULL);		\
> +	} while (0)

I very much dislike macros like these that don't add much value in terms of
shortening the code, but at the same time make the code much harder to read
by someone who is looking over all clock drivers. Better just open-code
all of the call sites of this.

	Arnd

