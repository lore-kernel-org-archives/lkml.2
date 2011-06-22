Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1FVKrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:47:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39276 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1FVKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:47:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01C82A.7070702@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 19:47:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, oleg@redhat.com
Subject: [PATCH 2/6] oom: improve dump_tasks() show items
References: <4E01C7D5.3060603@jp.fujitsu.com>
In-Reply-To: <4E01C7D5.3060603@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, oom internal logic was dramatically changed. Thus
dump_tasks() doesn't show enough information for bug report
analysis. it has some meaningless items and don't have some
oom socre related items.

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
[   pid]   ppid   uid euid total_vm      rss     swap score_adj name
[   417]      1     0    0     3298       12      184     -1000 udevd
[   830]      1     0    0     1776       11       16         0 system-setup-ke
[   973]      1     0    0    61179       35      116         0 rsyslogd
[  1733]   1732     0    0  1052337   958582        0         0 memtoy

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f552e39..9412657 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -373,7 +373,7 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 	struct task_struct *p;
 	struct task_struct *task;

-	pr_info("[ pid ]   uid  euid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
+	pr_info("[   pid]   ppid   uid  euid total_vm      rss     swap score_adj name\n");
 	for_each_process(p) {
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
@@ -388,12 +388,14 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 			continue;
 		}

-		pr_info("[%5d] %5d %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
-			task->pid, task_uid(task), task_euid(task),
-			task->tgid,
-			task->mm->total_vm, get_mm_rss(task->mm),
-			task_cpu(task), task->signal->oom_adj,
-			task->signal->oom_score_adj, task->comm);
+		pr_info("[%6d] %6d %5d %5d %8lu %8lu %8lu %9d %s\n",
+			task_tgid_nr(task), task_tgid_nr(task->real_parent),
+			task_uid(task),	task_euid(task),
+			task->mm->total_vm,
+			get_mm_rss(task->mm) + task->mm->nr_ptes,
+			get_mm_counter(task->mm, MM_SWAPENTS),
+			task->signal->oom_score_adj,
+			task->comm);
 		task_unlock(task);
 	}
 }
-- 
1.7.3.1



