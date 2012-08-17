Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2HQA3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:29:11 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42570
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932571Ab2HQA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:28:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 06/14] Tools: hv: Represent the ipv6 mask using CIDR notation
Date: Thu, 16 Aug 2012 17:45:17 -0700
Message-Id: <1345164325-5198-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345164325-5198-1-git-send-email-kys@microsoft.com>
References: <1345164300-5146-1-git-send-email-kys@microsoft.com>
 <1345164325-5198-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/hv/hv_kvp_daemon.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index de1724c..a63e83a 100644
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
@@ -611,18 +625,30 @@ kvp_get_ip_address(int family, char *if_name, int op,
 					goto gather_ipaddr;
 			} else {
 				ip_buffer->addr_family |= ADDR_FAMILY_IPV6;
+
 				/*
-				 * Get subnet info.
+				 * Get subnet info in CIDR format.
 				 */
-				error = kvp_process_ip_address(
-							     curp->ifa_netmask,
-							     AF_INET6,
-							     (char *)
-							     ip_buffer->sub_net,
-							     length,
-							     &sn_offset);
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

