Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967086Ab0GSWMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:12:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9220 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966632Ab0GSWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:12:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6048"; a="47970765"
Message-ID: <4C44CDD2.1070708@codeaurora.org>
Date: Mon, 19 Jul 2010 15:12:34 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, akinobu.mita@gmail.com,
        sboyd@codeaurora.org
Subject: [PATCH] timer: Added usleep[_range] timer
References: <4C44BB69.8050300@codeaurora.org> <4C44CC2E.405@linux.intel.com>
In-Reply-To: <4C44CC2E.405@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I like the general idea, but I kinda doubt the "interruptible" version
> makes sense for this...
> do you have any users for that in mind? if not... can we leave the
> interruptible version out... makes it simpler by a lot.
> 

Respun without interruptible...


>From 08b717cf4f76d7578cb20c1b1444d89a9331ce02 Mon Sep 17 00:00:00 2001
From: Patrick Pannuto <ppannuto@codeaurora.org>
Date: Mon, 19 Jul 2010 15:09:26 -0700
Subject: [PATCH] timer: Added usleep[_range] timer

usleep[_range] are finer precision implementations of msleep
and are designed to be drop-in replacements for udelay where
a precise sleep / busy-wait is unnecessary. They also allow
an easy interface to specify slack when a precise (ish)
wakeup is unnecessary to help minimize wakeups

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 include/linux/delay.h |    6 ++++++
 kernel/timer.c        |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..0e303d1 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -45,6 +45,12 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
+void usleep_range(unsigned long min, unsigned long max);
+
+static inline void usleep(unsigned long usecs)
+{
+	usleep_range(usecs, usecs);
+}
 
 static inline void ssleep(unsigned int seconds)
 {
diff --git a/kernel/timer.c b/kernel/timer.c
index ee305c8..4e6746f 100644
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
-- 
1.7.1.1
