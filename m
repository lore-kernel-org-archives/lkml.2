Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab0GPUYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:24:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57987 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab0GPUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:24:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Jul 2010 22:24:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firewire: cdev: some clarifications to the API
 documentation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
Message-ID: <tkrat.38c8fc1ec31d405c@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Response events:
  - are generated on more occasions than their documentation claimed.

Bus resets:
  - Note that FW_CDEV_IOC_INITIATE_BUS_RESET is nonblocking and that the
    client is not required to observe a grace period since kernels
    2.6.36+ will enforce it now (commit 02d37bed).

  - The possible values of fw_cdev_initiate_bus_reset.type are listed in
    the kerneldoc comment already.

  - Clarify that an application that uses FW_CDEV_IOC_ADD_DESCRIPTOR and
    FW_CDEV_IOC_REMOVE_DESCRIPTOR does not have to issue a bus reset.

Isochronous I/O contexts:
  - At most one can be created per open file descriptor.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -89,8 +89,9 @@ struct fw_cdev_event_bus_reset {
 
 /**
  * struct fw_cdev_event_response - Sent when a response packet was received
- * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_IOC_SEND_REQUEST ioctl
+ * @closure:	See &fw_cdev_event_common; set by %FW_CDEV_IOC_SEND_REQUEST
+ *		or %FW_CDEV_IOC_SEND_BROADCAST_REQUEST
+ *		or %FW_CDEV_IOC_SEND_STREAM_PACKET ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_RESPONSE
  * @rcode:	Response code returned by the remote node
  * @length:	Data length, i.e. the response's payload size in bytes
@@ -100,6 +101,11 @@ struct fw_cdev_event_bus_reset {
  * sent by %FW_CDEV_IOC_SEND_REQUEST ioctl.  The payload data for responses
  * carrying data (read and lock responses) follows immediately and can be
  * accessed through the @data field.
+ *
+ * The event is also generated after conclusions of transactions that do not
+ * involve response packets.  This includes unified write transactions,
+ * broadcast write transactions, and transmission of asynchronous stream
+ * packets.  @rcode indicates success or failure of such transmissions.
  */
 struct fw_cdev_event_response {
 	__u64 closure;
@@ -480,9 +486,14 @@ struct fw_cdev_deallocate {
  * Initiate a bus reset for the bus this device is on.  The bus reset can be
  * either the original (long) bus reset or the arbitrated (short) bus reset
  * introduced in 1394a-2000.
+ *
+ * The ioctl returns immediately.  A subsequent &fw_cdev_event_bus_reset
+ * indicates when the reset actually happened.  Since ABI v4, this may be
+ * considerably later than the ioctl because the kernel ensures a grace period
+ * between subsequent bus resets as per IEEE 1394 bus management specification.
  */
 struct fw_cdev_initiate_bus_reset {
-	__u32 type;	/* FW_CDEV_SHORT_RESET or FW_CDEV_LONG_RESET */
+	__u32 type;
 };
 
 /**
@@ -506,9 +517,10 @@ struct fw_cdev_initiate_bus_reset {
  *
  * @immediate, @key, and @data array elements are CPU-endian quadlets.
  *
- * If successful, the kernel adds the descriptor and writes back a handle to the
- * kernel-side object to be used for later removal of the descriptor block and
- * immediate key.
+ * If successful, the kernel adds the descriptor and writes back a @handle to
+ * the kernel-side object to be used for later removal of the descriptor block
+ * and immediate key.  The kernel will also generate a bus reset to signal the
+ * change of the configuration ROM to other nodes.
  *
  * This ioctl affects the configuration ROMs of all local nodes.
  * The ioctl only succeeds on device files which represent a local node.
@@ -527,7 +539,8 @@ struct fw_cdev_add_descriptor {
  *		descriptor was added
  *
  * Remove a descriptor block and accompanying immediate key from the local
- * nodes' configuration ROMs.
+ * nodes' configuration ROMs.  The kernel will also generate a bus reset to
+ * signal the change of the configuration ROM to other nodes.
  */
 struct fw_cdev_remove_descriptor {
 	__u32 handle;
@@ -559,6 +572,8 @@ struct fw_cdev_remove_descriptor {
  *
  * Note that the effect of a @header_size > 4 depends on
  * &fw_cdev_get_info.version, as documented at &fw_cdev_event_iso_interrupt.
+ *
+ * No more than one iso context can be created per fd.
  */
 struct fw_cdev_create_iso_context {
 	__u32 type;

-- 
Stefan Richter
-=====-==-=- -=== =----
http://arcgraph.de/sr/

