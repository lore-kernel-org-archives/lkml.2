Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0KKWvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:51:07 -0500
Received: from www.tglx.de ([62.245.132.106]:35847 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0KKWvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:51:05 -0500
Date: Thu, 11 Nov 2010 23:50:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kyle Moffett <kyle@moffetthome.net>
cc: Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCHv6 0/7] system time changes notification
In-Reply-To: <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org> <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net> <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Thu, 11 Nov 2010, Kyle Moffett wrote:
> On Thu, Nov 11, 2010 at 16:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The notification itself is pointless unless your application is
> > dealing with timers which need to be adjusted the one way or the
> > other.
> >
> > That said, I'm still not convinced that this usecase justifies a new
> > systemcall.
> >
> > 1) We can make timers wake up when a clock change happens
> > 2) Can't we use existing notification stuff like uevents or such ?
> 
> What about maybe adding device nodes for various kinds of "clock"
> devices?  You could then do:
> 
> #define CLOCK_FD 0x80000000
> fd = open("/dev/clock/realtime", O_RDWR);
> poll(fd);
> clock_gettime(CLOCK_FD|fd, &ts);

That won't work due to the posix-cputimers occupying the negative
number space already.

> [...]
> 
> This would also enable the folks who want to support things like PHY
> hardware clocks (for very-low-latency ethernet timestamping).  It
> would resolve the enumeration problem; instead of 0, 1, 2, ... as
> constants, they would show up in sysfs and be open()able.  Ideally you
> would be able to set up ntpd to slew the "realtime" clock by following
> a particular hardware clock, or vice versa.

There are other plans for the various interesting clocks floating
around which look pretty good.

But what you folks really want for this stuff is an extension to
timerfd as you want to be able to poll, right?

So what about the following:

Add a new flag TDF_NOTIFY_CLOCK_WAS_SET to the timerfd flags. Now this
flag adds the timer to a separate list, which gets woken up when the
clock is set.

No new syscall, just a few lines of code in fs/timerfd.c and
clock_was_set().

Thoughts ?

	 tglx
