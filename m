Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0LPDMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:12:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57677 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0LPDMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:12:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=dSY3gFJ/OZMNlrD4bVgYtFU0swnQGyX175ou71KJE/gq27UmjaCmZupzMCrBr3iPA
	10rflNm/bk9bZ6eD0mNnA==
Message-Id: <20101216031038.159704378@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 19:10:18 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 2/2] sched: charge unaccounted run-time on entity re-weight
References: <20101216031016.186364650@google.com>
Content-Disposition: inline; filename=update_on_reweight.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 kernel/sched_fair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -767,8 +767,12 @@ static void update_cfs_load(struct cfs_r
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
 


