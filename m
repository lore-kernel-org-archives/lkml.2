Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1EBVlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:41:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35397 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766Ab1EBVhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:37:00 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH tip/core/rcu 6/7] net,rcu: convert call_rcu(prl_entry_destroy_rcu) to kfree
Date: Mon,  2 May 2011 09:13:43 -0700
Message-Id: <1304352824-6563-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110502161321.GA6537@linux.vnet.ibm.com>
References: <20110502161321.GA6537@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU callback prl_entry_destroy_rcu() just calls kfree(), so we can
use kfree_rcu() instead of call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/ipv6/sit.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 43b3337..5f35d59 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -401,11 +401,6 @@ out:
 	return err;
 }
 
-static void prl_entry_destroy_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_tunnel_prl_entry, rcu_head));
-}
-
 static void prl_list_destroy_rcu(struct rcu_head *head)
 {
 	struct ip_tunnel_prl_entry *p, *n;
@@ -433,7 +428,7 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		     p = &x->next) {
 			if (x->addr == a->addr) {
 				*p = x->next;
-				call_rcu(&x->rcu_head, prl_entry_destroy_rcu);
+				kfree_rcu(x, rcu_head);
 				t->prl_count--;
 				goto out;
 			}
-- 
1.7.3.2

