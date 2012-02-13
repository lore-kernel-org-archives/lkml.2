Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2BMNKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:10:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64306 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab2BMNKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:10:03 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
Date: Mon, 13 Feb 2012 15:10:02 +0200
Message-ID: <CAOtvUMeT+HGKYW4vxfROx8fTwqM8YAAiNt8i_Z7jd_446yr6Qg@mail.gmail.com>
Subject: [RFC PATCH] make __next_timer_interrupt explicit about no future event
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While playing with Frederic's adaptive tick patch set' I've noticed
that no matter what
I do, even though I can get the scheduler tick to turn itself off, I
still got an interrupt from
the timer once every few seconds, although it did not run the
scheduler tick code.

After poking at it for some time I believe what is happening is as follows:

1. tick_nohz_stop_sched_tick()  [kernel/time/tick-sched.c]  calls
   get_next_timer_interrupt() [kernel/timer.c] with last_jiffies as parameter
   to get the next timer event, which in turn calls  __next_timer_interrupt().

2.  __next_timer_interrupt() starts with a default expiry time of
    (base->timer_jiffies + NEXT_TIMER_MAX_DELTA) and searches for the
next timer event.

3. Having failed to find any, __next_timer_interrupt() returns the
default expiry time, which
   is returned by get_next_timer_interrupt() to tick_nohz_stop_sched_tick()

4. tick_nohz_stop_sched_tick() now subtracts the value of last_jiffies
from the return value
    and checks if the delta is smaller then NEXT_TIMER_MAX_DELTA, if
it does (and multiple
    other things are aligned just right...) it cancels the timer interrupt.

5. Alas, base->timer_jiffies and last_jiffies are (usually) not equal,
with the result being that
    tick_nohz_stop_sched_tick() thinks there is a timer event pending
sometime in the distant
    future, aprox. 12 days from now(!). It therefore must keep the
underlying timer firing every
    KTIME_MAX nsecs so that the clocksource will not wrap around.

The end result is that we get a timer interrupt firing every KTIME_MAX
nsecs even there is
no future timer event at all.

The attached patch tries to fix the above, by adding an explicit
boolean return value to
__next_timer_interrupt() to indicate whether or not it found a future
timer event and having
get_next_timer_interrupt() return (last_jiffies +
NEXT_TIMER_MAX_DELTA) to indicate
there is no timer event, in the same way it does for offline CPUs.

Note that I had to go to unusual lengths to get to a point there is no
future timer event, such
as having a dedicated cpuset, disabling the vmstat timer and
clocksource watchdog, so this
patch by itself is not enough to get the timer interrupt to disable,
but it is needed if you want
it to.

The patch was only very slightly tested on 32bit x86 machine (8 way XMP).

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC:  Frederic Weisbecker <fweisbec@gmail.com>

---

RFC:

Does the patch makes sense?
If so, should we make tick_nohz_stop_sched_tick() also deal  with
explicit flags
rather then use magic delta values?

Thanks!
Gilad

diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..a41b171 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1187,11 +1187,13 @@ static inline void __run_timers(struct tvec_base *base)
  * is used on S/390 to stop all activity when a CPU is idle.
  * This function needs to be called with interrupts disabled.
  */
-static unsigned long __next_timer_interrupt(struct tvec_base *base)
+static bool __next_timer_interrupt(struct tvec_base *base,
+					unsigned long *next_timer)
 {
 	unsigned long timer_jiffies = base->timer_jiffies;
 	unsigned long expires = timer_jiffies + NEXT_TIMER_MAX_DELTA;
-	int index, slot, array, found = 0;
+	int index, slot, array;
+	bool found = false;
 	struct timer_list *nte;
 	struct tvec *varray[4];

@@ -1202,12 +1204,12 @@ static unsigned long
__next_timer_interrupt(struct tvec_base *base)
 			if (tbase_get_deferrable(nte->base))
 				continue;

-			found = 1;
+			found = true;
 			expires = nte->expires;
 			/* Look at the cascade bucket(s)? */
 			if (!index || slot < index)
 				goto cascade;
-			return expires;
+			goto out;
 		}
 		slot = (slot + 1) & TVR_MASK;
 	} while (slot != index);
@@ -1233,7 +1235,7 @@ cascade:
 				if (tbase_get_deferrable(nte->base))
 					continue;

-				found = 1;
+				found = true;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
 			}
@@ -1245,7 +1247,7 @@ cascade:
 				/* Look at the cascade bucket(s)? */
 				if (!index || slot < index)
 					break;
-				return expires;
+				goto out;
 			}
 			slot = (slot + 1) & TVN_MASK;
 		} while (slot != index);
@@ -1254,7 +1256,10 @@ cascade:
 			timer_jiffies += TVN_SIZE - index;
 		timer_jiffies >>= TVN_BITS;
 	}
-	return expires;
+out:
+	if(found)
+		*next_timer = expires;
+	return found;
 }

 /*
@@ -1317,9 +1322,15 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	if (cpu_is_offline(smp_processor_id()))
 		return now + NEXT_TIMER_MAX_DELTA;
 	spin_lock(&base->lock);
-	if (time_before_eq(base->next_timer, base->timer_jiffies))
-		base->next_timer = __next_timer_interrupt(base);
-	expires = base->next_timer;
+	if (time_before_eq(base->next_timer, base->timer_jiffies)) {
+
+		if(__next_timer_interrupt(base, &expires))
+			base->next_timer = expires;
+		else
+			expires = now + NEXT_TIMER_MAX_DELTA;
+	} else
+		expires = base->next_timer;
+
 	spin_unlock(&base->lock);

 	if (time_before_eq(expires, now))
-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
