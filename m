Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab0KXAb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:31:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab0KXAb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EwePUR6HzS8wgsTDob1XGhwy92mlk7KWN2nMYW4fkgSCr7kHi6ID0g+FVf74b8mUy9
         tvifAHX9avwtpMU2UM6BRNggnp+4d7dTd68NrsBCqCopOKaLePNXK2QY1PioLQcL66Yo
         aMCcTPIBOGlOkyEfsd3Q600k5EaG9jd7viUQA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] rcu: Stop checking quiescent states after grace period completion from remote
Date: Wed, 24 Nov 2010 01:31:13 +0100
Message-Id: <1290558673-23580-3-git-send-crap-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a CPU starts to chase its quiescent states by setting
rdp->qs_pending to 1, it can still enter into an extended
quiescent state and then another CPU will take care of this
and complete the grace period if necessary.

rcu_report_qs_rdp() currently doesn't handle well this case
and considers it must try later to notify its quiescent state.

However if the last grace period has been completed there is
nothing left to do for the current CPU.

It means that until a next grace period starts, the CPU that
runs into that case will keep chasing its own quiescent states
by raising a softirq on every tick for no good reason.

This can take a while before a new grace period starts and
this time slice is covered by spurious softirqs and other
kinds of rcu checks.

Fix this by resetting rdp->qs_pending if the last grace
period has been completed by a remote CPU while we were
in an extended quiescent state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5f038a1..f287eaa 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -937,6 +937,15 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
 		 * race occurred.
 		 */
 		rdp->passed_quiesc = 0;	/* try again later! */
+
+		/*
+		 * Another CPU may have taken care of us if we were in an
+		 * extended quiescent state, in which case we don't need
+		 * to continue to track anything.
+		 */
+		if (rnp->gpnum == rnp->completed)
+			rdp->qs_pending = 0;
+
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-- 
1.7.1

