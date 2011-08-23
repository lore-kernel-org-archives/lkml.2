Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1HWHbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:31:08 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43558 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1HWHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:31:07 -0400
Subject: [PATCH] oom: skip frozen tasks
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Date: Tue, 23 Aug 2011 11:31:01 +0300
Message-ID: <20110823073101.6426.77745.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All frozen tasks are unkillable, and if one of them has TIF_MEMDIE
we must kill something else to avoid deadlock. After this patch
select_bad_process() will skip frozen task before checking TIF_MEMDIE.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/oom_kill.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 626303b..931ab20 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -138,6 +138,8 @@ static bool oom_unkillable_task(struct task_struct *p,
 		return true;
 	if (p->flags & PF_KTHREAD)
 		return true;
+	if (p->flags & PF_FROZEN)
+		return true;
 
 	/* When mem_cgroup_out_of_memory() and p is not member of the group */
 	if (mem && !task_in_mem_cgroup(p, mem))

