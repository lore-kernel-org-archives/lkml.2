Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0LCP0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:26:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49323 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750837Ab0LCP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:26:11 -0500
Date: Fri, 3 Dec 2010 10:26:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PM: Use pm_wakeup_pending() in device_suspend()
In-Reply-To: <201012030123.43786.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012031024020.1682-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Before starting to suspend a device in device_suspend() check if
> there's a request to abort the power transition and return -EBUSY
> in that case.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -935,6 +935,11 @@ static void async_suspend(void *data, as
>  
>  static int device_suspend(struct device *dev)
>  {
> +	if (pm_wakeup_pending()) {
> +		async_error = -EBUSY;
> +		return async_error;
> +	}
> +
>  	INIT_COMPLETION(dev->power.completion);
>  
>  	if (pm_async_enabled && dev->power.async_suspend) {

Is a similar test needed in async_suspend()?  What happens if 
dpm_suspend() runs through the entire device list okay, but a wakeup 
event occurs in the middle of the async_synchronize_full() delay?

Alan Stern

