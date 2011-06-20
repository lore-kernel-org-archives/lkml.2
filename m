Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1FTFpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:54 -0400
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:44217
	"EHLO qmta07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430Ab1FTFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:42 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/22] staging: usbip: userspace: add new prefix for usbip network code
Date: Sun, 19 Jun 2011 22:44:50 -0700
Message-Id: <6df48ec3c864f2fcd7f17e1b879ad7ded630d9c5.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change and add new usbip_net_ prefix to every function in the network
code for easier identification.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_attach.c |    8 ++--
 drivers/staging/usbip/userspace/src/usbip_list.c   |   26 +++++----
 .../staging/usbip/userspace/src/usbip_network.c    |   56 ++++++++++---------
 .../staging/usbip/userspace/src/usbip_network.h    |   39 +++++++-------
 drivers/staging/usbip/userspace/src/usbipd.c       |   50 +++++++++---------
 5 files changed, 91 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 189238b..b7885a2 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -115,7 +115,7 @@ static int query_import_device(int sockfd, char *busid)
 	memset(&reply, 0, sizeof(reply));
 
 	/* send a request */
-	rc = usbip_send_op_common(sockfd, OP_REQ_IMPORT, 0);
+	rc = usbip_net_send_op_common(sockfd, OP_REQ_IMPORT, 0);
 	if (rc < 0) {
 		err("send op_common");
 		return -1;
@@ -125,20 +125,20 @@ static int query_import_device(int sockfd, char *busid)
 
 	PACK_OP_IMPORT_REQUEST(0, &request);
 
-	rc = usbip_send(sockfd, (void *) &request, sizeof(request));
+	rc = usbip_net_send(sockfd, (void *) &request, sizeof(request));
 	if (rc < 0) {
 		err("send op_import_request");
 		return -1;
 	}
 
 	/* recieve a reply */
-	rc = usbip_recv_op_common(sockfd, &code);
+	rc = usbip_net_recv_op_common(sockfd, &code);
 	if (rc < 0) {
 		err("recv op_common");
 		return -1;
 	}
 
-	rc = usbip_recv(sockfd, (void *) &reply, sizeof(reply));
+	rc = usbip_net_recv(sockfd, (void *) &reply, sizeof(reply));
 	if (rc < 0) {
 		err("recv op_import_reply");
 		return -1;
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 973bf8c..3edf5d1 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -56,22 +56,22 @@ static int get_exported_devices(char *host, int sockfd)
 	unsigned int i;
 	int j, rc;
 
-	rc = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
 	if (rc < 0) {
-		dbg("usbip_send_op_common failed");
+		dbg("usbip_net_send_op_common failed");
 		return -1;
 	}
 
-	rc = usbip_recv_op_common(sockfd, &code);
+	rc = usbip_net_recv_op_common(sockfd, &code);
 	if (rc < 0) {
-		dbg("usbip_recv_op_common failed");
+		dbg("usbip_net_recv_op_common failed");
 		return -1;
 	}
 
 	memset(&reply, 0, sizeof(reply));
-	rc = usbip_recv(sockfd, &reply, sizeof(reply));
+	rc = usbip_net_recv(sockfd, &reply, sizeof(reply));
 	if (rc < 0) {
-		dbg("usbip_recv_op_devlist failed");
+		dbg("usbip_net_recv_op_devlist failed");
 		return -1;
 	}
 	PACK_OP_DEVLIST_REPLY(0, &reply);
@@ -88,12 +88,12 @@ static int get_exported_devices(char *host, int sockfd)
 
 	for (i = 0; i < reply.ndev; i++) {
 		memset(&udev, 0, sizeof(udev));
-		rc = usbip_recv(sockfd, &udev, sizeof(udev));
+		rc = usbip_net_recv(sockfd, &udev, sizeof(udev));
 		if (rc < 0) {
-			dbg("usbip_recv failed: usbip_usb_device[%d]", i);
+			dbg("usbip_net_recv failed: usbip_usb_device[%d]", i);
 			return -1;
 		}
-		pack_usb_device(0, &udev);
+		usbip_net_pack_usb_device(0, &udev);
 
 		usbip_names_get_product(product_name, sizeof(product_name),
 					udev.idVendor, udev.idProduct);
@@ -105,12 +105,14 @@ static int get_exported_devices(char *host, int sockfd)
 		printf("%8s: %s\n", "", class_name);
 
 		for (j = 0; j < udev.bNumInterfaces; j++) {
-			rc = usbip_recv(sockfd, &uintf, sizeof(uintf));
+			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
 			if (rc < 0) {
-				dbg("usbip_recv failed: usbip_usb_intf[%d]", j);
+				dbg("usbip_net_recv failed: usbip_usb_intf[%d]",
+				    j);
+
 				return -1;
 			}
-			pack_usb_interface(0, &uintf);
+			usbip_net_pack_usb_interface(0, &uintf);
 
 			usbip_names_get_class(class_name, sizeof(class_name),
 					      uintf.bInterfaceClass,
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index a3833ff..1a84dd3 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -28,7 +28,7 @@
 #include "usbip_common.h"
 #include "usbip_network.h"
 
-void pack_uint32_t(int pack, uint32_t *num)
+void usbip_net_pack_uint32_t(int pack, uint32_t *num)
 {
 	uint32_t i;
 
@@ -40,7 +40,7 @@ void pack_uint32_t(int pack, uint32_t *num)
 	*num = i;
 }
 
-void pack_uint16_t(int pack, uint16_t *num)
+void usbip_net_pack_uint16_t(int pack, uint16_t *num)
 {
 	uint16_t i;
 
@@ -52,24 +52,26 @@ void pack_uint16_t(int pack, uint16_t *num)
 	*num = i;
 }
 
-void pack_usb_device(int pack, struct usbip_usb_device *udev)
+void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev)
 {
-	pack_uint32_t(pack, &udev->busnum);
-	pack_uint32_t(pack, &udev->devnum);
-	pack_uint32_t(pack, &udev->speed );
+	usbip_net_pack_uint32_t(pack, &udev->busnum);
+	usbip_net_pack_uint32_t(pack, &udev->devnum);
+	usbip_net_pack_uint32_t(pack, &udev->speed );
 
-	pack_uint16_t(pack, &udev->idVendor );
-	pack_uint16_t(pack, &udev->idProduct);
-	pack_uint16_t(pack, &udev->bcdDevice);
+	usbip_net_pack_uint16_t(pack, &udev->idVendor);
+	usbip_net_pack_uint16_t(pack, &udev->idProduct);
+	usbip_net_pack_uint16_t(pack, &udev->bcdDevice);
 }
 
-void pack_usb_interface(int pack __attribute__((unused)),
-			struct usbip_usb_interface *udev __attribute__((unused)))
+void usbip_net_pack_usb_interface(int pack __attribute__((unused)),
+				  struct usbip_usb_interface *udev
+				  __attribute__((unused)))
 {
 	/* uint8_t members need nothing */
 }
 
-static ssize_t usbip_xmit(int sockfd, void *buff, size_t bufflen, int sending)
+static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
+			      int sending)
 {
 	ssize_t nbytes;
 	ssize_t total = 0;
@@ -95,17 +97,17 @@ static ssize_t usbip_xmit(int sockfd, void *buff, size_t bufflen, int sending)
 	return total;
 }
 
-ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen)
+ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen)
 {
-	return usbip_xmit(sockfd, buff, bufflen, 0);
+	return usbip_net_xmit(sockfd, buff, bufflen, 0);
 }
 
-ssize_t usbip_send(int sockfd, void *buff, size_t bufflen)
+ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen)
 {
-	return usbip_xmit(sockfd, buff, bufflen, 1);
+	return usbip_net_xmit(sockfd, buff, bufflen, 1);
 }
 
-int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
+int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 {
 	struct op_common op_common;
 	int rc;
@@ -118,25 +120,25 @@ int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	PACK_OP_COMMON(1, &op_common);
 
-	rc = usbip_send(sockfd, &op_common, sizeof(op_common));
+	rc = usbip_net_send(sockfd, &op_common, sizeof(op_common));
 	if (rc < 0) {
-		dbg("usbip_send failed: %d", rc);
+		dbg("usbip_net_send failed: %d", rc);
 		return -1;
 	}
 
 	return 0;
 }
 
-int usbip_recv_op_common(int sockfd, uint16_t *code)
+int usbip_net_recv_op_common(int sockfd, uint16_t *code)
 {
 	struct op_common op_common;
 	int rc;
 
 	memset(&op_common, 0, sizeof(op_common));
 
-	rc = usbip_recv(sockfd, &op_common, sizeof(op_common));
+	rc = usbip_net_recv(sockfd, &op_common, sizeof(op_common));
 	if (rc < 0) {
-		dbg("usbip_recv failed: %d", rc);
+		dbg("usbip_net_recv failed: %d", rc);
 		goto err;
 	}
 
@@ -171,7 +173,7 @@ err:
 	return -1;
 }
 
-int usbip_set_reuseaddr(int sockfd)
+int usbip_net_set_reuseaddr(int sockfd)
 {
 	const int val = 1;
 	int ret;
@@ -183,7 +185,7 @@ int usbip_set_reuseaddr(int sockfd)
 	return ret;
 }
 
-int usbip_set_nodelay(int sockfd)
+int usbip_net_set_nodelay(int sockfd)
 {
 	const int val = 1;
 	int ret;
@@ -195,7 +197,7 @@ int usbip_set_nodelay(int sockfd)
 	return ret;
 }
 
-int usbip_set_keepalive(int sockfd)
+int usbip_net_set_keepalive(int sockfd)
 {
 	const int val = 1;
 	int ret;
@@ -236,9 +238,9 @@ int usbip_net_tcp_connect(char *hostname, char *service)
 			continue;
 
 		/* should set TCP_NODELAY for usbip */
-		usbip_set_nodelay(sockfd);
+		usbip_net_set_nodelay(sockfd);
 		/* TODO: write code for heartbeat */
-		usbip_set_keepalive(sockfd);
+		usbip_net_set_keepalive(sockfd);
 
 		if (connect(sockfd, rp->ai_addr, rp->ai_addrlen) == 0)
 			break;
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index 07274df..2d1e070 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -34,9 +34,9 @@ struct op_common {
 } __attribute__((packed));
 
 #define PACK_OP_COMMON(pack, op_common)  do {\
-	pack_uint16_t(pack, &(op_common)->version);\
-	pack_uint16_t(pack, &(op_common)->code   );\
-	pack_uint32_t(pack, &(op_common)->status );\
+	usbip_net_pack_uint16_t(pack, &(op_common)->version);\
+	usbip_net_pack_uint16_t(pack, &(op_common)->code   );\
+	usbip_net_pack_uint32_t(pack, &(op_common)->status );\
 } while (0)
 
 /* ---------------------------------------------------------------------- */
@@ -79,7 +79,7 @@ struct op_import_reply {
 } while (0)
 
 #define PACK_OP_IMPORT_REPLY(pack, reply)  do {\
-	pack_usb_device(pack, &(reply)->udev);\
+	usbip_net_pack_usb_device(pack, &(reply)->udev);\
 } while (0)
 
 /* ---------------------------------------------------------------------- */
@@ -98,7 +98,7 @@ struct op_export_reply {
 
 
 #define PACK_OP_EXPORT_REQUEST(pack, request)  do {\
-	pack_usb_device(pack, &(request)->udev);\
+	usbip_net_pack_usb_device(pack, &(request)->udev);\
 } while (0)
 
 #define PACK_OP_EXPORT_REPLY(pack, reply)  do {\
@@ -119,7 +119,7 @@ struct op_unexport_reply {
 } __attribute__((packed));
 
 #define PACK_OP_UNEXPORT_REQUEST(pack, request)  do {\
-	pack_usb_device(pack, &(request)->udev);\
+	usbip_net_pack_usb_device(pack, &(request)->udev);\
 } while (0)
 
 #define PACK_OP_UNEXPORT_REPLY(pack, reply)  do {\
@@ -164,22 +164,21 @@ struct op_devlist_reply_extra {
 } while (0)
 
 #define PACK_OP_DEVLIST_REPLY(pack, reply)  do {\
-	pack_uint32_t(pack, &(reply)->ndev);\
+	usbip_net_pack_uint32_t(pack, &(reply)->ndev);\
 } while (0)
 
-void pack_uint32_t(int pack, uint32_t *num);
-void pack_uint16_t(int pack, uint16_t *num);
-void pack_usb_device(int pack, struct usbip_usb_device *udev);
-void pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
-
-ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen);
-ssize_t usbip_send(int sockfd, void *buff, size_t bufflen);
-int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status);
-int usbip_recv_op_common(int sockfd, uint16_t *code);
-int usbip_set_reuseaddr(int sockfd);
-int usbip_set_nodelay(int sockfd);
-int usbip_set_keepalive(int sockfd);
-
+void usbip_net_pack_uint32_t(int pack, uint32_t *num);
+void usbip_net_pack_uint16_t(int pack, uint16_t *num);
+void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
+void usbip_net_pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
+
+ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen);
+ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen);
+int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status);
+int usbip_net_recv_op_common(int sockfd, uint16_t *code);
+int usbip_net_set_reuseaddr(int sockfd);
+int usbip_net_set_nodelay(int sockfd);
+int usbip_net_set_keepalive(int sockfd);
 int usbip_net_tcp_connect(char *hostname, char *port);
 
 #endif /* __USBIP_NETWORK_H */
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index aa92623..8668a80 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -84,9 +84,9 @@ static int recv_request_import(int sockfd)
 	memset(&req, 0, sizeof(req));
 	memset(&reply, 0, sizeof(reply));
 
-	rc = usbip_recv(sockfd, &req, sizeof(req));
+	rc = usbip_net_recv(sockfd, &req, sizeof(req));
 	if (rc < 0) {
-		dbg("usbip_recv failed: import request");
+		dbg("usbip_net_recv failed: import request");
 		return -1;
 	}
 	PACK_OP_IMPORT_REQUEST(0, &req);
@@ -102,7 +102,7 @@ static int recv_request_import(int sockfd)
 
 	if (found) {
 		/* should set TCP_NODELAY for usbip */
-		usbip_set_nodelay(sockfd);
+		usbip_net_set_nodelay(sockfd);
 
 		/* export device needs a TCP/IP socket descriptor */
 		rc = usbip_host_export_device(edev, sockfd);
@@ -113,11 +113,10 @@ static int recv_request_import(int sockfd)
 		error = 1;
 	}
 
-
-	rc = usbip_send_op_common(sockfd, OP_REP_IMPORT,
-				  (!error ? ST_OK : ST_NA));
+	rc = usbip_net_send_op_common(sockfd, OP_REP_IMPORT,
+				      (!error ? ST_OK : ST_NA));
 	if (rc < 0) {
-		dbg("usbip_send_op_common failed: %#0x", OP_REP_IMPORT);
+		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_IMPORT);
 		return -1;
 	}
 
@@ -127,11 +126,11 @@ static int recv_request_import(int sockfd)
 	}
 
 	memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-	pack_usb_device(1, &pdu_udev);
+	usbip_net_pack_usb_device(1, &pdu_udev);
 
-	rc = usbip_send(sockfd, &pdu_udev, sizeof(pdu_udev));
+	rc = usbip_net_send(sockfd, &pdu_udev, sizeof(pdu_udev));
 	if (rc < 0) {
-		dbg("usbip_send failed: devinfo");
+		dbg("usbip_net_send failed: devinfo");
 		return -1;
 	}
 
@@ -157,16 +156,16 @@ static int send_reply_devlist(int connfd)
 	}
 	info("exportable devices: %d", reply.ndev);
 
-	rc = usbip_send_op_common(connfd, OP_REP_DEVLIST, ST_OK);
+	rc = usbip_net_send_op_common(connfd, OP_REP_DEVLIST, ST_OK);
 	if (rc < 0) {
-		dbg("usbip_send_op_common failed: %#0x", OP_REP_DEVLIST);
+		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_DEVLIST);
 		return -1;
 	}
 	PACK_OP_DEVLIST_REPLY(1, &reply);
 
-	rc = usbip_send(connfd, &reply, sizeof(reply));
+	rc = usbip_net_send(connfd, &reply, sizeof(reply));
 	if (rc < 0) {
-		dbg("usbip_send failed: %#0x", OP_REP_DEVLIST);
+		dbg("usbip_net_send failed: %#0x", OP_REP_DEVLIST);
 		return -1;
 	}
 
@@ -174,22 +173,23 @@ static int send_reply_devlist(int connfd)
 			    struct usbip_exported_device) {
 		dump_usb_device(&edev->udev);
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-		pack_usb_device(1, &pdu_udev);
+		usbip_net_pack_usb_device(1, &pdu_udev);
 
-		rc = usbip_send(connfd, &pdu_udev, sizeof(pdu_udev));
+		rc = usbip_net_send(connfd, &pdu_udev, sizeof(pdu_udev));
 		if (rc < 0) {
-			dbg("usbip_send failed: pdu_udev");
+			dbg("usbip_net_send failed: pdu_udev");
 			return -1;
 		}
 
 		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
 			dump_usb_interface(&edev->uinf[i]);
 			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
-			pack_usb_interface(1, &pdu_uinf);
+			usbip_net_pack_usb_interface(1, &pdu_uinf);
 
-			rc = usbip_send(connfd, &pdu_uinf, sizeof(pdu_uinf));
+			rc = usbip_net_send(connfd, &pdu_uinf,
+					    sizeof(pdu_uinf));
 			if (rc < 0) {
-				dbg("usbip_send failed: pdu_uinf");
+				dbg("usbip_net_send failed: pdu_uinf");
 				return -1;
 			}
 		}
@@ -205,9 +205,9 @@ static int recv_request_devlist(int connfd)
 
 	memset(&req, 0, sizeof(req));
 
-	rc = usbip_recv(connfd, &req, sizeof(req));
+	rc = usbip_net_recv(connfd, &req, sizeof(req));
 	if (rc < 0) {
-		dbg("usbip_recv failed: devlist request");
+		dbg("usbip_net_recv failed: devlist request");
 		return -1;
 	}
 
@@ -225,7 +225,7 @@ static int recv_pdu(int connfd)
 	uint16_t code = OP_UNSPEC;
 	int ret;
 
-	ret = usbip_recv_op_common(connfd, &code);
+	ret = usbip_net_recv_op_common(connfd, &code);
 	if (ret < 0) {
 		dbg("could not receive opcode: %#0x", code);
 		return -1;
@@ -361,8 +361,8 @@ static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[])
 		if (sockfdlist[nsockfd] < 0)
 			continue;
 
-		usbip_set_reuseaddr(sockfdlist[nsockfd]);
-		usbip_set_nodelay(sockfdlist[nsockfd]);
+		usbip_net_set_reuseaddr(sockfdlist[nsockfd]);
+		usbip_net_set_nodelay(sockfdlist[nsockfd]);
 
 		if (sockfdlist[nsockfd] >= FD_SETSIZE) {
 			close(sockfdlist[nsockfd]);
-- 
1.7.5.2

