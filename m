Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2FKJL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:11:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40784 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2FKJLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:11:52 -0400
Date: Mon, 11 Jun 2012 02:11:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 3.5-rc2] mm, oom: fix and cleanup oom score calculations
In-Reply-To: <20120611004602.GA29713@redhat.com>
Message-ID: <alpine.DEB.2.00.1206110209080.6843@chino.kir.corp.google.com>
References: <20120604152710.GA1710@redhat.com> <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com> <20120605174454.GA23867@redhat.com> <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com> <20120608210330.GA21010@redhat.com>
 <alpine.DEB.2.00.1206091920140.7832@chino.kir.corp.google.com> <4FD412CB.9060809@gmail.com> <20120610201055.GA27662@redhat.com> <alpine.DEB.2.00.1206101652180.18114@chino.kir.corp.google.com> <20120611004602.GA29713@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The divide in p->signal->oom_score_adj * totalpages / 1000 within 
oom_badness() was causing an overflow of the signed long data type.

This adds both the root bias and p->signal->oom_score_adj before doing the 
normalization which fixes the issue and also cleans up the calculation.

Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -184,6 +184,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 			  const nodemask_t *nodemask, unsigned long totalpages)
 {
 	long points;
+	long adj;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -192,7 +193,8 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	if (!p)
 		return 0;
 
-	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+	adj = p->signal->oom_score_adj;
+	if (adj == OOM_SCORE_ADJ_MIN) {
 		task_unlock(p);
 		return 0;
 	}
@@ -210,14 +212,11 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30 * totalpages / 1000;
+		adj -= 30;
 
-	/*
-	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
-	 * either completely disable oom killing or always prefer a certain
-	 * task.
-	 */
-	points += p->signal->oom_score_adj * totalpages / 1000;
+	/* Normalize to oom_score_adj units */
+	adj *= totalpages / 1000;
+	points += adj;
 
 	/*
 	 * Never return 0 for an eligible task regardless of the root bonus and
