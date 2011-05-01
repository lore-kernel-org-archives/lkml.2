Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab1EANYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:24:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49921 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892Ab1EANWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:40 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>
Subject: [PATCH tip/core/rcu 82/86] security,rcu: convert call_rcu(sel_netport_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:22:02 -0700
Message-Id: <1304256126-26015-82-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback sel_netport_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sel_netport_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>
---
 security/selinux/netport.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index cfe2d72..ae76e29 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -68,22 +68,6 @@ static DEFINE_SPINLOCK(sel_netport_lock);
 static struct sel_netport_bkt sel_netport_hash[SEL_NETPORT_HASH_SIZE];
 
 /**
- * sel_netport_free - Frees a port entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table port entry can be
- * released safely.
- *
- */
-static void sel_netport_free(struct rcu_head *p)
-{
-	struct sel_netport *port = container_of(p, struct sel_netport, rcu);
-	kfree(port);
-}
-
-/**
  * sel_netport_hashfn - Hashing function for the port table
  * @pnum: port number
  *
@@ -142,7 +126,7 @@ static void sel_netport_insert(struct sel_netport *port)
 			rcu_dereference(sel_netport_hash[idx].list.prev),
 			struct sel_netport, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netport_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netport_hash[idx].size++;
 }
@@ -241,7 +225,7 @@ static void sel_netport_flush(void)
 		list_for_each_entry_safe(port, port_tmp,
 					 &sel_netport_hash[idx].list, list) {
 			list_del_rcu(&port->list);
-			call_rcu(&port->rcu, sel_netport_free);
+			kfree_rcu(port, rcu);
 		}
 		sel_netport_hash[idx].size = 0;
 	}
-- 
1.7.3.2

