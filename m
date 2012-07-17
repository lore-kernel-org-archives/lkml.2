Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab2GQVvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:51:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34345 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2GQVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:50:34 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, stable@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 03/11] 2.6.34.x: timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
Date: Tue, 17 Jul 2012 17:49:23 -0400
Message-Id: <1342561771-55678-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342561771-55678-1-git-send-email-johnstul@us.ibm.com>
References: <1342561771-55678-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071721-1780-0000-0000-0000077E407E
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000287; HX=3.00000193; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00157490; UDB=6.00035526; UTC=2012-07-17
 21:50:31
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
Cc: stable@kernel.org
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
index df1e939..f8d4877 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -759,6 +759,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		xtime.tv_sec++;
 		leap = second_overflow(xtime.tv_sec);
 		xtime.tv_sec += leap;
+		wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate into raw time */
-- 
1.7.9.5

