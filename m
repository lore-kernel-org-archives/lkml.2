Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab0FCFvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:51:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37888 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0FCFv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:51:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 03/12] oom: the points calculation of child processes must use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Message-Id: <20100603145036.7250.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 14:51:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

child point calclation use find_lock_task_mm() too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/oom_kill.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ce9c744..0542232 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -87,6 +87,7 @@ static struct task_struct *find_lock_task_mm(struct task_struct *p)
 unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
+	struct task_struct *c;
 	struct task_struct *child;
 	int oom_adj = p->signal->oom_adj;
 	struct task_cputime task_time;
@@ -124,11 +125,13 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * child is eating the vast majority of memory, adding only half
 	 * to the parents will make the child our kill candidate of choice.
 	 */
-	list_for_each_entry(child, &p->children, sibling) {
-		task_lock(child);
-		if (child->mm != p->mm && child->mm)
-			points += child->mm->total_vm/2 + 1;
-		task_unlock(child);
+	list_for_each_entry(c, &p->children, sibling) {
+		child = find_lock_task_mm(c);
+		if (child) {
+			if (child->mm != p->mm)
+				points += child->mm->total_vm/2 + 1;
+			task_unlock(child);
+		}
 	}
 
 	/*
-- 
1.6.5.2



