Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2HXIMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:12:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23826 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2HXIMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:12:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d00000476a-bc-5037376d5412
Message-id: <5037376A.9000507@samsung.com>
Date: Fri, 24 Aug 2012 17:12:26 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: jonghwa3.lee@samsung.com
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
References: <1340793077-14300-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120824020718.4547.991@nucleus> <5037318E.2040903@samsung.com>
In-reply-to: <5037318E.2040903@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jQd1cc/MAg/tnxC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrs+r2QsmCFYs/P6LvYHxPHcXIyeHhICJxLzPD9kgbDGJC/fW
	A9lcHEIC0xklnk5+ywyS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9R3MUk8PLyY
	HaJeS6J1+wmwXhYBVYn1e2ewgthsAnISb5u+MYLMERWIkPjVzwESFhGQkVh59ScTyBxmga+M
	EifebWUFqREWiJN4dUwRYn43o8T6dR1gh3IKaEvM2LeWZQKjwCwk581COG8WkvMWMDKvYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAgOv2fSOxhXNVgcYhTgYFTi4d3RYhYgxJpYVlyZe4hR
	goNZSYR3/mOgEG9KYmVValF+fFFpTmrxIUZpDhYlcV7+PsMAIYH0xJLU7NTUgtQimCwTB6dU
	A+P0KStklSYEnNhzl9Hkv2LOlw1+4RsX6c3lk92z5NIGnuXPU7cZmOd7+j2c9jAjwDHr24mZ
	r+7tdpeROtz3cu+ukIMLpfsS57XF7L5z1YHhm8u9xIsfTq7un/N2m/GfKfoynOvXLGG0/v/v
	u5LtBYUlW+tmlOw+43j2fsIN+TrxVGHGBxtnZ4trK7EUZyQaajEXFScCAMMV4Do7AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 08월 24일 16:47, jonghwa3.lee@samsung.com wrote:
> On 2012년 08월 24일 11:07, Mike Turquette wrote:
>>> +       struct clk *clk;
>>> +
>>> +       clk = clk_register(dev, clk_name[clk_id], &clk_max77686_ops,
>>> +                               &max77686->hw, NULL, 0, CLK_IS_ROOT);
>>> +
>>> +       if (IS_ERR(clk))
>>> +               return -ENOMEM;
>>> +
>>> +       max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
>>> +                                       GFP_KERNEL);
>>> +       if (IS_ERR(max77686->lookup))
>>> +               return -ENOMEM;
>>> +
>>> +       max77686->lookup->con_id = clk_name[clk_id];
>>> +       max77686->lookup->clk = clk;
>>> +
>>> +       clkdev_add(max77686->lookup);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static __devinit int max77686_clk_probe(struct platform_device *pdev)
>>> +{
>>> +       struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>>> +       struct clk_max77686 *max77686[MAX77686_CLKS_NUM];
>>> +       int i, ret;
>>> +
>>> +       for (i = 0; i < MAX77686_CLKS_NUM; i++) {
>>> +               max77686[i] = devm_kzalloc(&pdev->dev,
>>> +                                sizeof(struct clk_max77686), GFP_KERNEL);
>>> +               if (!max77686[i])
>>> +                       return -ENOMEM;
>>> +
>>> +               max77686[i]->iodev = iodev;
>>> +               max77686[i]->mask = 1 << i;
>>> +
>>> +               ret = max77686_clk_register(&pdev->dev, max77686[i], i);
>>> +               if (ret) {
>>> +                       dev_err(&pdev->dev, "Fail to register clock\n");
>>> +                       return ret;
>>> +               }
>> There is a memory leak if you successfully register any clocks and then
>> fail to register the others.  Be sure to unwind the loop and kfree those
>> clocks in such a case (since this appears fatal).
> I think it'll free memory allocation automatically, because It is used
> devm_kzalloc. Am I wrong?
>
>
Sorry, I misunderstood. Yes, you're right. Since clk has been allocated
with kzalloc it would be released for the failing.
Thanks for advisement. I'll fix it.

Thanks.

