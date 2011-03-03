Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1CCGX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:23:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58584 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab1CCGX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:23:57 -0500
Message-ID: <4D6F347E.2010806@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 14:26:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] perf cgroup: Clean up perf_cgroup_create()
References: <4D6F3461.6060406@cn.fujitsu.com>
In-Reply-To: <4D6F3461.6060406@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:22:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:22:47,
	Serialize complete at 2011-03-03 14:22:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use kzalloc() to replace kmalloc() + memset().
- Remove redundant initialization, since alloc_percpu() returns
  zero-filled percpu memory.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/perf_event.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index dca92b2..d6b3d16 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -7341,26 +7341,17 @@ static struct cgroup_subsys_state *perf_cgroup_create(
 	struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct perf_cgroup *jc;
-	struct perf_cgroup_info *t;
-	int c;
 
-	jc = kmalloc(sizeof(*jc), GFP_KERNEL);
+	jc = kzalloc(sizeof(*jc), GFP_KERNEL);
 	if (!jc)
 		return ERR_PTR(-ENOMEM);
 
-	memset(jc, 0, sizeof(*jc));
-
 	jc->info = alloc_percpu(struct perf_cgroup_info);
 	if (!jc->info) {
 		kfree(jc);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	for_each_possible_cpu(c) {
-		t = per_cpu_ptr(jc->info, c);
-		t->time = 0;
-		t->timestamp = 0;
-	}
 	return &jc->css;
 }
 
-- 
1.6.3
