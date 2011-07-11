Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1GKPh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:37:26 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57586 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab1GKPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:37:25 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [Update][PATCH 6/10] PM / Domains: System-wide transitions support for generic domains (v5)
Organization: Texas Instruments, Inc.
References: <Pine.LNX.4.44L0.1107081033000.2208-100000@iolanthe.rowland.org>
	<201107082006.49660.rjw@sisk.pl> <201107082124.24921.rjw@sisk.pl>
	<201107091615.38915.rjw@sisk.pl>
Date: Mon, 11 Jul 2011 08:37:19 -0700
In-Reply-To: <201107091615.38915.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 9 Jul 2011 16:15:38 +0200")
Message-ID: <87oc10zv4g.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[...]

>
> There's one more case to consider, namely devices that are runtime
> suspended, set up to wake up the system from sleep states
> (ie. device_may_wakeup(dev) returns "true") and such that
> genpd->active_wakeup(dev) returns "true" for them, because they need
> to be resumed at this point too (arguably, it makes a little sense to
> runtime suspend such devices, but that's possible in principle).
>
> So, IMO, the patch should look like this:
>
> ---
>  drivers/base/power/domain.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
>> Index: linux-2.6/drivers/base/power/domain.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/domain.c
> +++ linux-2.6/drivers/base/power/domain.c
> @@ -486,6 +486,22 @@ static void pm_genpd_sync_poweroff(struc
>  }
>  
>  /**
> + * resume_needed - Check whether to resume a device before system suspend.
> + * @dev: Device to handle.
> + * @genpd: PM domain the device belongs to.
> + */
> +static bool resume_needed(struct device *dev, struct generic_pm_domain *genpd)
> +{
> +	bool active_wakeup;
> +
> +	if (!device_can_wakeup(dev))
> +		return false;
> +
> +	active_wakeup = genpd->active_wakeup && genpd->active_wakeup(dev);
> +	return device_may_wakeup(dev) ? active_wakeup : !active_wakeup;

This also returns true and causes a resume if active_wakeup = false and
device_may_wakeup() = false.  That doesn't seem right.

> +}
> +
> +/**
>   * pm_genpd_prepare - Start power transition of a device in a PM domain.
>   * @dev: Device to start the transition of.
>   *
> @@ -519,6 +535,9 @@ static int pm_genpd_prepare(struct devic
>  		return -EBUSY;
>  	}
>  
> +	if (resume_needed(dev, genpd))
> +		pm_runtime_resume(dev);
> +
>  	genpd_acquire_lock(genpd);
>  
>  	if (genpd->prepared_count++ == 0)

IIUC, if a device is runtime suspended when a system suspend happens,
the device will be runtime resumed, but never re-suspended.

Should resumes by the PM core be done with a get (and a corresponding
put in .complete())?

Kevin
