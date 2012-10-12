Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946022Ab2JLRND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:13:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1945984Ab2JLRMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:12:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,578,1344182400"; 
   d="scan'208";a="5990994"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/4] srcu: export process_srcu()
Date: Sat, 13 Oct 2012 01:14:15 +0800
Message-Id: <1350062057-2439-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize complete at 2012/10/13 01:12:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

process_srcu() will be used in DEFINE_SRCU() (only).
Although it is exported, it is still an internal in srcu.h.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |    2 ++
 kernel/srcu.c        |    6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index a55ddb1..5cce128 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -78,6 +78,8 @@ int init_srcu_struct(struct srcu_struct *sp);
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+void process_srcu(struct work_struct *work);
+
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
  * @sp: srcu_struct in queue the callback
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 610486d..bfe4c5a 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -94,9 +94,6 @@ static inline void rcu_batch_move(struct rcu_batch *to, struct rcu_batch *from)
 	}
 }
 
-/* single-thread state-machine */
-static void process_srcu(struct work_struct *work);
-
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
@@ -639,7 +636,7 @@ static void srcu_reschedule(struct srcu_struct *sp)
 /*
  * This is the work-queue function that handles SRCU grace periods.
  */
-static void process_srcu(struct work_struct *work)
+void process_srcu(struct work_struct *work)
 {
 	struct srcu_struct *sp;
 
@@ -650,3 +647,4 @@ static void process_srcu(struct work_struct *work)
 	srcu_invoke_callbacks(sp);
 	srcu_reschedule(sp);
 }
+EXPORT_SYMBOL_GPL(process_srcu);
-- 
1.7.7.6

