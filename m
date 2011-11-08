Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1KHWNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:13:07 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:35490 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755868Ab1KHWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:13:05 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] ah: Correctly pass error codes in ahash output callback.
Date: Tue,  8 Nov 2011 17:12:44 -0500
Message-Id: <1320790365-29152-2-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1320790365-29152-1-git-send-email-nbowler@elliptictech.com>
References: <1320790365-29152-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AH4/6 ahash output callbacks pass nexthdr to xfrm_output_resume
instead of the error code.  This appears to be a copy+paste error from
the input case, where nexthdr is expected.  This causes the driver to
continuously add AH headers to the datagram until either an allocation
fails and the packet is dropped or the ahash driver hits a synchronous
fallback and the resulting monstrosity is transmitted.

Correct this issue by simply passing the error code unadulterated.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 net/ipv4/ah4.c |    2 --
 net/ipv6/ah6.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index c1f4154..33ca186 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -136,8 +136,6 @@ static void ah_output_done(struct crypto_async_request *base, int err)
 		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
 	}
 
-	err = ah->nexthdr;
-
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_output_resume(skb, err);
 }
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 2195ae6..ede4d9d 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -324,8 +324,6 @@ static void ah6_output_done(struct crypto_async_request *base, int err)
 #endif
 	}
 
-	err = ah->nexthdr;
-
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_output_resume(skb, err);
 }
-- 
1.7.3.4

