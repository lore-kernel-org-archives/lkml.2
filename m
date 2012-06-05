Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2FERJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:09:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52140 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752288Ab2FERJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:09:45 -0400
Date: Tue, 5 Jun 2012 13:09:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <CACVXFVMdidqhFE1AhenUi8VXbYhac492YdxsvPmVqcwmo=TrcA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206051256130.1542-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Ming Lei wrote:

> On Tue, Jun 5, 2012 at 10:47 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > Avoid running probe, that's fine.  But avoiding remove can lead to
> > problems, because the subsystem and the driver will no longer agree on
> > who should manage the device.
> 
> After device_shutdown() has been called, the whole system will enter power down
> or reset later, so it doesn't matter if who should manage the device.

Maybe.  But there might be quite some time between the shutdown call 
and the eventual power-off or reboot.

> Also once shutdown callback is called for the device, looks its other callbacks
> should not touch the device any more.

You shouldn't depend on that.  Shutdown methods generally put the 
device into a state suitable for power-off or reboot; they don't often 
guarantee that the driver won't change the state later on.

On the whole, it might be easier just to hold the device lock during 
the shutdown call.

> >> @@ -1803,6 +1806,9 @@ void device_shutdown(void)
> >>  {
> >>       struct device *dev;
> >>
> >> +     ACCESS_ONCE(device_shutdown_started) = 1;
> >
> > This does not need to be ACCESS_ONCE.  ACCESS_ONCE is needed only in
> > situations where the compiler might insert multiple reads or writes.
> 
> I have talked with Paul about the ACCESS_ONCE, and Paul thought it is needed
> to prevent the compiler from doing byte-at-a-time stores.

Why on earth would a compiler change this into a byte-at-a-time store?  
And even if it did, what problem would that cause?  Only one of the 
bytes would be different from the original value.

> Maybe Paul has a detailed explanation about it.

> >>  static int really_probe(struct device *dev, struct device_driver *drv)
> >>  {
> >>       int ret = 0;
> >> +     int idx;
> >>
> >> +     idx = srcu_read_lock(&driver_srcu);
> >>       atomic_inc(&probe_count);
> >> +     if (ACCESS_ONCE(device_shutdown_started))
> >
> > This doesn't need to be ACCESS_ONCE either.  If it would make you feel
> 
> Because the global variable of device_shutdown_started is not changed inside
> the function, the compiler may put the above line after the line of
> 'dev->driver = drv',

No, it can't do that.  If the compiler moved this read farther down, 
and as a result the CPU wrote to dev->driver when it shouldn't have, 
the result would be incorrect (i.e., different from what would have 
happened if the statement hadn't been moved).  Hence the compiler is 
prohibited from making such an optimization.

> so introduce the ACCESS_ONCE to avoid the compiler optimization.
> 
> > better, you could write
> >
> >        if (rcu_dereference(&device_shutdown_started))
> 
> The usage of SRCU refers to the part 'Cleaning Up Safely' of the SRCU
> paper 'Sleepable RCU'[1].  Also the patch doesn't call rcu_assign_pointer,
> so rcu_dereference isn't needed.

True, it's not needed any more than ACCESS_ONCE is.

> > As mentioned above, this is not good.  I don't know... maybe it won't
> > ever cause any difficulties.
> 
> Looks same with above.

You could try going into an infinite loop here, but that's probably not 
a good idea.

Alan Stern

