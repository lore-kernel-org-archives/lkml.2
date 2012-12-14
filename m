Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2LNCih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:38:37 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:46193 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab2LNCig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:38:36 -0500
Date: Thu, 13 Dec 2012 19:38:26 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121214023826.GA31613@obsidianresearch.com>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
 <20121214013725.GA11276@feng-snb>
 <50CA8837.5010800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA8837.5010800@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 06:00:23PM -0800, John Stultz wrote:

> So per Jason's related patch, he's made the point that the
> persistent_clock and RTC class functionality are basically exclusive
> (well, in his case, he said this with respect to updating the RTC,
> not reading it - I don't mean to put words in his mouth - Please do
> correct me here Jason. :).  In other words, we probably should avoid
> configurations where both the rtc hctosys and persistent_clock
> interfaces are both active.

I only studied update_persistent_clock, read_persistent_clock is
very much different.

Looking at it, I don't think that update_persistent_clock is in any
way related to read_persistent_clock..  update_persistent_clock is
*only* called by NTP, and its *only* purpose is to update the RTC with
NTP synchronized time. In many configurations it will never even be
called.

I think update_persistent_clock is badly named, it should be called
platform_save_ntp_time_to_rtc(), keep it divorced from
read_presistent_clock :)

> make the HCTOSYS option be dependent on !HAS_PERSISTENT_CLOCK. This
> way we avoid having configs where there are conflicting paths that
> we chose from.

On ARM the read_presistent_clock is used to access a true monotonic
counter that is divorced from the system RTC - look at
arch/arm/plat-omap/counter_32k.c for instance.

This seems like a great use of that hardware resource, and no doubt
those mach's also have a class RTC driver available talking to
different hardware.

For mach's without that functionality ARM returns a fixed 0 value
from read_persistent_clock, persumably the kernel detects this and
falls back to using class rtc functions?

Maybe Feng would be better off adjusting read_persistent_clock to
return ENODEV in such cases??

So, I think you have to keep your test as a run time test. To support
the single image ARM boot you can't make the distinction with kconfig.

Regards,
Jason
