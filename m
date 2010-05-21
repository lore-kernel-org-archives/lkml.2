Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab0EUCD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 22:03:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:38006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab0EUCDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 22:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,274,1272870000"; 
   d="scan'208,223";a="519939020"
Date: Fri, 21 May 2010 10:15:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 1/3] timekeeping: moving xtime's init to a later time
Message-ID: <20100521101553.36b8dff6@feng-i7>
In-Reply-To: <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
	<20100512103422.1d59cc85@feng-i7>
	<alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2451f205e29be57b30f0c50759c1b05a67bb97d1 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 19 May 2010 16:57:20 +0800
Subject: [PATCH 1/3] timekeeping: moving xtime's init to a later time

xtime doesn't need to be inited early, move it to a subsys_initcall,
as most of its consumers come from userspace. It will also give enough
time for some MMIO based wallclock devices to init

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/time/timekeeping.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 39f6177..7bc32de 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -529,26 +529,37 @@ void __attribute__((weak)) read_boot_clock(struct timespec *ts)
 }
 
 /*
- * timekeeping_init - Initializes the clocksource and common timekeeping values
+ * timekeeping_init - Initializes the clocksource
  */
 void __init timekeeping_init(void)
 {
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot;
-
-	read_persistent_clock(&now);
-	read_boot_clock(&boot);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	ntp_init();
-
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
+	ntp_init();
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+}
+
+/*
+ *  timekeeping_late_init - Initaizes the common timekeeping values
+ */
+static int __init timekeeping_late_init(void)
+{
+	unsigned long flags;
+	struct timespec now, boot;
+
+	read_persistent_clock(&now);
+	read_boot_clock(&boot);
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
 	xtime.tv_sec = now.tv_sec;
 	xtime.tv_nsec = now.tv_nsec;
 	raw_time.tv_sec = 0;
@@ -563,7 +574,10 @@ void __init timekeeping_init(void)
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	return 0;
 }
+subsys_initcall(timekeeping_late_init);
 
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
-- 
1.6.3.3
