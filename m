Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2GXQR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:17:57 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:44558
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755785Ab2GXQRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:17:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org,
        ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 08/17] Tools: hv: Gather subnet information
Date: Tue, 24 Jul 2012 09:01:32 -0700
Message-Id: <1343145701-3691-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1343145701-3691-1-git-send-email-kys@microsoft.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now gather sub-net information for the specified interface.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 79eb130..2c24ebf 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -534,6 +534,7 @@ kvp_get_ip_address(int family, char *if_name, int op,
 	struct ifaddrs *ifap;
 	struct ifaddrs *curp;
 	int offset = 0;
+	int sn_offset = 0;
 	const char *str;
 	int error = 0;
 	char *buffer;
@@ -594,12 +595,38 @@ kvp_get_ip_address(int family, char *if_name, int op,
 			 * Gather info other than the IP address.
 			 * IP address info will be gathered later.
 			 */
-			if (curp->ifa_addr->sa_family == AF_INET)
+			if (curp->ifa_addr->sa_family == AF_INET) {
 				ip_buffer->addr_family |= ADDR_FAMILY_IPV4;
-			else
+				/*
+				 * Get subnet info.
+				 */
+				error = kvp_process_ip_address(
+							curp->ifa_netmask,
+							AF_INET,
+							(char *)
+							ip_buffer->sub_net,
+							length,
+							&sn_offset);
+				if (error)
+					goto gather_ipaddr;
+			} else {
 				ip_buffer->addr_family |= ADDR_FAMILY_IPV6;
+				/*
+				 * Get subnet info.
+				 */
+				error = kvp_process_ip_address(
+							curp->ifa_netmask,
+							AF_INET6,
+							(char *)
+							ip_buffer->sub_net,
+							length,
+							&sn_offset);
+				if (error)
+					goto gather_ipaddr;
+			}
 		}
 
+gather_ipaddr:
 		error = kvp_process_ip_address(curp->ifa_addr,
 						curp->ifa_addr->sa_family,
 						buffer,
-- 
1.7.4.1

