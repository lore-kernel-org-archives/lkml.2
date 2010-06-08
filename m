Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0FHLy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:54:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47225 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0FHLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:54:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 01/10] oom: don't try to kill oom_unkillable child
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608205343.767D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:54:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, badness() doesn't care neigher CPUSET nor mempolicy. Then
if the victim child process is oom_unkillable()==1, __out_of_memory()
can makes kernel hang eventually.

This patch fixes it.


[remark: this is needed to fold "oom: sacrifice child with highest
badness score for parent"]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index d49d542..0d7397b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -387,9 +387,6 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
 			      int verbose)
 {
-	if (oom_unkillable(p, mem))
-		return 1;
-
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 1;
@@ -440,6 +437,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (c->mm == p->mm)
 				continue;
+			if (oom_unkillable(c, mem, nodemask))
+				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
 			cpoints = badness(c, uptime.tv_sec);
-- 
1.6.5.2



