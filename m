Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2HOQTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:19:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50034 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754064Ab2HOQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:19:14 -0400
Date: Wed, 15 Aug 2012 12:19:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] PM / Runtime: Clear power.deferred_resume on success
 in rpm_suspend()
In-Reply-To: <201208142340.45153.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208151214560.1674-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Rafael J. Wysocki wrote:

> 
> The power.deferred_resume can only be set if the runtime PM status
> of device is RPM_SUSPENDING and it should be cleared after its
> status has been changed, regardless of whether or not the runtime
> suspend has been successful.  However, it only is cleared on suspend
> failure, while it may remain set after successful suspend and is
> happily leaked to rpm_resume() executed in that case.
> 
> That shouldn't happen, so if power.deferred_resume is set in
> rpm_suspend() after the status has been changed to RPM_SUSPENDED,
> clear it before calling rpm_resume().  Then, it doesn't need to be
> cleared before changing the status to RPM_SUSPENDING any more,
> because it's always cleared after the status has been changed to
> either RPM_SUSPENDED (on success) or RPM_ACTIVE (on failure).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/runtime.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/base/power/runtime.c
> ===================================================================
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -388,7 +388,6 @@ static int rpm_suspend(struct device *de
>  		goto repeat;
>  	}
>  
> -	dev->power.deferred_resume = false;
>  	if (dev->power.no_callbacks)
>  		goto no_callback;	/* Assume success. */
>  
> @@ -440,6 +439,7 @@ static int rpm_suspend(struct device *de
>  	wake_up_all(&dev->power.wait_queue);
>  
>  	if (dev->power.deferred_resume) {
> +		dev->power.deferred_resume = false;
>  		rpm_resume(dev, 0);
>  		retval = -EAGAIN;
>  		goto out;

Basically this comes down to a matter of taste.  I tend to use a "lazy" 
approach, not initializing values until they need to contain a proper 
value (and not worrying if they contain garbage or wrong values at 
times when they won't be used).

But of course, this is fine too.  With this change, you can also
simplify one of the tests in rpm_check_suspend_allowed().

Acked-by: Alan Stern <stern@rowland.harvard.edu>

