Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1GGFdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:33:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1GGFdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=CBqOF+LKIOJC40SogBIRILz3AU0U7VlJ4gLhs5B9k6I62nEBFvw71Gq1pCLgV9mkD
	Cq6fnq0gdpHqGOQpPhnXQ==
Message-Id: <20110707053059.797714697@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:37 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 01/17] sched: (fixlet) dont update shares twice on on_rq parent
References: <20110707053036.173186930@google.com>
Content-Disposition: inline; filename=sched-bwc-fix_dequeue_task_buglet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
with additional weight.  However, we perform a double shares update on this
entity as we continue the shares update traversal from this point, despite
dequeue_entity() having already updated its queuing cfs_rq.
Avoid this by starting from the parent when we resume.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched_fair.c |    3 +++
 1 file changed, 3 insertions(+)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1370,6 +1370,9 @@ static void dequeue_task_fair(struct rq 
 			 */
 			if (task_sleep && parent_entity(se))
 				set_next_buddy(parent_entity(se));
+
+			/* avoid re-evaluating load for this entity */
+			se = parent_entity(se);
 			break;
 		}
 		flags |= DEQUEUE_SLEEP;


