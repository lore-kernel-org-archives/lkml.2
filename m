Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1FTFx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:53:26 -0400
Received: from qmta15.westchester.pa.mail.comcast.net ([76.96.59.228]:36310
	"EHLO qmta15.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab1FTFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:51:59 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/22] staging: usbip: userspace: usbip list: edit output messages
Date: Sun, 19 Jun 2011 22:44:44 -0700
Message-Id: <e36b98ea60e97784523fd31d4c258c9fbea0f63c.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edit dbg and normal output messages for consistency and better
feedback.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c |   58 +++++++++++++---------
 1 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 03f6210..afff469 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -49,7 +49,7 @@ static int get_exported_devices(int sockfd)
 {
 	char product_name[100];
 	char class_name[100];
-	struct op_devlist_reply rep;
+	struct op_devlist_reply reply;
 	uint16_t code = OP_REP_DEVLIST;
 	struct usbip_usb_device udev;
 	struct usbip_usb_interface uintf;
@@ -58,30 +58,30 @@ static int get_exported_devices(int sockfd)
 
 	rc = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
 	if (rc < 0) {
-		dbg("usbip_send_op_common");
+		dbg("usbip_send_op_common failed");
 		return -1;
 	}
 
 	rc = usbip_recv_op_common(sockfd, &code);
 	if (rc < 0) {
-		dbg("usbip_recv_op_common");
+		dbg("usbip_recv_op_common failed");
 		return -1;
 	}
 
-	memset(&rep, 0, sizeof(rep));
-	rc = usbip_recv(sockfd, &rep, sizeof(rep));
+	memset(&reply, 0, sizeof(reply));
+	rc = usbip_recv(sockfd, &reply, sizeof(reply));
 	if (rc < 0) {
-		dbg("usbip_recv_op_devlist");
+		dbg("usbip_recv_op_devlist failed");
 		return -1;
 	}
-	PACK_OP_DEVLIST_REPLY(0, &rep);
-	dbg("exportable devices: %d", rep.ndev);
+	PACK_OP_DEVLIST_REPLY(0, &reply);
+	dbg("exportable devices: %d\n", reply.ndev);
 
-	for (i = 0; i < rep.ndev; i++) {
+	for (i = 0; i < reply.ndev; i++) {
 		memset(&udev, 0, sizeof(udev));
 		rc = usbip_recv(sockfd, &udev, sizeof(udev));
 		if (rc < 0) {
-			dbg("usbip_recv: usbip_usb_device[%d]", i);
+			dbg("usbip_recv failed: usbip_usb_device[%d]", i);
 			return -1;
 		}
 		pack_usb_device(0, &udev);
@@ -98,7 +98,7 @@ static int get_exported_devices(int sockfd)
 		for (j = 0; j < udev.bNumInterfaces; j++) {
 			rc = usbip_recv(sockfd, &uintf, sizeof(uintf));
 			if (rc < 0) {
-				dbg("usbip_recv: usbip_usb_interface[%d]", j);
+				dbg("usbip_recv failed: usbip_usb_intf[%d]", j);
 				return -1;
 			}
 			pack_usb_interface(0, &uintf);
@@ -108,7 +108,6 @@ static int get_exported_devices(int sockfd)
 					      uintf.bInterfaceSubClass,
 					      uintf.bInterfaceProtocol);
 			printf("%8s: %2d - %s\n", "", j, class_name);
-
 		}
 		printf("\n");
 	}
@@ -123,16 +122,19 @@ static int list_exported_devices(char *host)
 
 	sockfd = usbip_net_tcp_connect(host, USBIP_PORT_STRING);
 	if (sockfd < 0) {
-		err("unable to connect to %s port %s: %s\n", host,
+		err("could not connect to %s:%s: %s", host,
 		    USBIP_PORT_STRING, gai_strerror(sockfd));
 		return -1;
 	}
-	dbg("connected to %s port %s\n", host, USBIP_PORT_STRING);
-	printf("- %s\n", host);
+	dbg("connected to %s:%s", host, USBIP_PORT_STRING);
+
+	printf("Exportable USB devices\n");
+	printf("======================\n");
+	printf(" - %s\n", host);
 
 	rc = get_exported_devices(sockfd);
 	if (rc < 0) {
-		dbg("get_exported_devices failed");
+		err("failed to get device list from %s", host);
 		return -1;
 	}
 
@@ -193,13 +195,14 @@ static int list_devices(bool parsable)
 
 	ubus = sysfs_open_bus(bus_type);
 	if (!ubus) {
-		err("sysfs_open_bus: %s", strerror(errno));
+		err("could not open %s bus: %s", bus_type, strerror(errno));
 		return -1;
 	}
 
 	devlist = sysfs_get_bus_devices(ubus);
 	if (!devlist) {
-		err("sysfs_get_bus_devices: %s", strerror(errno));
+		err("could not get %s bus devices: %s", bus_type,
+		    strerror(errno));
 		goto err_out;
 	}
 
@@ -215,8 +218,11 @@ static int list_devices(bool parsable)
 		idProduct  = sysfs_get_device_attr(dev, "idProduct");
 		bConfValue = sysfs_get_device_attr(dev, "bConfigurationValue");
 		bNumIntfs  = sysfs_get_device_attr(dev, "bNumInterfaces");
-		if (!idVendor || !idProduct || !bConfValue || !bNumIntfs)
+		if (!idVendor || !idProduct || !bConfValue || !bNumIntfs) {
+			err("problem getting device attributes: %s",
+			    strerror(errno));
 			goto err_out;
+		}
 
 		print_device(dev->bus_id, idVendor->value, idProduct->value,
 			     parsable);
@@ -225,8 +231,11 @@ static int list_devices(bool parsable)
 			snprintf(busid, sizeof(busid), "%s:%.1s.%d",
 				 dev->bus_id, bConfValue->value, i);
 			intf = sysfs_open_device(bus_type, busid);
-			if (!intf)
+			if (!intf) {
+				err("could not open device interface: %s",
+				    strerror(errno));
 				goto err_out;
+			}
 			print_interface(busid, intf->driver_name, parsable);
 			sysfs_close_device(intf);
 		}
@@ -244,11 +253,12 @@ err_out:
 int usbip_list(int argc, char *argv[])
 {
 	static const struct option opts[] = {
-		{ "parsable", no_argument, NULL, 'p' },
-		{ "remote", required_argument, NULL, 'r' },
-		{ "local", no_argument, NULL, 'l' },
-		{ NULL, 0, NULL, 0 }
+		{ "parsable", no_argument,       NULL, 'p' },
+		{ "remote",   required_argument, NULL, 'r' },
+		{ "local",    no_argument,       NULL, 'l' },
+		{ NULL,       0,                 NULL,  0  }
 	};
+
 	bool parsable = false;
 	int opt;
 	int ret = -1;
-- 
1.7.5.2

