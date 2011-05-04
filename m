Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1EDDMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:12:00 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60283 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab1EDDL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:11:59 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: Add locking to xtime access in get_seconds()
Date: Tue,  3 May 2011 20:11:48 -0700
Message-Id: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

So get_seconds() has always been lock free, with the assumption
that accessing a long will be atomic.

However, recently I came across an odd bug where time() access could
occasionally be inconsistent, but only on power7 hardware. The
same code paths on power6 or x86 could not reproduce the issue.

After adding careful debugging checks to any xtime manipulation, and
not seeing any inconsistencies on the kernel side, I realized that
with no locking in the get_seconds path, its could be that two
sequential calls to time() could be executed out of order on newer
hardware, causing the inconsistency to appear in userland.

After adding the following locking, the issue cannot be reproduced.

Wanted to run this by the power guys to make sure the theory above
sounds sane.

CC: Paul Mackerras <paulus@samba.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Anton Blanchard <anton@samba.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8ad5d57..89c7582 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -975,7 +975,15 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return xtime.tv_sec;
+	unsigned long seq, now;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		now = xtime.tv_sec;
+	} while (read_seqretry(&xtime_lock, seq));
+
+	return now;
 }
 EXPORT_SYMBOL(get_seconds);
 
-- 
1.7.3.2.146.gca209

