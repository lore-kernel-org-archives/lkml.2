Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1LACDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:03:18 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44355 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1LACDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:03:17 -0500
MIME-Version: 1.0
In-Reply-To: <1322704427-11876-1-git-send-email-Barry.Song@csr.com>
References: <1322704427-11876-1-git-send-email-Barry.Song@csr.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 1 Dec 2011 10:02:54 +0800
Message-ID: <CAMPhdO-BEgNkHERx-0mE5B4kTZ90wjAgWbWMBNdfTioyWFP5zA@mail.gmail.com>
Subject: Re: [PATCH] backlight: pwm_bl: move suspend/resume entries from
 platform_driver to driver.pm
To: Barry Song <Barry.Song@csr.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, linux-arm-kernel@lists.infradead.org,
        Xiangzhen Ye <Xiangzhen.Ye@csr.com>, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 9:53 AM, Barry Song <Barry.Song@csr.com> wrote:
> From: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
>
> At first, people are moving suspend/resume entries from platform_driver
> to driver.pm for many drivers.
> On the other hand, if we use swsusp to do hibernation for an embedded
> system using pwm_bl, in the process of preparing snapshot, backlight
> will be off and make lcd black screen. This gives bad user experiences.
> This patch will fix this issue as swsusp will go to call pm.freeze()
> but not platform_driver.suspend. we have no pm.freeze() for pwm_bl, so
> the lcd black screen will disappear.
>
> Signed-off-by: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/video/backlight/pwm_bl.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 8b5b2a4..50f3134 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -169,9 +169,9 @@ static int pwm_backlight_remove(struct platform_device *pdev)
>  }
>
>  #ifdef CONFIG_PM
> -static int pwm_backlight_suspend(struct platform_device *pdev,
> -                                pm_message_t state)
> +static int pwm_backlight_suspend(struct device *dev)
>  {
> +       struct platform_device *pdev = to_platform_device(dev);
>        struct backlight_device *bl = platform_get_drvdata(pdev);
>        struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>
> @@ -184,8 +184,9 @@ static int pwm_backlight_suspend(struct platform_device *pdev,
>        return 0;
>  }
>
> -static int pwm_backlight_resume(struct platform_device *pdev)
> +static int pwm_backlight_resume(struct device *dev)
>  {
> +       struct platform_device *pdev = to_platform_device(dev);
>        struct backlight_device *bl = platform_get_drvdata(pdev);
>
>        backlight_update_status(bl);
> @@ -196,15 +197,19 @@ static int pwm_backlight_resume(struct platform_device *pdev)
>  #define pwm_backlight_resume   NULL
>  #endif
>
> +static const struct dev_pm_ops pwm_backlight_pm_ops = {
> +       .suspend = pwm_backlight_suspend,
> +       .resume = pwm_backlight_resume,
> +};
> +
>  static struct platform_driver pwm_backlight_driver = {
>        .driver         = {
>                .name   = "pwm-backlight",
>                .owner  = THIS_MODULE,
> +               .pm     = &pwm_backlight_pm_ops,
>        },
>        .probe          = pwm_backlight_probe,
>        .remove         = pwm_backlight_remove,
> -       .suspend        = pwm_backlight_suspend,
> -       .resume         = pwm_backlight_resume,
>  };
>
>  static int __init pwm_backlight_init(void)
> --
> 1.7.1
>
>
>
> Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
> More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
