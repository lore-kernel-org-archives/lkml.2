Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1CRDls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:41:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54758 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1CRDlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:41:40 -0400
Message-ID: <4D82D4DE.60105@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:43:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
        devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 06/36] net,rcu: convert call_rcu(__gen_kill_estimator) to
 kfree_rcu()
References: <4D82D071.5020703@cn.fujitsu.com> <4D82D3FF.2080303@cn.fujitsu.com>
In-Reply-To: <4D82D3FF.2080303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:40:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:40:18,
	Serialize complete at 2011-03-18 11:40:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback __gen_kill_estimator() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(__gen_kill_estimator).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/core/gen_estimator.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 7c23733..43b03dd 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -249,13 +249,6 @@ int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 }
 EXPORT_SYMBOL(gen_new_estimator);
 
-static void __gen_kill_estimator(struct rcu_head *head)
-{
-	struct gen_estimator *e = container_of(head,
-					struct gen_estimator, e_rcu);
-	kfree(e);
-}
-
 /**
  * gen_kill_estimator - remove a rate estimator
  * @bstats: basic statistics
@@ -279,7 +272,7 @@ void gen_kill_estimator(struct gnet_stats_basic_packed *bstats,
 		write_unlock(&est_lock);
 
 		list_del_rcu(&e->list);
-		call_rcu(&e->e_rcu, __gen_kill_estimator);
+		kfree_rcu(e, e_rcu);
 	}
 	spin_unlock_bh(&est_tree_lock);
 }
-- 
1.7.4
