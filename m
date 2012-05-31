Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2EaOrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:47:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37810 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751799Ab2EaOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:47:12 -0400
Date: Thu, 31 May 2012 10:31:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Use of high-res timers
In-Reply-To: <alpine.LFD.2.02.1205310932240.3231@ionos>
Message-ID: <Pine.LNX.4.44L0.1205311004050.1580-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Thomas Gleixner wrote:

> > 	I need timed intervals with reliable lower bounds.  Let's say
> > 	I call ktime_get twice, maybe once in an interrupt handler and
> > 	once in an hrtimer callback (not necessarily on the same CPU).
> > 	Some action has to be taken no earlier than 1 ms after the 
> > 	first call.  If the second call returns a value that is at 
> > 	least 1 ms larger than the first call, is that enough of a 
> > 	guarantee?  If not, how much larger does it have to be?
> 
> ktime_get() is precise. Can you explain what you are trying to solve ?

Here's an example.  A hardware device accesses a software data
structure via DMA, and the driver needs to change the data structure.  
However, the data can't be updated safely while the device is using it.
Furthermore, we know that the device may continue to access the data
for as long as 1 ms after being told to stop (because of internal
caches and such).

It's okay to wait longer than 1 ms, but we'd like to minimize the wait 
time in order to avoid delaying I/O unnecessarily.  Therefore:

    (1) The driver removes the pointer to the data structure from
	the device's DMA list, then calls ktime_get, adds 1 ms, and
	stores the result.

    (2) The driver waits for while (details are unimportant).

    (3) Some time later, the driver calls ktime_get again and compares 
	the stored value to the new value.  If the new value is 
	smaller, go back to step (2).

    (4) Now the driver knows that at least 1 ms has passed since (1),
	and therefore any ongoing DMA has finished and the pointer has
	been dropped from the device's cache.  Thus the device cannot
	be doing DMA to the data structure any more, so the data can be
	updated safely.

The key here is the assumption in step (4): If the new value from
ktime_get exceeds the stored value then one millisecond of time really
has elapsed.  I can imagine this might not hold true if the two calls
to ktime_get were made on different CPUs, or possibly for other
reasons.

So my question is: What value should be stored in step (1) to guarantee 
that the assumption is value?

More or less equivalently, what is the relative error between two calls 
of ktime_get?

Alan Stern

