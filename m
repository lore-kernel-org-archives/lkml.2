Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0K3I53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:57:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38428 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0K3I52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:57:28 -0500
MIME-Version: 1.0
X-Originating-IP: [66.201.52.98]
In-Reply-To: <20101128055315.GD3318@intel.com>
References: <20101128055315.GD3318@intel.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 30 Nov 2010 00:57:07 -0800
Message-ID: <AANLkTiknO0BEBetKmFT5W0qwW+q1pS59qcwiqSMUHa_u@mail.gmail.com>
Subject: Re: [PATCH v1 3/3]mmc: changes to enable runtime PM of mmc core layer
To: Yunpeng Gao <yunpeng.gao@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yunpeng,

On Sat, Nov 27, 2010 at 9:53 PM, Yunpeng Gao <yunpeng.gao@intel.com> wrote:
>  static int mmc_runtime_idle(struct device *dev)
>  {
> -       return pm_runtime_suspend(dev);
> +       return pm_schedule_suspend(dev, 100);

You shouldn't do this here.

You didn't comment about or mentioned this change, but I guess you did
it because you (quite reasonably) didn't want the card to be powered
off as soon as mmc_blk_issue_rq() completes, and instead, you
preferred to wait until some period of inactivity time passes.

But that's not true for all mmc buses: e.g., when an SDIO function
driver decides it's time to power off the card (e.g. user disables the
wlan interface), there is no reason to have this delay.

In addition, putting an inherent delay here will completely prevent
anyone from achieving a synchronous idle notification on an mmc card
(so even pm_runtime_put_sync() will now set a timer to submit a
suspend request instead of carrying out a synchronous suspend).

It looks like you can drop this change, and instead just use the
autosuspend API from the mmc block driver (mainly use
pm_runtime_put_autosuspend() instead of pm_runtime_put()).

Another nice benefit of autosuspend is that now user space will be
able to tweak the amount of delay by using
/sys/devices/.../power/autosuspend_delay_ms attribute.


> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 92e3370..8268b8e 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -19,6 +19,7 @@
>  #include <linux/leds.h>
>  #include <linux/slab.h>
>  #include <linux/suspend.h>
> +#include <linux/pm_runtime.h>
>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/card.h>
> @@ -28,6 +29,33 @@
>
>  #define cls_dev_to_mmc_host(d) container_of(d, struct mmc_host, class_dev)
>
> +#ifdef CONFIG_PM_RUNTIME
> +static int mmc_host_runtime_suspend(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static int mmc_host_runtime_resume(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static int mmc_host_runtime_idle(struct device *dev)
> +{
> +       return pm_runtime_suspend(dev);
> +}
> +#else
> +#define mmc_host_runtime_suspend       NULL
> +#define mmc_host_runtime_resume                NULL
> +#define mmc_host_runtime_idle          NULL
> +#endif
> +
> +const static struct dev_pm_ops host_pm = {
> +       .runtime_suspend = mmc_host_runtime_suspend,
> +       .runtime_resume = mmc_host_runtime_resume,
> +       .runtime_idle = mmc_host_runtime_idle,
> +};

Since the host's classdev is just a logical sub device of the parent,
and will never be power managed on its own, we don't really need those
handlers.

Instead, you can just call pm_runtime_no_callbacks(). This will tell
the PM core to assume that ->runtime_idle() always invokes
->runtime_suspend(), and that the ->runtime_{suspend, resume}
callbacks always succeed.

> +
>  static void mmc_host_classdev_release(struct device *dev)
>  {
>        struct mmc_host *host = cls_dev_to_mmc_host(dev);
> @@ -37,6 +65,7 @@ static void mmc_host_classdev_release(struct device *dev)
>  static struct class mmc_host_class = {
>        .name           = "mmc_host",
>        .dev_release    = mmc_host_classdev_release,
> +       .pm             = &host_pm,
>  };
>
>  int mmc_register_host_class(void)
> @@ -333,6 +362,12 @@ int mmc_add_host(struct mmc_host *host)
>        if (err)
>                return err;
>
> +       /* Enable runtime PM */
> +       pm_runtime_get_noresume(&host->class_dev);
> +       pm_runtime_set_active(&host->class_dev);
> +       pm_runtime_enable(&host->class_dev);
> +       pm_runtime_put_sync(&host->class_dev);

Why do you need the get_noresume() and put_sync() calls here ?

If you put it in order to ensure the device is automatically powered
off after enabling runtime pm, you can just move the set_active() and
enable() calls a few lines upwards that function, just _before_ you
add the device to the device tree.

Thanks,
Ohad.

> +
>  #ifdef CONFIG_DEBUG_FS
>        mmc_add_host_debugfs(host);
>  #endif
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
