Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1F2Lh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:37:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1F2LhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:37:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 2/2] pwm: Add a i.MX23/28 pwm driver
Date: Wed, 29 Jun 2011 13:37:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Matthias Kaehlcke <matthias@kaehlcke.net>,
        Lothar =?iso-8859-15?q?Wa=DFmann?= <LW@karo-electronics.de>
References: <1309338215-10702-1-git-send-email-s.hauer@pengutronix.de> <1309338215-10702-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1309338215-10702-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291337.15336.arnd@arndb.de>
X-Provags-ID: V02:K0:5Fy3fRpJuz1nVOJykjOGkPlvaUNgdrlymv5bY/JybeD
 gMySx1p3aIPC6GrnQ1czegYplLSLW2LWc7osHE8pP7HtvmFuWV
 vpf1//QUAFvgzZ+8fpksFxNPjHccjHnVLQNF0cecv3E3QDkjwx
 +kRnBVht1nJaWvniXEBr2wS/tHRbFK58qglXE1u8xtJGk0Z6Tl
 xeFTUjl1sWfhXRprTx9mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011, Sascha Hauer wrote:
> +/*
> + * each pwm has a separate register space but all share a common
> + * enable register.
> + */
> +static int mxs_pwm_common_get(struct platform_device *pdev)
> +{
> +       struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       resource_size_t start = r->start & ~0xfff;
> +       int ret = 0;
> +
> +       if (!num_instances) {
> +               r = request_mem_region(start, 0x10, "mxs-pwm-common");
> +               if (!r)
> +                       goto err_request;

Yes, this looks better than the original approach, but it still feels
a bit awkward: 

You are requesting a region outside of the platform device resource.
This will cause problems with the device tree conversion, where the
idea is to list all registers that are used for each device.
It also becomes a problem if a system has multiple PWM regions
that are a page long each -- you only map one of them currently,
so the first one would win.

When you model the pwm device in the device tree, the most logical
representation IMHO would be to have a nested device, like:

/amba/pwm_core@0fa0000/pwm@0
                      /pwm@1
                      /pwm@2

The pwm_core then has the MMIO registers and provides an interface
for the individual pwms to access the registers, like an MFD
device. The resources for the slave devices are not MMIO ranges
but simply offsets. The pwm_enable function will then do something
like 

static void __pwm_enable(struct mxs_pwm_device *pwm, int enable)
{
	struct device *parent = &pwm->chip.dev.parent->parent;
	void __iomem *pwm_base_common = dev_get_drvdata(parent);

        if (enable)
                reg = pwm_base_common + REG_PWM_CTRL_SET;
        else
                reg = pwm_base_common + REG_PWM_CTRL_CLEAR;
 
        writel(PWM_ENABLE(pwm->chip.pwm_id), reg);
}

The pwm driver obviously has to register for both device types,
the parent and the child, and do different things in the two
cases, e.g.

static int __devinit mxs_pwm_probe(struct platform_device *pdev)
{
	switch (pdev->id_entry->driver_data) {
	case MXS_PWM_MASTER:
		return mxs_pwm_map_master_resources(pdev);
	case MXS_PWM_SLAVE:
		return mxs_pwm_register_pwmchip(pdev, to_platform_device(pdev->dev.parent));
	}
	return -ENODEV;
}

I'm normally not that picky, but I think we should have the best
possible solution for this in the mx23 driver, because it will
likely be used as an example for other drivers that have the
same problem.

	Arnd
