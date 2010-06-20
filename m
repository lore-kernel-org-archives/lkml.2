Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0FTUxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:53:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51918 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab0FTUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:53:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:52:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/8] firewire: cdev: freeze FW_CDEV_VERSION due to libraw1394
 bug
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.76e78b3888692346@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libraw1394 v2.0.0...v2.0.5 takes FW_CDEV_VERSION from an externally
installed header file and uses it to declare its own implementation
level in FW_CDEV_IOC_GET_INFO.  This is wrong; it should set the real
version for which it was actually written.

If we add features to the kernel ABI that require the kernel to check
a client's implementation level, we can not trust the client version if
it was set from FW_CDEV_VERSION.

Hence freeze FW_CDEV_VERSION at the current value (no damage has been
done yet), clearly document FW_CDEV_VERSION as a dummy version and what
clients are expected to do with fw_cdev_get_info.version, and use a new
defined constant (which is not placed into the exported header file) as
kernel implementation level.

Note, in order to check in client program source code which features are
present in an externally installed linux/firewire-cdev.h, use
preprocessor directives like
  #ifdef FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE
or
  #ifdef FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED
instead of a check of FW_CDEV_VERSION.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c  |    7 ++++++-
 include/linux/firewire-cdev.h |   22 ++++++++++++++++------
 2 files changed, 22 insertions(+), 7 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -47,6 +47,11 @@
 
 #include "core.h"
 
+/*
+ * ABI version history is documented in linux/firewire-cdev.h.
+ */
+#define FW_CDEV_KERNEL_VERSION 3
+
 struct client {
 	u32 version;
 	struct fw_device *device;
@@ -396,7 +401,7 @@ static int ioctl_get_info(struct client 
 	unsigned long ret = 0;
 
 	client->version = a->version;
-	a->version = FW_CDEV_VERSION;
+	a->version = FW_CDEV_KERNEL_VERSION;
 	a->card = client->device->card->index;
 
 	down_read(&fw_device_rwsem);
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -224,7 +224,7 @@ union fw_cdev_event {
 	struct fw_cdev_event_response		response;
 	struct fw_cdev_event_request		request;
 	struct fw_cdev_event_iso_interrupt	iso_interrupt;
-	struct fw_cdev_event_iso_resource	iso_resource;
+	struct fw_cdev_event_iso_resource	iso_resource; /* added in 2.6.30 */
 };
 
 /* available since kernel version 2.6.22 */
@@ -257,22 +257,32 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_GET_CYCLE_TIMER2   _IOWR('#', 0x14, struct fw_cdev_get_cycle_timer2)
 
 /*
- * FW_CDEV_VERSION History
+ * ABI version history
  *  1  (2.6.22)  - initial version
+ *     (2.6.24)  - added %FW_CDEV_IOC_GET_CYCLE_TIMER
  *  2  (2.6.30)  - changed &fw_cdev_event_iso_interrupt.header if
  *                 &fw_cdev_create_iso_context.header_size is 8 or more
+ *               - added %FW_CDEV_IOC_*_ISO_RESOURCE*,
+ *                 %FW_CDEV_IOC_GET_SPEED, %FW_CDEV_IOC_SEND_BROADCAST_REQUEST,
+ *                 %FW_CDEV_IOC_SEND_STREAM_PACKET
  *     (2.6.32)  - added time stamp to xmit &fw_cdev_event_iso_interrupt
  *     (2.6.33)  - IR has always packet-per-buffer semantics now, not one of
  *                 dual-buffer or packet-per-buffer depending on hardware
  *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
+ *               - added %FW_CDEV_IOC_GET_CYCLE_TIMER2
  */
-#define FW_CDEV_VERSION 3
+#define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
 /**
  * struct fw_cdev_get_info - General purpose information ioctl
- * @version:	The version field is just a running serial number.
- *		We never break backwards compatibility, but may add more
- *		structs and ioctls in later revisions.
+ * @version:	The version field is just a running serial number.  Both an
+ *		input parameter (ABI version implemented by the client) and
+ *		output parameter (ABI version implemented by the kernel).
+ *		A client must not fill in an %FW_CDEV_VERSION defined from an
+ *		included kernel header file but the actual version for which
+ *		the client was implemented.  This is necessary for forward
+ *		compatibility.  We never break backwards compatibility, but
+ *		may add more structs, events, and ioctls in later revisions.
  * @rom_length:	If @rom is non-zero, at most rom_length bytes of configuration
  *		ROM will be copied into that user space address.  In either
  *		case, @rom_length is updated with the actual length of the

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

