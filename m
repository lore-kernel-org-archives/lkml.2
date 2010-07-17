Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab0GQRUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 13:20:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38480 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab0GQRUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 13:20:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jul 2010 19:19:56 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/4 RFC] firewire: cdev: add PHY pinging
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
Message-ID: <tkrat.506ae60f1ea3a97a@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the FW_CDEV_IOC_SEND_PHY_PACKET ioctl() for /dev/fw* to be
useful for ping time measurements.  One application for it would be gap
count optimization in userspace that is based on ping times rather than
hop count.  (The latter is implemented in firewire-core itself but is
not applicable to beta PHYs that act as repeater.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
A simple test tool will be posted at linux1394-devel.

 drivers/firewire/core-cdev.c  |    9 ++++++---
 drivers/firewire/core.h       |    5 +++++
 drivers/firewire/ohci.c       |    4 ++++
 include/linux/firewire-cdev.h |    5 ++++-
 4 files changed, 19 insertions(+), 4 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1424,9 +1424,10 @@ static void outbound_phy_packet_callback
 	/* stale generation; cancelled; on certain controllers: no ack */
 	default:		e->phy_packet.rcode = status;		break;
 	}
+	e->phy_packet.data[0] = packet->timestamp;
 
-	queue_event(e->client, &e->event,
-		    &e->phy_packet, sizeof(e->phy_packet), NULL, 0);
+	queue_event(e->client, &e->event, &e->phy_packet,
+		    sizeof(e->phy_packet) + e->phy_packet.length, NULL, 0);
 	client_put(e->client);
 }
 
@@ -1440,7 +1441,7 @@ static int ioctl_send_phy_packet(struct 
 	if (!client->device->is_local)
 		return -ENOSYS;
 
-	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	e = kzalloc(sizeof(*e) + 4, GFP_KERNEL);
 	if (e == NULL)
 		return -ENOMEM;
 
@@ -1454,6 +1455,8 @@ static int ioctl_send_phy_packet(struct 
 	e->p.callback		= outbound_phy_packet_callback;
 	e->phy_packet.closure	= a->closure;
 	e->phy_packet.type	= FW_CDEV_EVENT_PHY_PACKET_SENT;
+	if (is_ping_packet(a->data))
+			e->phy_packet.length = 4;
 
 	card->driver->send_request(card, &e->p);
 
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -234,4 +234,9 @@ void fw_fill_response(struct fw_packet *
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count);
 
+static inline bool is_ping_packet(u32 *data)
+{
+	return (data[0] & 0xc0ffffff) == 0 && ~data[0] == data[1];
+}
+
 #endif /* _FIREWIRE_CORE_H */
Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1105,6 +1105,10 @@ static int at_context_queue_packet(struc
 	} else {
 		last = &d[0];
 		z = 2;
+
+		if (packet->header_length == 8 &&
+		    is_ping_packet(packet->header))
+			last->control |= cpu_to_le16(DESCRIPTOR_PING);
 	}
 
 	last->control |= cpu_to_le16(DESCRIPTOR_OUTPUT_LAST |
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -299,7 +299,10 @@ struct fw_cdev_event_iso_resource {
  * @length:	Data length in bytes
  * @data:	Incoming data
  *
- * If @type is %FW_CDEV_EVENT_PHY_PACKET_SENT, @length is 0 and @data empty.
+ * If @type is %FW_CDEV_EVENT_PHY_PACKET_SENT, @length is 0 and @data empty,
+ * except in case of a ping packet:  Then, @length is 4, and @data[0] is the
+ * ping time in 49.152MHz clocks if @rcode is %RCODE_COMPLETE.
+ *
  * If @type is %FW_CDEV_EVENT_PHY_PACKET_RECEIVED, @length is 8 and @data
  * consists of the two PHY packet quadlets, in host byte order.
  */

-- 
Stefan Richter
-=====-==-=- -=== =---=
http://arcgraph.de/sr/

