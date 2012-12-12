Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2LLVE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:04:56 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:53331 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab2LLVEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:04:54 -0500
Date: Wed, 12 Dec 2012 14:04:43 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] NTP: Add a CONFIG_RTC_SYSTOHC configuration
Message-ID: <20121212210443.GB11530@obsidianresearch.com>
References: <20121212055643.GA18078@obsidianresearch.com>
 <50C8DDAA.5010101@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C8DDAA.5010101@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 11:40:26AM -0800, John Stultz wrote:

> >The option also overrides the call to any platform update_persistent_clock
> >so that the RTC subsystem completely and generically replaces this
> >functionality.
> >
> >Tested on ARM kirkwood and PPC405

> So I'm initially mixed on this, as it feels a little redundant (esp
> given it may override a higher precision arch-specific function).
> But from the perspective of this being a generic RTC function,
> instead of an per-arch implementation, it does seem reasonable.

It isn't really redundant. The kernel still has two RTC subsystems,
'class RTC' and various platform specific
things. update_persisent_clock is the entry for the platform specific
RTC, while rtc_update_persistent_clock is the entry for class RTC.

The issue is on platforms like PPC where both co-exist. On PPC
update_persisent_clock just calls through a function pointer
(set_rtc_time) to the machine description to do whatever that mach
needs. Currently all the PPC mach's that use class RTC drivers via DTS
set set_rtc_time to null. Only the machs that implement a non class
RTC driver provide an implementation.

So it is an either/or case - either rtc_update_persistent_clock works
or update_persistent_clock does, never both.

> >diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> >index 19c03ab..30a866a 100644
> >+++ b/drivers/rtc/Kconfig
> >@@ -48,6 +48,14 @@ config RTC_HCTOSYS_DEVICE
> >  	  sleep states. Do not specify an RTC here unless it stays powered
> >  	  during all this system's supported sleep states.
> >
> >+config RTC_SYSTOHC
> >+	bool "Set the RTC time based on NTP synchronization"
> >+	default y
> >+	help
> >+	  If you say yes here, the system time (wall clock) will be stored
> >+          in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
> >+  	  minutes if the NTP status is synchronized.
> >+
> Nit: Does this need to depend on RTC_HCTOSYS_DEVICE being set?

Yes, it looks like RTC_HCTOSYS_DEVICE should have:
 depends on RTC_SYSTOHC = y

I will correct that

> Hrm. So on architectures that support GENERIC_CMOS_UPDATE already,
> this creates a duplicated code path that is slightly different. I'd
> like to avoid this if possible.  Since you're plugging
> rtc_update_persistent_clock into the GENERIC_CMOS_UPDATE code, we
> can't just have this option depend on !GENERIC_CMOS_UPDATE.

It isn't duplicate, we need to keep update_persistent_clock to support
non-class RTC machines.

I thought about this:

        if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
	        fail = -1;
#ifdef CONFIG_RTC_SYSTOHC
	        fail = rtc_update_persistent_clock(now);
#endif
#ifdef CONFIG_GENERIC_CMOS_UPDATE
                if (fail)
                         fail = update_persistent_clock(now);
#endif
       }

Try the RTC function first, then fall back to the legacy platform
function if it didn't work.

That seems better to me, do you agree?

> So this might need a slightly deeper rework?
> I'd suggest the following:
> 1) Convert GENERIC_CMOS_UPDATE into SUPPORTS_UPDATE_PERSISTENT_CLOCK.
> 2) Add RTC_SYSTOHC but make it depend on !SUPPORTS_UPDATE_PERSISTENT_CLOCK

This would only work for ARM, not PPC..

Ultimately I suspect the clean up needed is to convert more things to
class rtc drivers and remove update_persistent_clock.
ppc is pretty close already, and I think ARM is already there.

Jason
