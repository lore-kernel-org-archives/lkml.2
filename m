Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2H2QuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:11 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3132 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab2H2Qte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:49:34 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344204000"; 
   d="scan'208";a="154160471"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kernel-janitors@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] net/netfilter/nfnetlink_log.c: fix error return code
Date: Wed, 29 Aug 2012 18:49:17 +0200
Message-Id: <1346258957-7649-8-git-send-email-Julia.Lawall@lip6.fr>
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
 net/netfilter/nfnetlink_log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 4142aac..9ef5438 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1002,8 +1002,10 @@ static int __init nfnetlink_log_init(void)
 
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nfnetlink_log", 0440,
-			 proc_net_netfilter, &nful_file_ops))
+			 proc_net_netfilter, &nful_file_ops)) {
+		status = -ENOMEM;
 		goto cleanup_logger;
+	}
 #endif
 	return status;
 

