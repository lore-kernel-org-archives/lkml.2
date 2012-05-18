Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab2ERE7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:59:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43375 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2ERE7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:59:11 -0400
Date: Thu, 17 May 2012 21:59:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Race condition between =?utf-8?Q?drive?=
 =?utf-8?Q?r=5Fprobe=5Fdevice_and_device=5Fshutdown=E2=80=8F?=
Message-ID: <20120518045907.GA3397@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,

First off, sorry for missing this, and thanks to Andrew for pointing it
out to me.  You might want to use the tool, scripts/get_maintainer.pl
for who to know to cc: for patches like this, so I don't miss it.

> I'm seeing a driver crash in its shutdown routine because it's
> touching some uninitialized state. It turns out that the driver's
> probe routine was still running [for the same device]. There also
> appears to be an issue in the remove path, where device_shutdown()
> checks the dev->driver pointer and uses it later, with seemingly
> nothing to guarantee that it doesn't change.

What type of driver is having this problem?  What type of bus is it on?
Usually the bus prevents this from happening with its own serialization.

> Shouldn't we synchronize the shutdown routine with probe/remove to
> prevent such races?

Normally, yes, and for some reason, I thought we already were doing
that.

> The patch below should take care of these races.

Does this patch solve your problem?  Care to show me the oops you get
without it?

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index e28ce98..f2c63c6 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1823,6 +1823,9 @@ void device_shutdown(void)
>                 pm_runtime_get_noresume(dev);
>                 pm_runtime_barrier(dev);
> 
> +               if (dev->parent)        /* Needed for USB */
> +                       device_lock(dev->parent);
> +               device_lock(dev);

The parent thing is "interesting", and if we are going to have to start
duplicating this logic in different parts of the driver core, we should
wrap it up in a common function, right?

thanks,

greg k-h
