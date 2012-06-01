Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371Ab2FAQNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:13:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54612 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301Ab2FAQNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:13:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH] clock: max77686: Add driver for Maxim 77686 32KHz crystal oscillator
Date: Fri, 1 Jun 2012 16:13:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        H Hartley Sweeten <hsweetn@visionengravers.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1338541736-2978-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1338541736-2978-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206011613.33706.arnd@arndb.de>
X-Provags-ID: V02:K0:L+sWXrEhmNKVQxMnlZb4+/KcfRpDo68J2iiRI4OdSPN
 vMBxsu4kkRXsWMmKzpUo9m7e409+WGfiupgdhpBSLfoP8D3va6
 aQXS7K9NUqzdYNy2A/20Iqirr4xDISXXAI4z54O1DkiBlUC7On
 AY6Xp///i0mhAsLWwxRi7N5z0JfzRSTqIzXaj31Skqm7FfFlqi
 nV3oY623hfbSLU1TcEIDKIq2K2vOebEslWoxrdGdXHt6raTSXB
 vsnwn7cu14GnM34wwoXe5RZX0WtFjXbCf5Rjio6ALkkglICoy+
 48qlM3wgdWXq1HXzKwkJv9Sf7hl3dXAOpEEosPB5SmIk0nxr+y
 qbhbNr/PQeaClxzbPh9Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2012, Jonghwa Lee wrote:
> +
> +#ifdef COMMON_CONFIG_CLK

Two comments on this one:

1. It should be CONFIG_COMMON_CLK, not COMMON_CONFIG_CLK, I suppose. The symbol
you are testing for is never defined so your code does not even get built.
I suppose you did not test the version you are sending ...

2. There is no use in enclosing an entire file in #ifdef. Instead, make the Kconfig
symbol depend on COMMON_CLK.

> +#define to_max77686_clk(__name)		container_of(hw,		\
> +					struct max77686_clk, __name)

This use of container_of() is very unusual and confusing, because the argument
into your macro is the member of the struct, not the variable that you are basing
from. You should not need the macro at all, so please try to remove it.

> +struct max77686_clk {
> +	struct max77686_dev *iodev;
> +	struct clk_hw clk32khz_ap_hw;
> +	struct clk_hw clk32khz_cp_hw;
> +	struct clk_hw clk32khz_pmic_hw;
> +};
> +
> +static struct clk *clk32khz_ap;
> +static struct clk *clk32khz_cp;
> +static struct clk *clk32khz_pmic;
> +static char *max77686_clk[] = {
> +	"32khap",
> +	"32khcp",
> +	"p32kh",
> +};

With these static definitions, you can only have a single max77686 device in the
system. Better remove these symbols.

> +static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
> +{
> +	struct clk *clk = hw->clk;
> +	if (clk == clk32khz_ap)
> +		return to_max77686_clk(clk32khz_ap_hw);
> +	else if (clk == clk32khz_cp)
> +		return to_max77686_clk(clk32khz_cp_hw);
> +	else if (clk == clk32khz_pmic)
> +		return to_max77686_clk(clk32khz_pmic_hw);
> +	else
> +		return NULL;
> +}

I can only assume that you meant this to be

struct max77686_clk {
	struct max77686_dev *iodev;
	u32 mask;
	struct clk_hw hw;
};
static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
{
	return container_of(hw, struct max77686_clk, hw)->iodev;
}

You probably misunderstood the person who was suggesting you use
container_of(). Note that this function is so simple that you
probably don't even need it: just open-code the container_of.

> +static const struct platform_device_id max77686_clk_id[] = {
> +	{ "max77686-clk", 0},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, max77686_clk_id);
> +
> +static struct platform_driver max77686_clk_driver = {
> +	.driver = {
> +		.name  = "max77686-clk",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = max77686_clk_probe,
> +	.remove = __devexit_p(max77686_clk_remove),
> +	.id_table = max77686_clk_id,
> +};

You should also have an of_device_id table so you can match this driver from
device tree definitions.

	Arnd
