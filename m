Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0IOKil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:38:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45603 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab0IOKij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:38:39 -0400
X-Sasl-enc: Z8NOpwb/6KfTnu79TaUDDtX1gMwW9Zizu8NoXgyrZQ0N 1284547118
Message-ID: <4C90A228.1050809@eml.cc>
Date: Wed, 15 Sep 2010 12:38:32 +0200
From: Martin Kepplinger <martinkepplinger@eml.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100826 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: tglx@linutronix.de
CC: johnstul@us.ibm.com, damm@opensource.se, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] [BISECTED] System gets unresponsive since 2.6.35-rc1
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
My Ubuntu 10.04, 32bit on a Lenovo G550 Laptop has the following issue since .35-rc1: After a short uptime doing little things like video playback, the system gets slow and stuck after some time. At first, compiz-animations and everything (video playback, terminal-commands) gets unusably slow. /var/log/messages comes up with the following _during_ video playback. These warnings stop when the video is stopped. The system stays (quite) unresponsive / unusable.

Sep 15 12:15:51 mobil pulseaudio[1456]: ratelimit.c: 19 events suppressed
Sep 15 12:15:57 mobil pulseaudio[1456]: ratelimit.c: 25 events suppressed
Sep 15 12:16:02 mobil pulseaudio[1456]: ratelimit.c: 6 events suppressed
Sep 15 12:16:07 mobil pulseaudio[1456]: ratelimit.c: 11 events suppressed
Sep 15 12:16:17 mobil pulseaudio[1456]: ratelimit.c: 12 events suppressed
Sep 15 12:16:23 mobil pulseaudio[1456]: ratelimit.c: 3 events suppressed

Shutdown also hangs very soon. The problem is still present in 2.6.36-rc3! I'm about to test -rc4. The last "good" one is 2.6.34.

I bisected the problem. Unfortunately I could not revert the patch. Additionally, I'm only 90% sure about the result because I had to skip one step of the bisect (but since the toplevel-Makefile showed "2.6.34-something", I could guess it to be "good")

The rest of this E-Mail is the result (git show). I can only report it. I'd happily test patches to it and hope this makes sense to someone of you.

thanks,
Martin

commit d7e81c269db899b800e0963dc4aceece1f82a680
Author: John Stultz <johnstul@us.ibm.com>
Date:   Fri May 7 18:07:38 2010 -0700

    clocksource: Add clocksource_register_hz/khz interface
    
    How to pick good mult/shift pairs has always been difficult to
    describe to folks writing clocksource drivers, since it requires
    careful tradeoffs in adjustment accuracy vs overflow limits.
    
    Now, with the clocks_calc_mult_shift function, its much
    easier. However, not many clocksources have converted to using that
    function, and there is still the issue of the max interval length
    assumption being made by each clocksource driver independently.
    
    So this patch simplifies the registration process by having
    clocksources be registered with a hz/khz value and the registration
    function taking care of setting mult/shift.
    
    This should take most of the confusion out of writing a clocksource
    driver.
    
    Additionally it also keeps the shift size tradeoff (more accuracy vs
    longer possible nohz times) centralized so the timekeeping core can
    keep track of the assumptions being made.
    
    [ tglx: Coding style and comments fixed ]
    
    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    LKML-Reference: <1273280858-30143-1-git-send-email-johnstul@us.ibm.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..5ea3c60 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -273,7 +273,6 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mul
 }
 
 
-/* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
@@ -287,6 +286,24 @@ extern void clocksource_mark_unstable(struct clocksource *c
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
+/*
+ * Don't call __clocksource_register_scale directly, use
+ * clocksource_register_hz/khz
+ */
+extern int
+__clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
+
+static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
+{
+       return __clocksource_register_scale(cs, 1, hz);
+}
+
+static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
+{
+       return __clocksource_register_scale(cs, 1000, khz);
+}
+
+
 static inline void
 clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..f08e99c 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -625,6 +625,54 @@ static void clocksource_enqueue(struct clocksource *cs)
        list_add(&cs->list, entry);
 }
 
+
+/*
+ * Maximum time we expect to go between ticks. This includes idle
+ * tickless time. It provides the trade off between selecting a
+ * mult/shift pair that is very precise but can only handle a short
+ * period of time, vs. a mult/shift pair that can handle long periods
+ * of time but isn't as precise.
+ *
+ * This is a subsystem constant, and actual hardware limitations
+ * may override it (ie: clocksources that wrap every 3 seconds).
+ */
+#define MAX_UPDATE_LENGTH 5 /* Seconds */
+
+/**
+ * __clocksource_register_scale - Used to install new clocksources
+ * @t:         clocksource to be registered
+ * @scale:     Scale factor multiplied against freq to get clocksource hz
+ * @freq:      clocksource frequency (cycles per second) divided by scale
+ *
+ * Returns -EBUSY if registration fails, zero otherwise.
+ *
+ * This *SHOULD NOT* be called directly! Please use the
+ * clocksource_register_hz() or clocksource_register_khz helper functions.
+ */
+int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+{
+
+       /*
+        * Ideally we want to use  some of the limits used in
+        * clocksource_max_deferment, to provide a more informed
+        * MAX_UPDATE_LENGTH. But for now this just gets the
+        * register interface working properly.
+        */
+       clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
+                                     NSEC_PER_SEC/scale,
+                                     MAX_UPDATE_LENGTH*scale);
+       cs->max_idle_ns = clocksource_max_deferment(cs);
+
+       mutex_lock(&clocksource_mutex);
+       clocksource_enqueue(cs);
+       clocksource_select();
+       clocksource_enqueue_watchdog(cs);
+       mutex_unlock(&clocksource_mutex);
+       return 0;
+}
+EXPORT_SYMBOL_GPL(__clocksource_register_scale);
+
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:         clocksource to be registered
