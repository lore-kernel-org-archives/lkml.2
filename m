Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2HXHre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:47:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9553 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2HXHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:47:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fc66d0000043b7-ed-50373191253c
Message-id: <5037318E.2040903@samsung.com>
Date: Fri, 24 Aug 2012 16:47:26 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Mike Turquette <mturquette@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
References: <1340793077-14300-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120824020718.4547.991@nucleus>
In-reply-to: <20120824020718.4547.991@nucleus>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd2JhuYBBjs2ylhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MxZcesRY80qy4fecmYwPjXtkuRk4OCQETif8LHjFB2GISF+6t
	Z+ti5OIQEpjOKLF63lpGkASvgKDEj8n3WLoYOTiYBeQljlzKBgkzC6hLTJq3iBmivotJ4u2T
	71D1WhJND1rZQWwWAVWJpd9XgcXZBOQk3jZ9YwSZIyoQIfGrnwMkLAJUvu1AK9heZoGvjBKP
	v9wBqxEWiJN4dUwRpEZIIEdicsMvsDGcAnoSu/efY5nAKDALyXWzEK6bheS6BYzMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCg++Z1A7GlQ0WhxgFOBiVeHh3tJgFCLEmlhVX5h5ilOBg
	VhLhnf8YKMSbklhZlVqUH19UmpNafIhRmoNFSZyXv88wQEggPbEkNTs1tSC1CCbLxMEp1cDo
	otViv7E6qzz+VoPgzcOuz4Q0Y35dWuqevc1jh4D4vLKDm4UUFu97HcMf+XWh27Vn6cofLOoO
	i6svEyrZV3Qu9WDaOZnOG2ut+9q3sOsUuWrM48rWLIvW/LtPS/rH9hXLbnM9tNHXne+nf2hJ
	xNy8xzedmQxnrRJoXlRzKFF3GUeXtt2/p2pKLMUZiYZazEXFiQBI6oevOgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 2012년 08월 24일 11:07, Mike Turquette wrote:
> Hello Jonghwa,
>
> Quoting Jonghwa Lee (2012-06-27 03:31:17)
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mfd/max77686.h>
>> +#include <linux/mfd/max77686-private.h>
>> +#include <linux/clk-private.h>
> Please use clk-provider.h.  I don't see any reason for this code to need
> clk-private.h.
Yes, you're right. I missed to change it. I'll update it.
>> +#include <linux/mutex.h>
>> +#include <linux/clkdev.h>
>> +
>> +#define        MAX77686_CLKS_NUM 3
>> +
>> +struct clk_max77686 {
>> +       struct max77686_dev *iodev;
>> +       u32 mask;
>> +       struct clk_hw hw;
>> +       struct clk_lookup *lookup;
>> +};
>> +
>> +static struct clk_max77686 *get_max77686_clk(struct clk_hw *hw)
>> +{
>> +       return container_of(hw, struct clk_max77686, hw);
>> +}
>> +
>> +static int max77686_clk_enable(struct clk_hw *hw)
> Please rename this function to max77686_clk_prepare to reflect that is
> is the .prepare callback.
Okay.
>> +{
>> +       struct clk_max77686 *max77686;
>> +       int ret;
>> +
>> +       max77686 = get_max77686_clk(hw);
>> +       if (!max77686)
>> +               return -ENOMEM;
>> +
>> +       ret = regmap_update_bits(max77686->iodev->regmap,
>> +               MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
>> +
>> +       return ret;
>> +}
>> +
>> +static void max77686_clk_disable(struct clk_hw *hw)
> Please rename this function to max77686_clk_unprepare to reflect that is
> is the .unprepare callback.

Okay.

>> +{
>> +       struct clk_max77686 *max77686;
>> +
>> +       max77686 = get_max77686_clk(hw);
>> +       if (!max77686)
>> +               return;
>> +
>> +       regmap_update_bits(max77686->iodev->regmap,
>> +               MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
>> +}
>> +
>> +static int max77686_clk_is_enabled(struct clk_hw *hw)
>> +{
>> +       struct clk_max77686 *max77686;
>> +       int ret;
>> +       u32 val;
>> +
>> +       max77686 = get_max77686_clk(hw);
>> +       if (!max77686)
>> +               return -ENOMEM;
>> +
>> +       ret = regmap_read(max77686->iodev->regmap,
>> +                               MAX77686_REG_32KHZ, &val);
>> +
>> +       if (ret < 0)
>> +               return -EINVAL;
>> +
>> +       return val & max77686->mask;
>> +}
>> +
>> +static struct clk_ops clk_max77686_ops = {
>> +       .prepare        = max77686_clk_enable,
>> +       .unprepare      = max77686_clk_disable,
>> +       .is_enabled     = max77686_clk_is_enabled,
>> +};
>> +
>> +static int max77686_clk_register(struct device *dev,
>> +                               struct clk_max77686 *max77686, int clk_id)
>> +{
>> +       char clk_name[][10] = {"32khap", "32kcp", "p32kh"};
> const?

Okay, I agree that it is better to change definition into const.
>
>> +       struct clk *clk;
>> +
>> +       clk = clk_register(dev, clk_name[clk_id], &clk_max77686_ops,
>> +                               &max77686->hw, NULL, 0, CLK_IS_ROOT);
>> +
>> +       if (IS_ERR(clk))
>> +               return -ENOMEM;
>> +
>> +       max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
>> +                                       GFP_KERNEL);
>> +       if (IS_ERR(max77686->lookup))
>> +               return -ENOMEM;
>> +
>> +       max77686->lookup->con_id = clk_name[clk_id];
>> +       max77686->lookup->clk = clk;
>> +
>> +       clkdev_add(max77686->lookup);
>> +
>> +       return 0;
>> +}
>> +
>> +static __devinit int max77686_clk_probe(struct platform_device *pdev)
>> +{
>> +       struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>> +       struct clk_max77686 *max77686[MAX77686_CLKS_NUM];
>> +       int i, ret;
>> +
>> +       for (i = 0; i < MAX77686_CLKS_NUM; i++) {
>> +               max77686[i] = devm_kzalloc(&pdev->dev,
>> +                                sizeof(struct clk_max77686), GFP_KERNEL);
>> +               if (!max77686[i])
>> +                       return -ENOMEM;
>> +
>> +               max77686[i]->iodev = iodev;
>> +               max77686[i]->mask = 1 << i;
>> +
>> +               ret = max77686_clk_register(&pdev->dev, max77686[i], i);
>> +               if (ret) {
>> +                       dev_err(&pdev->dev, "Fail to register clock\n");
>> +                       return ret;
>> +               }
> There is a memory leak if you successfully register any clocks and then
> fail to register the others.  Be sure to unwind the loop and kfree those
> clocks in such a case (since this appears fatal).
I think it'll free memory allocation automatically, because It is used
devm_kzalloc. Am I wrong?

> You only have three clocks, so I think the loop could be completely
> replaced with an array and three calls to clk_register and clkdev_add
> (each).

Okay, I'll consider it.

Thanks and Best regard.
> Regards,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

