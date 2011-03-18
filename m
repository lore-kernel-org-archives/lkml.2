Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1CRECQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:02:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1CRECK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:02:10 -0400
Message-ID: <4D82D9AC.30205@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:03:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Moore <paul.moore@hp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/36] net,rcu: convert call_rcu(netlbl_unlhsh_free_addr4)
 to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:00:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:00:48,
	Serialize complete at 2011-03-18 12:00:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback netlbl_unlhsh_free_addr4() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(netlbl_unlhsh_free_addr4).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/netlabel/netlabel_unlabeled.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e2b0a68..4e5ad90 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -153,24 +153,6 @@ static const struct nla_policy netlbl_unlabel_genl_policy[NLBL_UNLABEL_A_MAX + 1
  * Unlabeled Connection Hash Table Functions
  */
 
-/**
- * netlbl_unlhsh_free_addr4 - Frees an IPv4 address entry from the hash table
- * @entry: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table address entry can be
- * released safely.
- *
- */
-static void netlbl_unlhsh_free_addr4(struct rcu_head *entry)
-{
-	struct netlbl_unlhsh_addr4 *ptr;
-
-	ptr = container_of(entry, struct netlbl_unlhsh_addr4, rcu);
-	kfree(ptr);
-}
-
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 /**
  * netlbl_unlhsh_free_addr6 - Frees an IPv6 address entry from the hash table
@@ -568,7 +550,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	if (entry == NULL)
 		return -ENOENT;
 
-	call_rcu(&entry->rcu, netlbl_unlhsh_free_addr4);
+	kfree_rcu(entry, rcu);
 	return 0;
 }
 
-- 
1.7.4
