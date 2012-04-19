Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2DSCZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:25:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:24268 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2DSCZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143436416"
Subject: Re: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, svenjoac@gmx.de, rjw@sisk.pl,
        linux-tip-commits@vger.kernel.org
Date: Wed, 18 Apr 2012 19:27:39 -0700
In-Reply-To: <alpine.LFD.2.02.1204181723350.2542@ionos>
References: <alpine.LFD.2.02.1204181205540.2542@ionos>
	 <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>
	 <CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>
	 <4F8ECD39.3080900@ti.com> <alpine.LFD.2.02.1204181723350.2542@ionos>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 17:31 +0200, Thomas Gleixner wrote:
> On Wed, 18 Apr 2012, Santosh Shilimkar wrote:
> > >>                if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
> > >> +                       clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
> > 
> > For some reason above if() check fails in my case, so broadcast device
> > never set to ONESHOT mode. That explains the problem I am seeing on
> > OMAP with the $subject patch. At this point of time bc->mode is
> > CLOCK_EVT_MODE_UNUSED.
> 
> Darn, crap. I wonder how that works on x86
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index bf57abd..e8f5479 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -373,6 +373,9 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
>  {
>  	struct clock_event_device *bc = tick_broadcast_device.evtdev;
>  
> +	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
> +		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
> +
>  	return clockevents_program_event(bc, expires, force);
>  }
>  

So Here is my understanding of the issue why only Sven saw the resume
issue and what Santosh has seen with the first fix that Thomas tried.

>From the review, most likely Sven's system we are force enabling the
hpet using the pci quirk's method very late. And in this case,
hpet_clockevent (which will be global_clock_event) handler can be null,
specifically as this platform might not be using deeper c-states and
using the reliable APIC timer.

Prior to commit 'fa4da365bc7772c', that handler will be set to
'tick_handle_oneshot_broadcast' when we switch the broadcast timer to
oneshot mode, even though we don't use it. Post commit
'fa4da365bc7772c', we stopped switching the broadcast mode to oneshot as
this is not really needed and his platform's global_clock_event's
handler will remain null. While on my SNB laptop, same is set to
'clockevents_handle_noop' because hpet gets enabled very early. (noop
handler on my platform set when the early enabled hpet timer gets
replaced by the lapic timer).

But the commit 'fa4da365bc7772c' tracked the broadcast timer mode in the
SW as oneshot, even though it didn't touch the HW timer. During resume
however, tick_resume_broadcast() saw the SW broadcast mode as oneshot
and actually programmed the broadcast device also into oneshot mode. So
this triggered the null pointer de-reference after the hpet wraps around
and depending on what the hpet counter is set to. On the normal
platforms where hpet gets enabled early we should be seeing a spurious
interrupt (in my SNB laptop I see one spurious interrupt after around 5
minutes ;) which is 32-bit hpet counter wraparound time).

So thomas even with your current proposed fix, we should address this
spurious interrupt once in 5 minutes after resume!

And now coming to the Santosh's bc mode in not used mode, Thomas in
tick_check_broadcast_device() we do this.

       if (!cpumask_empty(tick_get_broadcast_mask()))
                tick_broadcast_start_periodic(dev);

Typically during boot on a regular platform, broadcast mask is NULL,
resulting in the bc timer mode as 'CLOCK_EVT_MODE_UNUSED'. This is the
case even on regular x86.

In essence, feel free to add my
"Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>" to your updated
fix.

Also, please review and consider the appended patch which addresses the
spurious timer interrupt every 5 minutes up on resume in the platforms
where broadcast timer is really not used. Thanks.
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: tick: Fix the spurious broadcast timer ticks

During resume, tick_resume_broadcast() programs the broadcast timer
in oneshot mode unconditionally. On the platforms where broadcast timer
is not really required, this will generate spurious broadcast timer ticks
upon resume. For example, on the always running apic timer platforms with
HPET, I see spurious hpet tick once every ~5minutes (which is the 32-bit
hpet counter wraparound time).

Similar to boot time, during resume make the oneshot mode setting of
the broadcast clock event device conditional on the state of active broadcast
users. 

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/time/tick-broadcast.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf57abd..766cd82 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -346,7 +346,8 @@ int tick_resume_broadcast(void)
 						     tick_get_broadcast_mask());
 			break;
 		case TICKDEV_MODE_ONESHOT:
-			broadcast = tick_resume_broadcast_oneshot(bc);
+			if (!cpumask_empty(tick_get_broadcast_mask()))
+				broadcast = tick_resume_broadcast_oneshot(bc);
 			break;
 		}
 	}


