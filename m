Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab0FCFwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:52:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37942 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0FCFwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:52:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 04/12] oom: __oom_kill_task() must use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Message-Id: <20100603145125.7253.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 14:52:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__oom_kill_task also use find_lock_task_mm(). because if sysctl_oom_kill_allocating_task
is true, __out_of_memory() don't call select_bad_process().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/oom_kill.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0542232..79845f4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -394,12 +394,11 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 		return;
 	}
 
-	task_lock(p);
-	if (!p->mm) {
+	p = find_lock_task_mm(p);
+	if (!p) {
 		WARN_ON(1);
 		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
 			task_pid_nr(p), p->comm);
-		task_unlock(p);
 		return;
 	}
 
-- 
1.6.5.2



