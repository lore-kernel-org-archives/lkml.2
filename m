Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab1EANYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:24:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54971 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab1EANW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 42/86] net,rcu: convert call_rcu(sctp_local_addr_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:22 -0700
Message-Id: <1304256126-26015-42-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback sctp_local_addr_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sctp_local_addr_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/net/sctp/sctp.h |    1 -
 net/sctp/bind_addr.c    |    2 +-
 net/sctp/ipv6.c         |    2 +-
 net/sctp/protocol.c     |    9 +--------
 4 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 505845d..01e094c 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -115,7 +115,6 @@
  * sctp/protocol.c
  */
 extern struct sock *sctp_get_ctl_sock(void);
-extern void sctp_local_addr_free(struct rcu_head *head);
 extern int sctp_copy_local_addr_list(struct sctp_bind_addr *,
 				     sctp_scope_t, gfp_t gfp,
 				     int flags);
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index faf71d1..3c06c87 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -219,7 +219,7 @@ int sctp_del_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *del_addr)
 	}
 
 	if (found) {
-		call_rcu(&addr->rcu, sctp_local_addr_free);
+		kfree_rcu(addr, rcu);
 		SCTP_DBG_OBJCNT_DEC(addr);
 		return 0;
 	}
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 865ce7b..185fe05 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -123,7 +123,7 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 		}
 		spin_unlock_bh(&sctp_local_addr_lock);
 		if (found)
-			call_rcu(&addr->rcu, sctp_local_addr_free);
+			kfree_rcu(addr, rcu);
 		break;
 	}
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d5bf91d..065d999 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -230,13 +230,6 @@ static void sctp_free_local_addr_list(void)
 	}
 }
 
-void sctp_local_addr_free(struct rcu_head *head)
-{
-	struct sctp_sockaddr_entry *e = container_of(head,
-				struct sctp_sockaddr_entry, rcu);
-	kfree(e);
-}
-
 /* Copy the local addresses which are valid for 'scope' into 'bp'.  */
 int sctp_copy_local_addr_list(struct sctp_bind_addr *bp, sctp_scope_t scope,
 			      gfp_t gfp, int copy_flags)
@@ -681,7 +674,7 @@ static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
 		}
 		spin_unlock_bh(&sctp_local_addr_lock);
 		if (found)
-			call_rcu(&addr->rcu, sctp_local_addr_free);
+			kfree_rcu(addr, rcu);
 		break;
 	}
 
-- 
1.7.3.2

