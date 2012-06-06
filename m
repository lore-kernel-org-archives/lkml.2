Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2FFOoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:44:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51180 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752879Ab2FFOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:44:06 -0400
Date: Wed, 6 Jun 2012 10:44:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <CACVXFVPjQmvmXnYNm4sSjJXq83qe-Xg8=YjRppSNMpUQYLokjQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206061022020.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Ming Lei wrote:

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

Not much time from the user's point of view, but computers can do a lot 
in a short time.

> > On the whole, it might be easier just to hold the device lock during
> > the shutdown call.
> 
> Yes, it is easier, but it is not efficient because there are very less
> drivers which implemented .shutdown callback. Suppose there are some
> drivers which have no .shutdown but are holding device lock,  extra
> time will be consumed in the lock acquiring, which may slow down 'power
> down'.

The main reasons for holding the device lock are probe and remove 
callbacks.  In your patch, synchronize_srcu has to wait for those too.  
So there won't be much extra time.

> >> Because the global variable of device_shutdown_started is not changed inside
> >> the function, the compiler may put the above line after the line of
> >> 'dev->driver = drv',
> >
> > No, it can't do that.  If the compiler moved this read farther down,
> > and as a result the CPU wrote to dev->driver when it shouldn't have,
> > the result would be incorrect (i.e., different from what would have
> > happened if the statement hadn't been moved).  Hence the compiler is
> > prohibited from making such an optimization.
5B5B> 
> There are some similar examples(check on global variable is moved) with
> ACCESS_ONCE usage in Documentation/atomic_ops.txt. (from line 88)

Most of those examples involve repeatedly reading a global variable.  
In your case there is no repetition, and you are writing rather than 
reading.

Furthermore, I think some of those examples go a little too far.  
Here's an extract from the file:

-------------------------------------------------------------------
For a final example, consider the following code, assuming that the
variable a is set at boot time before the second CPU is brought online
and never changed later, so that memory barriers are not needed:

	if (a)
		b = 9;
	else
		b = 42;

The compiler is within its rights to manufacture an additional store
by transforming the above code into the following:

	b = 42;
	if (a)
		b = 9;

This could come as a fatal surprise to other code running concurrently
that expected b to never have the value 42 if a was zero.  To prevent
the compiler from doing this, write something like:

	if (a)
		ACCESS_ONCE(b) = 9;
	else
		ACCESS_ONCE(b) = 42;
-------------------------------------------------------------------

That just seems wrong.  By the same reasoning, the compiler is within 
its rights to transform either the original code or the code using 
ACCESS_ONCE into:

	b = 999;
	if (a)
		b = 9;
	else
		b = 42;

and again, other code would be confused.  The simple fact is that 
SMP-safe code is not likely to be produced by a compiler that assumes 
everything is single-threaded.

Alan Stern

