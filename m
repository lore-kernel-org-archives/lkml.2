Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab1CRDnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:43:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59728 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1CRDn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:43:28 -0400
Message-ID: <4D82D544.6090509@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:45:08 +0800
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
Subject: [PATCH 09/36] net,rcu: convert call_rcu(ip_mc_socklist_reclaim) to
 kfree_rcu()
References: <4D82D071.5020703@cn.fujitsu.com> <4D82D3FF.2080303@cn.fujitsu.com>
In-Reply-To: <4D82D3FF.2080303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:42:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:42:01,
	Serialize complete at 2011-03-18 11:42:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback ip_mc_socklist_reclaim() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ip_mc_socklist_reclaim).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/ipv4/igmp.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index cf98a36..998dff0 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1850,14 +1850,6 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 	return err;
 }
 
-
-static void ip_mc_socklist_reclaim(struct rcu_head *rp)
-{
-	kfree(container_of(rp, struct ip_mc_socklist, rcu));
-	/* sk_omem_alloc should have been decreased by the caller*/
-}
-
-
 /*
  *	Ask a socket to leave a group.
  */
@@ -1897,7 +1889,7 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 		rtnl_unlock();
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
-		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
+		kfree_rcu(iml, rcu);
 		return 0;
 	}
 	if (!in_dev)
@@ -2312,7 +2304,7 @@ void ip_mc_drop_socket(struct sock *sk)
 			ip_mc_dec_group(in_dev, iml->multi.imr_multiaddr.s_addr);
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(sizeof(*iml), &sk->sk_omem_alloc);
-		call_rcu(&iml->rcu, ip_mc_socklist_reclaim);
+		kfree_rcu(iml, rcu);
 	}
 	rtnl_unlock();
 }
-- 
1.7.4
