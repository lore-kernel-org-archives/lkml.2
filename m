Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1EANaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:30:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38401 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125Ab1EANWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 46/86] security,rcu: convert call_rcu(user_update_rcu_disposal) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:26 -0700
Message-Id: <1304256126-26015-46-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback user_update_rcu_disposal() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(user_update_rcu_disposal).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 security/keys/user_defined.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index c6ca866..f66baf4 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -69,18 +69,6 @@ error:
 EXPORT_SYMBOL_GPL(user_instantiate);
 
 /*
- * dispose of the old data from an updated user defined key
- */
-static void user_update_rcu_disposal(struct rcu_head *rcu)
-{
-	struct user_key_payload *upayload;
-
-	upayload = container_of(rcu, struct user_key_payload, rcu);
-
-	kfree(upayload);
-}
-
-/*
  * update a user defined key
  * - the key's semaphore is write-locked
  */
@@ -114,7 +102,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 		key->expiry = 0;
 	}
 
-	call_rcu(&zap->rcu, user_update_rcu_disposal);
+	kfree_rcu(zap, rcu);
 
 error:
 	return ret;
@@ -145,7 +133,7 @@ void user_revoke(struct key *key)
 
 	if (upayload) {
 		rcu_assign_pointer(key->payload.data, NULL);
-		call_rcu(&upayload->rcu, user_update_rcu_disposal);
+		kfree_rcu(upayload, rcu);
 	}
 }
 
-- 
1.7.3.2

