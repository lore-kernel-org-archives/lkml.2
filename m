Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1IYIYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 04:24:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61960 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1IYIYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 04:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <201109242325.53563.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201109242323.03474.rjw@sisk.pl>
	<201109242325.53563.rjw@sisk.pl>
Date: Sun, 25 Sep 2011 16:24:16 +0800
Message-ID: <CACVXFVPvbrWvC3TWL-SVfbdYxZcDWGQTj3vw6Z1+10KK=bv5ug@mail.gmail.com>
Subject: Re: [PATCH 2/3] PM / Runtime: Don't run callbacks under lock for
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

On Sun, Sep 25, 2011 at 5:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The rpm_suspend() and rpm_resume() routines execute subsystem or PM
> domain callbacks under power.lock if power.irq_safe is set for the
> given device.  This is inconsistent with that rpm_idle() does after
> commit 02b2677 (PM / Runtime: Allow _put_sync() from
> interrupts-disabled context) and is problematic for subsystems and PM
> domains wanting to use power.lock for synchronization in their
> runtime PM callbacks.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Reviewed-by: Ming Lei <tom.leiming@gmail.com>

> ---
>  drivers/base/power/runtime.c |   68 +++++++++++++++++++++++++++++--------------
>  1 file changed, 46 insertions(+), 22 deletions(-)
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
> @@ -347,6 +353,15 @@ static int rpm_suspend(struct device *de
>                        goto out;
>                }
>
> +               if (dev->power.irq_safe) {
> +                       spin_unlock(&dev->power.lock);
> +
> +                       cpu_relax();
> +
> +                       spin_lock(&dev->power.lock);
> +                       goto repeat;
> +               }
> +
>                /* Wait for the other suspend running in parallel with us. */
>                for (;;) {
>                        prepare_to_wait(&dev->power.wait_queue, &wait,
> @@ -496,6 +511,15 @@ static int rpm_resume(struct device *dev
>                        goto out;
>                }
>
> +               if (dev->power.irq_safe) {
> +                       spin_unlock(&dev->power.lock);
> +
> +                       cpu_relax();
> +
> +                       spin_lock(&dev->power.lock);
> +                       goto repeat;
> +               }
> +
>                /* Wait for the operation carried out in parallel with us. */
>                for (;;) {
>                        prepare_to_wait(&dev->power.wait_queue, &wait,
>
>


thanks,
-- 
Ming Lei
