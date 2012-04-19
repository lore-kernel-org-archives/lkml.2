Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2DSKOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:14:54 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33892 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471Ab2DSKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:14:50 -0400
Message-ID: <4F8FE592.2050408@ti.com>
Date: Thu, 19 Apr 2012 15:44:42 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        svenjoac@gmx.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
References: <alpine.LFD.2.02.1204181205540.2542@ionos>  <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>  <CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>  <4F8ECD39.3080900@ti.com> <alpine.LFD.2.02.1204181723350.2542@ionos> <1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com> <alpine.LFD.2.02.1204191028510.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204191028510.2542@ionos>
Content-Type: multipart/mixed;
 boundary="------------080802040401090901080107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080802040401090901080107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thomas,

On Thursday 19 April 2012 01:59 PM, Thomas Gleixner wrote:
> On Wed, 18 Apr 2012, Suresh Siddha wrote:
>> On Wed, 2012-04-18 at 17:31 +0200, Thomas Gleixner wrote:
>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>> Subject: tick: Fix the spurious broadcast timer ticks
>>
>> During resume, tick_resume_broadcast() programs the broadcast timer
>> in oneshot mode unconditionally. On the platforms where broadcast timer
>> is not really required, this will generate spurious broadcast timer ticks
>> upon resume. For example, on the always running apic timer platforms with
>> HPET, I see spurious hpet tick once every ~5minutes (which is the 32-bit
>> hpet counter wraparound time).
>>
>> Similar to boot time, during resume make the oneshot mode setting of
>> the broadcast clock event device conditional on the state of active broadcast
>> users. 
>>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Sven, Santosh, can you confirm that this works for you on top of the
> other two patches?
> 
I tried this patch on top of previous changes and it continues
to work. Just to be clear on what I have tested so far, attaching
the two patches.

Regards
Santosh

--------------080802040401090901080107
Content-Type: text/x-patch;
 name="0001-tick-Fix-oneshot-broadcast-setup-really.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-tick-Fix-oneshot-broadcast-setup-really.patch"

>From 90b674109949dd7aa9493b120a4c1a0f167cda1e Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 18 Apr 2012 17:51:40 +0530
Subject: [PATCH 1/2] tick: Fix oneshot broadcast setup really

Sven Joachim reported, that suspend/resume on rc3 trips over a NULL
pointer dereference. Linus spotted the clockevent handler being NULL.

commit fa4da365b(clockevents: tTack broadcast device mode change in
tick_broadcast_switch_to_oneshot()) tried to fix a problem with the
broadcast device setup, which was introduced in commit 77b0d60c5(
clockevents: Leave the broadcast device in shutdown mode when not
needed).

The initial commit avoided to set up the broadcast device when no
broadcast request bits were set, but that left the broadcast device
disfunctional. In consequence deep idle states which need the
broadcast device were not woken up.

commit fa4da365b tried to fix that by initializing the state of the
broadcast facility, but that missed the fact, that nothing initializes
the event handler and some other state of the underlying clock event
device.

The fix is to revert both commits and make only the mode setting of
the clock event device conditional on the state of active broadcast
users.

That initializes everything except the low level device mode, but this
happens when the broadcast functionality is invoked by deep idle.

Reported-and-tested-by: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1204181205540.2542@ionos
---
 kernel/time/tick-broadcast.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf57abd..0e5597e 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -373,6 +373,10 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 
+	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+
+
 	return clockevents_program_event(bc, expires, force);
 }
 
@@ -531,7 +535,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 		/* Take the do_timer update */
 		tick_do_timer_cpu = cpu;
@@ -549,6 +552,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			   to_cpumask(tmpmask));
 
 		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
 						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
@@ -577,15 +581,10 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
-
-	if (cpumask_empty(tick_get_broadcast_mask()))
-		goto end;
-
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
 
-end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-- 
1.7.5.4


--------------080802040401090901080107
Content-Type: text/x-patch;
 name="0002-tick-Fix-the-spurious-broadcast-timer-ticks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-tick-Fix-the-spurious-broadcast-timer-ticks.patch"

>From 26a102797f5542173809c3d4b0361c17d1be8db1 Mon Sep 17 00:00:00 2001
From: Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 19 Apr 2012 15:28:34 +0530
Subject: [PATCH 2/2] tick: Fix the spurious broadcast timer ticks

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
index 0e5597e..4c26100 100644
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
-- 
1.7.5.4


--------------080802040401090901080107--
