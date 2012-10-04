Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2JDWRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:17:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44231 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2JDVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:17:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 12/56] staging: r8712u: Do not queue cloned skb
Date: Thu,  4 Oct 2012 14:15:33 -0700
Message-Id: <20121004211153.499282651@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit fa16e5ea25d7dd83f663f333e70713aa2fa5dffe upstream.

Some post-3.4 kernels have a problem when a cloned skb is used in the
RX path. This patch handles one such case for r8712u.

The patch was suggested by Eric Dumazet.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/rtl8712_recv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -1127,6 +1127,9 @@ static void recv_tasklet(void *priv)
 		recvbuf2recvframe(padapter, pskb);
 		skb_reset_tail_pointer(pskb);
 		pskb->len = 0;
-		skb_queue_tail(&precvpriv->free_recv_skb_queue, pskb);
+		if (!skb_cloned(pskb))
+			skb_queue_tail(&precvpriv->free_recv_skb_queue, pskb);
+		else
+			consume_skb(pskb);
 	}
 }


