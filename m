Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848Ab1AVFEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:04:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1AVFEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:04:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=oBSP8E0T0tBfUx9YOhZEeQJj9u20iUz9bwZSlaKTJDd6mGD5njnBi0SSCkS6BnVpo
	ls4GCetQZ8YEqP0Qi8JQw==
Message-Id: <20110122044851.825284940@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 20:45:00 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dan Carpenter <error27@gmail.com>
Subject: [patch 2/5] sched: (cleanup) remove redundant cfs_rq checks
References: <20110122044458.058531078@google.com>
Content-Disposition: inline; filename=sched-remove_cfs_rq_checks.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since updates are against an entity's queuing cfs_rq it's not possible to
enter update_cfs_{shares,load} with a NULL cfs_rq.  (Indeed, update_cfs_load
would crash prior to the check if we did anyway since we load is examined
during the initializers).  Also, in the update_cfs_load case there's no point
in maintaining averages for rq->cfs_rq since we don't perform shares
distribution at that level -- NULL check is replaced accordingly.

Thanks to Dan Carpenter for pointing out the deference before NULL check.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -721,7 +721,7 @@ static void update_cfs_load(struct cfs_r
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (!cfs_rq)
+	if (cfs_rq->tg == &root_task_group)
 		return;
 
 	now = rq_of(cfs_rq)->clock;
@@ -784,9 +784,6 @@ static void update_cfs_shares(struct cfs
 	struct sched_entity *se;
 	long load_weight, load, shares;
 
-	if (!cfs_rq)
-		return;
-
 	tg = cfs_rq->tg;
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
 	if (!se)


