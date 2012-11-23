Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2KWJIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:08:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59142 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2KWJIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:08:38 -0500
MIME-Version: 1.0
In-Reply-To: <1352188034-9982-1-git-send-email-qingx@marvell.com>
References: <1352188034-9982-1-git-send-email-qingx@marvell.com>
Date: Fri, 23 Nov 2012 17:08:37 +0800
Message-ID: <CAN1soZw5RDN+wRacR1YTMqQfy5SNAg_KzGDt+77846M8Qk_7sw@mail.gmail.com>
Subject: Re: [PATCH 6/7] mfd: max8925: support dt for backlight
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, cxie4@marvell.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 3:47 PM, Qing Xu <qingx@marvell.com> wrote:
> From: Qing Xu <qingx@marvell.com>
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>  drivers/video/backlight/max8925_bl.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
> index f72ba54..7de02ed 100644
> --- a/drivers/video/backlight/max8925_bl.c
> +++ b/drivers/video/backlight/max8925_bl.c
> @@ -101,6 +101,29 @@ static const struct backlight_ops max8925_backlight_ops = {
>         .get_brightness = max8925_backlight_get_brightness,
>  };
>
> +#ifdef CONFIG_OF
> +static int max8925_backlight_dt_init(struct platform_device *pdev,
> +                             struct max8925_backlight_pdata *pdata)
> +{
> +       struct device_node *nproot = pdev->dev.parent->of_node, *np;
> +       int dual_string;
> +
> +       if (!nproot)
> +               return -ENODEV;
> +       np = of_find_node_by_name(nproot, "backlight");
> +       if (!np) {
> +               dev_err(&pdev->dev, "failed to find backlight node\n");
> +               return -ENODEV;
> +       }
> +
> +       of_property_read_u32(np, "dual-string", &dual_string);
Please use the property like "maxium,max8925-dual-string" at here. It's used
to avoid naming conflict.

> +       pdata->dual_string = dual_string;
> +       return 0;
> +}
> +#else
> +#define max8925_backlight_dt_init(x, y)        (-1)
> +#endif
> +
>  static int __devinit max8925_backlight_probe(struct platform_device *pdev)
>  {
>         struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
> @@ -150,6 +173,13 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
>         platform_set_drvdata(pdev, bl);
>
>         value = 0;
> +       if (pdev->dev.parent->of_node && !pdata) {
> +               pdata = devm_kzalloc(&pdev->dev,
> +                                    sizeof(struct max8925_backlight_pdata),
> +                                    GFP_KERNEL);
> +               max8925_backlight_dt_init(pdev, pdata);
> +       }
> +
>         if (pdata) {
>                 if (pdata->lxw_scl)
>                         value |= (1 << 7);
> @@ -161,7 +191,6 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
>         ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
>         if (ret < 0)
>                 goto out_brt;
> -
>         backlight_update_status(bl);
>         return 0;
>  out_brt:
> --
> 1.7.0.4
>
