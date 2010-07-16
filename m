Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab0GPU3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:29:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58013 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192Ab0GPU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:29:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Jul 2010 22:28:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH libraw1394] Implement raw1394_(start_)phy_packet_write() on
 new firewire backend
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
Message-ID: <tkrat.918a88e710ebb6ce@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requires kernel 2.6.36 or newer at runtime and linux-headers 2.6.36 or newer
at build time.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 src/dispatch.c |    2 +-
 src/fw.c       |   91 +++++++++++++++++++++++++++++++++++++++++++++++--------
 src/fw.h       |    6 ++--
 3 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/src/dispatch.c b/src/dispatch.c
index c6ff332..04fbad6 100644
--- a/src/dispatch.c
+++ b/src/dispatch.c
@@ -287,7 +287,7 @@ int raw1394_phy_packet_write (raw1394handle_t handle, quadlet_t data)
 		return -1;
 	}
 	if (handle->is_fw)
-		return fw_phy_packet_write(handle->mode.fw, data);
+		return fw_phy_packet_write(handle, data);
 	else
 		return ieee1394_phy_packet_write(handle, data);
 }
diff --git a/src/fw.c b/src/fw.c
index b1f12c9..bfe1e5e 100644
--- a/src/fw.c
+++ b/src/fw.c
@@ -340,6 +340,16 @@ handle_device_event(raw1394handle_t handle,
 		       sizeof u->iso_resource);
 		return 0;
 #endif
+
+#ifdef FW_CDEV_EVENT_PHY_PACKET_SENT /* added in kernel 2.6.36 */
+	case FW_CDEV_EVENT_PHY_PACKET_SENT:
+		rc = u64_to_ptr(u->phy_packet.closure);
+		errcode = fw_to_raw1394_errcode(u->phy_packet.rcode);
+		tag = rc->tag;
+		free(rc);
+
+		return fwhandle->tag_handler(handle, tag, errcode);
+#endif
 	default:
 	case FW_CDEV_EVENT_ISO_INTERRUPT:
 		/* Never happens. */
@@ -985,20 +995,6 @@ int fw_wake_up(fw_handle_t handle)
 	return fw_echo_request(handle, 0);
 }
 
-int fw_phy_packet_write (fw_handle_t handle, quadlet_t data)
-{
-	errno = ENOSYS;
-	return -1;
-}
-
-int
-fw_start_phy_packet_write(fw_handle_t handle,
-			       quadlet_t data, unsigned long tag)
-{
-	errno = ENOSYS;
-	return -1;
-}
-
 static int
 send_request(fw_handle_t handle, int tcode,
 	     nodeid_t node, nodeaddr_t addr,
@@ -1220,6 +1216,47 @@ fw_start_async_stream(fw_handle_t handle, unsigned int channel,
 			    0, addr, length, data, 0, NULL, rawtag);
 }
 
+int
+fw_start_phy_packet_write(fw_handle_t handle, quadlet_t data, unsigned long tag)
+{
+#ifdef FW_CDEV_IOC_SEND_PHY_PACKET /* added in kernel 2.6.36 */
+	struct fw_cdev_send_phy_packet send_phy_packet;
+	struct request_closure *closure;
+	int retval;
+
+	if (handle->local_device == NULL) {
+		handle->err = -EPERM;
+		errno = EPERM;
+		return -1;
+	}
+
+	closure = malloc(sizeof *closure);
+	if (closure == NULL) {
+		handle->err = -RCODE_SEND_ERROR;
+		errno = fw_errcode_to_errno(handle->err);
+		return -1;
+	}
+
+	closure->data   = NULL;
+	closure->length = 0;
+	closure->tag    = tag;
+
+	send_phy_packet.closure    = ptr_to_u64(closure);
+	send_phy_packet.data[0]    =  be32_to_cpu(data);
+	send_phy_packet.data[1]    = ~be32_to_cpu(data);
+	send_phy_packet.generation = handle->local_device->generation;
+	retval = ioctl(handle->local_device->fd, FW_CDEV_IOC_SEND_PHY_PACKET,
+		       &send_phy_packet);
+	if (retval < 0)
+		free(closure);
+
+	return retval;
+#else
+	errno = ENOSYS;
+	handle->err = -errno;
+	return -1;
+#endif
+}
 
 int
 fw_start_async_send(fw_handle_t handle,
@@ -1356,6 +1393,32 @@ fw_async_stream(raw1394handle_t handle, unsigned int channel,
 }
 
 int
+fw_phy_packet_write(raw1394handle_t handle, quadlet_t data)
+{
+	fw_handle_t fwhandle = handle->mode.fw;
+	struct raw1394_reqhandle reqhandle;
+	struct sync_data sd = { 0, 0 };
+	int err;
+
+	reqhandle.callback = sync_callback;
+	reqhandle.data = &sd;
+
+	err = fw_start_phy_packet_write(fwhandle, data,
+					(unsigned long) &reqhandle);
+
+	while (!sd.done) {
+		if (err < 0)
+			return err;
+		err = fw_loop_iterate(handle);
+	}
+
+	fwhandle->err = sd.err;
+	errno = fw_errcode_to_errno(sd.err);
+
+	return (errno ? -1 : 0);
+}
+
+int
 fw_async_send(fw_handle_t handle,
 		   size_t length, size_t header_length,
 		   unsigned int expect_response,
diff --git a/src/fw.h b/src/fw.h
index b0ff169..bc374d5 100644
--- a/src/fw.h
+++ b/src/fw.h
@@ -159,9 +159,6 @@ int fw_arm_get_buf(fw_handle_t handle, nodeaddr_t start,
 		   size_t length, void *buf);
 int fw_echo_request(fw_handle_t handle, quadlet_t data);
 int fw_wake_up(fw_handle_t handle);
-int fw_phy_packet_write (fw_handle_t handle, quadlet_t data);
-int fw_start_phy_packet_write(fw_handle_t handle,
-		   quadlet_t data, unsigned long tag);
 int fw_start_read(fw_handle_t handle, nodeid_t node, nodeaddr_t addr,
 		   size_t length, quadlet_t *buffer, unsigned long tag);
 int fw_start_write(fw_handle_t handle, nodeid_t node, nodeaddr_t addr,
@@ -176,6 +173,8 @@ int fw_start_async_stream(fw_handle_t handle, unsigned int channel,
 		   unsigned int tag, unsigned int sy,
 		   unsigned int speed, size_t length, quadlet_t *data,
 		   unsigned long rawtag);
+int fw_start_phy_packet_write(fw_handle_t handle,
+		   quadlet_t data, unsigned long tag);
 int fw_start_async_send(fw_handle_t handle,
 		   size_t length, size_t header_length,
 		   unsigned int expect_response,
@@ -193,6 +192,7 @@ int fw_lock64(raw1394handle_t handle, nodeid_t node, nodeaddr_t addr,
 int fw_async_stream(raw1394handle_t handle, unsigned int channel,
 		   unsigned int tag, unsigned int sy, unsigned int speed,
 		   size_t length, quadlet_t *data);
+int fw_phy_packet_write(raw1394handle_t handle, quadlet_t data);
 int fw_async_send(fw_handle_t handle,
 		   size_t length, size_t header_length,
 		   unsigned int expect_response,
-- 
1.7.1


-- 
Stefan Richter
-=====-==-=- -=== =----
http://arcgraph.de/sr/

