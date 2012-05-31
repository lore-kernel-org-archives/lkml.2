Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab2EaPEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:04:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:56887 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab2EaPEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:04:39 -0400
Date: Thu, 31 May 2012 17:04:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Ingo Molnar <mingo@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Use of high-res timers
In-Reply-To: <Pine.LNX.4.44L0.1205311004050.1580-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.02.1205311650130.3231@ionos>
References: <Pine.LNX.4.44L0.1205311004050.1580-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Alan Stern wrote:
> On Thu, 31 May 2012, Thomas Gleixner wrote:
> 
> > > 	I need timed intervals with reliable lower bounds.  Let's say
> > > 	I call ktime_get twice, maybe once in an interrupt handler and
> > > 	once in an hrtimer callback (not necessarily on the same CPU).
> > > 	Some action has to be taken no earlier than 1 ms after the 
> > > 	first call.  If the second call returns a value that is at 
> > > 	least 1 ms larger than the first call, is that enough of a 
> > > 	guarantee?  If not, how much larger does it have to be?
> > 
> > ktime_get() is precise. Can you explain what you are trying to solve ?
> 
> Here's an example.  A hardware device accesses a software data
> structure via DMA, and the driver needs to change the data structure.  
> However, the data can't be updated safely while the device is using it.
> Furthermore, we know that the device may continue to access the data
> for as long as 1 ms after being told to stop (because of internal
> caches and such).

And of course the hardware designers decided that there is no need for
a reliable way to detect that....
 
> It's okay to wait longer than 1 ms, but we'd like to minimize the wait 
> time in order to avoid delaying I/O unnecessarily.  Therefore:
> 
>     (1) The driver removes the pointer to the data structure from
> 	the device's DMA list, then calls ktime_get, adds 1 ms, and
> 	stores the result.
> 
>     (2) The driver waits for while (details are unimportant).
> 
>     (3) Some time later, the driver calls ktime_get again and compares 
> 	the stored value to the new value.  If the new value is 
> 	smaller, go back to step (2).
> 
>     (4) Now the driver knows that at least 1 ms has passed since (1),
> 	and therefore any ongoing DMA has finished and the pointer has
> 	been dropped from the device's cache.  Thus the device cannot
> 	be doing DMA to the data structure any more, so the data can be
> 	updated safely.
> 
> The key here is the assumption in step (4): If the new value from
> ktime_get exceeds the stored value then one millisecond of time really
> has elapsed.  I can imagine this might not hold true if the two calls
> to ktime_get were made on different CPUs, or possibly for other
> reasons.

No. ktime_get() is guaranteed to be monotonic across CPUs.
 
> So my question is: What value should be stored in step (1) to guarantee 
> that the assumption is value?
> 
> More or less equivalently, what is the relative error between two calls 
> of ktime_get?

It just depends on the resolution of the underlying clocksource and NTP
adjustments.

So the only case where you can run into trouble is when the
clocksource is coarse grained, e.g. pure jiffies, where two
consecutive calls can show a 1/HZ delta.

But you really should not worry much about that, except you are aiming
for some stoneage platform. Anything up to date is going to have at
least a 32kHz counter based clocksource. At 32kHz the per clock tick
increment is ~30us, so that's your expected error.

Thanks,

	tglx






