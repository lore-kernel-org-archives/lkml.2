Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab1E0IpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:45:00 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:38197
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758787Ab1E0Iot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:44:49 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging: usbip: userspace: usbip_list.c: cleanup exported device functions
Date: Fri, 27 May 2011 01:44:15 -0700
Message-Id: <14602431b0d0e944e09f86ee7ab7dee7c81ccfd8.1306485772.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
References: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename functions and cleanup coding style.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c |   90 ++++++++++------------
 1 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index e69c457..03f6210 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -45,45 +45,43 @@ void usbip_list_usage(void)
 	printf("usage: %s", usbip_list_usage_string);
 }
 
-static int query_exported_devices(int sockfd)
+static int get_exported_devices(int sockfd)
 {
-	int ret;
+	char product_name[100];
+	char class_name[100];
 	struct op_devlist_reply rep;
 	uint16_t code = OP_REP_DEVLIST;
-
-	memset(&rep, 0, sizeof(rep));
-
-	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
-	if (ret < 0) {
-		err("send op_common");
+	struct usbip_usb_device udev;
+	struct usbip_usb_interface uintf;
+	unsigned int i;
+	int j, rc;
+
+	rc = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	if (rc < 0) {
+		dbg("usbip_send_op_common");
 		return -1;
 	}
 
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common");
+	rc = usbip_recv_op_common(sockfd, &code);
+	if (rc < 0) {
+		dbg("usbip_recv_op_common");
 		return -1;
 	}
 
-	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
-	if (ret < 0) {
-		err("recv op_devlist");
+	memset(&rep, 0, sizeof(rep));
+	rc = usbip_recv(sockfd, &rep, sizeof(rep));
+	if (rc < 0) {
+		dbg("usbip_recv_op_devlist");
 		return -1;
 	}
-
 	PACK_OP_DEVLIST_REPLY(0, &rep);
-	dbg("exportable %d devices", rep.ndev);
-
-	for (unsigned int i=0; i < rep.ndev; i++) {
-		char product_name[100];
-		char class_name[100];
-		struct usbip_usb_device udev;
+	dbg("exportable devices: %d", rep.ndev);
 
+	for (i = 0; i < rep.ndev; i++) {
 		memset(&udev, 0, sizeof(udev));
-
-		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
-		if (ret < 0) {
-			err("recv usbip_usb_device[%d]", i);
+		rc = usbip_recv(sockfd, &udev, sizeof(udev));
+		if (rc < 0) {
+			dbg("usbip_recv: usbip_usb_device[%d]", i);
 			return -1;
 		}
 		pack_usb_device(0, &udev);
@@ -93,38 +91,34 @@ static int query_exported_devices(int sockfd)
 		usbip_names_get_class(class_name, sizeof(class_name),
 				      udev.bDeviceClass, udev.bDeviceSubClass,
 				      udev.bDeviceProtocol);
-
 		printf("%8s: %s\n", udev.busid, product_name);
-		printf("%8s: %s\n", " ", udev.path);
-		printf("%8s: %s\n", " ", class_name);
-
-		for (int j=0; j < udev.bNumInterfaces; j++) {
-			struct usbip_usb_interface uinf;
+		printf("%8s: %s\n", "", udev.path);
+		printf("%8s: %s\n", "", class_name);
 
-			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
-			if (ret < 0) {
-				err("recv usbip_usb_interface[%d]", j);
+		for (j = 0; j < udev.bNumInterfaces; j++) {
+			rc = usbip_recv(sockfd, &uintf, sizeof(uintf));
+			if (rc < 0) {
+				dbg("usbip_recv: usbip_usb_interface[%d]", j);
 				return -1;
 			}
+			pack_usb_interface(0, &uintf);
 
-			pack_usb_interface(0, &uinf);
 			usbip_names_get_class(class_name, sizeof(class_name),
-					      uinf.bInterfaceClass,
-					      uinf.bInterfaceSubClass,
-					      uinf.bInterfaceProtocol);
+					      uintf.bInterfaceClass,
+					      uintf.bInterfaceSubClass,
+					      uintf.bInterfaceProtocol);
+			printf("%8s: %2d - %s\n", "", j, class_name);
 
-			printf("%8s: %2d - %s\n", " ", j, class_name);
 		}
-
 		printf("\n");
 	}
 
-	return rep.ndev;
+	return 0;
 }
 
-static int show_exported_devices(char *host)
+static int list_exported_devices(char *host)
 {
-	int ret;
+	int rc;
 	int sockfd;
 
 	sockfd = usbip_net_tcp_connect(host, USBIP_PORT_STRING);
@@ -134,16 +128,16 @@ static int show_exported_devices(char *host)
 		return -1;
 	}
 	dbg("connected to %s port %s\n", host, USBIP_PORT_STRING);
-
 	printf("- %s\n", host);
 
-	ret = query_exported_devices(sockfd);
-	if (ret < 0) {
-		err("query");
+	rc = get_exported_devices(sockfd);
+	if (rc < 0) {
+		dbg("get_exported_devices failed");
 		return -1;
 	}
 
 	close(sockfd);
+
 	return 0;
 }
 
@@ -273,7 +267,7 @@ int usbip_list(int argc, char *argv[])
 			parsable = true;
 			break;
 		case 'r':
-			ret = show_exported_devices(optarg);
+			ret = list_exported_devices(optarg);
 			goto out;
 		case 'l':
 			ret = list_devices(parsable);
-- 
1.7.5.1

