Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2JQFjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:39:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2JQFjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:39:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/3] PM / Runtime: force memory allocation with no I/O during runtime_resume callbcack
Date: Wed, 17 Oct 2012 07:43:04 +0200
Message-ID: <6431373.tJcdR3m2Df@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1350403183-12650-3-git-send-email-ming.lei@canonical.com>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com> <1350403183-12650-3-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 of October 2012 23:59:42 Ming Lei wrote:
> This patch applies the introduced memalloc_noio_save() and
> memalloc_noio_restore() to force memory allocation with no I/O
> during runtime_resume callback.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/power/runtime.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 3148b10..c71a8f0 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -503,6 +503,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
>  	int (*callback)(struct device *);
>  	struct device *parent = NULL;
>  	int retval = 0;
> +	unsigned int noio_flag;
>  
>  	trace_rpm_resume(dev, rpmflags);
>  
> @@ -652,7 +653,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
>  	if (!callback && dev->driver && dev->driver->pm)
>  		callback = dev->driver->pm->runtime_resume;
>  
> +	/*
> +	 * Deadlock might be caused if memory allocation with GFP_KERNEL
> +	 * happens inside runtime_resume callback of one block device's
> +	 * ancestor or the block device itself. The easiest approach is
> +	 * to forbid I/O inside runtime_resume of all devices.
> +	 *
> +	 * In fact, it can be done only if the deivce is a block device
> +	 * or there is one block device descendant. But that may become
> +	 * complicated and not efficient because device tree traversing
> +	 * is involved.
> +	 */
> +	memalloc_noio_save(noio_flag);
>  	retval = rpm_callback(callback, dev);
> +	memalloc_noio_restore(noio_flag);
>  	if (retval) {
>  		__update_runtime_status(dev, RPM_SUSPENDED);
>  		pm_runtime_cancel_pending(dev);

This appears to be a bit too heavy handed.  First of all, it seems to affect
all memory allocations going in parallel with the resume callback.  Second,
it affects all resume callbacks, not only those where the problem really
appears.  As a result, we are likely to get some memory allocation failures
that don't happen without the patch and don't really need to happen at all.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
