Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0FHLzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:55:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47259 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0FHLzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:55:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 02/10] oom: remove verbose argument from __oom_kill_process()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608205454.7680.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:55:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, verbose argument is unused. This patch remove it.

[remark: this patch is needed to fold to "oom: remove PF_EXITING
check completely"]

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0d7397b..3c83fba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -384,20 +384,18 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
  * set.
  */
-static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
-			      int verbose)
+static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem)
 {
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 1;
 
-	if (verbose)
-		printk(KERN_ERR "Killed process %d (%s) "
-		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
-		       task_pid_nr(p), p->comm,
-		       K(p->mm->total_vm),
-		       K(get_mm_counter(p->mm, MM_ANONPAGES)),
-		       K(get_mm_counter(p->mm, MM_FILEPAGES)));
+	printk(KERN_ERR "Killed process %d (%s) "
+	       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+	       task_pid_nr(p), p->comm,
+	       K(p->mm->total_vm),
+	       K(get_mm_counter(p->mm, MM_ANONPAGES)),
+	       K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
 
 	/*
@@ -437,7 +435,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (c->mm == p->mm)
 				continue;
-			if (oom_unkillable(c, mem, nodemask))
+			if (oom_unkillable(c, mem))
 				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
@@ -449,7 +447,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		}
 	} while_each_thread(p, t);
 
-	return __oom_kill_process(victim, mem, 1);
+	return __oom_kill_process(victim, mem);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-- 
1.6.5.2



