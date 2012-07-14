Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2GNUpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:45:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42284
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752905Ab2GNUoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:44:38 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 09/15] Tools: hv: Represent the ipv6 mask using CIDR notation
Date: Sat, 14 Jul 2012 13:34:14 -0700
Message-Id: <1342298060-12662-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transfor ipv6 subnet information to CIDR notation.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 07f6f7c..b9da130 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -490,6 +490,15 @@ done:
 	return;
 }
 
+static unsigned int hweight32(unsigned int *w)
+{
+	unsigned int res = *w - ((*w >> 1) & 0x55555555);
+	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
+	res = (res + (res >> 4)) & 0x0F0F0F0F;
+	res = res + (res >> 8);
+	return (res + (res >> 16)) & 0x000000FF;
+}
+
 static int kvp_process_ip_address(void *addrp,
 				int family, char *buffer,
 				int length,  int *offset)
@@ -534,10 +543,15 @@ kvp_get_ip_address(int family, char *if_name, int op,
 	struct ifaddrs *curp;
 	int offset = 0;
 	int sn_offset = 0;
-	const char *str;
 	int error = 0;
 	char *buffer;
 	struct hv_kvp_ipaddr_value *ip_buffer;
+	char cidr_mask[5]; /* /xyz */
+	int weight;
+	int i;
+	unsigned int *w;
+	char *sn_str;
+	struct sockaddr_in6 *addr6;
 
 	if (op == KVP_OP_ENUMERATE) {
 		buffer = out_buffer;
@@ -611,17 +625,28 @@ kvp_get_ip_address(int family, char *if_name, int op,
 			} else {
 				ip_buffer->addr_family |= ADDR_FAMILY_IPV6;
 				/*
-				 * Get subnet info.
+				 * Get subnet info in CIDR format.
 				 */
-				error = kvp_process_ip_address(
-							curp->ifa_netmask,
-							AF_INET6,
-							(char *)
-							ip_buffer->sub_net,
-							length,
-							&sn_offset);
-				if (error)
+				weight = 0;
+				sn_str = (char *)ip_buffer->sub_net;
+				addr6 = (struct sockaddr_in6 *)
+					curp->ifa_netmask;
+				w = addr6->sin6_addr.s6_addr32;
+
+				for (i = 0; i < 4; i++)
+					weight += hweight32(&w[i]);
+
+				sprintf(cidr_mask, "/%d", weight);
+				if ((length - sn_offset) <
+					(strlen(cidr_mask) + 1))
 					goto gather_ipaddr;
+
+				if (sn_offset == 0)
+					strcpy(sn_str, cidr_mask);
+				else
+					strcat(sn_str, cidr_mask);
+				strcat((char *)ip_buffer->sub_net, ";");
+				sn_offset += strlen(sn_str) + 1;
 			}
 		}
 
-- 
1.7.4.1

