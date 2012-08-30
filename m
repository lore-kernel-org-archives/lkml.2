Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2H3VoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:44:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33393 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2H3VoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:44:14 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/15] rcu: Remove redundant memory barrier from __call_rcu()
Date: Thu, 30 Aug 2012 11:56:25 -0700
Message-Id: <1346352988-32444-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-1780-0000-0000-000008E0259A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169896; UDB=6.00038517; UTC=2012-08-30
 21:44:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The first memory barrier in __call_rcu() is supposed to order any
updates done beforehand by the caller against the actual queuing
of the callback.  However, the second memory barrier (which is intended
to order incrementing the queue lengths before queuing the callback)
is also between the caller's updates and the queuing of the callback.
The second memory barrier can therefore serve both purposes.

This commit therefore removes the first memory barrier.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e58097b..5b6709b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1923,8 +1923,6 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	head->func = func;
 	head->next = NULL;
 
-	smp_mb(); /* Ensure RCU update seen before callback registry. */
-
 	/*
 	 * Opportunistically note grace-period endings and beginnings.
 	 * Note that we might see a beginning right after we see an
-- 
1.7.8

