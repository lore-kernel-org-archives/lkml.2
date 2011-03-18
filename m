Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1CRENY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:13:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59450 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1CRENR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:13:17 -0400
Message-ID: <4D82DC46.5010905@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:15:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 36/36] net,rcu: convert call_rcu(xt_osf_finger_free_rcu) to
 kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:11:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:11:56,
	Serialize complete at 2011-03-18 12:11:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback xt_osf_finger_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(xt_osf_finger_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/netfilter/xt_osf.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 4327e10..846f895 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -62,13 +62,6 @@ static const struct nla_policy xt_osf_policy[OSF_ATTR_MAX + 1] = {
 	[OSF_ATTR_FINGER]	= { .len = sizeof(struct xt_osf_user_finger) },
 };
 
-static void xt_osf_finger_free_rcu(struct rcu_head *rcu_head)
-{
-	struct xt_osf_finger *f = container_of(rcu_head, struct xt_osf_finger, rcu_head);
-
-	kfree(f);
-}
-
 static int xt_osf_add_callback(struct sock *ctnl, struct sk_buff *skb,
 			       const struct nlmsghdr *nlh,
 			       const struct nlattr * const osf_attrs[])
@@ -133,7 +126,7 @@ static int xt_osf_remove_callback(struct sock *ctnl, struct sk_buff *skb,
 		 * We are protected by nfnl mutex.
 		 */
 		list_del_rcu(&sf->finger_entry);
-		call_rcu(&sf->rcu_head, xt_osf_finger_free_rcu);
+		kfree_rcu(sf, rcu_head);
 
 		err = 0;
 		break;
@@ -414,7 +407,7 @@ static void __exit xt_osf_fini(void)
 
 		list_for_each_entry_rcu(f, &xt_osf_fingers[i], finger_entry) {
 			list_del_rcu(&f->finger_entry);
-			call_rcu(&f->rcu_head, xt_osf_finger_free_rcu);
+			kfree_rcu(f, rcu_head);
 		}
 	}
 	rcu_read_unlock();
-- 
1.7.4
