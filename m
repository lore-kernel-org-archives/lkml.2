Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab0FCGZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:25:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54615 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0FCGZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:25:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 09/12] oom: remove PF_EXITING check completely
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Message-Id: <20100603152436.7262.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 15:25:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, PF_EXITING check is completely broken. because 1) It only
care main-thread and ignore sub-threads 2) If user enable core-dump
feature, it can makes deadlock because the task during coredump ignore
SIGKILL.

The deadlock is certenaly worst result, then, minor PF_EXITING
optimization worth is relatively ignorable.

This patch removes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/oom_kill.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 6360c56..5d723fb 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -302,24 +302,6 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
 
-		/*
-		 * This is in the process of releasing memory so wait for it
-		 * to finish before killing some other task by mistake.
-		 *
-		 * However, if p is the current task, we allow the 'kill' to
-		 * go ahead if it is exiting: this will simply set TIF_MEMDIE,
-		 * which will allow it to gain access to memory reserves in
-		 * the process of exiting and releasing its resources.
-		 * Otherwise we could get an easy OOM deadlock.
-		 */
-		if (p->flags & PF_EXITING) {
-			if (p != current)
-				return ERR_PTR(-1UL);
-
-			chosen = p;
-			*ppoints = ULONG_MAX;
-		}
-
 		points = badness(p, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
@@ -444,15 +426,6 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem);
 
-	/*
-	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just set TIF_MEMDIE so it can die quickly
-	 */
-	if (p->flags & PF_EXITING) {
-		__oom_kill_process(p, mem, 0);
-		return 0;
-	}
-
 	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
 					message, task_pid_nr(p), p->comm, points);
 
-- 
1.6.5.2



