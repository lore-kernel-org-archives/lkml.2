Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1EPKiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:38:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:50389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab1EPKiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:38:09 -0400
Date: Mon, 16 May 2011 10:37:53 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-db44fc017d5989302713ab4e7f9e922b648f4b59@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <20110509140705.GA2219@zhy>
References: <20110509140705.GA2219@zhy>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Avoid going ahead if ->cpus_allowed is not changed
Git-Commit-ID: db44fc017d5989302713ab4e7f9e922b648f4b59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 10:37:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db44fc017d5989302713ab4e7f9e922b648f4b59
Gitweb:     http://git.kernel.org/tip/db44fc017d5989302713ab4e7f9e922b648f4b59
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Mon, 9 May 2011 22:07:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 May 2011 11:01:18 +0200

sched: Avoid going ahead if ->cpus_allowed is not changed

If cpumask_equal(&p->cpus_allowed, new_mask) is true, seems
there is no reason to prevent set_cpus_allowed_ptr() return
directly.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110509140705.GA2219@zhy
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b8b9a7d..70bec4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5946,13 +5946,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 
 	rq = task_rq_lock(p, &flags);
 
+	if (cpumask_equal(&p->cpus_allowed, new_mask))
+		goto out;
+
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
 		ret = -EINVAL;
 		goto out;
 	}
