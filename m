Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0KTCJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:09:24 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39183 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab0KTCJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:09:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/5] sched: Enable might_sleep before initializing drivers.
Date: Fri, 19 Nov 2010 18:08:50 -0800
Message-Id: <1290218934-8544-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

This allows detection of init bugs in built-in drivers.

CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/sched.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index aa14a56..0b58415 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8104,13 +8104,24 @@ static inline int preempt_count_equals(int preempt_offset)
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }
 
+static int __might_sleep_init_called;
+int __init __might_sleep_init(void)
+{
+	__might_sleep_init_called = 1;
+	return 0;
+}
+early_initcall(__might_sleep_init);
+
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
-	    system_state != SYSTEM_RUNNING || oops_in_progress)
+	    oops_in_progress)
+		return;
+	if (system_state != SYSTEM_RUNNING &&
+	    (!__might_sleep_init_called || system_state != SYSTEM_BOOTING))
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 		return;
-- 
1.7.3.2.146.gca209

