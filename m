Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2H2QuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:50:01 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3132 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982Ab2H2Qtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:49:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,335,1344204000"; 
   d="scan'208";a="154160469"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] net/xfrm/xfrm_state.c: fix error return code
Date: Wed, 29 Aug 2012 18:49:15 +0200
Message-Id: <1346258957-7649-6-git-send-email-Julia.Lawall@lip6.fr>
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
 net/xfrm/xfrm_state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 7856c33..b68e0cc 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1994,8 +1994,10 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay)
 		goto error;
 
 	x->outer_mode = xfrm_get_mode(x->props.mode, family);
-	if (x->outer_mode == NULL)
+	if (x->outer_mode == NULL) {
+		err = -EPROTONOSUPPORT;
 		goto error;
+	}
 
 	if (init_replay) {
 		err = xfrm_init_replay(x);

