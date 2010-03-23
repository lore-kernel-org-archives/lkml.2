Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0CWPnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:43:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:43295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab0CWPnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:43:07 -0400
Date: Tue, 23 Mar 2010 15:42:43 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sonic.adi@gmail.com, johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, sonic.adi@gmail.com, tglx@linutronix.de
In-Reply-To: <1268948850-5225-1-git-send-email-johnstul@us.ibm.com>
References: <1268948850-5225-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Fix accumulation bug triggered by long delay.
Message-ID: <tip-830ec0458c390f29c6c99e1ff7feab9e36368d12@git.kernel.org>
Git-Commit-ID: 830ec0458c390f29c6c99e1ff7feab9e36368d12
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Mar 2010 15:42:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  830ec0458c390f29c6c99e1ff7feab9e36368d12
Gitweb:     http://git.kernel.org/tip/830ec0458c390f29c6c99e1ff7feab9e36368d12
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 18 Mar 2010 14:47:30 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 23 Mar 2010 16:41:01 +0100

time: Fix accumulation bug triggered by long delay.

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

Reported-by: Sonic Zhang <sonic.adi@gmail.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Sonic Zhang <sonic.adi@gmail.com>
LKML-Reference: <1268948850-5225-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
