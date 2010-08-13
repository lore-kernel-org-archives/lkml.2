Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036Ab0HMSbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:31:02 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40543 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0HMSbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:31:01 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] time: Workaround gcc loop optimization that causes 64bit div errors
Date: Fri, 13 Aug 2010 11:30:58 -0700
Message-Id: <1281724258-19898-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early 4.3 versions of gcc apparently aggressively optimize the raw
time accumulation loop, replacing it with a divide.

On 32bit systems, this causes the following link errors:
	undefined reference to `__umoddi3'
	undefined reference to `__udivdi3'

The gcc issue has been fixed in 4.4 and greater.

This patch replaces the accumulation loop with a do_div, as suggested
by Linus.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Jason Wessel <jason.wessel@windriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>
CC: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/time/timekeeping.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e960d82..49010d8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -710,9 +710,10 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	/* Accumulate raw time */
 	raw_nsecs = timekeeper.raw_interval << shift;
 	raw_nsecs += raw_time.tv_nsec;
-	while (raw_nsecs >= NSEC_PER_SEC) {
-		raw_nsecs -= NSEC_PER_SEC;
-		raw_time.tv_sec++;
+	if (raw_nsecs >= NSEC_PER_SEC) {
+		u64 raw_secs = raw_nsecs;
+		raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
+		raw_time.tv_sec += raw_secs;
 	}
 	raw_time.tv_nsec = raw_nsecs;
 
-- 
1.6.0.4

