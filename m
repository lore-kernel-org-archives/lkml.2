Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2H2QuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:07 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:35228
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab2H2Qtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:49:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344204000"; 
   d="scan'208";a="154160465"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Wensong Zhang <wensong@linux-vs.org>
Cc: kernel-janitors@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] ipvs: fix error return code
Date: Wed, 29 Aug 2012 18:49:11 +0200
Message-Id: <1346258957-7649-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 net/netfilter/ipvs/ip_vs_ctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 3c60137..767cc12 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1171,8 +1171,10 @@ ip_vs_add_service(struct net *net, struct ip_vs_service_user_kern *u,
 		goto out_err;
 	}
 	svc->stats.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
-	if (!svc->stats.cpustats)
+	if (!svc->stats.cpustats) {
+		ret = -ENOMEM;
 		goto out_err;
+	}
 
 	/* I'm the first user of the service */
 	atomic_set(&svc->usecnt, 0);

