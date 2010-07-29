Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0G2XIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:08:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58686 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035Ab0G2XIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:08:22 -0400
Subject: Re: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <1280436547.2829.72.camel@localhost.localdomain>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
	 <20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
	 <1280333569.1848.34.camel@work-vm>
	 <20100729091125.6e25368e@mschwide.boeblingen.de.ibm.com>
	 <1280436547.2829.72.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 16:08:15 -0700
Message-ID: <1280444895.2829.164.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 13:49 -0700, john stultz wrote:
> On Thu, 2010-07-29 at 09:11 +0200, Martin Schwidefsky wrote:
> > What about a clocksource_unregister while a cpu is in the middle of a
> > read_seqbegin/timekeeping_get_ns/read_seqretry? The clocksource structure
> > is "free" after the successful call to the unregister. At least in theory
> > this could be a use after free. The race window is tiny but on virtual
> > systems there can be an arbitrary delay in the ktime_get sequence.
>
> So yes, unregister has been contentious in the past for this very
> reason. Once registered, its really hard to find a safe point when it
> can be un-registered. Stop machine mostly solves this (although one
> should note: vsyscall enabled clocksources really can't be freed, as
> their vread() page needs to be statically mapped into userspace).
> 
> So while stop_machine is a solution here, it would make more sense to me
> to use stop_machine (or maybe even a different method, as it sort of
> screams RCU to me) to make sure all the cpus are out of the xtime_lock
> critical section prior to returning from unregister_clocksource, rather
> then stopping everything for the clocksource change.


Below is a rough patch to use stop_machine to get the same level of race
protection for clocksource_unregister as we have currently in Linus's
tree (which may possibly have holes in it?).

Comments or suggestions for other ideas would be appreciated.

I'm thinking RCU might be really close to what we actually want here,
but I'd like to be able to avoid any extra work on the read-side (ie:
even the preempt_disable()), and would even be more prone to disallowing
clocksource unregistration then impacting the xtime_lock read side.


Any other thoughts?

thanks
-john


>From c85f3adf525ac457b938f4cf39ace1e2239c509f Mon Sep 17 00:00:00 2001
From: John Stultz <johnstul@us.ibm.com>
Date: Thu, 29 Jul 2010 15:28:13 -0700
Subject: [PATCH] [HACK] Avoid clocksource_unregister races

This attempts to avoid use-after free style races caused
when a clocksource that is in-use is unregistered.

The problem arises as the read-side of the xtime_lock seqlock
allows for invalid calculations to be made while the write-lock
is held. This is normally ok, as the invalid calculations are
never returned. However, if a clocksource is unregistered, and
then freed, its possible that other cpus that still are in the
read-loop may hold invalid references to the clocksource
(possibly traversing an invalid clocksource->read function pointer).

This patch (ab)uses stop_machine to delay returning from
clocksource_unregister until all cpus have run the cpu_stopper_thread,
and have (we assume, possibly incorrectly), left the xtime_lock
protected read-side critical section.

I have concerns that stop_machine does not enforce that the other cpus
have in fact left the read-side xtime_lock critical section if
features like kernel preemption is enabled. So the race may
still exist.

However, this restores as much protection as we had earlier
when stop_machine was used to do all clocksource changes.

stop_machine also seems a little heavy handed for what we're wanting.
I'd appreciate other better tools to do similar. It is very RCU
like, but we'd like to avoid any extra work on the read-side.

(I'm suspecting making sure all other cpus idle time counters
have increased might be a better method to ensure everyone has
left the critical section)

NOT YET FOR INCLUSION! FOR DISCUSSION ONLY.
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/clocksource.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..9a1ae9e 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
 #include <linux/kthread.h>
+#include <linux/stop_machine.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -731,6 +732,17 @@ void clocksource_change_rating(struct clocksource *cs, int rating)
 }
 EXPORT_SYMBOL(clocksource_change_rating);
 
+
+static int unregister_wait(void *data)
+{
+	/*
+	 * We don't really do anything here, just
+	 * use this to get to a safe point before
+	 * we return from clocksource_unregister.
+	 */
+	 return 0;
+}
+
 /**
  * clocksource_unregister - remove a registered clocksource
  */
@@ -741,6 +753,18 @@ void clocksource_unregister(struct clocksource *cs)
 	list_del(&cs->list);
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
+
+	/*
+	 * There may be cpus that still hold a reference to
+	 * the clocksource's read() function, so block here
+	 * until they have all gone idle (via stop_machine).
+	 *
+	 * XXX - stop_machine preempts tasks, which may
+	 * not actually wait till the read seq xtime_lock is
+	 * "released". Regardless, this is atleast as safe
+	 * as what we have been doing in the past.
+	 */
+	stop_machine(unregister_wait, NULL, NULL);
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
-- 
1.6.0.4





