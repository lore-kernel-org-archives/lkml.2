Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2EUS3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:29:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57664 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750884Ab2EUS3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:29:10 -0400
Date: Mon, 21 May 2012 14:29:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
 =?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
In-Reply-To: <CACVXFVPeicEStTqtdO3Jt32JuhP3+_kof7vqgErK_iSDWdt92w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205211426040.1725-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Ming Lei wrote:

> Cc pm list because it is related with PM.
> 
> Hi Greg,
> 
> On Mon, May 21, 2012 at 3:51 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> >
> > And how can that happen with a real bus?  Don't we have a lock
> 
> The races may be triggered when one device is just probed(triggered
> by plug) or released(triggered by unplug) at the same time of running
> reboot/poweroff.
> 
> > somewhere per-bus that should be protecting this type of thing (sorry,
> > can't dig through the code at the moment, on the road...)
> 
> device_shutdown is called with only holding reboot_mutex, so I think no
> any protection on dev->driver there.
> 
> >
> > How come no one has ever hit them in the past 10 years?  What am I
> > missing here?
> 
> The window is so small that maybe it is very very difficult to trigger
> the races, :-)
> But looks Wedson is luck enough to observe it.
> 
> >> Looks the above makes sense to serialize .shutdown with
> >> .probe and .release.
> >
> > Let me look at the code when I get back in a few days, but I really
> > thought we already had a lock protecting all of this...
> 
> Also the previous patch don't cover the .runtime_resume races with
> .probe or .release, so the right fix may be below:
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 346be8b..cbc8bd2 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1820,6 +1820,11 @@ void device_shutdown(void)
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> 
> +		/*hold lock[s] to avoid races with .probe/.release*/
> +		if (dev->parent)
> +			device_lock(dev->parent);
> +		device_lock(dev);
> +
>  		/* Don't allow any more runtime suspends */
>  		pm_runtime_get_noresume(dev);
>  		pm_runtime_barrier(dev);
> @@ -1831,6 +1836,9 @@ void device_shutdown(void)
>  			dev_dbg(dev, "shutdown\n");
>  			dev->driver->shutdown(dev);
>  		}
> +		device_unlock(dev);
> +		if (dev->parent)
> +			device_unlock(dev->parent);
>  		put_device(dev);
> 
>  		spin_lock(&devices_kset->list_lock);
> 
> Another candidate fix is to register a reboot notifier in driver core to prevent
> driver from being bound or unbound from start of reboot/shutdown, but looks
> not easy as the way of holding device locks.

I'd guess it was done this way so that the shutdown task wouldn't have 
to wait for a buggy driver that didn't want to release the device lock 
(or that crashed while holding the lock).

It's not clear that the reboot notifier approach would work.  What 
about probes that had already started when notifier was called?

Alan Stern

