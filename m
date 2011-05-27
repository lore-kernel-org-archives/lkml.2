Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab1E0Iou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:44:50 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:36753 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758777Ab1E0Ioq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:44:46 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: usbip: userspace: rename usbip device and interface
Date: Fri, 27 May 2011 01:44:14 -0700
Message-Id: <139cf6e42d01a8b6e1669e9ee22248c688f6293f.1306485772.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
References: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prefix of usbip_ to internal usb device and interface to avoid
confusion with the kernel types. This also identifies the types as
being part of the usbip library.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    5 +++--
 .../staging/usbip/userspace/libsrc/stub_driver.h   |    4 ++--
 .../staging/usbip/userspace/libsrc/usbip_common.c  |    9 +++++----
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   13 +++++++------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |    2 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |    2 +-
 drivers/staging/usbip/userspace/src/usbip_list.c   |    8 ++++----
 .../staging/usbip/userspace/src/usbip_network.c    |   16 ++++++++--------
 .../staging/usbip/userspace/src/usbip_network.h    |   20 ++++++++++----------
 drivers/staging/usbip/userspace/src/usbipd.c       |    6 +++---
 10 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index 0355604..4d4d171 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -43,7 +43,7 @@ static struct sysfs_driver *open_sysfs_stub_driver(void)
 #define SYSFS_OPEN_RETRIES 100
 
 /* only the first interface value is true! */
-static int32_t read_attr_usbip_status(struct usb_device *udev)
+static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 {
 	char attrpath[SYSFS_PATH_MAX];
 	struct sysfs_attribute *attr;
@@ -145,7 +145,8 @@ static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 		goto err;
 
 	/* reallocate buffer to include usb interface data */
-	size_t size = sizeof(*edev) + edev->udev.bNumInterfaces * sizeof(struct usb_interface);
+	size_t size = sizeof(*edev) + edev->udev.bNumInterfaces *
+		sizeof(struct usbip_usb_interface);
 	edev = (struct usbip_exported_device *) realloc(edev, size);
 	if (!edev) {
 		err("alloc device");
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.h b/drivers/staging/usbip/userspace/libsrc/stub_driver.h
index 3107d18..332ebc5 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.h
@@ -19,8 +19,8 @@ struct usbip_exported_device {
 	struct sysfs_device *sudev;
 
 	int32_t status;
-	struct usb_device    udev;
-	struct usb_interface uinf[];
+	struct usbip_usb_device    udev;
+	struct usbip_usb_interface uinf[];
 };
 
 
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index a128a92..e9d0614 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -64,7 +64,7 @@ const char *usbip_speed_string(int num)
 #define DBG_UINF_INTEGER(name)\
 	dbg("%-20s = %x", to_string(name), (int) uinf->name)
 
-void dump_usb_interface(struct usb_interface *uinf)
+void dump_usb_interface(struct usbip_usb_interface *uinf)
 {
 	char buff[100];
 	usbip_names_get_class(buff, sizeof(buff),
@@ -74,7 +74,7 @@ void dump_usb_interface(struct usb_interface *uinf)
 	dbg("%-20s = %s", "Interface(C/SC/P)", buff);
 }
 
-void dump_usb_device(struct usb_device *udev)
+void dump_usb_device(struct usbip_usb_device *udev)
 {
 	char buff[100];
 
@@ -181,7 +181,7 @@ err:
 	do { (object)->name = (type) read_attr_value(dev, to_string(name), format); } while (0)
 
 
-int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev)
+int read_usb_device(struct sysfs_device *sdev, struct usbip_usb_device *udev)
 {
 	uint32_t busnum, devnum;
 
@@ -209,7 +209,8 @@ int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev)
 	return 0;
 }
 
-int read_usb_interface(struct usb_device *udev, int i, struct usb_interface *uinf)
+int read_usb_interface(struct usbip_usb_device *udev, int i,
+		       struct usbip_usb_interface *uinf)
 {
 	char busid[SYSFS_BUS_ID_SIZE];
 	struct sysfs_device *sif;
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index b38396f..32b27ed 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -104,7 +104,7 @@ extern int usbip_use_debug ;
 #define BUG()	do { err("sorry, it's a bug"); abort(); } while (0)
 
 
-struct usb_interface {
+struct usbip_usb_interface {
 	uint8_t bInterfaceClass;
 	uint8_t bInterfaceSubClass;
 	uint8_t bInterfaceProtocol;
@@ -113,7 +113,7 @@ struct usb_interface {
 
 
 
-struct usb_device {
+struct usbip_usb_device {
 	char path[SYSFS_PATH_MAX];
 	char busid[SYSFS_BUS_ID_SIZE];
 
@@ -135,11 +135,12 @@ struct usb_device {
 
 #define to_string(s)	#s
 
-void dump_usb_interface(struct usb_interface *);
-void dump_usb_device(struct usb_device *);
-int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev);
+void dump_usb_interface(struct usbip_usb_interface *);
+void dump_usb_device(struct usbip_usb_device *);
+int read_usb_device(struct sysfs_device *sdev, struct usbip_usb_device *udev);
 int read_attr_value(struct sysfs_device *dev, const char *name, const char *format);
-int read_usb_interface(struct usb_device *udev, int i, struct usb_interface *uinf);
+int read_usb_interface(struct usbip_usb_device *udev, int i,
+		       struct usbip_usb_interface *uinf);
 
 const char *usbip_speed_string(int num);
 const char *usbip_status_string(int32_t status);
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index 3395586..a2f7db1 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -27,7 +27,7 @@ struct usbip_imported_device {
 
 	/* usbip_class_device list */
 	struct dlist *cdev_list;
-	struct usb_device udev;
+	struct usbip_usb_device udev;
 };
 
 struct usbip_vhci_driver {
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 671d23c..189238b 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -73,7 +73,7 @@ static int record_connection(char *host, char *port, char *busid, int rhport)
 	return 0;
 }
 
-static int import_device(int sockfd, struct usb_device *udev)
+static int import_device(int sockfd, struct usbip_usb_device *udev)
 {
 	int rc;
 	int port;
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 4bbfae8..e69c457 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -77,13 +77,13 @@ static int query_exported_devices(int sockfd)
 	for (unsigned int i=0; i < rep.ndev; i++) {
 		char product_name[100];
 		char class_name[100];
-		struct usb_device udev;
+		struct usbip_usb_device udev;
 
 		memset(&udev, 0, sizeof(udev));
 
 		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
 		if (ret < 0) {
-			err("recv usb_device[%d]", i);
+			err("recv usbip_usb_device[%d]", i);
 			return -1;
 		}
 		pack_usb_device(0, &udev);
@@ -99,11 +99,11 @@ static int query_exported_devices(int sockfd)
 		printf("%8s: %s\n", " ", class_name);
 
 		for (int j=0; j < udev.bNumInterfaces; j++) {
-			struct usb_interface uinf;
+			struct usbip_usb_interface uinf;
 
 			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
 			if (ret < 0) {
-				err("recv usb_interface[%d]", j);
+				err("recv usbip_usb_interface[%d]", j);
 				return -1;
 			}
 
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index 0e0de56..26e95bd 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -4,10 +4,10 @@
  */
 
 #include <sys/socket.h>
-#include <arpa/inet.h>
 
 #include <string.h>
 
+#include <arpa/inet.h>
 #include <netdb.h>
 #include <netinet/tcp.h>
 #include <unistd.h>
@@ -39,7 +39,7 @@ void pack_uint16_t(int pack, uint16_t *num)
 	*num = i;
 }
 
-void pack_usb_device(int pack, struct usb_device *udev)
+void pack_usb_device(int pack, struct usbip_usb_device *udev)
 {
 	pack_uint32_t(pack, &udev->busnum);
 	pack_uint32_t(pack, &udev->devnum);
@@ -51,7 +51,7 @@ void pack_usb_device(int pack, struct usb_device *udev)
 }
 
 void pack_usb_interface(int pack __attribute__((unused)),
-			struct usb_interface *udev __attribute__((unused)))
+			struct usbip_usb_interface *udev __attribute__((unused)))
 {
 	/* uint8_t members need nothing */
 }
@@ -102,15 +102,15 @@ int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	memset(&op_common, 0, sizeof(op_common));
 
-	op_common.version	= USBIP_VERSION;
-	op_common.code		= code;
-	op_common.status	= status;
+	op_common.version = USBIP_VERSION;
+	op_common.code    = code;
+	op_common.status  = status;
 
 	PACK_OP_COMMON(1, &op_common);
 
 	ret = usbip_send(sockfd, (void *) &op_common, sizeof(op_common));
 	if (ret < 0) {
-		err("send op_common");
+		err("usbip_send has failed");
 		return -1;
 	}
 
@@ -126,7 +126,7 @@ int usbip_recv_op_common(int sockfd, uint16_t *code)
 
 	ret = usbip_recv(sockfd, (void *) &op_common, sizeof(op_common));
 	if (ret < 0) {
-		err("recv op_common, %d", ret);
+		err("usbip_recv has failed ret=%d", ret);
 		goto err;
 	}
 
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index 82b0811..07274df 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -56,8 +56,8 @@ struct op_devinfo_request {
 } __attribute__((packed));
 
 struct op_devinfo_reply {
-	struct usb_device udev;
-	struct usb_interface uinf[];
+	struct usbip_usb_device udev;
+	struct usbip_usb_interface uinf[];
 } __attribute__((packed));
 
 /* ---------------------------------------------------------------------- */
@@ -71,8 +71,8 @@ struct op_import_request {
 } __attribute__((packed));
 
 struct op_import_reply {
-	struct usb_device udev;
-//	struct usb_interface uinf[];
+	struct usbip_usb_device udev;
+//	struct usbip_usb_interface uinf[];
 } __attribute__((packed));
 
 #define PACK_OP_IMPORT_REQUEST(pack, request)  do {\
@@ -89,7 +89,7 @@ struct op_import_reply {
 #define OP_REP_EXPORT	(OP_REPLY   | OP_EXPORT)
 
 struct op_export_request {
-	struct usb_device udev;
+	struct usbip_usb_device udev;
 } __attribute__((packed));
 
 struct op_export_reply {
@@ -111,7 +111,7 @@ struct op_export_reply {
 #define OP_REP_UNEXPORT	(OP_REPLY   | OP_UNEXPORT)
 
 struct op_unexport_request {
-	struct usb_device udev;
+	struct usbip_usb_device udev;
 } __attribute__((packed));
 
 struct op_unexport_reply {
@@ -156,8 +156,8 @@ struct op_devlist_reply {
 } __attribute__((packed));
 
 struct op_devlist_reply_extra {
-	struct usb_device    udev;
-	struct usb_interface uinf[];
+	struct usbip_usb_device    udev;
+	struct usbip_usb_interface uinf[];
 } __attribute__((packed));
 
 #define PACK_OP_DEVLIST_REQUEST(pack, request)  do {\
@@ -169,8 +169,8 @@ struct op_devlist_reply_extra {
 
 void pack_uint32_t(int pack, uint32_t *num);
 void pack_uint16_t(int pack, uint16_t *num);
-void pack_usb_device(int pack, struct usb_device *udev);
-void pack_usb_interface(int pack, struct usb_interface *uinf);
+void pack_usb_device(int pack, struct usbip_usb_device *udev);
+void pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
 
 ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen);
 ssize_t usbip_send(int sockfd, void *buff, size_t bufflen);
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 12ff00b..332f9e6 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -64,7 +64,7 @@ static int send_reply_devlist(int sockfd)
 	}
 
 	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		struct usb_device pdu_udev;
+		struct usbip_usb_device pdu_udev;
 
 		dump_usb_device(&edev->udev);
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
@@ -77,7 +77,7 @@ static int send_reply_devlist(int sockfd)
 		}
 
 		for (int i=0; i < edev->udev.bNumInterfaces; i++) {
-			struct usb_interface pdu_uinf;
+			struct usbip_usb_interface pdu_uinf;
 
 			dump_usb_interface(&edev->uinf[i]);
 			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
@@ -167,7 +167,7 @@ static int recv_request_import(int sockfd)
 	}
 
 	if (!error) {
-		struct usb_device pdu_udev;
+		struct usbip_usb_device pdu_udev;
 
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 		pack_usb_device(1, &pdu_udev);
-- 
1.7.5.1

