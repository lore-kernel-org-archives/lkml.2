Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1LIS43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:56:29 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53955 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1LIS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:56:27 -0500
Message-ID: <1323456919.4078.23.camel@work-vm>
Subject: Re: Improved TSC calculation
From: john stultz <johnstul@us.ibm.com>
To: Ed W <lists@wildgooses.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 09 Dec 2011 10:55:19 -0800
In-Reply-To: <4EE206AC.6060800@wildgooses.com>
References: <4DA6D85A.8000800@wildgooses.com>
	 <1302805253.2673.17.camel@work-vm> <4EE206AC.6060800@wildgooses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120918-9360-0000-0000-000001628FF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 13:01 +0000, Ed W wrote:
> On 14/04/2011 19:20, john stultz wrote:
> > On Thu, 2011-04-14 at 12:19 +0100, Ed W wrote:
> >> Hi, Thanks for the new stable TSC calculation commit
> >> (08ec0c58fb8a05d3191d5cb6f5d6f81adb419798).
> >>
> >> My situation is that I don't have a PM or HPET timer (x86 Alix board),
> >> and my requirements are embedded type use, but with only intermittently
> >> connected network/gps, so accurate timekeeping between reboots is
> >> important.
> >>
> >> I had been experimenting with extending the existing PIT timer routines
> >> at boot, but I had the problem that it was taking 1s+ to get a very
> >> stable calculation (which is undesirable for my requirements), however,
> >> having spotted your commit it seems like a much more sensible solution.
> > Thanks!
> >
> >> Before I try and hack probably an (inadequate) solution myself, do you
> >> have any thoughts on the best solution to extend your commit to non
> >> PM/HEPT machine?  My initial thought was to repeatedly call
> >> pit_calibrate_tsc() with an extended latch, looking for a stable
> >> solution (ie refactor native_calibrate_tsc() ).  Is this workable?
> >> Better ideas?
> > Oof. So with the PIT you can maybe utilize the second channel/counter,
> > using a largish long countdown to try to get a similar functionality.
> > The only big concern is that the timer interrupt hardware is always
> > problematic (every time we chanage our usage, some random chunk of
> > laptops seem to stop working). So whatever solution that works for you
> > might not be able to be generically deployed. But I think it could be
> > interesting and might be worth you giving it a shot.
> >
> > I'd probably look at reworking tsc_refine_calibration_work, extending
> > the tsc_read_refs() code to also get PIT count values and then start the
> > long PIT countdown on the second channel before we
> > schedule_delayed_work.
> >
> > thanks
> > -john
> >
> 
> Hi John
> 
> I don't suppose you ever gave any thought to looking into this
> yourself... :-)
> 
> I have had a poke, but I'm way out of my depth trying to figure out a
> good solution. 
> 
> For reference my goal was to get a stable TSC calculation for my
> PCEngines Alix boards, which are basically popular, low cost x86
> compatible boards, but without HPET or PM.  I rather want to use them as
> way to get more reliable Stratum 1 NTP servers out in the wild -
> hopefully by documenting them as a very low cost solution to pair with a
> GPS.  Having them somewhat clock stable with respect to reboot would be
> handy

So, I guess what have you tried and where have you run into troubles?

I really don't have too much time to dig in on this particular issue,
but I'd suggest looking at pit_calibrate_tsc() in arch/x86/kernel/tsc.c
and considering how it might be extended to better improve accuracy.

So part of the difficulty with a timer based approach, is that the PIT's
lowest freq is something like 18hz, which is ~50ms. So you can't really
get a very good sampling interval over that time.

You might be able to do something funky where you set a timer for 1
second out, and sample the PIT/TSC combo, and then sample it again when
the timer fires, and knowing how many times the PIT should have wrapped,
you could probably get a sense of the TSC freq. However, I worry that
might be a bit fragile.

If you're looking for info on how to program the PIT, check out the
wikipedia page and the external links from:
	http://en.wikipedia.org/wiki/Intel_8253

Sorry I've not been of much help here! Let me know if you have any
patches you want me to look at or have any more concrete questions.

thanks
-john


