Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0EaJQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:16:47 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:48259 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab0EaJQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:16:46 -0400
MIME-Version: 1.0
In-Reply-To: <201005302202.39511.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005292227.15479.rjw@sisk.pl>
	<AANLkTim6zsho4RSrseJostaOJe9lL4VNRKA3vDGJWJhK@mail.gmail.com>
	<201005302202.39511.rjw@sisk.pl>
Date: Mon, 31 May 2010 02:16:45 -0700
Message-ID: <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Florian Mickler <florian@mickler.org>,
       Thomas Gleixner <tglx@linutronix.de>,
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

2010/5/30 Rafael J. Wysocki <rjw@sisk.pl>:
> On Saturday 29 May 2010, Arve Hjønnevåg wrote:
>> 2010/5/29 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Saturday 29 May 2010, Arve Hjønnevåg wrote:
>> >> 2010/5/28 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > On Friday 28 May 2010, Arve Hjønnevåg wrote:
>> >> >> On Fri, May 28, 2010 at 1:44 AM, Florian Mickler <florian@mickler.org> wrote:
>> >> >> > On Thu, 27 May 2010 20:05:39 +0200 (CEST)
>> >> >> > Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> > ...
>> >> >> > To integrate this with the current way of doing things, i gathered it
>> >> >> > needs to be implemented as an idle-state that does the suspend()-call?
>> >> >> >
>> >> >>
>> >> >> I think it is better no not confuse this with idle. Since initiating
>> >> >> suspend will cause the system to become not-idle, I don't think is is
>> >> >> beneficial to initiate suspend from idle.
>> >> >
>> >> > It is, if the following two conditions hold simultaneously:
>> >> >
>> >> > (a) Doing full system suspend is ultimately going to bring you more energy
>> >> >    savings than the (presumably lowest) idle state you're currently in.
>> >> >
>> >> > (b) You anticipate that the system will stay idle for a considerably long time
>> >> >    such that it's worth suspending.
>> >> >
>> >>
>> >> I still don't think this matters. If you are waiting for in interrupt
>> >> that cannot wake you up from suspend, then idle is not an indicator
>> >> that it is safe to enter suspend. I also don't think you can avoid any
>> >> user-space suspend blockers by delaying suspend until the system goes
>> >> idle since any page fault could cause it to go idle. Therefore I don't
>> >> see a benefit in delaying suspend until idle when the last suspend
>> >> blocker is released (it would only mask possible race conditions).
>> >
>> > I wasn't referring to suspend blockers, but to the idea of initiating full
>> > system suspend from idle, which I still think makes sense.  If you are
>> > waiting for an interrupt that cannot wake you from suspend, then
>> > _obviously_ suspend should not be started.  However, if you're not waiting for
>> > such an interrupt and the (a) and (b) above hold, it makes sense to start
>> > suspend from idle.
>> >
>>
>> What about timers? When you suspend timers stop (otherwise it is just
>> a deep-idle mode), and this could cause problems. Some drivers rely on
>> timers if the hardware does not have a completion interrupt. It is not
>> uncommon to see send command x then wait 200ms in a some hardware
>> specs.
>
> QoS should be used in such cases.
>

I think it makes more sense to block suspend while wakeup events are
pending than blocking it everywhere timers are used by code that could
be called while handling wakeup events or other critical work. Also,
even if you did block suspend everywhere timers where used you still
have the race where a wakeup interrupt happens right after you decided
to suspend. In other words, you still need to block suspend in all the
same places as with the current opportunistic suspend code, so what is
the benefit of delaying suspend until idle?

-- 
Arve Hjønnevåg
