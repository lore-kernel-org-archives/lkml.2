Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0F3Jbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:31:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59951 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0F3Jbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:31:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 07/11] oom: move OOM_DISABLE check from oom_kill_task to out_of_memory()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630183059.AA5C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:31:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, if oom_kill_allocating_task is enabled and current have
OOM_DISABLED, following printk in oom_kill_process is called twice.

    pr_err("%s: Kill process %d (%s) score %lu or sacrifice child\n",
            message, task_pid_nr(p), p->comm, points);

So, OOM_DISABLE check should be more early.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f5d903f..75f6dbc 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -424,7 +424,7 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 static int oom_kill_task(struct task_struct *p)
 {
 	p = find_lock_task_mm(p);
-	if (!p || p->signal->oom_adj == OOM_DISABLE) {
+	if (!p) {
 		task_unlock(p);
 		return 1;
 	}
@@ -686,7 +686,8 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
-	    !oom_unkillable_task(current, NULL, nodemask)) {
+	    !oom_unkillable_task(current, NULL, nodemask) &&
+	    (current->signal->oom_adj != OOM_DISABLE)) {
 		/*
 		 * oom_kill_process() needs tasklist_lock held.  If it returns
 		 * non-zero, current could not be killed so we must fallback to
-- 
1.6.5.2



