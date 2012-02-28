Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2B1KzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:55:14 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:59396 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab2B1KzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:55:13 -0500
Message-ID: <4F4CB20C.2000201@tu-ilmenau.de>
Date: Tue, 28 Feb 2012 11:53:00 +0100
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120217 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] nitro: make multiplier scaleable, change "nitro_hzmultiplicator"
 into "nitro_hz_permille"
References: <4F4B7CC6.1030307@tu-ilmenau.de>
In-Reply-To: <4F4B7CC6.1030307@tu-ilmenau.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the conventional "nitro_hzmultiplicator" into a permille-base.
So now it is possible also to scale down HZ. (For example half HZ would be possible
with nitro_hz_permille=500, a quarter nitro_hz_permille=250 ...etc...)
As always, jiffies_64 increases with HZ frequency.

The new proc-file is called "nitro_hz_permille"
The new config-option is called "CONFIG_SCHED_NITRO_HZBOOST_PERMILLE"

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
---
 kernel/Kconfig.sched        |   17 +++++++++--------
 kernel/sysctl.c             |   12 ++++++------
 kernel/time/tick-common.c   |   14 +++++++-------
 kernel/time/tick-internal.h |   19 ++++++++++++++-----
 4 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/kernel/Kconfig.sched b/kernel/Kconfig.sched
index 27e5518..a066434 100644
--- a/kernel/Kconfig.sched
+++ b/kernel/Kconfig.sched
@@ -176,23 +176,24 @@ config SCHED_NITRO_HZBOOST_USERSPAC
          accessable from userspace via procfs.
          The responsible file will be called /proc/sys/kernel/nitro_hzmultiplicator

-config SCHED_NITRO_HZBOOST_MULTIPLICATOR
-       int "Multiply the HZ frequency value"
-       range 1 100
-       default 1
+config SCHED_NITRO_HZBOOST_PERMILLE
+       int "Skale the HZ frequency value (per mille)"
+       range 1 100000
+       default 1000
        depends on (SCHED_NITRO_HZBOOST && X86_64 && SCHED_HRTICK)
        help
          Normally the scheduler code (scheduler_tick()) ticks with "HZ" frequency.
          With this frequency also "jiffies_64" is increased and is used by
          timerelated kernelcode.
-         This Option increases the schedulers tickerfrequency by multiplying
-         this multiplicator with HZ. However the jiffies_64 is STILL updated
-         with HZ-frequency and all the jiffy-based timecode is working further on.
+         This Option skales the schedulers tickerfrequency by multiplying
+         this per-mille value with HZ (and divides everything by 1000).
+         However the jiffies_64 is STILL updated with HZ-frequency and all the
+         jiffy-based timecode is working further on.

          Asyncron ns-time-based code will take advantage from this option and
          scheduling will become finer and more interactive.

-         WARNING: !! THIS OPTION WILL INCREASE YOUR "INTERRUPTS PER SECOND" FOR
+         WARNING: !! THIS OPTION MAY INCREASE YOUR "INTERRUPTS PER SECOND" FOR
                      EACH ONLINE CPU. THIS WILL ALSO INCREASE YOUR SYSTEMOVERHEAD !!
 endmenu

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6c95dfe..f8cec40 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -253,8 +253,8 @@ static struct ctl_table root_table[] = {

 #ifdef CONFIG_SCHED_NITRO_HZBOOST_USERSPAC
 #include "time/tick-internal.h"
-static int min_tick_period_HZmultiplicator = 1;
-static int max_tick_period_HZmultiplicator = 100;
+static int min_tick_period_HZscalepermille = 1;
+static int max_tick_period_HZscalepermille = 100000;
 #endif
 #ifdef CONFIG_SCHED_DEBUG
 static int min_sched_granularity_ns = 100000;          /* 100 usecs */
@@ -280,13 +280,13 @@ static struct ctl_table kern_table[] = {
        },
 #ifdef CONFIG_SCHED_NITRO_HZBOOST_USERSPAC
        {
-               .procname       = "nitro_hzmultiplicator",
-               .data           = &sysctl_tick_period_HZmultiplicator,
+               .procname       = "nitro_hz_permille",
+               .data           = &sysctl_tick_period_HZscalepermille,
                .maxlen         = sizeof(unsigned int),
                .mode           = 0644,
                .proc_handler   = tick_change_periodmultiplicator_handler,
-               .extra1         = &min_tick_period_HZmultiplicator,
-               .extra2         = &max_tick_period_HZmultiplicator,
+               .extra1         = &min_tick_period_HZscalepermille,
+               .extra2         = &max_tick_period_HZscalepermille,
        },
 #endif
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 1c62de8..a0176e245 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -170,7 +170,7 @@ static void tick_setup_device(struct tick_device *td,
                        tick_next_period = ktime_get();
 #ifdef CONFIG_SCHED_NITRO_HZBOOST
                        tick_HZbaseperiod = ktime_set(0, NSEC_PER_SEC / HZ);
-                       tick_change_periodmultiplicator(CONFIG_SCHED_NITRO_HZBOOST_MULTIPLICATOR);
+                       tick_change_periodmultiplicator(CONFIG_SCHED_NITRO_HZBOOST_PERMILLE);
 #else
                        tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
 #endif
@@ -427,8 +427,8 @@ void __init tick_init(void)
 }

 #ifdef CONFIG_SCHED_NITRO_HZBOOST_USERSPAC
-unsigned int sysctl_tick_period_HZmultiplicator        = ((unsigned long)CONFIG_SCHED_NITRO_HZBOOST_MULTIPLICATOR);
-static unsigned int __last_HZmultiplicator     = ((unsigned long)CONFIG_SCHED_NITRO_HZBOOST_MULTIPLICATOR);
+unsigned int sysctl_tick_period_HZscalepermille        = ((unsigned long)CONFIG_SCHED_NITRO_HZBOOST_PERMILLE);
+static unsigned int __last_HZscalepermille     = ((unsigned long)CONFIG_SCHED_NITRO_HZBOOST_PERMILLE);

 int tick_change_periodmultiplicator_handler(struct ctl_table *table, int write,
                                            void __user *buffer, size_t *lenp,
@@ -439,11 +439,11 @@ int tick_change_periodmultiplicator_handler(struct ctl_table *table, int write,
        if (ret || !write)
                return ret;

-       if (sysctl_tick_period_HZmultiplicator > 0)
-         if (__last_HZmultiplicator != sysctl_tick_period_HZmultiplicator) {
+       if (sysctl_tick_period_HZscalepermille > 0)
+         if (__last_HZscalepermille != sysctl_tick_period_HZscalepermille) {
            write_seqlock(&xtime_lock);
-           tick_change_periodmultiplicator(sysctl_tick_period_HZmultiplicator);
-           __last_HZmultiplicator = sysctl_tick_period_HZmultiplicator;
+           tick_change_periodmultiplicator(sysctl_tick_period_HZscalepermille);
+           __last_HZscalepermille = sysctl_tick_period_HZscalepermille;
            write_sequnlock(&xtime_lock);
          }

diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index eb60d32..26a1bda 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -17,19 +17,28 @@ extern int tick_do_timer_cpu __read_mostly;
 #ifdef CONFIG_SCHED_NITRO_HZBOOST
 extern ktime_t tick_HZbaseperiod;
 #ifdef CONFIG_SCHED_NITRO_HZBOOST_USERSPAC
-extern unsigned int sysctl_tick_period_HZmultiplicator;
+extern unsigned int sysctl_tick_period_HZscalepermille;
 extern int tick_change_periodmultiplicator_handler(struct ctl_table *table, int write,
                                            void __user *buffer, size_t *lenp,
                                            loff_t *ppos);
 #endif
 /*
  * proper locking has to be taken care outside
+ *
+ * scalepermille better be not zero!
+ *
  */
-static inline void tick_change_periodmultiplicator(const unsigned long long multiplicator)
+static inline void tick_change_periodmultiplicator(const unsigned long long scalepermille)
 {
-  printk( KERN_NOTICE "changing nitro hzboost multiplicator, new frequency: %llu x %lluHz\n", multiplicator, (unsigned long long)HZ);
-  tick_period = ktime_set(0, NSEC_PER_SEC / (HZ*multiplicator));
-  printk( KERN_NOTICE "scheduler nitro-patchset v1.0 Ilmenau 2012, by Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>\n");
+  unsigned long long __nanoseconds = (((unsigned long long)NSEC_PER_SEC) * 1000ULL) / scalepermille;
+  unsigned int i,j;
+
+  i = scalepermille / 1000;
+  j = scalepermille % 1000;
+
+  printk( KERN_NOTICE "changing nitro hzboost multiplicator, new frequency: %u.%03u x %lluHz\n", i, j, (unsigned long long)HZ);
+  tick_period = ktime_set(0, __nanoseconds / ((unsigned long long)HZ));
+  printk( KERN_NOTICE "scheduler nitro-patchset v1.0.1 Ilmenau 2012, by Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>\n");
 }
 #endif

-- 
1.7.3.4

