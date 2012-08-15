Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2HOQOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:14:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50030 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754064Ab2HOQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:14:53 -0400
Date: Wed, 15 Aug 2012 12:14:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / Runtime: Fix rpm_resume() return value for
 power.no_callbacks set
In-Reply-To: <201208142338.18797.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208151212490.1674-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Rafael J. Wysocki wrote:

> 
> For devices whose power.no_callbacks flag is set, rpm_resume()
> should return 1 if the device's parent is already active, so that
> the callers of pm_runtime_get() don't think that they have to wait
> for the device to resume (asynchronously) in that case (the core
> won't queue up an asynchronous resume in that case, so there's
> nothing to wait for anyway).
> 
> Modify the code accordingly (and make sure that an idle notification
> will be queued up on success, even if 1 is to be returned).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/runtime.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/base/power/runtime.c
> ===================================================================
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -584,6 +584,7 @@ static int rpm_resume(struct device *dev
>  		    || dev->parent->power.runtime_status == RPM_ACTIVE) {
>  			atomic_inc(&dev->parent->power.child_count);
>  			spin_unlock(&dev->parent->power.lock);
> +			retval = 1;
>  			goto no_callback;	/* Assume success. */
>  		}
>  		spin_unlock(&dev->parent->power.lock);
> @@ -664,7 +665,7 @@ static int rpm_resume(struct device *dev
>  	}
>  	wake_up_all(&dev->power.wait_queue);
>  
> -	if (!retval)
> +	if (retval >= 0)
>  		rpm_idle(dev, RPM_ASYNC);
>  
>   out:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

