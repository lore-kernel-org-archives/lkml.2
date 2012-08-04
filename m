Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2HDTVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 15:21:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54671 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2HDTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 15:21:19 -0400
Date: Sat, 4 Aug 2012 21:21:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] time: Fix adjustment cleanup bug in timekeeping_adjust()
Message-ID: <20120804192114.GA28347@gmail.com>
References: <201208032318.FGJ64576.tOMVLOFHFQOFJS@I-love.SAKURA.ne.jp>
 <201208042024.GFG34353.OFtFVQJMLOHFSO@I-love.SAKURA.ne.jp>
 <201208042110.EFH81212.OSVOLMOtFQHJFF@I-love.SAKURA.ne.jp>
 <201208042246.HBH81275.FVOOSLtJFMQOFH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208042246.HBH81275.FVOOSLtJFMQOFH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Hello.
> 
> Bisected to 2a8c0883 "time: Move xtime_nsec adjustment 
> underflow handling timekeeping_adjust".
> 
> Would you check?

probably caused by this stray return in timekeeping_adjust():

        } else
                return;

which should really be a proper goto - like the (totally 
untested!) patch below.

Does this fix the bug for you?

Thanks,

	Ingo

-------------

Subject: time: Fix adjustment cleanup bug in timekeeping_adjust()

Also make the flow more readable by properly balancing curly 
braces.

Signed-off-by: Ingo Molnar <mingo@kernel.org>


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
