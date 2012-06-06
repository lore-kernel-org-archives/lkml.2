Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2FFNm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:42:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47570 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2FFNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:42:44 -0400
Date: Wed, 6 Jun 2012 06:42:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120606134214.GC19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACVXFVMdidqhFE1AhenUi8VXbYhac492YdxsvPmVqcwmo=TrcA@mail.gmail.com>
 <Pine.LNX.4.44L0.1206051256130.1542-100000@iolanthe.rowland.org>
 <CACVXFVPjQmvmXnYNm4sSjJXq83qe-Xg8=YjRppSNMpUQYLokjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVPjQmvmXnYNm4sSjJXq83qe-Xg8=YjRppSNMpUQYLokjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060613-4242-0000-0000-000001E2B3DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:27:04AM +0800, Ming Lei wrote:
> On Wed, Jun 6, 2012 at 1:09 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> >> After device_shutdown() has been called, the whole system will enter power down
> >> or reset later, so it doesn't matter if who should manage the device.
> >
> > Maybe.  But there might be quite some time between the shutdown call
> > and the eventual power-off or reboot.
> 
> Between device_shutdown and machine_halt, there is only syscore_shutdown left
> to complete, so no much time is involved.
> 
> >
> > On the whole, it might be easier just to hold the device lock during
> > the shutdown call.
> 
> Yes, it is easier, but it is not efficient because there are very less
> drivers which implemented .shutdown callback. Suppose there are some
> drivers which have no .shutdown but are holding device lock,  extra
> time will be consumed in the lock acquiring, which may slow down 'power
> down'.
> 
> >
> >> >> @@ -1803,6 +1806,9 @@ void device_shutdown(void)
> >> >>  {
> >> >>       struct device *dev;
> >> >>
> >> >> +     ACCESS_ONCE(device_shutdown_started) = 1;
> >> >
> >> > This does not need to be ACCESS_ONCE.  ACCESS_ONCE is needed only in
> >> > situations where the compiler might insert multiple reads or writes.
> >>
> >> I have talked with Paul about the ACCESS_ONCE, and Paul thought it is needed
> >> to prevent the compiler from doing byte-at-a-time stores.
> >
> > Why on earth would a compiler change this into a byte-at-a-time store?
> > And even if it did, what problem would that cause?  Only one of the
> > bytes would be different from the original value.
> 
> Maybe Paul can answer the question...

No sane compiler would change it to a byte-at-a-time store, but the
compiler would nevertheless be within its rights to do so.  And a quick
review of certain LKML threads could easily cause anyone to question gcc's
sanity.  Furthermore, the compiler is permitted to make transformations
like the following, which it might well do to save a branch:

	if (b)				a = 0;
		a = 1;			if (b)
	else					a = 1;
		a = 0;

In short, without ACCESS_ONCE(), the compiler is within its rights to
assume that the code is single-threaded.  There are a large number of
non-obvious optimizations that are safe in single-threaded code but
destructive in multithreaded code.

In addition, and perhaps more important, ACCESS_ONCE() serves as useful
documentation of the fact that the variable is accessed outside of locks.

							Thanx, Paul

> >> Maybe Paul has a detailed explanation about it.
> >
> >> >>  static int really_probe(struct device *dev, struct device_driver *drv)
> >> >>  {
> >> >>       int ret = 0;
> >> >> +     int idx;
> >> >>
> >> >> +     idx = srcu_read_lock(&driver_srcu);
> >> >>       atomic_inc(&probe_count);
> >> >> +     if (ACCESS_ONCE(device_shutdown_started))
> >> >
> >> > This doesn't need to be ACCESS_ONCE either.  If it would make you feel
> >>
> >> Because the global variable of device_shutdown_started is not changed inside
> >> the function, the compiler may put the above line after the line of
> >> 'dev->driver = drv',
> >
> > No, it can't do that.  If the compiler moved this read farther down,
> > and as a result the CPU wrote to dev->driver when it shouldn't have,
> > the result would be incorrect (i.e., different from what would have
> > happened if the statement hadn't been moved).  Hence the compiler is
> > prohibited from making such an optimization.
> 
> There are some similar examples(check on global variable is moved) with
> ACCESS_ONCE usage in Documentation/atomic_ops.txt. (from line 88)
> 
> 
> Thanks,
> --
> Ming Lei
> 

