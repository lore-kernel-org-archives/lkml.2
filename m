Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2HOSXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:23:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42486 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753538Ab2HOSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:23:43 -0400
Date: Wed, 15 Aug 2012 14:23:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Update][PATCH 3/3] PM / Runtime: Check device PM QoS setting
 before "no callbacks" check
In-Reply-To: <201208152022.56224.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208151422580.547-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Runtime: Check device PM QoS setting before "no callbacks"
> 
> If __dev_pm_qos_read_value(dev) returns a negative value,
> rpm_suspend() should return -EPERM for dev even if its
> power.no_callbacks flag is set.  For this to happen, the device's
> power.no_callbacks flag has to be checked after the PM QoS check,
> so move the PM QoS check to rpm_check_suspend_allowed() (this will
> make it cover idle notifications as well as runtime suspend too).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/runtime.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> Index: linux/drivers/base/power/runtime.c
> ===================================================================
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -147,6 +147,8 @@ static int rpm_check_suspend_allowed(str
>  	    || (dev->power.request_pending
>  			&& dev->power.request == RPM_REQ_RESUME))
>  		retval = -EAGAIN;
> +	else if (__dev_pm_qos_read_value(dev) < 0)
> +		retval = -EPERM;
>  	else if (dev->power.runtime_status == RPM_SUSPENDED)
>  		retval = 1;
>  
> @@ -402,12 +404,6 @@ static int rpm_suspend(struct device *de
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

Acked-by: Alan Stern <stern@rowland.harvard.edu>

