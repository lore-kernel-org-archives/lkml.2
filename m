Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485Ab2FUVkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:40:11 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46814
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760443Ab2FUVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:40:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 10/13] Tools: hv: Gather ipv[4,6] gateway information
Date: Thu, 21 Jun 2012 14:31:42 -0700
Message-Id: <1340314305-27126-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect ipv4 and ipv6 gateway information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   80 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 101ab7f..68a4cc1 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -490,16 +490,40 @@ done:
 	return;
 }
 
+static void kvp_process_ipconfig_file(char *config_file,
+					char *config_buf, int len,
+					int element_size, int offset)
+{
+	char buf[256];
+	char *p;
+	char *x;
+	FILE *file;
+
+	file = fopen(config_file, "r");
+	if (file == NULL)
+		return;
+
+	if (offset == 0)
+		memset(config_buf, 0, len);
+	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
+		if ((len - strlen(config_buf)) < (element_size + 1))
+			break;
+
+		x = strchr(p, '\n');
+		*x = '\0';
+		strcat(config_buf, p);
+		strcat(config_buf, ";");
+	}
+	fclose(file);
+
+}
+
 static void kvp_get_ipconfig_info(char *if_name,
 				 struct hv_kvp_ipaddr_value *buffer)
 {
 	char cmd[512];
 	char *dns_config = "/var/opt/hyperv/.kvp_dns_cfg";
-	FILE *file;
-	char buf[256];
-	char *dns_buf;
-	char *p;
-	char *x;
+	char *gw_config = "/var/opt/hyperv/.kvp_gw_cfg";
 
 	memset(cmd, 0, 512);
 	strcat(cmd, "cat /etc/resolv.conf 2>/tmp/null | ");
@@ -508,29 +532,43 @@ static void kvp_get_ipconfig_info(char *if_name,
 
 	/*
 	 * Execute the command to gather dns info.
+	 * Note that all buffers are arrays of __u16.
 	 */
 	system(cmd);
-	file = fopen(dns_config, "r");
-	if (file == NULL)
-		return;
+	kvp_process_ipconfig_file(dns_config, (char *)buffer->dns_addr,
+				(MAX_IP_ADDR_SIZE * 2), INET6_ADDRSTRLEN, 0);
 
-	dns_buf = (char *)(buffer->dns_addr);
 	/*
-	 * The buffer is an array of __u16 elements.
+	 * Get the address of default gateway (ipv4).
 	 */
-	memset(dns_buf, 0, (MAX_IP_ADDR_SIZE * 2));
-	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
-		if (((MAX_IP_ADDR_SIZE * 2) - strlen(dns_buf)) <
-				(INET6_ADDRSTRLEN + 1))
-			break;
+	memset(cmd, 0, 512);
+	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
+	strcat(cmd, if_name);
+	strcat(cmd, " | awk '/default/ {print $3 }' > ");
+	strcat(cmd, "/var/opt/hyperv/.kvp_gw_cfg");
 
-		x = strchr(p, '\n');
-		*x = '\0';
-		strcat(dns_buf, p);
-		strcat(dns_buf, ";");
-	}
-	fclose(file);
+	/*
+	 * Execute the command to gather gateway info.
+	 */
+	system(cmd);
+	kvp_process_ipconfig_file(gw_config, (char *)buffer->gate_way,
+				(MAX_GATEWAY_SIZE * 2), INET_ADDRSTRLEN, 0);
+	/*
+	 * Get the address of default gateway (ipv6).
+	 */
+	memset(cmd, 0, 512);
+	strcat(cmd, "/sbin/ip -f inet6  route | grep -w ");
+	strcat(cmd, if_name);
+	strcat(cmd, " | awk '/default/ {print $3 }' > ");
+	strcat(cmd, "/var/opt/hyperv/.kvp_gw_cfg");
 
+	/*
+	 * Execute the command to gather gateway info (ipv6).
+	 */
+	system(cmd);
+	kvp_process_ipconfig_file(gw_config, (char *)buffer->gate_way,
+				(MAX_GATEWAY_SIZE * 2), INET6_ADDRSTRLEN,
+				strlen(gw_config));
 }
 
 
-- 
1.7.4.1

