Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0FAFud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:50:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52818 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab0FAFuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:50:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: [PATCH 4/5] oom-kill: give the dying task a higher priority (v4)
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100601144238.243A.A69D9226@jp.fujitsu.com>
References: <20100601144238.243A.A69D9226@jp.fujitsu.com>
Message-Id: <20100601144919.2443.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Jun 2010 14:50:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis Claudio R. Goncalves <lclaudio@uudg.org>

In a system under heavy load it was observed that even after the
oom-killer selects a task to die, the task may take a long time to die.

Right before sending a SIGKILL to the task selected by the oom-killer
this task has it's priority increased so that it can exit() exit soon,
freeing memory. That is accomplished by:

        /*
         * We give our sacrificial lamb high priority and access to
         * all the memory it needs. That way it should be able to
         * exit() and clear out its resources quickly...
         */
        p->rt.time_slice = HZ;
        set_tsk_thread_flag(p, TIF_MEMDIE);

It sounds plausible giving the dying task an even higher priority to be
sure it will be scheduled sooner and free the desired memory. It was
suggested on LKML using SCHED_FIFO:1, the lowest RT priority so that
this
task won't interfere with any running RT task.

Another good suggestion, implemented here, was to avoid boosting the
dying
task priority in case of mem_cgroup OOM.

Signed-off-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [rebase
on top my patches]
---
 mm/oom_kill.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b1df1d9..cbad4d4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -427,6 +427,18 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
 
 	force_sig(SIGKILL, p);
 
+	/*
+	 * If this is a system OOM (not a memcg OOM), speed up the recovery
+	 * by boosting the dying task priority to the lowest FIFO priority.
+	 * That helps with the recovery and avoids interfering with RT tasks.
+	 */
+	if (mem == NULL) {
+		struct sched_param param;
+
+		param.sched_priority = 1;
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+	}
+
 	return 0;
 }
 
-- 
1.6.5.2



