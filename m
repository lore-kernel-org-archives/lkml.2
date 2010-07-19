Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757Ab0GSUyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:54:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16188 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966417Ab0GSUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:54:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6048"; a="47962531"
Message-ID: <4C44BB69.8050300@codeaurora.org>
Date: Mon, 19 Jul 2010 13:54:01 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, akinobu.mita@gmail.com, sboyd@codeaurora.org
Subject: [PATCH] timer: Added usleep[_range][_interruptible] timer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** INTRO ***

As discussed here ( http://lkml.org/lkml/2007/8/3/250 ), msleep(1) is not
precise enough for many drivers (yes, sleep precision is an unfair notion,
but consistently sleeping for ~an order of magnitude greater than requested
is worth fixing). This patch adds a usleep API so that udelay does not have
to be used. Obviously not every udelay can be replaced (those in atomic
contexts or being used for simple bitbanging come to mind), but there are
many, many examples of

mydriver_write(...)
/* Wait for hardware to latch */
udelay(100)

in various drivers where a busy-wait loop is neither beneficial nor
necessary, but msleep simply does not provide enough precision and people
are using a busy-wait loop instead.


*** CONCERNS FROM THE RFC ***

Why is udelay a problem / necessary? Most callers of udelay are in device/
driver initialization code, which is serial...

	As I see it, there is only benefit to sleeping over a delay; the
	notion of "refactoring" areas that use udelay was presented, but
	I see usleep as the refactoring. Consider i2c, if the bus is busy,
	you need to wait a bit (say 100us) before trying again, your
	current options are:

		* udelay(100)
		* msleep(1) <-- As noted above, actually as high as ~20ms
				on some platforms, so not really an option
		* Manually set up an hrtimer to try again in 100us (which
		  is what usleep does anyway...)

	People choose the udelay route because it is EASY; we need to
	provide a better easy route.


	Device / driver / boot code is *currently* serial, but every few
	months someone makes noise about parallelizing boot, and IMHO, a
	little forward-thinking now is one less thing to worry about
	if/when that ever happens

udelay's could be preempted

	Sure, but if udelay plans on looping 1000 times, and it gets
	preempted on loop 200, whenever it's scheduled again, it is
	going to do the next 800 loops.

Is the interruptible case needed?

	Probably not, but I see usleep as a very logical parallel to msleep,
	so it made sense to include the "full" API. Processors are getting
	faster (albeit not as quickly as they are becoming more parallel),
	so if someone wanted to be interruptible for a few usecs, why not
	let them? If this is a contentious point, I'm happy to remove it.


*** OTHER THOUGHTS ***

I believe there is also value in exposing the usleep_range option; it gives
the scheduler a lot more flexibility and allows the programmer to express
his intent much more clearly; it's something I would hope future driver
writers will take advantage of.

To get the results in the NUMBERS section below, I literally s/udelay/usleep
the kernel tree; I had to go in and undo the changes to the USB drivers, but
everything else booted successfully; I find that extremely telling in and
of itself -- many people are using a delay API where a sleep will suit them
just fine.


*** SOME ATTEMPTS AT NUMBERS ***

It turns out that calculating quantifiable benefit on this is challenging,
so instead I will simply present the current state of things, and I hope
this to be sufficient:

How many udelay calls are there in 2.6.35-rc5?

	udealy(ARG) >=	| COUNT
	1000		| 319
	500		| 414
	100		| 1146
	20		| 1832

I am working on Android, so that is my focus for this. The following table
is a modified usleep that simply printk's the amount of time requested to
sleep; these tests were run on a kernel with udelay >= 20 --> usleep

"boot" is power-on to lock screen
"power collapse" is when the power button is pushed and the device suspends
"resume" is when the power button is pushed and the lock screen is displayed
         (no touchscreen events or anything, just turning on the display)
"use device" is from the unlock swipe to clicking around a bit; there is no
	sd card in this phone, so fail loading music, video, camera

	ACTION		| TOTAL NUMBER OF USLEEP CALLS	| NET TIME (us)
	boot		| 22				| 1250
	power-collapse	| 9				| 1200
	resume		| 5				| 500
	use device	| 59				| 7700

The most interesting category to me is the "use device" field; 7700us of
busy-wait time that could be put towards better responsiveness, or at the
least less power usage.


*** SUMMARY ***

I believe usleep to be a useful and logical extension to the current API,
and would like to submit this patch for linux-next

-Pat


>From 26193064936016e3f679c911b4e988a3de97c531 Mon Sep 17 00:00:00 2001
From: Patrick Pannuto <ppannuto@codeaurora.org>
Date: Tue, 22 Jun 2010 10:08:08 -0700
Subject: [PATCH] timer: Added usleep[_range][_interruptible] timer

usleep[_range][_interruptible] are finer precision implementations
of msleep[_interruptible] and are designed to be drop-in
replacements for udelay where a precise sleep / busy-wait is
unnecessary. They also allow an easy interface to specify slack
when a precise (ish) wakeup is unnecessary to help minimize wakeups

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 include/linux/delay.h |   12 ++++++++++++
 kernel/timer.c        |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..13f5378 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -45,6 +45,18 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
+void usleep_range(unsigned long min, unsigned long max);
+unsigned long usleep_range_interruptible(unsigned long min, unsigned long max);
+
+static inline void usleep(unsigned long usecs)
+{
+	usleep_range(usecs, usecs);
+}
+
+static inline unsigned long usleep_interruptible(unsigned long usecs)
+{
+	return usleep_range_interruptible(usecs, usecs);
+}
 
 static inline void ssleep(unsigned int seconds)
 {
diff --git a/kernel/timer.c b/kernel/timer.c
index 5db5a8d..1587dad 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1684,3 +1684,47 @@ unsigned long msleep_interruptible(unsigned int msecs)
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+static int __sched do_usleep_range(unsigned long min, unsigned long max)
+{
+	ktime_t kmin;
+	unsigned long delta;
+
+	kmin = ktime_set(0, min * NSEC_PER_USEC);
+	delta = max - min;
+	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
+}
+
+/**
+ * usleep_range - Drop in replacement for udelay where wakeup is flexible
+ * @min: Minimum time in usecs to sleep
+ * @max: Maximum time in usecs to sleep
+ */
+void usleep_range(unsigned long min, unsigned long max)
+{
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	do_usleep_range(min, max);
+}
+EXPORT_SYMBOL(usleep_range);
+
+/**
+ * usleep_range_interruptible - sleep waiting for signals
+ * @min: Minimum time in usecs to sleep
+ * @max: Maximum time in usecs to sleep
+ */
+unsigned long usleep_range_interruptible(unsigned long min, unsigned long max)
+{
+	int err;
+	ktime_t start;
+
+	start = ktime_get();
+
+	__set_current_state(TASK_INTERRUPTIBLE);
+	err = do_usleep_range(min, max);
+
+	if (err == -EINTR)
+		return ktime_us_delta(ktime_get(), start);
+	else
+		return 0;
+}
+EXPORT_SYMBOL(usleep_range_interruptible);
-- 1.7.1 
