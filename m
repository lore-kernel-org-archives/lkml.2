Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2FUVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:25:29 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40808
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760423Ab2FUVZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:25:27 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 05/13] Tools: hv: Further refactor kvp_get_ip_address()
Date: Thu, 21 Jun 2012 14:31:37 -0700
Message-Id: <1340314305-27126-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for making kvp_get_ip_address() more generic, factor out
the code for handling IP addresses.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   94 ++++++++++++++++++++-------------------------
 1 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 4fa6f95..2235855 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -490,17 +490,50 @@ done:
 	return;
 }
 
+static int kvp_process_ip_address(void *addrp,
+				int family, char *buffer,
+				int length,  int *offset)
+{
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+	int addr_length;
+	char tmp[50];
+	const char *str;
+
+	if (family == AF_INET) {
+		addr = (struct sockaddr_in *)addrp;
+		str = inet_ntop(family, &addr->sin_addr, tmp, 50);
+		addr_length = INET_ADDRSTRLEN;
+	} else {
+		addr6 = (struct sockaddr_in6 *)addrp;
+		str = inet_ntop(family, &addr6->sin6_addr.s6_addr, tmp, 50);
+		addr_length = INET6_ADDRSTRLEN;
+	}
+
+	if ((length - *offset) < addr_length + 1)
+		return 1;
+	if (str == NULL) {
+		strcpy(buffer, "inet_ntop failed\n");
+		return 1;
+	}
+	if (*offset == 0)
+		strcpy(buffer, tmp);
+	else
+		strcat(buffer, tmp);
+	strcat(buffer, ";");
+
+	*offset += strlen(str) + 1;
+	return 0;
+}
+
 static int
 kvp_get_ip_address(int family, char *if_name, int op,
 		 void  *out_buffer, int length)
 {
 	struct ifaddrs *ifap;
 	struct ifaddrs *curp;
-	int ipv4_len = strlen("255.255.255.255") + 1;
-	int ipv6_len = strlen("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff")+1;
 	int offset = 0;
 	const char *str;
-	char tmp[50];
 	int error = 0;
 	char *buffer;
 	struct hv_kvp_ipaddr_value *ip_buffer;
@@ -555,55 +588,12 @@ kvp_get_ip_address(int family, char *if_name, int op,
 			continue;
 		}
 
-		if ((curp->ifa_addr->sa_family == AF_INET) &&
-			((family == AF_INET) || (family == 0))) {
-			struct sockaddr_in *addr =
-			(struct sockaddr_in *) curp->ifa_addr;
-
-			str = inet_ntop(AF_INET, &addr->sin_addr, tmp, 50);
-			if (str == NULL) {
-				strcpy(buffer, "inet_ntop failed\n");
-				error = 1;
-				goto getaddr_done;
-			}
-			if (offset == 0)
-				strcpy(buffer, tmp);
-			else
-				strcat(buffer, tmp);
-			strcat(buffer, ";");
-
-			offset += strlen(str) + 1;
-			if ((length - offset) < (ipv4_len + 1))
-				goto getaddr_done;
-
-		} else if ((family == AF_INET6) || (family == 0)) {
-
-			/*
-			 * We only support AF_INET and AF_INET6
-			 * and the list of addresses is separated by a ";".
-			 */
-			struct sockaddr_in6 *addr =
-				(struct sockaddr_in6 *) curp->ifa_addr;
-
-			str = inet_ntop(AF_INET6,
-					&addr->sin6_addr.s6_addr,
-					tmp, 50);
-			if (str == NULL) {
-				strcpy(buffer, "inet_ntop failed\n");
-				error = 1;
-				goto getaddr_done;
-			}
-			if (offset == 0)
-				strcpy(buffer, tmp);
-			else
-				strcat(buffer, tmp);
-			strcat(buffer, ";");
-			offset += strlen(str) + 1;
-			if ((length - offset) < (ipv6_len + 1))
-				goto getaddr_done;
-
-		}
-
+		error = kvp_process_ip_address(curp->ifa_addr,
+						curp->ifa_addr->sa_family,
+						buffer,
+						length, &offset);
+		if (error)
+			goto getaddr_done;
 
 		curp = curp->ifa_next;
 	}
-- 
1.7.4.1

