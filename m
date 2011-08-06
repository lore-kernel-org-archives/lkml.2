Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114Ab1HFEdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 00:33:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1HFEdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 00:33:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=shVQwIWXs1e/YglUtsnfVTUXIhD92i6MHFcdZ3GVy79y5nHkDiZ4+sop0qaeiCXhI
	+vEGpvrdp4SYnscpCRkEw==
MIME-Version: 1.0
In-Reply-To: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
Date: Fri, 5 Aug 2011 21:33:31 -0700
Message-ID: <CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
From: Colin Cross <ccross@google.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 4:15 PM, Stephen Warren <swarren@nvidia.com> wrote:
> From: Dilan Lee <dilee@nvidia.com>
>
> We found the register settings of wm8903(an audio codec) can't be modified
> in snd_soc_suspend since I2C bus has been suspended before snd_soc_suspend.
>
> Pop noise will occur when system resume from LP0 if the register settings of wm8903
> haven't be modified correctly in snd_soc_suspend.
>
> So, we use the suspend_noirq/resume_noirq callbacks to make sure I2C bus still
> operates while running snd_soc_suspend.
>
> Signed-off-by: Dilan Lee <dilee@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> When applying this, you'll get a trivial merge conflict with the other
> i2c-tegra.c patch I just reposted titled "i2c: Tegra: Add of_match_table".
> Just add the two lines to tegra_i2c_driver.driver in whichever order you
> prefer:-).
>
>  drivers/i2c/busses/i2c-tegra.c |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 0c6e840..3d2bf19 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -687,8 +687,9 @@ static int tegra_i2c_remove(struct platform_device *pdev)
>  }
>
>  #ifdef CONFIG_PM
> -static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
> +static int tegra_i2c_suspend_noirq(struct device *dev)
>  {
> +       struct platform_device *pdev = to_platform_device(dev);
>        struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
>
>        i2c_lock_adapter(&i2c_dev->adapter);
> @@ -698,8 +699,9 @@ static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
>        return 0;
>  }
>
> -static int tegra_i2c_resume(struct platform_device *pdev)
> +static int tegra_i2c_resume_noirq(struct device *dev)
>  {
> +       struct platform_device *pdev = to_platform_device(dev);
>        struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
>        int ret;
>
> @@ -718,18 +720,23 @@ static int tegra_i2c_resume(struct platform_device *pdev)
>
>        return 0;
>  }
> +
> +static const struct dev_pm_ops tegra_i2c_dev_pm_ops = {
> +       .suspend_noirq = tegra_i2c_suspend_noirq,
> +       .resume_noirq = tegra_i2c_resume_noirq,
> +};
> +#define TEGRA_I2C_DEV_PM_OPS (&tegra_i2c_dev_pm_ops)
> +#else
> +#define TEGRA_I2C_DEV_PM_OPS NULL
>  #endif
>
>  static struct platform_driver tegra_i2c_driver = {
>        .probe   = tegra_i2c_probe,
>        .remove  = tegra_i2c_remove,
> -#ifdef CONFIG_PM
> -       .suspend = tegra_i2c_suspend,
> -       .resume  = tegra_i2c_resume,
> -#endif
>        .driver  = {
>                .name  = "tegra-i2c",
>                .owner = THIS_MODULE,
> +               .pm    = TEGRA_I2C_DEV_PM_OPS,
>        },
>  };
>
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

NAK - moving the suspend order around is not the correct way to solve
this.  If wm8903 needs to talk to the i2c bus in its suspend handler,
it needs to be child device on the i2c bus.  suspend_noirq is for
devices that must suspend with system irqs turned off, not for
ordering suspend handlers.
