Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1ARTFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:05:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:52927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab1ARTEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:04:53 -0500
Date: Tue, 18 Jan 2011 19:04:16 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110115015817.069769529@google.com>
References: <20110115015817.069769529@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Update effective_load() to use global share weights
Message-ID: <tip-977dda7c9b540f48b228174346d8b31542c1e99f@git.kernel.org>
Git-Commit-ID: 977dda7c9b540f48b228174346d8b31542c1e99f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  977dda7c9b540f48b228174346d8b31542c1e99f
Gitweb:     http://git.kernel.org/tip/977dda7c9b540f48b228174346d8b31542c1e99f
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 14 Jan 2011 17:57:50 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:09:38 +0100

sched: Update effective_load() to use global share weights

Previously effective_load would approximate the global load weight present on
a group taking advantage of:

entity_weight = tg->shares ( lw / global_lw ), where entity_weight was provided
by tg_shares_up.

This worked (approximately) for an 'empty' (at tg level) cpu since we would
place boost load representative of what a newly woken task would receive.

However, now that load is instantaneously updated this assumption is no longer
true and the load calculation is rather incorrect in this case.

Fix this (and improve the general case) by re-writing effective_load to take
advantage of the new shares distribution code.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110115015817.069769529@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..414145c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1362,27 +1362,27 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		return wl;
 
 	for_each_sched_entity(se) {
-		long S, rw, s, a, b;
+		long lw, w;
 
-		S = se->my_q->tg->shares;
-		s = se->load.weight;
-		rw = se->my_q->load.weight;
+		tg = se->my_q->tg;
+		w = se->my_q->load.weight;
 
-		a = S*(rw + wl);
-		b = S*rw + s*wg;
+		/* use this cpu's instantaneous contribution */
+		lw = atomic_read(&tg->load_weight);
+		lw -= se->my_q->load_contribution;
+		lw += w + wg;
 
-		wl = s*(a-b);
+		wl += w;
 
-		if (likely(b))
-			wl /= b;
+		if (lw > 0 && wl < lw)
+			wl = (wl * tg->shares) / lw;
+		else
+			wl = tg->shares;
 
-		/*
-		 * Assume the group is already running and will
-		 * thus already be accounted for in the weight.
-		 *
-		 * That is, moving shares between CPUs, does not
-		 * alter the group weight.
-		 */
+		/* zero point is MIN_SHARES */
+		if (wl < MIN_SHARES)
+			wl = MIN_SHARES;
+		wl -= se->load.weight;
 		wg = 0;
 	}
 
