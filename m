Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2K2Inu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab2K2InE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:04 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299574"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 4/8] srcu: srcu_read_lock() can be called from offline cpu
Date: Thu, 29 Nov 2012 16:46:05 +0800
Message-Id: <1354178770-6028-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize complete at 2012/11/29 16:42:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SRCU is based on its own statemachine and it doesn't
relies on normal RCU now, its read critical section can be used in
offline cpu, so we remove the check and the comments.

It partially reverts c0d6d01b(the part for SRCU).

It also makes the codes match the comments in whatisRCU.txt:

g.	Do you need read-side critical sections that are respected
	even though they are in the middle of the idle loop, during
	user-mode execution, or on an offlined CPU?  If so, SRCU is the
	only choice that will work for you.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 6eb691b..ae3ee39 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -163,9 +163,6 @@ void srcu_barrier(struct srcu_struct *sp);
  * power mode. This way we can notice an extended quiescent state to
  * other CPUs that started a grace period. Otherwise we would delay any
  * grace period as long as we run in the idle task.
- *
- * Similarly, we avoid claiming an SRCU read lock held if the current
- * CPU is offline.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
@@ -173,8 +170,6 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
 		return 1;
 	if (rcu_is_cpu_idle())
 		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
 	return lock_is_held(&sp->dep_map);
 }
 
-- 
1.7.4.4

