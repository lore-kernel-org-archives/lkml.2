Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab2ISVfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:35:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36881 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2ISVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:35:04 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/6] xfrm_user: fix info leak in copy_to_user_auth()
Date: Wed, 19 Sep 2012 23:33:38 +0200
Message-Id: <1348090423-32665-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348090423-32665-1-git-send-email-minipli@googlemail.com>
References: <1348090423-32665-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user_auth() fails to initialize the remainder of alg_name and
therefore discloses up to 54 bytes of heap memory via netlink to
userland.

Use strncpy() instead of strcpy() to fill the trailing bytes of alg_name
with null bytes.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 net/xfrm/xfrm_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e75d8e4..ba26423 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -742,7 +742,7 @@ static int copy_to_user_auth(struct xfrm_algo_auth *auth, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	algo = nla_data(nla);
-	strcpy(algo->alg_name, auth->alg_name);
+	strncpy(algo->alg_name, auth->alg_name, sizeof(algo->alg_name));
 	memcpy(algo->alg_key, auth->alg_key, (auth->alg_key_len + 7) / 8);
 	algo->alg_key_len = auth->alg_key_len;
 
-- 
1.7.10.4

