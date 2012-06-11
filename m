Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2FKP0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:26:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab2FKPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH v3] clock: max77686: Add driver for Maxim 77686 32KHz crystal oscillator
Date: Mon, 11 Jun 2012 15:25:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111525.34451.arnd@arndb.de>
X-Provags-ID: V02:K0:k9ZEyL98/iYDHdDIK5DxaR3Zogayb4q5Huc8TPOZ3U/
 jbeHGHAcC4sLW36/I0glXstNS7DUVFGOsp5O01Ti94IIVXmVLy
 fUxghX8taS0Fesm8aQn9iP6BB8BKhGnWMAD1t6Tf4LU+dczXDG
 6Iq9Lpwd9UfcKfdfk8A8L6YK/6gTIBhial6Fa39d2xYuja8kUn
 HxvlqcPv7YqKoesLR1liYrLPbTbfLPJKPSLQmLe9PSKKMHw2my
 n8R2I3LuNzrr32Ly+e92giErpdSwgbW/tSqRsyNMIgRVI0EfwF
 CSTPx8cb3k7YnrMkUoqXK3PIUqTU92XGO2GHdjOHinuZO+8rPP
 0GlahRcicqXrsLbsF2uE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Jonghwa Lee wrote:
> Maxim 77686 has three 32KHz clock outputs through the its crystal oscillator.
> This driver can control those ouputs by I2C bus. The clocks are used to supply
> to SOC and peripheral chips as a clock source. Clocks can be enabled/disabled only.
> It uses regmap interface to communicate with I2C bus.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Thanks for fixing the issues pointed out in my first review, it
looks much better now.

> +struct clk *clk32khz_ap;
> +struct clk *clk32khz_cp;
> +struct clk *clk32khz_pmic;

As Felipe pointed out, you should not have global pointers
for these, not even static ones.

I think it's best if you use platform_set_drvdata() to attach
the array with the three max77686_clk structures to the platform
device.

> +char *max77686_clks[] = {
> +	"32khap",
> +	"32khcp",
> +	"p32kh",
> +};

These can just be open-coded in the place where the strings
are used, there is no need to have a separate symbol for them.

> +static __devinit int max77686_clk_probe(struct platform_device *pdev)
> +{
> +	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +	struct max77686_clk *max77686[MAX77686_CLKS_NUM];
> +	int i, ret;
> +
> +	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
> +		max77686[i] = devm_kzalloc(&pdev->dev,
> +				 sizeof(struct max77686_clk), GFP_KERNEL);
> +		if (!max77686[i])
> +			return -ENOMEM;
> +
> +		max77686[i]->iodev = iodev;
> +		max77686[i]->mask = 1 << i;
> +		mutex_init(&max77686[i]->mutex);
> +	}
> +
> +
> +	clk32khz_ap = clk_register(&pdev->dev, max77686_clks[MAX77686_32KH_AP],
> +				&max77686_clk_ops,
> +				&max77686[MAX77686_32KH_AP]->hw,
> +				NULL, 0, CLK_IS_ROOT);
> +	if (IS_ERR(clk32khz_ap)) {
> +		ret = PTR_ERR(clk32khz_ap);
> +		goto err;
> +	}
> +
> +	clk32khz_cp = clk_register(&pdev->dev, max77686_clks[MAX77686_32KH_CP],
> +				&max77686_clk_ops,
> +				&max77686[MAX77686_32KH_CP]->hw,
> +				NULL, 0, CLK_IS_ROOT);
> +	if (IS_ERR(clk32khz_cp)) {
> +		ret = PTR_ERR(clk32khz_cp);
> +		goto err;
> +	}
> +
> +	clk32khz_pmic = clk_register(&pdev->dev, max77686_clks[MAX77686_P32KH],
> +				&max77686_clk_ops,
> +				&max77686[MAX77686_P32KH]->hw,
> +				NULL, 0, CLK_IS_ROOT);
> +	if (IS_ERR(clk32khz_pmic)) {
> +		ret = PTR_ERR(clk32khz_pmic);
> +		goto err;
> +	}

Note that the prototype for clk_register has changed recently, so this
will have to be rewritten. It might simplify the code if you pull the call
to clk_register into the loop, and add a helper function for the loop body,
like

	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
		ret = max77686_clk_register(&pdev->dev, iodev, i);
		if (ret) {
			max77686_clk_remove(pdev);
			return ret;
		}
	}

> +static int __devexit max77686_clk_remove(struct platform_device *pdev)
> +{
> +	kfree(clk32khz_ap);
> +	kfree(clk32khz_cp);
> +	kfree(clk32khz_pmic);
> +	return 0;
> +}

As Mark mentioned, the kfree is not necessary, but the clk_unregister
is missing here and in the error path of the probe function.

	Arnd
