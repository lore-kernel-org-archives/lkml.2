Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1BVWKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:10:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40051 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1BVWKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:10:39 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
In-Reply-To: <20110222213319.GI31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
	 <1298362178.4222.57.camel@work-vm>
	 <20110222181647.GA25569@opensource.wolfsonmicro.com>
	 <1298404268.9215.39.camel@work-vm>
	 <20110222200046.GD31611@opensource.wolfsonmicro.com>
	 <1298406174.9215.71.camel@work-vm>
	 <20110222210522.GG31611@opensource.wolfsonmicro.com>
	 <1298409673.9215.84.camel@work-vm>
	 <20110222213319.GI31611@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 14:10:34 -0800
Message-ID: <1298412634.9215.110.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 21:33 +0000, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 01:21:13PM -0800, john stultz wrote:
> 
> > But if you just mean trying to keep multiple alarms scheduled across
> > resets, I don't think that is something we can emulate (since the kernel
> > doesn't have any other persistent storage). But due to the lack of
> > consistency in RTC hardware, I don't think its a reasonable expectation
> > for applications to have.
> 
> I'm saying that I've got concerns about providing that functionality at
> all as it's going to be a pure software at runtime thing - the kernel
> can't do anything here that userspace couldn't already do and there are
> things that userspace can do that the kernel can't.  If the hardware
> could do it then great but otherwise it feels like you'd be better off
> with a program in userspace owning the hardware and dealing with the
> resource contention.

So to be sure I understand: the concern is that because the kernel can't
keep a persistent list of events across resets, while userland can (via
a file), it would be better to do multiplexing of alarm events via
userland coordination (maybe having something like a daemon that "owns"
the RTC device and handles events over dbus or something) instead of in
the kernel.

It is an interesting point.  And that would avoid the loss of the event
list across a system restart.

Although For me, I see multiplexing events becoming too useful a bit of
functionality to offload to a userland API. Especially since there might
be conflicting approaches to the userland coordination (Want to open a
file? There's one call you have to make. Want to draw a on the screen?
Well, there's X or fb or maybe wayland, etc). 

Further, because the existing interface isn't sharable, any legacy
application that requires the RTC could block the usage by any new
userland coordination framework. Similarly if the coordination framework
is being used, the legacy applications cannot function. Should there be
competing userland coordination frameworks, then the would be exclusive
and apps that used one wouldn't work on the other.

The benefit to the in-kernel approach is that it provides the addtional
functionality, but it also preserves the legacy interface. And even
better, it doesn't prevent such a userland-coordination method to be
used either (the legacy interface, or even via new interfaces like the
posix alarm timers).

Now, your observation about the behavior of persistence over reboots is
a interesting corner-case that I overlooked. And I do want to address
that as best we can, but I think it is an unreasonable expectation for
applications to have, given that much common hardware doesn't support
it.

thanks
-john



