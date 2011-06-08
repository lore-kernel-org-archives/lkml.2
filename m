Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1FHTiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:38:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44612 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab1FHTaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH tip/core/rcu 13/28] nfs,rcu: Convert call_rcu(nfs_free_delegation_callback) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:29:52 -0700
Message-Id: <1307561407-13809-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback nfs_free_delegation_callback() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(nfs_free_delegation_callback).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/nfs/delegation.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index bbbc6bf..dd25c2a 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -21,25 +21,13 @@
 #include "delegation.h"
 #include "internal.h"
 
-static void nfs_do_free_delegation(struct nfs_delegation *delegation)
-{
-	kfree(delegation);
-}
-
-static void nfs_free_delegation_callback(struct rcu_head *head)
-{
-	struct nfs_delegation *delegation = container_of(head, struct nfs_delegation, rcu);
-
-	nfs_do_free_delegation(delegation);
-}
-
 static void nfs_free_delegation(struct nfs_delegation *delegation)
 {
 	if (delegation->cred) {
 		put_rpccred(delegation->cred);
 		delegation->cred = NULL;
 	}
-	call_rcu(&delegation->rcu, nfs_free_delegation_callback);
+	kfree_rcu(delegation, rcu);
 }
 
 /**
-- 
1.7.3.2

