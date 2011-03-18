Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1CREF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:05:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50233 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1CREFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:05:22 -0400
Message-ID: <4D82DA6D.7030100@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:07:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/36] net,rcu: convert call_rcu(__nf_ct_ext_free_rcu) to
 kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:04:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:04:00,
	Serialize complete at 2011-03-18 12:04:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback __nf_ct_ext_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(__nf_ct_ext_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/netfilter/nf_conntrack_extend.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index bd82450..cc0bcda 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -68,12 +68,6 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)(*ext) + off;
 }
 
-static void __nf_ct_ext_free_rcu(struct rcu_head *head)
-{
-	struct nf_ct_ext *ext = container_of(head, struct nf_ct_ext, rcu);
-	kfree(ext);
-}
-
 void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *old, *new;
@@ -114,7 +108,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 					(void *)old + old->offset[i]);
 			rcu_read_unlock();
 		}
-		call_rcu(&old->rcu, __nf_ct_ext_free_rcu);
+		kfree_rcu(old, rcu);
 		ct->ext = new;
 	}
 
-- 
1.7.4
