Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946502Ab2I1Vx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:53:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032017Ab2I1UXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jesse Gross <jesse@nicira.com>
Subject: [ 031/218] openvswitch: Reset upper layer protocol info on internal devices.
Date: Fri, 28 Sep 2012 13:14:08 -0700
Message-Id: <20120928201504.947743429@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


