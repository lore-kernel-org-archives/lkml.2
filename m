Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1E1I5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 04:57:12 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:50763 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab1E1I5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 04:57:10 -0400
Date: Sat, 28 May 2011 01:57:03 -0700
From: Nishanth Menon <nm@ti.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 1/3] PM: Introduce DEVFREQ: generic DVFS framework
 with device-specific OPPs
Message-ID: <20110528085659.GA3300@olorun>
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:53-20110527, MyungJoo Ham wrote:
[..]
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 56a6899..819c1b3 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -21,6 +21,7 @@
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
>  #include <linux/opp.h>
> +#include <linux/devfreq.h>
>  
>  /*
>   * Internal data structure organization with the OPP layer library is as
> @@ -428,6 +429,11 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>  	list_add_rcu(&new_opp->node, head);
>  	mutex_unlock(&dev_opp_list_lock);
>  
> +	/*
> +	 * Notify generic dvfs for the change and ignore error
> +	 * because the device may not have a devfreq entry
> +	 */
> +	devfreq_update(dev);
I think I understand your thought about notifiers here - we had some
initial thought that we may need notifiers, for e.g. clk change
notifiers which could implement enable/disable on a dependent device,
thermal management etc.. so far, we have'nt had a need to modify the
lowest data store layer to handle this. In this case, I think you'd
like a notifier mechanism in general for opp_add,enable or disable in
the opp library. However, with this change, an opp_add now means:
a) opp_add now depends on devfreq_update() to be part of it's integral
operation - I think the devfreq should maintain it's own notifier
mechanisms and not make OPP library do the notification trigger job of
devfreq.
b) By ignoring the error, how will the caller of opp_add now know if the
failures were real - e.g. some device failed to act on the notification
and the overall opp_add operation failed? And why should OPP library do
recovery for on behalf of devfreq?
c) How will you ensure the lock accuracy - given that you need to keep
to the constraints of opp_add/opp_set_availability here? For example:
devfreq_do is called from devfreq_monitor(workqueue) and devfreq_update
in addition to having to call a bunch of function pointers whose
implementation you do not know, having a function that ensures security
of it's data, handles all lock conditions that is imposed differently by
add,enable and disable is not visible in this implementation.
c) How about considering the usage of OPP library with an SoC cpufreq
implementation say for MPU AND using the same SoC using devfreq for
controlling some devices like MALI in your example simultaneously? Lets
say the thermal policy manager implementation for some reason did an
opp_disable of a higher OPP of MPU - devfreq_update gets called with the
device(mpu_dev).. devfreq_update needs to now invoke it's validation
path and fails correctly - Vs devfreq_update being called by some module
which actually uses devfreq and the update failed - How does one
differentiate between the two?

just my 2 cents, I think these kind of notifiers should probably
stay out of opp library OR notifiers be introduced in a generic and safe
fashion.

>  	return 0;
>  }
>  
> @@ -512,6 +518,9 @@ unlock:
>  	mutex_unlock(&dev_opp_list_lock);
>  out:
>  	kfree(new_opp);
> +
> +	/* Notify generic dvfs for the change and ignore error */
> +	devfreq_update(dev);
Another place where I am confused - how does devfreq_update know in what
context is it being called is the OPP getting enabled/disabled/added -
devfreq_update has to do some additional work to make it's own decision
- it is almost as if it uses devfreq_update as a trigger mechanism to reevalute
the entire decision tree - without using information of the context
opp_enable/disable/add has to maybe make better call. if this
information is not needed, maybe some other mechanism implemented by
devfreq layer might suffice..

>  	return r;
>  }

[...]
-- 
Regards,
Nishanth Menon
