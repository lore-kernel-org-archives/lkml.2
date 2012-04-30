Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2D3I5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:57:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53040 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab2D3I5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:57:16 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.125.31]
In-Reply-To: <201204290311.01794.rjw@sisk.pl>
References: <201204272346.44145.rjw@sisk.pl>
	<201204290308.52416.rjw@sisk.pl>
	<201204290311.01794.rjw@sisk.pl>
Date: Mon, 30 Apr 2012 10:57:16 +0200
Message-ID: <CAORVsuW9JEmf97Cx7i4joMcuYyWA1e4xpcgmvoMfm_NuhGcDmg@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / QoS: Create device constraints objects on
 notifier registration
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Rafael,

On Sun, Apr 29, 2012 at 3:11 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The current behavior of dev_pm_qos_add_notifier() makes device PM QoS
> notifiers less than useful.  Namely, it silently returns success when
> called before any PM QoS constraints are added for the device, so the
> caller will assume that the notifier has been registered, but when
> someone actually adds some nontrivial constraints for the device
> eventually, the previous callers of dev_pm_qos_add_notifier()
> will not know about that and their notifier routines will not be
> executed (contrary to their expectations).
>
> To address this problem make dev_pm_qos_add_notifier() create the
> constraints object for the device if it is not present when the
> routine is called.
That is definitively more than needed!

FWIW:
Acked-by: Jean Pihet <j-pihet@ti.com>

Thanks for the fix,
Jean

>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by : markgross <markgross@thegnar.org>
> ---
>  drivers/base/power/qos.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> Index: linux/drivers/base/power/qos.c
> ===================================================================
> --- linux.orig/drivers/base/power/qos.c
> +++ linux/drivers/base/power/qos.c
> @@ -352,21 +352,26 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_remove_requ
>  *
>  * Will register the notifier into a notification chain that gets called
>  * upon changes to the target value for the device.
> + *
> + * If the device's constraints object doesn't exist when this routine is called,
> + * it will be created (or error code will be returned if that fails).
>  */
>  int dev_pm_qos_add_notifier(struct device *dev, struct notifier_block *notifier)
>  {
> -       int retval = 0;
> +       int ret = 0;
>
>        mutex_lock(&dev_pm_qos_mtx);
>
> -       /* Silently return if the constraints object is not present. */
> -       if (dev->power.constraints)
> -               retval = blocking_notifier_chain_register(
> -                               dev->power.constraints->notifiers,
> -                               notifier);
> +       if (!dev->power.constraints)
> +               ret = dev->power.power_state.event != PM_EVENT_INVALID ?
> +                       dev_pm_qos_constraints_allocate(dev) : -ENODEV;
> +
> +       if (!ret)
> +               ret = blocking_notifier_chain_register(
> +                               dev->power.constraints->notifiers, notifier);
>
>        mutex_unlock(&dev_pm_qos_mtx);
> -       return retval;
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(dev_pm_qos_add_notifier);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
