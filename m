Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1EGGdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:33:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1EGGcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=iEUtp/t87+QCGzT0UH8/yPpIcCIKcJP5cmPL2RBn0FU9AuCyy+EvlMo/wCCwa8wBZ
	Z73aaQom8rJa1cvCSFmWQ==
Message-Id: <20110503092904.541414484@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:47 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 01/15] sched: (fixlet) dont update shares twice on on_rq parent
References: <20110503092846.022272244@google.com>
Content-Disposition: inline; filename=sched-bwc-fix_dequeue_task_buglet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
with additional weight.  However, we perform a double shares update on this
entity since we continue the shares update traversal from that point, despite
dequeue_entity() having already updated its queuing cfs_rq.

Avoid this by starting from the parent when we resume.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched_fair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1355,8 +1355,10 @@ static void dequeue_task_fair(struct rq 
 		dequeue_entity(cfs_rq, se, flags);
 
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->load.weight) {
+			se = parent_entity(se);
 			break;
+		}
 		flags |= DEQUEUE_SLEEP;
 	}
 


