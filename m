Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2EaPps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:45:48 -0400
Received: from slapinbuild.ihdev.net ([46.4.202.25]:55458 "EHLO
	build.ossfans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab2EaPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:45:47 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 11:45:44 EDT
From: Sergey Lapin <slapin@ossfans.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        Sergey Lapin <slapin@ossfans.org>
Subject: [PATCH 1/2] LAPB: added 'delivered' interface
Date: Thu, 31 May 2012 11:31:17 -0400
Message-Id: <1338478278-24732-1-git-send-email-slapin@ossfans.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using LAPB API for non-X.25 work, it is often necessary
to know if/when data is delivered to third party using LAPB
interface (e.g over serial or other media).

Signed-off-by: Sergey Lapin <slapin@ossfans.org>
---
 include/linux/lapb.h  |    1 +
 net/lapb/lapb_iface.c |    6 ++++++
 net/lapb/lapb_subr.c  |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/lapb.h b/include/linux/lapb.h
index 873c1eb..fd963be 100644
--- a/include/linux/lapb.h
+++ b/include/linux/lapb.h
@@ -30,6 +30,7 @@ struct lapb_register_struct {
 	void (*disconnect_indication)(struct net_device *dev, int reason);
 	int  (*data_indication)(struct net_device *dev, struct sk_buff *skb);
 	void (*data_transmit)(struct net_device *dev, struct sk_buff *skb);
+	void (*data_delivered)(struct net_device *dev, struct sk_buff *skb);
 };
 
 struct lapb_parms_struct {
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 3cdaa04..0fe77ae 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -415,6 +415,12 @@ int lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *skb)
 	return used;
 }
 
+void lapb_data_delivered(struct lapb_cb *lapb, struct sk_buff *skb)
+{
+	if (lapb->callbacks->data_delivered)
+		lapb->callbacks->data_delivered(lapb->dev, skb);
+}
+
 EXPORT_SYMBOL(lapb_register);
 EXPORT_SYMBOL(lapb_unregister);
 EXPORT_SYMBOL(lapb_getparms);
diff --git a/net/lapb/lapb_subr.c b/net/lapb/lapb_subr.c
index 9d0a426..a44451d 100644
--- a/net/lapb/lapb_subr.c
+++ b/net/lapb/lapb_subr.c
@@ -61,6 +61,7 @@ void lapb_frames_acked(struct lapb_cb *lapb, unsigned short nr)
 	if (lapb->va != nr)
 		while (skb_peek(&lapb->ack_queue) && lapb->va != nr) {
 			skb = skb_dequeue(&lapb->ack_queue);
+			lapb_data_delivered(lapb, skb);
 			kfree_skb(skb);
 			lapb->va = (lapb->va + 1) % modulus;
 		}
-- 
1.7.5.4

