Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab2FUVlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:41:14 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46816
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760444Ab2FUVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:40:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 04/13] Tools: hv: Prepare to expand  kvp_get_ip_address() functionality
Date: Thu, 21 Jun 2012 14:31:36 -0700
Message-Id: <1340314305-27126-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvp_get_ip_address() implemented the functionality to retrieve IP address info.
Make this function more generic so that we could retrieve additional
per-interface information.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |  129 ++++++++++++++++++++++++++++++----------------
 1 files changed, 84 insertions(+), 45 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 4831997..4fa6f95 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -491,7 +491,8 @@ done:
 }
 
 static int
-kvp_get_ip_address(int family, char *buffer, int length)
+kvp_get_ip_address(int family, char *if_name, int op,
+		 void  *out_buffer, int length)
 {
 	struct ifaddrs *ifap;
 	struct ifaddrs *curp;
@@ -501,10 +502,19 @@ kvp_get_ip_address(int family, char *buffer, int length)
 	const char *str;
 	char tmp[50];
 	int error = 0;
-
+	char *buffer;
+	struct hv_kvp_ipaddr_value *ip_buffer;
+
+	if (op == KVP_OP_ENUMERATE) {
+		buffer = out_buffer;
+	} else {
+		ip_buffer = out_buffer;
+		buffer = (char *)ip_buffer->ip_addr;
+		ip_buffer->addr_family = 0;
+	}
 	/*
 	 * On entry into this function, the buffer is capable of holding the
-	 * maximum key value (2048 bytes).
+	 * maximum key value.
 	 */
 
 	if (getifaddrs(&ifap)) {
@@ -514,58 +524,87 @@ kvp_get_ip_address(int family, char *buffer, int length)
 
 	curp = ifap;
 	while (curp != NULL) {
-		if ((curp->ifa_addr != NULL) &&
-		   (curp->ifa_addr->sa_family == family)) {
-			if (family == AF_INET) {
-				struct sockaddr_in *addr =
-				(struct sockaddr_in *) curp->ifa_addr;
-
-				str = inet_ntop(family, &addr->sin_addr,
-						tmp, 50);
-				if (str == NULL) {
-					strcpy(buffer, "inet_ntop failed\n");
-					error = 1;
-					goto getaddr_done;
-				}
-				if (offset == 0)
-					strcpy(buffer, tmp);
-				else
-					strcat(buffer, tmp);
-				strcat(buffer, ";");
+		if (curp->ifa_addr == NULL) {
+			curp = curp->ifa_next;
+			continue;
+		}
 
-				offset += strlen(str) + 1;
-				if ((length - offset) < (ipv4_len + 1))
-					goto getaddr_done;
+		if ((if_name != NULL) &&
+			(strncmp(curp->ifa_name, if_name, strlen(if_name)))) {
+			/*
+			 * We want info about a specific interface;
+			 * just continue.
+			 */
+			curp = curp->ifa_next;
+			continue;
+		}
 
-			} else {
+		/*
+		 * We only support two address families: AF_INET and AF_INET6.
+		 * If a family value of 0 is specified, we collect both
+		 * supported address families; if not we gather info on
+		 * the specified address family.
+		 */
+		if ((family != 0) && (curp->ifa_addr->sa_family != family)) {
+			curp = curp->ifa_next;
+			continue;
+		}
+		if ((curp->ifa_addr->sa_family != AF_INET) &&
+			(curp->ifa_addr->sa_family != AF_INET6)) {
+			curp = curp->ifa_next;
+			continue;
+		}
+
+		if ((curp->ifa_addr->sa_family == AF_INET) &&
+			((family == AF_INET) || (family == 0))) {
+			struct sockaddr_in *addr =
+			(struct sockaddr_in *) curp->ifa_addr;
+
+			str = inet_ntop(AF_INET, &addr->sin_addr, tmp, 50);
+			if (str == NULL) {
+				strcpy(buffer, "inet_ntop failed\n");
+				error = 1;
+				goto getaddr_done;
+			}
+			if (offset == 0)
+				strcpy(buffer, tmp);
+			else
+				strcat(buffer, tmp);
+			strcat(buffer, ";");
+
+			offset += strlen(str) + 1;
+			if ((length - offset) < (ipv4_len + 1))
+				goto getaddr_done;
+
+		} else if ((family == AF_INET6) || (family == 0)) {
 
 			/*
 			 * We only support AF_INET and AF_INET6
 			 * and the list of addresses is separated by a ";".
 			 */
-				struct sockaddr_in6 *addr =
+			struct sockaddr_in6 *addr =
 				(struct sockaddr_in6 *) curp->ifa_addr;
 
-				str = inet_ntop(family,
+			str = inet_ntop(AF_INET6,
 					&addr->sin6_addr.s6_addr,
 					tmp, 50);
-				if (str == NULL) {
-					strcpy(buffer, "inet_ntop failed\n");
-					error = 1;
-					goto getaddr_done;
-				}
-				if (offset == 0)
-					strcpy(buffer, tmp);
-				else
-					strcat(buffer, tmp);
-				strcat(buffer, ";");
-				offset += strlen(str) + 1;
-				if ((length - offset) < (ipv6_len + 1))
-					goto getaddr_done;
-
+			if (str == NULL) {
+				strcpy(buffer, "inet_ntop failed\n");
+				error = 1;
+				goto getaddr_done;
 			}
+			if (offset == 0)
+				strcpy(buffer, tmp);
+			else
+				strcat(buffer, tmp);
+			strcat(buffer, ";");
+			offset += strlen(str) + 1;
+			if ((length - offset) < (ipv6_len + 1))
+				goto getaddr_done;
 
 		}
+
+
 		curp = curp->ifa_next;
 	}
 
@@ -812,13 +851,13 @@ int main(void)
 			strcpy(key_value, lic_version);
 			break;
 		case NetworkAddressIPv4:
-			kvp_get_ip_address(AF_INET, key_value,
-					HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
+			kvp_get_ip_address(AF_INET, NULL, KVP_OP_ENUMERATE,
+				key_value, HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
 			strcpy(key_name, "NetworkAddressIPv4");
 			break;
 		case NetworkAddressIPv6:
-			kvp_get_ip_address(AF_INET6, key_value,
-					HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
+			kvp_get_ip_address(AF_INET6, NULL, KVP_OP_ENUMERATE,
+				key_value, HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
 			strcpy(key_name, "NetworkAddressIPv6");
 			break;
 		case OSBuildNumber:
-- 
1.7.4.1

