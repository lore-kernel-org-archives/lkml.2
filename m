Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750812Ab2LCFCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:02:35 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59062 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LCFCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:02:34 -0500
MIME-Version: 1.0
In-Reply-To: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
Date: Mon, 3 Dec 2012 00:02:33 -0500
Message-ID: <CAHdPZaP+8wi6ZL5ugvgoEiq5AaLK8+V1SDbirMw0zj=C=w9ZNw@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove the device
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        haojian.zhuang@gmail.com, linux-arm-kernel@lists.infradead.org,
        xiechao.mail@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Andrew as he is the maintainer of the rtc subsystem

On Wed, Nov 28, 2012 at 9:21 PM, Chao Xie <chao.xie@marvell.com> wrote:
> The original sa1100_rtc_open/sa1100_rtc_release will be called
> when the /dev/rtc0 is opened or closed.
> In fact, these two functions will enable/disable the clock, and
> register/unregister the irqs.
> User application will use /dev/rtc0 to read the rtc time or set
> the alarm. The rtc should still run indepent of open/close the
> rtc device.
> So only enable clock and register the irqs when probe the device,
> and disable clock and unregister the irqs when remove the device.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  drivers/rtc/rtc-sa1100.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
> index 50a5c4a..e933327 100644
> --- a/drivers/rtc/rtc-sa1100.c
> +++ b/drivers/rtc/rtc-sa1100.c
> @@ -218,8 +218,6 @@ static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
>  }
>
>  static const struct rtc_class_ops sa1100_rtc_ops = {
> -       .open = sa1100_rtc_open,
> -       .release = sa1100_rtc_release,
>         .read_time = sa1100_rtc_read_time,
>         .set_time = sa1100_rtc_set_time,
>         .read_alarm = sa1100_rtc_read_alarm,
> @@ -253,6 +251,10 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
>         spin_lock_init(&info->lock);
>         platform_set_drvdata(pdev, info);
>
> +       ret = sa1100_rtc_open(&pdev->dev);
> +       if (ret)
> +               goto err_open;
> +
>         /*
>          * According to the manual we should be able to let RTTR be zero
>          * and then a default diviser for a 32.768KHz clock is used.
> @@ -305,7 +307,9 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
>
>         return 0;
>  err_dev:
> +       sa1100_rtc_release(&pdev->dev);
>         platform_set_drvdata(pdev, NULL);
> +err_open:
>         clk_put(info->clk);
>  err_clk:
>         kfree(info);
> @@ -318,6 +322,7 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
>
>         if (info) {
>                 rtc_device_unregister(info->rtc);
> +               sa1100_rtc_release(&pdev->dev);
>                 clk_put(info->clk);
>                 platform_set_drvdata(pdev, NULL);
>                 kfree(info);
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
