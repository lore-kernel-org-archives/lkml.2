Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2LNV5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:57:04 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:46436 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab2LNV5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:57:02 -0500
Date: Fri, 14 Dec 2012 14:56:51 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121214215651.GA31384@obsidianresearch.com>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
 <20121214013725.GA11276@feng-snb>
 <50CA8837.5010800@linaro.org>
 <20121214023826.GA31613@obsidianresearch.com>
 <20121214031330.GC11276@feng-snb>
 <20121214041024.GA1040@obsidianresearch.com>
 <50CB98AA.5090600@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CB98AA.5090600@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 01:22:50PM -0800, John Stultz wrote:

> Although from a timekeeping perspective, the read_persistent_clock()
> interface is actually *much* preferred over the rtc HCTOSYS device.
> 
> Since read_persistent_clock() has the requirement that its safe to
> call with IRQs disabled, we can use it in the timekeeping
> suspend/resume code, which allows for better time accuracy.

Sure, but my view on this is that it has nothing to do with
read_persistent_clock. If the RTC driver can run with IRQs off is a
property of the RTC driver and RTC hardware - it has nothing to do
with the platform. ARM platforms will vary on a machine by machine
basis. The rtc-mv driver used on my ARM system is perfectly
re-entrant, lots of rtc on SOC drivers will be the same.

If this is the only thing keeping you on read_persistent_clock, for
real RTCs, then how about a RTC_DEV_SAFE_READ flag (or whatever) in
rtc_device.flags?

Reserve read_persistent_clock for things like that very specialized
non-RTC ARM counter.

> 
> While we're suggesting cleanups, the RTC Kconfig choices probably
> need a cleanup too, as  the list of all possible drivers can be
> confusing, when usually each architecture has only a few that they

That is a general pain with the new 'everything is a driver'..
However device tree enabled stuff is much nicer, just grep the tree
for the compatible string and you'll find a big clue about what
physical boards are using that driver.

For instance:
                rtc@10300 {
                        compatible = "marvell,kirkwood-rtc", "marvell,orion-rtc";
                        reg = <0x10300 0x20>;
                        interrupts = <53>;
                };
is matched to:

drivers/rtc/rtc-mv.c:

static struct of_device_id rtc_mv_of_match_table[] = {
        { .compatible = "marvell,orion-rtc", },


> exclusively support (I know there are exceptions to this).  It makes
> it hard to even figure out for a specific rtc driver what
> architecture one should look for in order to test with (I usually

With anything embedded the answer is 'anything and everything'
unfortunately. For example, our board has two bits of RTC capable
hardware - one inside the CPU SOC and one outside. We went through a
big analysis to pick the best one, based on battery selection and
battery life time. Even the presence of a RTC block in a SOC is not a
guarentee it will be used universally.

Regards,
Jason
