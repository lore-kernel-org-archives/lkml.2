Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1EFAXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:23:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:50948 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1EFAXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:23:32 -0400
Date: Fri, 6 May 2011 02:23:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [GIT pull] rtc fixes for 2.6.39
In-Reply-To: <1304624059.20980.10.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1105060124440.3005@ionos>
References: <1304624059.20980.10.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, john stultz wrote:

> Hey Thomas,
> 	Here are some urgent 2.6.39 boot fixups from Wolfram for RTC devices
> that register themselves before they are finished initializing.
> 
> They are available in the git repository at:
> 
>   git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc
> 
> Wolfram Sang (3):
>       rtc: mxc: fix crash on boot
>       rtc: davinci: fix crash on boot
>       rtc: ep93xx: fix crash on boot

No. I'm not pulling that. The changelogs are completely ass backwards.

    rtc: $machine: fix crash on boot

"fix crash on boot" is equally informative as "Fix bug". It's not
informative at all, it's just sloppy.

    rtc: $machine: Initialize driver data before registering device

would tell me: Yes, that's an obvious late -rc fix.

    Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") caused a
    crash when initializing the driver.

That's totally misleading. The reality is that the stupid drivers
registered their device _BEFORE_ completing the initialization of the
setup and that commit unearthed that. So not the commit caused the
problem, the problem was there forever and was not noticed because the
register code did not touch any of the non initialized data up to that
point.

    The reason is that rtc_device_register() calls rtc_read_alarm() after
    that change, when the driver does not have all driver data set up yet.

And that's just the continuation of the distorted reality.

The reason is that the f*cking driver did register the device _BEFORE_
initializing the relevant data structures and that commit unearthed
the crap.

It does _NOT_ matter at all whether this worked before by chance. The
ordering is and _WAS_ always completely wrong.

And you can deduce something important here:

    While the patch itself is correct, the changelog shows that the
    fix is just mechanical and not backed by the required semantical
    understanding of the problem.

It does not matter whether you fix it yourself or preferrbably push
back hard on folks who send you obvious crappy changelogs. That
depends on the situation and the person you're dealing with.

As a side note, this is not the first fallout of the RTC rework which
unearthed these wrong order initialization problems. The obvious
reaction on the first "fix ordering problems" patch should have been
to add

	if (driver data == NULL) {
		printk("Fix your crap\n");
		return -EMORON;}
	}

to rtc_device_register().

Thanks,

	tglx
