Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0H1BJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:09:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43170 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab0H1BJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:09:06 -0400
Subject: Re: System time drifts when processor idle.
From: john stultz <johnstul@us.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: jean-philippe francois <jp.francois@cynove.com>, Lin Ming <lin@ming.vg>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
In-Reply-To: <AANLkTi=8MXx9L0+V-JqXoO5PCWq5EPRW9fqpr913OTyC@mail.gmail.com>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	 <AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	 <AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	 <AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	 <AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	 <AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
	 <1282932708.1946.8.camel@work-vm>
	 <AANLkTi=8MXx9L0+V-JqXoO5PCWq5EPRW9fqpr913OTyC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 18:09:01 -0700
Message-ID: <1282957741.1946.27.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 17:10 -0700, Venkatesh Pallipadi wrote:
> On Fri, Aug 27, 2010 at 11:11 AM, john stultz <johnstul@us.ibm.com> wrote:
> > On Fri, 2010-08-27 at 16:12 +0200, jean-philippe francois wrote:
> >> My Timekeeping bug is still present, here is an updated script and log.
> >> I am willing to make test, but I don't know what kind of debugging
> >> info is needed.
> >>
> >> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >> hpet acpi_pm
> >> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >> hpet
> >
> > Huh. hpet was not what I would have expected.
> >
> >
> > So first, two experiments:
> >
> > 1) Does booting with "clock=acpi_pm" cause the issue to disappear?
> >
> > 2) Does booting with "nohz=off" cause the issue to disappear?
> >
> >
> > Venkatesh: You have any experience with HPETs that halt in idle?
> >
> 
> No. Haven't seen anything like this before with HPET.
> 
> The jump was
> 
> system | hardware(RTC)
> 15:48:43 | ven. 27 août 2010 15:48:44 CEST  -0.985908 secondes
> 15:49:04 | ven. 27 août 2010 15:54:04 CEST  -0.032800 secondes
> 
> We lost ~300 seconds and from dmesg
> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> 
> Which is close to 2^32 HPET ticks. So, looks like we have some 32 bit
> wraparound somewhere..

Huh. So you're thinking the timer tick scheduler is pushing way past the
HPET wrap length, and then we're missing an accumulation point and
things wrap under us? 

We have some code to try to limit the nohz length to avoid hardware
wrapping, but honestly I'd be surprised if the system is actually that
idle for that long (no timers firing for 5 minutes? that'd be really
impressive!).

jean-philippe: Is the drift always in 5 minute increments? Can you leave
it idle for 3 minutes and see a similar 3 minute delay, or is it always
in units of 5 ?

thanks
-john



