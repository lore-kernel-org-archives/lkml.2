Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1CQWdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:33:38 -0400
Received: from build.ihdev.net ([178.63.197.118]:51229 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab1CQWdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:33:37 -0400
X-Greylist: delayed 766 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 18:33:37 EDT
From: Sergey Lapin <slapin@ossfans.org>
To: <linux-x25@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Sergey Lapin <slapin@ossfans.org>
Subject: [PATCH] Allow LAPB users know which data were actually sent.
Date: Thu, 17 Mar 2011 18:20:22 -0400
Message-Id: <1300400422-8820-1-git-send-email-slapin@ossfans.org>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, when LAPB is transport layer for X.25 protocol,
internal mechanics of X.25 knows wheather data were actually
received by peer. But for non-X.25 protocols which use LAPB
as data reliability layer, it is important to have some way
to know what was actually sent, so we add transmit indication.

This change doesn't affext X.25 in any way.

Signed-off-by: Sergey Lapin <slapin@ossfans.org>
---
 include/linux/lapb.h  |    2 ++
 include/net/lapb.h    |    2 ++
 net/lapb/lapb_iface.c |   13 +++++++++++++
 net/lapb/lapb_subr.c  |    1 +
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/lapb.h b/include/linux/lapb.h
index ce709e1..a57cac0 100644
--- a/include/linux/lapb.h
+++ b/include/linux/lapb.h
@@ -30,6 +30,8 @@ struct lapb_register_struct {
 	void (*disconnect_indication)(struct net_device *dev, int reason);
 	int  (*data_indication)(struct net_device *dev, struct sk_buff *skb);
 	void (*data_transmit)(struct net_device *dev, struct sk_buff *skb);
+	void (*data_transmit_indication)(struct net_device *dev,
+			struct sk_buff *skb);
 };
 
 struct lapb_parms_struct {
diff --git a/include/net/lapb.h b/include/net/lapb.h
index 96cb5dd..b720ffa 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -111,6 +111,8 @@ extern void lapb_disconnect_confirmation(struct lapb_cb *lapb, int);
 extern void lapb_disconnect_indication(struct lapb_cb *lapb, int);
 extern int  lapb_data_indication(struct lapb_cb *lapb, struct sk_buff *);
 extern int  lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *);
+extern void  lapb_data_transmit_indication(struct lapb_cb *lapb,
+				struct sk_buff *);
 
 /* lapb_in.c */
 extern void lapb_data_input(struct lapb_cb *lapb, struct sk_buff *);
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index d5d8d55..024045f 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -423,6 +423,19 @@ int lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *skb)
 	return used;
 }
 
+/* Here we indicate what we have just sent and received ack for
+ * This will allow us know what actually was sent */
+void lapb_data_transmit_indication(struct lapb_cb *lapb,
+					struct sk_buff *skb)
+{
+	int used = 0;
+	if (lapb->callbacks.data_transmit) {
+		lapb->callbacks.data_transmit_indication(lapb->dev, skb);
+		used = 1;
+	}
+	return used;
+}
+
 EXPORT_SYMBOL(lapb_register);
 EXPORT_SYMBOL(lapb_unregister);
 EXPORT_SYMBOL(lapb_getparms);
diff --git a/net/lapb/lapb_subr.c b/net/lapb/lapb_subr.c
index 43a2a7f..87ec449 100644
--- a/net/lapb/lapb_subr.c
+++ b/net/lapb/lapb_subr.c
@@ -60,6 +60,7 @@ void lapb_frames_acked(struct lapb_cb *lapb, unsigned short nr)
 	if (lapb->va != nr)
 		while (skb_peek(&lapb->ack_queue) && lapb->va != nr) {
 			skb = skb_dequeue(&lapb->ack_queue);
+			lapb_data_transmit_indication(lapb, skb);
 			kfree_skb(skb);
 			lapb->va = (lapb->va + 1) % modulus;
 		}
-- 
1.7.4.1

