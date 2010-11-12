Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0KLMkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:40:08 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:36751 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab0KLMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:40:06 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 07:40:05 EST
Date: Fri, 12 Nov 2010 14:30:44 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 0/7] system time changes notification
Message-ID: <20101112123044.GD10585@shisha.kicks-ass.net>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost>
 <20101111205123.GC10585@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:16:03PM +0100, Thomas Gleixner wrote:
> B1;2401;0cOn Thu, 11 Nov 2010, Alexander Shishkin wrote:
> 
> > On Thu, Nov 11, 2010 at 03:28:13PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Thu, 11 Nov 2010 21:29:55 +0200, Alexander Shishkin said:
> > > 
> > > > Consider we want stuff like "wakeup every day at 3pm", the next wakeup
> > > > might be earlier than the timer we calculated last time, on system
> > > > time changes. We need to re-calculate it. This is necessary for all
> > > > repeating events.
> > > > 
> > > > Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
> > > > hours. Now the system time changes to 2pm, and we would expect to
> > > > wakeup in one hour, but we take 25.
> > > 
> > > Sorry, I tuned in late here...
> > > 
> > > So the plan is that if you're not using this new interface, it will go off at
> > > the same absolute offset (23 hours after timer was set), but if you're using
> > > this interface, your timer event gets interrupted, you get woken up (say)
> > > 15 hours into your 23, and it's your job to decide if you need to set a
> > > new timer for the remaining 6, 7, 8 hours or some other number?
> > 
> > Yes. This interface doesn't deal with timers, it only provides notifications.
> 
> The notification itself is pointless unless your application is
> dealing with timers which need to be adjusted the one way or the
> other.

Not quite. There are two use cases that I know of that need this notification
but don't use timers like that. One was described by Chris Friesen in the
comments to the first version of this patchset [1]. The other one was
described by me in the same thread [2]. They could, of course start using
timers specifically to get this notification, but I'm not sure if it doesn't
abuse the whole idea of timers.

> That said, I'm still not convinced that this usecase justifies a new
> systemcall.

Well, initially it was a sysfs interface (an arguably ugly one, though).

> 1) We can make timers wake up when a clock change happens

Isn't there a race so that if two clock changes happen in quick succession,
the user might lose the second one while he restarts the timer?

> 2) Can't we use existing notification stuff like uevents or such ?

I thought about that in the beginning but uevents indeed seem too heavy
for this sort of notification, especially compared to eventfds.

[1] http://lkml.org/lkml/2010/8/4/383
[2] http://lkml.org/lkml/2010/8/5/192

Regards,
--
Alex
