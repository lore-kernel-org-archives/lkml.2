Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0FBIa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:30:28 -0400
Received: from www.tglx.de ([62.245.132.106]:48254 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0FBIaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:30:25 -0400
Date: Wed, 2 Jun 2010 10:29:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Florian Mickler <florian@mickler.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005302202.39511.rjw@sisk.pl> <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com> <201005312347.24251.rjw@sisk.pl> <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
 <alpine.LFD.2.00.1006011411200.2933@localhost.localdomain> <AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-3244195-1275462694=:2933"
Content-ID: <alpine.LFD.2.00.1006020922080.2933@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-3244195-1275462694=:2933
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1006020922081.2933@localhost.localdomain>

On Tue, 1 Jun 2010, Arve Hjønnevåg wrote:
> 2010/6/1 Thomas Gleixner <tglx@linutronix.de>:
> > On Mon, 31 May 2010, Arve Hjønnevåg wrote:
> >
> >> 2010/5/31 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Monday 31 May 2010, Arve Hjønnevåg wrote:
> >> >> 2010/5/30 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > ...
> >> >>
> >> >> I think it makes more sense to block suspend while wakeup events are
> >> >> pending than blocking it everywhere timers are used by code that could
> >> >> be called while handling wakeup events or other critical work. Also,
> >> >> even if you did block suspend everywhere timers where used you still
> >> >> have the race where a wakeup interrupt happens right after you decided
> >> >> to suspend. In other words, you still need to block suspend in all the
> >> >> same places as with the current opportunistic suspend code, so what is
> >> >> the benefit of delaying suspend until idle?
> >> >
> >> > Assume for a while that you don't use suspend blockers, OK?  I realize you
> >> > think that anything else doesn't make sense, but evidently some other people
> >> > have that opinion about suspend blockers.
> >> >
> >>
> >> It sounded like you were suggesting that initiating suspend from idle
> >> would somehow avoid the race condition with wakeup events. All I'm
> >> saying is that you would need to block suspend in all the same places.
> >> If you don't care about ignoring wakeup events, then sure you can
> >> initiate suspend from idle.
> >
> > And why should you miss a wakeup there ? If you get an interrupt in
> > the transition, then you are not longer idle.
> >
> 
> Because suspend itself causes you to not be idle you cannot abort
> suspend just because you are not idle anymore.

You still are addicted to the current suspend mechanism. :)

The whole point of doing it from idle in the form of a deep power
state is to avoid the massive sh*tload of work which is neccesary to
run the existing suspend code. But that needs runtime power management
and tweaks to avoid your timers waking you, etc.

The mechanism you want to use is: suspend no matter what, like closing
the lid of the laptop, but with a few tweaks around it:

   1) An interrupt on a wakeup source which comes in while the suspend
      code runs, i.e before you transitioned into wakeup mode, must
      abort / prevent suspend.

   2) Prevent another attempt to suspend before the event has been
      delivered and the apps have signaled that they have not longer
      any work to do.

   As a side effect you confine crappy apps with that mechanism in
   some way.

In the laptop case we do not want the tweaks as not going into suspend
might set your backpack on fire.

If I understood you correctly then you can shutdown the CPU in idle
completelty already, but that's not enough due to:

    1) crappy applications keeping the cpu away from idle
    2) timers firing

Would solving those two issues be sufficient for you or am I missing
something ?

Thanks,

	tglx
--8323328-3244195-1275462694=:2933--
