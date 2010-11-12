Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0KLAYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 19:24:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36347 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0KLAYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 19:24:06 -0500
Subject: Re: [RFC-PATCH] clocksource: update lpj if clocksource has been
 changed.
From: john stultz <johnstul@us.ibm.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>
In-Reply-To: <AANLkTimwTUUBNmg=ZUkS3_u7B_5F9V-m0d8TRYLfs3Lt@mail.gmail.com>
References: <1289464582-26898-1-git-send-email-myungjoo.ham@samsung.com>
	 <1289505761.2742.24.camel@work-vm>
	 <AANLkTimwTUUBNmg=ZUkS3_u7B_5F9V-m0d8TRYLfs3Lt@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 16:23:52 -0800
Message-ID: <1289521432.2742.157.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 08:58 +0900, MyungJoo Ham wrote:
> On Fri, Nov 12, 2010 at 5:02 AM, john stultz <johnstul@us.ibm.com> wrote:
> > On Thu, 2010-11-11 at 17:36 +0900, MyungJoo Ham wrote:
> >> With a clocksource change, loops_per_jiffy may have been changed; thus,
> >> the loops_per_jiffy in each cpu should be updated. Especially after some
> >> of the cpus were turned off and on, their loops_per_jiffy values are
> >> updated while the cpus kept on are not. Therefore, in order to make them
> >> "normalized equally", we need to let the loops_per_jiffy values of
> >> different cpus be based on the same clocksource.
> >>
> >> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > First, Thanks for reporting the issue and submitting the patch!
> >
> > So the premise is that read_current_timer -> get_cycles ->
> > clocksource_read on some arches. And then when we select a different
> > clocksource for timekeeping, this also changes the get_cycles source
> > breaking delay loops.
> >
> > The clocksource selected for timekeeping and the counter being used for
> > get_cycles really shouldn't be explicitly bound. On most systems I don't
> > think that is the case, so this patch would force needless recalibration
> > calls on clocksource changes.
> >
> > Which arch specifically are you seeing the issue on? I suspect there is
> > be a better way to fix this.
> >
> > thanks
> > -john
> 
> We are working on ARM/S5PC210 with two cores. Actually, in single core
> systems, clocksource changes that affect loops-per-jiffy do not matter
> much as in multi-core systems because we do not have something to
> compare with in such a system. This patch adds some overheads on
> changing system clocksources; however, is happens only once at boot.

Well, clocksource changes can happen any time a system is running.

Looking through the 2.6.37-rc arm code, I'm not seeing any counter based
delay implementation. I only see the loop based implementation in
arm/lib/delay.S. Additionally, I don't see ARCH_HAS_READ_CURRENT_TIMER
or a get_cycles implementation that uses the clocksource.

Have implemented a non-loop based delay for your platform? Or could you
more clearly explain how the clocksource being used for timekeeping
effects the delay function on your hardware?


> Or, would it be better if we add another entry to struct clocksource;
> i.e., "bool recalibrate" in struct clocksource? Then, we can put
> recalibration routine in clocksource_select() at the end of the
> function deciding whether to recalibrate based on the
> "base->recalibrate" value. How about this?

No, I don't think adding more to the clocksource is the right fix here. 

In my view, the correct solution should be to separate the get_cycles or
read_current_timer implementation (if that is the culprit) so it is not
dependent on the clocksource that the timekeeping code is currently
using.

That way, changes to the time keeping clocksource won't affect the delay
function, and the re-calibration will be unnecessary.

thanks
-john





