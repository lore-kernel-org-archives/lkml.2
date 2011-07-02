Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1GBAzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 20:55:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1GBAzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 20:55:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=tzIbsHwC67uCA7xxVRUxrE768ml53u+C2SVCvvyWwdfzBu9/OZiKx+bmILOBep4kM
	jJ0fVlXxcgfPNwP/ozKyw==
Message-Id: <20110702005228.481583467@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 17:52:23 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch 1/1] sched: update_curr versus correct cfs_rq in check_preempt_wakeup
References: <20110702005222.262883892@google.com>
Content-Disposition: inline; filename=fix_check_preempt_wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We update_curr() versus the current entity as the preemption decision is based
on the relative vruntime.  However, update_curr() is not hierarchical and in
the group scheduling case find_matching_se() will have us making the
comparison on a cfs_rq different to the one just updated.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip2/kernel/sched_fair.c
===================================================================
--- tip2.orig/kernel/sched_fair.c
+++ tip2/kernel/sched_fair.c
@@ -1919,8 +1919,8 @@ static void check_preempt_wakeup(struct 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
+	update_curr(cfs_rq_of(se));
 	BUG_ON(!pse);
 	if (wakeup_preempt_entity(se, pse) == 1) {
 		/*


