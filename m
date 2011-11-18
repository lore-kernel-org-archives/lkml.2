Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1KRXoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:44:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1KRXoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:44:03 -0500
Date: Fri, 18 Nov 2011 15:43:42 -0800
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-a3e5d1091c1298ded486aba87c22fe90cb55ea6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        avagin@openvz.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        avagin@openvz.org, mingo@elte.hu
In-Reply-To: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
References: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don't call task_group() too many times in set_task_rq()
Git-Commit-ID: a3e5d1091c1298ded486aba87c22fe90cb55ea6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:43:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3e5d1091c1298ded486aba87c22fe90cb55ea6c
Gitweb:     http://git.kernel.org/tip/a3e5d1091c1298ded486aba87c22fe90cb55ea6c
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Fri, 11 Nov 2011 17:04:00 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 08:48:24 +0100

sched: Don't call task_group() too many times in set_task_rq()

It improves perfomance, especially if autogroup is enabled.

The size of set_task_rq() was 0x180 and now it is 0xa0.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1321020240-3874331-1-git-send-email-avagin@openvz.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0df6986..c9e3ab6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -793,14 +793,18 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
+	struct task_group *tg = task_group(p);
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
+	p->se.cfs_rq = tg->cfs_rq[cpu];
+	p->se.parent = tg->se[cpu];
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
+	p->rt.rt_rq  = tg->rt_rq[cpu];
+	p->rt.parent = tg->rt_se[cpu];
 #endif
 }
 
