Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030791Ab2HGXD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:03:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030713Ab2HGWkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:40:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Manfred Rudigier <manfred.rudigier@omicron.at>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        Jiajun Wu <b06378@freescale.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 079/109] gianfar: fix potential sk_wmem_alloc imbalance
Date: Tue,  7 Aug 2012 15:35:38 -0700
Message-Id: <20120807222050.031986142@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 313b037cf054ec908de92fb4c085403ffd7420d4 ]

commit db83d136d7f753 (gianfar: Fix missing sock reference when
processing TX time stamps) added a potential sk_wmem_alloc imbalance

If the new skb has a different truesize than old one, we can get a
negative sk_wmem_alloc once new skb is orphaned at TX completion.

Now we no longer early orphan skbs in dev_hard_start_xmit(), this
probably can lead to fatal bugs.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Manfred Rudigier <manfred.rudigier@omicron.at>
Cc: Claudiu Manoil <claudiu.manoil@freescale.com>
Cc: Jiajun Wu <b06378@freescale.com>
Cc: Andy Fleming <afleming@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2065,10 +2065,9 @@ static int gfar_start_xmit(struct sk_buf
 			return NETDEV_TX_OK;
 		}
 
-		/* Steal sock reference for processing TX time stamps */
-		swap(skb_new->sk, skb->sk);
-		swap(skb_new->destructor, skb->destructor);
-		kfree_skb(skb);
+		if (skb->sk)
+			skb_set_owner_w(skb_new, skb->sk);
+		consume_skb(skb);
 		skb = skb_new;
 	}
 


