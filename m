Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab0IFHJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 03:09:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43856 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0IFHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 03:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JilM1hEwo4R5h8AQn9PhjFwNR9D6qrYERhTJCoLM8krz6pXFeSNXD6zZC/WpNFgGl6
         JVZMt2dEZwrFLNTo6lw0mUxyaqq09PZ89ArxrHxIq2HerM8kXvp6E/mctvdcQs5lhSLC
         TfUbZnZjA81DBB1ZQPuKc6XeatGEclxWQWP/U=
Date: Mon, 6 Sep 2010 09:09:51 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Christian Riesch <christian.riesch@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <20100906070951.GB4549@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <alpine.DEB.2.00.1009041221240.888@router.home>
 <4C828652.4060804@gmail.com>
 <alpine.DEB.2.00.1009042042130.9425@router.home>
 <20100905062240.GB2699@riccoc20.at.omicron.at>
 <20100905072041.GA2928@riccoc20.at.omicron.at>
 <alpine.DEB.2.00.1009051759100.3480@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009051759100.3480@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Taking John Stultz on CC.)

On Sun, Sep 05, 2010 at 06:13:33PM -0500, Christoph Lameter wrote:
> On Sun, 5 Sep 2010, Richard Cochran wrote:
> > When I get some more time, I'll try to put together an executive
> > summary of PTP and of all the discussions that have taken place over
> > the last few months on linux-netdev and the lkml.
> 
> I know PTP,

Ah, thats good.

> I just dont know why you would need to extend the existing
> apis for support. Maybe you could just simply write a PTP clock driver? If

That is what I already did in this patch set:

   http://lkml.org/lkml/2010/8/16/90

However, people asked, why not just use the posix clock API?  And so,
I implemented that idea, too. Now the question is, which API is the
better choice. I like the posix clock idea, but I am also fine with
the character device. That was my original approach.

> you follow the way hpet is implemented then you dont even need a clock id.
> See drivers/char/hpet.c. I cannot imagine why someone would want to set
> PTP to a different time and speed (vs. realtime not the hardware
> configuration) than the standard clock. The API you proposed so far is
> not needed as far as I can tell.

No one wants to set a different time, but the fact remains that we
have two separate clocks. The two clocks need to be synchronized, but
how do you do this?

My idea was this. Simply use the PPS subsystem to synchronize the
Linux system time to the PTP time in the PTP hardware clock. That is
just like using a GPS or radio clock. The only requirement is that the
hardware clocks provides one interrupt.

It will happen that some hardware will be build without any interrupt
between the PTP hardware clock and the CPU. Even so, such a setup can
still be useful, for example in an embedded control application. The
userland software can simply ignore the wrong system time. I think the
PTP hardware clock infrastructure should be rich enough to support
this situation.

> I really would like a PTP clock as soon as possible. Very very important
> for time sync via the network.

Good, me too!
 
> Then there is CLOCK_SGI_CYCLE. Another hw clock that can be set and gotten
> already with the standard posix interface. See drivers/char/mmtimer.c. The
> main benefit from CLOCK_SGI_CYCLE is that you can set it manually (maybe
> you want an offset to realtime? But I do not know of any usecase for
> setting the clock) and that the clock can cause hardware IRQ events
> to cause timer timers in user space (would be great to know if PTP needs
> this?).

Some PTP hardware clocks provide interrupts to the main CPU. These can
used to implement a PPS input, user alarms, and user timers.

> I would not think that PTP needs any of this specialized functionality.

Well, to make the super-synchronized time in the PTP hardware clock
really useful, there needs to be some extra functionality, like
timestamping external signals or producing periodic or one-shot output
signals.

If you don't have or need such functionality, then running PTP with
plain old software timestamping (no special PTP hardware clock) should
be good enough for most purposes.

> John point about not wanting to proliferate different APIs and useless
> clock ids is valid. An intial implementation using hpet style stuff would
> be satisfactory and as far as I can tell would be rather trivial to do.
> 
> Standardizing the ioctls between the different clock drivers would be
> useful so that they can all be controlled with some common API. But it
> would be great to first have a release of a clock_ptp listing all the
> needed ioctl so that we can see what the common subset is.

Okay, I think I have already done that in the above patch set. Would
you care to comment on it?

As I said before, I prefer the posix clock idea, but the character
device implementation is fine, too. Heck, we can offer both
avenues. My goal is to support PTP hardware clocks in the kernel.

Thanks,
Richard
