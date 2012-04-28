Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2D1IsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:48:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59797 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2D1IsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:48:05 -0400
Date: Sat, 28 Apr 2012 10:47:51 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 4/5] timekeeping: Offer an interface to
 manipulate leap seconds.
Message-ID: <20120428084751.GB2241@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <52e139c98370c405288cbbb4ac76c435dc36731f.1335510125.git.richardcochran@gmail.com>
 <4F9B26D3.1030100@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B26D3.1030100@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:08:03PM -0700, John Stultz wrote:
> On 04/27/2012 01:12 AM, Richard Cochran wrote:
> >+	/* The Kernel Time Scale (KTS) value of the next leap second. */
> >+	time_t next_leapsecond;
> 
> I'm not a big fan of this new Kernel Time Scale. I don't think we
> really need a new time domain, and it only muddles things.
> Why not have next_leapsecond be specified in CLOCK_MONOTONIC time?

I agree that the monotonic could be used as the basis, but I didn't
want to muck around with it just yet. This is only a RFC.
 
> >+	/* The current difference KTS - UTC. */
> >+	int kts_utc_offset;
> >+	/* The current difference TAI - KTS. */
> >+	int tai_kts_offset;
> Again, get rid of KTS and we can simplify these as:
> CLOCK_TAI = CLOCK_MONOTONIC + mono_to_tai;
> UTC/CLOCK_REALTIME = CLOCK_TAI + utc_offset;
> 
> This basically requires changing the timekeeping core from keeping
> track of CLOCK_REALTIME as its time base, and instead having it use
> CLOCK_MONOTONIC. This actually is something I proposed a long time
> ago, but was deferred because folks were concerned that the extra
> addition would slow gettimeofday() down.  However, that was back
> when everything internally used jiffies. These days ktime_get() is
> probably called internally more frequently, and so optimizing for
> CLOCK_MONOTONIC makes sense.

Yes, that is really the basic idea.

> >+#ifdef CONFIG_DELETE_LEAP_SECONDS
> >+	/* Remembers whether to insert or to delete. */
> >+	int insert_leapsecond;
> >+#endif
> 
> I'm not a big fan of this additional config option.  The maintenance
> burden for the extra condition is probably not worth the code size
> trade-off.  Or it needs way more justification.

Well, if people are wanting a fast gettimeofday, then they will want
this, too.

Furthermore, the extra code for deletion is dead code. It has never
been put to the test. It never, ever, gets called, and never will.
(Have you ever tested the current code?  Does it do the deletion
correctly?) Earth is decelerating. It is a scientific fact, almost as
certain as global warming.

[ Can't resist this quote from: "UTC is doomed" ]

  http://www.ucolick.org/~sla/leapsecs/HTMLutcdoomed.html

  If global warming causes the ice caps to melt then the deceleration
  will be somewhat larger.  If melting ice caps shut down the Gulf
  Stream and cause a new ice age then the deceleration could be
  somewhat smaller.  If a supervolcano erupts or asteroid strikes, all
  bets are off.

At first I had planned to not implement deletion at all, but I added
the option just to appease anyone who might protest, "but it is
standardized! NTP can do this!" So, if no option, then I would rather
just not offer deletion at all.

> >+static int __init tai_offset_setup(char *str)
> >+{
> >+	get_option(&str,&timekeeper.kts_utc_offset);
> >+	return 1;
> >+}
> >+__setup("tai_offset=", tai_offset_setup);
> >+
> Oooof.. Yuck.  I really don't like the boot time tai_offset
> argument. What sysadmin wants to change their grub settings after a
> leapsecond so that the next reboot its set properly?

One who cares about telling correct time?

Grub is not the only bootloader, but even so, if I admin a 24x7
critical system, and I have to do a planned reboot, then I surely will
want to update the grub.conf before rebooting. Or it would be enough
to check it once every six months according to a routine maintainance
schedule.

> I'd suggest tai_offset be set to zero until userland updates it at
> boot time.  CLOCK_TAI is not CLOCK_MONOTONIC, and it can jump around
> if the user calls settimeofday(), so I don't see a major reason for
> it to be initialized via a boot argument.

The reason is that it gives careful admins the possibility to have
time based services immediately working after boot. It should not be a
"must" to wait for the network. Starting with zero mandates that the
network is always present, but I think it smarter to allow for an
outage.

> Its true that right now there's no userland infrastructure to set it
> (other then ntp, but I've never verified it actually gets set), but
> there also aren't any users consuming it either.

Later on, there will be users.

I think it quite reasonable to expect that (once we offer a rational
time base) time sensitive systems will store the offset automatically.
There are lots of ways to do this, like bootloader config files, NVRAM
in an RTC, flash parameter sections, and so on.

Thanks,
Richard
