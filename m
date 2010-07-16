Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab0GPUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:25:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57999 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192Ab0GPUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:25:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Jul 2010 22:25:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4 RFC] firewire: cdev: add PHY packet transmission
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
Message-ID: <tkrat.29f50b597f93ced0@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an FW_CDEV_IOC_SEND_PHY_PACKET ioctl() for /dev/fw* which can be
used to implement bus management related functionality in userspace.

This is also half of the functionality (the transmit part) that is
needed to support a userspace implementation of a VersaPHY transaction
layer.

Safety considerations:

  - PHY packets are generally broadcasts and may have interesting
    effects on PHYs and the bus, e.g. make asynchronous arbitration
    impossible due to too low gap count.  Hence some kind of elevated
    privileges should be required of a process to be able to send
    PHY packets.  This implementation assumes that a process that is
    allowed to open the /dev/fw* of a local node does have this
    privilege.

    There was an inconclusive discussion about introducing POSIX
    capabilities as a means to check for user privileges for these
    kinds of operations.

  - The kernel does not check integrity of the supplied packet data.
    That would be far too much code, considering the many kinds of
    PHY packets.  A process which got the privilege to send these
    packets is trusted to do it correctly.

Just like with the other "send packet" ioctls, a non-blocking API is
chosen; i.e. the ioctl may return even before AT DMA started.  After
transmission, an event for poll()/read() is enqueued.  Most users are
going to need a blocking API, but a blocking userspace wrapper is easy
to implement, and the second of the two existing libraw1394 calls
raw1394_phy_packet_write() and raw1394_start_phy_packet_write() can be
better supported that way.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c  |   64 ++++++++++++++++++++++++++++++++++
 include/linux/firewire-cdev.h |   44 +++++++++++++++++++++++
 2 files changed, 107 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -195,6 +195,13 @@ struct iso_resource_event {
 	struct fw_cdev_event_iso_resource iso_resource;
 };
 
+struct outbound_phy_packet_event {
+	struct event event;
+	struct client *client;
+	struct fw_packet p;
+	struct fw_cdev_event_phy_packet phy_packet;
+};
+
 static inline void __user *u64_to_uptr(__u64 value)
 {
 	return (void __user *)(unsigned long)value;
@@ -397,6 +404,7 @@ union ioctl_arg {
 	struct fw_cdev_allocate_iso_resource	allocate_iso_resource;
 	struct fw_cdev_send_stream_packet	send_stream_packet;
 	struct fw_cdev_get_cycle_timer2		get_cycle_timer2;
+	struct fw_cdev_send_phy_packet		send_phy_packet;
 };
 
 static int ioctl_get_info(struct client *client, union ioctl_arg *arg)
@@ -1385,6 +1393,61 @@ static int ioctl_send_stream_packet(stru
 	return init_request(client, &request, dest, a->speed);
 }
 
+static void outbound_phy_packet_callback(struct fw_packet *packet,
+					 struct fw_card *card, int status)
+{
+	struct outbound_phy_packet_event *e =
+		container_of(packet, struct outbound_phy_packet_event, p);
+
+	switch (status) {
+	/* expected: */
+	case ACK_COMPLETE:	e->phy_packet.rcode = RCODE_COMPLETE;	break;
+	/* should never happen with PHY packets: */
+	case ACK_PENDING:	e->phy_packet.rcode = RCODE_COMPLETE;	break;
+	case ACK_BUSY_X:
+	case ACK_BUSY_A:
+	case ACK_BUSY_B:	e->phy_packet.rcode = RCODE_BUSY;	break;
+	case ACK_DATA_ERROR:	e->phy_packet.rcode = RCODE_DATA_ERROR;	break;
+	case ACK_TYPE_ERROR:	e->phy_packet.rcode = RCODE_TYPE_ERROR;	break;
+	/* stale generation; cancelled; on certain controllers: no ack */
+	default:		e->phy_packet.rcode = status;		break;
+	}
+
+	queue_event(e->client, &e->event,
+		    &e->phy_packet, sizeof(e->phy_packet), NULL, 0);
+	client_put(e->client);
+}
+
+static int ioctl_send_phy_packet(struct client *client, union ioctl_arg *arg)
+{
+	struct fw_cdev_send_phy_packet *a = &arg->send_phy_packet;
+	struct fw_card *card = client->device->card;
+	struct outbound_phy_packet_event *e;
+
+	/* Access policy: Allow this ioctl only on local nodes' device files. */
+	if (!client->device->is_local)
+		return -ENOSYS;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (e == NULL)
+		return -ENOMEM;
+
+	client_get(client);
+	e->client		= client;
+	e->p.speed		= SCODE_100;
+	e->p.generation		= a->generation;
+	e->p.header[0]		= a->data[0];
+	e->p.header[1]		= a->data[1];
+	e->p.header_length	= 8;
+	e->p.callback		= outbound_phy_packet_callback;
+	e->phy_packet.closure	= a->closure;
+	e->phy_packet.type	= FW_CDEV_EVENT_PHY_PACKET_SENT;
+
+	card->driver->send_request(card, &e->p);
+
+	return 0;
+}
+
 static int (* const ioctl_handlers[])(struct client *, union ioctl_arg *) = {
 	[0x00] = ioctl_get_info,
 	[0x01] = ioctl_send_request,
@@ -1407,6 +1470,7 @@ static int (* const ioctl_handlers[])(st
 	[0x12] = ioctl_send_broadcast_request,
 	[0x13] = ioctl_send_stream_packet,
 	[0x14] = ioctl_get_cycle_timer2,
+	[0x15] = ioctl_send_phy_packet,
 };
 
 static int dispatch_ioctl(struct client *client,
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -39,6 +39,7 @@
 
 /* available since kernel version 2.6.36 */
 #define FW_CDEV_EVENT_REQUEST2			0x06
+#define FW_CDEV_EVENT_PHY_PACKET_SENT		0x07
 
 /**
  * struct fw_cdev_event_common - Common part of all fw_cdev_event_ types
@@ -289,6 +290,19 @@ struct fw_cdev_event_iso_resource {
 };
 
 /**
+ * struct fw_cdev_event_phy_packet - A PHY packet was transmitted
+ * @closure:	See &fw_cdev_event_common;
+ *		set by %FW_CDEV_IOC_SEND_PHY_PACKET ioctl
+ * @type:	%FW_CDEV_EVENT_PHY_PACKET_SENT
+ * @rcode:	%RCODE_..., indicates success or failure of transmission
+ */
+struct fw_cdev_event_phy_packet {
+	__u64 closure;
+	__u32 type;
+	__u32 rcode;
+};
+
+/**
  * union fw_cdev_event - Convenience union of fw_cdev_event_ types
  * @common:        Valid for all types
  * @bus_reset:     Valid if @common.type == %FW_CDEV_EVENT_BUS_RESET
@@ -299,6 +313,7 @@ struct fw_cdev_event_iso_resource {
  * @iso_resource:  Valid if @common.type ==
  *				%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
  *				%FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED
+ * @phy_packet:    Valid if @common.type == %FW_CDEV_EVENT_PHY_PACKET_SENT
  *
  * Convenience union for userspace use.  Events could be read(2) into an
  * appropriately aligned char buffer and then cast to this union for further
@@ -316,6 +331,7 @@ union fw_cdev_event {
 	struct fw_cdev_event_request2		request2;     /* added in 2.6.36 */
 	struct fw_cdev_event_iso_interrupt	iso_interrupt;
 	struct fw_cdev_event_iso_resource	iso_resource; /* added in 2.6.30 */
+	struct fw_cdev_event_phy_packet		phy_packet;   /* added in 2.6.36 */
 };
 
 /* available since kernel version 2.6.22 */
@@ -347,6 +363,9 @@ union fw_cdev_event {
 /* available since kernel version 2.6.34 */
 #define FW_CDEV_IOC_GET_CYCLE_TIMER2   _IOWR('#', 0x14, struct fw_cdev_get_cycle_timer2)
 
+/* available since kernel version 2.6.36 */
+#define FW_CDEV_IOC_SEND_PHY_PACKET    _IOWR('#', 0x15, struct fw_cdev_send_phy_packet)
+
 /*
  * ABI version history
  *  1  (2.6.22)  - initial version
@@ -362,8 +381,9 @@ union fw_cdev_event {
  *               - shared use and auto-response for FCP registers
  *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
  *               - added %FW_CDEV_IOC_GET_CYCLE_TIMER2
- *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2
+ *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2, %FW_CDEV_EVENT_PHY_PACKET_SENT
  *               - implemented &fw_cdev_event_bus_reset.bm_node_id
+ *               - added %FW_CDEV_IOC_SEND_PHY_PACKET
  */
 #define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
@@ -811,4 +831,26 @@ struct fw_cdev_send_stream_packet {
 	__u32 speed;
 };
 
+/**
+ * struct fw_cdev_send_phy_packet - send a PHY packet
+ * @closure:	Passed back to userspace in the PHY-packet-sent event
+ * @data:	First and second quadlet of the PHY packet
+ * @generation:	The bus generation where packet is valid
+ *
+ * The %FW_CDEV_IOC_SEND_PHY_PACKET ioctl sends a PHY packet to all nodes
+ * on the same card as this device.  After transmission, an
+ * %FW_CDEV_EVENT_PHY_PACKET_SENT event is generated.
+ *
+ * The payload @data[] shall be specified in host byte order.  Usually,
+ * @data[1] needs to be the bitwise inverse of @data[0].  VersaPHY packets
+ * are an exception to this rule.
+ *
+ * The ioctl is only permitted on device files which represent a local node.
+ */
+struct fw_cdev_send_phy_packet {
+	__u64 closure;
+	__u32 data[2];
+	__u32 generation;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */

-- 
Stefan Richter
-=====-==-=- -=== =----
http://arcgraph.de/sr/

