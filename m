Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab1ETIBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:01:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49010 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212Ab1ETIBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:01:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD61FE2.1020303@jp.fujitsu.com>
Date: Fri, 20 May 2011 17:01:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, oleg@redhat.com
Subject: [PATCH 1/5] oom: improve dump_tasks() show items
References: <4DD61F80.1020505@jp.fujitsu.com>
In-Reply-To: <4DD61F80.1020505@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, oom internal logic was dramatically changed. Thus
dump_tasks() doesn't show enough information for bug report
analysis. it has some meaningless items and don't have some
oom score related items.

This patch adapt displaying fields to new oom logic.

details
--------
removed: pid (we always kill process. don't need thread id),
         signal->oom_adj (we no longer uses it internally)
	 cpu (we no longer uses it)
added:  ppid (we often kill sacrifice child process)
        swap (it's accounted)
modify: RSS (account mm->nr_ptes too)

<old>
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[ 3886]     0  3886     2893      441   1       0             0 bash
[ 3905]     0  3905    29361    25833   0       0             0 memtoy

<new>
[   pid]   ppid   uid total_vm      rss     swap score_adj name
[   417]      1     0     3298       12      184     -1000 udevd
[   830]      1     0     1776       11       16         0 system-setup-ke
[   973]      1     0    61179       35      116         0 rsyslogd
[  1733]   1732     0  1052337   958582        0         0 memtoy

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f52e85c..43d32ae 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -355,7 +355,7 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 	struct task_struct *p;
 	struct task_struct *task;

-	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
+	pr_info("[   pid]   ppid   uid total_vm      rss     swap score_adj name\n");
 	for_each_process(p) {
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
@@ -370,11 +370,14 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 			continue;
 		}

-		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
-			task->pid, task_uid(task), task->tgid,
-			task->mm->total_vm, get_mm_rss(task->mm),
-			task_cpu(task), task->signal->oom_adj,
-			task->signal->oom_score_adj, task->comm);
+		pr_info("[%6d] %6d %5d %8lu %8lu %8lu %9d %s\n",
+			task_tgid_nr(task), task_tgid_nr(task->real_parent),
+			task_uid(task),
+			task->mm->total_vm,
+			get_mm_rss(task->mm) + p->mm->nr_ptes,
+			get_mm_counter(p->mm, MM_SWAPENTS),
+			task->signal->oom_score_adj,
+			task->comm);
 		task_unlock(task);
 	}
 }
-- 
1.7.3.1



