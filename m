Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0GNA4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:56:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39494 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab0GNA4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:35 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Jeff Dike <jdike@addtoit.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/11] Convert um to use read_persistent_clock
Date: Tue, 13 Jul 2010 17:56:24 -0700
Message-Id: <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-4-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the um arch to use read_persistent_clock().
This allows it to avoid accessing xtime and wall_to_monotonic
directly.

This patch is un-tested, so any help by testers or maintainers would
be greatly appreciated!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Jeff Dike <jdike@addtoit.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/kernel/time.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index c8b9c46..2b8b262 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -102,16 +102,17 @@ static void __init setup_itimer(void)
 	clockevents_register_device(&itimer_clockevent);
 }
 
+void read_persistent_clock(struct timespec *ts)
+{
+	nsecs = os_nsecs();
+	set_normalized_timespec(ts, nsecs / NSEC_PER_SEC,
+				nsecs % NSEC_PER_SEC);
+}
+
 void __init time_init(void)
 {
 	long long nsecs;
 
 	timer_init();
-
-	nsecs = os_nsecs();
-	set_normalized_timespec(&wall_to_monotonic, -nsecs / NSEC_PER_SEC,
-				-nsecs % NSEC_PER_SEC);
-	set_normalized_timespec(&xtime, nsecs / NSEC_PER_SEC,
-				nsecs % NSEC_PER_SEC);
 	late_time_init = setup_itimer;
 }
-- 
1.6.0.4

