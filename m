Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1FTFwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:52:35 -0400
Received: from qmta14.westchester.pa.mail.comcast.net ([76.96.59.212]:52648
	"EHLO qmta14.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1FTFwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:52:01 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/22] staging: usbip: userspace: usbipd: major cleanup of daemon
Date: Sun, 19 Jun 2011 22:44:48 -0700
Message-Id: <a668188151a68a91691a3a93b7e56f9459a99c29.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize, rename [for clarity and to remove stub_driver
references], modify output messages, and cleanup coding style;
nevertheless, the actual implementation is pretty much untouched.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbipd.c |  693 +++++++++++++-------------
 1 files changed, 345 insertions(+), 348 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 332f9e6..aa92623 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
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
 
 #ifdef HAVE_CONFIG_H
@@ -27,66 +40,157 @@
 #include <glib.h>
 #include <signal.h>
 
-#include "stub_driver.h"
+#include "usbip_host_driver.h"
 #include "usbip_common.h"
 #include "usbip_network.h"
 
-static const char version[] = PACKAGE_STRING;
+#undef  PROGNAME
+#define PROGNAME "usbipd"
+#define MAXSOCKFD 20
+
+GMainLoop *main_loop;
 
-static int send_reply_devlist(int sockfd)
+static const char usbip_version_string[] = PACKAGE_STRING;
+
+static const char usbipd_help_string[] =
+	"usage: usbipd [options]			\n"
+	"	-D, --daemon				\n"
+	"		Run as a daemon process.	\n"
+	"						\n"
+	"	-d, --debug				\n"
+	"		Print debugging information.	\n"
+	"						\n"
+	"	-h, --help 				\n"
+	"		Print this help.		\n"
+	"						\n"
+	"	-v, --version				\n"
+	"		Show version.			\n";
+
+static void usbipd_help(void)
 {
-	int ret;
+	printf("%s\n", usbipd_help_string);
+}
+
+static int recv_request_import(int sockfd)
+{
+	struct op_import_request req;
+	struct op_common reply;
 	struct usbip_exported_device *edev;
-	struct op_devlist_reply reply;
+	struct usbip_usb_device pdu_udev;
+	int found = 0;
+	int error = 0;
+	int rc;
 
+	memset(&req, 0, sizeof(req));
+	memset(&reply, 0, sizeof(reply));
 
-	reply.ndev = 0;
+	rc = usbip_recv(sockfd, &req, sizeof(req));
+	if (rc < 0) {
+		dbg("usbip_recv failed: import request");
+		return -1;
+	}
+	PACK_OP_IMPORT_REQUEST(0, &req);
 
-	/* how many devices are exported ? */
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		reply.ndev += 1;
+	dlist_for_each_data(host_driver->edev_list, edev,
+			    struct usbip_exported_device) {
+		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
+			info("found requested device: %s", req.busid);
+			found = 1;
+			break;
+		}
 	}
 
-	dbg("%d devices are exported", reply.ndev);
+	if (found) {
+		/* should set TCP_NODELAY for usbip */
+		usbip_set_nodelay(sockfd);
 
-	ret = usbip_send_op_common(sockfd, OP_REP_DEVLIST,  ST_OK);
-	if (ret < 0) {
-		err("send op_common");
-		return ret;
+		/* export device needs a TCP/IP socket descriptor */
+		rc = usbip_host_export_device(edev, sockfd);
+		if (rc < 0)
+			error = 1;
+	} else {
+		info("requested device not found: %s", req.busid);
+		error = 1;
 	}
 
-	PACK_OP_DEVLIST_REPLY(1, &reply);
 
-	ret = usbip_send(sockfd, (void *) &reply, sizeof(reply));
-	if (ret < 0) {
-		err("send op_devlist_reply");
-		return ret;
+	rc = usbip_send_op_common(sockfd, OP_REP_IMPORT,
+				  (!error ? ST_OK : ST_NA));
+	if (rc < 0) {
+		dbg("usbip_send_op_common failed: %#0x", OP_REP_IMPORT);
+		return -1;
+	}
+
+	if (error) {
+		dbg("import request busid %s: failed", req.busid);
+		return -1;
+	}
+
+	memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
+	pack_usb_device(1, &pdu_udev);
+
+	rc = usbip_send(sockfd, &pdu_udev, sizeof(pdu_udev));
+	if (rc < 0) {
+		dbg("usbip_send failed: devinfo");
+		return -1;
 	}
 
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		struct usbip_usb_device pdu_udev;
+	dbg("import request busid %s: complete", req.busid);
+
+	return 0;
+}
 
+static int send_reply_devlist(int connfd)
+{
+	struct usbip_exported_device *edev;
+	struct usbip_usb_device pdu_udev;
+	struct usbip_usb_interface pdu_uinf;
+	struct op_devlist_reply reply;
+	int i;
+	int rc;
+
+	reply.ndev = 0;
+	/* number of exported devices */
+	dlist_for_each_data(host_driver->edev_list, edev,
+			    struct usbip_exported_device) {
+		reply.ndev += 1;
+	}
+	info("exportable devices: %d", reply.ndev);
+
+	rc = usbip_send_op_common(connfd, OP_REP_DEVLIST, ST_OK);
+	if (rc < 0) {
+		dbg("usbip_send_op_common failed: %#0x", OP_REP_DEVLIST);
+		return -1;
+	}
+	PACK_OP_DEVLIST_REPLY(1, &reply);
+
+	rc = usbip_send(connfd, &reply, sizeof(reply));
+	if (rc < 0) {
+		dbg("usbip_send failed: %#0x", OP_REP_DEVLIST);
+		return -1;
+	}
+
+	dlist_for_each_data(host_driver->edev_list, edev,
+			    struct usbip_exported_device) {
 		dump_usb_device(&edev->udev);
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 		pack_usb_device(1, &pdu_udev);
 
-		ret = usbip_send(sockfd, (void *) &pdu_udev, sizeof(pdu_udev));
-		if (ret < 0) {
-			err("send pdu_udev");
-			return ret;
+		rc = usbip_send(connfd, &pdu_udev, sizeof(pdu_udev));
+		if (rc < 0) {
+			dbg("usbip_send failed: pdu_udev");
+			return -1;
 		}
 
-		for (int i=0; i < edev->udev.bNumInterfaces; i++) {
-			struct usbip_usb_interface pdu_uinf;
-
+		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
 			dump_usb_interface(&edev->uinf[i]);
 			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
 			pack_usb_interface(1, &pdu_uinf);
 
-			ret = usbip_send(sockfd, (void *) &pdu_uinf, sizeof(pdu_uinf));
-			if (ret < 0) {
-				err("send pdu_uinf");
-				return ret;
+			rc = usbip_send(connfd, &pdu_uinf, sizeof(pdu_uinf));
+			if (rc < 0) {
+				dbg("usbip_send failed: pdu_uinf");
+				return -1;
 			}
 		}
 	}
@@ -94,283 +198,227 @@ static int send_reply_devlist(int sockfd)
 	return 0;
 }
 
-
-static int recv_request_devlist(int sockfd)
+static int recv_request_devlist(int connfd)
 {
-	int ret;
 	struct op_devlist_request req;
+	int rc;
 
 	memset(&req, 0, sizeof(req));
 
-	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
-	if (ret < 0) {
-		err("recv devlist request");
+	rc = usbip_recv(connfd, &req, sizeof(req));
+	if (rc < 0) {
+		dbg("usbip_recv failed: devlist request");
 		return -1;
 	}
 
-	ret = send_reply_devlist(sockfd);
-	if (ret < 0) {
-		err("send devlist reply");
+	rc = send_reply_devlist(connfd);
+	if (rc < 0) {
+		dbg("send_reply_devlist failed");
 		return -1;
 	}
 
 	return 0;
 }
 
-
-static int recv_request_import(int sockfd)
+static int recv_pdu(int connfd)
 {
+	uint16_t code = OP_UNSPEC;
 	int ret;
-	struct op_import_request req;
-	struct op_common reply;
-	struct usbip_exported_device *edev;
-	int found = 0;
-	int error = 0;
-
-	memset(&req, 0, sizeof(req));
-	memset(&reply, 0, sizeof(reply));
 
-	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
+	ret = usbip_recv_op_common(connfd, &code);
 	if (ret < 0) {
-		err("recv import request");
+		dbg("could not receive opcode: %#0x", code);
 		return -1;
 	}
 
-	PACK_OP_IMPORT_REQUEST(0, &req);
-
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
-			dbg("found requested device %s", req.busid);
-			found = 1;
-			break;
-		}
+	ret = usbip_host_refresh_device_list();
+	if (ret < 0) {
+		dbg("could not refresh device list: %d", ret);
+		return -1;
 	}
 
-	if (found) {
-		/* should set TCP_NODELAY for usbip */
-		usbip_set_nodelay(sockfd);
-
-		/* export_device needs a TCP/IP socket descriptor */
-		ret = usbip_stub_export_device(edev, sockfd);
-		if (ret < 0)
-			error = 1;
-	} else {
-		info("not found requested device %s", req.busid);
-		error = 1;
+	info("received request: %#0x(%d)", code, connfd);
+	switch (code) {
+	case OP_REQ_DEVLIST:
+		ret = recv_request_devlist(connfd);
+		break;
+	case OP_REQ_IMPORT:
+		ret = recv_request_import(connfd);
+		break;
+	case OP_REQ_DEVINFO:
+	case OP_REQ_CRYPKEY:
+	default:
+		err("received an unknown opcode: %#0x", code);
+		ret = -1;
 	}
 
+	if (ret == 0)
+		info("request %#0x(%d): complete", code, connfd);
+	else
+		info("request %#0x(%d): failed", code, connfd);
 
-	ret = usbip_send_op_common(sockfd, OP_REP_IMPORT, (!error ? ST_OK : ST_NA));
-	if (ret < 0) {
-		err("send import reply");
-		return -1;
-	}
-
-	if (!error) {
-		struct usbip_usb_device pdu_udev;
+	return ret;
+}
 
-		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-		pack_usb_device(1, &pdu_udev);
+#ifdef HAVE_LIBWRAP
+static int tcpd_auth(int connfd)
+{
+	struct request_info request;
+	int rc;
 
-		ret = usbip_send(sockfd, (void *) &pdu_udev, sizeof(pdu_udev));
-		if (ret < 0) {
-			err("send devinfo");
-			return -1;
-		}
-	}
+	request_init(&request, RQ_DAEMON, PROGNAME, RQ_FILE, connfd, 0);
+	fromhost(&request);
+	rc = hosts_access(&request);
+	if (rc == 0)
+		return -1;
 
 	return 0;
 }
+#endif
 
-
-
-static int recv_pdu(int sockfd)
+static int do_accept(int listenfd)
 {
-	int ret;
-	uint16_t code = OP_UNSPEC;
+	int connfd;
+	struct sockaddr_storage ss;
+	socklen_t len = sizeof(ss);
+	char host[NI_MAXHOST], port[NI_MAXSERV];
+	int rc;
 
+	memset(&ss, 0, sizeof(ss));
 
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common, %d", ret);
-		return ret;
+	connfd = accept(listenfd, (struct sockaddr *) &ss, &len);
+	if (connfd < 0) {
+		err("failed to accept connection");
+		return -1;
 	}
 
+	rc = getnameinfo((struct sockaddr *) &ss, len, host, sizeof(host),
+			 port, sizeof(port), NI_NUMERICHOST | NI_NUMERICSERV);
+	if (rc)
+		err("getnameinfo: %s", gai_strerror(rc));
 
-	ret = usbip_stub_refresh_device_list();
-	if (ret < 0)
+#ifdef HAVE_LIBWRAP
+	rc = tcpd_auth(connfd);
+	if (rc < 0) {
+		info("denied access from %s", host);
+		close(connfd);
 		return -1;
+	}
+#endif
+	info("connection from %s:%s", host, port);
 
-	switch(code) {
-		case OP_REQ_DEVLIST:
-			ret = recv_request_devlist(sockfd);
-			break;
+	return connfd;
+}
 
-		case OP_REQ_IMPORT:
-			ret = recv_request_import(sockfd);
-			break;
+gboolean process_request(GIOChannel *gio, GIOCondition condition,
+			 gpointer unused_data)
+{
+	int listenfd;
+	int connfd;
 
-		case OP_REQ_DEVINFO:
-		case OP_REQ_CRYPKEY:
+	(void) unused_data;
 
-		default:
-			err("unknown op_code, %d", code);
-			ret = -1;
+	if (condition & (G_IO_ERR | G_IO_HUP | G_IO_NVAL)) {
+		err("unknown condition");
+		BUG();
 	}
 
+	if (condition & G_IO_IN) {
+		listenfd = g_io_channel_unix_get_fd(gio);
+		connfd = do_accept(listenfd);
+		if (connfd < 0)
+			return TRUE;
 
-	return ret;
-}
-
-
+		recv_pdu(connfd);
+		close(connfd);
+	}
 
+	return TRUE;
+}
 
 static void log_addrinfo(struct addrinfo *ai)
 {
-	int ret;
 	char hbuf[NI_MAXHOST];
 	char sbuf[NI_MAXSERV];
+	int rc;
 
-	ret = getnameinfo(ai->ai_addr, ai->ai_addrlen, hbuf, sizeof(hbuf),
-			sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
-	if (ret)
-		err("getnameinfo, %s", gai_strerror(ret));
+	rc = getnameinfo(ai->ai_addr, ai->ai_addrlen, hbuf, sizeof(hbuf),
+			 sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
+	if (rc)
+		err("getnameinfo: %s", gai_strerror(rc));
 
-	info("listen at [%s]:%s", hbuf, sbuf);
-}
-
-static struct addrinfo *my_getaddrinfo(char *host, int ai_family)
-{
-	int ret;
-	struct addrinfo hints, *ai_head;
-
-	memset(&hints, 0, sizeof(hints));
-
-	hints.ai_family   = ai_family;
-	hints.ai_socktype = SOCK_STREAM;
-	hints.ai_flags    = AI_PASSIVE;
-
-	ret = getaddrinfo(host, USBIP_PORT_STRING, &hints, &ai_head);
-	if (ret) {
-		err("%s: %s", USBIP_PORT_STRING, gai_strerror(ret));
-		return NULL;
-	}
-
-	return ai_head;
+	info("listening on %s:%s", hbuf, sbuf);
 }
 
-#define MAXSOCK 20
-static int listen_all_addrinfo(struct addrinfo *ai_head, int lsock[])
+static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[])
 {
 	struct addrinfo *ai;
-	int n = 0;		/* number of sockets */
+	int ret, nsockfd = 0;
 
-	for (ai = ai_head; ai && n < MAXSOCK; ai = ai->ai_next) {
-		int ret;
-
-		lsock[n] = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
-		if (lsock[n] < 0)
+	for (ai = ai_head; ai && nsockfd < MAXSOCKFD; ai = ai->ai_next) {
+		sockfdlist[nsockfd] = socket(ai->ai_family, ai->ai_socktype,
+					     ai->ai_protocol);
+		if (sockfdlist[nsockfd] < 0)
 			continue;
 
-		usbip_set_reuseaddr(lsock[n]);
-		usbip_set_nodelay(lsock[n]);
+		usbip_set_reuseaddr(sockfdlist[nsockfd]);
+		usbip_set_nodelay(sockfdlist[nsockfd]);
 
-		if (lsock[n] >= FD_SETSIZE) {
-			close(lsock[n]);
-			lsock[n] = -1;
+		if (sockfdlist[nsockfd] >= FD_SETSIZE) {
+			close(sockfdlist[nsockfd]);
+			sockfdlist[nsockfd] = -1;
 			continue;
 		}
 
-		ret = bind(lsock[n], ai->ai_addr, ai->ai_addrlen);
+		ret = bind(sockfdlist[nsockfd], ai->ai_addr, ai->ai_addrlen);
 		if (ret < 0) {
-			close(lsock[n]);
-			lsock[n] = -1;
+			close(sockfdlist[nsockfd]);
+			sockfdlist[nsockfd] = -1;
 			continue;
 		}
 
-		ret = listen(lsock[n], SOMAXCONN);
+		ret = listen(sockfdlist[nsockfd], SOMAXCONN);
 		if (ret < 0) {
-			close(lsock[n]);
-			lsock[n] = -1;
+			close(sockfdlist[nsockfd]);
+			sockfdlist[nsockfd] = -1;
 			continue;
 		}
 
 		log_addrinfo(ai);
-
-		/* next if succeed */
-		n++;
+		nsockfd++;
 	}
 
-	if (n == 0) {
-		err("no socket to listen to");
+	if (nsockfd == 0)
 		return -1;
-	}
 
-	dbg("listen %d address%s", n, (n==1)?"":"es");
+	dbg("listening on %d address%s", nsockfd, (nsockfd == 1) ? "" : "es");
 
-	return n;
+	return nsockfd;
 }
 
-#ifdef HAVE_LIBWRAP
-static int tcpd_auth(int csock)
+static struct addrinfo *do_getaddrinfo(char *host, int ai_family)
 {
-	int ret;
-	struct request_info request;
-
-	request_init(&request, RQ_DAEMON, "usbipd", RQ_FILE, csock, 0);
-
-	fromhost(&request);
-
-	ret = hosts_access(&request);
-	if (!ret)
-		return -1;
-
-	return 0;
-}
-#endif
-
-static int my_accept(int lsock)
-{
-	int csock;
-	struct sockaddr_storage ss;
-	socklen_t len = sizeof(ss);
-	char host[NI_MAXHOST], port[NI_MAXSERV];
-	int ret;
-
-	memset(&ss, 0, sizeof(ss));
-
-	csock = accept(lsock, (struct sockaddr *) &ss, &len);
-	if (csock < 0) {
-		err("accept");
-		return -1;
-	}
+	struct addrinfo hints, *ai_head;
+	int rc;
 
-	ret = getnameinfo((struct sockaddr *) &ss, len,
-			host, sizeof(host), port, sizeof(port),
-			(NI_NUMERICHOST | NI_NUMERICSERV));
-	if (ret)
-		err("getnameinfo, %s", gai_strerror(ret));
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family   = ai_family;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags    = AI_PASSIVE;
 
-#ifdef HAVE_LIBWRAP
-	ret = tcpd_auth(csock);
-	if (ret < 0) {
-		info("deny access from %s", host);
-		close(csock);
-		return -1;
+	rc = getaddrinfo(host, USBIP_PORT_STRING, &hints, &ai_head);
+	if (rc) {
+		err("failed to get a network address %s: %s", USBIP_PORT_STRING,
+		    gai_strerror(rc));
+		return NULL;
 	}
-#endif
-
-	info("connected from %s:%s", host, port);
 
-	return csock;
+	return ai_head;
 }
 
-
-GMainLoop *main_loop;
-
 static void signal_handler(int i)
 {
-	dbg("signal catched, code %d", i);
+	dbg("received signal: code %d", i);
 
 	if (main_loop)
 		g_main_loop_quit(main_loop);
@@ -387,184 +435,133 @@ static void set_signal(void)
 	sigaction(SIGINT, &act, NULL);
 }
 
-
-gboolean process_comming_request(GIOChannel *gio, GIOCondition condition,
-				 gpointer data __attribute__((unused)))
+static int do_standalone_mode(gboolean daemonize)
 {
-	int ret;
-
-	if (condition & (G_IO_ERR | G_IO_HUP | G_IO_NVAL))
-		g_error("unknown condition");
-
-
-	if (condition & G_IO_IN) {
-		int lsock;
-		int csock;
-
-		lsock = g_io_channel_unix_get_fd(gio);
-
-		csock = my_accept(lsock);
-		if (csock < 0)
-			return TRUE;
-
-		ret = recv_pdu(csock);
-		if (ret < 0)
-			err("process recieved pdu");
-
-		close(csock);
-	}
-
-	return TRUE;
-}
-
-
-static void do_standalone_mode(gboolean daemonize)
-{
-	int ret;
-	int lsock[MAXSOCK];
 	struct addrinfo *ai_head;
-	int n;
-
-
+	int sockfdlist[MAXSOCKFD];
+	int nsockfd;
+	int i;
 
-	ret = usbip_names_init(USBIDS_FILE);
-	if (ret)
-		err("open usb.ids");
+	if (usbip_names_init(USBIDS_FILE))
+		err("failed to open %s", USBIDS_FILE);
 
-	ret = usbip_stub_driver_open();
-	if (ret < 0)
-		g_error("driver open failed");
+	if (usbip_host_driver_open()) {
+		err("please load " USBIP_CORE_MOD_NAME ".ko and "
+		    USBIP_HOST_DRV_NAME ".ko!");
+		return -1;
+	}
 
 	if (daemonize) {
-		if (daemon(0,0) < 0)
-			g_error("daemonizing failed: %s", g_strerror(errno));
+		if (daemon(0,0) < 0) {
+			err("daemonizing failed: %s", strerror(errno));
+			return -1;
+		}
 
 		usbip_use_syslog = 1;
 	}
-
 	set_signal();
 
-	ai_head = my_getaddrinfo(NULL, PF_UNSPEC);
+	ai_head = do_getaddrinfo(NULL, PF_UNSPEC);
 	if (!ai_head)
-		return;
+		return -1;
 
-	n = listen_all_addrinfo(ai_head, lsock);
-	if (n <= 0)
-		g_error("no socket to listen to");
+	info("starting " PROGNAME " (%s)", usbip_version_string);
+
+	nsockfd = listen_all_addrinfo(ai_head, sockfdlist);
+	if (nsockfd <= 0) {
+		err("failed to open a listening socket");
+		return -1;
+	}
 
-	for (int i = 0; i < n; i++) {
+	for (i = 0; i < nsockfd; i++) {
 		GIOChannel *gio;
 
-		gio = g_io_channel_unix_new(lsock[i]);
+		gio = g_io_channel_unix_new(sockfdlist[i]);
 		g_io_add_watch(gio, (G_IO_IN | G_IO_ERR | G_IO_HUP | G_IO_NVAL),
-				process_comming_request, NULL);
+			       process_request, NULL);
 	}
 
-
-	info("usbipd start (%s)", version);
-
-
 	main_loop = g_main_loop_new(FALSE, FALSE);
 	g_main_loop_run(main_loop);
 
-	info("shutdown");
+	info("shutting down " PROGNAME);
 
 	freeaddrinfo(ai_head);
+	usbip_host_driver_close();
 	usbip_names_free();
-	usbip_stub_driver_close();
 
-	return;
-}
-
-
-static const char help_message[] = "\
-Usage: usbipd [options]				\n\
-	-D, --daemon				\n\
-		Run as a daemon process.	\n\
-						\n\
-	-d, --debug				\n\
-		Print debugging information.	\n\
-						\n\
-	-v, --version				\n\
-		Show version.			\n\
-						\n\
-	-h, --help 				\n\
-		Print this help.		\n";
-
-static void show_help(void)
-{
-	printf("%s", help_message);
+	return 0;
 }
 
-static const struct option longopts[] = {
-	{"daemon",	no_argument,	NULL, 'D'},
-	{"debug",	no_argument,	NULL, 'd'},
-	{"version",	no_argument,	NULL, 'v'},
-	{"help",	no_argument,	NULL, 'h'},
-	{NULL,		0,		NULL,  0}
-};
-
 int main(int argc, char *argv[])
 {
-	gboolean daemonize = FALSE;
+	static const struct option longopts[] = {
+		{ "daemon",  no_argument, NULL, 'D' },
+		{ "debug",   no_argument, NULL, 'd' },
+		{ "help",    no_argument, NULL, 'h' },
+		{ "version", no_argument, NULL, 'v' },
+		{ NULL,	     0,           NULL,  0  }
+	};
 
 	enum {
 		cmd_standalone_mode = 1,
 		cmd_help,
 		cmd_version
-	} cmd = cmd_standalone_mode;
+	} cmd;
 
+	gboolean daemonize = FALSE;
+	int opt, rc = -1;
 
 	usbip_use_stderr = 1;
 	usbip_use_syslog = 0;
 
 	if (geteuid() != 0)
-		g_warning("running non-root?");
+		err("not running as root?");
 
+	cmd = cmd_standalone_mode;
 	for (;;) {
-		int c;
-		int index = 0;
+		opt = getopt_long(argc, argv, "Ddhv", longopts, NULL);
 
-		c = getopt_long(argc, argv, "vhdD", longopts, &index);
-
-		if (c == -1)
+		if (opt == -1)
 			break;
 
-		switch (c) {
-			case 'd':
-				usbip_use_debug = 1;
-				continue;
-			case 'v':
-				cmd = cmd_version;
-				break;
-			case 'h':
-				cmd = cmd_help;
-				break;
-			case 'D':
-				daemonize = TRUE;
-				break;
-			case '?':
-				show_help();
-				exit(EXIT_FAILURE);
-			default:
-				err("getopt");
-		}
-	}
-
-	switch (cmd) {
-		case cmd_standalone_mode:
-			do_standalone_mode(daemonize);
+		switch (opt) {
+		case 'D':
+			daemonize = TRUE;
+			break;
+		case 'd':
+			usbip_use_debug = 1;
 			break;
-		case cmd_version:
-			printf("%s\n", version);
+		case 'h':
+			cmd = cmd_help;
 			break;
-		case cmd_help:
-			show_help();
+		case 'v':
+			cmd = cmd_version;
 			break;
+		case '?':
+			usbipd_help();
 		default:
-			info("unknown cmd");
-			show_help();
+			goto err_out;
+		}
 	}
 
-	return 0;
+	switch (cmd) {
+	case cmd_standalone_mode:
+		rc = do_standalone_mode(daemonize);
+		break;
+	case cmd_version:
+		printf(PROGNAME " (%s)\n", usbip_version_string);
+		rc = 0;
+		break;
+	case cmd_help:
+		usbipd_help();
+		rc = 0;
+		break;
+	default:
+		usbipd_help();
+		goto err_out;
+	}
+
+err_out:
+	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
 }
-- 
1.7.5.2

