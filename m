Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1AOCDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 21:03:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56999 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1AOCDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 21:03:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=pkRktFtbsyQe6ShYSc+NtNj+s9NFQOcHIThf01z+0YrXZFRsyCaf/5j+NtuPkAIPh
	4PzCN89JPXTjq9aNtrfMA==
Message-Id: <20110115015817.069769529@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 17:57:50 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [wake_afine fixes/improvements 1/3] sched: update effective_load() to use global share weights
References: <20110115015749.692623529@google.com>
Content-Disposition: inline; filename=fix_wake_affine.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 kernel/sched_fair.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -1362,27 +1362,27 @@ static long effective_load(struct task_g
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
 


