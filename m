Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1BVUXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:23:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55443 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1BVUXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:23:03 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
In-Reply-To: <20110222200046.GD31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
	 <1298362178.4222.57.camel@work-vm>
	 <20110222181647.GA25569@opensource.wolfsonmicro.com>
	 <1298404268.9215.39.camel@work-vm>
	 <20110222200046.GD31611@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 12:22:54 -0800
Message-ID: <1298406174.9215.71.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 20:00 +0000, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 11:51:08AM -0800, john stultz wrote:
> > On Tue, 2011-02-22 at 10:16 -0800, Mark Brown wrote:
> 
> > > The WM83xx RTCs can do this (the alarm can be used to initiate a boot)
> > > and I'd expect many embedded RTC controllers can do similar.  The
> > > application would manage this by owning the RTC in the system, usually
> > > with a configuration saying something like "boot every day at 7am" or
> > > something.
> 
> > So since the RTC_ALM_SET doesn't support wildcards, the application
> > would be checking the hardware at least once a day and making sure the
> > alarm was properly set for 7am?
> 
> Probably, yes.  Though some RTCs just ignore the day anyway.
> 
> > Does the approach I mentioned in my last mail to Marcelo sound like a
> > reasonable solution?
> 
> > Basically: The kernel will try to init the value returned from
> > RTC_ALM_READ to whatever the hardware has stored, but since many (very
> > common) rtc devices don't support persistent values after reset,
> > applications shouldn't trust that alarms will persist across resets.
> 
> That'll probably work, yes.

Good to hear!  Thanks again for bringing this issue up. 


> > > Having thought about this a bit I'm thinking that this sort of alarm
> > > handling is probably something I'd expect to see handled in userspace.
> > > I can see us providing a virtual RTC driver that can generate alarms
> > > when there's no actual RTC hardware but adding additional functionality
> > > on top of the hardware feels like an application issue.
> 
> > If you're suggesting that the multiplexing of RTC events doesn't belong
> > in the kernel, and instead should be handled through userland
> > coordination, then I disagree. The kernel's job is explicitly to
> > abstract the hardware so that resources can be shared safely. So
> > abstracting the RTC alarms doesn't seem to be overreaching. But maybe
> > I'm misunderstanding what your saying?
> 
> I'm saying that for something like this it doesn't seem like the kernel
> should be adding support for features that the hardware doesn't actually
> have, it feels like it's going to be more complicated and error prone to
> implement in kernel space.

So yes, its a little split here.  On one hand, if the hardware doesn't
support alarms, we don't pretend it does. 

On the other, we have to preserve the existing behavior, so some things
had to be emulated. For example, I wouldn't have exposed the periodic
irq mode to userland. It simply duplicates existing functionality in the
kernel (ie: periodic timers). But since it has been exposed, to keep
compatibility I ended up emulating it using the kernel functionality it
duplicates.

In some ways it does complicate things, but in others it greatly
simplifies it. You don't have to have 80 drivers each implementing their
own code to set a mode that isn't used. Everyone is using the common
kernel code, so bugs are shared and thus found and fixed faster.
Features can be more easily added, as the limitations of specific
hardware have to be more formally expressed, rather then having to
change 80 drivers that opaquely work around their specific hardware
issues. Also, applications are easier to port, since there are less
platform specific differences.

I do agree that its not always optimal, but sometimes it is necessary if
we want to overcome the limits of earlier design decisions without
breaking applications.

thanks
-john


