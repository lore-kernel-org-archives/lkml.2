Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2HOQUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:20:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50037 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755495Ab2HOQUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:20:45 -0400
Date: Wed, 15 Aug 2012 12:20:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PM / Runtime: Check device PM QoS setting before
 "no callbacks" check
In-Reply-To: <201208142341.50852.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208151219170.1674-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Rafael J. Wysocki wrote:

> 
> If __dev_pm_qos_read_value(dev) returns a negative value,
> rpm_suspend() should return -EPERM for dev even if its
> power.no_callbacks flag is set.  For this to happen, the device's
> power.no_callbacks flag has to be checked after the PM QoS check,
> so modify the code accordingly.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/runtime.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux/drivers/base/power/runtime.c
> ===================================================================
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -388,6 +388,12 @@ static int rpm_suspend(struct device *de
>  		goto repeat;
>  	}
>  
> +	if (__dev_pm_qos_read_value(dev) < 0) {
> +		/* Negative PM QoS constraint means "never suspend". */
> +		retval = -EPERM;
> +		goto out;
> +	}
> +
>  	if (dev->power.no_callbacks)
>  		goto no_callback;	/* Assume success. */
>  
> @@ -402,12 +408,6 @@ static int rpm_suspend(struct device *de
>  		goto out;
>  	}
>  
> -	if (__dev_pm_qos_read_value(dev) < 0) {
> -		/* Negative PM QoS constraint means "never suspend". */
> -		retval = -EPERM;
> -		goto out;
> -	}
> -
>  	__update_runtime_status(dev, RPM_SUSPENDING);
>  
>  	if (dev->pm_domain)

Wouldn't it be better to move the test into 
rpm_check_suspend_allowed()?  Then it would apply to idle notifications 
and pm_schedule_suspend().

Alan Stern

