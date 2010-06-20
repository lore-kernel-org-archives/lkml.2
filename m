Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0FTUys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:54:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51926 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab0FTUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:54:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:53:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 7/8] firewire: cdev: fix ABI for FCP and address range
 mapping, add fw_cdev_event_request2
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.94c433133b5c4de5@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem:

A target-like userspace driver, e.g. AV/C target or SBP-2/3 target,
needs to be able to act as responder and requester.  In the latter role,
it needs to send requests to nods from which it received requests.  This
is currently impossible because fw_cdev_event_request lacks information
about sender node ID.
Reported-by: Jay Fenlason <fenlason@redhat.com>

Libffado + libraw1394 + firewire-core is currently unable to drive two
or more audio devices on the same bus.
Reported-by: Arnold Krille <arnold@arnoldarts.de>

This is because libffado requires destination node ID of FCP requests
and sender node ID of FCP responses to match.  It even prohibits
libffado from working with a bus on which libraw1394 opens a /dev/fw* as
default ioctl device that does not correspond with the audio device.
This is because libraw1394 does not receive the sender node ID from the
kernel.

Moreover, fw_cdev_event_request makes it impossible to tell unicast and
broadcast write requests apart.

The fix:

Add a replacement of struct fw_cdev_event_request request, boringly
called struct fw_cdev_event_request2.  The new event will be sent to a
userspace client instead of the old one if the client claims
compatibility with <linux/firewire-cdev.h> ABI version 4 or later.

libraw1394 needs to be extended to make use of the new event, in order
to properly support libffado and other FCP or address range mapping
users who require correct sender node IDs.

Further notes:

While we are at it, change back the range of possible values of
fw_cdev_event_request.tcode to 0x0...0xb like in ABI version <= 3.
The preceding change "firewire: expose extended tcode of incoming lock
requests to (userspace) drivers" expanded it to 0x0...0x17 which could
catch sloppily coded clients by surprise.  The extended range of codes
is only used in the new fw_cdev_event_request2.tcode.

Jay and I also suggested an alternative approach to fix the ABI for
incoming requests:  Add an FW_CDEV_IOC_GET_REQUEST_INFO ioctl which can
be called after reception of an fw_cdev_event_request, before issuing of
the closing FW_CDEV_IOC_SEND_RESPONSE ioctl.  The new ioctl would reveal
the vital information about a request that fw_cdev_event_request lacks.
Jay showed an implementation of this approach.

The former event approach adds 27 LOC of rather trivial code to
core-cdev.c, the ioctl approach 34 LOC, some of which is nontrivial.
The ioctl approach would certainly also add more LOC to userspace
programs which require the expanded information on inbound requests.
This approach is probably only on the lighter-weight side in case of
clients that want to be compatible with kernels that lack the new
capability, like libraw1394.  However, the code to be added to such
libraw1394-like clients in case of the event approach is a straight-
forward additional switch () case in its event handler.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c  |   45 ++++++++++++++++----
 include/linux/firewire-cdev.h |   76 +++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 11 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -50,7 +50,8 @@
 /*
  * ABI version history is documented in linux/firewire-cdev.h.
  */
-#define FW_CDEV_KERNEL_VERSION 3
+#define FW_CDEV_KERNEL_VERSION		4
+#define FW_CDEV_VERSION_EVENT_REQUEST2	4
 
 struct client {
 	u32 version;
@@ -177,7 +178,10 @@ struct outbound_transaction_event {
 
 struct inbound_transaction_event {
 	struct event event;
-	struct fw_cdev_event_request request;
+	union {
+		struct fw_cdev_event_request request;
+		struct fw_cdev_event_request2 request2;
+	} req;
 };
 
 struct iso_interrupt_event {
@@ -646,6 +650,7 @@ static void handle_request(struct fw_car
 	struct address_handler_resource *handler = callback_data;
 	struct inbound_transaction_resource *r;
 	struct inbound_transaction_event *e;
+	size_t event_size0;
 	void *fcp_frame = NULL;
 	int ret;
 
@@ -679,15 +684,37 @@ static void handle_request(struct fw_car
 	if (ret < 0)
 		goto failed;
 
-	e->request.type    = FW_CDEV_EVENT_REQUEST;
-	e->request.tcode   = tcode;
-	e->request.offset  = offset;
-	e->request.length  = length;
-	e->request.handle  = r->resource.handle;
-	e->request.closure = handler->closure;
+	if (handler->client->version < FW_CDEV_VERSION_EVENT_REQUEST2) {
+		struct fw_cdev_event_request *req = &e->req.request;
+
+		if (tcode & 0x10)
+			tcode = TCODE_LOCK_REQUEST;
+
+		req->type	= FW_CDEV_EVENT_REQUEST;
+		req->tcode	= tcode;
+		req->offset	= offset;
+		req->length	= length;
+		req->handle	= r->resource.handle;
+		req->closure	= handler->closure;
+		event_size0	= sizeof(*req);
+	} else {
+		struct fw_cdev_event_request2 *req = &e->req.request2;
+
+		req->type	= FW_CDEV_EVENT_REQUEST2;
+		req->tcode	= tcode;
+		req->offset	= offset;
+		req->source_node_id = source;
+		req->destination_node_id = destination;
+		req->card	= card->index;
+		req->generation	= generation;
+		req->length	= length;
+		req->handle	= r->resource.handle;
+		req->closure	= handler->closure;
+		event_size0	= sizeof(*req);
+	}
 
 	queue_event(handler->client, &e->event,
-		    &e->request, sizeof(e->request), r->data, length);
+		    &e->req, event_size0, r->data, length);
 	return;
 
  failed:
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -37,6 +37,9 @@
 #define FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED	0x04
 #define FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED	0x05
 
+/* available since kernel version 2.6.36 */
+#define FW_CDEV_EVENT_REQUEST2			0x06
+
 /**
  * struct fw_cdev_event_common - Common part of all fw_cdev_event_ types
  * @closure:	For arbitrary use by userspace
@@ -103,11 +106,46 @@ struct fw_cdev_event_response {
 };
 
 /**
- * struct fw_cdev_event_request - Sent on incoming request to an address region
+ * struct fw_cdev_event_request - Old version of &fw_cdev_event_request2
  * @closure:	See &fw_cdev_event_common; set by %FW_CDEV_IOC_ALLOCATE ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_REQUEST
+ * @tcode:	See &fw_cdev_event_request2
+ * @offset:	See &fw_cdev_event_request2
+ * @handle:	See &fw_cdev_event_request2
+ * @length:	See &fw_cdev_event_request2
+ * @data:	See &fw_cdev_event_request2
+ *
+ * This event is sent instead of &fw_cdev_event_request2 if the kernel or
+ * the client implements ABI version <= 3.
+ *
+ * Unlike &fw_cdev_event_request2, the sender identity cannot be established,
+ * broadcast write requests cannot be distinguished from unicast writes, and
+ * @tcode of lock requests is %TCODE_LOCK_REQUEST.
+ *
+ * Requests to the FCP_REQUEST or FCP_RESPONSE register are responded to as
+ * with &fw_cdev_event_request2, except in kernel 2.6.32 and older which send
+ * the response packet of the client's %FW_CDEV_IOC_SEND_RESPONSE ioctl.
+ */
+struct fw_cdev_event_request {
+	__u64 closure;
+	__u32 type;
+	__u32 tcode;
+	__u64 offset;
+	__u32 handle;
+	__u32 length;
+	__u32 data[0];
+};
+
+/**
+ * struct fw_cdev_event_request2 - Sent on incoming request to an address region
+ * @closure:	See &fw_cdev_event_common; set by %FW_CDEV_IOC_ALLOCATE ioctl
+ * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_REQUEST2
  * @tcode:	Transaction code of the incoming request
  * @offset:	The offset into the 48-bit per-node address space
+ * @source_node_id: Sender node ID
+ * @destination_node_id: Destination node ID
+ * @card:	The index of the card from which the request came
+ * @generation:	Bus generation in which the request is valid
  * @handle:	Reference to the kernel-side pending request
  * @length:	Data length, i.e. the request's payload size in bytes
  * @data:	Incoming data, if any
@@ -120,12 +158,42 @@ struct fw_cdev_event_response {
  *
  * The payload data for requests carrying data (write and lock requests)
  * follows immediately and can be accessed through the @data field.
+ *
+ * Unlike &fw_cdev_event_request, @tcode of lock requests is one of the
+ * firewire-core specific %TCODE_LOCK_MASK_SWAP...%TCODE_LOCK_VENDOR_DEPENDENT,
+ * i.e. encodes the extended transaction code.
+ *
+ * @card may differ from &fw_cdev_get_info.card because requests are received
+ * from all cards of the Linux host.  @source_node_id, @destination_node_id, and
+ * @generation pertain to that card.  Destination node ID and bus generation may
+ * therefore differ from the corresponding fields of the last
+ * &fw_cdev_event_bus_reset.
+ *
+ * @destination_node_id may also differ from the current node ID because of a
+ * non-local bus ID part or in case of a broadcast write request.  Note, a
+ * client must call an %FW_CDEV_IOC_SEND_RESPONSE ioctl even in case of a
+ * broadcast write request; the kernel will then release the kernel-side pending
+ * request but will not actually send a response packet.
+ *
+ * In case of a write request to FCP_REQUEST or FCP_RESPONSE, the kernel already
+ * sent a write response immediately after the request was received; in this
+ * case the client must still call an %FW_CDEV_IOC_SEND_RESPONSE ioctl to
+ * release the kernel-side pending request, though another response won't be
+ * sent.
+ *
+ * If the client subsequently needs to initiate requests to the sender node of
+ * an &fw_cdev_event_request2, it needs to use a device file with matching
+ * card index, node ID, and generation for outbound requests.
  */
-struct fw_cdev_event_request {
+struct fw_cdev_event_request2 {
 	__u64 closure;
 	__u32 type;
 	__u32 tcode;
 	__u64 offset;
+	__u32 source_node_id;
+	__u32 destination_node_id;
+	__u32 card;
+	__u32 generation;
 	__u32 handle;
 	__u32 length;
 	__u32 data[0];
@@ -205,6 +273,7 @@ struct fw_cdev_event_iso_resource {
  * @bus_reset:     Valid if @common.type == %FW_CDEV_EVENT_BUS_RESET
  * @response:      Valid if @common.type == %FW_CDEV_EVENT_RESPONSE
  * @request:       Valid if @common.type == %FW_CDEV_EVENT_REQUEST
+ * @request2:      Valid if @common.type == %FW_CDEV_EVENT_REQUEST2
  * @iso_interrupt: Valid if @common.type == %FW_CDEV_EVENT_ISO_INTERRUPT
  * @iso_resource:  Valid if @common.type ==
  *				%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
@@ -223,6 +292,7 @@ union fw_cdev_event {
 	struct fw_cdev_event_bus_reset		bus_reset;
 	struct fw_cdev_event_response		response;
 	struct fw_cdev_event_request		request;
+	struct fw_cdev_event_request2		request2;     /* added in 2.6.36 */
 	struct fw_cdev_event_iso_interrupt	iso_interrupt;
 	struct fw_cdev_event_iso_resource	iso_resource; /* added in 2.6.30 */
 };
@@ -268,8 +338,10 @@ union fw_cdev_event {
  *     (2.6.32)  - added time stamp to xmit &fw_cdev_event_iso_interrupt
  *     (2.6.33)  - IR has always packet-per-buffer semantics now, not one of
  *                 dual-buffer or packet-per-buffer depending on hardware
+ *               - shared use and auto-response for FCP registers
  *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
  *               - added %FW_CDEV_IOC_GET_CYCLE_TIMER2
+ *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2
  */
 #define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

