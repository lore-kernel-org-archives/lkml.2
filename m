Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0HSNG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:06:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45724 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0HSNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:06:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: oom: __task_cred() need rcu_read_lock()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100819220338.5FD5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 19 Aug 2010 22:06:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_tasks() can call __task_cred() safely because we are holding
tasklist_lock. but rcu lock validator don't have enough knowledge and
it makes following annoying warning.

Then, this patch change to call rcu_read_lock() explicitly.


	===================================================
	[ INFO: suspicious rcu_dereference_check() usage. ]
	---------------------------------------------------
	mm/oom_kill.c:410 invoked rcu_dereference_check() without protection!

	other info that might help us debug this:

	rcu_scheduler_active = 1, debug_locks = 1
	4 locks held by kworker/1:2/651:
	 #0:  (events){+.+.+.}, at: [<ffffffff8106aae7>]
	process_one_work+0x137/0x4a0
	 #1:  (moom_work){+.+...}, at: [<ffffffff8106aae7>]
	process_one_work+0x137/0x4a0
	 #2:  (tasklist_lock){.+.+..}, at: [<ffffffff810fafd4>]
	out_of_memory+0x164/0x3f0
	 #3:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff810fa48e>]
	find_lock_task_mm+0x2e/0x70

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c48c5ef..57c05f7 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -371,11 +371,13 @@ static void dump_tasks(const struct mem_cgroup *mem)
 			continue;
 		}
 
+		rcu_read_lock();
 		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
 			task->pid, __task_cred(task)->uid, task->tgid,
 			task->mm->total_vm, get_mm_rss(task->mm),
 			task_cpu(task), task->signal->oom_adj,
 			task->signal->oom_score_adj, task->comm);
+		rcu_read_unlock();
 		task_unlock(task);
 	}
 }
-- 
1.6.5.2



