Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1EFCSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 22:18:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52580 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1EFCSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 22:18:49 -0400
Subject: Re: [GIT pull] rtc fixes for 2.6.39
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <alpine.LFD.2.02.1105060124440.3005@ionos>
References: <1304624059.20980.10.camel@work-vm>
	 <alpine.LFD.2.02.1105060124440.3005@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 19:18:39 -0700
Message-ID: <1304648319.20980.100.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 02:23 +0200, Thomas Gleixner wrote:
> On Thu, 5 May 2011, john stultz wrote:
> 
> > Hey Thomas,
> > 	Here are some urgent 2.6.39 boot fixups from Wolfram for RTC devices
> > that register themselves before they are finished initializing.
> > 
> > They are available in the git repository at:
> > 
> >   git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc
> > 
> > Wolfram Sang (3):
> >       rtc: mxc: fix crash on boot
> >       rtc: davinci: fix crash on boot
> >       rtc: ep93xx: fix crash on boot
> 
> No. I'm not pulling that. The changelogs are completely ass backwards.
> 
>     rtc: $machine: fix crash on boot
> 
> "fix crash on boot" is equally informative as "Fix bug". It's not
> informative at all, it's just sloppy.
> 
>     rtc: $machine: Initialize driver data before registering device
> 
> would tell me: Yes, that's an obvious late -rc fix.
> 
>     Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") caused a
>     crash when initializing the driver.
> 
> That's totally misleading. The reality is that the stupid drivers
> registered their device _BEFORE_ completing the initialization of the
> setup and that commit unearthed that. So not the commit caused the
> problem, the problem was there forever and was not noticed because the
> register code did not touch any of the non initialized data up to that
> point.
> 
>     The reason is that rtc_device_register() calls rtc_read_alarm() after
>     that change, when the driver does not have all driver data set up yet.
> 
> And that's just the continuation of the distorted reality.
> 
> The reason is that the f*cking driver did register the device _BEFORE_
> initializing the relevant data structures and that commit unearthed
> the crap.
> 
> It does _NOT_ matter at all whether this worked before by chance. The
> ordering is and _WAS_ always completely wrong.

Yea. Sorry about this. I got caught up in the "A change I made keeps
systems from booting" view of it and rushed it a bit.

I'll work with Wolfram to get the subject/commit messages cleaned up.

> As a side note, this is not the first fallout of the RTC rework which
> unearthed these wrong order initialization problems. The obvious
> reaction on the first "fix ordering problems" patch should have been
> to add
> 
> 	if (driver data == NULL) {
> 		printk("Fix your crap\n");
> 		return -EMORON;}
> 	}
> 
> to rtc_device_register().

Well, unfortunately the various rtc drivers use the drvdata differently.
Some store indirection structures (which are the problematic case),
while others just store the rtc pointer returned from
rtc_device_register.

Regardless, I'll be going through doing an audit by hand to try to make
sure all the rtc drivers are looking correct.

thanks
-john

