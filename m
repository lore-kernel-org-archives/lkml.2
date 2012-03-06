Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab2CFJxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38725 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965120Ab2CFJxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:15 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4464392"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 4/6] remove flip_idx_and_wait()
Date: Tue, 6 Mar 2012 17:57:36 +0800
Message-Id: <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
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

flip and check are the basic steps of gp. call them directly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index d5f3450..d101ed5 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -300,23 +300,12 @@ static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
 }
 
 /*
- * Flip the readers' index by incrementing ->completed, then wait
- * until there are no more readers using the counters referenced by
- * the old index value.  (Recall that the index is the bottom bit
- * of ->completed.)
- *
- * Of course, it is possible that a reader might be delayed for the
- * full duration of flip_idx_and_wait() between fetching the
- * index and incrementing its counter.  This possibility is handled
- * by the next __synchronize_srcu() invoking wait_idx() for such readers
- * before starting a new grace period.
+ * Flip the readers' index by incrementing ->completed, then new
+ * readers will use counters referenced on new index value.
  */
-static void flip_idx_and_wait(struct srcu_struct *sp, int trycount)
+static void srcu_flip(struct srcu_struct *sp)
 {
-	int idx;
-
-	idx = sp->completed++ & 0x1;
-	wait_idx(sp, idx, trycount);
+	ACCESS_ONCE(sp->completed)++;
 }
 
 /*
@@ -362,10 +351,20 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 
 	/*
 	 * Now that wait_idx() has waited for the really old readers,
-	 * invoke flip_idx_and_wait() to flip the counter and wait
-	 * for current SRCU readers.
+	 *
+	 * Flip the readers' index by incrementing ->completed, then wait
+	 * until there are no more readers using the counters referenced by
+	 * the old index value.  (Recall that the index is the bottom bit
+	 * of ->completed.)
+	 *
+	 * Of course, it is possible that a reader might be delayed for the
+	 * full duration of flip_idx_and_wait() between fetching the
+	 * index and incrementing its counter.  This possibility is handled
+	 * by the next __synchronize_srcu() invoking wait_idx() for such
+	 * readers before starting a new grace period.
 	 */
-	flip_idx_and_wait(sp, trycount);
+	srcu_flip(sp);
+	wait_idx(sp, (sp->completed - 1) & 0x1, trycount);
 
 	mutex_unlock(&sp->mutex);
 }
-- 
1.7.4.4

