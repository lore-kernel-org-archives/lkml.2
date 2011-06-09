Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1FIWAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:00:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59762 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab1FIWAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:00:15 -0400
Date: Thu, 9 Jun 2011 22:59:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: john stultz <johnstul@us.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
Message-ID: <20110609215939.GI24424@n2100.arm.linux.org.uk>
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk> <4DE7637B.3060901@stericsson.com> <20110602110137.GU3660@n2100.arm.linux.org.uk> <4DE77D9A.6090301@stericsson.com> <4DE788B2.5060308@ti.com> <1307040455.11492.52.camel@work-vm> <4DEF7CA1.8080809@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEF7CA1.8080809@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 03:44:01PM +0200, Mattias Wallin wrote:
> On 06/02/2011 08:47 PM, john stultz wrote:
>> Yea. The basic idea is to interpolate between two counters to produce a
>> a continuous clocksource for the timekeeping core.
>>
>> As Russell pointed out, error is injected to the timekeeping code every
>> time you switch between clocksources or the persistent clock. Doing this
>> very frequently will provide very poor time.
>>
>> So by using an interpolated clocksource, we would be able to maintain
>> clock adjustments via ntp and provide accurate long term time, while
>> still having fine-grained resolution (along with some short term error).
>>
>> However, its all easier said then done. There are lots of gotchas and
>> corner-cases with interpolation. That's the whole reason we moved from
>> tick based timekeeping to continuous clocksource based timekeeping. I
>> believe the KVM folks have used similar interpolation method for their
>> kvm clocksource, and I know they had numerous issues. But it seems to
>> work well enough, so I would take a peek at their code to start.
>
> Russell,
> What is your gut feeling about above interpolated clocksource strategy  
> suggestion?

I think you're not going to maintain precision even with the above idea.
There's two problems:

1. When you switch from the high resolution to the low resolution, you
need to know how many high-res count increments have elapsed since the
last low-res count increment occurred.  From this you know the offset
between current time and the last low-res count increment and so can
correct for this change.

2. When you switch from the low-res to high-res, because the high-res
has restarted, you have lost track of the high-res counter.  The only
point when things are re-synchronisable is at the point when the low-res
counter increments.  So you either:
a) have to wait for the low-res to increment,
b) or you use the high-res counter to time until the low-res increments
 and then factor in some correction factor.

Either way looks like it will be fraught with problems - particularly
the resulting increase in latency caused by this when switching between
states, or the period of loss of precision caused by (2b) which may be
more disruptive to NTP.

> While we (I) look at an alternative clocksource strategy and experiment  
> are you ok with the three patches I sent?

No - I'd like you to check whether the patch I sent fixes your
sched_clock problem across suspend/resume so that we can get that sorted
for everyone, instead of coming up with platform specific fixes.  Then
we can work out how to hook that into cpuidle so that it works properly
there.

We're no longer going to go down the route of platforms working around
problems with common infrastructure in their own individual private
ways.  That madness has to stop right now.
