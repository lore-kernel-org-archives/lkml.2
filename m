Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2GQWIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:08:02 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41306 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab2GQWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:05:47 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 03/11] 2.6.32.x: timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
Date: Tue, 17 Jul 2012 18:05:27 -0400
Message-Id: <1342562735-55870-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com>
References: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071722-5930-0000-0000-000009F67FB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

This is a backport of fad0c66c4bb836d57a5f125ecd38bed653ca863a
which resolves a bug the previous commit.

Commit 6b43ae8a61 (ntp: Fix leap-second hrtimer livelock) broke the
leapsecond update of CLOCK_MONOTONIC. The missing leapsecond update to
wall_to_monotonic causes discontinuities in CLOCK_MONOTONIC.

Adjust wall_to_monotonic when NTP inserted a leapsecond.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Tested-by: Richard Cochran <richardcochran@gmail.com>
Link: http://lkml.kernel.org/r/1338400497-12420-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 00e2fae..6d19a00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -780,6 +780,7 @@ void update_wall_time(void)
 			xtime.tv_sec++;
 			leap = second_overflow(xtime.tv_sec);
 			xtime.tv_sec += leap;
+			wall_to_monotonic.tv_sec -= leap;
 		}
 
 		raw_time.tv_nsec += timekeeper.raw_interval;
-- 
1.7.9.5

