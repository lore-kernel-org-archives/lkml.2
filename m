Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0K3A7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:59:02 -0500
Received: from smtp-out.google.com ([74.125.121.35]:41180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab0K3A7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:59:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=Om1KNiBACg/YHAGZ2WOE+rFDfS2WrsifefsEJU+N7CxR7vfp3s5+D+tkvyLygTaLE
	E43lnQ5Vy0VO6PNA1D5QQ==
Message-Id: <20101130005740.080828123@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 29 Nov 2010 16:55:40 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch] sched: fix unregister_fair_sched_group
References: <20101130005539.617388324@google.com>
Content-Disposition: inline; filename=sched-fix_unregister.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the flipping and flopping between calling unregister_fair_sched_group on a
per-cpu versus per-group basis we ended up in a bad state.

Remove from the list for the passed cpu as opposed to some arbitrary index.

(This fixes explosions w/ autogroup as well as a group creation/destruction 
stress test)

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -8097,7 +8097,6 @@ static inline void unregister_fair_sched
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
-	int i;
 
 	/*
 	* Only empty task groups can be destroyed; so we can speculatively
@@ -8107,7 +8106,7 @@ static inline void unregister_fair_sched
 		return;
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	list_del_leaf_cfs_rq(tg->cfs_rq[i]);
+	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 #else /* !CONFG_FAIR_GROUP_SCHED */


