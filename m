Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1ILI0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:26:52 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51431 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1ILI0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <201108310020.26104.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201108310020.26104.rjw@sisk.pl>
Date: Mon, 12 Sep 2011 16:26:49 +0800
Message-ID: <CACVXFVPshpc-aVHGMYWkthffMRYLFh4BadnEAhf+eQ47CwWLZw@mail.gmail.com>
Subject: Re: [PATCH 2/5] PM / Runtime: Do not run callbacks under lock for
 power.irq_safe set
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 31, 2011 at 6:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The rpm_suspend() and rpm_resume() routines execute subsystem or PM
> domain callbacks under power.lock if power.irq_safe is set for the
> given device.  This is inconsistent with that rpm_idle() does after
> commit 02b2677 (PM / Runtime: Allow _put_sync() from
> interrupts-disabled context) and is problematic for subsystems and PM
> domains wanting to use power.lock for synchronization in their
> runtime PM callbacks.  For this reason, make runtime PM core functions
> always release power.lock before invoking subsystem or PM domain

If power.lock is released, the transition states(resuming or suspending)
may be observed in rpm_suspend or rpm_resume, then tasks schedule
will be produced in these two functions, so the functions below can't be

      pm_runtime_suspend()
      pm_runtime_autosuspend()
      pm_runtime_resume()
      pm_runtime_put_sync_suspend()
      pm_runtime_put_sync_autosuspend()

called in irq-off contexts safely even though irq_safe flag is set.

> callbacks.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/runtime.c |   50 ++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 22 deletions(-)
>
> Index: linux/drivers/base/power/runtime.c
> ===================================================================
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -155,6 +155,31 @@ static int rpm_check_suspend_allowed(str
>  }
>
>  /**
> + * __rpm_callback - Run a given runtime PM callback for a given device.
> + * @cb: Runtime PM callback to run.
> + * @dev: Device to run the callback for.
> + */
> +static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
> +       __releases(&dev->power.lock) __acquires(&dev->power.lock)
> +{
> +       int retval;
> +
> +       if (dev->power.irq_safe)
> +               spin_unlock(&dev->power.lock);
> +       else
> +               spin_unlock_irq(&dev->power.lock);
> +
> +       retval = cb(dev);
> +
> +       if (dev->power.irq_safe)
> +               spin_lock(&dev->power.lock);
> +       else
> +               spin_lock_irq(&dev->power.lock);
> +
> +       return retval;
> +}
> +
> +/**
>  * rpm_idle - Notify device bus type if the device can be suspended.
>  * @dev: Device to notify the bus type about.
>  * @rpmflags: Flag bits.
> @@ -225,19 +250,8 @@ static int rpm_idle(struct device *dev,
>        else
>                callback = NULL;
>
> -       if (callback) {
> -               if (dev->power.irq_safe)
> -                       spin_unlock(&dev->power.lock);
> -               else
> -                       spin_unlock_irq(&dev->power.lock);
> -
> -               callback(dev);
> -
> -               if (dev->power.irq_safe)
> -                       spin_lock(&dev->power.lock);
> -               else
> -                       spin_lock_irq(&dev->power.lock);
> -       }
> +       if (callback)
> +               __rpm_callback(callback, dev);
>
>        dev->power.idle_notification = false;
>        wake_up_all(&dev->power.wait_queue);
> @@ -252,22 +266,14 @@ static int rpm_idle(struct device *dev,
>  * @dev: Device to run the callback for.
>  */
>  static int rpm_callback(int (*cb)(struct device *), struct device *dev)
> -       __releases(&dev->power.lock) __acquires(&dev->power.lock)
>  {
>        int retval;
>
>        if (!cb)
>                return -ENOSYS;
>
> -       if (dev->power.irq_safe) {
> -               retval = cb(dev);
> -       } else {
> -               spin_unlock_irq(&dev->power.lock);
> -
> -               retval = cb(dev);
> +       retval = __rpm_callback(cb, dev);
>
> -               spin_lock_irq(&dev->power.lock);
> -       }
>        dev->power.runtime_error = retval;
>        return retval != -EACCES ? retval : -EIO;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


thanks,
-- 
Ming Lei
