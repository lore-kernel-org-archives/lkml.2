Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab0FPLfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:35:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50408 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642Ab0FPLfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:35:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 8/9] oom: cleanup has_intersects_mems_allowed()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
Message-Id: <20100616203445.72EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Jun 2010 20:35:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now has_intersects_mems_allowed() has own thread iterate logic, but
it should use while_each_thread().

It slightly improve the code readability.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4236d39..7e9942d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -46,10 +46,10 @@ static DEFINE_SPINLOCK(zone_scan_lock);
  * shares the same mempolicy nodes as current if it is bound by such a policy
  * and whether or not it has the same set of allowed cpuset nodes.
  */
-static bool has_intersects_mems_allowed(struct task_struct *tsk,
+static bool has_intersects_mems_allowed(struct task_struct *p,
 					const nodemask_t *mask)
 {
-	struct task_struct *start = tsk;
+	struct task_struct *tsk = p;
 
 	do {
 		if (mask) {
@@ -69,8 +69,8 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
 			if (cpuset_mems_allowed_intersects(current, tsk))
 				return true;
 		}
-		tsk = next_thread(tsk);
-	} while (tsk != start);
+	} while_each_thread(p, tsk);
+
 	return false;
 }
 #else
-- 
1.6.5.2



