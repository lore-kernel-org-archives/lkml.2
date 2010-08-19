Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0HSP0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0HSP0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:26:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] oom: __task_cred() need rcu_read_lock()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, rientjes@google.com,
        kamezawa.hiroyu@jp.fujitsu.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Date: Thu, 19 Aug 2010 16:26:18 +0100
Message-ID: <20100819152618.21246.68223.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

dump_tasks() needs to hold the RCU read lock around its access of the target
task's UID.  To this end it should use task_uid() as it only needs that one
thing from the creds.

The fact that dump_tasks() holds tasklist_lock is insufficient to prevent the
target process replacing its credentials on another CPU.

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
Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5014e50..7b03102 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -372,7 +372,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
 		}
 
 		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
-			task->pid, __task_cred(task)->uid, task->tgid,
+			task->pid, task_uid(task), task->tgid,
 			task->mm->total_vm, get_mm_rss(task->mm),
 			task_cpu(task), task->signal->oom_adj,
 			task->signal->oom_score_adj, task->comm);

