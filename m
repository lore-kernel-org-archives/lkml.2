Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0LJVL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:11:59 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63594 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab0LJVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:11:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BqIrubCxCqH9mPBOvawDTNaBXjH/QNR89Sq3hxCX5NX4PlGF6sSVxDy687aF48YyO/
         YVRSQiZJN9i4GiQ+uCl0oLR6ASbuVAXTCI/OZCIiIylwPPaSXcIbpb5g5eKrEjcuJVZl
         3L08Q3DUOF5FsMntRLl1KIQsPpVcxBRLVk7Ss=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] rcu: Stop chasing QS if another CPU did it for us
Date: Fri, 10 Dec 2010 22:11:10 +0100
Message-Id: <1292015471-19227-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU is idle and others CPUs handled its extended
quiescent state to complete grace periods on its behalf,
it will catch up with completed grace periods numbers
when it wakes up.

But at this point there might be no more grace period to
complete, but still the woken CPU always keeps its stale
qs_pending value and will then continue to chase quiescent
states even if its not needed anymore.

This results in clusters of spurious softirqs until a new
real grace period is started. Because if we continue to
chase quiescent states but we have completed every grace
periods, rcu_report_qs_rdp() is puzzled and makes that
state run into infinite loops.

As suggested by Lai Jiangshan, just reset qs_pending if
someone completed every grace periods on our behalf.

Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ccdc04c..8c4ed60 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -681,6 +681,14 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
+
+		/*
+		 * If another CPU handled our extended quiescent states and
+		 * we have no more grace period to complete yet, then stop
+		 * chasing quiescent states.
+		 */
+		if (rdp->completed == rnp->gpnum)
+			rdp->qs_pending = 0;
 	}
 }
 
-- 
1.7.3.2

