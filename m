Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1CJQkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:40:49 -0500
Received: from www.tglx.de ([62.245.132.106]:54176 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1CJQkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:40:47 -0500
Date: Thu, 10 Mar 2011 17:40:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shishkin <virtuoso@slind.org>
cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
In-Reply-To: <20110310154357.GG11410@shisha.kicks-ass.net>
Message-ID: <alpine.LFD.2.00.1103101653350.2787@localhost6.localdomain6>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <alpine.LFD.2.00.1103101014260.2787@localhost6.localdomain6> <20110310141241.GE11410@shisha.kicks-ass.net> <alpine.LFD.2.00.1103101516501.2787@localhost6.localdomain6>
 <20110310154357.GG11410@shisha.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Alexander Shishkin wrote:
> On Thu, Mar 10, 2011 at 03:55:00PM +0100, Thomas Gleixner wrote:
> > On Thu, 10 Mar 2011, Alexander Shishkin wrote:
> > > On Thu, Mar 10, 2011 at 10:52:18AM +0100, Thomas Gleixner wrote:
> > > > On Wed, 9 Mar 2011, Alexander Shishkin wrote:
> > > > The patch does something different. How is this related to the problem
> > > > you wanted to solve in the first place?
> > > 
> > > Well, if you scratch the timerfd_settime() bit, it kind of addresses the
> > > initial problem. The timerfd_settime() was indeed a mistake.
> > > 
> > > > Can you please explain which problems you identified aside of the
> > > > initial one?
> > > 
> > > Sure. The time daemon that we have here has to stop automatic time updates
> > > when some other program changes system time *and* keep that setting
> > > effective. Currently, when "the other program" changes the system time
> > > right before time daemon changes it, this time setting will be overwritten
> > > and lost. I'm thinking that it could be solved with something like
> > > 
> > >   clock_swaptime(clockid, new_timespec, old_timespec);
> > > 
> > > but something tells me that it will not be welcome either.
> > 
> > What's that time daemon doing? The semantics of updating system time,
> > but stopping to do so when something else sets the time sounds more
> > like a design problem than anything else.
> 
> The daemon's synchronizing system time with various sources like GSM base
> stations, time servers etc, but only until something else touches the time
> in the system, which would basically mean that the user has installed a
> 3rd-party application that's controlling system time or just called `date`.

Well, having several different applications fiddling with
settimeofday() is not a good idea to begin with. If you have that,
then there is no way to avoid races or inconsistencies.

There is no restriction of issuing settimeofday() or clock_settime()
on any standard Linux system other than security_settime(). Which is
fine. When I have the permission to issue 'date -s' then I better know
that I'm screwing over whatever is responsible for maintaining time on
my machine. Same applies for installing applications which fiddle with
time. My package manager usually makes sure, that I don't install two
NTP daemons, but nothing prevents me to launch another one when I'm on
a root shell. If stuff explodes in my face, then I'm to blame nothing
else.

> I don't know all the reasons for this requirement, but it seems that not
> losing time changes to a race is not a bad idea. Of course, if anyone cares.

Unless I'm missing something then this requirement is based on the
wish to shorten the rope with which you can hang yourself, but fails
to make it short enough to prevent it. So what's the point?

Thanks,

	tglx
