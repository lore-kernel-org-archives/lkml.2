Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1CWDKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab1CWDKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=dioOd0egJ9diXiV+vHQw7W73mB0Wbj0SJP7Kyj/mrPS4J5YWOJp5LTjAqO4etpudo
	w2IfiJ8atrz4pr7yKECJQ==
Message-Id: <20110323030449.628616053@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:36 -0700
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
Subject: [patch 10/15] sched: (fixlet) dont update shares twice on on_rq parent
References: <20110323030326.789836913@google.com>
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
@@ -1683,8 +1683,10 @@ static void dequeue_task_fair(struct rq 
 			break;
 		}
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->load.weight) {
+			se = parent_entity(se);
 			break;
+		}
 		check_cfs_rq_quota(cfs_rq);
 		flags |= DEQUEUE_SLEEP;
 	}


