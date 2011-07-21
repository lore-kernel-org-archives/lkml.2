Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1GUS2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:28:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:49841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1GUS2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:28:34 -0400
Date: Thu, 21 Jul 2011 18:28:25 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-9598c82dcacadc3b9daa8170613fd054c6124d30@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110707053059.797714697@google.com>
References: <20110707053059.797714697@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don't update shares twice on on_rq parent
Git-Commit-ID: 9598c82dcacadc3b9daa8170613fd054c6124d30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:28:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9598c82dcacadc3b9daa8170613fd054c6124d30
Gitweb:     http://git.kernel.org/tip/9598c82dcacadc3b9daa8170613fd054c6124d30
Author:     Paul Turner <pjt@google.com>
AuthorDate: Wed, 6 Jul 2011 22:30:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:44 +0200

sched: Don't update shares twice on on_rq parent

In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
with additional weight.  However, we perform a double shares update on this
entity as we continue the shares update traversal from this point, despite
dequeue_entity() having already updated its queuing cfs_rq.
Avoid this by starting from the parent when we resume.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110707053059.797714697@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f88720b..6cdff84 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1370,6 +1370,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			 */
 			if (task_sleep && parent_entity(se))
 				set_next_buddy(parent_entity(se));
+
+			/* avoid re-evaluating load for this entity */
+			se = parent_entity(se);
 			break;
 		}
 		flags |= DEQUEUE_SLEEP;
