Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344Ab1ETFxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:53:42 -0400
Received: from qmta14.westchester.pa.mail.comcast.net ([76.96.59.212]:43680
	"EHLO qmta14.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934448Ab1ETFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:53:40 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 08/12] staging: usbip: usbip_common.h: reorganize and document request headers
Date: Thu, 19 May 2011 21:37:02 -0700
Message-Id: <e7dc06e3e829e8aebe0129ef1f6108158dabaf09.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the request header structures; move #defines out of the
structures; organize function declarations by source file; and move
inline functions to the end of file.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/usbip_common.h |  236 +++++++++++++++++-----------------
 1 files changed, 121 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 83f8c1e..074ac42 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -104,111 +104,110 @@ extern struct device_attribute dev_attr_usbip_debug;
 	usbip_dbg_with_flag(usbip_debug_stub_tx, fmt , ##args)
 
 /*
- * USB/IP request headers.
- * Currently, we define 4 request types:
+ * USB/IP request headers
  *
- *  - CMD_SUBMIT transfers a USB request, corresponding to usb_submit_urb().
- *    (client to server)
- *  - RET_RETURN transfers the result of CMD_SUBMIT.
- *    (server to client)
- *  - CMD_UNLINK transfers an unlink request of a pending USB request.
+ * Each request is transferred across the network to its counterpart, which
+ * facilitates the normal USB communication. The values contained in the headers
+ * are basically the same as in a URB. Currently, four request types are
+ * defined:
+ *
+ *  - USBIP_CMD_SUBMIT: a USB request block, corresponds to usb_submit_urb()
  *    (client to server)
- *  - RET_UNLINK transfers the result of CMD_UNLINK.
+ *
+ *  - USBIP_RET_SUBMIT: the result of USBIP_CMD_SUBMIT
  *    (server to client)
  *
- * Note: The below request formats are based on the USB subsystem of Linux. Its
- * details will be defined when other implementations come.
+ *  - USBIP_CMD_UNLINK: an unlink request of a pending USBIP_CMD_SUBMIT,
+ *    corresponds to usb_unlink_urb()
+ *    (client to server)
  *
+ *  - USBIP_RET_UNLINK: the result of USBIP_CMD_UNLINK
+ *    (server to client)
  *
  */
+#define USBIP_CMD_SUBMIT	0x0001
+#define USBIP_RET_SUBMIT	0x0002
+#define USBIP_CMD_UNLINK	0x0003
+#define USBIP_RET_UNLINK	0x0004
 
-/*
- * A basic header followed by other additional headers.
+#define USBIP_DIR_IN	0x00
+#define USBIP_DIR_OUT	0x01
+
+/**
+ * struct usbip_header_basic - data pertinent to every request
+ * @command: the usbip request type
+ * @seqnum: sequential number that identifies requests; incremented per
+ *	    connection
+ * @devid: specifies a remote USB device uniquely instead of busnum and devnum;
+ *	   in the stub driver, this value is ((busnum << 16) | devnum)
+ * @direction: direction of the transfer
+ * @ep: endpoint number
  */
 struct usbip_header_basic {
-#define USBIP_CMD_SUBMIT	0x0001
-#define USBIP_CMD_UNLINK	0x0002
-#define USBIP_RET_SUBMIT	0x0003
-#define USBIP_RET_UNLINK	0x0004
 	__u32 command;
-
-	 /* sequential number which identifies requests.
-	  * incremented per connections */
 	__u32 seqnum;
-
-	/* devid is used to specify a remote USB device uniquely instead
-	 * of busnum and devnum in Linux. In the case of Linux stub_driver,
-	 * this value is ((busnum << 16) | devnum) */
 	__u32 devid;
-
-#define USBIP_DIR_OUT	0
-#define USBIP_DIR_IN	1
 	__u32 direction;
-	__u32 ep;     /* endpoint number */
+	__u32 ep;
 } __packed;
 
-/*
- * An additional header for a CMD_SUBMIT packet.
+/**
+ * struct usbip_header_cmd_submit - USBIP_CMD_SUBMIT packet header
+ * @transfer_flags: URB flags
+ * @transfer_buffer_length: the data size for (in) or (out) transfer
+ * @start_frame: initial frame for isochronous or interrupt transfers
+ * @number_of_packets: number of isochronous packets
+ * @interval: maximum time for the request on the server-side host controller
+ * @setup: setup data for a control request
  */
 struct usbip_header_cmd_submit {
-	/* these values are basically the same as in a URB. */
-
-	/* the same in a URB. */
 	__u32 transfer_flags;
-
-	/* set the following data size (out),
-	 * or expected reading data size (in) */
 	__s32 transfer_buffer_length;
 
 	/* it is difficult for usbip to sync frames (reserved only?) */
 	__s32 start_frame;
-
-	/* the number of iso descriptors that follows this header */
 	__s32 number_of_packets;
-
-	/* the maximum time within which this request works in a host
-	 * controller of a server side */
 	__s32 interval;
 
-	/* set setup packet data for a CTRL request */
 	unsigned char setup[8];
 } __packed;
 
-/*
- * An additional header for a RET_SUBMIT packet.
+/**
+ * struct usbip_header_ret_submit - USBIP_RET_SUBMIT packet header
+ * @status: return status of a non-iso request
+ * @actual_length: number of bytes transferred
+ * @start_frame: initial frame for isochronous or interrupt transfers
+ * @number_of_packets: number of isochronous packets
+ * @error_count: number of errors for isochronous transfers
  */
 struct usbip_header_ret_submit {
 	__s32 status;
-	__s32 actual_length;		/* returned data length */
-	__s32 start_frame;		/* ISO and INT */
-	__s32 number_of_packets;	/* ISO only */
-	__s32 error_count;		/* ISO only */
+	__s32 actual_length;
+	__s32 start_frame;
+	__s32 number_of_packets;
+	__s32 error_count;
 } __packed;
 
-/*
- * An additional header for a CMD_UNLINK packet.
+/**
+ * struct usbip_header_cmd_unlink - USBIP_CMD_UNLINK packet header
+ * @seqnum: the URB seqnum to unlink
  */
 struct usbip_header_cmd_unlink {
-	__u32 seqnum;			/* URB's seqnum that will be unlinked */
+	__u32 seqnum;
 } __packed;
 
-/*
- * An additional header for a RET_UNLINK packet.
+/**
+ * struct usbip_header_ret_unlink - USBIP_RET_UNLINK packet header
+ * @status: return status of the request
  */
 struct usbip_header_ret_unlink {
 	__s32 status;
 } __packed;
 
-/* the same as usb_iso_packet_descriptor but packed for pdu */
-struct usbip_iso_packet_descriptor {
-	__u32 offset;
-	__u32 length;			/* expected length */
-	__u32 actual_length;
-	__u32 status;
-} __packed;
-
-/*
- * All usbip packets use a common header to keep code simple.
+/**
+ * struct usbip_header - common header for all usbip packets
+ * @base: the basic header
+ * @u: packet type dependent header
  */
 struct usbip_header {
 	struct usbip_header_basic base;
@@ -221,40 +220,15 @@ struct usbip_header {
 	} u;
 } __packed;
 
-int usbip_xmit(int, struct socket *, char *, int, int);
-int usbip_sendmsg(struct socket *, struct msghdr *, int);
-
-static inline int interface_to_busnum(struct usb_interface *interface)
-{
-	struct usb_device *udev = interface_to_usbdev(interface);
-	return udev->bus->busnum;
-}
-
-static inline int interface_to_devnum(struct usb_interface *interface)
-{
-	struct usb_device *udev = interface_to_usbdev(interface);
-	return udev->devnum;
-}
-
-static inline int interface_to_infnum(struct usb_interface *interface)
-{
-	return interface->cur_altsetting->desc.bInterfaceNumber;
-}
-
-#if 0
-int setnodelay(struct socket *);
-int setquickack(struct socket *);
-int setkeepalive(struct socket *socket);
-void setreuse(struct socket *);
-#endif
-
-struct socket *sockfd_to_socket(unsigned int);
-int set_sockaddr(struct socket *socket, struct sockaddr_storage *ss);
-
-void usbip_dump_urb(struct urb *purb);
-void usbip_dump_header(struct usbip_header *pdu);
-
-struct usbip_device;
+/*
+ * This is the same as usb_iso_packet_descriptor but packed for pdu.
+ */
+struct usbip_iso_packet_descriptor {
+	__u32 offset;
+	__u32 length;			/* expected length */
+	__u32 actual_length;
+	__u32 status;
+} __packed;
 
 enum usbip_side {
 	USBIP_VHCI,
@@ -277,20 +251,7 @@ enum usbip_status {
 	VDEV_ST_ERROR
 };
 
-/* a common structure for stub_device and vhci_device */
-struct usbip_device {
-	enum usbip_side side;
-	enum usbip_status status;
-
-	/* lock for status */
-	spinlock_t lock;
-
-	struct socket *tcp_socket;
-
-	struct task_struct *tcp_rx;
-	struct task_struct *tcp_tx;
-
-	/* event handler */
+/* event handler */
 #define USBIP_EH_SHUTDOWN	(1 << 0)
 #define USBIP_EH_BYE		(1 << 1)
 #define USBIP_EH_RESET		(1 << 2)
@@ -307,6 +268,19 @@ struct usbip_device {
 #define	VDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
 #define	VDEV_EVENT_ERROR_MALLOC	(USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
 
+/* a common structure for stub_device and vhci_device */
+struct usbip_device {
+	enum usbip_side side;
+	enum usbip_status status;
+
+	/* lock for status */
+	spinlock_t lock;
+
+	struct socket *tcp_socket;
+
+	struct task_struct *tcp_rx;
+	struct task_struct *tcp_tx;
+
 	unsigned long event;
 	struct task_struct *eh;
 	wait_queue_head_t eh_waitq;
@@ -318,17 +292,32 @@ struct usbip_device {
 	} eh_ops;
 };
 
+#if 0
+int usbip_sendmsg(struct socket *, struct msghdr *, int);
+int set_sockaddr(struct socket *socket, struct sockaddr_storage *ss);
+int setnodelay(struct socket *);
+int setquickack(struct socket *);
+int setkeepalive(struct socket *socket);
+void setreuse(struct socket *);
+#endif
+
+/* usbip_common.c */
+void usbip_dump_urb(struct urb *purb);
+void usbip_dump_header(struct usbip_header *pdu);
+
+int usbip_xmit(int send, struct socket *sock, char *buf, int size,
+	       int msg_flags);
+struct socket *sockfd_to_socket(unsigned int sockfd);
+
 void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
 		    int pack);
-
 void usbip_header_correct_endian(struct usbip_header *pdu, int send);
-/* some members of urb must be substituted before. */
-int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
+
+void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
 /* some members of urb must be substituted before. */
 int usbip_recv_iso(struct usbip_device *ud, struct urb *urb);
-/* some members of urb must be substituted before. */
 int usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
-void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
+int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
 
 /* usbip_event.c */
 int usbip_start_eh(struct usbip_device *ud);
@@ -336,4 +325,21 @@ void usbip_stop_eh(struct usbip_device *ud);
 void usbip_event_add(struct usbip_device *ud, unsigned long event);
 int usbip_event_happened(struct usbip_device *ud);
 
+static inline int interface_to_busnum(struct usb_interface *interface)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	return udev->bus->busnum;
+}
+
+static inline int interface_to_devnum(struct usb_interface *interface)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	return udev->devnum;
+}
+
+static inline int interface_to_infnum(struct usb_interface *interface)
+{
+	return interface->cur_altsetting->desc.bInterfaceNumber;
+}
+
 #endif /* __USBIP_COMMON_H */
-- 
1.7.5.1

