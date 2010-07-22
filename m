Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0GVU2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:28:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50026
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352Ab0GVU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:28:04 -0400
Date: Thu, 22 Jul 2010 13:28:20 -0700 (PDT)
Message-Id: <20100722.132820.234331174.davem@davemloft.net>
To: andrea@persephoneslair.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of skb csum field in pskb_expand_head()
 of net/core/skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100722191234.GA832@cronus.persephoneslair.org>
References: <20100722191234.GA832@cronus.persephoneslair.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Shepard <andrea@persephoneslair.org>
Date: Thu, 22 Jul 2010 12:12:35 -0700

> Make pskb_expand_head() check ip_summed to make sure csum_start is really
> csum_start and not csum before adjusting it.
...
> Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

Applied, but your email client corrupted tab characters into spaces so
I had to apply your patch by hand.

There is a similar bug in skb_copy_expand() so I fixed that too.

Thanks again.

--------------------
net: Fix skb_copy_expand() handling of ->csum_start

It should only be adjusted if ip_summed == CHECKSUM_PARTIAL.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/skbuff.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c699159..ce88293 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -932,7 +932,8 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
 	copy_skb_header(n, skb);
 
 	off                  = newheadroom - oldheadroom;
-	n->csum_start       += off;
+	if (n->ip_summed == CHECKSUM_PARTIAL)
+		n->csum_start += off;
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
 	n->transport_header += off;
 	n->network_header   += off;
-- 
1.7.1.1

