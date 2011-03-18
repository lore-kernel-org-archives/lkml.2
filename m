Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1CREDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:03:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1CREDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:03:03 -0400
Message-ID: <4D82D9E2.4000408@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:04:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Moore <paul.moore@hp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/36] net,rcu: convert call_rcu(netlbl_unlhsh_free_addr6)
 to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:01:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:01:41,
	Serialize complete at 2011-03-18 12:01:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback netlbl_unlhsh_free_addr6() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(netlbl_unlhsh_free_addr6).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/netlabel/netlabel_unlabeled.c |   22 +---------------------
 1 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 4e5ad90..9c38658 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -153,26 +153,6 @@ static const struct nla_policy netlbl_unlabel_genl_policy[NLBL_UNLABEL_A_MAX + 1
  * Unlabeled Connection Hash Table Functions
  */
 
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-/**
- * netlbl_unlhsh_free_addr6 - Frees an IPv6 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr6(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr6 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr6, rcu);
-	kfree(ptr);
-}
-#endif /* IPv6 */
-
 /**
  * netlbl_unlhsh_free_iface - Frees an interface entry from the hash table
  * @entry: the entry's RCU field
@@ -611,7 +591,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr6);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 #endif /* IPv6 */
-- 
1.7.4
