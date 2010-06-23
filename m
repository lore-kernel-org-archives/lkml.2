Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0FWTWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:22:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0FWTWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:22:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6022"; a="45169870"
Message-ID: <4C225EED.5040600@codeaurora.org>
Date: Wed, 23 Jun 2010 12:22:21 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: sboyd@codeaurora.org, tglx@linutronix.de, mingo@elte.hu,
       heiko.carstens@de.ibm.com, eranian@google.com, schwidefsky@de.ibm.com
Subject: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
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


*** SOME QUANTIFIABLE (?) NUMBERS ***

My focus is on Android, so I started by replacing the udelays in
drivers/i2c/busses/i2c-msm.c:

	267: udelay(100) --> usleep_range(100, 200)
	283: udelay(100) --> usleep_range(100, 200)
	333: udelay(20) --> usleep(20)

and measured wakeups after Android was completely booted and stable
across 100 trials (throwing away the first) like so:

for i in {1..100}; do
	echo "=== Trial $i" >> test.txt;
	echo 1 > /proc/timer_stats; sleep 10; echo 0 > /proc/timer_stats;
	cat /proc/timer_stats >> test.txt;
	sleep 2s;
done

then averaged the results to see if there was any benefit:

=== ORIGINAL (99 samples) ========================================= ORIGINAL ===
    Avg: 188.760000 wakeups in 9.911010 secs (19.045486 wkups/sec) [18876 total]
Wakeups: Min - 179, Max - 208, Mean - 190.666667, Stdev - 6.601194

=== USLEEP (99 samples) ============================================= USLEEP ===
    Avg: 188.200000 wakeups in 9.911230 secs (18.988561 wkups/sec) [18820 total]
Wakeups: Min - 181, Max - 213, Mean - 190.101010, Stdev - 6.950757

While not particularly rigorous, the results seem to indicate that there may be
some benefit from pursuing this.


*** HOW MUCH BENEFIT? ***

Somewhat arbitrarily choosing 100 as a cut-off for udelay VS usleep:

	git grep 'udelay([[:digit:]]\+)' | 
		perl -F"[\(\)]" -anl -e 'print if $F[1] >= 100' | wc -l

yeilds 1093 on Linus's tree. There are 313 instances of >= 1000 and still
another 53 >= 10000us of busy wait! (If AVOID_POPS is configured in, the
es18xx driver will udelay(100000) or *0.1 seconds of busy wait*)


*** SUMMARY ***

I believe the usleep functions provide a tangible benefit, but would like
some input before I go for a more thorough udelay removal. Also, at what
point is a reasonable cutoff between udelay and usleep? I found two dated
(2007) papers discussing the overhead of a context switch:

      http://www.cs.rochester.edu/u/cli/research/switch.pdf
      IBM eServer, dual 2.0GHz Pentium Xeon; 512 KB L2, cache line 128B
      Linux 2.6.17, RHEL 9, gcc 3.2.2 (-O0)
      3.8 us / context switch

      http://delivery.acm.org/10.1145/1290000/1281703/a3-david.pdf
      ARMv5, ARM926EJ-S on an OMAP1610 (set to 120MHz clock)
      Linux 2.6.20-rc5-omap1
      48 us / context switch

However, there is more to consider than just context switching; is there
anyone who knows an appropriate cut-off, or an appropriate way to measure
and find one?


Finally, to address any potential questions of why this isn't built on
top of do_nanosleep, the function usleep_range seems very valuable for
power applications; many of the delays are simply waiting for something
to complete, thus I would prefer if they did not themselves instigate
a wake-up; also, do_nanosleep seems like it is built to be an interface
for the user-space nanosleep function - it did not seem like a good fit.

-Pat



>From 26193064936016e3f679c911b4e988a3de97c531 Mon Sep 17 00:00:00 2001
From: Patrick Pannuto <ppannuto@codeaurora.org>
Date: Tue, 22 Jun 2010 10:08:08 -0700
Subject: [PATCH] timer: Added usleep[_range][_interruptable] timer

usleep[_range][_interruptable] are finer precision implmentations
of msleep[_interruptable] and are designed to be drop-in
replacements for udelay where a precise sleep / busy-wait is
unnecessary. They also allow an easy interface to specify slack
when a precise (ish) wakeup is unnecessary to help minimize wakeups

Change-Id: I277737744ca58061323837609b121a0fc9d27f33
Change-Id: I088f14e905fc569c0a728fff5dc61ef25f49bb1e
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
-- 
1.7.1

