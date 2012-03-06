Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab2CFJxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965121Ab2CFJxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:15 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4464393"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 3/6] use "int trycount" instead of "bool expedited"
Date: Tue, 6 Mar 2012 17:57:35 +0800
Message-Id: <1331027858-7648-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:20,
	Serialize complete at 2012-03-06 17:51:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index fbe2d5f..d5f3450 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -254,12 +254,12 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  * we repeatedly block for 1-millisecond time periods.  This approach
  * has done well in testing, so there is no need for a config parameter.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY 5
+#define SYNCHRONIZE_SRCU_READER_DELAY	5
+#define SYNCHRONIZE_SRCU_TRYCOUNT	2
+#define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
 
-static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
+static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
 {
-	int trycount = 0;
-
 	/*
 	 * If a reader fetches the index before the ->completed increment,
 	 * but increments its counter after srcu_readers_active_idx_check()
@@ -278,9 +278,10 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
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
@@ -310,18 +311,18 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
  * by the next __synchronize_srcu() invoking wait_idx() for such readers
  * before starting a new grace period.
  */
-static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
+static void flip_idx_and_wait(struct srcu_struct *sp, int trycount)
 {
 	int idx;
 
 	idx = sp->completed++ & 0x1;
-	wait_idx(sp, idx, expedited);
+	wait_idx(sp, idx, trycount);
 }
 
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
+static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 {
 	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
 			   !lock_is_held(&rcu_bh_lock_map) &&
@@ -357,14 +358,14 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
 	 * fetching ->completed and incrementing their counter, wait_idx()
 	 * will normally not need to wait.
 	 */
-	wait_idx(sp, (sp->completed - 1) & 0x1, expedited);
+	wait_idx(sp, (sp->completed - 1) & 0x1, trycount);
 
 	/*
 	 * Now that wait_idx() has waited for the really old readers,
 	 * invoke flip_idx_and_wait() to flip the counter and wait
 	 * for current SRCU readers.
 	 */
-	flip_idx_and_wait(sp, expedited);
+	flip_idx_and_wait(sp, trycount);
 
 	mutex_unlock(&sp->mutex);
 }
@@ -385,7 +386,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, 0);
+	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
@@ -406,7 +407,7 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, 1);
+	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_EXP_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
-- 
1.7.4.4

