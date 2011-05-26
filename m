Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1EZNSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:18:04 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:46419 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757774Ab1EZNRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:44 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging: usbip: userspace: usbip_network: rename and cleanup function
Date: Thu, 26 May 2011 06:17:13 -0700
Message-Id: <4aa90189a4736075d68e2eae4b43957b508b9e21.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306414175.git.mfm@muteddisk.com>
References: <cover.1306414175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename tcp_connection to usbip_net_tcp_connection, which alludes to a
usbip network library that will eventually follow. The implementation
of this function has also been cleaned up.

Headers had to be adjusted due to the elimination of the old usbip.h.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/src/usbip_network.c    |   73 +++++++++-----------
 .../staging/usbip/userspace/src/usbip_network.h    |   37 +++-------
 2 files changed, 45 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index 01be3c7..ef93b02 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -3,6 +3,16 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
+#include <sys/socket.h>
+#include <arpa/inet.h>
+
+#include <string.h>
+
+#include <netdb.h>
+#include <netinet/tcp.h>
+#include <unistd.h>
+
+#include "usbip_common.h"
 #include "usbip_network.h"
 
 void pack_uint32_t(int pack, uint32_t *num)
@@ -186,66 +196,49 @@ int usbip_set_keepalive(int sockfd)
 	return ret;
 }
 
-/* IPv6 Ready */
 /*
- * moved here from vhci_attach.c
+ * IPv6 Ready
  */
-int tcp_connect(char *hostname, char *service)
+int usbip_net_tcp_connect(char *hostname, char *port)
 {
-	struct addrinfo hints, *res, *res0;
+	struct addrinfo hints, *res, *rp;
 	int sockfd;
-	int err;
-
+	int ret;
 
 	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = SOCK_STREAM;
 
 	/* get all possible addresses */
-	err = getaddrinfo(hostname, service, &hints, &res0);
-	if (err) {
-		err("%s %s: %s", hostname, service, gai_strerror(err));
-		return -1;
+	ret = getaddrinfo(hostname, port, &hints, &res);
+	if (ret < 0) {
+		dbg("getaddrinfo: %s port %s: %s", hostname, port,
+		    gai_strerror(ret));
+		return ret;
 	}
 
-	/* try all the addresses */
-	for (res = res0; res; res = res->ai_next) {
-		char hbuf[NI_MAXHOST], sbuf[NI_MAXSERV];
-
-		err = getnameinfo(res->ai_addr, res->ai_addrlen,
-				hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
-		if (err) {
-			err("%s %s: %s", hostname, service, gai_strerror(err));
-			continue;
-		}
-
-		dbg("trying %s port %s\n", hbuf, sbuf);
-
-		sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
-		if (sockfd < 0) {
-			err("socket");
+	/* try the addresses */
+	for (rp = res; rp; rp = rp->ai_next) {
+		sockfd = socket(rp->ai_family, rp->ai_socktype,
+				rp->ai_protocol);
+		if (sockfd < 0)
 			continue;
-		}
 
 		/* should set TCP_NODELAY for usbip */
 		usbip_set_nodelay(sockfd);
-		/* TODO: write code for heatbeat */
+		/* TODO: write code for heartbeat */
 		usbip_set_keepalive(sockfd);
 
-		err = connect(sockfd, res->ai_addr, res->ai_addrlen);
-		if (err < 0) {
-			close(sockfd);
-			continue;
-		}
+		if (connect(sockfd, rp->ai_addr, rp->ai_addrlen) == 0)
+			break;
 
-		/* connected */
-		dbg("connected to %s:%s", hbuf, sbuf);
-		freeaddrinfo(res0);
-		return sockfd;
+		close(sockfd);
 	}
 
+	if (!rp)
+		return EAI_SYSTEM;
 
-	dbg("%s:%s, %s", hostname, service, "no destination to connect to");
-	freeaddrinfo(res0);
+	freeaddrinfo(res);
 
-	return -1;
+	return sockfd;
 }
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index 1225466..82b0811 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -2,19 +2,20 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-#ifndef _USBIP_NETWORK_H
-#define _USBIP_NETWORK_H
+#ifndef __USBIP_NETWORK_H
+#define __USBIP_NETWORK_H
 
-#include "usbip.h"
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/tcp.h>
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
 
+#include <sys/types.h>
+#include <sysfs/libsysfs.h>
 
-/* -------------------------------------------------- */
-/* Define Protocol Format                             */
-/* -------------------------------------------------- */
+#include <stdint.h>
 
+#define USBIP_PORT 3240
+#define USBIP_PORT_STRING "3240"
 
 /* ---------------------------------------------------------------------- */
 /* Common header for all the kinds of PDUs. */
@@ -38,7 +39,6 @@ struct op_common {
 	pack_uint32_t(pack, &(op_common)->status );\
 } while (0)
 
-
 /* ---------------------------------------------------------------------- */
 /* Dummy Code */
 #define OP_UNSPEC	0x00
@@ -60,7 +60,6 @@ struct op_devinfo_reply {
 	struct usb_interface uinf[];
 } __attribute__((packed));
 
-
 /* ---------------------------------------------------------------------- */
 /* Import a remote USB device. */
 #define OP_IMPORT	0x03
@@ -83,8 +82,6 @@ struct op_import_reply {
 	pack_usb_device(pack, &(reply)->udev);\
 } while (0)
 
-
-
 /* ---------------------------------------------------------------------- */
 /* Export a USB device to a remote host. */
 #define OP_EXPORT	0x06
@@ -128,8 +125,6 @@ struct op_unexport_reply {
 #define PACK_OP_UNEXPORT_REPLY(pack, reply)  do {\
 } while (0)
 
-
-
 /* ---------------------------------------------------------------------- */
 /* Negotiate IPSec encryption key. (still not used) */
 #define OP_CRYPKEY	0x04
@@ -172,11 +167,6 @@ struct op_devlist_reply_extra {
 	pack_uint32_t(pack, &(reply)->ndev);\
 } while (0)
 
-
-/* -------------------------------------------------- */
-/* Declare Prototype Function                         */
-/* -------------------------------------------------- */
-
 void pack_uint32_t(int pack, uint32_t *num);
 void pack_uint16_t(int pack, uint16_t *num);
 void pack_usb_device(int pack, struct usb_device *udev);
@@ -190,9 +180,6 @@ int usbip_set_reuseaddr(int sockfd);
 int usbip_set_nodelay(int sockfd);
 int usbip_set_keepalive(int sockfd);
 
-int tcp_connect(char *hostname, char *service);
+int usbip_net_tcp_connect(char *hostname, char *port);
 
-#define USBIP_PORT 3240
-#define USBIP_PORT_STRING "3240"
-
-#endif
+#endif /* __USBIP_NETWORK_H */
-- 
1.7.5.1

