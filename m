Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2HERAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 13:00:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab2HERAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 13:00:48 -0400
Date: Sun, 5 Aug 2012 10:00:35 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-1d17d17484d40f2d5b35c79518597a2b25296996@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120804192114.GA28347@gmail.com>
References: <20120804192114.GA28347@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Fix adjustment cleanup bug in timekeeping_adjust()
Git-Commit-ID: 1d17d17484d40f2d5b35c79518597a2b25296996
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 10:00:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d17d17484d40f2d5b35c79518597a2b25296996
Gitweb:     http://git.kernel.org/tip/1d17d17484d40f2d5b35c79518597a2b25296996
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 4 Aug 2012 21:21:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 5 Aug 2012 12:37:14 +0200

time: Fix adjustment cleanup bug in timekeeping_adjust()

Tetsuo Handa reported that sporadically the system clock starts
counting up too quickly which is enough to confuse the hangcheck
timer to print a bogus stall warning.

Commit 2a8c0883 "time: Move xtime_nsec adjustment underflow handling
timekeeping_adjust" overlooked this exit path:

        } else
                return;

which should really be a proper exit sequence, fixing the bug as a
side effect.

Also make the flow more readable by properly balancing curly
braces.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: john.stultz@linaro.org
Cc: a.p.zijlstra@chello.nl
Cc: richardcochran@gmail.com
Cc: prarit@redhat.com
Link: http://lkml.kernel.org/r/20120804192114.GA28347@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/timekeeping.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

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
