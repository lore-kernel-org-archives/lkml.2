Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0LTIht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:37:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:57801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab0LTIhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:37:48 -0500
Date: Mon, 20 Dec 2010 08:37:09 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        pjt@google.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101216031038.159704378@google.com>
References: <20101216031038.159704378@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix interactivity bug by charging unaccounted run-time on entity re-weight
Message-ID: <tip-19e5eebb8eaa5ca3ff8aa18cb57ccb7a9f67277d@git.kernel.org>
Git-Commit-ID: 19e5eebb8eaa5ca3ff8aa18cb57ccb7a9f67277d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 20 Dec 2010 08:37:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19e5eebb8eaa5ca3ff8aa18cb57ccb7a9f67277d
Gitweb:     http://git.kernel.org/tip/19e5eebb8eaa5ca3ff8aa18cb57ccb7a9f67277d
Author:     Paul Turner <pjt@google.com>
AuthorDate: Wed, 15 Dec 2010 19:10:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Dec 2010 16:36:30 +0100

sched: Fix interactivity bug by charging unaccounted run-time on entity re-weight

Mike Galbraith reported poor interactivity[*] when the new shares distribution
code was combined with autogroups.

The root cause turns out to be a mis-ordering of accounting accrued execution
time and shares updates.  Since update_curr() is issued hierarchically,
updating the parent entity weights to reflect child enqueue/dequeue results in
the parent's unaccounted execution time then being accrued (vs vruntime) at the
new weight as opposed to the weight present at accumulation.

While this doesn't have much effect on processes with timeslices that cross a
tick, it is particularly problematic for an interactive process (e.g. Xorg)
which incurs many (tiny) timeslices.  In this scenario almost all updates are
at dequeue which can result in significant fairness perturbation (especially if
it is the only thread, resulting in potential {tg->shares, MIN_SHARES}
transitions).

Correct this by ensuring unaccounted time is accumulated prior to manipulating
an entity's weight.

[*] http://xkcd.com/619/ is perversely Nostradamian here.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20101216031038.159704378@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 16ee398..c62ebae 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -765,8 +765,12 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
-	if (se->on_rq)
+	if (se->on_rq) {
+		/* commit outstanding execution time */
+		if (cfs_rq->curr == se)
+			update_curr(cfs_rq);
 		account_entity_dequeue(cfs_rq, se);
+	}
 
 	update_load_set(&se->load, weight);
 
