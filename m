Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2HXCHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:07:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48430 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab2HXCHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:07:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1340793077-14300-1-git-send-email-jonghwa3.lee@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1340793077-14300-1-git-send-email-jonghwa3.lee@samsung.com>
Message-ID: <20120824020718.4547.991@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH v4] clock: max77686: Add driver for Maxim 77686 32KHz crystal
 oscillator
Date: Thu, 23 Aug 2012 19:07:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonghwa,

Quoting Jonghwa Lee (2012-06-27 03:31:17)
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/max77686.h>
> +#include <linux/mfd/max77686-private.h>
> +#include <linux/clk-private.h>

Please use clk-provider.h.  I don't see any reason for this code to need
clk-private.h.

> +#include <linux/mutex.h>
> +#include <linux/clkdev.h>
> +
> +#define        MAX77686_CLKS_NUM 3
> +
> +struct clk_max77686 {
> +       struct max77686_dev *iodev;
> +       u32 mask;
> +       struct clk_hw hw;
> +       struct clk_lookup *lookup;
> +};
> +
> +static struct clk_max77686 *get_max77686_clk(struct clk_hw *hw)
> +{
> +       return container_of(hw, struct clk_max77686, hw);
> +}
> +
> +static int max77686_clk_enable(struct clk_hw *hw)

Please rename this function to max77686_clk_prepare to reflect that is
is the .prepare callback.

> +{
> +       struct clk_max77686 *max77686;
> +       int ret;
> +
> +       max77686 = get_max77686_clk(hw);
> +       if (!max77686)
> +               return -ENOMEM;
> +
> +       ret = regmap_update_bits(max77686->iodev->regmap,
> +               MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
> +
> +       return ret;
> +}
> +
> +static void max77686_clk_disable(struct clk_hw *hw)

Please rename this function to max77686_clk_unprepare to reflect that is
is the .unprepare callback.

> +{
> +       struct clk_max77686 *max77686;
> +
> +       max77686 = get_max77686_clk(hw);
> +       if (!max77686)
> +               return;
> +
> +       regmap_update_bits(max77686->iodev->regmap,
> +               MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
> +}
> +
> +static int max77686_clk_is_enabled(struct clk_hw *hw)
> +{
> +       struct clk_max77686 *max77686;
> +       int ret;
> +       u32 val;
> +
> +       max77686 = get_max77686_clk(hw);
> +       if (!max77686)
> +               return -ENOMEM;
> +
> +       ret = regmap_read(max77686->iodev->regmap,
> +                               MAX77686_REG_32KHZ, &val);
> +
> +       if (ret < 0)
> +               return -EINVAL;
> +
> +       return val & max77686->mask;
> +}
> +
> +static struct clk_ops clk_max77686_ops = {
> +       .prepare        = max77686_clk_enable,
> +       .unprepare      = max77686_clk_disable,
> +       .is_enabled     = max77686_clk_is_enabled,
> +};
> +
> +static int max77686_clk_register(struct device *dev,
> +                               struct clk_max77686 *max77686, int clk_id)
> +{
> +       char clk_name[][10] = {"32khap", "32kcp", "p32kh"};

const?

> +       struct clk *clk;
> +
> +       clk = clk_register(dev, clk_name[clk_id], &clk_max77686_ops,
> +                               &max77686->hw, NULL, 0, CLK_IS_ROOT);
> +
> +       if (IS_ERR(clk))
> +               return -ENOMEM;
> +
> +       max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
> +                                       GFP_KERNEL);
> +       if (IS_ERR(max77686->lookup))
> +               return -ENOMEM;
> +
> +       max77686->lookup->con_id = clk_name[clk_id];
> +       max77686->lookup->clk = clk;
> +
> +       clkdev_add(max77686->lookup);
> +
> +       return 0;
> +}
> +
> +static __devinit int max77686_clk_probe(struct platform_device *pdev)
> +{
> +       struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +       struct clk_max77686 *max77686[MAX77686_CLKS_NUM];
> +       int i, ret;
> +
> +       for (i = 0; i < MAX77686_CLKS_NUM; i++) {
> +               max77686[i] = devm_kzalloc(&pdev->dev,
> +                                sizeof(struct clk_max77686), GFP_KERNEL);
> +               if (!max77686[i])
> +                       return -ENOMEM;
> +
> +               max77686[i]->iodev = iodev;
> +               max77686[i]->mask = 1 << i;
> +
> +               ret = max77686_clk_register(&pdev->dev, max77686[i], i);
> +               if (ret) {
> +                       dev_err(&pdev->dev, "Fail to register clock\n");
> +                       return ret;
> +               }

There is a memory leak if you successfully register any clocks and then
fail to register the others.  Be sure to unwind the loop and kfree those
clocks in such a case (since this appears fatal).

You only have three clocks, so I think the loop could be completely
replaced with an array and three calls to clk_register and clkdev_add
(each).

Regards,
Mike
