Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468Ab2FUVkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:40:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44027
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760442Ab2FUVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:40:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 07/13] Tools: hv: Gather subnet information
Date: Thu, 21 Jun 2012 14:31:39 -0700
Message-Id: <1340314305-27126-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
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
index b5db1b5..2160462 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -533,6 +533,7 @@ kvp_get_ip_address(int family, char *if_name, int op,
 	struct ifaddrs *ifap;
 	struct ifaddrs *curp;
 	int offset = 0;
+	int sn_offset = 0;
 	const char *str;
 	int error = 0;
 	char *buffer;
@@ -593,12 +594,38 @@ kvp_get_ip_address(int family, char *if_name, int op,
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

