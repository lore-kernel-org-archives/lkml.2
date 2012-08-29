Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2H2QuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:14 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3132 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab2H2Qta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:49:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344204000"; 
   d="scan'208";a="154160466"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] net: ipv6: fix error return code
Date: Wed, 29 Aug 2012 18:49:12 +0200
Message-Id: <1346258957-7649-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

The initial initialization of the return variable is also dropped, because
that value is never used.

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
 net/ipv6/esp6.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 6dc7fd3..282f372 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -167,8 +167,6 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 	struct esp_data *esp = x->data;
 
 	/* skb is pure payload to encrypt */
-	err = -ENOMEM;
-
 	aead = esp->aead;
 	alen = crypto_aead_authsize(aead);
 
@@ -203,8 +201,10 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 	}
 
 	tmp = esp_alloc_tmp(aead, nfrags + sglists, seqhilen);
-	if (!tmp)
+	if (!tmp) {
+		err = -ENOMEM;
 		goto error;
+	}
 
 	seqhi = esp_tmp_seqhi(tmp);
 	iv = esp_tmp_iv(aead, tmp, seqhilen);

