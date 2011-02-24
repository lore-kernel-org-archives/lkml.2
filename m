Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1BXGzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:55:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58217 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab1BXGzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:55:31 -0500
Message-ID: <4D660141.7020201@cn.fujitsu.com>
Date: Thu, 24 Feb 2011 14:57:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH v2 2/4] cpuset: Remove unneeded NODEMASK_ALLOC() in cpuset_attch()
References: <4D660130.8020009@cn.fujitsu.com>
In-Reply-To: <4D660130.8020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-24 14:54:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-24 14:54:27,
	Serialize complete at 2011-02-24 14:54:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'from' is not modified after it's copied from
oldcs->mems_allowed, so we can just pass oldcs->mems_allowed
to cpuset_migrate_mm().

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e79650b..8fef8c6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1438,10 +1438,9 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
 	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
 
-	if (from == NULL || to == NULL)
+	if (to == NULL)
 		goto alloc_fail;
 
 	if (cs == &top_cpuset) {
@@ -1463,18 +1462,16 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	}
 
 	/* change mm; only needs to be done once even if threadgroup */
-	*from = oldcs->mems_allowed;
 	*to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
 		mpol_rebind_mm(mm, to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, from, to);
+			cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
 		mmput(mm);
 	}
 
 alloc_fail:
-	NODEMASK_FREE(from);
 	NODEMASK_FREE(to);
 }
 
-- 
1.7.3.1
