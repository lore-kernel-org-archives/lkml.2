Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2GXPrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:47:12 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39818
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755558Ab2GXPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:46:37 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org,
        ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 09/17] Tools: hv: Represent the ipv6 mask using CIDR notation
Date: Tue, 24 Jul 2012 09:01:33 -0700
Message-Id: <1343145701-3691-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1343145701-3691-1-git-send-email-kys@microsoft.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transform ipv6 subnet information to CIDR notation.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 2c24ebf..007e698 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -491,6 +491,15 @@ done:
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
@@ -535,10 +544,15 @@ kvp_get_ip_address(int family, char *if_name, int op,
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
@@ -612,17 +626,28 @@ kvp_get_ip_address(int family, char *if_name, int op,
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

