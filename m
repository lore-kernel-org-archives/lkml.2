Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2KCWC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:02:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2KCWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/9] sched: Don't define unthrottle_offline_cfs_rqs when !CONFIG_SMP
Date: Sat,  3 Nov 2012 23:02:25 +0100
Message-Id: <1351980150-24145-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since unthrottle_offline_cfs_rqs is only ever invoked when CONFIG_SMP
let's pre-processor it out when SMP is not configured. This change
suppresses the build error below when !CONFIG_SMP.

kernel/sched/fair.c:2055:13: warning: ‘unthrottle_offline_cfs_rqs’ defined but not used [-Wunused-function]

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/sched/fair.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..c0aab13 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2052,6 +2052,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
+#if defined CONFIG_SMP
 static void unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
@@ -2071,6 +2072,7 @@ static void unthrottle_offline_cfs_rqs(struct rq *rq)
 			unthrottle_cfs_rq(cfs_rq);
 	}
 }
+#endif /* CONFIG_SMP */
 
 #else /* CONFIG_CFS_BANDWIDTH */
 static __always_inline
@@ -2106,7 +2108,9 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+#if defined CONFIG_SMP
 static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+#endif /* CONFIG_SMP */
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
-- 
1.7.9.5

