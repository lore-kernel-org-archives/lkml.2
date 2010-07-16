Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab0GPU0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:26:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58004 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192Ab0GPU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:26:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Jul 2010 22:25:51 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4 RFC] firewire: cdev: add PHY packet reception
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
Message-ID: <tkrat.5fd8fb865c16340e@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an FW_CDEV_IOC_RECEIVE_PHY_PACKETS ioctl() and
FW_CDEV_EVENT_PHY_PACKET_RECEIVED poll()/read() event for /dev/fw*.
This can be used to get information from remote PHYs by remote access
PHY packets.

This is also the 2nd half of the functionality (the receive part) to
support a userspace implementation of a VersaPHY transaction layer.

Safety considerations:

  - PHY packets are generally broadcasts, hence some kind of elevated
    privileges should be required of a process to be able to listen in
    on PHY packets.  This implementation assumes that a process that is
    allowed to open the /dev/fw* of a local node does have this
    privilege.

    There was an inconclusive discussion about introducing POSIX
    capabilities as a means to check for user privileges for these
    kinds of operations.

Other limitations:

  - PHY packet reception may be switched on by ioctl() but cannot be
    switched off again.  It would be trivial to provide an off switch,
    but this is not worth the code.  The client should simply close()
    the fd then, or just ignore further events.

  - For sake of simplicity of API and kernel-side implementation, no
    filter per packet content is provided.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c        |    1 +
 drivers/firewire/core-cdev.c        |   73 ++++++++++++++++++++++++++--
 drivers/firewire/core-transaction.c |    5 ++
 drivers/firewire/core.h             |    2 +
 drivers/firewire/ohci.c             |    3 -
 include/linux/firewire-cdev.h       |   39 ++++++++++++---
 include/linux/firewire.h            |    3 +
 7 files changed, 111 insertions(+), 15 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -514,6 +514,7 @@ void fw_card_initialize(struct fw_card *
 	kref_init(&card->kref);
 	init_completion(&card->done);
 	INIT_LIST_HEAD(&card->transaction_list);
+	INIT_LIST_HEAD(&card->phy_receiver_list);
 	spin_lock_init(&card->lock);
 
 	card->local_node = NULL;
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -70,6 +70,9 @@ struct client {
 	struct fw_iso_buffer buffer;
 	unsigned long vm_start;
 
+	struct list_head phy_receiver_link;
+	u64 phy_receiver_closure;
+
 	struct list_head link;
 	struct kref kref;
 };
@@ -202,6 +205,11 @@ struct outbound_phy_packet_event {
 	struct fw_cdev_event_phy_packet phy_packet;
 };
 
+struct inbound_phy_packet_event {
+	struct event event;
+	struct fw_cdev_event_phy_packet phy_packet;
+};
+
 static inline void __user *u64_to_uptr(__u64 value)
 {
 	return (void __user *)(unsigned long)value;
@@ -237,6 +245,7 @@ static int fw_device_op_open(struct inod
 	idr_init(&client->resource_idr);
 	INIT_LIST_HEAD(&client->event_list);
 	init_waitqueue_head(&client->wait);
+	INIT_LIST_HEAD(&client->phy_receiver_link);
 	kref_init(&client->kref);
 
 	file->private_data = client;
@@ -358,7 +367,7 @@ static void queue_bus_reset_event(struct
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL) {
-		fw_notify("Out of memory when allocating bus reset event\n");
+		fw_notify("Out of memory when allocating event\n");
 		return;
 	}
 
@@ -405,6 +414,7 @@ union ioctl_arg {
 	struct fw_cdev_send_stream_packet	send_stream_packet;
 	struct fw_cdev_get_cycle_timer2		get_cycle_timer2;
 	struct fw_cdev_send_phy_packet		send_phy_packet;
+	struct fw_cdev_receive_phy_packets	receive_phy_packets;
 };
 
 static int ioctl_get_info(struct client *client, union ioctl_arg *arg)
@@ -672,9 +682,10 @@ static void handle_request(struct fw_car
 
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
-	if (r == NULL || e == NULL)
+	if (r == NULL || e == NULL) {
+		fw_notify("Out of memory when allocating event\n");
 		goto failed;
-
+	}
 	r->card    = card;
 	r->request = request;
 	r->data    = payload;
@@ -903,9 +914,10 @@ static void iso_callback(struct fw_iso_c
 	struct iso_interrupt_event *e;
 
 	e = kmalloc(sizeof(*e) + header_length, GFP_ATOMIC);
-	if (e == NULL)
+	if (e == NULL) {
+		fw_notify("Out of memory when allocating event\n");
 		return;
-
+	}
 	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
 	e->interrupt.closure   = client->iso_closure;
 	e->interrupt.cycle     = cycle;
@@ -1448,6 +1460,52 @@ static int ioctl_send_phy_packet(struct 
 	return 0;
 }
 
+static int ioctl_receive_phy_packets(struct client *client, union ioctl_arg *arg)
+{
+	struct fw_cdev_receive_phy_packets *a = &arg->receive_phy_packets;
+	struct fw_card *card = client->device->card;
+
+	/* Access policy: Allow this ioctl only on local nodes' device files. */
+	if (!client->device->is_local)
+		return -ENOSYS;
+
+	spin_lock_irq(&card->lock);
+
+	list_move_tail(&client->phy_receiver_link, &card->phy_receiver_list);
+	client->phy_receiver_closure = a->closure;
+
+	spin_unlock_irq(&card->lock);
+
+	return 0;
+}
+
+void fw_cdev_handle_phy_packet(struct fw_card *card, struct fw_packet *p)
+{
+	struct client *client;
+	struct inbound_phy_packet_event *e;
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	list_for_each_entry(client, &card->phy_receiver_list, phy_receiver_link) {
+		e = kmalloc(sizeof(*e) + 8, GFP_ATOMIC);
+		if (e == NULL) {
+			fw_notify("Out of memory when allocating event\n");
+			break;
+		}
+		e->phy_packet.closure	= client->phy_receiver_closure;
+		e->phy_packet.type	= FW_CDEV_EVENT_PHY_PACKET_RECEIVED;
+		e->phy_packet.rcode	= RCODE_COMPLETE;
+		e->phy_packet.length	= 8;
+		e->phy_packet.data[0]	= p->header[1];
+		e->phy_packet.data[1]	= p->header[2];
+		queue_event(client, &e->event,
+			    &e->phy_packet, sizeof(e->phy_packet) + 8, NULL, 0);
+	}
+
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
 static int (* const ioctl_handlers[])(struct client *, union ioctl_arg *) = {
 	[0x00] = ioctl_get_info,
 	[0x01] = ioctl_send_request,
@@ -1471,6 +1529,7 @@ static int (* const ioctl_handlers[])(st
 	[0x13] = ioctl_send_stream_packet,
 	[0x14] = ioctl_get_cycle_timer2,
 	[0x15] = ioctl_send_phy_packet,
+	[0x16] = ioctl_receive_phy_packets,
 };
 
 static int dispatch_ioctl(struct client *client,
@@ -1578,6 +1637,10 @@ static int fw_device_op_release(struct i
 	struct client *client = file->private_data;
 	struct event *event, *next_event;
 
+	spin_lock_irq(&client->device->card->lock);
+	list_del(&client->phy_receiver_link);
+	spin_unlock_irq(&client->device->card->lock);
+
 	mutex_lock(&client->device->client_list_mutex);
 	list_del(&client->link);
 	mutex_unlock(&client->device->client_list_mutex);
Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -880,6 +880,11 @@ void fw_core_handle_request(struct fw_ca
 	if (p->ack != ACK_PENDING && p->ack != ACK_COMPLETE)
 		return;
 
+	if (TCODE_IS_LINK_INTERNAL(HEADER_GET_TCODE(p->header[0]))) {
+		fw_cdev_handle_phy_packet(card, p);
+		return;
+	}
+
 	request = allocate_request(card, p);
 	if (request == NULL) {
 		/* FIXME: send statically allocated busy packet. */
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -128,6 +128,7 @@ extern const struct file_operations fw_d
 
 void fw_device_cdev_update(struct fw_device *device);
 void fw_device_cdev_remove(struct fw_device *device);
+void fw_cdev_handle_phy_packet(struct fw_card *card, struct fw_packet *p);
 
 
 /* -device */
@@ -214,6 +215,7 @@ static inline bool is_next_generation(in
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
 #define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
+#define TCODE_IS_LINK_INTERNAL(tcode)	((tcode) == 0xe)
 #define TCODE_IS_REQUEST(tcode)		(((tcode) &  2) == 0)
 #define TCODE_IS_RESPONSE(tcode)	(((tcode) &  2) != 0)
 #define TCODE_HAS_REQUEST_DATA(tcode)	(((tcode) & 12) != 4)
Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1764,10 +1764,9 @@ static int ohci_enable(struct fw_card *c
 		  OHCI1394_HCControl_noByteSwapData);
 
 	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
-	reg_write(ohci, OHCI1394_LinkControlClear,
-		  OHCI1394_LinkControl_rcvPhyPkt);
 	reg_write(ohci, OHCI1394_LinkControlSet,
 		  OHCI1394_LinkControl_rcvSelfID |
+		  OHCI1394_LinkControl_rcvPhyPkt |
 		  OHCI1394_LinkControl_cycleTimerEnable |
 		  OHCI1394_LinkControl_cycleMaster);
 
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -40,6 +40,7 @@
 /* available since kernel version 2.6.36 */
 #define FW_CDEV_EVENT_REQUEST2			0x06
 #define FW_CDEV_EVENT_PHY_PACKET_SENT		0x07
+#define FW_CDEV_EVENT_PHY_PACKET_RECEIVED	0x08
 
 /**
  * struct fw_cdev_event_common - Common part of all fw_cdev_event_ types
@@ -290,16 +291,24 @@ struct fw_cdev_event_iso_resource {
 };
 
 /**
- * struct fw_cdev_event_phy_packet - A PHY packet was transmitted
- * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_IOC_SEND_PHY_PACKET ioctl
- * @type:	%FW_CDEV_EVENT_PHY_PACKET_SENT
+ * struct fw_cdev_event_phy_packet - A PHY packet was transmitted or received
+ * @closure:	See &fw_cdev_event_common; set by %FW_CDEV_IOC_SEND_PHY_PACKET
+ *		or %FW_CDEV_IOC_RECEIVE_PHY_PACKETS ioctl
+ * @type:	%FW_CDEV_EVENT_PHY_PACKET_SENT or %..._RECEIVED
  * @rcode:	%RCODE_..., indicates success or failure of transmission
+ * @length:	Data length in bytes
+ * @data:	Incoming data
+ *
+ * If @type is %FW_CDEV_EVENT_PHY_PACKET_SENT, @length is 0 and @data empty.
+ * If @type is %FW_CDEV_EVENT_PHY_PACKET_RECEIVED, @length is 8 and @data
+ * consists of the two PHY packet quadlets, in host byte order.
  */
 struct fw_cdev_event_phy_packet {
 	__u64 closure;
 	__u32 type;
 	__u32 rcode;
+	__u32 length;
+	__u32 data[0];
 };
 
 /**
@@ -313,7 +322,9 @@ struct fw_cdev_event_phy_packet {
  * @iso_resource:  Valid if @common.type ==
  *				%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
  *				%FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED
- * @phy_packet:    Valid if @common.type == %FW_CDEV_EVENT_PHY_PACKET_SENT
+ * @phy_packet:    Valid if @common.type ==
+ *				%FW_CDEV_EVENT_PHY_PACKET_SENT or
+ *				%FW_CDEV_EVENT_PHY_PACKET_RECEIVED
  *
  * Convenience union for userspace use.  Events could be read(2) into an
  * appropriately aligned char buffer and then cast to this union for further
@@ -365,6 +376,7 @@ union fw_cdev_event {
 
 /* available since kernel version 2.6.36 */
 #define FW_CDEV_IOC_SEND_PHY_PACKET    _IOWR('#', 0x15, struct fw_cdev_send_phy_packet)
+#define FW_CDEV_IOC_RECEIVE_PHY_PACKETS _IOW('#', 0x16, struct fw_cdev_receive_phy_packets)
 
 /*
  * ABI version history
@@ -381,9 +393,9 @@ union fw_cdev_event {
  *               - shared use and auto-response for FCP registers
  *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
  *               - added %FW_CDEV_IOC_GET_CYCLE_TIMER2
- *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2, %FW_CDEV_EVENT_PHY_PACKET_SENT
+ *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2, %FW_CDEV_EVENT_PHY_PACKET_*
  *               - implemented &fw_cdev_event_bus_reset.bm_node_id
- *               - added %FW_CDEV_IOC_SEND_PHY_PACKET
+ *               - added %FW_CDEV_IOC_SEND_PHY_PACKET, _RECEIVE_PHY_PACKETS
  */
 #define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
@@ -853,4 +865,17 @@ struct fw_cdev_send_phy_packet {
 	__u32 generation;
 };
 
+/**
+ * struct fw_cdev_receive_phy_packets - start reception of PHY packets
+ * @closure: Passed back to userspace in phy packet events
+ *
+ * This ioctl activates issuing of %FW_CDEV_EVENT_PHY_PACKET_RECEIVED due to
+ * incoming PHY packets from any node on the same bus as the device.
+ *
+ * The ioctl is only permitted on device files which represent a local node.
+ */
+struct fw_cdev_receive_phy_packets {
+	__u64 closure;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -111,9 +111,10 @@ struct fw_card {
 	bool beta_repeaters_present;
 
 	int index;
-
 	struct list_head link;
 
+	struct list_head phy_receiver_list;
+
 	struct delayed_work br_work; /* bus reset job */
 	bool br_short;
 

-- 
Stefan Richter
-=====-==-=- -=== =----
http://arcgraph.de/sr/

