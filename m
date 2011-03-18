Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1CRD7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:59:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64588 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1CRD7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:59:05 -0400
Message-ID: <4D82D8F2.5020208@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:00:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/36] net,rcu: convert call_rcu(ipv6_mc_socklist_reclaim)
 to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:57:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:57:43,
	Serialize complete at 2011-03-18 11:57:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback ipv6_mc_socklist_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ipv6_mc_socklist_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/ipv6/mcast.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 49f986d..7f8df31 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -201,10 +201,6 @@ int ipv6_sock_mc_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	return 0;
 }
 
-static void ipv6_mc_socklist_reclaim(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ipv6_mc_socklist, rcu));
-}
 /*
  *	socket leave on multicast group
  */
@@ -239,7 +235,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 				(void) ip6_mc_leave_src(sk, mc_lst, NULL);
 			rcu_read_unlock();
 			atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-			call_rcu(&mc_lst->rcu, ipv6_mc_socklist_reclaim);
+			kfree_rcu(mc_lst, rcu);
 			return 0;
 		}
 	}
@@ -307,7 +303,7 @@ void ipv6_sock_mc_close(struct sock *sk)
 		rcu_read_unlock();
 
 		atomic_sub(sizeof(*mc_lst), &sk->sk_omem_alloc);
-		call_rcu(&mc_lst->rcu, ipv6_mc_socklist_reclaim);
+		kfree_rcu(mc_lst, rcu);
 
 		spin_lock(&ipv6_sk_mc_lock);
 	}
-- 
1.7.4
