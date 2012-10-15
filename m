Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2JOOOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:14:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50309 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753772Ab2JOOOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:14:36 -0400
Date: Mon, 15 Oct 2012 10:14:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH 2/3] PM / Runtime: force memory allocation with no
 I/O during runtime_resume callbcack
In-Reply-To: <1350278059-14904-3-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1210151013310.1702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, Ming Lei wrote:

> This patch applies the introduces tsk_memalloc_forbid_io() and
> tsk_memalloc_allow_io() to force memory allocation with no I/O
> during runtime_resume callback.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/power/runtime.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 3148b10..76836c1 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -652,7 +652,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
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
> +	tsk_memalloc_forbid_io(current);
>  	retval = rpm_callback(callback, dev);
> +	tsk_memalloc_allow_io(current);

This is not so good.  What happens if I/O was already forbidden when
this function was called?

Alan Stern

