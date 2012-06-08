Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab2FHUVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:21:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56078 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab2FHUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:21:29 -0400
Date: Fri, 8 Jun 2012 13:21:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [patch for-3.5-rc1] mm, oom: fix badness score underflow
In-Reply-To: <20120608150437.GA31091@redhat.com>
Message-ID: <alpine.DEB.2.00.1206081317120.19054@chino.kir.corp.google.com>
References: <20120607165942.GA31966@redhat.com> <20120608140328.GA26650@redhat.com> <20120608142625.GC1711@redhat.com> <20120608150437.GA31091@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the privileges given to root threads (3% of allowable memory) or a 
negative value of /proc/pid/oom_score_adj happen to exceed the amount of 
rss of a thread, its badness score overflows as a result of a7f638f999ff 
("mm, oom: normalize oom scores to oom_score_adj scale only for 
userspace").

Fix this by making the type signed and return 1, meaning the thread is 
still eligible for kill, if the value is negative.

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -183,7 +183,7 @@ static bool oom_unkillable_task(struct task_struct *p,
 unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 			  const nodemask_t *nodemask, unsigned long totalpages)
 {
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -223,7 +223,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	 * Never return 0 for an eligible task regardless of the root bonus and
 	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
 	 */
-	return points ? points : 1;
+	return points > 0 ? points : 1;
 }
 
 /*
