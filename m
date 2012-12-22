Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2LVRMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:12:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14205 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2LVRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:12:18 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7h1ZG5PzY5sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1bVccPqbPM8A:10 a=VwQbUJbxAAAA:8 a=7viBfxuKHOKy5Nc70s0A:9 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121222171217.147373707@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 22 Dec 2012 12:12:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable@vger.kernel.org>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 1/4] sched: Adjust sched_reset_on_fork when nothing else changes
References: <20121222171201.588460638@goodmis.org>
Content-Disposition: inline; filename=0001-sched-Adjust-sched_reset_on_fork-when-nothing-else-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If the policy and priority remain unchanged a possible modification of
sched_reset_on_fork gets lost in the early exit path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: stable-rt@vger.kernel.org
---
 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2cf4c4b..945009e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5339,11 +5339,13 @@ recheck:
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed
+	 * further, but store a possible modification of
+	 * reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
 			param->sched_priority == p->rt_priority))) {
-
+		p->sched_reset_on_fork = reset_on_fork;
 		__task_rq_unlock(rq);
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		return 0;
-- 
1.7.10.4


