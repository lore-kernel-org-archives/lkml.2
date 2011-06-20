Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1FTFps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:48 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:40235
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab1FTFpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:40 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/22] staging: usbip: userspace: usbip_network.c: coding style cleanup
Date: Sun, 19 Jun 2011 22:44:49 -0700
Message-Id: <105b753b32a2491879ec025694d4100c61e5aeb4.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change messges to debug, and fix a few coding style issues.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/src/usbip_network.c    |   73 +++++++++++--------
 1 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index 26e95bd..a3833ff 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -1,6 +1,19 @@
 /*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
  *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <sys/socket.h>
@@ -56,17 +69,15 @@ void pack_usb_interface(int pack __attribute__((unused)),
 	/* uint8_t members need nothing */
 }
 
-
 static ssize_t usbip_xmit(int sockfd, void *buff, size_t bufflen, int sending)
 {
+	ssize_t nbytes;
 	ssize_t total = 0;
 
 	if (!bufflen)
 		return 0;
 
 	do {
-		ssize_t nbytes;
-
 		if (sending)
 			nbytes = send(sockfd, buff, bufflen, 0);
 		else
@@ -75,13 +86,12 @@ static ssize_t usbip_xmit(int sockfd, void *buff, size_t bufflen, int sending)
 		if (nbytes <= 0)
 			return -1;
 
-		buff	= (void *) ((intptr_t) buff + nbytes);
+		buff	 = (void *)((intptr_t) buff + nbytes);
 		bufflen	-= nbytes;
 		total	+= nbytes;
 
 	} while (bufflen > 0);
 
-
 	return total;
 }
 
@@ -97,8 +107,8 @@ ssize_t usbip_send(int sockfd, void *buff, size_t bufflen)
 
 int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
 {
-	int ret;
 	struct op_common op_common;
+	int rc;
 
 	memset(&op_common, 0, sizeof(op_common));
 
@@ -108,9 +118,9 @@ int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	PACK_OP_COMMON(1, &op_common);
 
-	ret = usbip_send(sockfd, (void *) &op_common, sizeof(op_common));
-	if (ret < 0) {
-		err("usbip_send has failed");
+	rc = usbip_send(sockfd, &op_common, sizeof(op_common));
+	if (rc < 0) {
+		dbg("usbip_send failed: %d", rc);
 		return -1;
 	}
 
@@ -119,36 +129,38 @@ int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 int usbip_recv_op_common(int sockfd, uint16_t *code)
 {
-	int ret;
 	struct op_common op_common;
+	int rc;
 
 	memset(&op_common, 0, sizeof(op_common));
 
-	ret = usbip_recv(sockfd, (void *) &op_common, sizeof(op_common));
-	if (ret < 0) {
-		err("usbip_recv has failed ret=%d", ret);
+	rc = usbip_recv(sockfd, &op_common, sizeof(op_common));
+	if (rc < 0) {
+		dbg("usbip_recv failed: %d", rc);
 		goto err;
 	}
 
 	PACK_OP_COMMON(0, &op_common);
 
 	if (op_common.version != USBIP_VERSION) {
-		err("version mismatch, %d %d", op_common.version, USBIP_VERSION);
+		dbg("version mismatch: %d %d", op_common.version,
+		    USBIP_VERSION);
 		goto err;
 	}
 
-	switch(*code) {
-		case OP_UNSPEC:
-			break;
-		default:
-			if (op_common.code != *code) {
-				info("unexpected pdu %d for %d", op_common.code, *code);
-				goto err;
-			}
+	switch (*code) {
+	case OP_UNSPEC:
+		break;
+	default:
+		if (op_common.code != *code) {
+			dbg("unexpected pdu %#0x for %#0x", op_common.code,
+			    *code);
+			goto err;
+		}
 	}
 
 	if (op_common.status != ST_OK) {
-		info("request failed at peer, %d", op_common.status);
+		dbg("request failed at peer: %d", op_common.status);
 		goto err;
 	}
 
@@ -159,7 +171,6 @@ err:
 	return -1;
 }
 
-
 int usbip_set_reuseaddr(int sockfd)
 {
 	const int val = 1;
@@ -167,7 +178,7 @@ int usbip_set_reuseaddr(int sockfd)
 
 	ret = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 	if (ret < 0)
-		err("setsockopt SO_REUSEADDR");
+		dbg("setsockopt: SO_REUSEADDR");
 
 	return ret;
 }
@@ -179,7 +190,7 @@ int usbip_set_nodelay(int sockfd)
 
 	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
 	if (ret < 0)
-		err("setsockopt TCP_NODELAY");
+		dbg("setsockopt: TCP_NODELAY");
 
 	return ret;
 }
@@ -191,7 +202,7 @@ int usbip_set_keepalive(int sockfd)
 
 	ret = setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &val, sizeof(val));
 	if (ret < 0)
-		err("setsockopt SO_KEEPALIVE");
+		dbg("setsockopt: SO_KEEPALIVE");
 
 	return ret;
 }
@@ -199,7 +210,7 @@ int usbip_set_keepalive(int sockfd)
 /*
  * IPv6 Ready
  */
-int usbip_net_tcp_connect(char *hostname, char *port)
+int usbip_net_tcp_connect(char *hostname, char *service)
 {
 	struct addrinfo hints, *res, *rp;
 	int sockfd;
@@ -210,9 +221,9 @@ int usbip_net_tcp_connect(char *hostname, char *port)
 	hints.ai_socktype = SOCK_STREAM;
 
 	/* get all possible addresses */
-	ret = getaddrinfo(hostname, port, &hints, &res);
+	ret = getaddrinfo(hostname, service, &hints, &res);
 	if (ret < 0) {
-		dbg("getaddrinfo: %s port %s: %s", hostname, port,
+		dbg("getaddrinfo: %s service %s: %s", hostname, service,
 		    gai_strerror(ret));
 		return ret;
 	}
-- 
1.7.5.2

