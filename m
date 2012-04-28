Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2D1Pd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 11:33:56 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56488 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2D1Pdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 11:33:38 -0400
Date: Sat, 28 Apr 2012 08:33:35 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 1/2] PM / QoS: Create device constraints objects on
 notifier registration
Message-ID: <20120428153335.GA13787@G62>
Reply-To: markgross@thegnar.org
References: <201204272346.44145.rjw@sisk.pl>
 <201204272348.18533.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204272348.18533.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:48:18PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The current behavior of dev_pm_qos_add_notifier() makes device PM QoS
> notifiers less than useful.  Namely, it silently returns success when
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
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/qos.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> Index: linux/drivers/base/power/qos.c
> ===================================================================
> --- linux.orig/drivers/base/power/qos.c
> +++ linux/drivers/base/power/qos.c
> @@ -352,21 +352,26 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_remove_requ
>   *
>   * Will register the notifier into a notification chain that gets called
>   * upon changes to the target value for the device.
> + *
> + * If the device's constraints object doesn't exist when this routine is called,
> + * it will be created (or error code will be returned if that fails).
>   */
>  int dev_pm_qos_add_notifier(struct device *dev, struct notifier_block *notifier)
>  {
> -	int retval = 0;
> +	int ret = 0;
>  
>  	mutex_lock(&dev_pm_qos_mtx);
>  
> -	/* Silently return if the constraints object is not present. */
> -	if (dev->power.constraints)
> -		retval = blocking_notifier_chain_register(
> -				dev->power.constraints->notifiers,
> -				notifier);
FWIW (and IIRC) I did this because some audio use of pm_qos had a series
of re-allocation of constraints and clean up that would fall over so I
had this silent hack to deal with that "complexity".

> +	if (!dev->power.constraints)
> +		ret = dev->power.power_state.event != PM_EVENT_INVALID ?
> +			dev_pm_qos_constraints_allocate(dev) : -ENODEV;
> +
> +	if (!ret)
> +		ret = blocking_notifier_chain_register(
> +				dev->power.constraints->notifiers, notifier);
>  
>  	mutex_unlock(&dev_pm_qos_mtx);
> -	return retval;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(dev_pm_qos_add_notifier);
>  
Definitely a change for the better (but we should check that the audio
stuff still works before committing this.  I'll see if I can check that
this weekend.)

Acked-by : markgross <markgross@thegnar.org>

--mark

