Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1GAPRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:17:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:33152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1GAPRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:17:36 -0400
Date: Fri, 1 Jul 2011 15:17:21 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-1c09ab0d257317f97e8629a3d0c8713d6dd9de4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, chengxu@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, chengxu@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <BANLkTi=87P3RoTF_UEtamNfc_XGxQXE__Q@mail.gmail.com>
References: <BANLkTi=87P3RoTF_UEtamNfc_XGxQXE__Q@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Skip autogroup when looking for all rt sched groups
Git-Commit-ID: 1c09ab0d257317f97e8629a3d0c8713d6dd9de4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:17:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c09ab0d257317f97e8629a3d0c8713d6dd9de4c
Gitweb:     http://git.kernel.org/tip/1c09ab0d257317f97e8629a3d0c8713d6dd9de4c
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 28 Jun 2011 10:51:31 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 10:39:08 +0200

sched: Skip autogroup when looking for all rt sched groups

Since commit ec514c48 ("sched: Fix rt_rq runtime leakage bug")
'cat /proc/sched_debug' will print data of root_task_group.rt_rq
multiple times.

This is because autogroup does not have its own rt group, instead
rt group of autogroup is linked to root_task_group.

So skip it when we are looking for all rt sched groups, and it
will also save some noop operation against root_task_group when
__disable_runtime()/__enable_runtime().

-v2: Based on Cheng Xu's idea which uses less code.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Cheng Xu <chengxu@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTi=87P3RoTF_UEtamNfc_XGxQXE__Q@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_autogroup.h |    1 +
 kernel/sched_rt.c        |   22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 0557705..c2f0e72 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -13,6 +13,7 @@ struct autogroup {
 	int			nice;
 };
 
+static inline bool task_group_is_autogroup(struct task_group *tg);
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b03cd89..97540f0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -185,11 +185,23 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 
 typedef struct task_group *rt_rq_iter_t;
 
-#define for_each_rt_rq(rt_rq, iter, rq) \
-	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
-	     (&iter->list != &task_groups) && \
-	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
-	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
+static inline struct task_group *next_task_group(struct task_group *tg)
+{
+	do {
+		tg = list_entry_rcu(tg->list.next,
+			typeof(struct task_group), list);
+	} while (&tg->list != &task_groups && task_group_is_autogroup(tg));
+
+	if (&tg->list == &task_groups)
+		tg = NULL;
+
+	return tg;
+}
+
+#define for_each_rt_rq(rt_rq, iter, rq)					\
+	for (iter = container_of(&task_groups, typeof(*iter), list);	\
+		(iter = next_task_group(iter)) &&			\
+		(rt_rq = iter->rt_rq[cpu_of(rq)]);)
 
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
