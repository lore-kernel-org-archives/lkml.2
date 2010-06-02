Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0FBIyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:54:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48208 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0FBIyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
Date: Wed, 2 Jun 2010 01:54:38 -0700
Message-ID: <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Florian Mickler <florian@mickler.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/2 Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 1 Jun 2010, Arve Hjønnevåg wrote:
>> 2010/6/1 Thomas Gleixner <tglx@linutronix.de>:
>> > On Mon, 31 May 2010, Arve Hjønnevåg wrote:
>> >
>> >> 2010/5/31 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > On Monday 31 May 2010, Arve Hjønnevåg wrote:
>> >> >> 2010/5/30 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > ...
>> >> >>
>> >> >> I think it makes more sense to block suspend while wakeup events are
>> >> >> pending than blocking it everywhere timers are used by code that could
>> >> >> be called while handling wakeup events or other critical work. Also,
>> >> >> even if you did block suspend everywhere timers where used you still
>> >> >> have the race where a wakeup interrupt happens right after you decided
>> >> >> to suspend. In other words, you still need to block suspend in all the
>> >> >> same places as with the current opportunistic suspend code, so what is
>> >> >> the benefit of delaying suspend until idle?
>> >> >
>> >> > Assume for a while that you don't use suspend blockers, OK?  I realize you
>> >> > think that anything else doesn't make sense, but evidently some other people
>> >> > have that opinion about suspend blockers.
>> >> >
>> >>
>> >> It sounded like you were suggesting that initiating suspend from idle
>> >> would somehow avoid the race condition with wakeup events. All I'm
>> >> saying is that you would need to block suspend in all the same places.
>> >> If you don't care about ignoring wakeup events, then sure you can
>> >> initiate suspend from idle.
>> >
>> > And why should you miss a wakeup there ? If you get an interrupt in
>> > the transition, then you are not longer idle.
>> >
>>
>> Because suspend itself causes you to not be idle you cannot abort
>> suspend just because you are not idle anymore.
>
> You still are addicted to the current suspend mechanism. :)
>

No I want you to stop confusing low power idle modes with suspend. I
know how to enter low power modes from idle if that low power mode is
not too disruptive.

> The whole point of doing it from idle in the form of a deep power
> state is to avoid the massive sh*tload of work which is neccesary to
> run the existing suspend code. But that needs runtime power management
> and tweaks to avoid your timers waking you, etc.
>
> The mechanism you want to use is: suspend no matter what, like closing
> the lid of the laptop, but with a few tweaks around it:
>
>   1) An interrupt on a wakeup source which comes in while the suspend
>      code runs, i.e before you transitioned into wakeup mode, must
>      abort / prevent suspend.
>
>   2) Prevent another attempt to suspend before the event has been
>      delivered and the apps have signaled that they have not longer
>      any work to do.
>
>   As a side effect you confine crappy apps with that mechanism in
>   some way.
>
> In the laptop case we do not want the tweaks as not going into suspend
> might set your backpack on fire.

If that is the case you should also disable the wakeup events.

>
> If I understood you correctly then you can shutdown the CPU in idle
> completelty already, but that's not enough due to:
>
>    1) crappy applications keeping the cpu away from idle
>    2) timers firing
>
> Would solving those two issues be sufficient for you or am I missing
> something ?

Solving those two is enough for current android phones, but it may not
be enough for other android devices. 1 is not solvable (meaning we
cannot fix all apps), and 2 is difficult to fix since the periodic
work is useful while the device is actually in use. One possible way
to solve 2 is to allow timers on a not-idle clock. Unrelated to
Android, I also want to use opportunistic suspend on my desktop.

-- 
Arve Hjønnevåg
