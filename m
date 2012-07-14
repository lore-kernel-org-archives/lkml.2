Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2GNUUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:20:47 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51147
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752013Ab2GNUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:19:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 10/15] Tools: hv: Gather ipv[4,6] gateway information
Date: Sat, 14 Jul 2012 13:34:15 -0700
Message-Id: <1342298060-12662-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gather information on the default gateways - ipv4/ipv6.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index b9da130..b7a2df0 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -490,6 +490,72 @@ done:
 	return;
 }
 
+static void kvp_process_ipconfig_file(char *cmd,
+					char *config_buf, int len,
+					int element_size, int offset)
+{
+	char buf[256];
+	char *p;
+	char *x;
+	FILE *file;
+
+	/*
+	 * First execute the command.
+	 */
+	file = popen(cmd, "r");
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
+	pclose(file);
+}
+
+static void kvp_get_ipconfig_info(char *if_name,
+				 struct hv_kvp_ipaddr_value *buffer)
+{
+	char cmd[512];
+
+	/*
+	 * Get the address of default gateway (ipv4).
+	 */
+	memset(cmd, 0, 512);
+	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
+	strcat(cmd, if_name);
+	strcat(cmd, " | awk '/default/ {print $3 }'");
+
+	/*
+	 * Execute the command to gather gateway info.
+	 */
+	kvp_process_ipconfig_file(cmd, (char *)buffer->gate_way,
+				(MAX_GATEWAY_SIZE * 2), INET_ADDRSTRLEN, 0);
+
+	/*
+	 * Get the address of default gateway (ipv6).
+	 */
+	memset(cmd, 0, 512);
+	strcat(cmd, "/sbin/ip -f inet6  route | grep -w ");
+	strcat(cmd, if_name);
+	strcat(cmd, " | awk '/default/ {print $3 }'");
+
+	/*
+	 * Execute the command to gather gateway info (ipv6).
+	 */
+	kvp_process_ipconfig_file(cmd, (char *)buffer->gate_way,
+				(MAX_GATEWAY_SIZE * 2), INET6_ADDRSTRLEN, 1);
+
+}
+
+
 static unsigned int hweight32(unsigned int *w)
 {
 	unsigned int res = *w - ((*w >> 1) & 0x55555555);
@@ -648,6 +714,12 @@ kvp_get_ip_address(int family, char *if_name, int op,
 				strcat((char *)ip_buffer->sub_net, ";");
 				sn_offset += strlen(sn_str) + 1;
 			}
+
+			/*
+			 * Collect other ip related configuration info.
+			 */
+
+			kvp_get_ipconfig_info(if_name, ip_buffer);
 		}
 
 gather_ipaddr:
-- 
1.7.4.1

