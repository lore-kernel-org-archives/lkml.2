Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2JVRXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:23:20 -0400
Received: from [93.179.225.50] ([93.179.225.50]:41364 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab2JVRXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:23:18 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 13:23:18 EDT
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: davem@davemloft.net
Cc: dwmw2@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v2 2/3] pppoatm: fix race condition with destroying of vcc
Date: Mon, 22 Oct 2012 19:14:50 +0200
Message-Id: <1350926091-12642-2-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.0.2.g35080e9
In-Reply-To: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pppoatm_send() calls vcc->send() and now also checks for
some vcc flags that indicate destroyed vcc without proper locking.

The vcc_sendmsg() uses lock_sock(sk). This lock is used by
vcc_release(), so vcc_destroy_socket() will not be called between
check and during ->send(). The vcc_release_async() sets ATM_VF_CLOSE,
but it should be safe to call ->send() after it, because
vcc->dev->ops->close() is not called.

The pppoatm_send() is called with BH disabled, so bh_lock_sock()
should be used instead of lock_sock().

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 net/atm/pppoatm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 0dcb5dc..e3b2d69 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -270,6 +270,7 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 {
 	struct pppoatm_vcc *pvcc = chan_to_pvcc(chan);
 	struct atm_vcc *vcc;
+	int ret;
 
 	ATM_SKB(skb)->vcc = pvcc->atmvcc;
 	pr_debug("(skb=0x%p, vcc=0x%p)\n", skb, pvcc->atmvcc);
@@ -304,17 +305,24 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 	}
 
 	vcc = ATM_SKB(skb)->vcc;
+	bh_lock_sock(sk_atm(vcc));
+	if (sock_owned_by_user(sk_atm(vcc)))
+		goto nospace_unlock_sock;
 	if (test_bit(ATM_VF_RELEASED, &vcc->flags)
 			|| test_bit(ATM_VF_CLOSE, &vcc->flags)
 			|| !test_bit(ATM_VF_READY, &vcc->flags))
-		goto nospace;
+		goto nospace_unlock_sock;
 
 	atomic_add(skb->truesize, &sk_atm(ATM_SKB(skb)->vcc)->sk_wmem_alloc);
 	ATM_SKB(skb)->atm_options = ATM_SKB(skb)->vcc->atm_options;
 	pr_debug("atm_skb(%p)->vcc(%p)->dev(%p)\n",
 		 skb, ATM_SKB(skb)->vcc, ATM_SKB(skb)->vcc->dev);
-	return ATM_SKB(skb)->vcc->send(ATM_SKB(skb)->vcc, skb)
+	ret = ATM_SKB(skb)->vcc->send(ATM_SKB(skb)->vcc, skb)
 	    ? DROP_PACKET : 1;
+	bh_unlock_sock(sk_atm(vcc));
+	return ret;
+nospace_unlock_sock:
+	bh_unlock_sock(sk_atm(vcc));
 nospace:
 	/*
 	 * We don't have space to send this SKB now, but we might have
-- 
1.8.0.2.g35080e9

