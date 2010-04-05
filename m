Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0DEUZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:25:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38790 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab0DEUYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:41 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 5/6] futex: handle timeout inside adaptive lock spin
Date: Mon,  5 Apr 2010 13:23:58 -0700
Message-Id: <1270499039-23728-6-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 kernel/futex.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c33ac2a..af61dcd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2385,6 +2385,7 @@ out:
 /**
  * trylock_futex_adaptive() - Try to acquire the futex lock in a busy loop
  * @uaddr: the futex user address
+ * @timeout: absolute timeout or NULL if none
  *
  * Try to acquire a futex lock in a loop until the owner changes or the owner
  * is descheduled. To lock the futex, set the value to the current TID.
@@ -2394,10 +2395,11 @@ out:
  *  1 - Futex lock acquired
  * <0 - On error
  */
-static int trylock_futex_adaptive(u32 __user *uaddr)
+static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
 {
 	int ret = 0;
 	u32 curval;
+	ktime_t now;
 
 	for (;;) {
 		struct thread_info *owner;
@@ -2433,6 +2435,22 @@ static int trylock_futex_adaptive(u32 __user *uaddr)
 		if (need_resched())
 			break;
 
+		if (timeout) {
+			now = ktime_get();
+/* FIXME: consider creating ktime_less_than(lhs, rhs) */
+#if (BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)
+			if (timeout->tv64 < now.tv64)
+				break;
+#else
+			if (timeout->sec < now.sec ||
+			    (timeout->sec == now.sec &&
+			     timeout->nsec < now.nsec)) {
+				ret = -ETIMEDOUT;
+				break;
+			}
+#endif
+		}
+
 		cpu_relax();
 	}
 	return ret;
@@ -2480,7 +2498,7 @@ retry:
 #ifdef CONFIG_SMP
 	if (flags & FLAGS_ADAPTIVE) {
 		preempt_disable();
-		ret = trylock_futex_adaptive(uaddr);
+		ret = trylock_futex_adaptive(uaddr, time);
 		preempt_enable();
 
 		/* We got the lock. */
@@ -2489,7 +2507,7 @@ retry:
 			goto out;
 		}
 
-		/* We encountered an error, -EFAULT most likely. */
+		/* We encountered an error, -EFAULT or -ETIMEDOUT */
 		if (ret)
 			goto out;
 	}
-- 
1.6.3.3

