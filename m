Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0HBWBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:01:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26389 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0HBWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:01:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6062"; a="49642671"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net,
        arjan@linux.intel.com, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/4] timer: Added usleep_range timer
Date: Mon,  2 Aug 2010 15:01:04 -0700
Message-Id: <1280786467-26999-2-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
References: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usleep_range is a finer precision implementations of msleep
and is designed to be a drop-in replacement for udelay where
a precise sleep / busy-wait is unnecessary.

Since an easy interface to hrtimers could lead to an undesired
proliferation of interrupts, we provide only a "range" API,
forcing the caller to think about an acceptable tolerance on
both ends and hopefully avoiding introducing another interrupt.

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

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 include/linux/delay.h |    1 +
 kernel/timer.c        |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..a6ecb34 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -45,6 +45,7 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
+void usleep_range(unsigned long min, unsigned long max);
 
 static inline void ssleep(unsigned int seconds)
 {
diff --git a/kernel/timer.c b/kernel/timer.c
index ee305c8..c2253dd 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1750,3 +1750,25 @@ unsigned long msleep_interruptible(unsigned int msecs)
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+static int __sched do_usleep_range(unsigned long min, unsigned long max)
+{
+	ktime_t kmin;
+	unsigned long delta;
+
+	kmin = ktime_set(0, min * NSEC_PER_USEC);
+	delta = (max - min) * NSEC_PER_USEC;
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
-- 
1.7.2

