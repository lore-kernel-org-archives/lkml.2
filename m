Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0KKWgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:36:54 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41351 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0KKWgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:36:53 -0500
Subject: Re: [PATCHv6 0/7] system time changes notification
From: john stultz <johnstul@us.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
	 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net>
	 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
	 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 14:36:34 -0800
Message-ID: <1289514994.2742.81.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 17:11 -0500, Kyle Moffett wrote:
> On Thu, Nov 11, 2010 at 16:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The notification itself is pointless unless your application is
> > dealing with timers which need to be adjusted the one way or the
> > other.
> >
> > That said, I'm still not convinced that this usecase justifies a new
> > systemcall.
> >
> > 1) We can make timers wake up when a clock change happens

I think this seems like the most interesting solution. 

However we may need some sort of special flag, as I don't think many
timers are expecting to fire before the specified time, so you'd likely
break regular applications if all timers woke up on clock changes.


> > 2) Can't we use existing notification stuff like uevents or such ?
> 
> What about maybe adding device nodes for various kinds of "clock"
> devices?  You could then do:
> 
> #define CLOCK_FD 0x80000000
> fd = open("/dev/clock/realtime", O_RDWR);
> poll(fd);
> clock_gettime(CLOCK_FD|fd, &ts);

Ehh.. I'm not a huge fan of creating dynamic ids for what are static
clocksources (REALTIME, MONOTONIC, etc). 

That said...

> [...]
> 
> This would also enable the folks who want to support things like PHY
> hardware clocks (for very-low-latency ethernet timestamping).  It
> would resolve the enumeration problem; instead of 0, 1, 2, ... as
> constants, they would show up in sysfs and be open()able.  Ideally you
> would be able to set up ntpd to slew the "realtime" clock by following
> a particular hardware clock, or vice versa.

This is very similar in spirit to what's being done by Richard Cochran's
dynamic clock devices code: http://lwn.net/Articles/413332/

thanks
-john

