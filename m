Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1FVKqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:46:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44921 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1FVKqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:46:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01C809.9020508@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 19:46:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, oleg@redhat.com
Subject: [PATCH 1/6] oom: use euid instead of CAP_SYS_ADMIN for protection
 root process
References: <4E01C7D5.3060603@jp.fujitsu.com>
In-Reply-To: <4E01C7D5.3060603@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, many userland daemon prefer to use libcap-ng and drop
all privilege just after startup. Because of (1) Almost privilege
are necessary only when special file open, and aren't necessary
read and write. (2) In general, privilege dropping brings better
protection from exploit when bugs are found in the daemon.

But, it makes suboptimal oom-killer behavior. CAI Qian reported
oom killer killed some important daemon at first on his fedora
like distro. Because they've lost CAP_SYS_ADMIN.

Of course, we recommend to drop privileges as far as possible
instead of keeping them. Thus, oom killer don't have to check
any capability. It implicitly suggest wrong programming style.

This patch change root process check way from CAP_SYS_ADMIN to
just euid==0.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e4b0991..f552e39 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -203,7 +203,7 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 * Root processes get 3% bonus, just like the __vm_enough_memory()
 	 * implementation used by LSMs.
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
+	if (task_euid(p) == 0)
 		points -= 30;

 	/*
@@ -373,7 +373,7 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 	struct task_struct *p;
 	struct task_struct *task;

-	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
+	pr_info("[ pid ]   uid  euid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
 	for_each_process(p) {
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
@@ -388,8 +388,9 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 			continue;
 		}

-		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
-			task->pid, task_uid(task), task->tgid,
+		pr_info("[%5d] %5d %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
+			task->pid, task_uid(task), task_euid(task),
+			task->tgid,
 			task->mm->total_vm, get_mm_rss(task->mm),
 			task_cpu(task), task->signal->oom_adj,
 			task->signal->oom_score_adj, task->comm);
-- 
1.7.3.1



