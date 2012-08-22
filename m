Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2HVPA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab2HVPAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:00:48 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 17/36] autonuma: prevent select_task_rq_fair to return -1
Date: Wed, 22 Aug 2012 16:59:01 +0200
Message-Id: <1345647560-30387-18-git-send-email-aarcange@redhat.com>
In-Reply-To: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_idlest_cpu when run up on all domain levels shouldn't normally
return -1. With the introduction of the NUMA affinity check that
should be still true most of the time, but it's not guaranteed if the
NUMA affinity of the task changes very fast. So better not to depend
on timings.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/sched/fair.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 42a88fa..677b99e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2794,6 +2794,17 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 unlock:
 	rcu_read_unlock();
 
+#ifdef CONFIG_AUTONUMA
+	if (new_cpu < 0)
+		/*
+		 * find_idlest_cpu() may return -1 if
+		 * task_autonuma_cpu() changes all the time, it's very
+		 * unlikely, but we must handle it if it ever happens.
+		 */
+		new_cpu = prev_cpu;
+#endif
+	BUG_ON(new_cpu < 0);
+
 	return new_cpu;
 }
 #endif /* CONFIG_SMP */
