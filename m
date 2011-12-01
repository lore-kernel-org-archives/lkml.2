Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1LAHVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:21:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1LAHVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:21:02 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] clocksource: get rid of clocksource_calc_mult_shift()
Date: Thu,  1 Dec 2011 15:20:16 +0800
Message-Id: <1322724016-9770-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encourage the user to use clocksource_register_hz/khz(), and
lose the burden of maintainer.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |    3 ---
 kernel/time/clocksource.c   |   19 -------------------
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index a02a8d7..f018278 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -314,9 +314,6 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 	__clocksource_updatefreq_scale(cs, 1000, khz);
 }
 
-extern void
-clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec);
-
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void
 update_vsyscall(struct timespec *ts, struct timespec *wtm,
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5119042..a75bd7b 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -724,25 +724,6 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 }
 EXPORT_SYMBOL_GPL(__clocksource_register_scale);
 
-void clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
-{
-	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
-				NSEC_PER_SEC, minsec);
-
-	/*
-	 * for clocksources that have large mults, to avoid overflow.
-	 * Since mult may be adjusted by ntp, add an safety extra margin
-	 *
-	 */
-	cs->maxadj = clocksource_max_adjustment(cs);
-	while ((cs->mult + cs->maxadj < cs->mult)
-		|| (cs->mult - cs->maxadj > cs->mult)) {
-		cs->mult >>= 1;
-		cs->shift--;
-		cs->maxadj = clocksource_max_adjustment(cs);
-	}
-}
-
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
-- 
1.7.5.4

