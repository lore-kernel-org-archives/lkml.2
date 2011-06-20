Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1FTGWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 02:22:00 -0400
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:44695
	"EHLO qmta02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab1FTGV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 02:21:57 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/22] staging: usbip: userspace: usbip list: move output header
Date: Sun, 19 Jun 2011 22:44:45 -0700
Message-Id: <bbfb8cad6b8d0d7715ff6316c6ca9ccc533c0ed5.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delay the printing of the output header until the list is received
from the remote host. This allows notification that the host does not
have any exportable devices.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index afff469..973bf8c 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -45,7 +45,7 @@ void usbip_list_usage(void)
 	printf("usage: %s", usbip_list_usage_string);
 }
 
-static int get_exported_devices(int sockfd)
+static int get_exported_devices(char *host, int sockfd)
 {
 	char product_name[100];
 	char class_name[100];
@@ -77,6 +77,15 @@ static int get_exported_devices(int sockfd)
 	PACK_OP_DEVLIST_REPLY(0, &reply);
 	dbg("exportable devices: %d\n", reply.ndev);
 
+	if (reply.ndev == 0) {
+		info("no exportable devices found on %s", host);
+		return 0;
+	}
+
+	printf("Exportable USB devices\n");
+	printf("======================\n");
+	printf(" - %s\n", host);
+
 	for (i = 0; i < reply.ndev; i++) {
 		memset(&udev, 0, sizeof(udev));
 		rc = usbip_recv(sockfd, &udev, sizeof(udev));
@@ -128,11 +137,7 @@ static int list_exported_devices(char *host)
 	}
 	dbg("connected to %s:%s", host, USBIP_PORT_STRING);
 
-	printf("Exportable USB devices\n");
-	printf("======================\n");
-	printf(" - %s\n", host);
-
-	rc = get_exported_devices(sockfd);
+	rc = get_exported_devices(host, sockfd);
 	if (rc < 0) {
 		err("failed to get device list from %s", host);
 		return -1;
-- 
1.7.5.2

