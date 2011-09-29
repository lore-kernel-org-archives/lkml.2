Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1I2ARr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:17:47 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:39652 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075Ab1I2ARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:17:45 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, jean.pihet@newoldbits.com,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/3] PM / Runtime: Don't run callbacks under lock for power.irq_safe set
Organization: Texas Instruments, Inc.
References: <201108310017.03103.rjw@sisk.pl> <87oby66ejr.fsf@ti.com>
	<201109271916.33616.rjw@sisk.pl> <201109272150.42732.rjw@sisk.pl>
Date: Wed, 28 Sep 2011 17:17:39 -0700
In-Reply-To: <201109272150.42732.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 27 Sep 2011 21:50:42 +0200")
Message-ID: <87wrcstd5o.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday, September 27, 2011, Rafael J. Wysocki wrote:
>> On Tuesday, September 27, 2011, Kevin Hilman wrote:
>> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> > 
>> > > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > >
>> > > The rpm_suspend() and rpm_resume() routines execute subsystem or PM
>> > > domain callbacks under power.lock if power.irq_safe is set for the
>> > > given device.  This is inconsistent with that rpm_idle() does after
>> > > commit 02b2677 (PM / Runtime: Allow _put_sync() from
>> > > interrupts-disabled context) and is problematic for subsystems and PM
>> > > domains wanting to use power.lock for synchronization in their
>> > > runtime PM callbacks.
>> > >
>> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > 
>> > The part described here looks right, and is much better for consistency.
>> > 
>> > Reviewed-by: Kevin Hilman <khilman@ti.com>
>> > 
>> > but...
>> > 
>> > [...]
>> > 
>> > > @@ -347,6 +353,15 @@ static int rpm_suspend(struct device *de
>> > >  			goto out;
>> > >  		}
>> > >  
>> > > +		if (dev->power.irq_safe) {
>> > > +			spin_unlock(&dev->power.lock);
>> > > +
>> > > +			cpu_relax();
>> > > +
>> > > +			spin_lock(&dev->power.lock);
>> > > +			goto repeat;
>> > > +		}
>> > > +
>> > 
>> > 
>> > ... AFAICT, this isn't directly related to the problem described in the
>> > changelog (or at least I didn't find it obvious),
>> 
>> It is related.  Whether or not it's obvious, I'm not sure. :-)
>> 
>> The problem is that after the changes in __rpm_callback() another CPU may start
>> executing the same routine for the same device if dev->power.irq_safe is set
>> (previously, it would block on the dev's power.lock) and it may see
>> dev->power.runtime_status == RPM_RESUMING or
>> dev->power.runtime_status == RPM_SUSPENDING, while previously, it wouldn't
>> reach the relevant code.  Thus we have to modify that code to take
>> the dev->power.irq_safe case into account.
>> 
>> > and probably deserves a comment in the code as well.
>> 
>> Well, the comment in the code would explain why the commit did what it did,
>> but it wouldn't be very useful afterwards IMHO.
>> 
>> Perhaps I'll simply add some explanation to the changelog.
>
> Below is the patch with the new changelog, for completness.

Thanks, it's much clearer now.

Kevin

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Runtime: Don't run callbacks under lock for power.irq_safe set
>
> The rpm_suspend() and rpm_resume() routines execute subsystem or PM
> domain callbacks under power.lock if power.irq_safe is set for the
> given device.  This is inconsistent with that rpm_idle() does after
> commit 02b2677 (PM / Runtime: Allow _put_sync() from
> interrupts-disabled context) and is problematic for subsystems and PM
> domains wanting to use power.lock for synchronization in their
> runtime PM callbacks.
>
> This change requires the code checking if the device's runtime PM
> status is RPM_SUSPENDING or RPM_RESUMING to be modified too, to take
> the power.irq_safe set case into account (that code wasn't reachable
> before with power.irq_safe set, because it's executed with the
> device's power.lock held).
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reviewed-by: Ming Lei <tom.leiming@gmail.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> ---
>  drivers/base/power/runtime.c |   68 +++++++++++++++++++++++++++++--------------
>  1 file changed, 46 insertions(+), 22 deletions(-)
>
> Index: linux/drivers/base/power/runtime.c
> ===================================================================
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -155,6 +155,31 @@ static int rpm_check_suspend_allowed(str
>  }
>  
>  /**
> + * __rpm_callback - Run a given runtime PM callback for a given device.
> + * @cb: Runtime PM callback to run.
> + * @dev: Device to run the callback for.
> + */
> +static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
> +	__releases(&dev->power.lock) __acquires(&dev->power.lock)
> +{
> +	int retval;
> +
> +	if (dev->power.irq_safe)
> +		spin_unlock(&dev->power.lock);
> +	else
> +		spin_unlock_irq(&dev->power.lock);
> +
> +	retval = cb(dev);
> +
> +	if (dev->power.irq_safe)
> +		spin_lock(&dev->power.lock);
> +	else
> +		spin_lock_irq(&dev->power.lock);
> +
> +	return retval;
> +}
> +
> +/**
>   * rpm_idle - Notify device bus type if the device can be suspended.
>   * @dev: Device to notify the bus type about.
>   * @rpmflags: Flag bits.
> @@ -225,19 +250,8 @@ static int rpm_idle(struct device *dev,
>  	else
>  		callback = NULL;
>  
> -	if (callback) {
> -		if (dev->power.irq_safe)
> -			spin_unlock(&dev->power.lock);
> -		else
> -			spin_unlock_irq(&dev->power.lock);
> -
> -		callback(dev);
> -
> -		if (dev->power.irq_safe)
> -			spin_lock(&dev->power.lock);
> -		else
> -			spin_lock_irq(&dev->power.lock);
> -	}
> +	if (callback)
> +		__rpm_callback(callback, dev);
>  
>  	dev->power.idle_notification = false;
>  	wake_up_all(&dev->power.wait_queue);
> @@ -252,22 +266,14 @@ static int rpm_idle(struct device *dev,
>   * @dev: Device to run the callback for.
>   */
>  static int rpm_callback(int (*cb)(struct device *), struct device *dev)
> -	__releases(&dev->power.lock) __acquires(&dev->power.lock)
>  {
>  	int retval;
>  
>  	if (!cb)
>  		return -ENOSYS;
>  
> -	if (dev->power.irq_safe) {
> -		retval = cb(dev);
> -	} else {
> -		spin_unlock_irq(&dev->power.lock);
> -
> -		retval = cb(dev);
> +	retval = __rpm_callback(cb, dev);
>  
> -		spin_lock_irq(&dev->power.lock);
> -	}
>  	dev->power.runtime_error = retval;
>  	return retval != -EACCES ? retval : -EIO;
>  }
> @@ -347,6 +353,15 @@ static int rpm_suspend(struct device *de
>  			goto out;
>  		}
>  
> +		if (dev->power.irq_safe) {
> +			spin_unlock(&dev->power.lock);
> +
> +			cpu_relax();
> +
> +			spin_lock(&dev->power.lock);
> +			goto repeat;
> +		}
> +
>  		/* Wait for the other suspend running in parallel with us. */
>  		for (;;) {
>  			prepare_to_wait(&dev->power.wait_queue, &wait,
> @@ -496,6 +511,15 @@ static int rpm_resume(struct device *dev
>  			goto out;
>  		}
>  
> +		if (dev->power.irq_safe) {
> +			spin_unlock(&dev->power.lock);
> +
> +			cpu_relax();
> +
> +			spin_lock(&dev->power.lock);
> +			goto repeat;
> +		}
> +
>  		/* Wait for the operation carried out in parallel with us. */
>  		for (;;) {
>  			prepare_to_wait(&dev->power.wait_queue, &wait,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
