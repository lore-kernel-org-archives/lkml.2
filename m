Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0GWLFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:05:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49419 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0GWLFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:05:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 23 Jul 2010 13:05:39 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH rfc] firewire: cdev: improve FW_CDEV_IOC_ALLOCATE
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.9a7c74143b0f179f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In both the ieee1394 stack and the firewire stack, the core treats
kernelspace drivers better than userspace drivers when it comes to
CSR address range allocation:  The former may request a register to be
placed automatically at a free spot anywhere inside a specified address
range.  The latter may only request a register at a fixed offset.

Hence, userspace drivers which do not require a fixed offset potentially
need to implement a retry loop with incremented offset in each retry
until the kernel does not fail allocation with EBUSY.  This awkward
procedure is not necessary as the core already provides a superior
allocation API to kernelspace drivers.

Therefore change the ioctl() ABI by addition of a region_end member in
the existing struct fw_cdev_allocate.

There is a small cost to pay by clients though:  If client source code
is required to compile with older kernel headers too, then any use of
the new member needs to be enclosed by #ifdef/#endif directives.
However, any client program that seriously wants to use address range
allocations will require a kernel of cdev ABI version >= 4 at runtime
and a linux/firewire-cdev.h header of >= 4 anyway.  This is because v4
brings FW_CDEV_EVENT_REQUEST2.  The only client program in which
build-time compatibility with struct fw_cdev_allocate as found in older
kernel headers makes sense is libraw1394.

(libraw1394 uses the older broken FW_CDEV_EVENT_REQUEST to implement a
makeshift, incorrect transaction responder that does at least work
somewhat in many simple scenarios, relying on guesswork by libraw1394
and by libraw1394 based applications.  Plus, address range allocation
and transaction responder is only one of many features that libraw1394
needs to provide, and these other features need to work with kernel and
kernel-headers as old as possible.  Any new linux/firewire-cdev.h based
client that implements a transaction responder should never attempt to
do it like libraw1394;  instead it should make a header and kernel of v4
or later a hard requirement.)

While we are at it, update the struct fw_cdev_allocate documentation to
better reflect the recent fw_cdev_event_request2 ABI addition.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

I posted libraw1394 a patch recently which lets it state to implement
ABI v4.  That libraw1394 patch and this kernel patch here require yet
another straightforward libraw1394 patch which I will post to
linux1394-devel right away.

 drivers/firewire/core-cdev.c  |   12 +++++++++---
 include/linux/firewire-cdev.h |   29 ++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 8 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -51,8 +51,9 @@
 /*
  * ABI version history is documented in linux/firewire-cdev.h.
  */
-#define FW_CDEV_KERNEL_VERSION		4
-#define FW_CDEV_VERSION_EVENT_REQUEST2	4
+#define FW_CDEV_KERNEL_VERSION			4
+#define FW_CDEV_VERSION_EVENT_REQUEST2		4
+#define FW_CDEV_VERSION_ALLOCATE_REGION_END	4
 
 struct client {
 	u32 version;
@@ -774,7 +775,11 @@ static int ioctl_allocate(struct client 
 		return -ENOMEM;
 
 	region.start = a->offset;
-	region.end   = a->offset + a->length;
+	if (client->version < FW_CDEV_VERSION_ALLOCATE_REGION_END)
+		region.end = a->offset + a->length;
+	else
+		region.end = a->region_end;
+
 	r->handler.length           = a->length;
 	r->handler.address_callback = handle_request;
 	r->handler.callback_data    = r;
@@ -786,6 +791,7 @@ static int ioctl_allocate(struct client 
 		kfree(r);
 		return ret;
 	}
+	a->offset = r->handler.offset;
 
 	r->resource.release = release_address_handler;
 	ret = add_client_resource(client, &r->resource, GFP_KERNEL);
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -399,6 +399,7 @@ union fw_cdev_event {
  *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2, %FW_CDEV_EVENT_PHY_PACKET_*
  *               - implemented &fw_cdev_event_bus_reset.bm_node_id
  *               - added %FW_CDEV_IOC_SEND_PHY_PACKET, _RECEIVE_PHY_PACKETS
+ *               - added &fw_cdev_allocate.region_end
  */
 #define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
@@ -478,17 +479,21 @@ struct fw_cdev_send_response {
 };
 
 /**
- * struct fw_cdev_allocate - Allocate a CSR address range
+ * struct fw_cdev_allocate - Allocate a CSR in an address range
  * @offset:	Start offset of the address range
  * @closure:	To be passed back to userspace in request events
- * @length:	Length of the address range, in bytes
+ * @length:	Length of the CSR, in bytes
  * @handle:	Handle to the allocation, written by the kernel
+ * @region_end:	First address above the address range (added in ABI v4, 2.6.36)
  *
  * Allocate an address range in the 48-bit address space on the local node
  * (the controller).  This allows userspace to listen for requests with an
- * offset within that address range.  When the kernel receives a request
- * within the range, an &fw_cdev_event_request event will be written back.
- * The @closure field is passed back to userspace in the response event.
+ * offset within that address range.  Every time when the kernel receives a
+ * request within the range, an &fw_cdev_event_request2 event will be emitted.
+ * (If the kernel or the client implements ABI version <= 3, an
+ * &fw_cdev_event_request will be generated instead.)
+ *
+ * The @closure field is passed back to userspace in these request events.
  * The @handle field is an out parameter, returning a handle to the allocated
  * range to be used for later deallocation of the range.
  *
@@ -496,12 +501,26 @@ struct fw_cdev_send_response {
  * is exclusive except for the FCP command and response registers.  If an
  * exclusive address region is already in use, the ioctl fails with errno set
  * to %EBUSY.
+ *
+ * If kernel and client implement ABI version >= 4, the kernel looks up a free
+ * spot of size @length inside [@offset..@region_end) and, if found, writes
+ * the start address of the new CSR back in @offset.  I.e. @offset is an
+ * in and out parameter.  If this automatic placement of a CSR in a bigger
+ * address range is not desired, the client simply needs to set @region_end
+ * = @offset + @length.
+ *
+ * If the kernel or the client implements ABI version <= 3, @region_end is
+ * ignored and effectively assumed to be @offset + @length.
+ *
+ * @region_end is only present in a kernel header >= 2.6.36.  If necessary,
+ * this can for example be tested by #ifdef FW_CDEV_EVENT_REQUEST2.
  */
 struct fw_cdev_allocate {
 	__u64 offset;
 	__u64 closure;
 	__u32 length;
 	__u32 handle;
+	__u64 region_end;	/* available since kernel version 2.6.36 */
 };
 
 /**

-- 
Stefan Richter
-=====-==-=- -=== =-===
http://arcgraph.de/sr/

