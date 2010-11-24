Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0KXAb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:31:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab0KXAbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NfM7KphfAyg6mQOs5GAytVqg20jIb7HHdtjX55S51Ktu4XZey/5xumIhaLAgiZSKEM
         D5CPLVCaNEyTTq+wXtB5uRVsUVKiBUTeCPFcdKf2D0ouMjSm5O15FONdHKZISmFIQS93
         gwrIGrqygp86ZGLUWUULJRM1gjoNib5xZvGKk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states after extended grace periods
Date: Wed, 24 Nov 2010 01:31:12 +0100
Message-Id: <1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu is in an extended quiescent state, which includes idle
nohz or CPU offline, others CPUs will take care of the grace periods
on its behalf.

When this CPU exits its extended quiescent state, it will catch up
with the last started grace period and start chasing its own
quiescent states to end the current grace period.

However in this case we always start to track quiescent states if the
grace period number has changed since we started our extended
quiescent state. And we do this because we always assume that the last
grace period is not finished and needs us to complete it, which is
sometimes wrong.

This patch verifies if the last grace period has been completed and
if so, start hunting local quiescent states like we always did.
Otherwise don't do anything, this economizes us some work and
an unnecessary softirq.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ccdc04c..5f038a1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -620,8 +620,17 @@ static void __init check_cpu_stall_init(void)
 static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	if (rdp->gpnum != rnp->gpnum) {
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
+		/*
+		 * Another CPU might have taken take of this new grace period
+		 * while we were idle and handled us as in an extended quiescent
+		 * state. In that case, we don't need to chase a local quiescent
+		 * state, otherwise:
+		 */
+		if (rdp->completed != rnp->gpnum) {
+			rdp->qs_pending = 1;
+			rdp->passed_quiesc = 0;
+		}
+
 		rdp->gpnum = rnp->gpnum;
 	}
 }
-- 
1.7.1

