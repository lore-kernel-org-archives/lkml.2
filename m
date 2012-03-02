Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab2CBHNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:21 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49039 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965139Ab2CBHNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 6/9] time: Reduce timekeeper read lock hold time
Date: Thu,  1 Mar 2012 23:12:45 -0800
Message-Id: <1330672368-32290-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-8974-0000-0000-000006E1F4DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that timekeeper updates are done with a shadow copy,
we can reduce the readlock hold time to only the update.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ed8cb51..97982b1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1071,7 +1071,6 @@ static void update_wall_time(void)
 	s64 remainder;
 
 	spin_lock_irqsave(&timekeeper_wlock, flags);
-	write_seqcount_begin(&timekeeper_rlock);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1155,13 +1154,13 @@ static void update_wall_time(void)
 		second_overflow();
 	}
 
-
+	write_seqcount_begin(&timekeeper_rlock);
 	timekeeper = shadow_tk;
 	timekeeper.clock->cycle_last = timekeeper.cycle_last;
 	timekeeping_update(&timekeeper, false);
+	write_seqcount_end(&timekeeper_rlock);
 
 out:
-	write_seqcount_end(&timekeeper_rlock);
 	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 }
-- 
1.7.3.2.146.gca209

