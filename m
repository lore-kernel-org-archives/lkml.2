Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0FXFpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:45:53 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38578 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0FXFpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=F17/SZHQWNzp8pL4jE7+j1XeuaOT25siEWp7yLLqJIFzfK9wNsqpiIuIYo5C5Tw2UV
         9VB4aNMytYSK+YddmPDex3VNB+Mlwr3kDq6D+A1/IEaStnThIWJGEpc66hFbtGNMAdS5
         DJzydxdC1CTeJkiHJvApMRz3xqXIdWcYjDf2g=
From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>
To: netdev@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "John W.Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Cc: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>
Subject: [PATCH] xfrm: check bundle policy existance before dereferencing it
Date: Thu, 24 Jun 2010 08:45:19 +0300
Message-Id: <1277358319-9868-1-git-send-email-timo.teras@iki.fi>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4C22805A.3080307@gmail.com>
References: <4C22805A.3080307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the bundle validation code to not assume having a valid policy.
When we have multiple transformations for a xfrm policy, the bundle
instance will be a chain of bundles with only the first one having
the policy reference. When policy_genid is bumped it will expire the
first bundle in the chain which is equivalent of expiring the whole
chain.

Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Timo Teräs <timo.teras@iki.fi>
---
 net/xfrm/xfrm_policy.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4bf27d9..af1c173 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2300,7 +2300,8 @@ int xfrm_bundle_ok(struct xfrm_policy *pol, struct xfrm_dst *first,
 			return 0;
 		if (xdst->xfrm_genid != dst->xfrm->genid)
 			return 0;
-		if (xdst->policy_genid != atomic_read(&xdst->pols[0]->genid))
+		if (xdst->num_pols > 0 &&
+		    xdst->policy_genid != atomic_read(&xdst->pols[0]->genid))
 			return 0;
 
 		if (strict && fl &&
-- 
1.7.0.4

