Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2K0Vlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:41:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34633 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab2K0Vlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:41:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
Date: Tue, 27 Nov 2012 22:46:34 +0100
Message-ID: <3562840.kvm4ZTnunM@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <5434404.G1ERYjuorE@vostro.rjw.lan>
References: <1353761958-12810-1-git-send-email-ming.lei@canonical.com> <1353761958-12810-3-git-send-email-ming.lei@canonical.com> <5434404.G1ERYjuorE@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 27, 2012 10:19:29 PM Rafael J. Wysocki wrote:
> On Saturday, November 24, 2012 08:59:14 PM Ming Lei wrote:
> > The patch introduces the flag of memalloc_noio in 'struct dev_pm_info'
> > to help PM core to teach mm not allocating memory with GFP_KERNEL
> > flag for avoiding probable deadlock.
> > 
> > As explained in the comment, any GFP_KERNEL allocation inside
> > runtime_resume() or runtime_suspend() on any one of device in
> > the path from one block or network device to the root device
> > in the device tree may cause deadlock, the introduced
> > pm_runtime_set_memalloc_noio() sets or clears the flag on
> > device in the path recursively.
> > 
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Signed-off-by: Ming Lei <ming.lei@canonical.com>
> > ---
> > v5:
> > 	- fix code style error
> > 	- add comment on clear the device memalloc_noio flag
> > v4:
> > 	- rename memalloc_noio_resume as memalloc_noio
> > 	- remove pm_runtime_get_memalloc_noio()
> > 	- add comments on pm_runtime_set_memalloc_noio
> > v3:
> > 	- introduce pm_runtime_get_memalloc_noio()
> > 	- hold one global lock on pm_runtime_set_memalloc_noio
> > 	- hold device power lock when accessing memalloc_noio_resume
> > 	  flag suggested by Alan Stern
> > 	- implement pm_runtime_set_memalloc_noio without recursion
> > 	  suggested by Alan Stern
> > v2:
> > 	- introduce pm_runtime_set_memalloc_noio()
> > ---
> >  drivers/base/power/runtime.c |   60 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/pm.h           |    1 +
> >  include/linux/pm_runtime.h   |    3 +++
> >  3 files changed, 64 insertions(+)
> > 
> > diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> > index 3148b10..3e198a0 100644
> > --- a/drivers/base/power/runtime.c
> > +++ b/drivers/base/power/runtime.c
> > @@ -124,6 +124,66 @@ unsigned long pm_runtime_autosuspend_expiration(struct device *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(pm_runtime_autosuspend_expiration);
> >  
> > +static int dev_memalloc_noio(struct device *dev, void *data)
> > +{
> > +	return dev->power.memalloc_noio;
> > +}
> > +
> > +/*
> > + * pm_runtime_set_memalloc_noio - Set a device's memalloc_noio flag.
> > + * @dev: Device to handle.
> > + * @enable: True for setting the flag and False for clearing the flag.
> > + *
> > + * Set the flag for all devices in the path from the device to the
> > + * root device in the device tree if @enable is true, otherwise clear
> > + * the flag for devices in the path whose siblings don't set the flag.
> > + *
> 
> Please use counters instead of walking the whole path every time.  Ie. in
> addition to the flag add a counter to store the number of the device's
> children having that flag set.

I would use the flag only to store the information that
pm_runtime_set_memalloc_noio(dev, true) has been run for this device directly
and I'd use a counter for everything else.

That is, have power.memalloc_count that would be incremented when (1)
pm_runtime_set_memalloc_noio(dev, true) is called for that device and (2) when
power.memalloc_count for one of its children changes from 0 to 1 (and
analogously for decrementation).  Then, check the counter in rpm_callback().

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
