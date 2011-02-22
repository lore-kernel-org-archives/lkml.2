Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1BVCzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:55:48 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:36621 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1BVCzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:55:46 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: John Stultz <john.stultz@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
In-Reply-To: <20110222023452.GB18299@sirena.org.uk>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 18:55:33 -0800
Message-ID: <1298343333.4222.36.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 02:34 +0000, Mark Brown wrote:
> On Mon, Feb 21, 2011 at 03:55:32PM -0800, John Stultz wrote:
> > With the generic rtc code managing the now virtualized alarm timer,
> > no one actually calls rtc_clas_ops->read_alarm().
> 
> > We do check that it exists in rtc_read_alarm(), but that is only
> > to verify that the hardware supports irqs. The same test can
> > be done by checking set_alarm instead.
> 
> > This patch changes the the read_alarm check to set_alarm, and then
> > removes the read_alarm method and its implementations in the rt
> > drivers.
> 
> Can you go into more detail on the rationale behind this virtualised
> functionality and how it works?  I'd really expect the RTC alarm to be
> preserved over system reboots (on some systems it can be used to
> initiate a boot) and that would mean that we need to go to the hardware
> for at least the initial configuration.

So with respect to the rationale:

The difference with the new code (already in for 2.6.38), is that when
alarms are set via the userland interface, instead of directly
manipulating the hardware, it creates a rtc_timer event that is managed
by the kernel.

The kernel then looks at the list of rtc_timers and sets the RTC for
soonest rtc_timer. When the alarm occurs (possibly waking up the
system), the kernel notifies the waiting userland app and then looks at
the timer list to see if there are any more events to program into the
hardware.

This allows us in the future to multiplex events onto the RTC hardware
from different sources without breaking compatibility.

Right now, if two applications want to set a wake alarm on the RTC ,
they have to coordinate their access to the rtc device (or the machine
has to have multiple RTC devices).

Soon, with my posix alarm timers work, those two applications would be
able to set standard posix timers against CLOCK_REALTIME_ALARM, and the
kernel will manage the RTC hardware to wake the system up for both
application's alarms. No coordination needed.


Now, to your point about persistence across reboots:

It is an interesting point to consider. 

So currently, if the hardware supports it, then the behavior should
remain the same: As long as no application sets a new alarm, the
previous alarm should persist in the RTC hardware.

However, an application's ability to notice that such an alarm is set,
is currently limited.  So your point about reading the hardware to
initialize the state is quite valid, and shows a good reason to preserve
the read_alarm() method. 

Thus, I'll drop this patch for my 2.6.39 queue. And I'll try to fix the
current initialization limitation to ensure applications can detect
alarm persistence.

Thanks for pointing this issue out!
-john


