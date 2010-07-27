Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0G0KsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:48:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:34762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0KsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:48:08 -0400
Date: Tue, 27 Jul 2010 10:47:47 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] um: Convert to use read_persistent_clock
Message-ID: <tip-9f31f5774961a735687fee17953ab505b3df3abf@git.kernel.org>
Git-Commit-ID: 9f31f5774961a735687fee17953ab505b3df3abf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:47:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f31f5774961a735687fee17953ab505b3df3abf
Gitweb:     http://git.kernel.org/tip/9f31f5774961a735687fee17953ab505b3df3abf
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:24 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:55 +0200

um: Convert to use read_persistent_clock

This patch converts the um arch to use read_persistent_clock().
This allows it to avoid accessing xtime and wall_to_monotonic
directly.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>
LKML-Reference: <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
