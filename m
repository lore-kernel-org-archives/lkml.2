Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2HERcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 13:32:06 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49469 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2HERcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 13:32:04 -0400
Date: Sun, 5 Aug 2012 19:31:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: [GIT PULL] time fix
Message-ID: <20120805173158.GA15215@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: 1d17d17484d40f2d5b35c79518597a2b25296996 time: Fix adjustment cleanup bug in timekeeping_adjust()

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      time: Fix adjustment cleanup bug in timekeeping_adjust()


 kernel/time/timekeeping.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2988bc8..e16af19 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -923,20 +923,22 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = timekeeping_bigadjust(tk, error, &interval,
-							&offset);
-	} else if (error < -interval) {
-		/* See comment above, this is just switched for the negative */
-		error >>= 2;
-		if (likely(error >= -interval)) {
-			adj = -1;
-			interval = -interval;
-			offset = -offset;
-		} else
-			adj = timekeeping_bigadjust(tk, error, &interval,
-							&offset);
-	} else
-		return;
+			adj = timekeeping_bigadjust(tk, error, &interval, &offset);
+	} else {
+		if (error < -interval) {
+			/* See comment above, this is just switched for the negative */
+			error >>= 2;
+			if (likely(error >= -interval)) {
+				adj = -1;
+				interval = -interval;
+				offset = -offset;
+			} else {
+				adj = timekeeping_bigadjust(tk, error, &interval, &offset);
+			}
+		} else {
+			goto out_adjust;
+		}
+	}
 
 	if (unlikely(tk->clock->maxadj &&
 		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
@@ -999,6 +1001,7 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	tk->xtime_nsec -= offset;
 	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
 
+out_adjust:
 	/*
 	 * It may be possible that when we entered this function, xtime_nsec
 	 * was very small.  Further, if we're slightly speeding the clocksource
