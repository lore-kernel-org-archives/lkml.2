Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab0KQAzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:55:20 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51597 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab0KQAzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:55:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ak2wc17LUSeUbkI3cixixKL8rgfNwc6q4pzYcZTNLcEnC4kC30HeXe6C+a+z1+Qavx
         +ytCogBZf1QnzLMK0NrSZG8rrD1abxxG1at9i0auyDfST/KdLvsi9X9CojQ1Jtsn6ma/
         RpBvBAE2+RJxcITaqrXP52vgAfBT4TQYQ52Xo=
MIME-Version: 1.0
In-Reply-To: <1289953570.3860.34.camel@localhost.localdomain>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
 <1289605221.3292.53.camel@localhost.localdomain> <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
 <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
 <1289607722.3292.84.camel@localhost.localdomain> <1289609931.3292.87.camel@localhost.localdomain>
 <AANLkTim27c_pHpawoGw3VyV9qQAF_8twJPTr5kqt6jhW@mail.gmail.com> <1289953570.3860.34.camel@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 16 Nov 2010 19:54:56 -0500
X-Google-Sender-Auth: tLgR6fQgFD1saxN5yFZhWCWOa4c
Message-ID: <AANLkTiks_8sjStgGnTGVj-3UemDqP4G8hZuUDhngZhij@mail.gmail.com>
Subject: Re: [PATCH] Improve clocksource unstable warning
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 7:26 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2010-11-16 at 19:05 -0500, Andrew Lutomirski wrote:
>> On Fri, Nov 12, 2010 at 7:58 PM, john stultz <johnstul@us.ibm.com> wrote:
>> > On Sat, 2010-11-13 at 00:22 +0000, john stultz wrote:
>> >> On Fri, 2010-11-12 at 18:51 -0500, Andrew Lutomirski wrote:
>> >> > Also wrong if cs_elapsed is just slightly less than wd_wrapping_time
>> >> > but the wd clocksource runs enough faster that it wrapped.
>> >>
>> >> Ok. Good point, that's a problem. Hrmmmm. Too much math for Friday. :)
>> >
>> > I have a hard time leaving things alone. :)
>> >
>> > So this still has the issue of the u64%u64 won't work on 32bit systems,
>> > but I think once I rework the modulo bit the following should be what
>> > you were describing.
>> >
>> > It is ugly, so let me know if you have a cleaner way.
>> >
>>
>> I'm playing with this stuff now, and it looks like my (invariant,
>> constant, single-package i7) TSC has a max_idle_ns of just over 3
>> seconds.  I'm confused.
>
> Yea. I hit this wall the other day as well. So my patch is invalid
> because its assuming the TSC deltas will be large, but for any
> unreasonable delay, we'll actually end up with multiply overflows,
> causing the tsc ns interval to be invalid as well.
>
> I'm starting to think we should be pushing the watchdog check into the
> timekeeping accumulation loop (or have it hang off of the accumulation
> loop).
>
> 1) The clocksource cyc2ns conversion code is built with assumptions
> linked to how frequently we accumulate time via update_wall_time().
>
> 2) update_wall_time() happens in timer irq context, so we don't have to
> worry about being delayed. If an irq storm or something does actually
> cause the timer irq to be delayed, we have bigger issues.

That's why I hit this.  It would be nice if we didn't respond to irq
storms by calling stop_machine.

>
> The only trouble with this, is that if we actually push the max_idle_ns
> out to something like 10 seconds on the TSC, we could end up having the
> watchdog clocksource wrapping while we're in nohz idle.  So that could
> be ugly. Maybe if the current clocksource needs the watchdog
> observations, we should cap the max_idle_ns to the smaller of the
> current clocksource and the watchdog clocksource.
>

What would you think about implementing non-overflowing
clocksource_cyc2ns on architectures that can do it efficiently?  You'd
have to artificially limit the mask to 2^64 / (rate in GHz), rounded
down to a power of 2, but that shouldn't be a problem for any sensible
clocksource.

x86_64 can do it with one multiply, two shifts, an or, and a subtract
(to figure out the shifts).  It should take just a couple cycles
longer than the current code (or maybe the same amount of time,
depending on how good the CPU is at running the whole thing in
parallel).
x86_32 and similar architectures would need two multiplies and one add.
Architectures with only 32x32->32 multiply would need three
multiplies.  (They're already presumably doing two multiplies with the
current code, though.)

The benefit would be that sensible clocksources (TSC and 64-bit HPET)
would essentially never overflow and multicore systems could keep most
cores asleep for as long as they liked.

(There's yet another approach: keep the current clocksource_cyc2ns,
but add an exact version and only use it when waking up from a long
sleep.)

--Andy
