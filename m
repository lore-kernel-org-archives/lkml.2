Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0IQNw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:52:59 -0400
Received: from www.tglx.de ([62.245.132.106]:35191 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0IQNw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:52:58 -0400
Date: Fri, 17 Sep 2010 15:52:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kyle Moffett <kyle@moffetthome.net>
cc: Alexander Shishkin <virtuoso@slind.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv5 0/7] system time changes notification
In-Reply-To: <AANLkTin2T3XX0b5ezzCvLvQiu0qg_KWfTSTaATHZmMk=@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1009171518500.2416@localhost6.localdomain6>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org> <alpine.LFD.2.00.1009171452270.2416@localhost6.localdomain6> <AANLkTin2T3XX0b5ezzCvLvQiu0qg_KWfTSTaATHZmMk=@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010, Kyle Moffett wrote:
> On Fri, Sep 17, 2010 at 08:57, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 17 Sep 2010, Alexander Shishkin wrote:
> > > Consider we want stuff like "wakeup every day at 3pm", the next wakeup
> > > might be earlier than the timer we calculated last time, on system
> > > time changes. We need to re-calculate it. This is necessary for all
> > > repeating events.
> > >
> > > Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
> > > hours. Now the system time changes to 2pm, and we would expect to
> > > wakeup in one hour, but we take 25.
> >
> > And that's why we have posix-timers with the ability to arm absolute
> > timers. They already deal with the clock being set.
> >
> > man timer_settime
> >
> 
> This still doesn't help with the specified use-case.  For example, consider
> the case of configuring my crontab to run a command every day at 2PM.
> 
> Let's assume that I then start the cron daemon at 2:05PM, and it establishes
> an absolute timer at 2PM the following day.
>
> I then realize that the clock is wrong, and correct it to read 1:55PM.
> 
> The problem is... cron's timer is still set to trigger at 2PM *tomorrow*,
> instead of being readjusted at the time the clock is changed to go off at
> 2PM *today*.
> 
> Right now there's really no way to fix that other than polling every so
> often to recheck the system time is what you expect.

Hmm, ok.

So what you really want is a timer which drops back to user space with
an appropriate error code when something fiddled with the clock.

That's reasonably easy to implement as an extension at least for
clock_nanosleep. For the signal based timers it'd be probably quite
nasty, but doable.

Thanks,

	tglx
