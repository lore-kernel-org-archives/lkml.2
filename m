Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2ETTvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 15:51:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62813 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2ETTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 15:51:42 -0400
Date: Sun, 20 May 2012 12:51:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Race condition between =?utf-8?Q?drive?=
 =?utf-8?Q?r=5Fprobe=5Fdevice_and_device=5Fshutdown=E2=80=8F?=
Message-ID: <20120520195126.GA11282@kroah.com>
References: <20120518045907.GA3397@kroah.com>
 <CACVXFVPhPmTfdB-pKpz7NpL+N03cxDvPpiFdPWeZcqBNNSffYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVPhPmTfdB-pKpz7NpL+N03cxDvPpiFdPWeZcqBNNSffYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 10:08:08PM +0800, Ming Lei wrote:
> Hi,
> 
> On Fri, May 18, 2012 at 12:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> Hi,
> >
> > First off, sorry for missing this, and thanks to Andrew for pointing it
> > out to me.  You might want to use the tool, scripts/get_maintainer.pl
> > for who to know to cc: for patches like this, so I don't miss it.
> >
> >> I'm seeing a driver crash in its shutdown routine because it's
> >> touching some uninitialized state. It turns out that the driver's
> >> probe routine was still running [for the same device]. There also
> >> appears to be an issue in the remove path, where device_shutdown()
> >> checks the dev->driver pointer and uses it later, with seemingly
> >> nothing to guarantee that it doesn't change.
> >
> > What type of driver is having this problem?  What type of bus is it on?
> > Usually the bus prevents this from happening with its own serialization.
> 
> Looks it is a generic problem.
> 
> There are two races, one is between .probe and .shutdown, and another
> is between .release  and .shutdown, see below:
> 
> 
> void device_shutdown(void)
> 
> 		......
> 		/* Don't allow any more runtime suspends */
> 		pm_runtime_get_noresume(dev);
> 		pm_runtime_barrier(dev);
> 
> 		if (dev->bus && dev->bus->shutdown) {
> 			dev_dbg(dev, "shutdown\n");
> 			dev->bus->shutdown(dev);
> 		} else if (dev->driver && dev->driver->shutdown) {  /*line-driver*/
> 			dev_dbg(dev, "shutdown\n");
> 			dev->driver->shutdown(dev);                              /*line-shut*/
> 		}
> 		......
> 
> If dev->driver is just set(really_probe) before 'line-driver' and .probe is
> not executed before 'line-shut', the .shutdown may touch a uninitialized
> device.
> 
> Also if dev->driver is just cleared(__device_release_driver) after "line-driver"
> and before "line-shut", null pointer will be referenced and oops will
> be triggered.

And how can that happen with a real bus?  Don't we have a lock
somewhere per-bus that should be protecting this type of thing (sorry,
can't dig through the code at the moment, on the road...)

> >> Shouldn't we synchronize the shutdown routine with probe/remove to
> >> prevent such races?
> >
> > Normally, yes, and for some reason, I thought we already were doing
> > that.
> 
> Looks the races are still there.

How come no one has ever hit them in the past 10 years?  What am I
missing here?

> >> The patch below should take care of these races.
> >
> > Does this patch solve your problem?  Care to show me the oops you get
> > without it?
> >
> >> diff --git a/drivers/base/core.c b/drivers/base/core.c
> >> index e28ce98..f2c63c6 100644
> >> --- a/drivers/base/core.c
> >> +++ b/drivers/base/core.c
> >> @@ -1823,6 +1823,9 @@ void device_shutdown(void)
> >>                 pm_runtime_get_noresume(dev);
> >>                 pm_runtime_barrier(dev);
> >>
> >> +               if (dev->parent)        /* Needed for USB */
> >> +                       device_lock(dev->parent);
> >> +               device_lock(dev);
> 
> Looks the above makes sense to serialize .shutdown with
> .probe and .release.

Let me look at the code when I get back in a few days, but I really
thought we already had a lock protecting all of this...

thanks,

greg k-h
