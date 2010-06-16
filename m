Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab0FPLeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:34:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46882 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0FPLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:34:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 6/9] oom: use same_thread_group instead comparing ->mm
Cc: kosaki.motohiro@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
Message-Id: <20100616203319.72E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Jun 2010 20:34:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, oom are using "child->mm != p->mm" check to distinguish subthread.
But It's incorrect. vfork() child also have the same ->mm.

This patch change to use same_thread_group() instead.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 12204c7..e4b1146 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -161,7 +161,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long uptime)
 		list_for_each_entry(c, &t->children, sibling) {
 			child = find_lock_task_mm(c);
 			if (child) {
-				if (child->mm != p->mm)
+				if (same_thread_group(p, child))
 					points += child->mm->total_vm/2 + 1;
 				task_unlock(child);
 			}
@@ -486,7 +486,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned long child_points;
 
-			if (child->mm == p->mm)
+			if (same_thread_group(p, child))
 				continue;
 			if (oom_unkillable_task(child, mem, nodemask))
 				continue;
-- 
1.6.5.2



