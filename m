Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2B1Abl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:31:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39272 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2B1A3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 6/7] time: Reduce timekeeper read lock hold time
Date: Mon, 27 Feb 2012 16:29:33 -0800
Message-Id: <1330388974-27793-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-1780-0000-0000-00000385A546
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000252; HX=3.00000183; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00117492; UDB=6.00028615; UTC=2012-02-28
 00:29:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that timekeeper updates are done with a shadow copy,
we can reduce the readlock hold time to only the update.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ebfb037..5a444b8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1062,7 +1062,6 @@ static void update_wall_time(void)
 	s64 remainder;
 
 	spin_lock_irqsave(&timekeeper.wlock, flags);
-	write_seqcount_begin(&timekeeper.rlock);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1145,13 +1144,18 @@ static void update_wall_time(void)
 		second_overflow();
 	}
 
-
+	write_seqcount_begin(&timekeeper.rlock);
+	/*
+	 * We have to store rlock back to tk, otherwise we'll
+	 * corrupt the timeekeerp.rlock when we copy over timekeeper
+	 */
+	tk.rlock = timekeeper.rlock;
 	timekeeper = tk;
 	timekeeper.clock->cycle_last = timekeeper.cycle_last;
 	timekeeping_update(&timekeeper, false);
+	write_seqcount_end(&timekeeper.rlock);
 
 out:
-	write_seqcount_end(&timekeeper.rlock);
 	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 }
-- 
1.7.3.2.146.gca209

