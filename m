Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0CRVrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:47:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53596 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab0CRVrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:47:33 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sonic Zhang <sonic.adi@gmail.com>
Subject: [PATCH] time: Fix accumulation bug triggered by long delay.
Date: Thu, 18 Mar 2010 14:47:30 -0700
Message-Id: <1268948850-5225-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logarithmic accumulation done in the timekeeping has some overflow
protection that limits the max shift value. That means it will take
more then shift loops to accumulate all of the cycles. This causes
the shift decrement to underflow, which causes the loop to never exit.

The simplest fix would be simply to do a:
	if (shift)
		shift--;

However that is not optimal, as we know the cycle offset is larger
then the interval << shift, the above would make shift drop to zero,
then we would be spinning for quite awhile accumulating at interval
chunks at a time.

Instead, this patch only decreases shift if the offset is smaller
then cycle_interval << shift.  This makes sure we accumulate using
the largest chunks possible without overflowing tick_length, and limits
the number of iterations through the loop.

This issue was found and reported by Sonic Zhang, who also tested the fix.
Many thanks your explanation and testing!

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Sonic Zhang <sonic.adi@gmail.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1673637..39f6177 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -818,7 +818,8 @@ void update_wall_time(void)
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
-		shift--;
+		if(offset < timekeeper.cycle_interval<<shift)
+			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
-- 
1.6.0.4

