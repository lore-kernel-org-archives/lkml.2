Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2E3R4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:56:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41411 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab2E3R4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:56:40 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, stable@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: Fix CLOCK_MONOTONIC inconsistency during leapsecond
Date: Wed, 30 May 2012 10:54:57 -0700
Message-Id: <1338400497-12420-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053017-1780-0000-0000-000006033579
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000278; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00143738; UDB=6.00033057; UTC=2012-05-30
 17:56:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we update wall_to_monotonic when adding a leapsecond.
This could otherwise cause discontinuities in CLOCK_MONOTONIC.

This fixes a regression caused by
6b43ae8a619d17c4935c3320d2ef9e92bdeed05d

CC: stable@kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..6f46a00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate raw time */
@@ -1077,6 +1078,7 @@ static void update_wall_time(void)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	timekeeping_update(false);
-- 
1.7.3.2.146.gca209

