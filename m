Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2CSIHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:07:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2CSIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:07:17 -0400
X-IronPort-AV: E=Sophos;i="4.73,611,1325433600"; 
   d="scan'208";a="4567342"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 2/4 V2] rcu: use "int trycount" instead of "bool expedited"
Date: Mon, 19 Mar 2012 16:12:12 +0800
Message-Id: <1332144734-9375-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:07,
	Serialize complete at 2012-03-19 16:05:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the value of trycount for the strategy for expedited or not in srcu.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 9e86ed7..2923541 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -251,16 +251,16 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  * we repeatedly block for 1-millisecond time periods.  This approach
  * has done well in testing, so there is no need for a config parameter.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY 5
+#define SYNCHRONIZE_SRCU_READER_DELAY	5
+#define SYNCHRONIZE_SRCU_TRYCOUNT	2
+#define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
 
 /*
  * Wait until all the readers(which starts before this wait_idx()
  * with the specified idx) complete.
  */
-static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
+static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
 {
-	int trycount = 0;
-
 	/*
 	 * SRCU read-side critical sections are normally short, so wait
 	 * a small amount of time before possibly blocking.
@@ -268,9 +268,10 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
 	if (!srcu_readers_active_idx_check(sp, idx)) {
 		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
 		while (!srcu_readers_active_idx_check(sp, idx)) {
-			if (expedited && ++ trycount < 10)
+			if (trycount > 0) {
+				trycount--;
 				udelay(SYNCHRONIZE_SRCU_READER_DELAY);
-			else
+			} else
 				schedule_timeout_interruptible(1);
 		}
 	}
@@ -284,7 +285,7 @@ static void srcu_flip(struct srcu_struct *sp)
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
+static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 {
 	int busy_idx;
 
@@ -301,8 +302,8 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 	 * There are some readers start with idx=0, and some others start
 	 * with idx=1. So two wait_idx()s are enough for synchronize:
 	 * __synchronize_srcu() {
-	 * 	wait_idx(sp, 0, expedited);
-	 * 	wait_idx(sp, 1, expedited);
+	 * 	wait_idx(sp, 0, trycount);
+	 * 	wait_idx(sp, 1, trycount);
 	 * }
 	 * When it returns, all started readers have complete.
 	 *
@@ -331,7 +332,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 	 * Because this probability is not high, wait_idx()
 	 * will normally not need to wait.
 	 */
-	wait_idx(sp, 1 - busy_idx, expedited);
+	wait_idx(sp, 1 - busy_idx, trycount);
 
 	/* flip the index to ensure the return of the next wait_idx() */
 	srcu_flip(sp);
@@ -339,7 +340,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 	/*
 	 * Now that wait_idx() has waited for the really old readers.
 	 */
-	wait_idx(sp, busy_idx, expedited);
+	wait_idx(sp, busy_idx, trycount);
 
 	mutex_unlock(&sp->mutex);
 }
@@ -360,7 +361,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, 0);
+	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
@@ -381,7 +382,7 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, 1);
+	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_EXP_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
-- 
1.7.4.4

