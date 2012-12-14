Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2LNCPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:15:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:3160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab2LNCPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:15:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,277,1355126400"; 
   d="scan'208";a="257234515"
Date: Fri, 14 Dec 2012 10:15:25 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com, jgunthorpe@obsidianresearch.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121214021525.GB11276@feng-snb>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
 <20121214013725.GA11276@feng-snb>
 <50CA8837.5010800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA8837.5010800@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 06:00:23PM -0800, John Stultz wrote:
> On 12/13/2012 05:37 PM, Feng Tang wrote:
> >On Thu, Dec 13, 2012 at 05:20:36PM -0800, John Stultz wrote:
> >>On 12/12/2012 06:05 PM, Feng Tang wrote:
> >>>In current kernel, there are several places which need to check
> >>>whether there is a persistent clock for the platform. Current check
> >>>is done by calling the read_persistent_clock() and validating the
> >>>return value.
> >>>
> >>>Add such a flag to make code more readable and call read_persistent_clock()
> >>>only once for all the checks.
> >>Sorry.. What  the actual benefit of this patch set?   (Usually with
> >>changelogs its better to explain why you're doing something, rather
> >>then just what you're doing.)
> >The main benefits is not bother to do the rtc_resume and rtc_suspend work
> >if persistent clock exists. Current RTC suspend/resume code will do many
> >time calculation and compensation work at first, and then call
> >timekeeping_inject_sleeptime() which will just return for platform with
> >persistent clock, what I did in this patchset is to put the check at
> >the start, also I save the persistent_clock_exist flag for all possible
> >check after timekeeping_init().
> 
> CC'ing Jason as his recent patch is conceptually connected here.
> 
> Ok, Feng, so your patch set is a suspend/resume optimization for the
> case where the architecture has a read_persistent_clock()
> implementation, but the kernel config has also the rtc
> HCTOSYS_DEVICE set, right?

Exactly! Sorry for I didn't make it clear

> 
> So we basically short-cut the rtc's HCTOSYS_DEVICE suspend/resume
> logic, likely to speed up suspend/resume.
> 
> So per Jason's related patch, he's made the point that the
> persistent_clock and RTC class functionality are basically exclusive
> (well, in his case, he said this with respect to updating the RTC,
> not reading it - I don't mean to put words in his mouth - Please do
> correct me here Jason. :).  In other words, we probably should avoid
> configurations where both the rtc hctosys and persistent_clock
> interfaces are both active.

Yes, I agree these 2 should be exclusive.

> 
> So my thought here is that this same behavioral change could be made
> via Kconfig constraints rather then extra run-time conditionals.
> Basically we add a HAS_PERSISTENT_CLOCK, that architectures select
> if they want to use the read/update_persistent_clock calls. Then we
> make the HCTOSYS option be dependent on !HAS_PERSISTENT_CLOCK. This
> way we avoid having configs where there are conflicting paths that
> we chose from.

Sounds good to me, and we may need to add the HAS_PERSISTENT_CLOCK
to the default config of platforms who implemente the read_persistent_clock().

One concern is if a platform has read_persistent_clock capability, will
it also has the write_persistent_clock? The answer may be no  

Thanks,
Feng


