Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1CRDm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:42:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1CRDmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:42:22 -0400
Message-ID: <4D82D508.5080901@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:44:08 +0800
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
Subject: [PATCH 07/36] net,rcu: convert call_rcu(ip_mc_list_reclaim) to kfree_rcu()
References: <4D82D071.5020703@cn.fujitsu.com> <4D82D3FF.2080303@cn.fujitsu.com>
In-Reply-To: <4D82D3FF.2080303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:40:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:40:59,
	Serialize complete at 2011-03-18 11:40:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback ip_mc_list_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ip_mc_list_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/ipv4/igmp.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index e0e77e2..cf187b6 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -149,17 +149,11 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc);
 static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 			 int sfcount, __be32 *psfsrc, int delta);
 
-
-static void ip_mc_list_reclaim(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ip_mc_list, rcu));
-}
-
 static void ip_ma_put(struct ip_mc_list *im)
 {
 	if (atomic_dec_and_test(&im->refcnt)) {
 		in_dev_put(im->interface);
-		call_rcu(&im->rcu, ip_mc_list_reclaim);
+		kfree_rcu(im, rcu);
 	}
 }
 
-- 
1.7.4
