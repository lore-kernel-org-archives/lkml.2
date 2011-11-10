Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab1KJTBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:01:42 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:40923 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933082Ab1KJTBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:01:37 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] ah: Don't return NET_XMIT_DROP on input.
Date: Thu, 10 Nov 2011 14:01:27 -0500
Message-Id: <1320951687-21491-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ahash driver returns -EBUSY, AH4/6 input functions return
NET_XMIT_DROP, presumably copied from the output code path.  But
returning transmit codes on input doesn't make a lot of sense.
Since NET_XMIT_DROP is a positive int, this gets interpreted as
the next header type (i.e., success).  As that can only end badly,
remove the check.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
This appears to be another longstanding issue (since the initial ahash
conversion circa 2.6.33), but there doesn't seem to be many ahash
drivers in the tree that can possibly trigger it.  Furthermore, most
if not all of these drivers require special hardware.

 net/ipv4/ah4.c |    2 --
 net/ipv6/ah6.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index c7056b2..36d1440 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -369,8 +369,6 @@ static int ah_input(struct xfrm_state *x, struct sk_buff *skb)
 		if (err == -EINPROGRESS)
 			goto out;
 
-		if (err == -EBUSY)
-			err = NET_XMIT_DROP;
 		goto out_free;
 	}
 
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index eb71dbc..0873a21 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -581,8 +581,6 @@ static int ah6_input(struct xfrm_state *x, struct sk_buff *skb)
 		if (err == -EINPROGRESS)
 			goto out;
 
-		if (err == -EBUSY)
-			err = NET_XMIT_DROP;
 		goto out_free;
 	}
 
-- 
1.7.3.4

