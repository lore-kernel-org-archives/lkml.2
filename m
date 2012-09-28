Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2I1Szz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:55:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab2I1Szn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jesse Gross <jesse@nicira.com>
Subject: [ 034/262] openvswitch: Reset upper layer protocol info on internal devices.
Date: Fri, 28 Sep 2012 11:49:23 -0700
Message-Id: <20120928183001.942500251@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jesse Gross <jesse@nicira.com>

[ Upstream commit 7fe99e2d434eafeac0c57b279a77e5de39212636 ]

It's possible that packets that are sent on internal devices (from
the OVS perspective) have already traversed the local IP stack.
After they go through the internal device, they will again travel
through the IP stack which may get confused by the presence of
existing information in the skb. The problem can be observed
when switching between namespaces. This clears out that information
to avoid problems but deliberately leaves other metadata alone.
This is to provide maximum flexibility in chaining together OVS
and other Linux components.

Signed-off-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/vport-internal_dev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -24,6 +24,9 @@
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
 
+#include <net/dst.h>
+#include <net/xfrm.h>
+
 #include "datapath.h"
 #include "vport-internal_dev.h"
 #include "vport-netdev.h"
@@ -209,6 +212,11 @@ static int internal_dev_recv(struct vpor
 	int len;
 
 	len = skb->len;
+
+	skb_dst_drop(skb);
+	nf_reset(skb);
+	secpath_reset(skb);
+
 	skb->dev = netdev;
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, netdev);


